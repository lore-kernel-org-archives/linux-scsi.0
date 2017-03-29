From: Szymon Mielczarek <szymonx.mielczarek@intel.com>
Subject: [PATCH] Revert "scsi: ufs: add queries retry mechanism"
Date: Wed, 29 Mar 2017 08:19:21 +0200
Message-ID: <1490768361-4492-1-git-send-email-szymonx.mielczarek@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:11242 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753386AbdC2GTy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 02:19:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: subhashj@codeaurora.org, Szymon Mielczarek <szymonx.mielczarek@intel.com>

This reverts commit 61e073590b82a539654626ecae91b8fab11db3f3.

The patch introduced redundant query retries as we already had such
mechanism provided with _retry functions.
Both ufshcd_read_desc and ufshcd_read_unit_desc_param functions
call ufshcd_query_descriptor_retry wrapper.

Signed-off-by: Szymon Mielczarek <szymonx.mielczarek@intel.com>
---
Resending the patch due to smtp server issue.
 drivers/scsi/ufs/ufshcd.c | 54 ++++++++---------------------------------------
 1 file changed, 9 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 096e95b..3dddd13 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3103,18 +3103,7 @@ static inline int ufshcd_read_power_desc(struct ufs_hba *hba,
 					 u8 *buf,
 					 u32 size)
 {
-	int err = 0;
-	int retries;
-
-	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-		/* Read descriptor*/
-		err = ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
-		if (!err)
-			break;
-		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, err);
-	}
-
-	return err;
+	return ufshcd_read_desc(hba, QUERY_DESC_IDN_POWER, 0, buf, size);
 }
 
 static int ufshcd_read_device_desc(struct ufs_hba *hba, u8 *buf, u32 size)
@@ -4272,24 +4261,16 @@ static void ufshcd_set_queue_depth(struct scsi_device *sdev)
 {
 	int ret = 0;
 	u8 lun_qdepth;
-	int retries;
 	struct ufs_hba *hba;
 
 	hba = shost_priv(sdev->host);
 
 	lun_qdepth = hba->nutrs;
-	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-		/* Read descriptor*/
-		ret = ufshcd_read_unit_desc_param(hba,
-				  ufshcd_scsi_to_upiu_lun(sdev->lun),
-				  UNIT_DESC_PARAM_LU_Q_DEPTH,
-				  &lun_qdepth,
-				  sizeof(lun_qdepth));
-		if (!ret || ret == -ENOTSUPP)
-			break;
-
-		dev_dbg(hba->dev, "%s: error %d retrying\n", __func__, ret);
-	}
+	ret = ufshcd_read_unit_desc_param(hba,
+					  ufshcd_scsi_to_upiu_lun(sdev->lun),
+					  UNIT_DESC_PARAM_LU_Q_DEPTH,
+					  &lun_qdepth,
+					  sizeof(lun_qdepth));
 
 	/* Some WLUN doesn't support unit descriptor */
 	if (ret == -EOPNOTSUPP)
@@ -5960,24 +5941,6 @@ static u32 ufshcd_find_max_sup_active_icc_level(struct ufs_hba *hba,
 	return icc_level;
 }
 
-static int ufshcd_set_icc_levels_attr(struct ufs_hba *hba, u32 icc_level)
-{
-	int ret = 0;
-	int retries;
-
-	for (retries = QUERY_REQ_RETRIES; retries > 0; retries--) {
-		/* write attribute */
-		ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
-			QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0, &icc_level);
-		if (!ret)
-			break;
-
-		dev_dbg(hba->dev, "%s: failed with error %d\n", __func__, ret);
-	}
-
-	return ret;
-}
-
 static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 {
 	int ret;
@@ -5998,8 +5961,9 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 	dev_dbg(hba->dev, "%s: setting icc_level 0x%x",
 			__func__, hba->init_prefetch_data.icc_level);
 
-	ret = ufshcd_set_icc_levels_attr(hba,
-				 hba->init_prefetch_data.icc_level);
+	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
+		QUERY_ATTR_IDN_ACTIVE_ICC_LVL, 0, 0,
+		&hba->init_prefetch_data.icc_level);
 
 	if (ret)
 		dev_err(hba->dev,
-- 
1.9.1

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by
others is strictly prohibited.
