From: Patrick Michael Kane <modus@pr.es.to>
Subject: Repeat: Reproducible aic7xxx "Attempting to queue an ABORT message" after full hardware swapout
Date: Sun, 2 Nov 2003 14:02:42 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031102140242.A1099@pr.es.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isaac.asimov.net ([208.185.231.103]:29077 "HELO
	isaac.asimov.net") by vger.kernel.org with SMTP id S261838AbTKBWCn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Nov 2003 17:02:43 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi:

I sent the message below and have not gotten any feedback.  What
additional information can I provide or how can I improve the bug
report to make it easier for someone to assist?  Thanks!

----- Begin forwarded message -----

I have an x86 dual Intel Xeon system (Dell PowerEdge 2650) with an
Adaptec 39160 SCSI card.  The card is hooked up to a Dell PowerVault
132T tape robot, which has the robot as SCSI ID 0 and the tape drive
as SCSI ID 1.

We are running RH7.3, with the latest kernel errata
(2.4.20-20.7bigmem).

Whenever we load media into or out of the drive, We get the following
error:

Oct 23 14:57:21 db02 kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
Oct 23 14:57:21 db02 kernel: scsi1: Dumping Card State while idle, at SEQADDR 0x8

(full error below my signature)

This error is 100% reproducible.  Sometimes the bus recovers and the
device sticks around.  Sometimes it doesn't and we have to remove and
reload the aic7xxx driver to get it back.

Today, Dell swapped out every piece of equipment, except the server
(39160, cables, terminators, chassis and SDLT drive) and we are still
seeing the problem.

I have also tried the most recent version of the driver from Justin
Gibb's site, with the same result.

If anyone has thoughts, I'm all ears.  I'm just trying to anticipate
the Linux fingerpointing that will begin tomorrow from Dell.

Thanks in advance for any help!

Best,
-- 
Patrick Michael Kane
<modus@pr.es.to>

Oct 23 14:57:21 db02 kernel: scsi1:0:0:0: Attempting to queue an ABORT
message
Oct 23 14:57:21 db02 kernel: scsi1: Dumping Card State while idle, at
SEQADDR 0x8
Oct 23 14:57:21 db02 kernel: ACCUM = 0x4, SINDEX = 0x7, DINDEX = 0x21,
ARG_2 = 0x0
Oct 23 14:57:21 db02 kernel: HCNT = 0x0 SCBPTR = 0x0
Oct 23 14:57:21 db02 kernel: SCSISEQ = 0x12, SBLKCTL = 0xa
Oct 23 14:57:21 db02 kernel:  DFCNTRL = 0x0, DFSTATUS = 0x89
Oct 23 14:57:21 db02 kernel: LASTPHASE = 0x1, SCSISIGI = 0x0, SXFRCTL0
= 0x80
Oct 23 14:57:21 db02 kernel: SSTAT0 = 0x0, SSTAT1 = 0x8
Oct 23 14:57:21 db02 kernel: SCSIPHASE = 0x0
Oct 23 14:57:21 db02 kernel: STACK == 0x3, 0x17c, 0x167, 0xee
Oct 23 14:57:21 db02 kernel: SCB count = 4
Oct 23 14:57:21 db02 kernel: Kernel NEXTQSCB = 3
Oct 23 14:57:21 db02 kernel: Card NEXTQSCB = 3
Oct 23 14:57:21 db02 kernel: QINFIFO entries: 
Oct 23 14:57:21 db02 kernel: Waiting Queue entries: 
Oct 23 14:57:21 db02 kernel: Disconnected Queue entries: 0:2 
Oct 23 14:57:21 db02 kernel: QOUTFIFO entries: 
Oct 23 14:57:21 db02 kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8
9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Oct 23 14:57:21 db02 kernel: Sequencer SCB Info: 0(c 0x44, s 0x7, l 0,
t 0x2) 1(c 0x0, s 0xff, l 255, t 0xff) 2(c 0x0, s 0xff, l 255, t 0xff)
3(c 0x0, s 0xff, l 255, t 0xff) 4(c 0x0, s 0xff, l 255, t 0xff) 5(c
0x0, s 0xff, l 255, t 0xff) 6(c 0x0, s 0xff, l 255, t 0xff) 7(c 0x0, s
0xff, l 255, t 0xff) 8(c 0x0, s 0xff, l 255, t 0xff) 9(c 0x0, s 0xff,
l 255, t 0xff) 10(c 0x0, s 0xff, l 255, t 0xff) 11(c 0x0, s 0xff, l
255, t 0xff) 12(c 0x0, s 0xff, l 255, t 0xff) 13(c 0x0, s 0xff, l 255,
t 0xff) 14(c 0x0, s 0xff, l 255, t 0xff) 15(c 0x0, s 0xff, l 255, t
0xff) 16(c 0x0, s 0xff, l 255, t 0xff) 17(c 0x0, s 0xff, l 255, t
0xff) 18(c 0x0, s 0xff, l 255, t 0xff) 19(c 0x0, s 0xff, l 255, t
0xff) 20(c 0x0, s 0xff, l 255, t 0xff) 21(c 0x0, s 0xff, l 255, t
0xff) 22(c 0x0, s 0xff, l 255, t 0xff) 23(c 0x0, s 0xff, l 255, t
0xff) 24(c 0x0, s 0xff, l 255, t 0xff) 25(c 0x0, s 0xff, l 255, t
0xff) 26(c 0x0, s 0xff, l 255, t 0xff) 27(c 0x0, s 0xff, l 255, t
0xff) 28(c 0x0, s 0xff, l 255, t 0xff) 29(c 0x0, s 0xff, l 255, t 0xff
Oct 23 14:57:21 db02 kernel:  30(c 0x0, s 0xff, l 255, t 0xff) 31(c
0x0, s 0xff, l 255, t 0xff) 
Oct 23 14:57:21 db02 kernel: Pending list: 2(c 0x40, s 0x7, l 0)
Oct 23 14:57:21 db02 kernel: Kernel Free SCB list: 1 0 
Oct 23 14:57:21 db02 kernel: Untagged Q(0): 2 
Oct 23 14:57:21 db02 kernel: DevQ(0:0:0): 0 waiting
Oct 23 14:57:21 db02 kernel: DevQ(0:1:0): 0 waiting
Oct 23 14:57:21 db02 kernel: (scsi1:A:0:0): Queuing a recovery SCB
Oct 23 14:57:21 db02 kernel: scsi1:0:0:0: Device is disconnected,
re-queuing SCB
Oct 23 14:57:21 db02 kernel: (scsi1:A:0:0): Abort Message Sent
Oct 23 14:57:21 db02 kernel: Recovery code sleeping
Oct 23 14:57:22 db02 kernel: (scsi1:A:0:0): SCB 2 - Abort Completed.
Oct 23 14:57:22 db02 kernel: Recovery SCB completes
Oct 23 14:57:22 db02 kernel: Recovery code awake
Oct 23 14:57:22 db02 kernel: aic7xxx_abort returns 0x2002
Oct 23 14:57:24 db02 kernel: scsi1:0:0:0: Attempting to queue a TARGET
RESET message
Oct 23 14:57:24 db02 kernel: scsi1:0:0:0: Command not found
Oct 23 14:57:24 db02 kernel: aic7xxx_dev_reset returns 0x2002
Oct 23 14:57:30 db02 kernel: (scsi1:A:1): 80.000MB/s transfers
(40.000MHz, offset 62, 16bit)

