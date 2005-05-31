From: =?ISO-8859-2?Q?Martin_MOKREJ=A9?= <mmokrejs@ribosome.natur.cuni.cz>
Subject: Attempting to queue an ABORT message
Date: Tue, 31 May 2005 13:08:57 +0200
Message-ID: <429C45C9.4040708@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ribosome.natur.cuni.cz ([195.113.57.20]:14292 "EHLO
	ribosome.natur.cuni.cz") by vger.kernel.org with ESMTP
	id S261849AbVEaLI7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 May 2005 07:08:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,
  could someone explain me meaning of teh below debug messages?
The disk sdb went wrong because of bad media. However, I observe
weird scsi-card errors. We had to re-generate parity on RAID5 disks
in the array, although the disk which broke was NRAID disk:


Setting Global Tags= 32
scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 29160 Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.36
        <Adaptec 29160B Ultra160 SCSI adapter>
        aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs

blk: queue f73eaa18, I/O limit 524287Mb (mask 0x7fffffffff)
(scsi2:A:0): 160.000MB/s transfers (80.000MHz DT, offset 62, 16bit)
(scsi1:A:4): 80.000MB/s transfers (40.000MHz, offset 62, 16bit)
(scsi1:A:6): 20.000MB/s transfers (10.000MHz, offset 15, 16bit)
  Vendor: QUANTUM   Model: SuperDLT1         Rev: 4646
  Type:   Sequential-Access                  ANSI SCSI revision: 02
blk: queue f73ea818, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: OVERLAND  Model: LXB               Rev: 0106
  Type:   Medium Changer                     ANSI SCSI revision: 02
blk: queue f704f418, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
  Type:   Direct-Access                      ANSI SCSI revision: 04
blk: queue f704fa18, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
  Type:   Direct-Access                      ANSI SCSI revision: 04
blk: queue f73ea418, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
  Type:   Direct-Access                      ANSI SCSI revision: 04
blk: queue f6fadc18, I/O limit 524287Mb (mask 0x7fffffffff)
  Vendor: ADVUNI    Model: OXYGENRAID 3000R  Rev: 327J
  Type:   Direct-Access                      ANSI SCSI revision: 04
blk: queue f6fada18, I/O limit 524287Mb (mask 0x7fffffffff)
scsi2:A:0:0: Tagged Queuing enabled.  Depth 32
scsi2:A:0:1: Tagged Queuing enabled.  Depth 32
scsi2:A:0:2: Tagged Queuing enabled.  Depth 32
scsi2:A:0:3: Tagged Queuing enabled.  Depth 32
st: Version 20040102, bufsize 32768, max init. bufs 4, s/g segs 16
Attached scsi tape st0 at scsi1, channel 0, id 4, lun 0
Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 1
Attached scsi disk sdd at scsi2, channel 0, id 0, lun 2
Attached scsi disk sde at scsi2, channel 0, id 0, lun 3
SCSI device sdb: 245760000 512-byte hdwr sectors (125829 MB)
 /dev/scsi/host2/bus0/target0/lun0: p1
SCSI device sdc: 40989184 512-byte hdwr sectors (20986 MB)
 /dev/scsi/host2/bus0/target0/lun1: p1
SCSI device sdd: 1638400000 512-byte hdwr sectors (838861 MB)
 /dev/scsi/host2/bus0/target0/lun2: p1
SCSI device sde: 651395072 512-byte hdwr sectors (333514 MB)
 /dev/scsi/host2/bus0/target0/lun3: p1

The disk sdb1 went wrong because of bad media. However, I observe
weird scsi-card errors:

scsi1:0:4:0: Attempting to queue an ABORT message
CDB: 0x12 0x0 0x0 0x0 0x32 0x0
scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State in Message-out phase, at SEQADDR 0x36
Card was paused
ACCUM = 0xa0, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0
SCSIPHASE[0x4] SCSISIGI[0xb6] ERROR[0x0] SCSIBUSL[0x0] 
LASTPHASE[0xa0] SCSISEQ[0x12] SBLKCTL[0xa] SCSIRATE[0x93] 
SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x2] SSTAT1[0x11] 
SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
SXFRCTL0[0x88] DFCNTRL[0x0] DFSTATUS[0x89] 
STACK: 0x0 0x16a 0x17f 0x34
SCB count = 6
Kernel NEXTQSCB = 4
Card NEXTQSCB = 4
QINFIFO entries: 
Waiting Queue entries: 
Disconnected Queue entries: 
QOUTFIFO entries: 
Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Sequencer SCB Info: 
  0 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0x3] 
  1 SCB_CONTROL[0xc0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff] 
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Pending list: 
  3 SCB_CONTROL[0x40] SCB_SCSIID[0x47] SCB_LUN[0x0] 
