From: "JF" <jfilla@yahoo.com>
Subject: Scsi debug help requested. What's happening here?
Date: Mon, 26 Sep 2005 09:59:54 -0700
Message-ID: <dh99d6$9p2$1@sea.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:12481 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S932400AbVIZRYI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Sep 2005 13:24:08 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1EJwec-0002gV-OZ
	for linux-scsi@vger.kernel.org; Mon, 26 Sep 2005 19:20:39 +0200
Received: from dsl093-128-025.sfo4.dsl.speakeasy.net ([66.93.128.25])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2005 19:20:38 +0200
Received: from jfilla by dsl093-128-025.sfo4.dsl.speakeasy.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2005 19:20:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Good day,

I have an old Dell workstation running RedHat Enterprise 3 Rel5 with an
oboard Adaptec 7899 and an Adaptec 29160. The 29160 connects externally to a
Promise UltraTrak100 TX8 (external SCSI-to-ATA RAID). Inside the UltraTrak
there are 8 Western Digital WD120JB drives; this gives me about 833GB of
RAID5 storage:

SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec aic7899 Ultra160 SCSI adapter>
        aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs

blk: queue f7fc8618, I/O limit 4095Mb (mask 0xffffffff)
(scsi1:A:0): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
(scsi0:A:0): 80.000MB/s transfers (40.000MHz, offset 16, 16bit)
(scsi1:A:1): 160.000MB/s transfers (80.000MHz DT, offset 127, 16bit)
  Vendor: Promise   Model: 8 Disk RAID5      Rev: 1.10
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7fc8418, I/O limit 4095Mb (mask 0xffffffff)
scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 1626952320 512-byte hdwr sectors (833000 MB)
Partition check:
 sda: sda1
blk: queue f7fcb018, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: QUANTUM   Model: ATLAS10K2-TY367L  Rev: DA40
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7fcce18, I/O limit 4095Mb (mask 0xffffffff)
  Vendor: FUJITSU   Model: MAJ3364MP         Rev: 5509
  Type:   Direct-Access                      ANSI SCSI revision: 03
blk: queue f7fd6018, I/O limit 4095Mb (mask 0xffffffff)
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
Attached scsi disk sdc at scsi1, channel 0, id 1, lun 0
SCSI device sdb: 71132959 512-byte hdwr sectors (36420 MB)
 sdb: sdb1 sdb2 sdb3 < sdb5 sdb6 sdb7 sdb8 sdb9 >
SCSI device sdc: 71132959 512-byte hdwr sectors (36420 MB)
 sdc: sdc1
blk: queue f77c0c18, I/O limit 4095Mb (mask 0xffffffff)


Anyhooooo, twice in the past 2 weeks, the array has panicked (or caused the
kernel to panic) causing it to go offline. I haven't lost a byte of data;
rebooting both the array and the host clears everything up, but twice is now
a pattern for me. /var/log/messages has the following messages in it:

