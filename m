From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v3 09/13] scsi: ufs: make ufshcd_config_pwr_mode of non-static
 func
Date: Thu, 01 Oct 2015 13:39:26 +0530
Message-ID: <1443686970-28104-10-git-send-email-alim.akhtar@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:58136 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbbJAIYO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2015 04:24:14 -0400
In-reply-to: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org

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
index 73a8d13..66f2fb8 100644
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
 
@@ -2598,7 +2596,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
  */
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
@@ -2614,6 +2612,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
 /**
  * ufshcd_complete_dev_init() - checks device readiness
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 845d1c2..f771cb8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -636,6 +636,8 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+			struct ufs_pa_layer_attr *desired_pwr_mode);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
1.7.10.4

