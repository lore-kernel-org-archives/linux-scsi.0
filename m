From: Andrew Patterson <andrew@fc.hp.com>
Subject: Kernel panic using Aic7xxx driver after timeout
Date: 07 May 2002 13:29:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1020799743.2317.20.camel@lvadp.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>
Cc: gibbs@scsiguy.com

I am using the aic7xxx (new) driver that comes with the linux 2.4.17
kernel.  I get a kernel panic under the following conditions:

One process sends a long-running command, e.g., rewind or tape load
through the driver to a a device.

A second process sends a second command (such as an inquriy) to the
device with a timeout set such that the timeout expires before the
rewind/load command completes.

The driver correctly aborts the second command when the timeout expires,
but then panics the kernel with the error log below.  Here are some
hardware details:

HBA:    Adaptec 29160
Device: DLT8000  (I get the same behavior on an HP tape changer).

I tried version 6.2.5 with the same results.

This is the timeout abort message from the second (inquiry) command:

May  7 13:06:33 lvadp kernel: scsi2:0:2:0: Attempting to queue an ABORT
message
May  7 13:06:33 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x18
May  7 13:06:33 lvadp kernel: ACCUM = 0x2, SINDEX = 0x48, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:06:33 lvadp kernel: HCNT = 0x0
May  7 13:06:33 lvadp kernel: SCSISEQ = 0x5a, SBLKCTL = 0xa
May  7 13:06:33 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:06:33 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x18, SXFRCTL0
= 0x80
May  7 13:06:33 lvadp kernel: SSTAT0 = 0x10, SSTAT1 = 0x8
May  7 13:06:33 lvadp kernel: SCSIPHASE = 0x0
May  7 13:06:33 lvadp kernel: STACK == 0x17, 0x175, 0x160, 0x0
May  7 13:06:33 lvadp kernel: SCB count = 4
May  7 13:06:33 lvadp kernel: Kernel NEXTQSCB = 3
May  7 13:06:33 lvadp kernel: Card NEXTQSCB = 3
May  7 13:06:33 lvadp kernel: QINFIFO entries: 
May  7 13:06:33 lvadp kernel: Waiting Queue entries: 0:2 
May  7 13:06:33 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:33 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:33 lvadp kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9
10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May  7 13:06:33 lvadp kernel: Pending list: 2
May  7 13:06:33 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:33 lvadp kernel: Untagged Q(2): 2 
May  7 13:06:33 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:06:33 lvadp kernel: scsi2:0:2:0: Cmd aborted from QINFIFO
May  7 13:06:33 lvadp kernel: aic7xxx_abort returns 0x2002
May  7 13:06:33 lvadp kernel: scsi2:A:2: ahc_intr - referenced scb not
valid during seqint 0x71 scb(255)
May  7 13:06:33 lvadp kernel: scsi2: Dumping Card State in Message-in
phase, at SEQADDR 0x1a3
May  7 13:06:33 lvadp kernel: ACCUM = 0x0, SINDEX = 0x71, DINDEX = 0xe4,
ARG_2 = 0x3f
May  7 13:06:33 lvadp kernel: HCNT = 0x0
May  7 13:06:33 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:06:33 lvadp kernel:  DFCNTRL = 0x4, DFSTATUS = 0x89
May  7 13:06:33 lvadp kernel: LASTPHASE = 0xe0, SCSISIGI = 0xe6,
SXFRCTL0 = 0x88
May  7 13:06:33 lvadp kernel: SSTAT0 = 0x7, SSTAT1 = 0x11
May  7 13:06:33 lvadp kernel: SCSIPHASE = 0x8
May  7 13:06:33 lvadp kernel: STACK == 0x175, 0x160, 0x0, 0xfe
May  7 13:06:33 lvadp kernel: SCB count = 4
May  7 13:06:33 lvadp kernel: Kernel NEXTQSCB = 2
May  7 13:06:33 lvadp kernel: Card NEXTQSCB = 3
May  7 13:06:33 lvadp kernel: QINFIFO entries: 3 
May  7 13:06:33 lvadp kernel: Waiting Queue entries: 
May  7 13:06:33 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:33 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:33 lvadp kernel: Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8
9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
May  7 13:06:33 lvadp kernel: Pending list: 3
May  7 13:06:33 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:33 lvadp kernel: Untagged Q(2): 3 
May  7 13:06:33 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:06:33 lvadp kernel: for safetyscsi2: No free or disconnected
SCBs
May  7 13:06:33 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x1a3
May  7 13:06:33 lvadp kernel: ACCUM = 0x0, SINDEX = 0xd1, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:06:33 lvadp kernel: HCNT = 0x0
May  7 13:06:33 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:06:33 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:06:33 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
May  7 13:06:33 lvadp kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
May  7 13:06:33 lvadp kernel: SCSIPHASE = 0x0
May  7 13:06:33 lvadp kernel: STACK == 0x160, 0x0, 0xb, 0x197
May  7 13:06:33 lvadp kernel: SCB count = 4
May  7 13:06:33 lvadp kernel: Kernel NEXTQSCB = 2
May  7 13:06:33 lvadp kernel: Card NEXTQSCB = 3
May  7 13:06:33 lvadp kernel: QINFIFO entries: 3 
May  7 13:06:33 lvadp kernel: Waiting Queue entries: 
May  7 13:06:33 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:33 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:33 lvadp kernel: Sequencer Free SCB List: 
May  7 13:06:33 lvadp kernel: Pending list: 3
May  7 13:06:33 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:33 lvadp kernel: Untagged Q(2): 3 
May  7 13:06:33 lvadp kernel: DevQ(0:2:0): 0 waiting

