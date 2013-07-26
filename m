From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH 2/7] scsi: ufs: find out sense data over scsi status values
Date: Fri, 26 Jul 2013 22:46:00 +0900
Message-ID: <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:36895 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab3GZNqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jul 2013 09:46:03 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQJ00LMYQ8NKFT0@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Fri, 26 Jul 2013 22:46:01 +0900 (KST)
In-reply-to: <1374280885-11526-1-git-send-email-mita@fixstars.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

Except for 'GOOD' and 'CHECK CONDITION', other status value
in Response UPIU may or may contain sense data. If a non-zero
value is in the Data Segment Length field, it means that UPIU
has Sense Data in the Data Segment area.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
---
 drivers/scsi/ufs/ufs.h    |    1 +
 drivers/scsi/ufs/ufshcd.c |   27 +++++++++++++++++++--------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 139bc06..737c31b 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -114,6 +114,7 @@ enum {
 	MASK_SCSI_STATUS	= 0xFF,
 	MASK_TASK_RESPONSE	= 0xFF00,
 	MASK_RSP_UPIU_RESULT	= 0xFFFF,
+	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
 };
 
 /* Task management service response */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4cf3a2d..688ae0e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -218,6 +218,20 @@ ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
 	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
 }
 
+/*
+ * ufshcd_get_rsp_upiu_data_seg_len - Get the data segment length
+ *				from response UPIU
+ * @ucd_rsp_ptr: pointer to response UPIU
+ *
+ * Return the data segment length.
+ */
+static inline int
+ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
+{
+	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
+		MASK_RSP_UPIU_DATA_SEG_LEN;
+}
+
 /**
  * ufshcd_config_int_aggr - Configure interrupt aggregation values.
  *		Currently there is no use case where we want to configure
@@ -298,7 +312,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
 static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 {
 	int len;
-	if (lrbp->sense_buffer) {
+	if (lrbp->sense_buffer &&
+	    !ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sense_data_len);
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sense_data,
@@ -1156,21 +1171,17 @@ ufshcd_scsi_cmd_status(struct ufshcd_lrb *lrbp, int scsi_status)
 			  SAM_STAT_CHECK_CONDITION;
 		ufshcd_copy_sense_data(lrbp);
 		break;
-	case SAM_STAT_BUSY:
-		result |= SAM_STAT_BUSY;
-		break;
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
+		result |= scsi_status;
+		ufshcd_copy_sense_data(lrbp);
 		break;
 	default:
 		result |= DID_ERROR << 16;
-- 
1.7.0.4


