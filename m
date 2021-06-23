Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCDFC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85B316128A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbhFWHj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:59 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:1336 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbhFWHjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:35 -0400
IronPort-SDR: 1sK+7NVO8ocyv0fC1vFZySpl1OO5BRLl07oXIDVFZIgtxyYRDyH9hbJ3F27UJmlOH2plpvEjJh
 +BcCoy3W4RplFAQjcaLzkMSISraDymnL5/puVdCOvFbPduUlEOUb0ad+XIx7cHZuqNK1prNlhe
 slAEnvuDBsiiwPXfLKRYGnR1xyPzZwmMdls0/D2SlxO6j3GvwAzby0tlWw/GGGZPVCmHvVSOup
 QpXHPKveQxOBilp5AKd+R8qdsU9XTiWz2Hq5jGfaALk8+Gn6cTrZsItdapLyyBUmpOUhBmustr
 yLA=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="29780822"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:37:16 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg03-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:37:14 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 8541C21BC1; Wed, 23 Jun 2021 00:37:14 -0700 (PDT)
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
Subject: [PATCH v4 07/10] scsi: ufs: Simplify error handling preparation
Date:   Wed, 23 Jun 2021 00:35:07 -0700
Message-Id: <1624433711-9339-9-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit cb7e6f05fce67c965194ac04467e1ba7bc70b069 ("scsi: ufs: core: Enable
power management for wlun") moves UFS operations out of ufshcd_resume(), so
in error handling preparation, if ufshcd hba has failed to resume, there is
no point to re-enable IRQ/clk/pwr.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 56 +++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a09e4a2..379c6a0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2727,8 +2727,8 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		break;
 	case UFSHCD_STATE_EH_SCHEDULED_FATAL:
 		/*
-		 * pm_runtime_get_sync() is used at error handling preparation
-		 * stage. If a scsi cmd, e.g. the SSU cmd, is sent from hba's
+		 * ufshcd_rpm_get_sync() is used at error handling preparation
+		 * stage. If a scsi cmd, e.g., the SSU cmd, is sent from the
 		 * PM ops, it can never be finished if we let SCSI layer keep
 		 * retrying it, which gets err handler stuck forever. Neither
 		 * can we let the scsi cmd pass through, because UFS is in bad
@@ -5905,34 +5905,31 @@ static void ufshcd_clk_scaling_suspend(struct ufs_hba *hba, bool suspend)
 	}
 }
 
-static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
+static int ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
 	/*
 	 * It is not safe to perform error handling while suspend or resume is
 	 * in progress. Hence the lock_system_sleep() call.
 	 */
 	lock_system_sleep();
+	/*
+	 * Exclusively call pm_runtime_get_sync(hba->dev) once, in case
+	 * following ufshcd_rpm_get_sync() fails.
+	 */
+	pm_runtime_get_sync(hba->dev);
+	if (pm_runtime_suspended(hba->dev) || hba->is_sys_suspended) {
+		pm_runtime_put(hba->dev);
+		unlock_system_sleep();
+		return -EINVAL;
+	}
+
+	ufshcd_set_eh_in_progress(hba);
 	ufshcd_rpm_get_sync(hba);
-	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
+	if (pm_runtime_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
 	    hba->is_wlu_sys_suspended) {
-		enum ufs_pm_op pm_op;
+		enum ufs_pm_op pm_op = hba->is_wlu_sys_suspended ?
+				       UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 
-		/*
-		 * Don't assume anything of resume, if
-		 * resume fails, irq and clocks can be OFF, and powers
-		 * can be OFF or in LPM.
-		 */
-		ufshcd_setup_hba_vreg(hba, true);
-		ufshcd_setup_vreg(hba, true);
-		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
-		ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq2);
-		ufshcd_hold(hba, false);
-		if (!ufshcd_is_clkgating_allowed(hba)) {
-			ufshcd_setup_clocks(hba, true);
-			ufshcd_enable_irq(hba);
-		}
-		ufshcd_release(hba);
-		pm_op = hba->is_wlu_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
 		ufshcd_hold(hba, false);
@@ -5946,16 +5943,19 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 	down_write(&hba->clk_scaling_lock);
 	up_write(&hba->clk_scaling_lock);
 	cancel_work_sync(&hba->eeh_work);
+	return 0;
 }
 
 static void ufshcd_err_handling_unprepare(struct ufs_hba *hba)
 {
+	ufshcd_clear_eh_in_progress(hba);
 	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		ufshcd_clk_scaling_suspend(hba, false);
 	ufshcd_clear_ua_wluns(hba);
 	ufshcd_rpm_put(hba);
+	pm_runtime_put(hba->dev);
 	unlock_system_sleep();
 }
 
@@ -6048,9 +6048,13 @@ static void ufshcd_err_handler(struct work_struct *work)
 		up(&hba->host_sem);
 		return;
 	}
-	ufshcd_set_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_err_handling_prepare(hba);
+	if (ufshcd_err_handling_prepare(hba)) {
+		dev_err(hba->dev, "%s: error handling preparation failed\n",
+				__func__);
+		up(&hba->host_sem);
+		return;
+	}
 	/* Complete requests that have door-bell cleared by h/w */
 	ufshcd_complete_requests(hba);
 	spin_lock_irqsave(hba->host->host_lock, flags);
@@ -6194,7 +6198,6 @@ static void ufshcd_err_handler(struct work_struct *work)
 			dev_err_ratelimited(hba->dev, "%s: exit: saved_err 0x%x saved_uic_err 0x%x",
 			    __func__, hba->saved_err, hba->saved_uic_err);
 	}
-	ufshcd_clear_eh_in_progress(hba);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	ufshcd_err_handling_unprepare(hba);
 	up(&hba->host_sem);
@@ -8995,6 +8998,9 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	/* Enable Auto-Hibernate if configured */
 	ufshcd_auto_hibern8_enable(hba);
+
+	hba->clk_gating.is_suspended = false;
+	ufshcd_release(hba);
 	goto out;
 
 set_old_link_state:
@@ -9004,8 +9010,6 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
-	hba->clk_gating.is_suspended = false;
-	ufshcd_release(hba);
 	hba->wlu_pm_op_in_progress = false;
 	return ret <= 0 ? ret : -EINVAL;
 }
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

