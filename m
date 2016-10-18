From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 03/11] scsi: ufs: fix bugs related to null pointer access and array size
Date: Mon, 17 Oct 2016 17:09:24 -0700
Message-ID: <1476749364-11163-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

In this change there are a few fixes of possible NULL pointer access
and possible access to index that exceeds array boundaries.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs.h    |  3 ++-
 drivers/scsi/ufs/ufshcd.c | 25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 845b874..7a6ccb6 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -46,6 +46,7 @@
 #define QUERY_DESC_HDR_SIZE       2
 #define QUERY_OSF_SIZE            (GENERAL_UPIU_REQUEST_SIZE - \
 					(sizeof(struct utp_upiu_header)))
+#define RESPONSE_UPIU_SENSE_DATA_LENGTH	18
 
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
 			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
@@ -416,7 +417,7 @@ struct utp_cmd_rsp {
 	__be32 residual_transfer_count;
 	__be32 reserved[4];
 	__be16 sense_data_len;
-	u8 sense_data[18];
+	u8 sense_data[RESPONSE_UPIU_SENSE_DATA_LENGTH];
 };
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 834a28c..a99f57b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -889,10 +889,14 @@ static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
 	int len;
 	if (lrbp->sense_buffer &&
 	    ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
+		int len_to_copy;
+
 		len = be16_to_cpu(lrbp->ucd_rsp_ptr->sr.sense_data_len);
+		len_to_copy = min_t(int, RESPONSE_UPIU_SENSE_DATA_LENGTH, len);
+
 		memcpy(lrbp->sense_buffer,
 			lrbp->ucd_rsp_ptr->sr.sense_data,
-			min_t(int, len, SCSI_SENSE_BUFFERSIZE));
+			min_t(int, len_to_copy, SCSI_SENSE_BUFFERSIZE));
 	}
 }
 
@@ -6091,7 +6095,10 @@ EXPORT_SYMBOL(ufshcd_system_suspend);
 
 int ufshcd_system_resume(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered || pm_runtime_suspended(hba->dev))
+	if (!hba)
+		return -EINVAL;
+
+	if (!hba->is_powered || pm_runtime_suspended(hba->dev))
 		/*
 		 * Let the runtime resume take care of resuming
 		 * if runtime suspended.
@@ -6112,7 +6119,10 @@ EXPORT_SYMBOL(ufshcd_system_resume);
  */
 int ufshcd_runtime_suspend(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered)
+	if (!hba)
+		return -EINVAL;
+
+	if (!hba->is_powered)
 		return 0;
 
 	return ufshcd_suspend(hba, UFS_RUNTIME_PM);
@@ -6142,10 +6152,13 @@ EXPORT_SYMBOL(ufshcd_runtime_suspend);
  */
 int ufshcd_runtime_resume(struct ufs_hba *hba)
 {
-	if (!hba || !hba->is_powered)
+	if (!hba)
+		return -EINVAL;
+
+	if (!hba->is_powered)
 		return 0;
-	else
-		return ufshcd_resume(hba, UFS_RUNTIME_PM);
+
+	return ufshcd_resume(hba, UFS_RUNTIME_PM);
 }
 EXPORT_SYMBOL(ufshcd_runtime_resume);
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
