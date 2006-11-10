From: Michael Stone <mstone@mathom.us>
Subject: aic79xx dumping card state
Date: Thu, 09 Nov 2006 19:45:09 -0500
Message-ID: <20061110004508.GF2667@mathom.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms044pub.verizon.net ([206.46.252.44]:20526 "EHLO
	vms044pub.verizon.net") by vger.kernel.org with ESMTP
	id S965695AbWKJApN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Nov 2006 19:45:13 -0500
Received: from osgiliath.mathom.us ([71.246.251.8])
 by vms044.mailsrvcs.net (Sun Java System Messaging Server 6.2-6.01 (built Apr
 3 2006)) with ESMTPA id <0J8H001GOORCHJH4@vms044.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Thu, 09 Nov 2006 18:45:12 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
	by osgiliath.mathom.us (Postfix) with ESMTP id 4512170621	for
 <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2006 19:45:11 -0500 (EST)
Received: from osgiliath.mathom.us ([127.0.0.1])
	by localhost (osgiliath.home.mathom.us [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 5e-o0MmGPI1A for <linux-scsi@vger.kernel.org>; Thu,
 09 Nov 2006 19:45:10 -0500 (EST)
Content-disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

How to debug? Kernel is 2.6.18.1, I think the other details are in the 
dmesg output:

ACPI: PCI Interrupt 0000:01:06.0[A] -> GSI 16 (level, low) -> IRQ 21
scsi2 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 39320A Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs

  Vendor: SC U320/  Model: SATA16R           Rev: R0.0
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target2:0:0: asynchronous
scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
 target2:0:0: Beginning Domain Validation
 target2:0:0: wide asynchronous
 target2:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU RTI WRFLOW PCOMP (6.25 ns, offset 127)
 target2:0:0: Ending Domain Validation
SCSI device sdb: 4095967232 1024-byte hdwr sectors (4194270 MB)
sdb: Write Protect is off
sdb: Mode Sense: cd 00 00 08
SCSI device sdb: drive cache: write back
SCSI device sdb: 4095967232 1024-byte hdwr sectors (4194270 MB)
sdb: Write Protect is off
sdb: Mode Sense: cd 00 00 08
SCSI device sdb: drive cache: write back
 sdb: unknown partition table
sd 2:0:0:0: Attached scsi disk sdb


At this point I try to dd from /dev/sdb, don't get very far before:

sd 2:0:0:0: Attempting to queue an ABORT message:CDB: 0x28 0x0 0x0 0x0 0x28 0x70
 0x0 0x1 0x0 0x0
scsi2: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi2: Dumping Card State at program address 0x3b Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11] 
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
SCSISIGI[0x24]:(P_DATAOUT_DT|BSYI) SCSIPHASE[0x0] 
SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x40]:(ENSELO) SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x4]:(SELECTOUT_QFROZEN) 
QFREEZE_COUNT[0x0] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x10]:(SELINGO) 
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED) 
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x40] 

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
qinstart = 90 qinfifonext = 90
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x3 )
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
Total 1
Kernel Free SCB list: 2 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi2: FIFO0 Free, LONGJMP == 0x8271, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEP
TRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 

scsi2: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEP
TRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x8 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x
0 0x0 
scsi2: LQISTATE = 0x1, LQOSTATE = 0x1a, OPTIONMODE = 0x52
scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi2: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi2: REG0 == 0x3, SINDEX = 0x102, DINDEX = 0x102
scsi2: SCBPTR == 0xff03, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 3 1 0 0 0 0
STACK: 0x24 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi2:0:0:0: Cmd aborted from QINFIFO
sd 2:0:0:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 
0x0 0x0
scsi2: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi2: Dumping Card State at program address 0x3b Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80]:(SWTMINTMASK) SEQINTSTAT[0x0] SAVED_MODE[0x11] 
DFFSTAT[0x33]:(CURRFIFO_NONE|FIFO0FREE|FIFO1FREE) 
SCSISIGI[0x24]:(P_DATAOUT_DT|BSYI) SCSIPHASE[0x0] 
SCSIBUS[0x0] LASTPHASE[0x1]:(P_DATAOUT|P_BUSFREE) 
SCSISEQ0[0x40]:(ENSELO) SCSISEQ1[0x12]:(ENAUTOATNP|ENRSELI) 
SEQCTL0[0x0] SEQINTCTL[0x0] SEQ_FLAGS[0x0] 
SEQ_FLAGS2[0x4]:(SELECTOUT_QFROZEN) 
QFREEZE_COUNT[0x0] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x10]:(SELINGO) 
SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x0] 
SIMODE1[0xac]:(ENSCSIPERR|ENBUSFREE|ENSCSIRST|ENSELTIMO) 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]:(PACKETIZED) 
LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x40] 

SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
qinstart = 90 qinfifonext = 91
QINFIFO: 0x3
WAITING_TID_QUEUES:
Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) SCB_SCSIID[0x7] 
Total 1
Kernel Free SCB list: 2 1 0 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi2: FIFO0 Free, LONGJMP == 0x8271, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEP
TRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 

scsi2: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
SEQIMODE[0x3f]:(ENCFG4TCMD|ENCFG4ICMD|ENCFG4TSTAT|ENCFG4ISTAT|ENCFG4DATA|ENSAVEP
TRS) 
SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL) 
SG_CACHE_SHADOW[0x2]:(LAST_SEG) SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5]:(FIFOFREE|DLZERO) SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]:(SG_CACHE_AVAIL) 
LQIN: 0x8 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
0x0 0x0 0x
0 0x0 
scsi2: LQISTATE = 0x1, LQOSTATE = 0x1a, OPTIONMODE = 0x52
scsi2: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi2: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0

SIMODE0[0xc]:(ENOVERRUN|ENIOERR) 
CCSCBCTL[0x4]:(CCSCBDIR) 
scsi2: REG0 == 0x3, SINDEX = 0x102, DINDEX = 0x102
scsi2: SCBPTR == 0xff03, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
CDB 3 1 0 0 0 0
STACK: 0x24 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi2:0:0:0: Cmd aborted from QINFIFO
sd 2:0:0:0: Attempting to queue a TARGET RESET message:CDB: 0x28 0x0 0x0 
0x0 0x2
8 0x70 0x0 0x1 0x0 0x0
scsi2: Device reset code sleeping
scsi2: Device reset timer expired (active 1)
scsi2: Device reset returning 0x2003
Recovery SCB completes
sd 2:0:0:0: scsi: Device offlined - not ready after error recovery
sd 2:0:0:0: SCSI error: return code = 0x00020000
end_request: I/O error, dev sdb, sector 20704
Buffer I/O error on device sdb, logical block 2588
Buffer I/O error on device sdb, logical block 2589
Buffer I/O error on device sdb, logical block 2590
Buffer I/O error on device sdb, logical block 2591
Buffer I/O error on device sdb, logical block 2592
Buffer I/O error on device sdb, logical block 2593
Buffer I/O error on device sdb, logical block 2594
sd 2:0:0:0: rejecting I/O to offline device
Buffer I/O error on device sdb, logical block 2588
Buffer I/O error on device sdb, logical block 2595
Buffer I/O error on device sdb, logical block 2596

 