Sep 25 00:51:24 aztec kernel: scsi0:0:0:0: Attempting to queue an ABORT
message
Sep 25 00:51:24 aztec kernel: scsi0: At time of recovery, card was not
paused
Sep 25 00:51:24 aztec kernel: scsi0: Dumping Card State while idle, at
SEQADDR 0x9
Sep 25 00:51:24 aztec kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
SCSIBUSL[0x0]
Sep 25 00:51:24 aztec kernel: LASTPHASE[0x1] SCSISEQ[0x12] SBLKCTL[0xa]
SCSIRATE[0x0]
Sep 25 00:51:24 aztec kernel:   0 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x5]
Sep 25 00:51:24 aztec kernel:   1 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x16]
Sep 25 00:51:24 aztec kernel:   2 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x3]
Sep 25 00:51:24 aztec kernel:   3 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x1c]
Sep 25 00:51:24 aztec kernel:   4 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x12]
Sep 25 00:51:24 aztec kernel:   5 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x7]
Sep 25 00:51:24 aztec kernel:   6 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x17]
Sep 25 00:51:24 aztec kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x9]
Sep 25 00:51:24 aztec kernel:   8 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x14]
Sep 25 00:51:24 aztec kernel:   9 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x0]
Sep 25 00:51:24 aztec kernel:  10 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x1a]
Sep 25 00:51:24 aztec kernel:  11 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xf]
Sep 25 00:51:24 aztec kernel:  12 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x22]
Sep 25 00:51:24 aztec kernel:  13 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x8]
Sep 25 00:51:24 aztec kernel:  14 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x19]
Sep 25 00:51:24 aztec kernel:  15 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x18]
Sep 25 00:51:24 aztec kernel:  16 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x11]
Sep 25 00:51:24 aztec kernel:  17 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xc]
Sep 25 00:51:24 aztec kernel:  18 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x23]
Sep 25 00:51:24 aztec kernel:  19 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x1b]
Sep 25 00:51:24 aztec kernel:  20 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xe]
Sep 25 00:51:24 aztec kernel:  21 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x10]
Sep 25 00:51:24 aztec kernel:  22 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xb]
Sep 25 00:51:24 aztec kernel:  23 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xd]
Sep 25 00:51:24 aztec kernel:  24 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x1d]
Sep 25 00:51:24 aztec kernel:  25 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x13]
Sep 25 00:51:24 aztec kernel:  26 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x21]
Sep 25 00:51:24 aztec kernel:  27 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x2]
Sep 25 00:51:24 aztec kernel:  28 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x4]
Sep 25 00:51:24 aztec kernel:  29 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x1]
Sep 25 00:51:24 aztec kernel:  30 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0xa]
Sep 25 00:51:24 aztec kernel:  31 SCB_CONTROL[0x64] SCB_SCSIID[0x7]
SCB_LUN[0x0] SCB_TAG[0x15]
Sep 25 00:51:25 aztec kernel:   4 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  25 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   7 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  23 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   1 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   8 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  22 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  12 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   2 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  13 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   0 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  15 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  28 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   5 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  14 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  35 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  11 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  16 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  33 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   9 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  24 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:   3 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  21 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  34 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  19 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  26 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  29 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  10 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  18 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  27 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  17 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel:  20 SCB_CONTROL[0x60] SCB_SCSIID[0x7]
SCB_LUN[0x0]
Sep 25 00:51:25 aztec kernel: (scsi0:A:0:0): Device is disconnected,
re-queuing SCB
Sep 25 00:51:25 aztec kernel: (scsi0:A:0:0): Abort Tag Message Sent
Sep 25 00:51:25 aztec kernel: (scsi0:A:0:0): SCB 23 - Abort Tag Completed.
Sep 25 00:51:34 aztec kernel: scsi0:0:0:0: Attempting to queue an ABORT
message
Sep 25 00:51:34 aztec kernel: scsi0: At time of recovery, card was not
paused
Sep 25 00:51:34 aztec kernel: scsi0: Dumping Card State while idle, at
SEQADDR 0x16b
Sep 25 00:51:34 aztec kernel: SCSIPHASE[0x0] SCSISIGI[0x14] ERROR[0x0]
SCSIBUSL[0x0]
Sep 25 00:51:24 aztec kernel: scsi0:0:0:0: Attempting to queue an ABORT
message
Sep 25 00:51:24 aztec kernel: scsi0: At time of recovery, card was not
paused
Sep 25 00:51:24 aztec kernel: scsi0: Dumping Card State while idle, at
SEQADDR 0x9

and so on and so forth.

Due to the fact I am not a scsi engineer, I have no idea what the problem
is. I replace the 29160 the first time, but it happened again. I suspect the
obvious, that it, that the UltraTrak is the problem, but I cannot tell if it
is a drive in the array or if the whole unit is dying. The UltraTrak's
limited display says the array is 'functional.'

Is anyone out there able to make heads or tails of these kernel messages?
I'd really appreciate it.

Thanks,

JF



