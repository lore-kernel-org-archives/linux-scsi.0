From: Ingo Flaschberger <if@xip.at>
Subject: scsi troubles - controller or hdd?
Date: Mon, 28 Nov 2005 10:25:49 +0100 (CET)
Message-ID: <Pine.GSO.4.64.0511280958070.16249@filebunker.xip.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.xip.at ([193.239.188.99]:17540 "EHLO chile.gbit.at")
	by vger.kernel.org with ESMTP id S1750754AbVK1JtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Nov 2005 04:49:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

I have troubles with a not full supported
Adaptec AIC-7902 U320 w/HostRAID (rev 03) (no hostraid support).

I'm doing now software raid and have spurious scsi bus resets when high 
load is at the discs. Currently the machines runs at only 1 disk, but the 
problems happens with 2 or with 1 disk.
The disk's are quite old, 3 years.

My question is, are the disks producing the problems or the controller 
itself?
What could I do / change?

System: dual intel xeon
kernel version:  2.4.20-021stab028.18.777-smp

scsi errors below;
boot dmesg below;



scsi errors (long):
---snip---
Nov 24 22:18:45 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1796a00: 0x2a 0x0 0x2 0xb 0xe5 0xab 0x0 0x0 0x8 0x0
Nov 24 22:18:45 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:18:45 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:18:45 server0001 kernel: scsi1: Dumping Card State at program address 0x261 Mode 0x0
Nov 24 22:18:45 server0001 kernel: Card was paused
Nov 24 22:18:45 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:18:45 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:18:45 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:18:45 server0001 kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:18:45 server0001 kernel: SSTAT1[0x19] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:18:45 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:18:45 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:18:45 server0001 kernel:
Nov 24 22:19:40 server0001 kernel: SCB Count = 32 CMDS_PENDING = 5 LASTSCB 0x6 CURRSCB 0x6 NEXTSCB 0xff80
Nov 24 22:19:40 server0001 kernel: qinstart = 29930 qinfifonext = 29930
Nov 24 22:19:40 server0001 kernel: QINFIFO:
Nov 24 22:19:40 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:40 server0001 kernel:        0 ( 0x6 0x16 )
Nov 24 22:19:40 server0001 kernel: Pending list:
Nov 24 22:19:40 server0001 kernel:  22 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:40 server0001 kernel:   6 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:40 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:40 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:40 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:40 server0001 kernel: Total 5
Nov 24 22:19:40 server0001 kernel: Kernel Free SCB list: 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 31 8
Nov 24 22:19:40 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:40 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:40 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:40 server0001 kernel:
Nov 24 22:19:40 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:40 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:40 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:40 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:40 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:40 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:40 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:40 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:40 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:40 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:40 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:40 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:40 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:40 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:40 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:40 server0001 kernel: scsi1: REG0 == 0x1260, SINDEX = 0x100, DINDEX = 0x102
Nov 24 22:19:40 server0001 kernel: scsi1: SCBPTR == 0xa, SCB_NEXT == 0x17, SCB_NEXT2 == 0xf
Nov 24 22:19:40 server0001 kernel: CDB 2a 0 2 80 18 a0
Nov 24 22:19:40 server0001 kernel: STACK: 0x25 0x14 0x125 0x0 0x0 0x25e 0x25e 0x25e
Nov 24 22:19:40 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:40 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:40 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:40 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:40 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1796a00: 0x0 0x0 0x0 0x0 0x0 0x0
Nov 24 22:19:40 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:40 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:40 server0001 kernel: scsi1: Dumping Card State at program address 0x94 Mode 0x11
Nov 24 22:19:40 server0001 kernel: Card was paused
Nov 24 22:19:41 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:41 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:41 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:41 server0001 kernel: SEQINTCTL[0x80] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:41 server0001 kernel: SSTAT1[0x19] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:41 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:41 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:41 server0001 kernel:
Nov 24 22:19:41 server0001 kernel: SCB Count = 32 CMDS_PENDING = 4 LASTSCB 0x16 CURRSCB 0x16 NEXTSCB 0xff80
Nov 24 22:19:41 server0001 kernel: qinstart = 29931 qinfifonext = 29931
Nov 24 22:19:41 server0001 kernel: QINFIFO:
Nov 24 22:19:41 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:41 server0001 kernel:        0 ( 0x16 )
Nov 24 22:19:41 server0001 kernel: Pending list:
Nov 24 22:19:41 server0001 kernel:  22 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel: Total 4
Nov 24 22:19:41 server0001 kernel: Kernel Free SCB list: 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 31 8
Nov 24 22:19:41 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:41 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:41 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:41 server0001 kernel:
Nov 24 22:19:41 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:41 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:41 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:41 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:41 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:41 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:41 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:41 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:41 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:41 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:41 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:41 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:41 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:41 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:41 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:41 server0001 kernel: scsi1: REG0 == 0x60, SINDEX = 0x122, DINDEX = 0x102
Nov 24 22:19:41 server0001 kernel: scsi1: SCBPTR == 0xa, SCB_NEXT == 0x17, SCB_NEXT2 == 0xf
Nov 24 22:19:41 server0001 kernel: CDB 2a 0 2 80 18 a0
Nov 24 22:19:41 server0001 kernel: STACK: 0x29 0x15 0x125 0x0 0x0 0x25e 0x25e 0x25e
Nov 24 22:19:41 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:41 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:41 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:41 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:41 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1796c00: 0x2a 0x0 0x1 0xb4 0xe9 0xc1 0x0 0x0 0x4 0x0
Nov 24 22:19:41 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:41 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:41 server0001 kernel: scsi1: Dumping Card State at program address 0x15 Mode 0x22
Nov 24 22:19:41 server0001 kernel: Card was paused
Nov 24 22:19:41 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:41 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:41 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:41 server0001 kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:41 server0001 kernel: SSTAT1[0x19] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:41 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:41 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:41 server0001 kernel:
Nov 24 22:19:41 server0001 kernel: SCB Count = 32 CMDS_PENDING = 3 LASTSCB 0x16 CURRSCB 0x16 NEXTSCB 0xff80
Nov 24 22:19:41 server0001 kernel: qinstart = 29931 qinfifonext = 29931
Nov 24 22:19:41 server0001 kernel: QINFIFO:
Nov 24 22:19:41 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:41 server0001 kernel: Pending list:
Nov 24 22:19:41 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:41 server0001 kernel: Total 3
Nov 24 22:19:41 server0001 kernel: Kernel Free SCB list: 22 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 318
Nov 24 22:19:41 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:41 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:41 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:41 server0001 kernel:
Nov 24 22:19:41 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:41 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:41 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:41 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:41 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:41 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:41 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:41 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:41 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:41 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:41 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:41 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:41 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:41 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:41 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:41 server0001 kernel: scsi1: REG0 == 0x16, SINDEX = 0x122, DINDEX = 0x102
Nov 24 22:19:41 server0001 kernel: scsi1: SCBPTR == 0xff00, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
Nov 24 22:19:41 server0001 kernel: CDB 0 1 0 0 0 0
Nov 24 22:19:41 server0001 kernel: STACK: 0x125 0x0 0x0 0x25e 0x25e 0x25e 0x29 0x15
Nov 24 22:19:41 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:41 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:41 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:41 server0001 kernel: (scsi1:A:0:0): Device is disconnected, re-queuing SCB
Nov 24 22:19:41 server0001 kernel: Recovery code sleeping
Nov 24 22:19:41 server0001 kernel: Recovery code awake
Nov 24 22:19:41 server0001 kernel: Timer Expired
Nov 24 22:19:41 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1796e00: 0x2a 0x0 0x2 0xb 0xe5 0xa7 0x0 0x0 0x2 0x0
Nov 24 22:19:41 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:41 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:41 server0001 kernel: scsi1: Dumping Card State at program address 0x94 Mode 0x22
Nov 24 22:19:41 server0001 kernel: Card was paused
Nov 24 22:19:41 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:41 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:41 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:41 server0001 kernel: SEQINTCTL[0x80] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:42 server0001 kernel: SSTAT1[0x11] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:42 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:42 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: SCB Count = 32 CMDS_PENDING = 3 LASTSCB 0x17 CURRSCB 0x17 NEXTSCB 0xff80
Nov 24 22:19:42 server0001 kernel: qinstart = 29932 qinfifonext = 29932
Nov 24 22:19:42 server0001 kernel: QINFIFO:
Nov 24 22:19:42 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:42 server0001 kernel:        0 ( 0x17 )
Nov 24 22:19:42 server0001 kernel: Pending list:
Nov 24 22:19:42 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel: Total 3
Nov 24 22:19:42 server0001 kernel: Kernel Free SCB list: 22 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 318
Nov 24 22:19:42 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:42 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:42 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8 
Nov 24 22:19:42 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:42 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:42 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:42 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:42 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:42 server0001 kernel: scsi1: REG0 == 0x17, SINDEX = 0x133, DINDEX = 0x102
Nov 24 22:19:42 server0001 kernel: scsi1: SCBPTR == 0xff00, SCB_NEXT == 0xff00, SCB_NEXT2 == 0x0
Nov 24 22:19:42 server0001 kernel: CDB 0 1 0 0 0 0
Nov 24 22:19:42 server0001 kernel: STACK: 0x1 0x125 0x0 0x0 0x25e 0x25e 0x25e 0x29
Nov 24 22:19:42 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:42 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: Recovery SCB completes
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1796e00: 0x0 0x0 0x0 0x0 0x0 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:42 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:42 server0001 kernel: scsi1: Dumping Card State at program address 0x23 Mode 0x0
Nov 24 22:19:42 server0001 kernel: Card was paused
Nov 24 22:19:42 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:42 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:42 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:42 server0001 kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:42 server0001 kernel: SSTAT1[0x11] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:42 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:42 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: SCB Count = 32 CMDS_PENDING = 3 LASTSCB 0x17 CURRSCB 0x17 NEXTSCB 0xff80
Nov 24 22:19:42 server0001 kernel: qinstart = 29933 qinfifonext = 29933
Nov 24 22:19:42 server0001 kernel: QINFIFO:
Nov 24 22:19:42 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:42 server0001 kernel:        0 ( 0x17 )
Nov 24 22:19:42 server0001 kernel: Pending list:
Nov 24 22:19:42 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel: Total 3
Nov 24 22:19:42 server0001 kernel: Kernel Free SCB list: 22 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 318
Nov 24 22:19:42 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:42 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:42 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:42 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:42 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:42 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:42 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:42 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:42 server0001 kernel: scsi1: REG0 == 0x1260, SINDEX = 0x100, DINDEX = 0x102
Nov 24 22:19:42 server0001 kernel: scsi1: SCBPTR == 0xa, SCB_NEXT == 0x17, SCB_NEXT2 == 0xf
Nov 24 22:19:42 server0001 kernel: CDB 2a 0 2 80 18 a0
Nov 24 22:19:42 server0001 kernel: STACK: 0x14 0x125 0x0 0x0 0x25e 0x25e 0x25e 0x23
Nov 24 22:19:42 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:42 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1797000: 0x2a 0x0 0x1 0xda 0x7 0xef 0x0 0x0 0x2 0x0
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Command not found
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1797000: 0x0 0x0 0x0 0x0 0x0 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:42 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:42 server0001 kernel: scsi1: Dumping Card State at program address 0xb Mode 0x33
Nov 24 22:19:42 server0001 kernel: Card was paused
Nov 24 22:19:42 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:42 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:42 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:42 server0001 kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:42 server0001 kernel: SSTAT1[0x11] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:42 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:42 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: SCB Count = 32 CMDS_PENDING = 3 LASTSCB 0x17 CURRSCB 0x17 NEXTSCB 0xff80
Nov 24 22:19:42 server0001 kernel: qinstart = 29934 qinfifonext = 29934
Nov 24 22:19:42 server0001 kernel: QINFIFO:
Nov 24 22:19:42 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:42 server0001 kernel:        0 ( 0x17 )
Nov 24 22:19:42 server0001 kernel: Pending list:
Nov 24 22:19:42 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel: Total 3
Nov 24 22:19:42 server0001 kernel: Kernel Free SCB list: 22 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 318
Nov 24 22:19:42 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:42 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:42 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:42 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:42 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:42 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:42 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:42 server0001 kernel: CCSCBCTL[0x4] 
Nov 24 22:19:42 server0001 kernel: scsi1: REG0 == 0xf, SINDEX = 0x133, DINDEX = 0x102
Nov 24 22:19:42 server0001 kernel: scsi1: SCBPTR == 0x17, SCB_NEXT == 0xff00, SCB_NEXT2 == 0xff7d
Nov 24 22:19:42 server0001 kernel: CDB 0 0 0 0 0 0
Nov 24 22:19:42 server0001 kernel: STACK: 0x125 0x0 0x0 0x25e 0x25e 0x25e 0x29 0x1
Nov 24 22:19:42 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:42 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1797200: 0x2a 0x0 0x0 0x0 0xb6 0x57 0x0 0x0 0x10 0x0
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Command not found
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Attempting to abort cmd c1797200: 0x0 0x0 0x0 0x0 0x0 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: At time of recovery, card was not paused
Nov 24 22:19:42 server0001 kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
Nov 24 22:19:42 server0001 kernel: scsi1: Dumping Card State at program address 0x14 Mode 0x11
Nov 24 22:19:42 server0001 kernel: Card was paused
Nov 24 22:19:42 server0001 kernel: HS_MAILBOX[0x0] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11]
Nov 24 22:19:42 server0001 kernel: DFFSTAT[0x20] SCSISIGI[0xe6] SCSIPHASE[0x8] SCSIBUS[0x55]
Nov 24 22:19:42 server0001 kernel: LASTPHASE[0x1] SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x10]
Nov 24 22:19:42 server0001 kernel: SEQINTCTL[0x0] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x0] SSTAT0[0x2]
Nov 24 22:19:42 server0001 kernel: SSTAT1[0x11] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0x8]
Nov 24 22:19:42 server0001 kernel: SIMODE1[0xa4] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
Nov 24 22:19:42 server0001 kernel: LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x81]
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: SCB Count = 32 CMDS_PENDING = 3 LASTSCB 0x17 CURRSCB 0x17 NEXTSCB 0xff80
Nov 24 22:19:42 server0001 kernel: qinstart = 29935 qinfifonext = 29935
Nov 24 22:19:42 server0001 kernel: QINFIFO:
Nov 24 22:19:42 server0001 kernel: WAITING_TID_QUEUES:
Nov 24 22:19:42 server0001 kernel:        0 ( 0x17 )
Nov 24 22:19:42 server0001 kernel: Pending list:
Nov 24 22:19:42 server0001 kernel:  23 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  15 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel:  10 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Nov 24 22:19:42 server0001 kernel: Total 3
Nov 24 22:19:42 server0001 kernel: Kernel Free SCB list: 22 6 27 3 7 20 5 11 30 24 26 12 9 2 4 13 28 25 21 19 0 16 17 1 18 14 29 318
Nov 24 22:19:42 server0001 kernel: Sequencer Complete DMA-inprog list:
Nov 24 22:19:42 server0001 kernel: Sequencer Complete list:
Nov 24 22:19:42 server0001 kernel: Sequencer DMA-Up and Complete list:
Nov 24 22:19:42 server0001 kernel:
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO0 Active, LONGJMP == 0x25e, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x8] DFSTATUS[0x0]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x8] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0xa] SHADDR = 0x05c47c458, SHCNT = 0x3a8
Nov 24 22:19:42 server0001 kernel: HADDR = 0x05c47c400, HCNT = 0x400 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: scsi1: FIFO1 Free, LONGJMP == 0x8277, SCB 0xa
Nov 24 22:19:42 server0001 kernel: SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x4] DFSTATUS[0x89]
Nov 24 22:19:42 server0001 kernel: SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
Nov 24 22:19:42 server0001 kernel: SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
Nov 24 22:19:42 server0001 kernel: HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
Nov 24 22:19:42 server0001 kernel: LQIN: 0x5 0x0 0x0 0xa 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x2 0x0 0x0 0x0 0x2 0x0
Nov 24 22:19:42 server0001 kernel: scsi1: LQISTATE = 0x21, LQOSTATE = 0x0, OPTIONMODE = 0x42
Nov 24 22:19:42 server0001 kernel: scsi1: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x1
Nov 24 22:19:42 server0001 kernel: SIMODE0[0xc]
Nov 24 22:19:42 server0001 kernel: CCSCBCTL[0x4]
Nov 24 22:19:42 server0001 kernel: scsi1: REG0 == 0x60, SINDEX = 0x111, DINDEX = 0x102
Nov 24 22:19:42 server0001 kernel: scsi1: SCBPTR == 0xa, SCB_NEXT == 0x17, SCB_NEXT2 == 0xf
Nov 24 22:19:42 server0001 kernel: CDB 2a 0 2 80 18 a0
Nov 24 22:19:42 server0001 kernel: STACK: 0x125 0x0 0x0 0x25e 0x25e 0x25e 0x26 0x14
Nov 24 22:19:42 server0001 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
Nov 24 22:19:42 server0001 kernel: DevQ(0:0:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: DevQ(0:6:0): 0 waiting
Nov 24 22:19:42 server0001 kernel: scsi1:0:0:0: Cmd aborted from QINFIFO
Nov 24 22:19:42 server0001 kernel: Recovery code sleeping
Nov 24 22:19:42 server0001 kernel: Recovery code awake
Nov 24 22:19:42 server0001 kernel: Timer Expired
Nov 24 22:19:42 server0001 kernel: scsi1: Device reset returning 0x2003
Nov 24 22:19:42 server0001 kernel: Recovery SCB completes
---snap---


boot dmesg:
---snip---
Nov 21 14:27:58 server0001 kernel: Linux version 
2.4.20-021stab028.18.777-smp (moruga@current.eng.sw.ru) (gcc version 2.96 20000731
(Red Hat Linux 7.3 2.96-110)) #1 SMP Wed Sep 14 19:49:52 MSD 2005
Nov 21 14:27:58 server0001 kernel: BIOS-provided physical RAM map:
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 0000000000000000 - 000000000009ac00 (usable)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 000000000009ac00 - 00000000000a0000 (reserved)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000000e8000 - 0000000000100000 (reserved)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 0000000000100000 - 00000000bfff0000 (usable)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000bfff0000 - 00000000bffff000 (ACPI data)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000bffff000 - 00000000c0000000 (ACPI NVS)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Nov 21 14:27:58 server0001 kernel:  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Nov 21 14:27:58 server0001 kernel: 0MB HIGHMEM available.
Nov 21 14:27:58 server0001 kernel: 3071MB LOWMEM available.
Nov 21 14:27:58 server0001 kernel: found SMP MP-table at 000ff780
Nov 21 14:27:58 server0001 kernel: hm, page 000ff000 reserved twice.
Nov 21 14:27:58 server0001 kernel: hm, page 00100000 reserved twice.
Nov 21 14:27:58 server0001 random: Initializing random number generator:  succeeded
Nov 21 14:27:58 server0001 kernel: hm, page 000f1000 reserved twice.
Nov 21 14:27:58 server0001 kernel: hm, page 000f2000 reserved twice.
Nov 21 14:27:58 server0001 kernel: On node 0 totalpages: 786416
Nov 21 14:27:58 server0001 kernel: zone(0): 4096 pages.
Nov 21 14:27:58 server0001 kernel: zone(1): 782320 pages.
Nov 21 14:27:58 server0001 kernel: zone(2): 0 pages.
Nov 21 14:27:58 server0001 kernel: ACPI: Searched entire block, no RSDP was found.
Nov 21 14:27:58 server0001 kernel: ACPI: RSDP located at physical address 020ff9b0
Nov 21 14:27:58 server0001 kernel: RSD PTR  v0 [INTEL ]
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff0000, 0x68): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: ACPI table found: RSDT v1 [INTEL  SWV25    0.1]
Nov 21 14:27:58 server0001 kernel: ACPI table found: RSDT v1 [INTEL  SWV25    0.1]
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff0030, 0x24): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff0030, 0x74): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: ACPI table found: FACP v1 [INTEL  SWV25    0.1]
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff00b0, 0x24): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff00b0, 0x90): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: ACPI table found: APIC v1 [INTEL  SWV25    0.1]
Nov 21 14:27:58 server0001 kernel: __va_range(0xbfff00b0, 0x90): idx=8 mapped at ffbf7000
Nov 21 14:27:58 server0001 kernel: LAPIC (acpi_id[0x0000] id[0x0] enabled[1])
Nov 21 14:27:58 server0001 kernel: CPU 0 (0x0000) enabledProcessor #0 Pentium 4(tm) XEON(tm) APIC version 16
Nov 21 14:27:58 server0001 vz: loading Virtuozzo modules succeeded
Nov 21 14:27:58 server0001 kernel:
Nov 21 14:27:58 server0001 kernel: LAPIC (acpi_id[0x0001] id[0x6] enabled[1])
Nov 21 14:27:58 server0001 kernel: CPU 1 (0x0600) enabledProcessor #6 Pentium 4(tm) XEON(tm) APIC version 16
Nov 21 14:27:58 server0001 kernel:
Nov 21 14:27:58 server0001 kernel: LAPIC (acpi_id[0x0002] id[0x0] enabled[0])
Nov 21 14:27:58 server0001 kernel: CPU 2 (0x0000) disabled
Nov 21 14:27:59 server0001 kernel: LAPIC (acpi_id[0x0003] id[0x0] enabled[0])
Nov 21 14:27:59 server0001 kernel: CPU 3 (0x0000) disabled
Nov 21 14:27:59 server0001 kernel: IOAPIC (id[0x8] address[0xfec00000] global_irq_base[0x0])
Nov 21 14:27:59 server0001 kernel: IOAPIC (id[0x9] address[0xfec81000] global_irq_base[0x18])
Nov 21 14:27:59 server0001 kernel: IOAPIC (id[0xa] address[0xfec81400] global_irq_base[0x30])
Nov 21 14:27:59 server0001 kernel: INT_SRC_OVR (bus[0] irq[0x0] global_irq[0x2] polarity[0x0] trigger[0x0])
Nov 21 14:27:59 server0001 kernel: INT_SRC_OVR (bus[0] irq[0x9] global_irq[0x9] polarity[0x1] trigger[0x3])
Nov 21 14:27:59 server0001 kernel: LAPIC_NMI (acpi_id[0x0000] polarity[0x1] trigger[0x3] lint[0x1])
Nov 21 14:27:59 server0001 kernel: LAPIC_NMI (acpi_id[0x0001] polarity[0x1] trigger[0x3] lint[0x1])
Nov 21 14:27:59 server0001 kernel: 4 CPUs total
Nov 21 14:27:59 server0001 kernel: Local APIC address fee00000
Nov 21 14:27:59 server0001 kernel: __va_range(0xbfff0140, 0x24): idx=8 mapped at ffbf7000
Nov 21 14:27:59 server0001 kernel: __va_range(0xbfff0140, 0x50): idx=8 mapped at ffbf7000
Nov 21 14:27:59 server0001 kernel: ACPI table found: OEMR v1 [INTEL  SWV25    0.1]
Nov 21 14:27:59 server0001 kernel: Enabling the CPU's according to the ACPI table
Nov 21 14:27:59 server0001 kernel: Intel MultiProcessor Specification v1.4
Nov 21 14:27:59 server0001 kernel:     Virtual Wire compatibility mode.
Nov 21 14:27:59 server0001 kernel: OEM ID: INTEL    Product ID: SWV25        APIC at: 0xFEE00000
Nov 21 14:27:59 server0001 kernel: I/O APIC #8 Version 32 at 0xFEC00000.
Nov 21 14:27:59 server0001 kernel: I/O APIC #9 Version 32 at 0xFEC81000.
Nov 21 14:27:59 server0001 kernel: I/O APIC #10 Version 32 at 0xFEC81400.
Nov 21 14:27:59 server0001 kernel: Processors: 2
Nov 21 14:27:59 server0001 kernel: Kernel command line: ro root=/dev/md0
Nov 21 14:27:59 server0001 kernel: Sorting kernel __ex_table entries... done.
Nov 21 14:27:59 server0001 kernel: Initializing CPU#0
Nov 21 14:27:59 server0001 kernel: Detected 2392.346 MHz processor.
Nov 21 14:27:59 server0001 kernel: Console: colour VGA+ 80x25
Nov 21 14:27:59 server0001 kernel: Calibrating delay loop... 4771.02 BogoMIPS
Nov 21 14:27:59 server0001 kernel: Memory: 3100588k/3145664k available (2256k kernel code, 44668k reserved, 1136k data, 648k init, 0k highmem)
Nov 21 14:27:59 server0001 kernel: Protecting kernel code at 0x2104000-0x23fc000... done.
Nov 21 14:27:59 server0001 kernel: Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Nov 21 14:27:59 server0001 kernel: Inode cache hash table entries: 262144 (order: 9, 2097152 bytes)
Nov 21 14:27:59 server0001 kernel: Mount-cache hash table entries: 65536 (order: 7, 524288 bytes)
Nov 21 14:27:59 server0001 kernel: Buffer-cache hash table entries: 262144 (order: 8, 1048576 bytes)
Nov 21 14:27:59 server0001 kernel: Page-cache hash table entries: 524288 (order: 9, 2097152 bytes)
Nov 21 14:27:59 server0001 kernel: CPU: L1 I cache: 0K, L1 D cache: 8K
Nov 21 14:27:59 server0001 kernel: CPU: L2 cache: 512K
Nov 21 14:27:59 server0001 kernel: CPU: Physical Processor ID: 0
Nov 21 14:27:59 server0001 kernel: Intel machine check architecture supported.
Nov 21 14:27:59 server0001 kernel: Intel machine check reporting enabled on CPU#0.
Nov 21 14:27:59 server0001 vz: loading Virtuozzo license succeeded
Nov 21 14:27:59 server0001 vz: set vzprivrange succeeded
Nov 21 14:27:59 server0001 kernel: Enabling fast FPU save and restore... done.
Nov 21 14:27:59 server0001 kernel: Enabling unmasked SIMD FPU exception support... done.
Nov 21 14:27:59 server0001 kernel: Checking 'hlt' instruction... OK.
Nov 21 14:27:59 server0001 kernel: POSIX conformance testing by UNIFIX
Nov 21 14:27:59 server0001 kernel: mtrr: v1.40 (20010327) Richard Gooch (rgooch@atnf.csiro.au)
Nov 21 14:27:59 server0001 kernel: mtrr: detected mtrr type: Intel
Nov 21 14:27:59 server0001 vz: Configuring Virtuozzo accounting succeeded
Nov 21 14:27:59 server0001 kernel: CPU: L1 I cache: 0K, L1 D cache: 8K
Nov 21 14:27:59 server0001 kernel: CPU: L2 cache: 512K
Nov 21 14:27:59 server0001 kernel: CPU: Physical Processor ID: 0
Nov 21 14:27:59 server0001 kernel: Intel machine check reporting enabled on CPU#0.
Nov 21 14:27:59 server0001 kernel: CPU0: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Nov 21 14:27:59 server0001 kernel: per-CPU timeslice cutoff: 1462.89 usecs.
Nov 21 14:27:59 server0001 kernel: enabled ExtINT on CPU#0
Nov 21 14:27:59 server0001 kernel: ESR value before enabling vector: 00000000
Nov 21 14:27:59 server0001 kernel: ESR value after enabling vector: 00000000
Nov 21 14:27:59 server0001 kernel: Booting processor 1/6 eip 2000
Nov 21 14:27:59 server0001 kernel: Initializing CPU#1
Nov 21 14:27:59 server0001 kernel: masked ExtINT on CPU#1
Nov 21 14:27:59 server0001 kernel: ESR value before enabling vector: 00000000
Nov 21 14:27:59 server0001 kernel: ESR value after enabling vector: 00000000
Nov 21 14:27:59 server0001 kernel: Calibrating delay loop... 4784.12 BogoMIPS
Nov 21 14:27:59 server0001 kernel: CPU: L1 I cache: 0K, L1 D cache: 8K
Nov 21 14:27:59 server0001 kernel: CPU: L2 cache: 512K
Nov 21 14:27:59 server0001 kernel: CPU: Physical Processor ID: 3
Nov 21 14:27:59 server0001 kernel: Intel machine check reporting enabled on CPU#1.
Nov 21 14:27:59 server0001 kernel: CPU1: Intel(R) Xeon(TM) CPU 2.40GHz stepping 07
Nov 21 14:27:59 server0001 kernel: Total of 2 processors activated (9555.14 BogoMIPS).
Nov 21 14:27:59 server0001 kernel: WARNING: No sibling found for CPU 0.
Nov 21 14:27:59 server0001 kernel: WARNING: No sibling found for CPU 1.
Nov 21 14:27:59 server0001 kernel: ENABLING IO-APIC IRQs
Nov 21 14:27:59 server0001 kernel: Setting 8 in the phys_id_present_map
Nov 21 14:27:59 server0001 kernel: ...changing IO-APIC physical APIC ID to 8 ... ok.
Nov 21 14:27:59 server0001 kernel: Setting 9 in the phys_id_present_map
Nov 21 14:27:59 server0001 kernel: ...changing IO-APIC physical APIC ID to 9 ... ok.
Nov 21 14:27:59 server0001 kernel: Setting 10 in the phys_id_present_map
Nov 21 14:27:59 server0001 kernel: ...changing IO-APIC physical APIC ID to 10 ... ok.
Nov 21 14:27:59 server0001 kernel: ..TIMER: vector=0x31 pin1=2 pin2=0
Nov 21 14:27:59 server0001 kernel: activating NMI Watchdog ... done.
Nov 21 14:27:59 server0001 kernel: testing NMI watchdog ... OK.
Nov 21 14:27:59 server0001 kernel: testing the IO APIC.......................
Nov 21 14:27:59 server0001 kernel:
Nov 21 14:27:59 server0001 last message repeated 2 times
Nov 21 14:27:59 server0001 kernel: .................................... done.
Nov 21 14:27:59 server0001 kernel: Using local APIC timer interrupts.
Nov 21 14:27:59 server0001 kernel: calibrating APIC timer ...
Nov 21 14:27:59 server0001 kernel: ..... CPU clock speed is 2392.3176 MHz.
Nov 21 14:27:59 server0001 kernel: ..... host bus clock speed is 132.9064 MHz.
Nov 21 14:27:59 server0001 kernel: cpu: 0, clocks: 1329064, slice: 443021
Nov 21 14:27:59 server0001 kernel: CPU0<T0:1329056,T1:886032,D:3,S:443021,C:1329064>
Nov 21 14:27:59 server0001 kernel: cpu: 1, clocks: 1329064, slice: 443021
Nov 21 14:27:59 server0001 kernel: CPU1<T0:1329056,T1:443008,D:6,S:443021,C:1329064>
Nov 21 14:27:59 server0001 kernel: checking TSC synchronization across CPUs: passed.
Nov 21 14:27:59 server0001 kernel: Waiting on wait_init_idle (map = 0x2)
Nov 21 14:27:59 server0001 kernel: All processors have done init_idle
Nov 21 14:27:59 server0001 kernel: Initializing VE sub-system
Nov 21 14:27:59 server0001 kernel: Marking 0 idle task with zero envid
Nov 21 14:28:00 server0001 kernel: Marking 1 idle task with zero envid
Nov 21 14:28:00 server0001 kernel: PCI: PCI BIOS revision 2.10 entry at 0xfdb75, last bus=4
Nov 21 14:28:00 server0001 kernel: PCI: Using configuration type 1
Nov 21 14:28:00 server0001 kernel: PCI: Probing PCI hardware
Nov 21 14:28:00 server0001 kernel: PCI: Ignoring BAR0-3 of IDE controller 00:1f.1
Nov 21 14:28:00 server0001 kernel: Transparent bridge - Intel Corp. 82801BA/CA/DB/EB PCI Bridge
Nov 21 14:28:00 server0001 kernel: PCI: Using IRQ router PIIX [8086/2480] at 00:1f.0
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B0,I29,P0) -> 16
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B0,I29,P1) -> 19
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B0,I31,P0) -> 17
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B0,I31,P1) -> 17
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B4,I7,P0) -> 50
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B4,I7,P1) -> 49
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B3,I7,P0) -> 30
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B3,I7,P1) -> 31
Nov 21 14:28:00 server0001 kernel: PCI->APIC IRQ transform: (B1,I12,P0) -> 17
Nov 21 14:28:00 server0001 kernel: Linux NET4.0 for Linux 2.4
Nov 21 14:28:00 server0001 kernel: Based upon Swansea University Computer Society NET3.039
Nov 21 14:28:00 server0001 kernel: Initializing RT netlink socket
Nov 21 14:28:00 server0001 kernel: IA-32 Microcode Update Driver: v1.14 <tigran@veritas.com>
Nov 21 14:28:00 server0001 kernel: Fair CPU scheduler v0.45ve
Nov 21 14:28:00 server0001 kernel: Starting kswapd
Nov 21 14:28:00 server0001 kernel: Page beancounter hash is 262144 entries.
Nov 21 14:28:00 server0001 kernel: Journalled Block Device driver loaded
Nov 21 14:28:00 server0001 kernel: Detected PS/2 Mouse Port.
Nov 21 14:28:00 server0001 kernel: pty: 256 Unix98 ptys configured
Nov 21 14:28:00 server0001 kernel: Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI enabled
Nov 21 14:28:00 server0001 kernel: ttyS00 at 0x03f8 (irq = 4) is a 16550A
Nov 21 14:28:00 server0001 kernel: ttyS01 at 0x02f8 (irq = 3) is a 16550A
Nov 21 14:28:00 server0001 kernel: Real Time Clock Driver v1.10e
Nov 21 14:28:00 server0001 kernel: RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Nov 21 14:28:00 server0001 kernel: Compaq SMART2 Driver (v 2.4.21)
Nov 21 14:28:00 server0001 kernel: HP CISS Driver (v 2.4.50)
Nov 21 14:28:00 server0001 kernel: Uniform Multi-Platform E-IDE driver Revision: 7.00beta3-.2.4
Nov 21 14:28:00 server0001 kernel: ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Nov 21 14:28:00 server0001 kernel: ICH3: IDE controller at PCI slot 00:1f.1
Nov 21 14:28:00 server0001 kernel: PCI: Enabling device 00:1f.1 (0005 -> 0007)
Nov 21 14:28:00 server0001 kernel: ICH3: chipset revision 2
Nov 21 14:28:00 server0001 kernel: ICH3: not 100% native mode: will probe irqs later
Nov 21 14:28:00 server0001 kernel:     ide0: BM-DMA at 0x03a0-0x03a7, BIOS settings: hda:pio, hdb:pio
Nov 21 14:28:00 server0001 kernel:     ide1: BM-DMA at 0x03a8-0x03af, BIOS settings: hdc:DMA, hdd:pio
Nov 21 14:28:00 server0001 kernel: hdc: SAMSUNG CD-ROM SN-124, ATAPI CD/DVD-ROM drive
Nov 21 14:28:00 server0001 kernel: hdc: Disabling (U)DMA for SAMSUNG CD-ROM SN-124
Nov 21 14:28:00 server0001 kernel: ide1 at 0x170-0x177,0x376 on irq 15
Nov 21 14:28:00 server0001 kernel: SCSI subsystem driver Revision: 1.00
Nov 21 14:28:00 server0001 kernel: Loading Adaptec I2O RAID: Version 2.4 Build 5
Nov 21 14:28:00 server0001 kernel: Detecting Adaptec I2O RAID controllers...
Nov 21 14:28:00 server0001 kernel: Red Hat/Adaptec aacraid driver (1.1-4[9999])
Nov 21 14:28:00 server0001 kernel: scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
Nov 21 14:28:00 server0001 kernel:         <Adaptec AIC7902 Ultra320 SCSI adapter>
Nov 21 14:28:00 server0001 kernel:         aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Nov 21 14:28:00 server0001 kernel:
Nov 21 14:28:00 server0001 kernel: scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 1.3.10
Nov 21 14:28:00 server0001 kernel:         <Adaptec AIC7902 Ultra320 SCSI adapter>
Nov 21 14:28:00 server0001 kernel:         aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI-X 67-100Mhz, 512 SCBs
Nov 21 14:28:00 server0001 kernel:
Nov 21 14:28:00 server0001 kernel: (scsi1:A:0): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Nov 21 14:28:00 server0001 kernel: (scsi1:A:1): 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Nov 21 14:28:00 server0001 kernel:   Vendor: FUJITSU   Model: MAP3367NC         Rev: 0105
Nov 21 14:28:00 server0001 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Nov 21 14:28:00 server0001 kernel:   Vendor: FUJITSU   Model: MAP3367NC         Rev: 0105
Nov 21 14:28:00 server0001 kernel:   Type:   Direct-Access                      ANSI SCSI revision: 03
Nov 21 14:28:00 server0001 kernel:   Vendor: ESG-SHV   Model: SCA HSBP M18      Rev: 0.07
Nov 21 14:28:00 server0001 kernel:   Type:   Processor                          ANSI SCSI revision: 02
Nov 21 14:28:00 server0001 kernel: scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
Nov 21 14:28:00 server0001 kernel: scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
Nov 21 14:28:00 server0001 kernel: ISP SCSI and Fibre Channel Host Adapter Driver
Nov 21 14:28:00 server0001 kernel:       Linux Platform Version 2.1
Nov 21 14:28:00 server0001 kernel:       Common Core Code Version 2.6
Nov 21 14:28:00 server0001 kernel:       Built on Sep 14 2005, 19:51:41
Nov 21 14:28:00 server0001 kernel: qla4xxx: code starts at address = 02273c30
Nov 21 14:28:00 server0001 kernel: megaraid: v2.10.8.2-RH1 (Release Date: Mon Jul 26 12:15:51 EDT 2004)
Nov 21 14:28:00 server0001 kernel: 3ware Storage Controller device driver for Linux v1.02.00.037.
Nov 21 14:28:00 server0001 kernel: 3w-xxxx: No cards found.
Nov 21 14:28:00 server0001 kernel: 3ware 9000 Storage Controller device driver for Linux v2.24.00.011fw.
Nov 21 14:28:00 server0001 kernel: 3w-9xxx: No cards successfully initialized.
Nov 21 14:28:00 server0001 kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0
Nov 21 14:28:00 server0001 kernel: Attached scsi disk sdb at scsi1, channel 0, id 1, lun 0
Nov 21 14:28:00 server0001 kernel: SCSI device sda: 71775284 512-byte hdwr sectors (36749 MB)
Nov 21 14:28:00 server0001 kernel: Partition check:
Nov 21 14:28:00 server0001 kernel:  sda: sda1 sda2 sda3
Nov 21 14:28:00 server0001 kernel: SCSI device sdb: 71775284 512-byte hdwr sectors (36749 MB)
Nov 21 14:28:00 server0001 kernel:  sdb: sdb1 sdb2 sdb3
Nov 21 14:28:00 server0001 kernel: Fusion MPT base driver 2.05.16
Nov 21 14:28:00 server0001 kernel: Copyright (c) 1999-2004 LSI Logic Corporation
Nov 21 14:28:00 server0001 kernel: mptbase: 0 MPT adapters found, 0 installed.
Nov 21 14:28:00 server0001 kernel: Fusion MPT SCSI Host driver 2.05.16
Nov 21 14:28:00 server0001 kernel: mice: PS/2 mouse device common for all mice
Nov 21 14:28:00 server0001 kernel: md: linear personality registered as nr 1
Nov 21 14:28:00 server0001 kernel: md: raid0 personality registered as nr 2
Nov 21 14:28:00 server0001 kernel: md: raid1 personality registered as nr 3
Nov 21 14:28:00 server0001 kernel: md: raid5 personality registered as nr 4
Nov 21 14:28:00 server0001 kernel: raid5: measuring checksumming speed
Nov 21 14:28:00 server0001 kernel:    8regs     :  2792.800 MB/sec
Nov 21 14:28:00 server0001 kernel:    32regs    :  1718.000 MB/sec
Nov 21 14:28:00 server0001 kernel:    pIII_sse  :  3098.000 MB/sec
Nov 21 14:28:00 server0001 kernel:    pII_mmx   :  2841.200 MB/sec
Nov 21 14:28:00 server0001 kernel:    p5_mmx    :  2759.200 MB/sec
Nov 21 14:28:00 server0001 kernel: raid5: using function: pIII_sse (3098.000 MB/sec)
Nov 21 14:28:00 server0001 kernel: md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
Nov 21 14:28:00 server0001 kernel: md: Autodetecting RAID arrays.
Nov 21 14:28:00 server0001 kernel:  [events: 00000025]
Nov 21 14:28:00 server0001 last message repeated 3 times
Nov 21 14:28:00 server0001 kernel: md: autorun ...
Nov 21 14:28:00 server0001 kernel: md: considering sdb3 ...
Nov 21 14:28:00 server0001 kernel: md:  adding sdb3 ...
Nov 21 14:28:00 server0001 kernel: md:  adding sda3 ...
Nov 21 14:28:00 server0001 kernel: md: created md1
Nov 21 14:28:00 server0001 kernel: md: bind<sda3,1>
Nov 21 14:28:01 server0001 kernel: md: bind<sdb3,2>
Nov 21 14:28:01 server0001 kernel: md: running: <sdb3><sda3>
Nov 21 14:28:01 server0001 kernel: md: sdb3's event counter: 00000025
Nov 21 14:28:01 server0001 kernel: md: sda3's event counter: 00000025
Nov 21 14:28:01 server0001 kernel: md: RAID level 1 does not need chunksize! Continuing anyway.
Nov 21 14:28:01 server0001 kernel: md1: max total readahead window set to 124k
Nov 21 14:28:01 server0001 kernel: md1: 1 data-disks, max readahead per data-disk: 124k
Nov 21 14:28:01 server0001 kernel: raid1: device sdb3 operational as mirror 1
Nov 21 14:28:01 server0001 kernel: raid1: device sda3 operational as mirror 0
Nov 21 14:28:01 server0001 kernel: raid1: raid set md1 active with 2 out of 2 mirrors
Nov 21 14:28:01 server0001 kernel: md: updating md1 RAID superblock on device
Nov 21 14:28:01 server0001 kernel: md: sdb3 [events: 00000026]<6>(write) sdb3's sb offset: 26442880
Nov 21 14:28:01 server0001 kernel: md: sda3 [events: 00000026]<6>(write) sda3's sb offset: 26442880
Nov 21 14:28:01 server0001 kernel: md: considering sdb1 ...
Nov 21 14:28:01 server0001 kernel: md:  adding sdb1 ...
Nov 21 14:28:01 server0001 kernel: md:  adding sda1 ...
Nov 21 14:28:01 server0001 kernel: md: created md0
Nov 21 14:28:01 server0001 kernel: md: bind<sda1,1>
Nov 21 14:28:01 server0001 kernel: md: bind<sdb1,2>
Nov 21 14:28:01 server0001 kernel: md: running: <sdb1><sda1>
Nov 21 14:28:01 server0001 kernel: md: sdb1's event counter: 00000025
Nov 21 14:28:01 server0001 kernel: md: sda1's event counter: 00000025
Nov 21 14:28:01 server0001 kernel: md: RAID level 1 does not need chunksize! Continuing anyway.
Nov 21 14:28:01 server0001 kernel: md0: max total readahead window set to 124k
Nov 21 14:28:01 server0001 kernel: md0: 1 data-disks, max readahead per data-disk: 124k
Nov 21 14:28:01 server0001 kernel: raid1: device sdb1 operational as mirror 1
Nov 21 14:28:01 server0001 kernel: raid1: device sda1 operational as mirror 0
Nov 21 14:28:01 server0001 kernel: raid1: raid set md0 active with 2 out of 2 mirrors
Nov 21 14:28:01 server0001 kernel: md: updating md0 RAID superblock on device
Nov 21 14:28:01 server0001 kernel: md: sdb1 [events: 00000026]<6>(write) sdb1's sb offset: 8385792
Nov 21 14:28:01 server0001 kernel: md: sda1 [events: 00000026]<6>(write) sda1's sb offset: 8385792
Nov 21 14:28:01 server0001 kernel: md: ... autorun DONE.
Nov 21 14:28:01 server0001 kernel: LVM version 1.0.8(17/11/2003)
Nov 21 14:28:01 server0001 kernel: NET4: Linux TCP/IP 1.0 for NET4.0
Nov 21 14:28:01 server0001 kernel: IP Protocols: ICMP, UDP, TCP
Nov 21 14:28:01 server0001 kernel: IP: routing cache hash table of 32768 buckets, 256Kbytes
Nov 21 14:28:01 server0001 kernel: TCP: Hash tables configured (established 262144 bind 65536)
Nov 21 14:28:01 server0001 kernel: NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
Nov 21 14:28:01 server0001 kernel: kjournald starting.  Commit interval 5 seconds
Nov 21 14:28:01 server0001 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Nov 21 14:28:01 server0001 kernel: VFS: Mounted root (ext3 filesystem) readonly.
Nov 21 14:28:01 server0001 kernel: Freeing unused kernel memory: 648k freed
Nov 21 14:28:01 server0001 kernel: : registered new driver usbdevfs
Nov 21 14:28:01 server0001 kernel: : registered new driver hub
Nov 21 14:28:01 server0001 kernel: : $Revision: 1.275 $ time 19:53:40 Sep 14 2005
Nov 21 14:28:01 server0001 kernel: : High bandwidth mode enabled
Nov 21 14:28:01 server0001 vz:  succeeded
Nov 21 14:28:01 server0001 kernel: : USB UHCI at I/O 0x5020, IRQ 16
Nov 21 14:28:01 server0001 kernel: : Detected 2 ports
Nov 21 14:28:01 server0001 kernel: : new USB bus registered, assigned bus number 1
Nov 21 14:28:01 server0001 kernel: : USB hub found
Nov 21 14:28:01 server0001 kernel: : 2 ports detected
Nov 21 14:28:01 server0001 kernel: : USB UHCI at I/O 0x5000, IRQ 19
Nov 21 14:28:01 server0001 kernel: : Detected 2 ports
Nov 21 14:28:01 server0001 kernel: : new USB bus registered, assigned bus number 2
Nov 21 14:28:01 server0001 kernel: : USB hub found
Nov 21 14:28:01 server0001 kernel: : 2 ports detected
Nov 21 14:28:01 server0001 kernel: : v1.275:USB Universal Host Controller Interface driver
Nov 21 14:28:01 server0001 kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,0), internal journal
Nov 21 14:28:01 server0001 kernel: Adding Swap: 1052248k swap-space (priority -1)
Nov 21 14:28:01 server0001 kernel: Adding Swap: 1052248k swap-space (priority -2)
Nov 21 14:28:01 server0001 kernel: kjournald starting.  Commit interval 5 seconds
Nov 21 14:28:01 server0001 kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,1), internal journal
Nov 21 14:28:01 server0001 kernel: EXT3-fs: mounted filesystem with ordered data mode.
Nov 21 14:28:01 server0001 kernel: ip_tables: (C) 2000-2002 Netfilter core team
Nov 21 14:28:01 server0001 kernel: ip_conntrack version 2.1 (8192 buckets, 65536 max) - 300 bytes per conntrack
Nov 21 14:28:01 server0001 kernel: Intel(R) PRO/1000 Network Driver - version 6.0.60
Nov 21 14:28:01 server0001 kernel: Copyright (c) 1999-2005 Intel Corporation.
Nov 21 14:28:01 server0001 kernel: e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Nov 21 14:28:01 server0001 kernel: e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
Nov 21 14:28:01 server0001 kernel: e1000: eth0: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex
Nov 21 14:28:01 server0001 kernel: Virtual Network Device for VE networking
Nov 21 14:28:01 server0001 kernel: VZFS: Virtuozzo file system version 005.003
---snap---


Kind regards,
 	ingo flaschberger

geschaeftsleitung
crossip communications gmbH
------------------------------
sebastian kneipp gasse 1
a-1020 wien
fix: +43-1-726 15 22-201
fax: +43-1-726 15 22-111
mob: +43-699-105 86 719
www.xip.at
------------------------------
