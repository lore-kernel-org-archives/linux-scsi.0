From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 2/2] scsi: ufs: fix sparse warning
Date: Mon, 29 Sep 2014 13:32:43 +0300
Message-ID: <1411986763-7389-2-git-send-email-draviv@codeaurora.org>
References: <1411986763-7389-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411986763-7389-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, merez@codeaurora.org, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch fixes newly introduced sparse warning, introduced by
UFS power management series.

Sparse warning:
>> drivers/scsi/ufs/ufshcd.c:1867:5: sparse: symbol
	'ufshcd_uic_pwr_ctrl' was not declared. Should it be static?
>> drivers/scsi/ufs/ufshcd.c:2025:5: sparse: symbol
	'ufshcd_change_power_mode' was not declared. Should it be static?

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 5c78c3d..497c38a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2146,7 +2146,7 @@ EXPORT_SYMBOL_GPL(ufshcd_dme_get_attr);
  *
  * Returns 0 on success, non-zero value on failure
  */
-int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
+static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 {
 	struct completion uic_async_done;
 	unsigned long flags;
@@ -2309,7 +2309,7 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	return 0;
 }
 
-int ufshcd_change_power_mode(struct ufs_hba *hba,
+static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode)
 {
 	int ret;
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
