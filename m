From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v5 09/11] scsi: ufs: make ufshcd_config_pwr_mode of non-static
 func
Date: Mon, 09 Nov 2015 10:56:25 +0530
Message-ID: <1447046787-480-10-git-send-email-alim.akhtar@samsung.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, gautam.vivek@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, kishon@ti.com
List-Id: linux-scsi@vger.kernel.org

From: Seungwon Jeon <essuuj@gmail.com>

This makes ufshcd_config_pwr_mode non-static so that other vendors
like exynos can use the same.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c |    5 ++---
 drivers/scsi/ufs/ufshcd.h |    2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 075b7bf13080..358d9114a1a5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -185,8 +185,6 @@ static int ufshcd_uic_hibern8_ctrl(struct ufs_hba *hba, bool en);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
 
@@ -2592,7 +2590,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
  */
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
@@ -2608,6 +2606,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
 /**
  * ufshcd_complete_dev_init() - checks device readiness
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 9c69dd2f3672..8cad52c072d4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -666,6 +666,8 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+			struct ufs_pa_layer_attr *desired_pwr_mode);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
1.7.10.4
