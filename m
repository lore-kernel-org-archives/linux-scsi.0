From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: aic7xxx dump interpretation
Date: Fri, 28 Jan 2005 10:44:17 -0500
Message-ID: <74A9A71929931E40967CA9F27B1D7396DC00D3@hdsmsx401.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr14.intel.com ([192.55.52.68]:43931 "EHLO
	fmsfmr002.fm.intel.com") by vger.kernel.org with ESMTP
	id S261317AbVA1Po0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2005 10:44:26 -0500
Received: from fmsfmr101.fm.intel.com (fmsfmr101.fm.intel.com [10.1.192.59])
	by fmsfmr002.fm.intel.com (8.12.10/8.12.10/d: major-outer.mc,v 1.1 2004/09/17 17:50:56 root Exp $) with ESMTP id j0SFiPfd002361
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2005 15:44:25 GMT
Received: from fmsmsxvs042.fm.intel.com (fmsmsxvs042.fm.intel.com [132.233.42.128])
	by fmsfmr101.fm.intel.com (8.12.10/8.12.10/d: major-inner.mc,v 1.2 2004/09/17 18:05:01 root Exp $) with SMTP id j0SFiP4L007833
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2005 15:44:25 GMT
Received: from fmsmsx331.amr.corp.intel.com ([132.233.42.156])
 by fmsmsxvs042.fm.intel.com (SAVSMTP 3.1.2.35) with SMTP id M2005012807442517803
 for <linux-scsi@vger.kernel.org>; Fri, 28 Jan 2005 07:44:25 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Folks,

I'm hoping that some of you can help me interpret the aic7xxx dump
messages from the syslog below.

This is from a customer system running a 2.4.18 kernel, with aic7xxx
driver version 6.2.36.
The scsi1:0:12:0 device with the error is ST336607LW, see
/proc/scsi/scsi info below.

I suspect that the root cause may be related to the fact that this is
apparently a U320 device on a U160 scsi adapter and  the tagged queue
depth may need to be less than 32, however, I'd like to know if the dump
confirms this, or points to something else.  

TIA,

Andy

----------/proc/scsi/scsi output-------------------------
Host: scsi0 Channel: 00 Id: 05 Lun: 00
  Vendor: HP       Model: C5683A           Rev: C111  Ser#:    9
  Type:   Sequential-Access                ANSI SCSI revision: 02
Host: scsi1 Channel: 00 Id: 12 Lun: 00
  Vendor: SEAGATE  Model: ST336607LW       Rev: 0007  Ser#: 3JA6HCS4
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: DotHill  Model: SANnet II SCSI   Rev: 0325  Ser#: 5B6D4164
  Type:   Direct-Access                    ANSI SCSI revision: 04
Host: scsi2 Channel: 00 Id: 01 Lun: 00
  Vendor: DotHill  Model: SANnet II SCSI   Rev: 0325  Ser#: 00000000
  Type:   Enclosure                        ANSI SCSI revision: 04

--------/var/log/messages dump output-------------
[...]
Dec 19 12:45:08 fsxgsn0 kernel: scsi1:0:12:0: Attempting to queue an
ABORT message
Dec 19 12:45:08 fsxgsn0 kernel: CDB: 0x2a 0x0 0x2 0x6e 0x4b 0xe2 0x0 0x4
0x0 0x0
Dec 19 12:45:08 fsxgsn0 kernel: scsi1: At time of recovery, card was not
paused
Dec 19 12:45:08 fsxgsn0 kernel: >>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
Dec 19 12:45:08 fsxgsn0 kernel: scsi1: Dumping Card State while idle, at
SEQADDR 0x9
Dec 19 12:45:08 fsxgsn0 kernel: Card was paused
Dec 19 12:45:08 fsxgsn0 kernel: ACCUM = 0x4, SINDEX = 0x64, DINDEX =
0x65, ARG_2 = 0x1
Dec 19 12:45:08 fsxgsn0 kernel: HCNT = 0x0 SCBPTR = 0x16
Dec 19 12:45:08 fsxgsn0 kernel: SCSIPHASE[0x0] SCSISIGI[0x0] ERROR[0x0]
SCSIBUSL[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel: LASTPHASE[0x1] SCSISEQ[0x12]
SBLKCTL[0xa] SCSIRATE[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel: SEQCTL[0x10] SEQ_FLAGS[0xc0] SSTAT0[0x0]
SSTAT1[0x8] 
Dec 19 12:45:08 fsxgsn0 kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
SIMODE1[0xa4] 
Dec 19 12:45:08 fsxgsn0 kernel: SXFRCTL0[0x80] DFCNTRL[0x0]
DFSTATUS[0x89] 
Dec 19 12:45:08 fsxgsn0 kernel: STACK: 0x0 0x16a 0x17f 0x3
Dec 19 12:45:08 fsxgsn0 kernel: SCB count = 66
Dec 19 12:45:08 fsxgsn0 kernel: Kernel NEXTQSCB = 44
Dec 19 12:45:08 fsxgsn0 kernel: Card NEXTQSCB = 44
Dec 19 12:45:08 fsxgsn0 kernel: QINFIFO entries: 
Dec 19 12:45:08 fsxgsn0 kernel: Waiting Queue entries: 
Dec 19 12:45:08 fsxgsn0 kernel: Disconnected Queue entries: 22:6 21:40
15:29 20:12 3:36 9:42 12:39 27:20 13:64 10:47 0:54 18:15 16:49 30:63
17:10 24:55 7:23 25:33 4:27 28:28 1:45 23:26 8:32 2:8 26:57 14:41 11:51
19:52 
Dec 19 12:45:08 fsxgsn0 kernel: QOUTFIFO entries: 
Dec 19 12:45:08 fsxgsn0 kernel: Sequencer Free SCB List: 5 6 29 31 
Dec 19 12:45:08 fsxgsn0 kernel: Sequencer SCB Info: 
Dec 19 12:45:08 fsxgsn0 kernel:   0 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x36] 
Dec 19 12:45:08 fsxgsn0 kernel:   1 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2d] 
Dec 19 12:45:08 fsxgsn0 kernel:   2 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x8] 
Dec 19 12:45:08 fsxgsn0 kernel:   3 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x24] 
Dec 19 12:45:08 fsxgsn0 kernel:   4 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1b] 
Dec 19 12:45:08 fsxgsn0 kernel:   5 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:08 fsxgsn0 kernel:   6 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:08 fsxgsn0 kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x17] 
Dec 19 12:45:08 fsxgsn0 kernel:   8 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x20] 
Dec 19 12:45:08 fsxgsn0 kernel:   9 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2a] 
Dec 19 12:45:08 fsxgsn0 kernel:  10 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2f] 
Dec 19 12:45:08 fsxgsn0 kernel:  11 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x33] 
Dec 19 12:45:08 fsxgsn0 kernel:  12 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x27] 
Dec 19 12:45:08 fsxgsn0 kernel:  13 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x40] 
Dec 19 12:45:08 fsxgsn0 kernel:  14 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x29] 
Dec 19 12:45:08 fsxgsn0 kernel:  15 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1d] 
Dec 19 12:45:08 fsxgsn0 kernel:  16 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x31] 
Dec 19 12:45:08 fsxgsn0 kernel:  17 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xa] 
Dec 19 12:45:08 fsxgsn0 kernel:  18 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xf] 
Dec 19 12:45:08 fsxgsn0 kernel:  19 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x34] 
Dec 19 12:45:08 fsxgsn0 kernel:  20 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xc] 
Dec 19 12:45:08 fsxgsn0 kernel:  21 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x28] 
Dec 19 12:45:08 fsxgsn0 kernel:  22 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x6] 
Dec 19 12:45:08 fsxgsn0 kernel:  23 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1a] 
Dec 19 12:45:08 fsxgsn0 kernel:  24 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x37] 
Dec 19 12:45:08 fsxgsn0 kernel:  25 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x21] 
Dec 19 12:45:08 fsxgsn0 kernel:  26 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x39] 
Dec 19 12:45:08 fsxgsn0 kernel:  27 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x14] 
Dec 19 12:45:08 fsxgsn0 kernel:  28 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1c] 
Dec 19 12:45:08 fsxgsn0 kernel:  29 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:08 fsxgsn0 kernel:  30 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x3f] 
Dec 19 12:45:08 fsxgsn0 kernel:  31 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:08 fsxgsn0 kernel: Pending list: 
Dec 19 12:45:08 fsxgsn0 kernel:   6 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  40 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  29 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  12 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  36 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  42 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  39 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  20 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  64 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  47 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  54 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  15 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  49 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  63 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  10 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  55 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  23 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  33 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  27 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  28 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  45 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  26 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  32 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:   8 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  57 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  41 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  51 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel:  52 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:08 fsxgsn0 kernel: Kernel Free SCB list: 7 31 48 4 43 50 13
1 30 62 16 3 0 17 65 24 53 5 56 22 58 34 38 21 9 2 59 19 11 37 61 46 18
25 14 35 60 
Dec 19 12:45:08 fsxgsn0 kernel: DevQ(0:12:0): 0 waiting
Dec 19 12:45:08 fsxgsn0 kernel: 
Dec 19 12:45:08 fsxgsn0 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Dec 19 12:45:08 fsxgsn0 kernel: (scsi1:A:12:0): Device is disconnected,
re-queuing SCB
Dec 19 12:45:08 fsxgsn0 kernel: Recovery code sleeping
Dec 19 12:45:08 fsxgsn0 kernel: (scsi1:A:12:0): Abort Tag Message Sent
Dec 19 12:45:13 fsxgsn0 kernel: Recovery code awake
Dec 19 12:45:13 fsxgsn0 kernel: Timer Expired
Dec 19 12:45:13 fsxgsn0 kernel: aic7xxx_abort returns 0x2003
Dec 19 12:45:13 fsxgsn0 kernel: scsi1:0:12:0: Attempting to queue an
ABORT message
Dec 19 12:45:13 fsxgsn0 kernel: CDB: 0x2a 0x0 0x2 0x6e 0x41 0x82 0x0 0x0
0x60 0x0
Dec 19 12:45:13 fsxgsn0 kernel: scsi1: At time of recovery, card was not
paused
Dec 19 12:45:13 fsxgsn0 kernel: >>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
Dec 19 12:45:13 fsxgsn0 kernel: scsi1: Dumping Card State in Message-out
phase, at SEQADDR 0x172
Dec 19 12:45:13 fsxgsn0 kernel: Card was paused
Dec 19 12:45:13 fsxgsn0 kernel: ACCUM = 0xa0, SINDEX = 0x61, DINDEX =
0xe4, ARG_2 = 0xd
Dec 19 12:45:13 fsxgsn0 kernel: HCNT = 0x0 SCBPTR = 0x13
Dec 19 12:45:13 fsxgsn0 kernel: SCSIPHASE[0x0] SCSISIGI[0xa4] ERROR[0x0]
SCSIBUSL[0xd] 
Dec 19 12:45:13 fsxgsn0 kernel: LASTPHASE[0xa0] SCSISEQ[0x12]
SBLKCTL[0xa] SCSIRATE[0xc2] 
Dec 19 12:45:13 fsxgsn0 kernel: SEQCTL[0x10] SEQ_FLAGS[0x40] SSTAT0[0x0]
SSTAT1[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel: SSTAT2[0x0] SSTAT3[0x0] SIMODE0[0x8]
SIMODE1[0xac] 
Dec 19 12:45:13 fsxgsn0 kernel: SXFRCTL0[0x88] DFCNTRL[0x0]
DFSTATUS[0x89] 
Dec 19 12:45:13 fsxgsn0 kernel: STACK: 0xe8 0x0 0x16a 0x17f
Dec 19 12:45:13 fsxgsn0 kernel: SCB count = 66
Dec 19 12:45:13 fsxgsn0 kernel: Kernel NEXTQSCB = 44
Dec 19 12:45:13 fsxgsn0 kernel: Card NEXTQSCB = 44
Dec 19 12:45:13 fsxgsn0 kernel: QINFIFO entries: 
Dec 19 12:45:13 fsxgsn0 kernel: Waiting Queue entries: 
Dec 19 12:45:13 fsxgsn0 kernel: Disconnected Queue entries: 22:6 21:40
15:29 20:12 3:36 9:42 12:39 27:20 13:64 10:47 0:54 18:15 16:49 30:63
17:10 24:55 7:23 25:33 4:27 28:28 1:45 23:26 8:32 2:8 26:57 14:41 11:51 
Dec 19 12:45:13 fsxgsn0 kernel: QOUTFIFO entries: 
Dec 19 12:45:13 fsxgsn0 kernel: Sequencer Free SCB List: 5 6 29 31 
Dec 19 12:45:13 fsxgsn0 kernel: Sequencer SCB Info: 
Dec 19 12:45:13 fsxgsn0 kernel:   0 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x36] 
Dec 19 12:45:13 fsxgsn0 kernel:   1 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2d] 
Dec 19 12:45:13 fsxgsn0 kernel:   2 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x8] 
Dec 19 12:45:13 fsxgsn0 kernel:   3 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x24] 
Dec 19 12:45:13 fsxgsn0 kernel:   4 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1b] 
Dec 19 12:45:13 fsxgsn0 kernel:   5 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:13 fsxgsn0 kernel:   6 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:13 fsxgsn0 kernel:   7 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x17] 
Dec 19 12:45:13 fsxgsn0 kernel:   8 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x20] 
Dec 19 12:45:13 fsxgsn0 kernel:   9 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2a] 
Dec 19 12:45:13 fsxgsn0 kernel:  10 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x2f] 
Dec 19 12:45:13 fsxgsn0 kernel:  11 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x33] 
Dec 19 12:45:13 fsxgsn0 kernel:  12 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x27] 
Dec 19 12:45:13 fsxgsn0 kernel:  13 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x40] 
Dec 19 12:45:13 fsxgsn0 kernel:  14 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x29] 
Dec 19 12:45:13 fsxgsn0 kernel:  15 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1d] 
Dec 19 12:45:13 fsxgsn0 kernel:  16 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x31] 
Dec 19 12:45:13 fsxgsn0 kernel:  17 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xa] 
Dec 19 12:45:13 fsxgsn0 kernel:  18 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xf] 
Dec 19 12:45:13 fsxgsn0 kernel:  19 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x34] 
Dec 19 12:45:13 fsxgsn0 kernel:  20 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xc] 
Dec 19 12:45:13 fsxgsn0 kernel:  21 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x28] 
Dec 19 12:45:13 fsxgsn0 kernel:  22 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x6] 
Dec 19 12:45:13 fsxgsn0 kernel:  23 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1a] 
Dec 19 12:45:13 fsxgsn0 kernel:  24 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x37] 
Dec 19 12:45:13 fsxgsn0 kernel:  25 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x21] 
Dec 19 12:45:13 fsxgsn0 kernel:  26 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x39] 
Dec 19 12:45:13 fsxgsn0 kernel:  27 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x14] 
Dec 19 12:45:13 fsxgsn0 kernel:  28 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x1c] 
Dec 19 12:45:13 fsxgsn0 kernel:  29 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:13 fsxgsn0 kernel:  30 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0x3f] 
Dec 19 12:45:13 fsxgsn0 kernel:  31 SCB_CONTROL[0xe0] SCB_SCSIID[0xc7]
SCB_LUN[0x0] SCB_TAG[0xff] 
Dec 19 12:45:13 fsxgsn0 kernel: Pending list: 
Dec 19 12:45:13 fsxgsn0 kernel:   6 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  40 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  29 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  12 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  36 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  42 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  39 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  20 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  64 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  47 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  54 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  15 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  49 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  63 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  10 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  55 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  23 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  33 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  27 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  28 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  45 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  26 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  32 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:   8 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  57 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  41 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  51 SCB_CONTROL[0x60] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel:  52 SCB_CONTROL[0x64] SCB_SCSIID[0xc7]
SCB_LUN[0x0] 
Dec 19 12:45:13 fsxgsn0 kernel: Kernel Free SCB list: 7 31 48 4 43 50 13
1 30 62 16 3 0 17 65 24 53 5 56 22 58 34 38 21 9 2 59 19 11 37 61 46 18
25 14 35 60 
Dec 19 12:45:13 fsxgsn0 kernel: DevQ(0:12:0): 0 waiting
Dec 19 12:45:13 fsxgsn0 kernel: 
Dec 19 12:45:13 fsxgsn0 kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends
>>>>>>>>>>>>>>>>>>
Dec 19 12:45:13 fsxgsn0 kernel: (scsi1:A:12:0): Device is disconnected,
re-queuing SCB
Dec 19 12:45:13 fsxgsn0 kernel: Recovery code sleeping
Dec 19 12:45:18 fsxgsn0 kernel: Recovery code awake
Dec 19 12:45:18 fsxgsn0 kernel: Timer Expired
Dec 19 12:45:18 fsxgsn0 kernel: aic7xxx_abort returns 0x2003
Dec 19 12:45:18 fsxgsn0 kernel: scsi1:0:12:0: Attempting to queue an
ABORT message
Dec 19 12:45:18 fsxgsn0 kernel: CDB: 0x2a 0x0 0x2 0x6e 0x41 0xea 0x0 0x1
0xf8 0x0
Dec 19 12:45:18 fsxgsn0 kernel: scsi1: At time of recovery, card was not
paused
Dec 19 12:45:18 fsxgsn0 kernel: >>>>>>>>>>>>>>>>>> Dump Card State
Begins <<<<<<<<<<<<<<<<<
[...]

