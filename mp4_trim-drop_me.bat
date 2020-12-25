@echo off
setlocal enabledelayedexpansion
set FFMPEG=ffmpeg.exe
WHERE /q %FFMPEG%
IF %ERRORLEVEL% NEQ 0 (
	set FFMPEG="%~dp0%FFMPEG%"
	IF NOT EXIST !FFMPEG! powershell -Command Start-BitsTransfer -Source "https://raw.githubusercontent.com/youcantgetme/ffmpeg-batch/master/ffmpeg.exe" -Destination !FFMPEG!
)
:reinput
set /p begin="Enter begin time with hh:mm:ss (eg 01:05:20): "
set /p end="Enter end time with hh:mm:ss (eg 02:11:01): "
echo Cut from %begin% to %end% 
set INPUT=r
echo Yes/No/Retry (y/n/r)
set /P INPUT=(y/n/r): %=%

IF "%INPUT%"=="y" GOTO yes
IF "%INPUT%"=="n" GOTO no
IF "%INPUT%"=="Y" GOTO yes
IF "%INPUT%"=="N" GOTO no
IF "%INPUT%"=="r" GOTO reinput
IF "%INPUT%"=="R" GOTO reinput

:yes
FOR %%a IN (%*) DO %FFMPEG% -ss %begin% -i %%a -to %end% -c copy -avoid_negative_ts make_zero -copyts -f mp4 "%%~dpna_trim_result.mp4"
pause

:no

