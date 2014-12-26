From: Gabor Zele <zegab@szerverhaz.hu>
Subject: can't access LUN >2TB with aic79xx
Date: Fri, 26 Dec 2014 02:42:55 +0100 (CET)
Message-ID: <1594224725.855013.1419558175115.JavaMail.zimbra@szerverhaz.hu>
References: <1603365636.855007.1419557473273.JavaMail.zimbra@szerverhaz.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zimbra.renewcloud.net ([87.97.76.119]:54448 "EHLO
	zimbra.renewcloud.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLZByi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Dec 2014 20:54:38 -0500
Received: from localhost (localhost [127.0.0.1])
	by zimbra.renewcloud.net (Postfix) with ESMTP id 6530AA0508
	for <linux-scsi@vger.kernel.org>; Fri, 26 Dec 2014 02:42:56 +0100 (CET)
Received: from zimbra.renewcloud.net (zimbra.renewcloud.net [192.168.10.6])
	by zimbra.renewcloud.net (Postfix) with ESMTP id 2C05BA04E0
	for <linux-scsi@vger.kernel.org>; Fri, 26 Dec 2014 02:42:55 +0100 (CET)
In-Reply-To: <1603365636.855007.1419557473273.JavaMail.zimbra@szerverhaz.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello all,


I've encountered the following on a fairly recent Linux system
(CentOS 7, kernel 3.10.0-123.8.1.el7.x86_64):

I was trying to attach a Promise Vtrak M500P raid array to the host by an adaptec 29320-lpe card. The raid is configured to a single very large lun, over 10TiBs.
(it is working fine with an other, LSI based host adapter (mptscsih module), with the same system - but i have to replace the card due to not enogh pci-e slots).

First, I have noticed,that the stock aic79xx driver thrown a lot of error after the READ CAPACITY(16) and READ(16) instructions.
The reported lun size was 2TiB only. 

After a quick search I found that this issue was considered here before, in these threads:
http://marc.info/?l=linux-scsi&m=119278917517261&w=2
http://marc.info/?l=linux-scsi&m=124650197016896&w=4

I have applied teh patch that upped the max_cmd_len variable to 16 in the driver, recompiled, but know I'm facing some even more interesting errors.
As you will see, the device is know detected with it's correct size, even the partition table was read, but after that the whole thing is messed up.

I'm not a expreienced kernel or scsi guy, so I'm asking a hand for fixing this, of course if that's possible.



[  102.794817] sd 6:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
[  102.795303] sd 6:0:0:0: [sde] 27343744512 512-byte logical blocks: (13.9 TB/12.7 TiB)
[  102.798585] sd 6:0:0:0: [sde] Write Protect is off
[  102.798595] sd 6:0:0:0: [sde] Mode Sense: a7 00 10 08
[  102.798976] sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[  102.802612] sd 6:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
[  102.803382] sd 6:0:0:0: Attached scsi generic sg5 type 0
[  102.806183]  sde: sde1
[  102.806926] sd 6:0:0:0: [sde] Very big device. Trying to use READ CAPACITY(16).
[  102.807885] sd 6:0:0:0: [sde] Attached SCSI disk

-----
after this I had run fdisk /dev/sde

[  133.892716] sd 6:0:0:0: [sde] Attempting to queue an ABORT message:
[  133.892727] CDB: 0x88 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x1 0x88 0x0 0x0 0x0 0x8 0x0 0x0
[  133.893301] scsi6: At time of recovery, card was not paused
[  133.893312] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi6: Dumping Card State at program address 0x0 Mode 0x22
[  133.893317] Card was paused
[  133.893322] INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
[  133.893339] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
[  133.893355] SCSISIGI[0x24] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
[  133.893371] SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
[  133.893386] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
[  133.893402] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff]
[  133.893416] SSTAT0[0x10] SSTAT1[0x8] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]
[  133.893435] SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
[  133.893451] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x40]
[  133.893478]
SCB Count = 4 CMDS_PENDING = 3 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
[  133.893490] qinstart = 118 qinfifonext = 118
QINFIFO:
WAITING_TID_QUEUES:
[  133.893508]        0 ( 0x3 0x2 0x1 )
[  133.893531] Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Total 3
[  133.893567] Kernel Free SCB list: 0
[  133.893571] Sequencer Complete DMA-inprog list:
[  133.893577] Sequencer Complete list:
[  133.893583] Sequencer DMA-Up and Complete list:
[  133.893589] Sequencer On QFreeze and Complete list:
[  133.893607]

