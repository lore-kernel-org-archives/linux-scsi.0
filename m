From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v7 2/3] added UFS 2.0 capabilities
Date: Thu, 11 Feb 2016 12:13:05 +0000
Message-ID: <001da774573abec6c4504e46b601a36c600d6c5c.1455192008.git.jpinto@synopsys.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1455192008.git.jpinto@synopsys.com>
In-Reply-To: <cover.1455192008.git.jpinto@synopsys.com>
References: <cover.1455192008.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Adding UFS 2.0 support to the UFS core driver.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v0->v7:
- Nothing changed (just to keep up with patch set version).

 drivers/scsi/ufs/ufshcd.c | 29 +++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshci.h |  1 +
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 85cd256..2b5f2bf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1223,6 +1223,7 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			ret = -EINVAL;
 		}
 		break;
+	case UTP_CMD_TYPE_UFS_STORAGE:
 	case UTP_CMD_TYPE_DEV_MANAGE:
 		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, DMA_NONE);
 		if (hba->dev_cmd.type == DEV_CMD_TYPE_QUERY)
@@ -1287,6 +1288,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	struct ufshcd_lrb *lrbp;
 	struct ufs_hba *hba;
 	unsigned long flags;
+	u32 upiu_flags;
 	int tag;
 	int err = 0;
 
@@ -1343,10 +1345,23 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->task_tag = tag;
 	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = !ufshcd_is_intr_aggr_allowed(hba) ? true : false;
-	lrbp->command_type = UTP_CMD_TYPE_SCSI;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
 	/* form UPIU before issuing the command */
-	ufshcd_compose_upiu(hba, lrbp);
+	if (hba->ufs_version == UFSHCI_VERSION_20) {
+		if (likely(lrbp->cmd)) {
+			ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags,
+					lrbp->cmd->sc_data_direction);
+			ufshcd_prepare_utp_scsi_cmd_upiu(lrbp, upiu_flags);
+		} else
+			err = -EINVAL;
+	} else
+		ufshcd_compose_upiu(hba, lrbp);
+
 	err = ufshcd_map_sg(lrbp);
 	if (err) {
 		lrbp->cmd = NULL;
@@ -1371,7 +1386,12 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
 	lrbp->sense_buffer = NULL;
 	lrbp->task_tag = tag;
 	lrbp->lun = 0; /* device management cmd is not specific to any LUN */
-	lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
+	if (hba->ufs_version == UFSHCI_VERSION_20)
+		lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
+	else
+		lrbp->command_type = UTP_CMD_TYPE_DEV_MANAGE;
+
 	lrbp->intr_cmd = true; /* No interrupt aggregation */
 	hba->dev_cmd.type = cmd_type;
 
@@ -3187,7 +3207,8 @@ static void ufshcd_transfer_req_compl(struct ufs_hba *hba)
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
index 0ae0967..8dba0e7 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -273,6 +273,7 @@ enum {
 	UTP_CMD_TYPE_SCSI		= 0x0,
 	UTP_CMD_TYPE_UFS		= 0x1,
 	UTP_CMD_TYPE_DEV_MANAGE		= 0x2,
+	UTP_CMD_TYPE_UFS_STORAGE	= 0x11,
 };
 
 enum {
-- 
1.8.1.5
