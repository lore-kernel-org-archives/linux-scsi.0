From: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Subject: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: 24 Jul 2003 15:36:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1059057411.6798.30.camel@carwash.duncangibb.com>
References: <20030724151233.E9280@laokoon.bug.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [217.169.3.180] ([217.169.3.180]:56773 "EHLO
	carwash.duncangibb.com") by vger.kernel.org with ESMTP
	id S271455AbTGXOVq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 10:21:46 -0400
In-Reply-To: <20030724151233.E9280@laokoon.bug.net>
List-Id: linux-scsi@vger.kernel.org
To: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Cc: linux-scsi@vger.kernel.org

On Thu, 2003-07-24 at 14:12, Thomas Beutin wrote:

TB> I have big problems with my secend an third hard disk
TB> on a Adaptec AIC-7902 U320 sitting on an intel
TB> SE7501HG2 board.

I'm not sure I can help you, but I can certainly tell you you're not
alone.  I have very similar problems with the on-board AIC7902 on my
SuperMicro X5DA8 board.  This uses the 7505 chipset rather than the
7501, but AFAIK, both are i810-derivatives from Linux's point of view.

Just before I read your post, I built a 2.4.21-bk17 kernel in the hope
that this would have been fixed some time in the last couple of months. 
I'm not really in to running experimental kernels, so usually I won't
stray further than the -ac series.


TB> The first disk is an IBM IC35L036UCPR15-0 (Rev: S70H)
TB> and runs fine.

In my case /proc/scsi/scsi reads:

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: COMPAQ   Model: ST32171W         Rev: 0388
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 02 Lun: 00
  Vendor: EPSON SC Model: ANNER GT-6500    Rev: 1.23
  Type:   Processor                        ANSI SCSI revision: 01
Host: scsi1 Channel: 00 Id: 03 Lun: 00
  Vendor: YAMAHA   Model: CRW2100S         Rev: 1.0H
  Type:   CD-ROM                           ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: MPL      Model: MC-DISK-D-1S[0]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 01
  Vendor: MPL      Model: MC-DISK-D-1S[0]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 02
  Vendor: MPL      Model: MC-DISK-D-1S[1]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 03
  Vendor: MPL      Model: MC-DISK-D-1S[1]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 04
  Vendor: MPL      Model: MC-DISK-D-1S[1]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 05
  Vendor: MPL      Model: MC-DISK-D-1S[1]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 06
  Vendor: MPL      Model: MC-DISK-D-1S[0]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 07
  Vendor: MPL      Model: MC-DISK-D-1S[0]  Rev: 3.3
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: SONY     Model: DVD RW DRU-500A  Rev: 2.0c
  Type:   CD-ROM                           ANSI SCSI revision: 02


The "Compaq" (ie Seagate) disk is the system swap disk, and it must be
working fine or the whole machine would hang (I presume).

Also I think the MPL device (which is a PC-card/CompactFlash reader)
should have only two LUNs, since that's how many slots it has... 
"scsi2" is ide-scsi.


TB> The system is'nt comletly hanging, it seems a file
TB> system access in an already open shell freezes the
TB> shell, while doing other stuff is ok.

If I try to scan something, Xsane hangs for a while, then recovers OK. 
But if I put a CD in the Yamaha drive, anything which touches the scsi
subsystem from then on will hang.

Here's what's in /var/log/messages:

-- Xsane-scan-recover------------------------------------------

scsi1:0:2:0: Attempting to abort cmd f7be0800: 0x8 0x0 0x0 0x2 0x78 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x1ae Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x31] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Jul 24 14:07:51 localhost kernel:
SCB Count = 5 CMDS_PENDING = 1 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0
qinstart = 9041 qinfifonext = 9042
QINFIFO: 0x4
WAITING_TID_QUEUES:
Pending list:
Jul 24 14:07:51 localhost kernel:   4 FIFO_USE[0x0] SCB_CONTROL[0x48]
SCB_SCSIID[0x27]
Jul 24 14:07:51 localhost kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x40]
SCB_SCSIID[0x37]
Total 2
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Jul 24 14:07:51 localhost kernel:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi1: FIFO1 Free, LONGJMP == 0x81ec, SCB 0x4
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi1: REG0 == 0x4, SINDEX = 0x133, DINDEX = 0x108
scsi1: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffdb
CDB 43 0 0 0 0 0
STACK: 0xe2 0x0 0x0 0x0 0x0 0x0 0x0 0x29
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
scsi1:0:2:0: Cmd aborted from QINFIFO