scsi6: FIFO0 Free, LONGJMP == 0x826c, SCB 0x3
[  133.893614] SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
[  133.893630] SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
[  133.893642] SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
[  133.893689] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi6: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
[  133.893706] SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
[  133.893722] SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
[  133.893734] SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
[  133.893781] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x8 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
[  133.893846] scsi6: LQISTATE = 0x1, LQOSTATE = 0x1a, OPTIONMODE = 0x52
[  133.893853] scsi6: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
[  133.893860] scsi6: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
[  133.893864] SIMODE0[0xc]
[  133.893870] CCSCBCTL[0x4]
[  133.893885] scsi6: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
[  133.893899] scsi6: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xff6a
[  133.893914] CDB 88 0 0 0 0 6
[  133.893917] STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[  133.894020] scsi6:0:0:0: Cmd aborted from QINFIFO
[  133.894114] sd 6:0:0:0: [sde] Unhandled error code
[  133.894120] sd 6:0:0:0: [sde]
[  133.894133] Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK
[  133.894138] sd 6:0:0:0: [sde] CDB:
[  133.894142] Read(16): 88 00 00 00 00 06 5d d0 6d 00 00 00 00 08 00 00
[  133.894163] end_request: I/O error, dev sde, sector 27343744256
[  133.894221] Buffer I/O error on device sde1, logical block 27343742208
[  133.894271] Buffer I/O error on device sde1, logical block 27343742209
[  133.894319] Buffer I/O error on device sde1, logical block 27343742210
[  133.894366] Buffer I/O error on device sde1, logical block 27343742211
[  133.894413] Buffer I/O error on device sde1, logical block 27343742212
[  133.894460] Buffer I/O error on device sde1, logical block 27343742213
[  133.894507] Buffer I/O error on device sde1, logical block 27343742214
[  133.894563] Buffer I/O error on device sde1, logical block 27343742215
[  193.937832] sd 6:0:0:0: [sde] Attempting to queue an ABORT message:
[  193.937843] CDB: 0x88 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x1 0x88 0x0 0x0 0x0 0x8 0x0 0x0
[  193.939076] scsi6: At time of recovery, card was not paused
[  193.939087] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi6: Dumping Card State at program address 0x20 Mode 0x22
[  193.939092] Card was paused
[  193.939097] INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
[  193.939114] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
[  193.939130] SCSISIGI[0x24] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
[  193.939146] SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
[  193.939162] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
[  193.939178] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff]
[  193.939193] SSTAT0[0x10] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]
[  193.939212] SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
[  193.939227] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x40]
[  193.939254]
SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
[  193.939266] qinstart = 118 qinfifonext = 121
QINFIFO: 0x1 0x2 0x3
WAITING_TID_QUEUES:
[  193.939288] Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Total 3
[  193.939324] Kernel Free SCB list: 0
[  193.939328] Sequencer Complete DMA-inprog list:
[  193.939334] Sequencer Complete list:
[  193.939340] Sequencer DMA-Up and Complete list:
[  193.939346] Sequencer On QFreeze and Complete list:
[  193.939364]

scsi6: FIFO0 Free, LONGJMP == 0x826c, SCB 0x3
[  193.939371] SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
[  193.939387] SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
[  193.939399] SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
[  193.939447] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]

scsi6: FIFO1 Free, LONGJMP == 0x8063, SCB 0x3
[  193.939464] SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89]
[  193.939480] SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0]
[  193.939492] SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0
[  193.939539] HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10]
LQIN: 0x8 0x0 0x0 0x3 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
[  193.939604] scsi6: LQISTATE = 0x1, LQOSTATE = 0x1a, OPTIONMODE = 0x52
[  193.939611] scsi6: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
[  193.939618] scsi6: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
[  193.939623] SIMODE0[0xc]
[  193.939628] CCSCBCTL[0x4]
[  193.939643] scsi6: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
[  193.939658] scsi6: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xff6a
[  193.939673] CDB 88 0 0 0 0 6
[  193.939675] STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
[  193.939739] scsi6:0:0:0: Cmd aborted from QINFIFO
[  193.939830] sd 6:0:0:0: [sde] Attempting to queue an ABORT message:
[  193.939833] CDB: 0x88 0x0 0x0 0x0 0x0 0x6 0x5d 0xd0 0x6d 0x0 0x0 0x0 0x0 0x8 0x0 0x0
[  193.941441] scsi6: At time of recovery, card was not paused
[  193.941451] >>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi6: Dumping Card State at program address 0x34 Mode 0x22
[  193.941455] Card was paused
[  193.941460] INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0]
[  193.941478] INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x33]
[  193.941494] SCSISIGI[0x24] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x1]
[  193.941510] SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0]
[  193.941527] SEQ_FLAGS[0x0] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0]
[  193.941543] KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] MK_MESSAGE_SCSIID[0xff]
[  193.941557] SSTAT0[0x10] SSTAT1[0x0] SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0]
[  193.941579] SIMODE1[0xac] LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x80]
[  193.941595] LQOSTAT0[0x0] LQOSTAT1[0x0] LQOSTAT2[0x40]
[  193.941621]
SCB Count = 4 CMDS_PENDING = 0 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0xff00
[  193.941631] qinstart = 118 qinfifonext = 120
QINFIFO: 0x2 0x3
WAITING_TID_QUEUES:
[  193.941651] Pending list:
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7]
Total 2
[  193.941678] Kernel Free SCB list: 1 0



regards,
Gabor Zele
