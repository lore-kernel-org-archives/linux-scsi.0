Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 057E6C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C6460FE4
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 08:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhEXItD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 04:49:03 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:4217 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhEXItC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 04:49:02 -0400
IronPort-SDR: SCTIeINVKE3Rk6lueOllKahbgRMm/8yxsxxWigw1PiZRmOc1W6MLy6VuWyjoCm9h2jd1KCKfza
 AtFnOIdMarhPt6Ec41dWpYlOdMjfKfS2Y23/xJ5pH05zr+jRx9rbkK03JY0PXvBXiJFXyE43tt
 fVurMWXwWlEgZ2RX5zslKk1OYTMDhs5e8kBIYCaJQOh+9Y6qXl/bxzH7vZd+MP0aApaPrxIY86
 zTjaDecALRuzH5dUM5smUuS+ihEPlyZBR6i1yeXLxSIg14pBOUTEN4BDSCRaiWWMj/7nRxsgti
 ucA=
X-IronPort-AV: E=Sophos;i="5.82,319,1613462400"; 
   d="scan'208";a="29772334"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 24 May 2021 01:47:35 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 24 May 2021 01:47:34 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id ECB1921AD7; Mon, 24 May 2021 01:47:34 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/6] scsi: ufs: Differentiate status between hba pm ops and wl pm ops
