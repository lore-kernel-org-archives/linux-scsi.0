From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 02/11] scsi: ufs: add index details to query error messages
Date: Wed, 23 Nov 2016 16:31:18 -0800
Message-ID: <1479947478-6976-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

When sending query to the device, the index  of the failure
is additional useful information that should be printed out as it
might specify the logical unit (LU) where the error occurred.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0b278a1..9abc11e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1914,8 +1914,8 @@ static int ufshcd_query_attr(struct ufs_hba *hba, enum query_opcode opcode,
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
 
 	if (err) {
-		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, err = %d\n",
-				__func__, opcode, idn, err);
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
+				__func__, opcode, idn, index, err);
 		goto out_unlock;
 	}
 
@@ -2014,8 +2014,8 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
 	err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, QUERY_REQ_TIMEOUT);
 
 	if (err) {
-		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, err = %d\n",
-				__func__, opcode, idn, err);
+		dev_err(hba->dev, "%s: opcode 0x%.2x for idn %d failed, index %d, err = %d\n",
+				__func__, opcode, idn, index, err);
 		goto out_unlock;
 	}
 
@@ -2112,8 +2112,9 @@ static int ufshcd_read_desc_param(struct ufs_hba *hba,
 	    (desc_buf[QUERY_DESC_LENGTH_OFFSET] !=
 	     ufs_query_desc_max_size[desc_id])
 	    || (desc_buf[QUERY_DESC_DESC_TYPE_OFFSET] != desc_id)) {
-		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d param_offset %d buff_len %d ret %d",
-			__func__, desc_id, param_offset, buff_len, ret);
+		dev_err(hba->dev, "%s: Failed reading descriptor. desc_id %d, param_offset %d, buff_len %d ,index %d, ret %d",
+			__func__, desc_id, param_offset, buff_len,
+			desc_index, ret);
 		if (!ret)
 			ret = -EINVAL;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
