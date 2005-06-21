From: Yogesh Bhanu <yogesh@gsf.de>
Subject: Adpatec AIC7xxx problems
Date: Tue, 21 Jun 2005 12:47:38 +0200
Message-ID: <42B7F04A.3090309@gsf.de>
Reply-To: yogesh@gsf.de
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta2.gsf.de ([146.107.4.111]:29069 "EHLO mta2.gsf.de")
	by vger.kernel.org with ESMTP id S261160AbVFUKre (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 06:47:34 -0400
Received: from [146.107.217.179] (cavy.gsf.de [146.107.217.179])
	by mta2.gsf.de (Postfix) with ESMTP id 9E6285382F
	for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2005 12:47:33 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi ,
      I had posted a similar message sometime back on linux-kernel mailing list .
So here it goes again .
After I have switched to 2.6  from 2.4 kernel . My adaptec controller has panics
under load .
I have got the vendor to replace almost all of the SCSI components. but still it
panics .
Now I have upgraded to kernel version 2.6.12 and still I get panic under load.
So I think it is a driver issue.

The system under question is Dual Xeon 2.4Ghz with 6 GB RAM hosting an external
infortrend raid system on an Adaptec 3960D Ultra160.
Any pointers to fix the issue will be of great help .

I get error messages on scsi bus .

Jun 18 23:15:46 mips-nas kernel: Error handler scsi_eh_1 waking up
Jun 18 23:15:46 mips-nas kernel: scsi_eh_prt_fail_stats: 1:0:1:0 cmds failed: 0, 
cancel: 1
Jun 18 23:15:46 mips-nas kernel: Total of 1 commands on 1 devices require eh work
Jun 18 23:15:46 mips-nas kernel: scsi_eh_1: aborting cmd:0xf6fc1380
Jun 18 23:15:46 mips-nas kernel: scsi1:0:1:0: Attempting to queue an ABORT message
Jun 18 23:15:46 mips-nas kernel: CDB: 0x2a 0x0 0x0 0x23 0xf5 0xc7 0x0 0x0 0x8 0x0
Jun 18 23:15:46 mips-nas kernel: scsi1: At time of recovery, card was not paused
Jun 18 23:15:46 mips-nas kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Jun 18 23:15:46 mips-nas kernel: scsi1: Dumping Card State while idle, at 
SEQADDR 0x9
Jun 18 23:15:46 mips-nas kernel: Card was paused
Jun 18 23:15:46 mips-nas kernel: ACCUM = 0x4, SINDEX = 0x64, DINDEX = 0x65, 
ARG_2 = 0x0
Jun 18 23:15:46 mips-nas kernel: HCNT = 0x0 SCBPTR = 0x0
Jun 18 23:15:46 mips-nas kernel: SCSIPHASE[0x0] SCSISIGI[0x48]:(SELI|IOI) ERROR[0x0]
Jun 18 23:15:46 mips-nas kernel: SCSIBUSL[0x2] LASTPHASE[0x1]:(P_BUSFREE) 
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Jun 18 23:15:46 mips-nas kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
SEQCTL[0x10]:(FASTMODE)
Jun 18 23:15:46 mips-nas kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) 
SSTAT0[0x0]
Jun 18 23:15:46 mips-nas kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0] SSTAT3[0x0] 
SIMODE0[0x8]:(ENSWRAP)
Jun 18 23:15:46 mips-nas kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Jun 18 23:15:46 mips-nas kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Jun 18 23:15:46 mips-nas kernel: STACK: 0x0 0x16a 0x17f 0x3
Jun 18 23:15:46 mips-nas kernel: SCB count = 4
Jun 18 23:15:46 mips-nas kernel: Kernel NEXTQSCB = 2
Jun 18 23:15:46 mips-nas kernel: Card NEXTQSCB = 2
Jun 18 23:15:46 mips-nas kernel: QINFIFO entries:
Jun 18 23:15:46 mips-nas kernel: Waiting Queue entries:
Jun 18 23:15:46 mips-nas kernel: Disconnected Queue entries: 0:3
Jun 18 23:15:46 mips-nas kernel: QOUTFIFO entries:
Jun 18 23:15:46 mips-nas kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Jun 18 23:15:46 mips-nas kernel: Sequencer SCB Info:
Jun 18 23:15:46 mips-nas kernel:   0 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x17]
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0x0] SCB_TAG[0x3]
Jun 18 23:15:46 mips-nas kernel:   1 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   2 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   3 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   4 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   5 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   6 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   7 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   8 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:   9 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  10 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  11 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  12 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  13 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  14 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  15 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  16 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  17 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  18 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  19 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  20 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  21 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  22 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  23 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  24 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  25 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  26 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  27 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  28 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  29 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  30 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel:  31 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:15:46 mips-nas kernel: Pending list:
Jun 18 23:15:46 mips-nas kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x17]
Jun 18 23:15:46 mips-nas kernel: SCB_LUN[0x0]
Jun 18 23:15:46 mips-nas kernel: Kernel Free SCB list: 1 0
Jun 18 23:15:46 mips-nas kernel: Untagged Q(1): 3
Jun 18 23:15:46 mips-nas kernel:
Jun 18 23:15:46 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:15:46 mips-nas kernel: Recovery code sleeping
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): SCB 3 - Abort Tag Completed.
Jun 18 23:15:46 mips-nas kernel: Recovery SCB completes
Jun 18 23:15:46 mips-nas kernel: Recovery code awake
Jun 18 23:15:46 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:15:46 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:15:46 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_1: flush retry cmd: f6fc1380
Jun 18 23:15:46 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:15:46 mips-nas kernel: Error handler scsi_eh_1 sleeping
Jun 18 23:16:29 mips-nas kernel: Error handler scsi_eh_1 waking up
Jun 18 23:16:29 mips-nas kernel: scsi_eh_prt_fail_stats: 1:0:1:0 cmds failed: 0, 
cancel: 1
Jun 18 23:16:29 mips-nas kernel: Total of 1 commands on 1 devices require eh work
Jun 18 23:16:29 mips-nas kernel: scsi_eh_1: aborting cmd:0xf6fc1380
Jun 18 23:16:29 mips-nas kernel: scsi1:0:1:0: Attempting to queue an ABORT message
Jun 18 23:16:29 mips-nas kernel: CDB: 0x2a 0x0 0x0 0x23 0xf5 0xc7 0x0 0x0 0x8 0x0
Jun 18 23:16:29 mips-nas kernel: scsi1: At time of recovery, card was not paused
Jun 18 23:16:29 mips-nas kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Jun 18 23:16:29 mips-nas kernel: scsi1: Dumping Card State while idle, at 
SEQADDR 0x9
Jun 18 23:16:29 mips-nas kernel: Card was paused
Jun 18 23:16:29 mips-nas kernel: ACCUM = 0x4, SINDEX = 0x64, DINDEX = 0x65, 
ARG_2 = 0x0
Jun 18 23:16:29 mips-nas kernel: HCNT = 0x0 SCBPTR = 0x0
Jun 18 23:16:29 mips-nas kernel: SCSIPHASE[0x0] SCSISIGI[0x48]:(SELI|IOI) ERROR[0x0]
Jun 18 23:16:29 mips-nas kernel: SCSIBUSL[0x2] LASTPHASE[0x1]:(P_BUSFREE) 
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Jun 18 23:16:29 mips-nas kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
SEQCTL[0x10]:(FASTMODE)
Jun 18 23:16:29 mips-nas kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) 
SSTAT0[0x0]
Jun 18 23:16:29 mips-nas kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0] SSTAT3[0x0] 
SIMODE0[0x8]:(ENSWRAP)
Jun 18 23:16:29 mips-nas kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Jun 18 23:16:29 mips-nas kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Jun 18 23:16:29 mips-nas kernel: STACK: 0xe8 0x16a 0x17f 0x3
Jun 18 23:15:46 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:15:46 mips-nas kernel: Recovery code sleeping
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:15:46 mips-nas kernel: (scsi1:A:1:0): SCB 3 - Abort Tag Completed.
Jun 18 23:15:46 mips-nas kernel: Recovery SCB completes
Jun 18 23:15:46 mips-nas kernel: Recovery code awake
Jun 18 23:15:46 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:15:46 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:15:46 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:15:46 mips-nas kernel: scsi_eh_1: flush retry cmd: f6fc1380
Jun 18 23:15:46 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:15:46 mips-nas kernel: Error handler scsi_eh_1 sleeping
Jun 18 23:16:29 mips-nas kernel: Error handler scsi_eh_1 waking up
Jun 18 23:16:29 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:16:29 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:16:29 mips-nas kernel: Recovery code sleeping
Jun 18 23:16:29 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:16:29 mips-nas kernel: (scsi1:A:1:0): SCB 3 - Abort Tag Completed.
Jun 18 23:16:29 mips-nas kernel: Recovery SCB completes
Jun 18 23:16:29 mips-nas kernel: Recovery code awake
Jun 18 23:16:29 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:16:29 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:16:29 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:16:29 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:16:29 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:16:29 mips-nas kernel: scsi_eh_1: flush retry cmd: f6fc1380
Jun 18 23:16:29 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:16:29 mips-nas kernel: Error handler scsi_eh_1 sleeping

