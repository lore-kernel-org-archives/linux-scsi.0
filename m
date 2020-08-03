Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C739CC433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A628820738
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 09:05:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbgHCJFI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 05:05:08 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:3956 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgHCJFI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 05:05:08 -0400
IronPort-SDR: t1JhFbN83uYpwYSfhW57WkE9t415KSwyenRzHfqXwYdJlTuaCOX7XnnIlJfZbYyCf+zSSvgXAw
 gs2crTwwHMirsFywV7TykhPgD6Ez6rcUvS9zulDtXjxYXWXyZfOQWjTt6bPoyx1cbu3ZpB4Hd+
 B9f7s5Grruh7Gh1zji78Ksm7NrSaR3It7s/4d1Er1wuVUC/amIhVdbpBpFT6YgRwNDkGyeJ6iG
 Lmb2b1+2v/twScdGWjXzvFhkwsh7qFWHt8aeatqWU4kzUs/MVHN/3jGBBcXuwGtJ+r5tR3V4zP
 22w=
X-IronPort-AV: E=Sophos;i="5.75,429,1589266800"; 
   d="scan'208";a="47240957"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 03 Aug 2020 02:05:08 -0700
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 03 Aug 2020 02:05:07 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 3EE89214E4; Mon,  3 Aug 2020 02:05:07 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v9 6/9] scsi: ufs: Recover hba runtime PM error in error handler
Date:   Mon,  3 Aug 2020 02:04:41 -0700
Message-Id: <1596445485-19834-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
References: <1596445485-19834-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Current error handler cannot work well or recover hba runtime PM error if
ufshcd_suspend/resume has failed due to UFS errors, e.g. hibern8 enter/exit
error or SSU cmd error. When this happens, error handler may fail doing
full reset and restore because error handler always assumes that powers,
IRQs and clocks are ready after pm_runtime_get_sync returns, but actually
they are not if ufshcd_reusme fails [1]. Besides, if ufschd_suspend/resume
fails due to UFS error, runtime PM framework saves the error value to
dev.power.runtime_error. After that, hba dev runtime suspend/resume would
not be invoked anymore unless runtime_error is cleared [2].

In case of ufshcd_suspend/resume fails due to UFS errors, for scenario [1],
error handler cannot assume anything of pm_runtime_get_sync, meaning error
handler should explicitly turn ON powers, IRQs and clocks again. To get the
hba runtime PM work as regard for scenario [2], error handler can clear the
runtime_error by calling pm_runtime_set_active() if full reset and restore
succeeds. And, more important, if pm_runtime_set_active() returns no error,
which means runtime_error has been cleared, we also need to resume those
scsi devices under hba in case any of them has failed to be resumed due to
hba runtime resume failure. This is to unblock blk_queue_enter in case
there are bios waiting inside it.

Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 108 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 99 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2604016..6a10003 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/bitfield.h>
 #include <linux/blk-pm.h>
+#include <linux/blkdev.h>
 #include "ufshcd.h"
 #include "ufs_quirks.h"
 #include "unipro.h"
@@ -229,6 +230,10 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
 static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
+static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
+static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
+static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
+					 struct ufs_vreg *vreg);
 static int ufshcd_wb_buf_flush_enable(struct ufs_hba *hba);
 static int ufshcd_wb_buf_flush_disable(struct ufs_hba *hba);
 static int ufshcd_wb_ctrl(struct ufs_hba *hba, bool enable);
@@ -5553,6 +5558,84 @@ static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
+{
+	pm_runtime_get_sync(hba->dev);
+	if (pm_runtime_suspended(hba->dev)) {
+		/*
+		 * Don't assume anything of pm_runtime_get_sync(), if
+		 * resume fails, irq and clocks can be OFF, and powers
+		 * can be OFF or in LPM.
+		 */
+		ufshcd_setup_hba_vreg(hba, true);
+		ufshcd_enable_irq(hba);
+		ufshcd_setup_vreg(hba, true);
+		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
+		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
+		ufshcd_hold(hba, false);
+		if (!ufshcd_is_clkgating_allowed(hba))
+			ufshcd_setup_clocks(hba, true);
+		ufshcd_release(hba);
+		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
+	} else {
+		ufshcd_hold(hba, false);
+		if (hba->clk_scaling.is_allowed) {
+			cancel_work_sync(&hba->clk_scaling.suspend_work);
+			cancel_work_sync(&hba->clk_scaling.resume_work);
+			ufshcd_suspend_clkscaling(hba);
+		}
+	}
+}
+
+static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
+{
+	ufshcd_release(hba);
+	if (hba->clk_scaling.is_allowed)
+		ufshcd_resume_clkscaling(hba);
+	pm_runtime_put(hba->dev);
+}
+
+static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
+{
+	return (hba->ufshcd_state == UFSHCD_STATE_ERROR ||
+		(!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
+			ufshcd_is_link_broken(hba))));
+}
+
+#ifdef CONFIG_PM
+static void ufshcd_recover_pm_error(struct ufs_hba *hba)
+{
+	struct Scsi_Host *shost = hba->host;
+	struct scsi_device *sdev;
+	struct request_queue *q;
+	int ret;
+
+	/*
+	 * Set RPM status of hba device to RPM_ACTIVE,
+	 * this also clears its runtime error.
+	 */
+	ret = pm_runtime_set_active(hba->dev);
+	/*
+	 * If hba device had runtime error, we also need to resume those
+	 * scsi devices under hba in case any of them has failed to be
+	 * resumed due to hba runtime resume failure. This is to unblock
+	 * blk_queue_enter in case there are bios waiting inside it.
+	 */
+	if (!ret) {
+		list_for_each_entry(sdev, &shost->__devices, siblings) {
+			q = sdev->request_queue;
+			if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
+				       q->rpm_status == RPM_SUSPENDING))
+				pm_request_resume(q->dev);
+		}
+	}
+}
+#else
+static inline void ufshcd_recover_pm_error(struct ufs_hba *hba)
+{
+}
+#endif
+
 /**
  * ufshcd_err_handler - handle UFS errors that require s/w attention
  * @work: pointer to work structure
@@ -5570,9 +5653,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	hba = container_of(work, struct ufs_hba, eh_work);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->ufshcd_state == UFSHCD_STATE_ERROR ||
-	    (!(hba->saved_err || hba->saved_uic_err || hba->force_reset ||
-		ufshcd_is_link_broken(hba)))) {
+	if (ufshcd_err_handling_should_stop(hba)) {
 		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
 			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
@@ -5581,10 +5662,17 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba, false);
-
+	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	/*
+	 * A full reset and restore might have happened after preparation
+	 * is finished, double check whether we should stop.
+	 */
+	if (ufshcd_err_handling_should_stop(hba)) {
+		if (hba->ufshcd_state != UFSHCD_STATE_ERROR)
+			hba->ufshcd_state = UFSHCD_STATE_OPERATIONAL;
+		goto out;
+	}
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 
 	/* Complete requests that have door-bell cleared by h/w */
@@ -5662,10 +5750,12 @@ static void ufshcd_err_handler(struct work_struct *work)
 		hba->force_reset = false;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		err = ufshcd_reset_and_restore(hba);
-		spin_lock_irqsave(hba->host->host_lock, flags);
 		if (err)
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
+		else
+			ufshcd_recover_pm_error(hba);
+		spin_lock_irqsave(hba->host->host_lock, flags);
 	}
 
 skip_err_handling:
@@ -5677,11 +5767,11 @@ static void ufshcd_err_handler(struct work_struct *work)
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
 
+out:
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
-	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_err_handling_unprepare(hba);
 }
 
 /**
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