And here is the panic (I replaced the panic call with a printk):

May  7 13:06:43 lvadp kernel: for safetyscsi2:0:2:0: Attempting to queue
an ABORT message
May  7 13:06:43 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x8
May  7 13:06:43 lvadp kernel: ACCUM = 0x0, SINDEX = 0x3, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:06:43 lvadp kernel: HCNT = 0x0
May  7 13:06:43 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:06:43 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:06:43 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
May  7 13:06:43 lvadp kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
May  7 13:06:43 lvadp kernel: SCSIPHASE = 0x0
May  7 13:06:43 lvadp kernel: STACK == 0x3, 0x108, 0x160, 0x0
May  7 13:06:43 lvadp kernel: SCB count = 4
May  7 13:06:43 lvadp kernel: Kernel NEXTQSCB = 2
May  7 13:06:43 lvadp kernel: Card NEXTQSCB = 2
May  7 13:06:43 lvadp kernel: QINFIFO entries: 
May  7 13:06:43 lvadp kernel: Waiting Queue entries: 
May  7 13:06:43 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:43 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:43 lvadp kernel: Sequencer Free SCB List: 
May  7 13:06:43 lvadp kernel: Pending list: 3
May  7 13:06:43 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:43 lvadp kernel: Untagged Q(2): 3 
May  7 13:06:43 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:06:43 lvadp kernel: (scsi2:A:2:0): Queuing a recovery SCB
May  7 13:06:43 lvadp kernel: scsi2:0:2:0: Device is disconnected,
re-queuing SCB
May  7 13:06:43 lvadp kernel: scsi2: No free or disconnected SCBs
May  7 13:06:43 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x1a3
May  7 13:06:43 lvadp kernel: ACCUM = 0x0, SINDEX = 0xd1, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:06:43 lvadp kernel: HCNT = 0x0
May  7 13:06:43 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:06:43 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:06:43 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
May  7 13:06:43 lvadp kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
May  7 13:06:43 lvadp kernel: SCSIPHASE = 0x0
May  7 13:06:43 lvadp kernel: STACK == 0x160, 0x0, 0xb, 0x197
May  7 13:06:43 lvadp kernel: SCB count = 4
May  7 13:06:43 lvadp kernel: Kernel NEXTQSCB = 2
May  7 13:06:43 lvadp kernel: Card NEXTQSCB = 3
May  7 13:06:43 lvadp kernel: QINFIFO entries: 3 
May  7 13:06:43 lvadp kernel: Waiting Queue entries: 
May  7 13:06:43 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:43 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:43 lvadp kernel: Sequencer Free SCB List: 
May  7 13:06:43 lvadp kernel: Pending list: 3
May  7 13:06:43 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:43 lvadp kernel: Untagged Q(2): 3 
May  7 13:06:43 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:06:43 lvadp kernel: for safetyRecovery code sleeping
May  7 13:06:43 lvadp kernel: (scsi2:A:2:0): Abort Message Sent
May  7 13:06:43 lvadp kernel: (scsi2:A:2:0): SCB 3 - Abort Completed.
May  7 13:06:43 lvadp kernel: Recovery SCB completes
May  7 13:06:43 lvadp kernel: Recovery code awake
May  7 13:06:43 lvadp kernel: aic7xxx_abort returns 0x2002
May  7 13:06:43 lvadp kernel: scsi2:0:2:0: Attempting to queue a TARGET
RESET message
May  7 13:06:43 lvadp kernel: scsi2:0:2:0: Command not found
May  7 13:06:43 lvadp kernel: aic7xxx_dev_reset returns 0x2002
May  7 13:06:53 lvadp kernel: scsi2:0:2:0: Attempting to queue an ABORT
message
May  7 13:06:53 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x8
May  7 13:06:53 lvadp kernel: ACCUM = 0x0, SINDEX = 0x2, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:06:53 lvadp kernel: HCNT = 0x0
May  7 13:06:53 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:06:53 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:06:53 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
May  7 13:06:53 lvadp kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
May  7 13:06:53 lvadp kernel: SCSIPHASE = 0x0
May  7 13:06:53 lvadp kernel: STACK == 0x3, 0x108, 0x160, 0xe7
May  7 13:06:53 lvadp kernel: SCB count = 4
May  7 13:06:53 lvadp kernel: Kernel NEXTQSCB = 3
May  7 13:06:53 lvadp kernel: Card NEXTQSCB = 3
May  7 13:06:53 lvadp kernel: QINFIFO entries: 
May  7 13:06:53 lvadp kernel: Waiting Queue entries: 
May  7 13:06:53 lvadp kernel: Disconnected Queue entries: 
May  7 13:06:53 lvadp kernel: QOUTFIFO entries: 
May  7 13:06:53 lvadp kernel: Sequencer Free SCB List: 31 
May  7 13:06:53 lvadp kernel: Pending list: 2
May  7 13:06:53 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:06:53 lvadp kernel: Untagged Q(2): 2 
May  7 13:06:53 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:06:53 lvadp kernel: (scsi2:A:2:0): Queuing a recovery SCB
May  7 13:06:53 lvadp kernel: scsi2:0:2:0: Device is disconnected,
re-queuing SCB
May  7 13:06:53 lvadp kernel: Recovery code sleeping
May  7 13:06:53 lvadp kernel: (scsi2:A:2:0): Abort Message Sent
May  7 13:06:53 lvadp kernel: (scsi2:A:2:0): SCB 2 - Abort Completed.
May  7 13:06:53 lvadp kernel: Recovery SCB completes
May  7 13:06:53 lvadp kernel: Recovery code awake
May  7 13:06:53 lvadp kernel: aic7xxx_abort returns 0x2002
May  7 13:07:08 lvadp kernel: scsi2:0:2:0: Attempting to queue an ABORT
message
May  7 13:07:08 lvadp kernel: scsi2: Dumping Card State while idle, at
SEQADDR 0x9
May  7 13:07:08 lvadp kernel: ACCUM = 0x0, SINDEX = 0x3, DINDEX = 0xe4,
ARG_2 = 0x0
May  7 13:07:08 lvadp kernel: HCNT = 0x0
May  7 13:07:08 lvadp kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
May  7 13:07:08 lvadp kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
May  7 13:07:08 lvadp kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
May  7 13:07:08 lvadp kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
May  7 13:07:08 lvadp kernel: SCSIPHASE = 0x0
May  7 13:07:08 lvadp kernel: STACK == 0x3, 0x108, 0x160, 0xe7
May  7 13:07:08 lvadp kernel: SCB count = 4
May  7 13:07:08 lvadp kernel: Kernel NEXTQSCB = 2
May  7 13:07:08 lvadp kernel: Card NEXTQSCB = 2
May  7 13:07:08 lvadp kernel: QINFIFO entries: 
May  7 13:07:08 lvadp kernel: Waiting Queue entries: 
May  7 13:07:08 lvadp kernel: Disconnected Queue entries: 
May  7 13:07:08 lvadp kernel: QOUTFIFO entries: 
May  7 13:07:08 lvadp kernel: Sequencer Free SCB List: 31 
May  7 13:07:08 lvadp kernel: Pending list: 3
May  7 13:07:08 lvadp kernel: Kernel Free SCB list: 1 0 
May  7 13:07:08 lvadp kernel: Untagged Q(2): 3 
May  7 13:07:08 lvadp kernel: DevQ(0:2:0): 0 waiting
May  7 13:07:08 lvadp kernel: (scsi2:A:2:0): Queuing a recovery SCB
May  7 13:07:08 lvadp kernel: scsi2:0:2:0: Device is disconnected,
re-queuing SCB
May  7 13:07:08 lvadp kernel: Recovery code sleeping
May  7 13:07:08 lvadp kernel: (scsi2:A:2:0): Abort Message Sent
May  7 13:07:08 lvadp kernel: (scsi2:A:2:0): SCB 3 - Abort Completed.
May  7 13:07:08 lvadp kernel: Recovery SCB completes
May  7 13:07:08 lvadp kernel: Recovery code awake
May  7 13:07:08 lvadp kernel: aic7xxx_abort returns 0x2002
May  7 13:07:08 lvadp kernel: scsi: device set offline - not ready or
command retry failed after bus reset: host 2 channel 0 id 2 lun 0


-- 
=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
   Andrew Patterson                          Voice:  (970) 898-3261
   Hewlett-Packard Company                   Email:  andrew@fc.hp.com


