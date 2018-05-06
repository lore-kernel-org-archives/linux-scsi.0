From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 4/4] scsi: ufs: make ufshcd_config_pwr_mode of non-static
 func
Date: Sun, 06 May 2018 15:44:18 +0530
Message-ID: <1525601658-31989-5-git-send-email-alim.akhtar@samsung.com>
References: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
        <CGME20180506102643epcas2p24ed80d7ede859db73c2595724d9c2414@epcas2p2.samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1525601658-31989-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vivek.gautam@codeaurora.org, subhashj@codeaurora.org, vinholikatti@gmail.com, olof@lixom.net, alim.akhtar@samsung.com
List-Id: linux-scsi@vger.kernel.org

This makes ufshcd_config_pwr_mode non-static so that other vendors
like exynos can use the same.

Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 ++---
 drivers/scsi/ufs/ufshcd.h | 2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5bfd385..68aefcd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -233,8 +233,6 @@ static void ufshcd_suspend_clkscaling(struct ufs_hba *hba);
 static void __ufshcd_suspend_clkscaling(struct ufs_hba *hba);
 static int ufshcd_scale_clks(struct ufs_hba *hba, bool scale_up);
 static irqreturn_t ufshcd_intr(int irq, void *__hba);
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
-		struct ufs_pa_layer_attr *desired_pwr_mode);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
 static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
@@ -3969,7 +3967,7 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
  * @hba: per-adapter instance
  * @desired_pwr_mode: desired power configuration
  */
-static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 		struct ufs_pa_layer_attr *desired_pwr_mode)
 {
 	struct ufs_pa_layer_attr final_params = { 0 };
@@ -3987,6 +3985,7 @@ static int ufshcd_config_pwr_mode(struct ufs_hba *hba,
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ufshcd_config_pwr_mode);
 
 /**
  * ufshcd_complete_dev_init() - checks device readiness
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 013a07e..b42a5a3 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -805,6 +805,8 @@ extern int ufshcd_dme_set_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u8 attr_set, u32 mib_val, u8 peer);
 extern int ufshcd_dme_get_attr(struct ufs_hba *hba, u32 attr_sel,
 			       u32 *mib_val, u8 peer);
+extern int ufshcd_config_pwr_mode(struct ufs_hba *hba,
+			struct ufs_pa_layer_attr *desired_pwr_mode);
 
 /* UIC command interfaces for DME primitives */
 #define DME_LOCAL	0
-- 
2.7.4