Date:   Mon, 24 May 2021 01:47:20 -0700
Message-Id: <1621846046-22204-2-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
References: <1621846046-22204-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Put pm_op_in_progress and is_sys_suspend flags back to ufshcd hba pm ops,
add two new flags, namely wl_pm_op_in_progress and is_wl_sys_suspended, to
track the UFS device W-LU pm ops. This helps us differentiate the status of
hba and wl pm ops when we need to do troubleshooting.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 42 ++++++++++++++++++++++++++++--------------
 drivers/scsi/ufs/ufshcd.h |  4 +++-
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2b7ad26..3836a0a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -543,7 +543,9 @@ static void ufshcd_print_host_state(struct ufs_hba *hba)
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=%d, UIC link state=%d\n",
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
-	dev_err(hba->dev, "PM in progress=%d, sys. suspended=%d\n",
+	dev_err(hba->dev, "wl_pm_op_in_progress=%d, is_wl_sys_suspended=%d\n",
+		hba->wl_pm_op_in_progress, hba->is_wl_sys_suspended);
+	dev_err(hba->dev, "pm_op_in_progress=%d, is_sys_suspended=%d\n",
 		hba->pm_op_in_progress, hba->is_sys_suspended);
 	dev_err(hba->dev, "Auto BKOPS=%d, Host self-block=%d\n",
 		hba->auto_bkops_enabled, hba->host->host_self_blocked);
@@ -1993,7 +1995,7 @@ static void ufshcd_clk_scaling_start_busy(struct ufs_hba *hba)
 	if (!hba->clk_scaling.active_reqs++)
 		queue_resume_work = true;
 
-	if (!hba->clk_scaling.is_enabled || hba->pm_op_in_progress) {
+	if (!hba->clk_scaling.is_enabled || hba->wl_pm_op_in_progress) {
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
 		return;
 	}
@@ -2728,7 +2730,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		 * err handler blocked for too long. So, just fail the scsi cmd
 		 * sent from PM ops, err handler can recover PM error anyways.
 		 */
-		if (hba->pm_op_in_progress) {
+		if (hba->wl_pm_op_in_progress) {
 			hba->force_reset = true;
 			set_host_byte(cmd, DID_BAD_TARGET);
 			cmd->scsi_done(cmd);
@@ -2761,7 +2763,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 		(hba->clk_gating.state != CLKS_ON));
 
 	if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
-		if (hba->pm_op_in_progress)
+		if (hba->wl_pm_op_in_progress)
 			set_host_byte(cmd, DID_BAD_TARGET);
 		else
 			err = SCSI_MLQUEUE_HOST_BUSY;
@@ -5110,7 +5112,7 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 			 * solution could be to abort the system suspend if
 			 * UFS device needs urgent BKOPs.
 			 */
-			if (!hba->pm_op_in_progress &&
+			if (!hba->wl_pm_op_in_progress &&
 			    !ufshcd_eh_in_progress(hba) &&
 			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
 				/* Flushed in suspend */
@@ -5910,7 +5912,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 {
 	ufshcd_rpm_get_sync(hba);
 	if (pm_runtime_status_suspended(&hba->sdev_ufs_device->sdev_gendev) ||
-	    hba->is_sys_suspended) {
+	    hba->is_wl_sys_suspended) {
 		enum ufs_pm_op pm_op;
 
 		/*
@@ -5927,7 +5929,7 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
 		ufshcd_release(hba);
-		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
+		pm_op = hba->is_wl_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
 		ufshcd_hold(hba, false);
@@ -5970,7 +5972,7 @@ static void ufshcd_recover_pm_error(struct ufs_hba *hba)
 	struct request_queue *q;
 	int ret;
 
-	hba->is_sys_suspended = false;
+	hba->is_wl_sys_suspended = false;
 	/*
 	 * Set RPM status of wlun device to RPM_ACTIVE,
 	 * this also clears its runtime error.
@@ -8774,7 +8776,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
 
-	hba->pm_op_in_progress = true;
+	hba->wl_pm_op_in_progress = true;
 	if (pm_op != UFS_SHUTDOWN_PM) {
 		pm_lvl = pm_op == UFS_RUNTIME_PM ?
 			 hba->rpm_lvl : hba->spm_lvl;
@@ -8909,7 +8911,7 @@ static int __ufshcd_wl_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		hba->clk_gating.is_suspended = false;
 		ufshcd_release(hba);
 	}
-	hba->pm_op_in_progress = false;
+	hba->wl_pm_op_in_progress = false;
 	return ret;
 }
 
@@ -8918,7 +8920,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	int ret;
 	enum uic_link_state old_link_state = hba->uic_link_state;
 
-	hba->pm_op_in_progress = true;
+	hba->wl_pm_op_in_progress = true;
 
 	/*
 	 * Call vendor specific resume callback. As these callbacks may access
@@ -8996,7 +8998,7 @@ static int __ufshcd_wl_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		ufshcd_update_evt_hist(hba, UFS_EVT_WL_RES_ERR, (u32)ret);
 	hba->clk_gating.is_suspended = false;
 	ufshcd_release(hba);
-	hba->pm_op_in_progress = false;
+	hba->wl_pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9062,7 +9064,7 @@ static int ufshcd_wl_suspend(struct device *dev)
 
 out:
 	if (!ret)
-		hba->is_sys_suspended = true;
+		hba->is_wl_sys_suspended = true;
 	trace_ufshcd_wl_suspend(dev_name(dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
@@ -9090,7 +9092,7 @@ static int ufshcd_wl_resume(struct device *dev)
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 	if (!ret)
-		hba->is_sys_suspended = false;
+		hba->is_wl_sys_suspended = false;
 	up(&hba->host_sem);
 	return ret;
 }
@@ -9132,6 +9134,8 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 
 	if (!hba->is_powered)
 		return 0;
+
+	hba->pm_op_in_progress = true;
 	/*
 	 * Disable the host irq as host controller as there won't be any
 	 * host controller transaction expected till resume.
@@ -9151,6 +9155,7 @@ static int ufshcd_suspend(struct ufs_hba *hba)
 	ufshcd_vreg_set_lpm(hba);
 	/* Put the host controller in low power mode if possible */
 	ufshcd_hba_vreg_set_lpm(hba);
+	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9171,6 +9176,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
 	if (!hba->is_powered)
 		return 0;
 
+	hba->pm_op_in_progress = true;
 	ufshcd_hba_vreg_set_hpm(hba);
 	ret = ufshcd_vreg_set_hpm(hba);
 	if (ret)
@@ -9190,6 +9196,7 @@ static int ufshcd_resume(struct ufs_hba *hba)
 out:
 	if (ret)
 		ufshcd_update_evt_hist(hba, UFS_EVT_RESUME_ERR, (u32)ret);
+	hba->pm_op_in_progress = false;
 	return ret;
 }
 
@@ -9215,6 +9222,10 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	trace_ufshcd_system_suspend(dev_name(hba->dev), ret,
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
+
+	if (!ret)
+		hba->is_sys_suspended = true;
+
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_suspend);
@@ -9241,6 +9252,9 @@ int ufshcd_system_resume(struct ufs_hba *hba)
 		ktime_to_us(ktime_sub(ktime_get(), start)),
 		hba->curr_dev_pwr_mode, hba->uic_link_state);
 
+	if (!ret)
+		hba->is_sys_suspended = false;
+
 	return ret;
 }
 EXPORT_SYMBOL(ufshcd_system_resume);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index d5325e8..fe7ee30 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -752,7 +752,8 @@ struct ufs_hba {
 	enum ufs_pm_level spm_lvl;
 	struct device_attribute rpm_lvl_attr;
 	struct device_attribute spm_lvl_attr;
-	int pm_op_in_progress;
+	bool pm_op_in_progress;
+	bool wl_pm_op_in_progress;
 
 	/* Auto-Hibernate Idle Timer register value */
 	u32 ahit;
@@ -839,6 +840,7 @@ struct ufs_hba {
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
 	bool is_sys_suspended;
+	bool is_wl_sys_suspended;
 
 	enum bkops_status urgent_bkops_lvl;
 	bool is_urgent_bkops_lvl_checked;
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

