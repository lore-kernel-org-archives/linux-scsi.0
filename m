From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v4 11/15] scsi: ufs: retry failed query flag requests
Date: Sun, 25 Oct 2015 16:56:20 +0200
Message-ID: <1445784984-16443-12-git-send-email-ygardi@codeaurora.org>
References: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

UFS flag query requests may fail sometimes due to timeouts etc.
Add a wrapper function to retry up to 10 times in case of such
failure, similar to retries being made for attribute queries.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 63 ++++++++++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  4 +++
 2 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 60ba729..889a7be 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1663,6 +1663,29 @@ static inline void ufshcd_init_query(struct ufs_hba *hba,
 	(*request)->upiu_req.selector = selector;
 }
 
+static int ufshcd_query_flag_retry(struct ufs_hba *hba,
+	enum query_opcode opcode, enum flag_idn idn, bool *flag_res)
+{
+	int ret;
+	int retries;
+
+	for (retries = 0; retries < QUERY_REQ_RETRIES; retries++) {
+		ret = ufshcd_query_flag(hba, opcode, idn, flag_res);
+		if (ret)
+			dev_dbg(hba->dev,
+				"%s: failed with error %d, retries %d\n",
+				__func__, ret, retries);
+		else
+			break;
+	}
+
+	if (ret)
+		dev_err(hba->dev,
+			"%s: query attribute, opcode %d, idn %d, failed with error %d after %d retires\n",
+			__func__, opcode, idn, ret, retries);
+	return ret;
+}
+
 /**
  * ufshcd_query_flag() - API function for sending flag query requests
  * hba: per-adapter instance
@@ -1672,7 +1695,7 @@ static inline void ufshcd_init_query(struct ufs_hba *hba,
  *
  * Returns 0 for success, non-zero in case of failure
  */
-static int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
+int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
 			enum flag_idn idn, bool *flag_res)
 {
 	struct ufs_query_req *request = NULL;
@@ -2657,17 +2680,12 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
  */
 static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 {
-	int i, retries, err = 0;
+	int i;
+	int err;
 	bool flag_res = 1;
 
-	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-		/* Set the fDeviceInit flag */
-		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
-					QUERY_FLAG_IDN_FDEVICEINIT, NULL);
-		if (!err || err == -ETIMEDOUT)
-			break;
-		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
-	}
+	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+		QUERY_FLAG_IDN_FDEVICEINIT, NULL);
 	if (err) {
 		dev_err(hba->dev,
 			"%s setting fDeviceInit flag failed with error %d\n",
@@ -2675,18 +2693,11 @@ static int ufshcd_complete_dev_init(struct ufs_hba *hba)
 		goto out;
 	}
 
-	/* poll for max. 100 iterations for fDeviceInit flag to clear */
-	for (i = 0; i < 100 && !err && flag_res; i++) {
-		for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-			err = ufshcd_query_flag(hba,
-					UPIU_QUERY_OPCODE_READ_FLAG,
-					QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
-			if (!err || err == -ETIMEDOUT)
-				break;
-			dev_dbg(hba->dev, "%s: error %d retrying\n", __func__,
-					err);
-		}
-	}
+	/* poll for max. 1000 iterations for fDeviceInit flag to clear */
+	for (i = 0; i < 1000 && !err && flag_res; i++)
+		err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+			QUERY_FLAG_IDN_FDEVICEINIT, &flag_res);
+
 	if (err)
 		dev_err(hba->dev,
 			"%s reading fDeviceInit flag failed with error %d\n",
@@ -3433,7 +3444,7 @@ static int ufshcd_enable_auto_bkops(struct ufs_hba *hba)
 	if (hba->auto_bkops_enabled)
 		goto out;
 
-	err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
+	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_SET_FLAG,
 			QUERY_FLAG_IDN_BKOPS_EN, NULL);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to enable bkops %d\n",
@@ -3482,7 +3493,7 @@ static int ufshcd_disable_auto_bkops(struct ufs_hba *hba)
 		goto out;
 	}
 
-	err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
+	err = ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_CLEAR_FLAG,
 			QUERY_FLAG_IDN_BKOPS_EN, NULL);
 	if (err) {
 		dev_err(hba->dev, "%s: failed to disable bkops %d\n",
@@ -4453,8 +4464,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 		/* clear any previous UFS device information */
 		memset(&hba->dev_info, 0, sizeof(hba->dev_info));
-		if (!ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
-				       QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
+		if (!ufshcd_query_flag_retry(hba, UPIU_QUERY_OPCODE_READ_FLAG,
+				QUERY_FLAG_IDN_PWR_ON_WPE, &flag))
 			hba->dev_info.f_power_on_wp_en = flag;
 
 		if (!hba->is_init_prefetch)
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 2570d94..f8ce680 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -3,6 +3,7 @@
  *
  * This code is based on drivers/scsi/ufs/ufshcd.h
  * Copyright (C) 2011-2013 Samsung India Software Operations
+ * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
  *
  * Authors:
  *	Santosh Yaraganavi <santosh.sy@samsung.com>
@@ -681,6 +682,9 @@ static inline int ufshcd_dme_peer_get(struct ufs_hba *hba,
 	return ufshcd_dme_get_attr(hba, attr_sel, mib_val, DME_PEER);
 }
 
+/* Expose Query-Request API */
+int ufshcd_query_flag(struct ufs_hba *hba, enum query_opcode opcode,
+	enum flag_idn idn, bool *flag_res);
 int ufshcd_hold(struct ufs_hba *hba, bool async);
 void ufshcd_release(struct ufs_hba *hba);
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
