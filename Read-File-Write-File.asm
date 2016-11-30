TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc
.data

userMessage BYTE "Please enter the absolute path: ", 0
openErrorMessage BYTE "Error: cannot open file.", 0dh, 0ah, 0
readErrorMessage BYTE "Error: cannot read file.", 0dh, 0ah, 0
createErrorMessage BYTE "Error: cannot create file.", 0dh, 0ah, 0
successMessageRead BYTE " Reads...", 0dh, 0ah, 0
doneMessage BYTE "Done...", 0dh, 0ah, 0
counter DD 1;

filename BYTE 50 DUP(0)
newFile BYTE "C:\Users\Tebin\Desktop\mynewfile4.txt", 0

bytesRead DD 500

openReadHandle DWORD 100 
createWriteHandle DWORD 100

openBuffer BYTE 101 DUP(0)
bufferSize DD 50

readStr    DB    50 DUP(0)

.code 
main PROC
	call Clrscr

	mov edx, offset userMessage
	call writeString
	mov ecx, 49
	call ReadString ;num of characters go into eax ;result goes into edx
	
	;mov edx, offset filename
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Open;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	call OpenInputFile
	mov openReadHandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	jne noError
	mov edx, offset openErrorMessage
	call writeString

	noError equ $
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Create;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	mov edx, offset newFile
	call createOutputFile
	mov createWriteHandle, eax
	cmp eax, INVALID_HANDLE_VALUE
	jne noCreateError
	mov edx, offset createErrorMessage
	call writeString

	noCreateError equ $

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Read;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
	
	L1:
		mov eax, openReadHandle
		mov edx, offset openBuffer ;buffer
		mov ecx, bufferSize ;buffer size
		call readFromFile
		mov bytesRead, eax
		jnc  noReadError

		mov edx, offset readErrorMessage
		call writeString

		noReadError equ $
		
		call writeInt

		mov eax, counter
		add counter, 1
		call writeint
		mov edx, offset successMessageRead
		call writeString
		

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;Write;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
		mov eax, createWriteHandle
		mov edx, offset openBuffer
		mov ecx, bytesRead
		call writeToFile
		
		cmp eax, 50
		jl lessout

		jmp L1

		



	lessout:
		mov edx, offset doneMessage
		call writeString
		call closeFile
	
	
	lea eax, readStr
	mov ecx,1
	call ReadChar ;pause screen
	


	exit

main ENDP






END main