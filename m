From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 2/6] scsi: ufs: fix power info after link start-up
Date: Thu, 23 Oct 2014 13:25:13 +0300
Message-ID: <1414059917-13831-3-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Yaniv Gardi <ygardi@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Yaniv Gardi <ygardi@codeaurora.org>

After link start-up power mode will always be PWM G1. This is not
reflected in the pwr_info struct which will keep the previous values.
Since ufshcd_change_power_mode() tries to avoid unnecessary power mode
change if the requested power mode and current power mode are same,
power mode change won't execute again after driver initialization.

This patch solves the problem by setting pwr_info to PWM G1 after link
start-up.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 59b6544..77a4e38 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2246,6 +2246,22 @@ static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba)
 	return ret;
 }
 
+ /**
+ * ufshcd_init_pwr_info - setting the POR (power on reset)
+ * values in hba power info
+ * @hba: per-adapter instance
+ */
+static void ufshcd_init_pwr_info(struct ufs_hba *hba)
+{
+	hba->pwr_info.gear_rx = UFS_PWM_G1;
+	hba->pwr_info.gear_tx = UFS_PWM_G1;
+	hba->pwr_info.lane_rx = 1;
+	hba->pwr_info.lane_tx = 1;
+	hba->pwr_info.pwr_rx = SLOWAUTO_MODE;
+	hba->pwr_info.pwr_tx = SLOWAUTO_MODE;
+	hba->pwr_info.hs_rate = 0;
+}
+
 /**
  * ufshcd_get_max_pwr_mode - reads the max power mode negotiated with device
  * @hba: per-adapter instance
@@ -4118,6 +4134,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
+	ufshcd_init_pwr_info(hba);
+
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
 
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