Kernel Free SCB list: 5 2 1 0 
Untagged Q(4): 3 
DevQ(0:4:0): 0 waiting
DevQ(0:6:0): 0 waiting

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi1:0:4:0: Device is active, asserting ATN
Recovery code sleeping
(scsi1:A:4:0): Abort Message Sent
(scsi1:A:4:0): SCB 3 - Abort Completed.
Recovery SCB completes
Recovery code awake
aic7xxx_abort returns 0x2002
scsi1:0:6:0: Attempting to queue an ABORT message
CDB: 0x12 0x0 0x0 0x0 0x32 0x0
Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State while idle, at SEQADDR 0x18
Card was paused
ACCUM = 0x3, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0
SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
STACK: 0xe8 0x16a 0x17f 0x17
SCB count = 6
Kernel NEXTQSCB = 5
Card NEXTQSCB = 5
QINFIFO entries: 
Waiting Queue entries: 0:3 
Disconnected Queue entries: 
QOUTFIFO entries: 
Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Sequencer SCB Info: 
  0 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0x3] 
  1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Pending list: 
  3 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Kernel Free SCB list: 4 2 1 0 
Untagged Q(6): 3 
DevQ(0:4:0): 0 waiting
DevQ(0:6:0): 0 waiting

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi1:0:6:0: Cmd aborted from QINFIFO
aic7xxx_abort returns 0x2002
scsi1:0:6:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State while idle, at SEQADDR 0x18
Card was paused
ACCUM = 0x3, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0
SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
STACK: 0xe8 0x16a 0x17f 0x17
SCB count = 6
Kernel NEXTQSCB = 3
Card NEXTQSCB = 5
QINFIFO entries: 5 
Waiting Queue entries: 
Disconnected Queue entries: 
QOUTFIFO entries: 
Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Sequencer SCB Info: 
  0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff] 
  1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Pending list: 
  5 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Kernel Free SCB list: 4 2 1 0 
