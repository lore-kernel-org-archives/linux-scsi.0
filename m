From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: HD somtimes hanging
Date: Thu, 24 Jul 2003 15:12:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724151233.E9280@laokoon.bug.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:4001 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S263952AbTGXNAB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 09:00:01 -0400
Received: from hirsch.in-berlin.de (localhost [127.0.0.1])
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with ESMTP id h6ODF8ch007136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jul 2003 15:15:08 +0200
Received: (from uucp@localhost)
	by hirsch.in-berlin.de (8.12.9/8.12.9/Debian-1) with UUCP id h6ODF8kJ007130
	for linux-scsi@vger.kernel.org; Thu, 24 Jul 2003 15:15:08 +0200
Received: (from tyrone@localhost)
	by laokoon.bug.net (8.9.3/8.9.3) id PAA05771
	for linux-scsi@vger.kernel.org; Thu, 24 Jul 2003 15:12:33 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

sorry, if this question is already answered, but i cannot find
a searchable mailing list archiv. In this case it would be nice
if You can give me a pointer to the answers.

I have big problems with my secend an third hard disk on a
Adaptec AIC-7902 U320 sitting on an intel SE7501HG2 board.
The disks are SCA disks FUJITSU  Model: MAP3367NC Rev: 0105
plugged into a hot swap back plane SCA HSBP M15 (Vendor
is ESG-SHV).
The first disk is an IBM IC35L036UCPR15-0 (Rev: S70H) and
runs fine.
When i try to access one of this FUJITSU disks, the system
hangs a couple of minutes and after that my dmesg command
ouput is full of "Dump Card State" (see below).
After a while the system (vanilla linux SMP kernel 2.4.21
running on a slackware 9.0) comes back to normal operation.
The system is'nt comletly hanging, it seems a file system
access in an already open shell freezes the shell, while
doing other stuff is ok.
Have You any idea what's going on? Is the backplane kidding
me (i've never bevor worked with an intelligent
SCSI-ID-consuming backplane)? I've found the fact, that the
disks are a short time available after a cold reboot (no
power in the machine at all), but later (2..3 hours) the
problems appeares again.

I've put some output and messages below. If You need more,
please let me know.

Any help or links to explanations welcome!

Thanks,
-tb

# cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: IC35L036UCPR15-0 Rev: S70H
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: ESG-SHV  Model: SCA HSBP M15     Rev: 0.10
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi0 Channel: 00 Id: 02 Lun: 00
  Vendor: FUJITSU  Model: MAP3367NC        Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: TEAC     Model: CD-552E          Rev: T016
  Type:   CD-ROM                           ANSI SCSI revision: 02

# uname -a
Linux stulle 2.4.21 #2 SMP Mon Jun 30 12:46:15 CEST 2003 i686 unknown

# lsmod 
Module                  Size  Used by    Not tainted
raid1                  14412   1 
md                     60640   1  [raid1]
uhci                   27248   0  (unused)
usbcore                66240   1  [uhci]
i810_rng                2820   0  (unused)
reiserfs              185264   1 
floppy                 51548   0 
serial                 49028   0  (unused)
rtc                     7612   0  (unused)
ide-scsi               10544   0 
e1000                  54464   1 


------ BEGIN dmesg snip ------
DevQ(0:0:0): 0 waiting
DevQ(0:1:0): 0 waiting
DevQ(0:2:0): 0 waiting
DevQ(0:6:0): 0 waiting
scsi0:0:2:0: Cmd aborted from QINFIFO
scsi0:0:2:0: Attempting to abort cmd f14af000
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0xb Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] 
DFFSTAT[0x11] SCSISIGI[0x74] SCSIPHASE[0x0] SCSIBUS[0x0] 
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10] 
SEQINTCTL[0x0] SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x0] SSTAT0[0x0] 
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80] 
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81] 

SCB Count = 64 CMDS_PENDING = 2 LASTSCB 0x3e CURRSCB 0x3e NEXTSCB 0xff00
qinstart = 53881 qinfifonext = 53881
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
 17 SCB_CONTROL[0x60] SCB_SCSIID[0x27] SCB_TAG[0x11] 
 42 SCB_CONTROL[0x60] SCB_SCSIID[0x27] SCB_TAG[0x2a] 
Total 2
Kernel Free SCB list: 62 48 1 3 50 38 22 4 63 55 5 53 49 30 58 28 15 14 19 26 33 10 35 6 46 23 59 24 43 45 16 25 29 8 51 32 41 2 56 44 7 54 13 9 27 34 39 37 21 57 11 40 18 20 47 31 52 36 12 0 61 60 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 

scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0, LJSCB 0xff00
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x0] 
scsi0: FIFO1 Active, LONGJMP == 0x247, SCB 0x2a, LJSCB 0x2a
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x1] 
SG_CACHE_SHADOW[0x50] SG_STATE[0x3] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x02d693c00, SHCNT = 0x400 
HADDR = 0x02d693c00, HCNT = 0x400 CCSGCTL[0x10] 
LQIN: 0x4 0x0 0x0 0x2a 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0xf4 0x0 0x0 0x0 0x2 0x0 
scsi0: LQISTATE = 0x29, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x3e, SINDEX = 0x133, DINDEX = 0x106
scsi0: SCBPTR == 0x3e, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xffe1
CDB 0 0 0 0 0 0
STACK: 0x120 0x120 0x0 0x247 0x247 0x235 0x2e 0x1
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
------ END dmesg snip ------
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