-- 69-second pause at this point

scsi1:0:2:0: Attempting to abort cmd f7be0800: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x1ae Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x31] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Jul 24 14:08:01 localhost kernel:
SCB Count = 5 CMDS_PENDING = 1 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0
qinstart = 9041 qinfifonext = 9042
QINFIFO: 0x4
WAITING_TID_QUEUES:
Pending list:
Jul 24 14:08:01 localhost kernel:   4 FIFO_USE[0x0] SCB_CONTROL[0x48]
SCB_SCSIID[0x27]
Jul 24 14:08:01 localhost kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x40]
SCB_SCSIID[0x37]
Total 2
Kernel Free SCB list: 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Jul 24 14:08:01 localhost kernel:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi1: FIFO1 Free, LONGJMP == 0x81ec, SCB 0x4
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi1: REG0 == 0x4, SINDEX = 0x133, DINDEX = 0x108
scsi1: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffdb
CDB 43 0 0 0 0 0
STACK: 0xe2 0x0 0x0 0x0 0x0 0x0 0x0 0x29
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
scsi1:0:2:0: Cmd aborted from QINFIFO
scsi1:0:3:0: Attempting to abort cmd f7be0c00: 0x43 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0xc 0x40
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x1ae Mode 0x33
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x31] SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
SEQINTCTL[0x0] SEQ_FLAGS[0x40] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0]
SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Jul 24 14:08:02 localhost kernel:
SCB Count = 5 CMDS_PENDING = 1 LASTSCB 0x3 CURRSCB 0x3 NEXTSCB 0x0
qinstart = 9041 qinfifonext = 9041
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Jul 24 14:08:02 localhost kernel:   3 FIFO_USE[0x0] SCB_CONTROL[0x40]
SCB_SCSIID[0x37]
Total 1
Kernel Free SCB list: 4 2 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Jul 24 14:08:02 localhost kernel:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi1: FIFO1 Free, LONGJMP == 0x81ec, SCB 0x4
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi1: REG0 == 0x4, SINDEX = 0x133, DINDEX = 0x108
scsi1: SCBPTR == 0x3, SCB_NEXT == 0xffc0, SCB_NEXT2 == 0xffdb
CDB 43 0 0 0 0 0
STACK: 0xe2 0x0 0x0 0x0 0x0 0x0 0x0 0x29
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
scsi1:0:3:0: Unable to deliver message
Recovery code sleeping

-- four-second pause

Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery code sleeping

-- five-second pause

Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery SCB completes

-- Xsane-scan-recover------------------------------------------



-- Insert-CD-ROM-and-hang-system-------------------------------

scsi1:0:3:0: Attempting to abort cmd f7be0c00: 0x28 0x0 0x0 0x0 0x0 0x10
0x0 0x0 0x1 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x2c Mode 0x22
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x31] SCSISIGI[0x48] SCSIPHASE[0x0] SCSIBUS[0x88]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
SEQINTCTL[0x0] SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Jul 24 14:19:15 localhost kernel:
SCB Count = 5 CMDS_PENDING = 1 LASTSCB 0x2 CURRSCB 0x2 NEXTSCB 0x0
qinstart = 18960 qinfifonext = 18960
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Jul 24 14:19:15 localhost kernel:   2 FIFO_USE[0x0] SCB_CONTROL[0x44]
SCB_SCSIID[0x37]
Total 1
Kernel Free SCB list: 3 4 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Jul 24 14:19:15 localhost kernel:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi1: FIFO1 Free, LONGJMP == 0x80ec, SCB 0x2
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi1: REG0 == 0x2, SINDEX = 0x122, DINDEX = 0x1c0
scsi1: SCBPTR == 0xff02, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 2 1 0 0 0 0
STACK: 0x15 0x0 0x0 0x0 0x0 0x0 0x0 0x29
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 1 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
(scsi1:A:3:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi1:A:3:0): Abort Message Sent