Jun 18 23:17:06 mips-nas kernel: SCB count = 4
Jun 18 23:17:06 mips-nas kernel: Kernel NEXTQSCB = 3
Jun 18 23:17:06 mips-nas kernel: Card NEXTQSCB = 3
Jun 18 23:17:06 mips-nas kernel: QINFIFO entries:
Jun 18 23:17:06 mips-nas kernel: Waiting Queue entries:
Jun 18 23:17:06 mips-nas kernel: Disconnected Queue entries: 0:2
Jun 18 23:17:06 mips-nas kernel: QOUTFIFO entries:
Jun 18 23:17:06 mips-nas kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Jun 18 23:17:06 mips-nas kernel: Sequencer SCB Info:
Jun 18 23:17:06 mips-nas kernel:   0 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x17]
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0x0] SCB_TAG[0x2]
Jun 18 23:17:06 mips-nas kernel:   1 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   2 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   3 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   4 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   5 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   6 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   7 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   8 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:   9 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  10 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  11 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  12 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  13 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  14 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  15 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  16 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  17 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  18 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  19 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  20 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  21 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  22 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  23 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  24 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  25 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  26 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  27 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  28 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  29 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  30 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel:  31 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:06 mips-nas kernel: Pending list:
Jun 18 23:17:06 mips-nas kernel:   2 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x17]
Jun 18 23:17:06 mips-nas kernel: SCB_LUN[0x0]
Jun 18 23:17:06 mips-nas kernel: Kernel Free SCB list: 1 0
Jun 18 23:17:06 mips-nas kernel: Untagged Q(1): 2
Jun 18 23:17:06 mips-nas kernel:
Jun 18 23:17:06 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:17:06 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:17:06 mips-nas kernel: Recovery code sleeping
Jun 18 23:17:06 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:17:06 mips-nas kernel: (scsi1:A:1:0): SCB 2 - Abort Tag Completed.
Jun 18 23:17:06 mips-nas kernel: Recovery SCB completes
Jun 18 23:17:06 mips-nas kernel: Recovery code awake
Jun 18 23:17:06 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:17:06 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:17:06 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:17:06 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:17:06 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:17:06 mips-nas kernel: scsi_eh_1: flush retry cmd: f6fc1380
Jun 18 23:17:06 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:17:06 mips-nas kernel: Error handler scsi_eh_1 sleeping
Jun 18 23:17:40 mips-nas kernel: Error handler scsi_eh_1 waking up
Jun 18 23:17:40 mips-nas kernel: scsi_eh_prt_fail_stats: 1:0:1:0 cmds failed: 0, 
cancel: 1
Jun 18 23:17:40 mips-nas kernel: Total of 1 commands on 1 devices require eh work
Jun 18 23:17:40 mips-nas kernel: scsi_eh_1: aborting cmd:0xf6fc1380
Jun 18 23:17:40 mips-nas kernel: scsi1:0:1:0: Attempting to queue an ABORT message
Jun 18 23:17:40 mips-nas kernel: CDB: 0x2a 0x0 0x0 0x23 0xf5 0xc7 0x0 0x0 0x8 0x0
Jun 18 23:17:40 mips-nas kernel: scsi1: At time of recovery, card was not paused
Jun 18 23:17:40 mips-nas kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Jun 18 23:17:40 mips-nas kernel: scsi1: Dumping Card State while idle, at 
SEQADDR 0x9
Jun 18 23:17:40 mips-nas kernel: Card was paused
Jun 18 23:17:40 mips-nas kernel: ACCUM = 0x4, SINDEX = 0x64, DINDEX = 0x65, 
ARG_2 = 0x0
Jun 18 23:17:40 mips-nas kernel: HCNT = 0x0 SCBPTR = 0x0
Jun 18 23:17:40 mips-nas kernel: SCSIPHASE[0x0] SCSISIGI[0x48]:(SELI|IOI) ERROR[0x0]
Jun 18 23:17:40 mips-nas kernel: SCSIBUSL[0x2] LASTPHASE[0x1]:(P_BUSFREE) 
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Jun 18 23:17:40 mips-nas kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
SEQCTL[0x10]:(FASTMODE)
Jun 18 23:17:40 mips-nas kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) 
SSTAT0[0x0]
Jun 18 23:17:40 mips-nas kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0] SSTAT3[0x0] 
SIMODE0[0x8]:(ENSWRAP)
Jun 18 23:17:40 mips-nas kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Jun 18 23:17:40 mips-nas kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Jun 18 23:17:40 mips-nas kernel: STACK: 0xe8 0x16a 0x17f 0x3
Jun 18 23:17:40 mips-nas kernel: SCB count = 4
Jun 18 23:17:40 mips-nas kernel: Kernel NEXTQSCB = 2
Jun 18 23:17:40 mips-nas kernel: Card NEXTQSCB = 2
Jun 18 23:17:40 mips-nas kernel: QINFIFO entries:
Jun 18 23:17:40 mips-nas kernel: Waiting Queue entries:
Jun 18 23:17:40 mips-nas kernel: Disconnected Queue entries: 0:3
Jun 18 23:17:40 mips-nas kernel: QOUTFIFO entries:
Jun 18 23:17:40 mips-nas kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Jun 18 23:17:40 mips-nas kernel: Sequencer SCB Info:
Jun 18 23:17:40 mips-nas kernel:   0 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x17]
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0x0] SCB_TAG[0x3]
Jun 18 23:17:40 mips-nas kernel:   1 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   2 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   3 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   4 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID) Jun 18 23:17:40 mips-nas kernel:   6 
SCB_CONTROL[0x0] SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   7 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   8 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:   9 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  10 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  11 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  12 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  13 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  14 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  15 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  16 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  17 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  18 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  19 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  20 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  21 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  22 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  23 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  24 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  25 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  26 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  27 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  28 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  29 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  30 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel:  31 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:17:40 mips-nas kernel: Pending list:
Jun 18 23:17:40 mips-nas kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x17]
Jun 18 23:17:40 mips-nas kernel: SCB_LUN[0x0]
Jun 18 23:17:40 mips-nas kernel: Kernel Free SCB list: 1 0
Jun 18 23:17:40 mips-nas kernel: Untagged Q(1): 3
Jun 18 23:17:40 mips-nas kernel:
Jun 18 23:17:40 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:17:40 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:17:40 mips-nas kernel: Recovery code sleeping
Jun 18 23:17:40 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:17:40 mips-nas kernel: (scsi1:A:1:0): SCB 3 - Abort Tag Completed.
Jun 18 23:17:40 mips-nas kernel: Recovery SCB completes
Jun 18 23:17:40 mips-nas kernel: Recovery code awake
Jun 18 23:17:40 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:17:40 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:17:40 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:17:40 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:17:40 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:17:40 mips-nas kernel: scsi_eh_1: flush retry cmd: f6fc1380
Jun 18 23:17:40 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:17:40 mips-nas kernel: Error handler scsi_eh_1 sleeping
Jun 18 23:18:13 mips-nas kernel: Error handler scsi_eh_1 waking up
Jun 18 23:18:13 mips-nas kernel: scsi_eh_prt_fail_stats: 1:0:1:0 cmds failed: 0, 
cancel: 1
Jun 18 23:18:13 mips-nas kernel: Total of 1 commands on 1 devices require eh work
Jun 18 23:18:13 mips-nas kernel: scsi_eh_1: aborting cmd:0xf6fc1380
Jun 18 23:18:13 mips-nas kernel: scsi1:0:1:0: Attempting to queue an ABORT message
Jun 18 23:18:13 mips-nas kernel: CDB: 0x2a 0x0 0x0 0x23 0xf5 0xc7 0x0 0x0 0x8 0x0
Jun 18 23:18:13 mips-nas kernel: scsi1: At time of recovery, card was not paused
Jun 18 23:18:13 mips-nas kernel: >>>>>>>>>>>>>>>>>> Dump Card State Begins 
<<<<<<<<<<<<<<<<<
Jun 18 23:18:13 mips-nas kernel: scsi1: Dumping Card State while idle, at 
SEQADDR 0x8
Jun 18 23:18:13 mips-nas kernel: Card was paused
Jun 18 23:18:13 mips-nas kernel: ACCUM = 0x4, SINDEX = 0x64, DINDEX = 0x65, 
ARG_2 = 0x0
Jun 18 23:18:13 mips-nas kernel: HCNT = 0x0 SCBPTR = 0x0
Jun 18 23:18:13 mips-nas kernel: SCSIPHASE[0x0] SCSISIGI[0x48]:(SELI|IOI) ERROR[0x0]
Jun 18 23:18:13 mips-nas kernel: SCSIBUSL[0x2] LASTPHASE[0x1]:(P_BUSFREE) 
SCSISEQ[0x12]:(ENAUTOATNP|ENRSELI)
Jun 18 23:18:13 mips-nas kernel: SBLKCTL[0xa]:(SELWIDE|SELBUSB) SCSIRATE[0x0] 
SEQCTL[0x10]:(FASTMODE)
Jun 18 23:18:13 mips-nas kernel: SEQ_FLAGS[0xc0]:(NO_CDB_SENT|NOT_IDENTIFIED) 
SSTAT0[0x0]
Jun 18 23:18:13 mips-nas kernel: SSTAT1[0x8]:(BUSFREE) SSTAT2[0x0] SSTAT3[0x0] 
SIMODE0[0x8]:(ENSWRAP)
Jun 18 23:18:13 mips-nas kernel: SIMODE1[0xa4]:(ENSCSIPERR|ENSCSIRST|ENSELTIMO)
Jun 18 23:18:13 mips-nas kernel: SXFRCTL0[0x80]:(DFON) DFCNTRL[0x0] 
DFSTATUS[0x89]:(FIFOEMP|HDONE|PRELOAD_AVAIL)
Jun 18 23:18:13 mips-nas kernel: STACK: 0xe8 0x16a 0x17f 0x3
Jun 18 23:18:13 mips-nas kernel: SCB count = 4
Jun 18 23:18:13 mips-nas kernel: Kernel NEXTQSCB = 2
Jun 18 23:18:13 mips-nas kernel: Card NEXTQSCB = 2
Jun 18 23:18:13 mips-nas kernel: QINFIFO entries:
Jun 18 23:18:13 mips-nas kernel: Waiting Queue entries:
Jun 18 23:18:13 mips-nas kernel: Disconnected Queue entries: 0:3
Jun 18 23:18:13 mips-nas kernel: QOUTFIFO entries:
Jun 18 23:18:13 mips-nas kernel: Sequencer Free SCB List: 1 2 3 4 5 6 7 8 9 10 
11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
Jun 18 23:18:13 mips-nas kernel: Sequencer SCB Info:
Jun 18 23:18:13 mips-nas kernel:   0 
SCB_CONTROL[0x64]:(DISCONNECTED|TAG_ENB|DISCENB) SCB_SCSIID[0x17]
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0x0] SCB_TAG[0x3]
Jun 18 23:18:13 mips-nas kernel:   1 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   2 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   3 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   4 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   5 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   6 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   7 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   8 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:   9 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  10 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  11 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  12 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  13 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  14 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  15 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  16 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)

