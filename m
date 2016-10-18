From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 10/11] scsi: ufshcd: Fix race between clk scaling and ungate work
Date: Mon, 17 Oct 2016 17:10:53 -0700
Message-ID: <1476749453-11446-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

The ungate work turns on the clock before it exits hibern8,
if the link was put in hibern8 during clock gating work.
There occurs a race condition when clock scaling work calls
ufshcd_hold() to make sure low power states cannot be entered,
but that returns by checking only whether the clocks are on.
This causes the clock scaling work to issue UIC commands when
the link is in hibern8 causing failures. Make sure we exit
hibern8 state before returning from ufshcd_hold().

Callstacks for race condition:

 ufshcd_scale_gear
 ufshcd_devfreq_scale
 ufshcd_devfreq_target
 update_devfreq
 devfreq_monitor
 process_one_work
 worker_thread
 kthread
 ret_from_fork

 ufshcd_uic_hibern8_exit
 ufshcd_ungate_work
 process_one_work
 worker_thread
 kthread
 ret_from_fork

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ea97fd0..7959793 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -675,6 +675,21 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 start:
 	switch (hba->clk_gating.state) {
 	case CLKS_ON:
+		/*
+		 * Wait for the ungate work to complete if in progress.
+		 * Though the clocks may be in ON state, the link could
+		 * still be in hibner8 state if hibern8 is allowed
+		 * during clock gating.
+		 * Make sure we exit hibern8 state also in addition to
+		 * clocks being ON.
+		 */
+		if (ufshcd_can_hibern8_during_gating(hba) &&
+		    ufshcd_is_link_hibern8(hba)) {
+			spin_unlock_irqrestore(hba->host->host_lock, flags);
+			flush_work(&hba->clk_gating.ungate_work);
+			spin_lock_irqsave(hba->host->host_lock, flags);
+			goto start;
+		}
 		break;
 	case REQ_CLKS_OFF:
 		if (cancel_delayed_work(&hba->clk_gating.gate_work)) {
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
