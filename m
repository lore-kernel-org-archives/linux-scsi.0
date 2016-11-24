From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 04/11] scsi: ufs: fix failure to read the string descriptor
Date: Wed, 23 Nov 2016 16:31:41 -0800
Message-ID: <1479947501-7056-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

While reading variable size descriptors (like string descriptor), some UFS
devices may report the "LENGTH" (field in "Transaction Specific fields" of
Query Response UPIU) same as what was requested in Query Request UPIU
instead of reporting the actual size of the variable size descriptor.
Although it's safe to ignore the "LENGTH" field for variable size
descriptors as we can always derive the length of the descriptor from
the descriptor header fields. Hence this change impose the length match
check only for fixed size descriptors (for which we always request the
correct size as part of Query Request UPIU).

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9abc11e..d6e87dc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2108,16 +2108,38 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 					desc_id, desc_index, 0, desc_buf,
 					&buff_len);
 
-	if (ret || (buff_len < ufs_query_desc_max_size[desc_id]) ||
-	    (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
-	     ufs_query_desc_max_size[desc_id])
-	    || (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id)) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, param_offset %d, buff_len %d ,index %d, ret %d",
-			__func__, desc_id, param_offset, buff_len,
-			desc_index, ret);
-		if (!ret)
-			ret = -EINVAL;
+	if (ret) {
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, desc_index %d, param_offset %d, ret %d",
+			__func__, desc_id, desc_index, param_offset, ret);
+
+		goto out;
+	}
+
+	/* Sanity check */
+	if (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id) {
+		dev_err(hba->dev, "%s: invalid desc_id %d in descriptor header",
+			__func__, desc_buf[QUERY_DESC_DESC_TYPE_OFFSET]);
+		ret = -EINVAL;
+		goto out;
+	}
 
+	/*
+	 * While reading variable size descriptors (like string descriptor),
+	 * some UFS devices may report the "LENGTH" (field in "Transaction
+	 * Specific fields" of Query Response UPIU) same as what was requested
+	 * in Query Request UPIU instead of reporting the actual size of the
+	 * variable size descriptor.
+	 * Although it's safe to ignore the "LENGTH" field for variable size
+	 * descriptors as we can always derive the length of the descriptor from
+	 * the descriptor header fields. Hence this change impose the length
+	 * match check only for fixed size descriptors (for which we always
+	 * request the correct size as part of Query Request UPIU).
+	 */
+	if ((desc_id != QUERY_DESC_IDN_STRING) &&
+	    (buff_len != desc_buf[QUERY_DESC_LENGTH_OFFSET])) {
+		dev_err(hba->dev, "%s: desc_buf length mismatch: buff_len %d, buff_len(desc_header) %d",
+			__func__, buff_len, desc_buf[QUERY_DESC_LENGTH_OFFSET]);
+		ret = -EINVAL;
 		goto out;
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
