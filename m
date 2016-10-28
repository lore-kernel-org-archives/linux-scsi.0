From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 1/4] scsi: ufs: fix race between clock gating and devfreq scaling work
Date: Thu, 27 Oct 2016 17:25:47 -0700
Message-ID: <1477614347-5404-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33308 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942875AbcJ1AZx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2016 20:25:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>

UFS devfreq clock scaling work may require clocks to be ON if it need to
execute some UFS commands hence it may request for clock hold before
issuing the command. But if UFS clock gating work is already running in
parallel, ungate work would end up waiting for the clock gating work to
finish and as clock gating work would also wait for the clock scaling work
to finish, we would enter in deadlock state. Here is the call trace during
this deadlock state:

Workqueue: devfreq_wq devfreq_monitor
	__switch_to
	__schedule
	schedule
	schedule_timeout
	wait_for_common
	wait_for_completion
	flush_work
	ufshcd_hold
	ufshcd_send_uic_cmd
	ufshcd_dme_get_attr
	ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div
	ufs_qcom_clk_scale_notify
	ufshcd_scale_clks
	ufshcd_devfreq_target
	update_devfreq
	devfreq_monitor
	process_one_work
	worker_thread
	kthread
	ret_from_fork

Workqueue: events ufshcd_gate_work
	__switch_to
	__schedule
	schedule
	schedule_preempt_disabled
	__mutex_lock_slowpath
	mutex_lock
	devfreq_monitor_suspend
	devfreq_simple_ondemand_handler
	devfreq_suspend_device
	ufshcd_gate_work
	process_one_work
	worker_thread
	kthread
	ret_from_fork

Workqueue: events ufshcd_ungate_work
	__switch_to
	__schedule
	schedule
	schedule_timeout
	wait_for_common
	wait_for_completion
	flush_work
	__cancel_work_timer
	cancel_delayed_work_sync
	ufshcd_ungate_work
	process_one_work
	worker_thread
	kthread
	ret_from_fork

This change fixes this deadlock by doing this in devfreq work (devfreq_wq):
Try cancelling clock gating work. If we are able to cancel gating work
or it wasn't scheduled, hold the clock reference count until scaling is
in progress. If gate work is already running in parallel, let's skip
the frequecy scaling at this time and it will be retried once next scaling
window expires.

Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 304adce..5c931d1 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6379,15 +6379,47 @@ static int ufshcd_devfreq_target(struct device *dev,
 {
 	int err = 0;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
+	bool release_clk_hold = false;
+	unsigned long irq_flags;
 
 	if (!ufshcd_is_clkscaling_enabled(hba))
 		return -EINVAL;
 
+	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	if (ufshcd_eh_in_progress(hba)) {
+		spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+		return 0;
+	}
+
+	if (ufshcd_is_clkgating_allowed(hba) &&
+	    (hba->clk_gating.state != CLKS_ON)) {
+		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
+			/* hold the vote until the scaling work is completed */
+			hba->clk_gating.active_reqs++;
+			release_clk_hold = true;
+			hba->clk_gating.state = CLKS_ON;
+		} else {
+			/*
+			 * Clock gating work seems to be running in parallel
+			 * hence skip scaling work to avoid deadlock between
+			 * current scaling work and gating work.
+			 */
+			spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+			return 0;
+		}
+	}
+	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+
 	if (*freq == UINT_MAX)
 		err = ufshcd_scale_clks(hba, true);
 	else if (*freq == 0)
 		err = ufshcd_scale_clks(hba, false);
 
+	spin_lock_irqsave(hba->host->host_lock, irq_flags);
+	if (release_clk_hold)
+		__ufshcd_release(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
+
 	return err;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

