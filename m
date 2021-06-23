Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33558C48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E6846128A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhFWHkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:40:03 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1666 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhFWHjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:39 -0400
IronPort-SDR: gxr3rinUnZwqhDdvoPSRL3vJPIPKMfWgnZxn3KTf+6ceJ/uPEtNRQLo7c4+cgAZ/VJjjaCaRZK
 4hetoaFwvUTjqYQthpw+igVHNe96ts1DoJEhPg5EKnryoN/4a4bDpdiSPcw7v5kjXuFmsLxGY0
 5buz/q0xuKhWTdo+4fghNnlusBHXVxAit8gexCVBTmNum1dop7bBPRBTz8mhJV1LLV605VrkWS
 rrsbuJ/ne/ptgMtLuEH4friErVigXmi8xJROLWfzbldzPwshRd7RfChmoub1RjD+nBjiNiWTUc
 BwA=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="29780823"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:18 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:37:18 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1ABA121BC1; Wed, 23 Jun 2021 00:37:18 -0700 (PDT)
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
Subject: [PATCH v4 08/10] scsi: ufs: Update ufshcd_recover_pm_error()
Date:   Wed, 23 Jun 2021 00:35:08 -0700
Message-Id: <1624433711-9339-10-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
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
index 379c6a0..d739401 100644
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
@@ -5946,13 +5947,15 @@ static int ufshcd_err_handling_prepare(struct ufs_hba *hba)
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
@@ -5972,34 +5975,26 @@ static inline bool ufshcd_err_handling_should_stop(struct ufs_hba *hba)
 static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 {
 	struct Scsi_Host *shost = hba->host;
-	struct scsi_device *sdev;
-	struct request_queue *q;
+	struct scsi_device *sdev = hba->sdev_ufs_device;
+	struct scsi_target *starget = sdev->sdev_target;
 	int ret;
 
 	hba->is_wlu_sys_suspended = false;
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
@@ -6033,7 +6028,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 	unsigned long flags;
 	bool err_xfer = false;
 	bool err_tm = false;
-	int err = 0, pmc_err;
+	int err = -1, pmc_err;
 	int tag;
 	bool needs_reset = false, needs_restore = false;
 
@@ -6185,8 +6180,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 		if (err)
 			dev_err(hba->dev, "%s: reset and restore failed with err %d\n",
 					__func__, err);
-		else
-			ufshcd_recover_pm_error(hba);
 		spin_lock_irqsave(hba->host->host_lock, flags);
 	}
 
@@ -6199,7 +6192,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_err_handling_unprepare(hba);
+	ufshcd_err_handling_unprepare(hba, err);
 	up(&hba->host_sem);
 }
 
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

