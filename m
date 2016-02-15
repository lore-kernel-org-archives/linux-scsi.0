From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v8 2/3] added UFS 2.0 capabilities
Date: Mon, 15 Feb 2016 15:25:12 +0000
Message-ID: <4e48beb48bc4c67c335de45218e2b49aa51dd4d9.1455549222.git.jpinto@synopsys.com>
References: <cover.1455549221.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1455549221.git.jpinto@synopsys.com>
In-Reply-To: <cover.1455549221.git.jpinto@synopsys.com>
References: <cover.1455549221.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, arnd@arndb.de, mark.rutland@arm.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org

Adding UFS 2.0 support to the UFS core driver.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v7->v8:
- Added "jedec, ufs-2.0" to the ufschd-platform compatibility strings
Changes v0->v7:
- Nothing changed (just to keep up with patch set version).

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  4 +--
 drivers/scsi/ufs/ufshcd.c                          | 29 +++++++++++++++++++---
 drivers/scsi/ufs/ufshci.h                          |  1 +
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
index 03c0e98..8d9a9d2 100644
--- a/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
+++ b/Documentation/devicetree/bindings/ufs/ufshcd-pltfrm.txt
@@ -4,8 +4,8 @@ UFSHC nodes are defined to describe on-chip UFS host controllers.
 Each UFS controller instance should have its own node.
 
 Required properties:
-- compatible		: must contain "jedec,ufs-1.1", may also list one or more
-					  of the following:
+- compatible		: must contain "jedec,ufs-1.1" or "jedec,ufs-2.0", may
+			  also list one or more of the following:
 					  "qcom,msm8994-ufshc"
 					  "qcom,msm8996-ufshc"
 					  "qcom,ufshc"
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
