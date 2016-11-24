From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 01/11] scsi: ufs: add queries retry mechanism
Date: Wed, 23 Nov 2016 16:30:49 -0800
Message-ID: <1479947449-6936-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933573AbcKXAbn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2016 19:31:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Dolev Raviv <draviv@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

From: Dolev Raviv <draviv@codeaurora.org>

Some of the queries might fail during init. To avoid
system failure, we add retry mechanism to issue queries
several times.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 54 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f91e50b..0b278a1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2141,7 +2141,18 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
 					 u8 *buf,
 					 u32 size)
 {
-	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
+	int err = 0;
+	int retries;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* Read descriptor*/
+		err = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
+		if (!err)
+			break;
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
+	}
+
+	return err;
 }
 
 int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
@@ -3251,16 +3262,24 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 {
 	int ret = 0;
 	u8 lun_qdepth;
+	int retries;
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
 
 	lun_qdepth = hba->nutrs;
-	ret = ufshcd_read_unit_desc_param(hba,
-					  ufshcd_scsi_to_upiu_lun(sdev->lun),
-					  UNIT_DESC_PARAM_LU_Q_DEPTH,
-					  &lun_qdepth,
-					  sizeof(lun_qdepth));
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* Read descriptor*/
+		ret = ufshcd_read_unit_desc_param(hba,
+				  ufshcd_scsi_to_upiu_lun(sdev->lun),
+				  UNIT_DESC_PARAM_LU_Q_DEPTH,
+				  &lun_qdepth,
+				  sizeof(lun_qdepth));
+		if (!ret || ret == -ENOTSUPP)
+			break;
+
+		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, ret);
+	}
 
 	/* Some WLUN doesn't support unit descriptor */
 	if (ret == -EOPNOTSUPP)
@@ -4796,6 +4815,24 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 	return icc_level;
 }
 
+static int ufshcd_set_icc_levels_attr(struct ufs_hba *hba, u32 icc_level)
+{
+	int ret = 0;
+	int retries;
+
+	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
+		/* write attribute */
+		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
+		if (!ret)
+			break;
+
+		dev_dbg(hba->dev, "%s: failed with error %d\n", __func__, ret);
+	}
+
+	return ret;
+}
+
 static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 {
 	int ret;
@@ -4816,9 +4853,8 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
 			__func__, hba->init_prefetch_data.icc_level);
 
-	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
-		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
-		&hba->init_prefetch_data.icc_level);
+	ret = ufshcd_set_icc_levels_attr(hba,
+				 hba->init_prefetch_data.icc_level);
 
 	if (ret)
 		dev_err(hba->dev,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

