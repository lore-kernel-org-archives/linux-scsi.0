From: ishikawa@yk.rim.or.jp
Subject: Ungraceful handling of scsi tape drive error condition
Date: Sat, 20 Jul 2002 03:53:39 +0900 (JST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <m17Vcsl-000HcIC@standard.erephon>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: by yk.rim.or.jp
	via sendmail from stdin
	id <m17Vcsl-000HcIC@standard.erephon> (Debian Smail3.2.0.114)
	for linux-scsi@vger.kernel.org; Sat, 20 Jul 2002 03:53:39 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kai.Makisara@metla.fi, dc390@garloff.de, garloff@suse


Hi,

I would like to report a problem of ungraceful handling of
tape device error by SCSI subsystem and
DC390 (tmscsim) driver.

I am not sure exactly where the problem lies, and so
send to various e-mail addresses.

(To be honest, I am not sure if the software
can cope with the situation at all, but
here it goes anyway.)

Background:

I have an HP DDS2 DAT tape drive.

The external drive is connected  to my linux PC
using Tekram DC390 scsi adaptor. (I have
a separate active terminator block and 
more or less good SCSI cable. The combination worked flawlessly
previously and since I tested out the connection
carefully before I began using this, I am more or less
confident that the cabling and terminator is not the problem.)
This DAT drive was used to make backup archive of various files.
This worked fine under 2.4.16 (and 2.4.17, I think.)
SCSI tape support is used as module: st.o

This week, I tried to make another backup copy of
many files I have brought from external source.

Then I have encountered a problem.
The tar program got hung in the middle of
operation. 

I thought OK, maybe a drive proble, but then I
was surprised to find that I could not even kill
the tar process. "kill -KILL pid" won't remove it
from the ps output.
It seems that it got stuck inside the
write system call.

I suspect the cause of the problem is drive-related.  (Maybe a dirty
head or something causing the drive to respond very slowly or even
triggered a firmware problme or something.)

While I will go out and buy a cleaning tape to remedy the
supposedly dirty head, I am reporting this
so that we can improve the error handling in SCSI subsystem.
That is, it would be nice
if we can make sure that the tar program 
can be killed by interrut (control-C), etc. even
in the presence of lower-level physical problem.

I agree that if the drive behaves in a very strange manner
due to temporary hardware problem, there may be
few options to deal with it, but I still would like
to be able to kill a program that accesses that drive.
This is because I could not even try to remove the st (scsi tape)
driver module to see if the older st.c from older
kernel might work, etc..
Since tar was holding the /dev/st0, I could not remove the
st module. Also, if I recall correctly,
trying to rewind the tape was refused since the
device was in use, etc.. (But I may be confused about this.)

Again, I am reporting this so that
someone may notice that there are places
where SCSI error handlings can be improved, specifically
for tape drives. I will try to solve the physical problem
by firstly trying head cleaing tape on my end.

By the way, I do think the drive is at fault. (Not the
cable, etc.)  I have an HP tape
library utility (a Windows program made by HP and downloadable from
HP's web site) to test and diagnose problems of HP DAT drives.
The drive passes all the self-diagnotics and the like
that didn't touch the recording medium. The test includes
the SCSI connection to/from the tape drive.
The diagnostics that looked at internal log buffer of the drive
did suggest maybe I need to clean the tape head(!).
Then by invoking media validation test of HP program,
I found that my DAT drive in current condition 
has a difficulty in reading/writing the
tape medium. 
(It did write without problems only a couple of days ago, though.) 
Hence, my current suspcition is the dirty read/write head.  


REPEAT-BY:

The sequence of operation that led to the problem of hung "tar" which
is not killable at all is explained below.
(Actually, I tried various combinations of
OS versions (2.4.18, 2.4.17), max transfer speed (10MB/s, 8MB/s,
6.6MB/s, etc.)
set in DC390 BIOS (and honoured by the tmscsim driver),
and the problem surfaced after a while during the copying of
large tar file. So I am more or less certain that the
problem is caused by the device physical error.)

    insmod st
    mt -f /dev/st0 datcompression
    tar cvXbf exclude-file-list 20 /dev/st0 MANY-DIRECTORIES-AND-FILES

Luckily I got a few messages from the syslog file which may be
relevant (and listed below), but unfortunately I didn't notice this
while I was dealing with the malfunctioning drive and so my
explanation may be a little out of sync with what truely happened.

Anyway, here is the log with my explanation.
I believe the following was recorded while I booted
2.4.17 kernel. 

LOG and the sequence of event.

****  "insmod st" was executed from my backup script.

Jul 18 23:49:20 duron kernel: st: Version 20011103, bufsize 32768, wrt 30720, max init. bufs 4, s/g segs 16
Jul 18 23:49:20 duron kernel: Attached scsi tape st0 at scsi1, channel 0, id 3, lun 0
Jul 18 23:49:20 duron kernel: DC390: Target 3: Sync transfer 10.0 MHz, Offset 15
Jul 18 23:49:20 duron kernel: st0: Block limits 1 - 16777215 bytes.

**** After mt -f /dev/st0 datcompression
**** tar began execution.

    ... tar began writing to /dev/st0 
    ... But at some point, the drive seemed to encountered an error,
    ... maybe due to a dirty head, which requires cleaning.
    ... 
    ... Instead of gracefully handling the situation caused by
    ... the timeout of the drive,
    ... the tar program got hung.
    ... DC390 drive (tmscsim driver)  printed out diagnostics in a
    ... neat manner.

Jul 19 00:14:17 duron kernel: scsi : aborting command due to timeout : pid 54817, scsi1, channel 0, id 3, lun 0 Write (6) 00 00 28 00 00 
Jul 19 00:14:17 duron kernel: DC390: Abort command (pid 54817, Device 03-00)
Jul 19 00:14:17 duron kernel: DC390: SRB: Xferred 00000000, Remain 00000000, State 00000080, Phase 04
Jul 19 00:14:17 duron kernel: DC390: AdpaterStatus: 00, SRB Status 00
Jul 19 00:14:17 duron kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 0890cc20
Jul 19 00:14:17 duron kernel: DC390: Register dump: SCSI block:
Jul 19 00:14:17 duron kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 Ctl2 Ctl3 Ctl4
Jul 19 00:14:17 duron kernel: DC390:  000000   44   10   cc   00   80   17   48   18   04
Jul 19 00:14:17 duron kernel: DC390: Register dump: DMA engine:
Jul 19 00:14:17 duron kernel: DC390: Cmd   STrCnt    SBusA    WrkBC    WrkAC Stat SBusCtrl
Jul 19 00:14:17 duron kernel: DC390:  00 00002800 002f8000 00000000 002fa800   00 03080000
Jul 19 00:14:17 duron kernel: DC390: Register dump: PCI Status: 0200
Jul 19 00:14:17 duron kernel: DC390: In case of driver trouble read linux/drivers/scsi/README.tmscsim
Jul 19 00:14:17 duron kernel: DC390: Aborted pid 54817 with status 0


    ... I was doing something else and didn't realize the hung tar
    ... program until I checked the terminal window about 15 minutes later.
    ... I now noticed the problem and tried to kill the tar process by
    ... control-C, etc..
    ... However, I found that the tar program could not be killed!
    ... While my doing this, the system seemed to record another set of
    ... messages. Maybe due to my forceful removal of the tape medium, etc..

Jul 19 00:29:23 duron kernel: scsi : aborting command due to timeout : pid 54817, scsi1, channel 0, id 3, lun 0 Write (6) 00 00 28 00 00 
Jul 19 00:29:23 duron kernel: DC390: Abort command (pid 54817, Device 03-00)
Jul 19 00:29:23 duron kernel: DC390: SRB: Xferred 00000000, Remain 00000000, State 00000080, Phase 04
Jul 19 00:29:23 duron kernel: DC390: AdpaterStatus: 00, SRB Status 00
Jul 19 00:29:23 duron kernel: DC390: Status of last IRQ (DMA/SC/Int/IRQ): 0890cc20
Jul 19 00:29:23 duron kernel: DC390: Register dump: SCSI block:
Jul 19 00:29:23 duron kernel: DC390: XferCnt  Cmd Stat IntS IRQS FFIS Ctl1 Ctl2 Ctl3 Ctl4
Jul 19 00:29:23 duron kernel: DC390:  000000   44   10   cc   00   80   17   48   18   04
Jul 19 00:29:23 duron kernel: DC390: Register dump: DMA engine:
Jul 19 00:29:23 duron kernel: DC390: Cmd   STrCnt    SBusA    WrkBC    WrkAC Stat SBusCtrl
Jul 19 00:29:23 duron kernel: DC390:  00 00002800 002f8000 00000000 002fa800   00 03080000
Jul 19 00:29:23 duron kernel: DC390: Register dump: PCI Status: 0200
Jul 19 00:29:23 duron kernel: DC390: In case of driver trouble read linux/drivers/scsi/README.tmscsim
Jul 19 00:29:23 duron kernel: DC390: Aborted pid 54817 with status 0
Jul 19 00:29:23 duron kernel: SCSI host 1 abort (pid 54817) timed out - resetting
Jul 19 00:29:23 duron kernel: SCSI bus is being reset for host 1 channel 0.
Jul 19 00:29:23 duron kernel: DC390: RESET ... done
Jul 19 00:29:23 duron kernel: st0: Error 26030000 (sugg. bt 0x20, driver bt 0x6, host bt 0x3).
Jul 19 00:29:23 duron kernel: DC390: Target 3: Sync transfer 10.0 MHz, Offset 15
Jul 19 00:29:23 duron kernel: SCSI error: host 1 id 3 lun 0 return code = 28000002
Jul 19 00:29:23 duron kernel: ^ISense class 7, sense error 0, extended sense 0



PS: I don't know if there is a timeout value which could be
    enlarged to accommodate this particular error of HP drive, but
    I think the drive requires servicing as explained above. So
    even a much larger value won't help. 
    What worries me, though is this.
    I am wondering why the error condition reported by DC390 (tmscsim)
    driver is not noticed by the upper layer of SCSI system
    so that the write system call returned an error and we could kill the tar
    program that called it. That would be a more graceful handling
    of the situation IMHO.
    

cf. 
>From README.st

I noticed this excellent file only after I wrote the above
to look for the maintainer address.
 
>To enable debugging messages, edit st.c and #define DEBUG 1. As seen
>above, debugging can be switched off with an ioctl if debugging is
>compiled into the driver. The debugging output is not voluminuous.

I will try to do this after I buy the cleaning tape.

>If the tape seems to hang, I would be very interested to hear where
>the driver is waiting. With the command 'ps -l' you can see the state
>of the process using the tape. If the state is D, the process is
>waiting for something. The field WCHAN tells where the driver is
>waiting. If you have the current System.map in the correct place (in
>/boot for the procps I use) or have updated /etc/psdatabase (for kmem
>ps), ps writes the function name in the WCHAN field. If not, you have
>to look up the function from System.map.
>

I am sorry that the above log was collected using
2.4.17 kenrel while the main OS I use is nowadays 2.4.18 kernel.
I think the System.map was incorrect. Actually I hit ALT+SysReq+t
to see where the tar program got hung during the trials and errors,
(but to my dismay, I didn't see the output immediately on
the console. I was running X. Then later on, while I wrote the
above memo, I notice the call trace was in the syslog file!)



>From my own log: I didn't realize the output from Alt+SysReq+t is
directed to syslog, etc.. 
I am not sure if the symbols are correct due to the version mismatch
above.

	...

>Jul 19 00:26:03 duron kernel: bash          S 00000000  2656   406    405   409               (NOTLB)
>Jul 19 00:26:03 duron kernel: Call Trace: [sys_wait4+862/912] [system_call+51/56] 
>Jul 19 00:26:03 duron kernel: tar           D D961E000  5000   409    406                     (NOTLB)
>Jul 19 00:26:03 duron kernel: Call Trace: [wait_for_completion+114/144] [ide-cd:ignore+37481379/72914909] [ide-cd:ignore+37485815/72910473] [file_read_actor+0/96] [sys_write+150/208] 
>Jul 19 00:26:03 duron kernel:    [system_call+51/56] 

        ...


if the drive still behaves in a funny manner after
applying cleaning tape,
I will try to gather the information above.

Oh, for that matter, if the information is really
important, I will try to gather the data WITHOUT
applying the cleaning tape. That is I will try to
see if I can coerce the misbehaving DAT tape drive
into accepting tar output even for a few seconds and
then when tar gets hung, I can try Alt+SysReq+t.

Please advise me if necessary.

>Note also that the timeouts are very long compared to most other
>drivers. This means that the Linux driver may appear hung although the
>real reason is that the tape firmware has got confused.

It seems like the case since the drive now operates
in a rather funny manner even under windows 98 when it is tested
using HP's excellent diagnostics tool.
