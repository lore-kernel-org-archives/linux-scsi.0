Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2C34C49EA4
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EDAA6128A
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 07:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhFWHja (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 03:39:30 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:9285 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhFWHjQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 03:39:16 -0400
IronPort-SDR: ujXVmqoYARV0Q8xtWsocShnrvWMWpL4um30/LKnCvTJwnfur+9R3D6qcZrrNk8fUkOP4gIW+PM
 oeldCWf5v9ug+TZcJv4RgGOKbyoCZtB1qGu9E4TnDCijfZ7QvdxrZdO6dY1kOks/bbTsP1dBQg
 TgBX6x0EjCLQXD+jQBem1YWUELC4RS9Xa4li6+IhjJvhKMgeVqmCbKQZrDV90kCJS4bzP38uMO
 8Ac8Q5yQ8UD8J/7H+djzDuOXw1qiPe8vijHCMAI3ZLgtF8e4/nUOCjMdQ2dKlaXsNNsHAwb538
 TkI=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="47902944"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 23 Jun 2021 00:36:59 -0700
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 23 Jun 2021 00:36:56 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 95B3521BC1; Wed, 23 Jun 2021 00:36:52 -0700 (PDT)
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
        Adrian Hunter <adrian.hunter@intel.com>,
        Satya Tangirala <satyat@google.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 02/10] scsi: ufs: Add flags pm_op_in_progress and is_sys_suspended
Date:   Wed, 23 Jun 2021 00:35:01 -0700
Message-Id: <1624433711-9339-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add flags pm_op_in_progress and is_sys_suspended to track the status of hba
runtime and system suspend/resume operations.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
 drivers/scsi/ufs/ufshcd.h |  4 ++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c40ba1d..abe5f2d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -551,6 +551,8 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	dev_err(hba->dev, "wlu_pm_op_in_progress=%d, is_wlu_sys_suspended=%d\n",
 		hba->wlu_pm_op_in_progress, hba->is_wlu_sys_suspended);
+	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
+		hba->pm_op_in_progress, hba->is_sys_suspended);
 	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
 		hba->auto_bkops_enabled, hba->host->host_self_blocked);
 	dev_err(hba->dev, "Clk gate=%d\n", hba->clk_gating.state);
@@ -9141,6 +9143,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 
 	if (!hba->is_powered)
 		return 0;
+
+	hba->pm_op_in_progress = true;
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller transaction expected till resume.
@@ -9160,6 +9164,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	ufshcd_vreg_set_lpm(hba);
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
+	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9179,6 +9184,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
 	if (!hba->is_powered)
 		return 0;
 
+	hba->pm_op_in_progress = true;
 	ufshcd_hba_vreg_set_hpm(hba);
 	ret = ufshcd_vreg_set_hpm(hba);
 	if (ret)
@@ -9198,6 +9204,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
+	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9222,6 +9229,8 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
+	if (!ret)
+		hba->is_sys_suspended = true;
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_suspend);
@@ -9247,7 +9256,8 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 	trace_ufshcd_system_resume(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
-
+	if (!ret)
+		hba->is_sys_suspended = false;
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 93aeeb3..1e7fe73 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -754,6 +754,8 @@ struct ufs_hba {
 	struct device_attribute spm_lvl_attr;
 	/* A flag to tell whether __ufshcd_wl_suspend/resume() is in progress */
 	bool wlu_pm_op_in_progress;
+	/* A flag to tell whether ufshcd_suspend/resume() is in progress */
+	bool pm_op_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
@@ -841,6 +843,8 @@ struct ufs_hba {
 	struct ufs_clk_scaling clk_scaling;
 	/* A flag to tell whether the UFS device W-LU is system suspended */
 	bool is_wlu_sys_suspended;
+	/* A flag to tell whether hba is system suspended */
+	bool is_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