Untagged Q(6): 5 
DevQ(0:4:0): 0 waiting
DevQ(0:6:0): 0 waiting

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi1:0:6:0: Cmd aborted from QINFIFO
aic7xxx_abort returns 0x2002
scsi1:0:6:0: Attempting to queue a TARGET RESET message
CDB: 0x12 0x0 0x0 0x0 0x32 0x0
scsi1:0:6:0: Command not found
aic7xxx_dev_reset returns 0x2002
scsi1:0:6:0: Attempting to queue an ABORT message
CDB: 0x0 0x0 0x0 0x0 0x0 0x0
Infinite interrupt loop, INTSTAT = 0scsi1: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi1: Dumping Card State while idle, at SEQADDR 0x18
Card was paused
ACCUM = 0x3, SINDEX = 0x48, DINDEX = 0xe4, ARG_2 = 0x0
HCNT = 0x0 SCBPTR = 0x0
SCSIPHASE[0x0] SCSISIGI[0x18] ERROR[0x0] SCSIBUSL[0x0] 
LASTPHASE[0x1] SCSISEQ[0x1a] SBLKCTL[0xa] SCSIRATE[0x0] 
SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x10] SSTAT1[0x8] 
SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8] SIMODE1[0xac] 
SXFRCTL0[0x80] DFCNTRL[0x0] DFSTATUS[0x89] 
STACK: 0xe8 0x16a 0x17f 0x17
SCB count = 6
Kernel NEXTQSCB = 5
Card NEXTQSCB = 3
QINFIFO entries: 3 
Waiting Queue entries: 
Disconnected Queue entries: 
QOUTFIFO entries: 
Sequencer Free SCB List: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 
Sequencer SCB Info: 
  0 SCB_CONTROL[0x0] SCB_SCSIID[0x67] SCB_LUN[0x0] SCB_TAG[0xff] 
  1 SCB_CONTROL[0xc0] SCB_SCSIID[0x47] SCB_LUN[0x0] SCB_TAG[0xff] 
  2 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  3 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  4 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  5 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  6 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  7 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  8 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
  9 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 10 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 11 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 12 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 13 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 14 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 15 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 16 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 17 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 18 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 19 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 20 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 21 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 22 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 23 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 24 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 25 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 26 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 27 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 28 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 29 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 30 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
 31 SCB_CONTROL[0x0] SCB_SCSIID[0xff] SCB_LUN[0xff] SCB_TAG[0xff] 
Pending list: 
  3 SCB_CONTROL[0x40] SCB_SCSIID[0x67] SCB_LUN[0x0] 
Kernel Free SCB list: 4 2 1 0 
Untagged Q(6): 3 
DevQ(0:4:0): 0 waiting
DevQ(0:6:0): 0 waiting

<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi1:0:6:0: Cmd aborted from QINFIFO
aic7xxx_abort returns 0x2002

# lspci
0000:00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub (rev 01)ernel-headers=/usr/src/linux-2.4.30-pre2-bk3 -
0000:00:00.1 Class ff00: Intel Corporation E7500/E7501 Host RASUM Controller (rev 01)-new-config --enable-debug-kernel --enabl
0000:00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C PCI-to-PCI Bridge (rev 01)
0000:00:03.1 Class ff00: Intel Corporation E7500/E7501 Hub Interface C RASUM Controller (rev 01)
0000:00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #1) (rev 02)
0000:00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #2) (rev 02)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42)
0000:00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface Controller (rev 02)
0000:00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage Controller (rev 02)
0000:00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
0000:01:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27)
0000:02:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
0000:02:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04)
0000:02:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04)
0000:02:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 04)
0000:03:07.0 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
0000:03:07.1 Ethernet controller: Intel Corporation 82546EB Gigabit Ethernet Controller (Copper) (rev 01)
0000:03:08.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
0000:04:08.0 RAID bus controller: Intel Corporation RAID Controller
0000:04:09.0 SCSI storage controller: Adaptec AIC-7892A U160/m (rev 02)
# cat /proc/scsi/scsi 
Attached devices: 
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: Intel    Model: Host Drive  #00  Rev:     
  Type:   Direct-Access                    ANSI SCSI revision: 02
Host: scsi0 Channel: 02 Id: 06 Lun: 00
  Vendor: ESG-SHV  Model: SCA HSBP M16     Rev: 0.05
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 04 Lun: 00
  Vendor: QUANTUM  Model: SuperDLT1        Rev: 4646
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 06 Lun: 00
  Vendor: OVERLAND Model: LXB              Rev: 0106
  Type:   Medium Changer                   ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 00 Lun: 01
  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 00 Lun: 02
  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 00 Lun: 03
  Vendor: ADVUNI   Model: OXYGENRAID 3000R Rev: 327J
  Type:   Direct-Access                    ANSI SCSI revision: 04
#
# uname -a
Linux oxygen 2.4.30-pre2-bk3 #3 SMP Mon Mar 7 13:35:40 MET 2005 i686 Intel(R) Xeon(TM) CPU 3.06GHz GenuineIntel GNU/Linux

Thanks for help
Martin
