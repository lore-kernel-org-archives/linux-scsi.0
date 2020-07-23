Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 501BFC433F2
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:47:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30FC42080D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 11:47:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgGWLq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 07:46:57 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:16314 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728453AbgGWLq5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 07:46:57 -0400
IronPort-SDR: JI9qnLjrw8zbDZmV8MArq+7mXsUf3Cc04qQJ7QkqMVVyh8Gc7s41TIivTrLKEucleXnXeCKJdo
 MsziDNkHeEf3ZmhisH5JT4/MCYdC36pmn38iryKvuEURwrgrRMyBZzOB9faUJKknzt7Pb8T+TT
 uizA0GVOcZlkYmbcJNc3Ocod7VdX9pFF49rwyFbiyvAcpgoP/6C0ZABGPn1Jgc9SGBHx9JqTse
 5+WHiU1uQyngfZZexJQVnBfVRzSo3et7hCJtDKr9bBGo4Xu/YXySmQUdAYRESyq6Wy3tiyy/9Y
 ljc=
X-IronPort-AV: E=Sophos;i="5.75,386,1589266800"; 
   d="scan'208";a="29048255"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 23 Jul 2020 04:46:56 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Jul 2020 04:46:56 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id DD65822E23; Thu, 23 Jul 2020 04:46:55 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        sh425.lee@samsung.com, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v6 6/8] scsi: ufs: Recover hba runtime PM error in error handler
Date:   Thu, 23 Jul 2020 04:46:24 -0700
Message-Id: <1595504787-19429-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
References: <1595504787-19429-1-git-send-email-cang@codeaurora.org>
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

In addition, if ufshcd_resume errors out, ufshcd_release in ufshcd_resume
would be skipped. After hba runtime PM error is recovered in error handler,
we should do ufshcd_release once to get clock gating back to work.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 91 +++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/ufs/ufshcd.h |  1 +
 2 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c2d7a90..c480823 100644
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
@@ -5553,6 +5558,78 @@ static inline void ufshcd_schedule_eh_work(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
+{
+	pm_runtime_get_sync(hba->dev);
+	if (pm_runtime_status_suspended(hba->dev)) {
+		/*
+		 * Don't assume anything of pm_runtime_get_sync(), if
+		 * resume fails, irq and clocks can be OFF, and powers
+		 * can be OFF or in LPM.
+		 */
+		ufshcd_setup_hba_vreg(hba, true);
+		ufshcd_setup_clocks(hba, true);
+		ufshcd_enable_irq(hba);
+		ufshcd_setup_vreg(hba, true);
+		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
+		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
+		ufshcd_vops_resume(hba, UFS_RUNTIME_PM);
+	}
+	ufshcd_hold(hba, false);
+	if (ufshcd_is_clkscaling_supported(hba)) {
+		cancel_work_sync(&hba->clk_scaling.suspend_work);
+		cancel_work_sync(&hba->clk_scaling.resume_work);
+		ufshcd_suspend_clkscaling(hba);
+	}
+}
+
+static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
+{
+	/* If clk_gating is held by pm ops, release it */
+	if (pm_runtime_active(hba->dev) && hba->clk_gating.held_by_pm) {
+		hba->clk_gating.held_by_pm = false;
+		ufshcd_release(hba);
+	}
+	ufshcd_release(hba);
+	if (ufshcd_is_clkscaling_supported(hba))
+		ufshcd_resume_clkscaling(hba);
+	pm_runtime_put(hba->dev);
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
+						q->rpm_status == RPM_SUSPENDING))
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
@@ -5580,9 +5657,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	}
 	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	pm_runtime_get_sync(hba->dev);
-	ufshcd_hold(hba, false);
-
+	ufshcd_err_handling_prepare(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->ufshcd_state = UFSHCD_STATE_RESET;
 
@@ -5661,10 +5736,12 @@ static void ufshcd_err_handler(struct work_struct *work)
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
@@ -5679,8 +5756,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_scsi_unblock_requests(hba);
-	ufshcd_release(hba);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_err_handling_unprepare(hba);
 }
 
 /**
@@ -8232,6 +8308,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	 * just gate the clocks.
 	 */
 	ufshcd_hold(hba, false);
+	hba->clk_gating.held_by_pm = true;
 	hba->clk_gating.is_suspended = true;
 
 	if (hba->clk_scaling.is_allowed) {
@@ -8351,6 +8428,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	hba->clk_gating.is_suspended = false;
 	hba->dev_info.b_rpm_dev_flush_capable = false;
 	ufshcd_release(hba);
+	hba->clk_gating.held_by_pm = false;
 out:
 	if (hba->dev_info.b_rpm_dev_flush_capable) {
 		schedule_delayed_work(&hba->rpm_dev_flush_recheck_work,
@@ -8457,6 +8535,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
+	hba->clk_gating.held_by_pm = false;
 
 	goto out;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 83e5cd9..585e58b 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -354,6 +354,7 @@ struct ufs_clk_gating {
 	struct device_attribute delay_attr;
 	struct device_attribute enable_attr;
 	bool is_enabled;
+	bool held_by_pm;
 	int active_reqs;
 	struct workqueue_struct *clk_gating_workq;
 };
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

