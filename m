From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V3 15/16] scsi: ufs: tune bkops while power managment events
Date: Wed, 10 Sep 2014 14:54:22 +0300
Message-ID: <1410350063-23267-16-git-send-email-draviv@codeaurora.org>
References: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:44028 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbaIJLzN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 07:55:13 -0400
In-Reply-To: <1410350063-23267-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

Add capability to control the auto bkops during suspend.
If host explicitly enables the auto bkops (background operation) on device
then only device would perform the bkops on its own. If auto bkops is not
enabled explicitly and if the device reaches to state where it must do
background operation, device would raise the urgent bkops exception event
to host and then host will enable the auto bkops on device. This patch
adds the option to choose whether auto bkops should be enabled during
runtime suspend or not. Since we don't want to keep the device active to
perform the non critical bkops, host will enable urgent bkops only.

Keep auto-bkops enabled after resume if urgent bkops needed.
If device bkops status shows that its in critical need of executing
background operations, host should allow the device to continue doing
background operations.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0bbb933..33984cc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4719,13 +4719,19 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	}
 
 	if (ufshcd_is_runtime_pm(pm_op)) {
-		/*
-		 * The device is idle with no requests in the queue,
-		 * allow background operations if needed.
-		 */
-		ret = ufshcd_bkops_ctrl(hba, BKOPS_STATUS_NON_CRITICAL);
-		if (ret)
-			goto enable_gating;
+		if (ufshcd_can_autobkops_during_suspend(hba)) {
+			/*
+			 * The device is idle with no requests in the queue,
+			 * allow background operations if bkops status shows
+			 * that performance might be impacted.
+			 */
+			ret = ufshcd_urgent_bkops(hba);
+			if (ret)
+				goto enable_gating;
+		} else {
+			/* make sure that auto bkops is disabled */
+			ufshcd_disable_auto_bkops(hba);
+		}
 	}
 
 	if ((req_dev_pwr_mode != hba->curr_dev_pwr_mode) &&
@@ -4871,7 +4877,11 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 			goto set_old_link_state;
 	}
 
-	ufshcd_disable_auto_bkops(hba);
+	/*
+	 * If BKOPs operations are urgently needed at this moment then
+	 * keep auto-bkops enabled or else disable it.
+	 */
+	ufshcd_urgent_bkops(hba);
 	hba->clk_gating.is_suspended = false;
 
 	if (ufshcd_is_clkscaling_enabled(hba))
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d5699d0..b94b835 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -466,6 +466,8 @@ struct ufs_hba {
 #define UFSHCD_CAP_HIBERN8_WITH_CLK_GATING (1 << 1)
 	/* Allow dynamic clk scaling */
 #define UFSHCD_CAP_CLK_SCALING	(1 << 2)
+	/* Allow auto bkops to enabled during runtime suspend */
+#define UFSHCD_CAP_AUTO_BKOPS_SUSPEND (1 << 3)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
@@ -484,6 +486,11 @@ static inline int ufshcd_is_clkscaling_enabled(struct ufs_hba *hba)
 {
 	return hba->caps & UFSHCD_CAP_CLK_SCALING;
 }
+static inline bool ufshcd_can_autobkops_during_suspend(struct ufs_hba *hba)
+{
+	return hba->caps & UFSHCD_CAP_AUTO_BKOPS_SUSPEND;
+}
+
 #define ufshcd_writel(hba, val, reg)	\
 	writel((val), (hba)->mmio_base + (reg))
 #define ufshcd_readl(hba, reg)	\
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

