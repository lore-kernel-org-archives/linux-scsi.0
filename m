From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1] ufs: introcude UFSHCD_QUIRK_GET_VS_RESULT quirk
Date: Tue, 08 Nov 2016 16:48:52 +0900
Message-ID: <002001d23994$8cce5080$a66af180$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:48942 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbcKHHtb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 02:49:31 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGB00QVFCDFR370@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 08 Nov 2016 16:48:52 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, vinholikatti@gmail.com
Cc: =?UTF-8?B?7LaU7ZeM6rSR?= <hg.chu@samsung.com>

Some UFS host controllers may not report a result of
UIC command completion properly.
In such cases, they should get the result from UIC directly
if their architectures support that.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 27 +++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h | 20 ++++++++++++++++++++
 2 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d4a5a9c..8e19631 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1011,7 +1011,10 @@ static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
  */
 static inline u8 ufshcd_get_upmcrs(struct ufs_hba *hba)
 {
-	return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
+	if (hba->quirks & UFSHCD_QUIRK_GET_VS_RESULT)
+		return (u8)ufshcd_vops_get_vs_info(hba, VS_OP_03);
+	else
+		return (ufshcd_readl(hba, REG_CONTROLLER_STATUS) >> 8) & 0x7;
 }
 
 /**
@@ -1038,6 +1041,17 @@ ufshcd_dispatch_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		      REG_UIC_COMMAND);
 }
 
+static inline enum vs_opcode ufshcd_get_vs_opcode(struct uic_command *uic_cmd)
+{
+	if (uic_cmd->command == UIC_CMD_DME_LINK_STARTUP)
+		return VS_OP_00;
+	else if ((uic_cmd->command == UIC_CMD_DME_HIBER_ENTER))
+		return VS_OP_01;
+	else if ((uic_cmd->command == UIC_CMD_DME_HIBER_EXIT))
+		return VS_OP_02;
+	else
+		return VS_OP_INVALID;
+}
 /**
  * ufshcd_wait_for_uic_cmd - Wait complectioin of UIC command
  * @hba: per adapter instance
@@ -1051,11 +1065,16 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 {
 	int ret;
 	unsigned long flags;
+	enum vs_opcode vs_op = ufshcd_get_vs_opcode(uic_cmd);
 
 	if (wait_for_completion_timeout(&uic_cmd->done,
-					msecs_to_jiffies(UIC_CMD_TIMEOUT)))
-		ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
-	else
+					msecs_to_jiffies(UIC_CMD_TIMEOUT))) {
+		if (hba->quirks & UFSHCD_QUIRK_GET_VS_RESULT &&
+					vs_op != VS_OP_INVALID)
+			ret = ufshcd_vops_get_vs_info(hba, vs_op);
+		else
+			ret = uic_cmd->argument2 & MASK_UIC_COMMAND_RESULT;
+	} else
 		ret = -ETIMEDOUT;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 13504b4..8cf3991 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -245,6 +245,14 @@ struct ufs_pwr_mode_info {
 	struct ufs_pa_layer_attr info;
 };
 
+enum vs_opcode {
+	VS_OP_00 = 0x00,
+	VS_OP_01,
+	VS_OP_02,
+	VS_OP_03,
+	VS_OP_INVALID = 0xFF,
+};
+
 /**
  * struct ufs_hba_variant_ops - variant specific callbacks
  * @name: variant name
@@ -297,6 +305,7 @@ struct ufs_hba_variant_ops {
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
 	int	(*phy_initialization)(struct ufs_hba *);
+	int	(*get_vs_info)(struct ufs_hba *hba, enum vs_opcode);
 };
 
 /* clock gating state  */
@@ -484,6 +493,8 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
 
+	#define UFSHCD_QUIRK_GET_VS_RESULT			UFS_BIT(6)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	/* Device deviations from standard UFS device spec. */
@@ -853,4 +864,13 @@ static inline void ufshcd_vops_dbg_register_dump(struct ufs_hba *hba)
 		hba->vops->dbg_register_dump(hba);
 }
 
+static inline int ufshcd_vops_get_vs_info(struct ufs_hba *hba,
+					enum vs_opcode op)
+{
+	if (hba->vops && hba->vops->get_vs_info)
+		return hba->vops->get_vs_info(hba, op);
+
+	return -ENOTSUPP;
+}
+
 #endif /* End of Header */
-- 
2.1.4

