From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 1/6] scsi: ufs: find out sense data over scsi status values
Date: Sat, 31 Aug 2013 21:40:19 +0530
Message-ID: <1377965424-30991-2-git-send-email-santoshsy@gmail.com>
References: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60693 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab3HaQLA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 12:11:00 -0400
Received: by mail-pb0-f42.google.com with SMTP id un15so3074585pbc.15
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 09:11:00 -0700 (PDT)
In-Reply-To: <1377965424-30991-1-git-send-email-santoshsy@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Seungwon Jeon <tgih.jun@samsung.com>, Santosh Y <santoshsy@gmail.com>

From: Seungwon Jeon <tgih.jun@samsung.com>

Unlike 'GOOD' and 'CHECK CONDITION', other status values in
Response UPIU may or may not contain sense data. That is returning
sense data isn't obvious. So, in this case the Data Segment Length
field should be checked. If a non-zero value, it means that UPIU
has Sense Data in the Data Segment area.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
Tested-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Santosh Y <santoshsy@gmail.com>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index bce09a6..7210500 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -177,6 +177,7 @@ enum {
 	MASK_TASK_RESPONSE              = 0xFF00,
 	MASK_RSP_UPIU_RESULT            = 0xFFFF,
 	MASK_QUERY_DATA_SEG_LEN         = 0xFFFF,
+	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
 	MASK_RSP_EXCEPTION_EVENT        = 0x10000,
 };
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a0f5ac2..ac3d56b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -310,6 +310,20 @@ ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
 	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
 }
 
+/*
+ * ufshcd_get_rsp_upiu_data_seg_len - Get the data segment length
+ *				from response UPIU
+ * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * Return the data segment length.
+ */
+static inline unsigned int
+ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
+{
+	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
+		MASK_RSP_UPIU_DATA_SEG_LEN;
+}
+
 /**
  * ufshcd_is_exception_event - Check if the device raised an exception event
  * @ucd_rsp_ptr: pointer to response UPIU
@@ -405,7 +419,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
 	int len;
-	if (lrbp->sense_buffer) {
+	if (lrbp->sense_buffer &&
+	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sr.sense_data,
@@ -1789,32 +1804,24 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 	int result = 0;
 
 	switch (scsi_status) {
-	case SAM_STAT_GOOD:
-		result |= DID_OK << 16 |
-			  COMMAND_COMPLETE << 8 |
-			  SAM_STAT_GOOD;
-		break;
 	case SAM_STAT_CHECK_CONDITION:
+		ufshcd_copy_sense_data(lrbp);
+	case SAM_STAT_GOOD:
 		result |= DID_OK << 16 |
 			  COMMAND_COMPLETE << 8 |
-			  SAM_STAT_CHECK_CONDITION;
-		ufshcd_copy_sense_data(lrbp);
-		break;
-	case SAM_STAT_BUSY:
-		result |= SAM_STAT_BUSY;
+			  scsi_status;
 		break;
 	case SAM_STAT_TASK_SET_FULL:
-
 		/*
 		 * If a LUN reports SAM_STAT_TASK_SET_FULL, then the LUN queue
 		 * depth needs to be adjusted to the exact number of
 		 * outstanding commands the LUN can handle at any given time.
 		 */
 		ufshcd_adjust_lun_qdepth(lrbp->cmd);
-		result |= SAM_STAT_TASK_SET_FULL;
-		break;
+	case SAM_STAT_BUSY:
 	case SAM_STAT_TASK_ABORTED:
-		result |= SAM_STAT_TASK_ABORTED;
+		ufshcd_copy_sense_data(lrbp);
+		result |= scsi_status;
 		break;
 	default:
 		result |= DID_ERROR << 16;
-- 
1.8.4

