Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB1CC47094
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D24A260FEF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 04:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhFJEqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 00:46:15 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:10993 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbhFJEqO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jun 2021 00:46:14 -0400
IronPort-SDR: Vj+rtK7BokAmQ8EmYJ5TWOKGfZjBVOyZZ1pinm/RGEoe/ejUNIYv5+dGJzRlZ5P2L0RWGqqEY3
 AP4VwsTshwOB2Mg0jUkqK6MIGcZv15gi2HDrVMPz6Bbtm6je36SQAoFaDcETjzCcsJye83W1S/
 SSfY3/n+JPTeuGdzG14qLh5yc4Ufxri51zT8ouUE/effwICOWolCmmq90sT+nKazN33c8NmXku
 F3f99wijrgMDqXhFVaXsL/5fUdTzvjnfJrrWHoyfVJDUutwCBOPlOAj+75r1vV6XSghnVN6I9j
 xgk=
X-IronPort-AV: E=Sophos;i="5.83,262,1616482800"; 
   d="scan'208";a="29778430"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 09 Jun 2021 21:44:19 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 09 Jun 2021 21:44:18 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id E25EF21AF7; Wed,  9 Jun 2021 21:44:18 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 6/9] scsi: ufs: Update ufshcd_recover_pm_error()
Date:   Wed,  9 Jun 2021 21:43:34 -0700
Message-Id: <1623300218-9454-7-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
References: <1623300218-9454-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

After error handler performs a successful reset and restore, all the LUs
become active, forcibly set the runtime PM status of the scsi devices (and
their request queues) underneath hba to ACTIVE to reflect the change. By
doing so, dev->power.runtime_error (if any) can also be cleared, such that
runtime PM can get back to work on them, otherwise the device(s) may be
left either runtime active or runtime suspended permanently.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 49 ++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0afad6b..c418a19 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -243,6 +243,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba);
 static int ufshcd_change_power_mode(struct ufs_hba *hba,
 			     struct ufs_pa_layer_attr *pwr_mode);
 static void ufshcd_schedule_eh_work(struct ufs_hba *hba);
+static void ufshcd_recover_pm_error(struct ufs_hba *hba);
 static int ufshcd_setup_hba_vreg(struct ufs_hba *hba, bool on);
 static int ufshcd_setup_vreg(struct ufs_hba *hba, bool on);
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
@@ -5951,13 +5952,15 @@ static int ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	return 0;
 }
 
-static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
+static void ufshcd_err_handling_unprepare(struct ufs_hba *hba, int reset_err)
 {
 	ufshcd_clear_eh_in_progress(hba);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
+	if (!reset_err)
+		ufshcd_recover_pm_error(hba);
 	ufshcd_clear_ua_wluns(hba);
 	ufshcd_rpm_put(hba);
 	pm_runtime_put(hba->dev);
@@ -5976,34 +5979,26 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
 	struct Scsi_Host *shost = hba->host;
-	struct scsi_device *sdev;
-	struct request_queue *q;
+	struct scsi_device *sdev = hba->sdev_ufs_device;
+	struct scsi_target *starget = sdev->sdev_target;
 	int ret;
 
 	hba->is_wl_sys_suspended = false;
-	/*
-	 * Set RPM status of wlun device to RPM_ACTIVE,
-	 * this also clears its runtime error.
-	 */
-	ret = pm_runtime_set_active(&hba->sdev_ufs_device->sdev_gendev);
 
-	/* hba device might have a runtime error otherwise */
-	if (ret)
-		ret = pm_runtime_set_active(hba->dev);
-	/*
-	 * If wlun device had runtime error, we also need to resume those
-	 * consumer scsi devices in case any of them has failed to be
-	 * resumed due to supplier runtime resume failure. This is to unblock
-	 * blk_queue_enter in case there are bios waiting inside it.
-	 */
-	if (!ret) {
-		shost_for_each_device(sdev, shost) {
-			q = sdev->request_queue;
-			if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
-				       q->rpm_status == RPM_SUSPENDING))
-				pm_request_resume(q->dev);
-		}
+	/* Resume parent/target to clear path for pm_runtime_set_active() */
+	pm_runtime_get_sync(&starget->dev);
+	shost_for_each_device(sdev, shost) {
+		struct device *dev = &sdev->sdev_gendev;
+
+		pm_runtime_get_sync(dev);
+		/* Clear dev->power.runtime_error */
+		ret = pm_runtime_set_active(dev);
+		if (!ret)
+			/* runtime_error cleared, kick blk_queue_enter() */
+			blk_set_runtime_active(sdev->request_queue);
+		pm_runtime_put(dev);
 	}
+	pm_runtime_put(&starget->dev);
 }
 #else
 static inline void ufshcd_recover_pm_error(struct ufs_hba *hba)
@@ -6037,7 +6032,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
-	int err = 0, pmc_err;
+	int err = -1, pmc_err;
 	int tag;
 	bool needs_reset = false, needs_restore = false;
 
@@ -6189,8 +6184,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 		if (err)
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
-		else
-			ufshcd_recover_pm_error(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
 	}
 
@@ -6203,7 +6196,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_err_handling_unprepare(hba);
+	ufshcd_err_handling_unprepare(hba, err);
 	up(&hba->host_sem);
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