Jun 18 23:18:13 mips-nas kernel:  17 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  18 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  19 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  20 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  21 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  22 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  23 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  24 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  25 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  26 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  27 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  28 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  29 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  30 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel:  31 SCB_CONTROL[0x0] 
SCB_SCSIID[0xff]:(TWIN_CHNLB|OID|TWIN_TID)
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0xff]:(SCB_XFERLEN_ODD|LID) SCB_TAG[0xff]
Jun 18 23:18:13 mips-nas kernel: Pending list:
Jun 18 23:18:13 mips-nas kernel:   3 SCB_CONTROL[0x60]:(TAG_ENB|DISCENB) 
SCB_SCSIID[0x17]
Jun 18 23:18:13 mips-nas kernel: SCB_LUN[0x0]
Jun 18 23:18:13 mips-nas kernel: Kernel Free SCB list: 1 0
Jun 18 23:18:13 mips-nas kernel: Untagged Q(1): 3
Jun 18 23:18:13 mips-nas kernel:
Jun 18 23:18:13 mips-nas kernel: <<<<<<<<<<<<<<<<< Dump Card State Ends 
 >>>>>>>>>>>>>>>>>>
Jun 18 23:18:13 mips-nas kernel: (scsi1:A:1:0): Device is disconnected, 
re-queuing SCB
Jun 18 23:18:13 mips-nas kernel: Recovery code sleeping
Jun 18 23:18:13 mips-nas kernel: (scsi1:A:1:0): Abort Tag Message Sent
Jun 18 23:18:13 mips-nas kernel: (scsi1:A:1:0): SCB 3 - Abort Tag Completed.
Jun 18 23:18:13 mips-nas kernel: Recovery SCB completes
Jun 18 23:18:13 mips-nas kernel: Recovery code awake
Jun 18 23:18:13 mips-nas kernel: aic7xxx_abort returns 0x2002
Jun 18 23:18:13 mips-nas kernel: scsi_eh_done scmd: f6fc1380 result: 0
Jun 18 23:18:13 mips-nas kernel: scsi_send_eh_cmnd: scmd: f6fc1380, rtn:2002
Jun 18 23:18:13 mips-nas kernel: scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
Jun 18 23:18:13 mips-nas kernel: scsi_eh_tur: scmd f6fc1380 rtn 2002
Jun 18 23:18:13 mips-nas kernel: scsi_eh_1: flush finish cmd: f6fc1380
Jun 18 23:18:13 mips-nas kernel: SCSI error : <1 0 1 0> return code = 0x6000000
Jun 18 23:18:13 mips-nas kernel: end_request: I/O error, dev sdb, sector 2356679
Jun 18 23:18:13 mips-nas kernel: lost page write due to I/O error on sdb1
Jun 18 23:18:13 mips-nas kernel: scsi_restart_operations: waking up host to restart
Jun 18 23:18:13 mips-nas kernel: Error handler scsi_eh_1 sleeping
Jun 18 23:47:25 mips-nas -- MARK --
Jun 19 00:07:26 mips-nas -- MARK --


  Thanks
yogesh