-- five-second pause

Recovery code awake
Timer Expired
scsi1:0:3:0: Attempting to abort cmd f7be0e00: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:3:0: Command found on device queue

-- ten-second pause

scsi1:0:3:0: Attempting to abort cmd f7be0e00: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:3:0: Command found on device queue
Recovery code sleeping

-- five-second pause

Recovery code awake
Timer Expired
scsi1: Device reset returning 0x2003
Recovery SCB completes
Recovery SCB completes

-- 42-second pause

scsi1:0:3:0: Attempting to abort cmd f7be0c00: 0x28 0x0 0x0 0x0 0x0 0x10
0x0 0x0 0x1 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State at program address 0x94 Mode 0x0
Card was paused
HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
DFFSTAT[0x31] SCSISIGI[0x48] SCSIPHASE[0x0] SCSIBUS[0x88]
LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
SEQINTCTL[0x80] SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x0] SSTAT0[0x0]
SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0]
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]
Jul 24 14:20:17 localhost kernel:
SCB Count = 5 CMDS_PENDING = 1 LASTSCB 0x2 CURRSCB 0x2 NEXTSCB 0x0
qinstart = 20221 qinfifonext = 20221
QINFIFO:
WAITING_TID_QUEUES:
Pending list:
Jul 24 14:20:17 localhost kernel:   2 FIFO_USE[0x0] SCB_CONTROL[0x44]
SCB_SCSIID[0x37]
Total 1
Kernel Free SCB list: 3 4 1 0
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Jul 24 14:20:17 localhost kernel:
scsi1: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
scsi1: FIFO1 Free, LONGJMP == 0x80ec, SCB 0x2
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi1: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x42
scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
SIMODE0[0xc]
CCSCBCTL[0x4]
scsi1: REG0 == 0x27a5, SINDEX = 0x111, DINDEX = 0x1c0
scsi1: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 0 0 0 0 0 0
STACK: 0x26 0x14 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
DevQ(0:2:0): 0 waiting
DevQ(0:3:0): 0 waiting
DevQ(0:6:0): 0 waiting
DevQ(0:6:1): 0 waiting
DevQ(0:6:2): 0 waiting
DevQ(0:6:3): 0 waiting
DevQ(0:6:4): 0 waiting
DevQ(0:6:5): 0 waiting
DevQ(0:6:6): 0 waiting
DevQ(0:6:7): 0 waiting
(scsi1:A:3:0): Device is disconnected, re-queuing SCB
Recovery code sleeping
(scsi1:A:3:0): Abort Message Sent

-- four-second pause

Recovery code awake
Timer Expired
scsi: device set offline - not ready or command retry failed after bus
reset: host 1 channel 0 id 3 lun 0

-- ten-second pause

scsi1:0:3:0: Attempting to abort cmd f7be0e00: 0x0 0x0 0x0 0x0 0x0 0x0
scsi1:0:3:0: Command found on device queue
scsi: device set offline - not ready or command retry failed after bus
reset: host 1 channel 0 id 3 lun 0
 I/O error: dev 0b:00, sector 64
isofs_read_super: bread failed, dev=0b:00, iso_blknum=16, block=16
cdrom: open failed.

-- Insert-CD-ROM-and-hang-system-------------------------------


So, the common factors seem to be that we both have Xeon SMP systems
with Intel 750x (i810-like) chipsets, and both find that the
lowest-numbered (0,0,0) SCSI disk works fine, but using other devices
hangs all future attempts to talk to SCSI devices (other than the one
that works OK).


Thanks in advance to anyone who's been patient enough to read all this
and help us.


Cheers


Duncan



