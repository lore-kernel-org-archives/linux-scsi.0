From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 3/4] scsi: ufs: add quirk to increase host PA_SaveConfigTime
Date: Mon,  5 Dec 2016 19:25:32 -0800
Message-ID: <1480994732-19698-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbcLFDZj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 22:25:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>

The maximum value PA_SaveConfigTime is 250 (10us) but this is not enough
for some vendors. Gear switch from PWM to HS may fail even with this max.
PA_SaveConfigTime. Gear switch can be issued by host controller as an
error recovery and any software delay will not help on this case so we
need to increase PA_SaveConfigTime to >32us as per vendor recommendation.
This change adds a quirk to increase the PA_SaveConfigTime parameter.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c   | 30 ++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufs-qcom.h   |  1 +
 drivers/scsi/ufs/ufs_quirks.h | 30 +++++++++---------------------
 drivers/scsi/ufs/ufshcd.c     | 26 ++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.h     | 12 ++++++++++--
 5 files changed, 76 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index ff61461..2943a68 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -23,6 +23,7 @@
 #include "unipro.h"
 #include "ufs-qcom.h"
 #include "ufshci.h"
+#include "ufs_quirks.h"
 #define UFS_QCOM_DEFAULT_DBG_PRINT_EN	\
 	(UFS_QCOM_DBG_PRINT_REGS_EN | UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
 
@@ -1031,6 +1032,34 @@ static int ufs_qcom_pwr_change_notify(struct ufs_hba *hba,
 	return ret;
 }
 
+static int ufs_qcom_quirk_host_pa_saveconfigtime(struct ufs_hba *hba)
+{
+	int err;
+	u32 pa_vs_config_reg1;
+
+	err = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_VS_CONFIG_REG1),
+			     &pa_vs_config_reg1);
+	if (err)
+		goto out;
+
+	/* Allow extension of MSB bits of PA_SaveConfigTime attribute */
+	err = ufshcd_dme_set(hba, UIC_ARG_MIB(PA_VS_CONFIG_REG1),
+			    (pa_vs_config_reg1 | (1 << 12)));
+
+out:
+	return err;
+}
+
+static int ufs_qcom_apply_dev_quirks(struct ufs_hba *hba)
+{
+	int err = 0;
+
+	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME)
+		err = ufs_qcom_quirk_host_pa_saveconfigtime(hba);
+
+	return err;
+}
+
 static u32 ufs_qcom_get_ufs_hci_version(struct ufs_hba *hba)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
@@ -1618,6 +1647,7 @@ static void ufs_qcom_dump_dbg_regs(struct ufs_hba *hba)
 	.hce_enable_notify      = ufs_qcom_hce_enable_notify,
 	.link_startup_notify    = ufs_qcom_link_startup_notify,
 	.pwr_change_notify	= ufs_qcom_pwr_change_notify,
+	.apply_dev_quirks	= ufs_qcom_apply_dev_quirks,
 	.suspend		= ufs_qcom_suspend,
 	.resume			= ufs_qcom_resume,
 	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
diff --git a/drivers/scsi/ufs/ufs-qcom.h b/drivers/scsi/ufs/ufs-qcom.h
index a19307a..fe517cd 100644
--- a/drivers/scsi/ufs/ufs-qcom.h
+++ b/drivers/scsi/ufs/ufs-qcom.h
@@ -142,6 +142,7 @@ enum ufs_qcom_phy_init_type {
 	 UFS_QCOM_DBG_PRINT_TEST_BUS_EN)
 
 /* QUniPro Vendor specific attributes */
+#define PA_VS_CONFIG_REG1	0x9000
 #define DME_VS_CORE_CLK_CTRL	0xD002
 /* bit and mask definitions for DME_VS_CORE_CLK_CTRL attribute */
 #define DME_VS_CORE_CLK_CTRL_CORE_CLK_DIV_EN_BIT		BIT(8)
diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
index f798305..08b799d 100644
--- a/drivers/scsi/ufs/ufs_quirks.h
+++ b/drivers/scsi/ufs/ufs_quirks.h
@@ -134,29 +134,17 @@ struct ufs_dev_fix {
  */
 #define UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE	(1 << 7)
 
+/*
+ * The max. value PA_SaveConfigTime is 250 (10us) but this is not enough for
+ * some vendors.
+ * Gear switch from PWM to HS may fail even with this max. PA_SaveConfigTime.
+ * Gear switch can be issued by host controller as an error recovery and any
+ * software delay will not help on this case so we need to increase
+ * PA_SaveConfigTime to >32us as per vendor recommendation.
+ */
+#define UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME	(1 << 8)
 
 struct ufs_hba;
 void ufs_advertise_fixup_device(struct ufs_hba *hba);
 
-static struct ufs_dev_fix ufs_fixups[] = {
-	/* UFS cards deviations table */
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_NO_FASTAUTO),
-	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
-		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
-		UFS_DEVICE_QUIRK_PA_TACTIVATE),
-	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
-
-	END_FIX
-};
 #endif /* UFS_QUIRKS_H_ */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7af70aa..af7e028 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -185,6 +185,30 @@ enum {
 	return ufs_pm_lvl_states[lvl].link_state;
 }
 
+static struct ufs_dev_fix ufs_fixups[] = {
+	/* UFS cards deviations table */
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_RECOVERY_FROM_DL_NAC_ERRORS),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_NO_FASTAUTO),
+	UFS_FIX(UFS_VENDOR_SAMSUNG, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_DELAY_BEFORE_LPM),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9C8KBADG",
+		UFS_DEVICE_QUIRK_PA_TACTIVATE),
+	UFS_FIX(UFS_VENDOR_TOSHIBA, "THGLF2G9D8KBADG",
+		UFS_DEVICE_QUIRK_PA_TACTIVATE),
+	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
+	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
+		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
+
+	END_FIX
+};
+
 static void ufshcd_tmc_handler(struct ufs_hba *hba);
 static void ufshcd_async_scan(void *data, async_cookie_t cookie);
 static int ufshcd_reset_and_restore(struct ufs_hba *hba);
@@ -5213,6 +5237,8 @@ static void ufshcd_tune_unipro_params(struct ufs_hba *hba)
 
 	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_PA_TACTIVATE)
 		ufshcd_quirk_tune_host_pa_tactivate(hba);
+
+	ufshcd_vops_apply_dev_quirks(hba);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 7d9ff22..08cd26e 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -266,7 +266,7 @@ struct ufs_pwr_mode_info {
  * @setup_task_mgmt: called before any task management request is issued
  *                  to set some things
  * @hibern8_notify: called around hibern8 enter/exit
- *		    to configure some things
+ * @apply_dev_quirks: called to apply device specific quirks
  * @suspend: called during host controller PM callback
  * @resume: called during host controller PM callback
  * @dbg_register_dump: used to dump controller debug information
@@ -293,7 +293,8 @@ struct ufs_hba_variant_ops {
 	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
-				       enum ufs_notify_change_status);
+					enum ufs_notify_change_status);
+	int	(*apply_dev_quirks)(struct ufs_hba *);
 	int     (*suspend)(struct ufs_hba *, enum ufs_pm_op);
 	int     (*resume)(struct ufs_hba *, enum ufs_pm_op);
 	void	(*dbg_register_dump)(struct ufs_hba *hba);
@@ -839,6 +840,13 @@ static inline void ufshcd_vops_hibern8_notify(struct ufs_hba *hba,
 		return hba->vops->hibern8_notify(hba, cmd, status);
 }
 
+static inline int ufshcd_vops_apply_dev_quirks(struct ufs_hba *hba)
+{
+	if (hba->vops && hba->vops->apply_dev_quirks)
+		return hba->vops->apply_dev_quirks(hba);
+	return 0;
+}
+
 static inline int ufshcd_vops_suspend(struct ufs_hba *hba, enum ufs_pm_op op)
 {
 	if (hba->vops && hba->vops->suspend)
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

