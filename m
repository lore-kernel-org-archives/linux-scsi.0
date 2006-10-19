From: Sean Bruno <sean.bruno@dsl-only.net>
Subject: Re: Adaptec 29320 [aic79xx] fails on power cycle of LUN
Date: Thu, 19 Oct 2006 05:25:30 -0700
Message-ID: <1161260730.3204.36.camel@home-desk>
References: <1161210246.3204.17.camel@home-desk>
	 <1161210748.3204.22.camel@home-desk>  <1161237121.15090.9.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iron2.pdx.net ([69.64.224.71]:48312 "EHLO iron2.pdx.net")
	by vger.kernel.org with ESMTP id S1423335AbWJSMZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Oct 2006 08:25:31 -0400
In-Reply-To: <1161237121.15090.9.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 2006-10-19 at 01:52 -0400, Mike Christie wrote:
> On Wed, 2006-10-18 at 15:32 -0700, Sean Bruno wrote:
> > On Wed, 2006-10-18 at 15:24 -0700, Sean Bruno wrote:
> > > I have had a tough time tracking this one down, however I can say for
> > > certain that the 29320 is really having trouble if a LUN is power
> > > cycled.
> > > 
> > > I don't have access to a BUS analyzer right now, but here is my
> > > regression.
> > > 
> > > 1.  Hook an external SCSI array/disk to a 29320.
> > > 2.  Power up SCSI array/disk
> > > 3.  Power up PC with 29320.
> > > 4.  When PC has booted, login and test device by creating a file
> > >     system, eg. mkfs /dev/sda (or whatever disk the array is called on
> > >     ur machine).
> > > 5.  Power cycle array/disk
> > > 6.  Retest device with another 'mkfs /dev/sda' ... panic/crash/lock-up
> > > ensues.
> > > 
> > > 
> > > 
> > > This did not happen in 2.6.15.7 but did appear in 2.6.16 and higher.
> > > 

> Does this only occur with sg or is that the only way you got a trace? In
> the original bug report you mentioned it occurring with mkfs, but the
> bug oops is from a sg request. Is tdg_2 run while the mkfs is running?

Snippets from 'dmesg' during step 6:

scsi0: Someone reset channel A
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
0x0 0x80 0x0 0x0 0x80 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11321
QINFIFO: 0x0 0x2
WAITING_TID_QUEUES:
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
  0 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 2
Kernel Free SCB list: 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0
0x0 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11321
QINFIFO: 0x2 0x0
WAITING_TID_QUEUES:
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 2
Kernel Free SCB list: 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0
0x0 0x0 0x0 0x0 0x80 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11320
QINFIFO: 0x2
WAITING_TID_QUEUES:
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 1
Kernel Free SCB list: 0 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0
0x0 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11320
QINFIFO: 0x2
WAITING_TID_QUEUES:
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 1
Kernel Free SCB list: 0 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: Attempting to queue a TARGET RESET message:CDB: 0x28 0x0 0x0
0x0 0x0 0x80 0x0 0x0 0x80 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
scsi0: bus reset still active
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0
0x0 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11321
QINFIFO: 0x2 0x0
WAITING_TID_QUEUES:
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 2
Kernel Free SCB list: 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0
0x0 0x0
Infinite interrupt loop, INTSTAT = 8scsi0: At time of recovery, card was
paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x13 Mode 0x33
Card was paused
INTSTAT[0x8] SELOID[0x4] SELID[0x40] HS_MAILBOX[0x0]
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
SCSISIGI[0x0] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
SCSISEQ0[0x0] SCSISEQ1[0x2] SEQCTL0[0x0] SEQINTCTL[0x0]
SEQ_FLAGS[0xc0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x9]
KERNEL_QFREEZE_COUNT[0x9] MK_MESSAGE_SCB[0x0] MK_MESSAGE_SCSIID[0x47]
SSTAT0[0x0] SSTAT1[0x28] SSTAT2[0x0] SSTAT3[0x0]
PERRDIAG[0xc0] SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0]
LQISTAT2[0x0] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x0]

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x0 NEXTSCB 0x0
qinstart = 11319 qinfifonext = 11321
QINFIFO: 0x2 0x0
WAITING_TID_QUEUES:
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
  2 FIFO_USE[0x0] SCB_CONTROL[0x68] SCB_SCSIID[0x47]
Total 2
Kernel Free SCB list: 1 3
Sequencer Complete DMA-inprog list:
Sequencer Complete list:
Sequencer DMA-Up and Complete list:
Sequencer On QFreeze and Complete list:


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi0: FIFO1 Free, LONGJMP == 0x81f1, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
0x0 0x0 0x0 0x0
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc]
CCSCBCTL[0x0]
scsi0: REG0 == 0xffff, SINDEX = 0x1e0, DINDEX = 0xe1
scsi0: SCBPTR == 0x0, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff57
CDB 2a 0 0 80 9 e0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:4:0: Cmd aborted from QINFIFO
sd 0:0:4:0: scsi: Device offlined - not ready after error recovery
sd 0:0:4:0: scsi: Device offlined - not ready after error recovery
sd 0:0:4:0: SCSI error: return code = 0x00050000
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 128
Buffer I/O error on device sda, logical block 129
Buffer I/O error on device sda, logical block 130
Buffer I/O error on device sda, logical block 131
Buffer I/O error on device sda, logical block 132
Buffer I/O error on device sda, logical block 133
Buffer I/O error on device sda, logical block 134
Buffer I/O error on device sda, logical block 135
Buffer I/O error on device sda, logical block 136
Buffer I/O error on device sda, logical block 137
sd 0:0:4:0: SCSI error: return code = 0x00050000
end_request: I/O error, dev sda, sector 0
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device
sd 0:0:4:0: rejecting I/O to offline device


Sean

