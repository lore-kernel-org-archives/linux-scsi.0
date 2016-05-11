From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v16 3/9] ufs: add UFS 2.0 capabilities
Date: Wed, 11 May 2016 12:21:27 +0100
Message-ID: <4d268ec8cc2eafc50aa2b04f474e0ab0d3af72af.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:52698 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcEKLVp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2016 07:21:45 -0400
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
In-Reply-To: <cover.1462963164.git.jpinto@synopsys.com>
References: <cover.1462963164.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

Add UFS 2.0 support to the UFS core driver.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
Changes v12->v16:
- Nothing changed (just to keep up with patch set version).
Changes v11->v12 (Tomas Winkler):
- devicetree binding tweak was moved to a separated patch
- unipro tweaks were moved to a separated patch
- ufshcd_compose_upiu was decomposed in 2 functions
- UTP_CMD_TYPE_UFS_STORAGE is now 0x1 (previously was 0x11)
Changes v8->v11:
- Nothing changed (just to keep up with patch set version).
Changes v7->v8:
- Added "jedec, ufs-2.0" to the ufschd-platform compatibility strings
Changes v0->v7:
- Nothing changed (just to keep up with patch set version).

 drivers/scsi/ufs/ufshcd.c | 89 +++++++++++++++++++++++++----------------------
 drivers/scsi/ufs/ufshci.h |  5 +++
 2 files changed, 53 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f8fa72c..8e8989a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1173,7 +1173,7 @@ static void ufshcd_disable_intr(struct ufs_hba *hba, u32 intrs)
  * @cmd_dir: requests data direction
  */
 static void ufshcd_prepare_req_desc_hdr(struct ufshcd_lrb *lrbp,
-		u32 *upiu_flags, enum dma_data_direction cmd_dir)
+			u32 *upiu_flags, enum dma_data_direction cmd_dir)
 {
 	struct utp_transfer_req_desc *req_desc = lrbp->utr_descriptor_ptr;
 	u32 data_direction;
@@ -1299,47 +1299,55 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
 }
 
 /**
- * ufshcd_compose_upiu - form UFS Protocol Information Unit(UPIU)
+ * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
+ *			     for Device Management Purposes
  * @hba - per adapter instance
  * @lrb - pointer to local reference block
  */
-static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 {
 	u32 upiu_flags;
 	int ret = 0;
 
-	switch (lrbp->command_type) {
-	case UTP_CMD_TYPE_SCSI:
-		if (likely(lrbp->cmd)) {
-			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
-					lrbp->cmd->sc_data_direction);
-			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
-		} else {
-			ret = -EINVAL;
-		}
-		break;
-	case UTP_CMD_TYPE_DEV_MANAGE:
-		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
-		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
-			ufshcd_prepare_utp_query_req_upiu(
-					hba, lrbp, upiu_flags);
-		else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
-			ufshcd_prepare_utp_nop_upiu(lrbp);
-		else
-			ret = -EINVAL;
-		break;
-	case UTP_CMD_TYPE_UFS:
-		/* For UFS native command implementation */
-		ret = -ENOTSUPP;
-		dev_err(hba->dev, "%s: UFS native command are not supported\n",
-			__func__);
-		break;
-	default:
-		ret = -ENOTSUPP;
-		dev_err(hba->dev, "%s: unknown command type: 0x%x\n",
-				__func__, lrbp->command_type);
-		break;
-	} /* end of switch */
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
+	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
+	if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
+		ufshcd_prepare_utp_query_req_upiu(hba, lrbp, upiu_flags);
+	else if (hba->dev_cmd.type == DEV_CMD_TYPE_NOP)
+		ufshcd_prepare_utp_nop_upiu(lrbp);
+	else
+		ret = -EINVAL;
+
+	return ret;
+}
+
+/**
+ * ufshcd_comp_scsi_upiu - UFS Protocol Information Unit(UPIU)
+ *			   for SCSI Purposes
+ * @hba - per adapter instance
+ * @lrb - pointer to local reference block
+ */
+static int ufshcd_comp_scsi_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
+{
+	u32 upiu_flags;
+	int ret = 0;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
+
+	if (likely(lrbp->cmd)) {
+		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+						lrbp->cmd->sc_data_direction);
+		ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+	} else {
+		ret = -EINVAL;
+	}
 
 	return ret;
 }
@@ -1451,10 +1459,9 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
-	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(hba, lrbp);
+	ufshcd_comp_scsi_upiu(hba, lrbp);
+
 	err = ufshcd_map_sg(lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
@@ -1479,11 +1486,10 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
-	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 
-	return ufshcd_compose_upiu(hba, lrbp);
+	return ufshcd_comp_devman_upiu(hba, lrbp);
 }
 
 static int
@@ -3539,7 +3545,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
 			__ufshcd_release(hba);
-		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE) {
+		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
+			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete)
 				complete(hba->dev_cmd.complete);
 		}
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 4cb1cc6..36f5879 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -279,6 +279,11 @@ enum {
 	UTP_CMD_TYPE_DEV_MANAGE		= 0x2,
 };
 
+/* To accommodate UFS2.0 required Command type */
+enum {
+	UTP_CMD_TYPE_UFS_STORAGE	= 0x1,
+};
+
 enum {
 	UTP_SCSI_COMMAND		= 0x00000000,
 	UTP_NATIVE_UFS_COMMAND		= 0x10000000,
-- 
1.8.1.5

