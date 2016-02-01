From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 14/14] scsi: ufs: add wrapper for retrying sending query attribute
Date: Mon,  1 Feb 2016 15:02:50 +0200
Message-ID: <1454331770-29642-15-git-send-email-ygardi@codeaurora.org>
References: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Sometimes queries from the device might return a failure so it is
recommended to retry sending the query, before giving up.
This change adds a wrapper to retry sending a query attribute,
in cases where we need to wait longer, before we continue,
or before reporting a failure.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 51 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2fc678d..7ab6a45 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1821,6 +1821,43 @@ out:
 }
 
 /**
+ * ufshcd_query_attr_retry() - API function for sending query
+ * attribute with retries
+ * @hba: per-adapter instance
+ * @opcode: attribute opcode
+ * @idn: attribute idn to access
+ * @index: index field
+ * @selector: selector field
+ * @attr_val: the attribute value after the query request
+ * completes
+ *
+ * Returns 0 for success, non-zero in case of failure
+*/
+static int ufshcd_query_attr_retry(struct ufs_hba *hba,
+	enum query_opcode opcode, enum attr_idn idn, u8 index, u8 selector,
+	u32 *attr_val)
+{
+	int ret = 0;
+	u32 retries;
+
+	 for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		ret = ufshcd_query_attr(hba, opcode, idn, index,
+						selector, attr_val);
+		if (ret)
+			dev_dbg(hba->dev, "%s: failed with error %d, retries %d\n",
+				__func__, ret, retries);
+		else
+			break;
+	}
+
+	if (ret)
+		dev_err(hba->dev,
+			"%s: query attribute, idn %d, failed with error %d after %d retires\n",
+			__func__, idn, ret, QUERY_REQ_RETRIES);
+	return ret;
+}
+
+/**
  * ufshcd_query_descriptor - API function for sending descriptor requests
  * hba: per-adapter instance
  * opcode: attribute opcode
@@ -3401,7 +3438,7 @@ static int ufshcd_disable_ee(struct ufs_hba *hba, u16 mask)
 
 	val = hba->ee_ctrl_mask & ~mask;
 	val &= 0xFFFF; /* 2 bytes */
-	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
 	if (!err)
 		hba->ee_ctrl_mask &= ~mask;
@@ -3429,7 +3466,7 @@ static int ufshcd_enable_ee(struct ufs_hba *hba, u16 mask)
 
 	val = hba->ee_ctrl_mask | mask;
 	val &= 0xFFFF; /* 2 bytes */
-	err = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+	err = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
 			QUERY_ATTR_IDN_EE_CONTROL, 0, 0, &val);
 	if (!err)
 		hba->ee_ctrl_mask |= mask;
@@ -3535,7 +3572,7 @@ static void  ufshcd_force_reset_auto_bkops(struct ufs_hba *hba)
 
 static inline int ufshcd_get_bkops_status(struct ufs_hba *hba, u32 *status)
 {
-	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 			QUERY_ATTR_IDN_BKOPS_STATUS, 0, 0, status);
 }
 
@@ -3598,7 +3635,7 @@ static int ufshcd_urgent_bkops(struct ufs_hba *hba)
 
 static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
 {
-	return ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
+	return ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 			QUERY_ATTR_IDN_EE_STATUS, 0, 0, status);
 }
 
@@ -4352,9 +4389,9 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
 			__func__, hba->init_prefetch_data.icc_level);
 
-	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
-			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
-			&hba->init_prefetch_data.icc_level);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
+		&hba->init_prefetch_data.icc_level);
 
 	if (ret)
 		dev_err(hba->dev,
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
