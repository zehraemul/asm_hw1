datasg SEGMENT PARA 'data'
n		DW 10 ; n'e deger verdim
datasg ENDS
stacksg SEGMENT PARA STACK 'yigin'
	DW 300 DUP(?)  ; stackte n icin yer ayirdim
stacksg ENDS
my_codes		SEGMENT PARA 'kod'
ASSUME CS:my_codes, DS:datasg


DNUM    PROC FAR
		PUSH BP
		PUSH CX
		MOV BP, SP
		MOV CX, [BP+8]
		CMP CX, 0
		JNE div1 
		MOV WORD PTR [BP+8], 0
		POP CX
		POP BP
		RETF
div1:	CMP CX, 1
		JNE div4
		MOV WORD PTR [BP+8], 1
		POP CX
		POP BP
		RETF
div4:	CMP CX, 2
		JNE div2
		MOV WORD PTR [BP+8], 1
		POP CX
		POP BP
		RETF
div2:	PUSH DX
		PUSH AX
		MOV DX, CX  ;DX =N
		DEC DX  ;N-1
		PUSH DX 
		CALL DNUM ; D(n-1)
		CALL DNUM ; D(D(N-1))
		POP AX
		PUSH AX
		PUSH CX
		SUB CX, 2 ;N-2
		PUSH CX
		CALL DNUM ;D(N-2)
		POP AX
		POP CX 
		DEC CX  
		SUB CX, AX
		PUSH CX
		CALL DNUM ; D(n-1-D(n-2))
		POP DX
		POP AX
		ADD AX,DX   ;
		MOV [BP+8], AX 
		POP AX
		POP DX
		POP CX
		POP BP
		RETF
DNUM ENDP
my_codes		ENDS
codesg SEGMENT PARA 'kodd'
ASSUME CS:codesg, SS:stacksg, DS:datasg

PRINTINT	PROC NEAR 
		PUSH BX
		PUSH BP
		PUSH DX
		MOV BP, SP
		MOV AX, [BP+8]
		MOV BX, 1
		PUSH BX
		XOR DX, DX 
		MOV BX, 0Ah
div3:	DIV BX
		ADD DX, '0'
		PUSH DX
		XOR DX, DX
		CMP AX, 0
		JNZ div3
printdiv:	POP AX
		CMP AX, 1
		JZ end1
		MOV DL, AL
		MOV AH, 2
		INT 21h
		JMP printdiv
end1:	POP DX
		POP BP
		POP BX
		RET 2
PRINTINT	ENDP

MAIN PROC FAR  ;  tum kodlar exe tipinde olan yazilmasi zorunlu kodlar.
		PUSH DS
		XOR AX, AX
		PUSH AX
		MOV AX, datasg
		MOV DS, AX ; exe tipi zorunlu kodlarin sonu
		
		MOV AX, n
		PUSH AX
		CALL DNUM ; dnum fonksiyonunu cagirdim.
		CALL PRINTINT ; yazdirmak icin printint fonksiyonunu cagirdim.
		RETF
MAIN ENDP
codesg ENDS
END MAIN

