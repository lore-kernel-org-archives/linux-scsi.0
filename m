From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 4/24] mpt fusion: [2.6.30-rc6] small fix for 1078 data corruption issue
Date: Fri, 22 May 2009 16:11:30 +0530
Message-ID: <20090522104130.GF16245@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og110.obsmtp.com ([64.18.2.173]:60977 "EHLO
	exprod7og110.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbZEVLCa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 May 2009 07:02:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com


Patch applied on 21/01/2009: "Fixing 1078 data curruption" need this changes
also.
message flags will use runtime sense width instead of compile time as
explain in patch applied on 21/01/2009 "Fixing 1078 data curruption".
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptbase.h b/drivers/message/fusion/mptbase.h
index 1b258b2..8cd0a16 100644
--- a/drivers/message/fusion/mptbase.h
+++ b/drivers/message/fusion/mptbase.h
@@ -767,9 +767,10 @@ typedef struct _mpt_sge {
 } MptSge_t;
 
 
-#define mpt_msg_flags() \
-	((sizeof(dma_addr_t) == sizeof(u64)) ? MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_64 : \
-		MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_32)
+#define mpt_msg_flags(ioc) \
+	(ioc->sg_addr_size == sizeof(u64)) ?		\
+	MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_64 : 		\
+	MPI_SCSIIO_MSGFLGS_SENSE_WIDTH_32
 
 #define MPT_SGE_FLAGS_64_BIT_ADDRESSING \
 	(MPI_SGE_FLAGS_64_BIT_ADDRESSING << MPI_SGE_FLAGS_SHIFT)
diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 55f6102..bece386 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1895,7 +1895,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			}
 
 			pScsiReq->MsgFlags &= ~MPI_SCSIIO_MSGFLGS_SENSE_WIDTH;
-			pScsiReq->MsgFlags |= mpt_msg_flags();
+			pScsiReq->MsgFlags |= mpt_msg_flags(ioc);
 
 
 			/* verify that app has not requested
@@ -1981,7 +1981,7 @@ mptctl_do_mpt_command (struct mpt_ioctl_command karg, void __user *mfPtr)
 			int dataSize;
 
 			pScsiReq->MsgFlags &= ~MPI_SCSIIO_MSGFLGS_SENSE_WIDTH;
-			pScsiReq->MsgFlags |= mpt_msg_flags();
+			pScsiReq->MsgFlags |= mpt_msg_flags(ioc);
 
 
 			/* verify that app has not requested
diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index a1ce079..8c08c73 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -1357,7 +1357,7 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
 	pScsiReq->CDBLength = SCpnt->cmd_len;
 	pScsiReq->SenseBufferLength = MPT_SENSE_BUFFER_SIZE;
 	pScsiReq->Reserved = 0;
-	pScsiReq->MsgFlags = mpt_msg_flags();
+	pScsiReq->MsgFlags = mpt_msg_flags(ioc);
 	int_to_scsilun(SCpnt->device->lun, (struct scsi_lun *)pScsiReq->LUN);
 	pScsiReq->Control = cpu_to_le32(scsictl);
 
@@ -3108,7 +3108,7 @@ mptscsih_do_cmd(MPT_SCSI_HOST *hd, INTERNAL_CMD *io)
 
 	pScsiReq->Reserved = 0;
 
-	pScsiReq->MsgFlags = mpt_msg_flags();
+	pScsiReq->MsgFlags = mpt_msg_flags(ioc);
 	/* MsgContext set in mpt_get_msg_fram call  */
 
 	int_to_scsilun(io->lun, (struct scsi_lun *)pScsiReq->LUN);
