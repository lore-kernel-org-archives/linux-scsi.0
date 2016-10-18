From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 06/11] scsi: ufs: suspend clock scaling for failed runtime_resume
Date: Mon, 17 Oct 2016 17:10:00 -0700
Message-ID: <1476749401-11284-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Gilad Broner <gbroner@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

During runtime resume operation, clock scaling may get indirectly
resumed via call to ufshcd_set_dev_pwr_mode(): Start/Stop Unit command
times out and SCSI error handling ultimately calls the host reset handler
to recover, during which clock scaling is resumed.
Error case exit path of runtime resume will disable clocks.
As clock scaling was already resumed, it will get scheduled later on and
try to access UFS registers while clocks are disabled, resulting in
unclocked register access.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f549be3..c6fa3c0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -600,6 +600,20 @@ static bool ufshcd_is_unipro_pa_params_tuning_req(struct ufs_hba *hba)
 		return false;
 }
 
+static void ufshcd_suspend_clkscaling(struct ufs_hba *hba)
+{
+	if (ufshcd_is_clkscaling_enabled(hba)) {
+		devfreq_suspend_device(hba->devfreq);
+		hba->clk_scaling.window_start_t = 0;
+	}
+}
+
+static void ufshcd_resume_clkscaling(struct ufs_hba *hba)
+{
+	if (ufshcd_is_clkscaling_enabled(hba))
+		devfreq_resume_device(hba->devfreq);
+}
+
 static void ufshcd_ungate_work(struct work_struct *work)
 {
 	int ret;
@@ -633,8 +647,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	if (ufshcd_is_clkscaling_enabled(hba))
-		devfreq_resume_device(hba->devfreq);
+	ufshcd_resume_clkscaling(hba);
 	scsi_unblock_requests(hba->host);
 }
 
@@ -733,10 +746,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 		ufshcd_set_link_hibern8(hba);
 	}
 
-	if (ufshcd_is_clkscaling_enabled(hba)) {
-		devfreq_suspend_device(hba->devfreq);
-		hba->clk_scaling.window_start_t = 0;
-	}
+	ufshcd_suspend_clkscaling(hba);
 
 	if (!ufshcd_is_link_active(hba))
 		ufshcd_setup_clocks(hba, false);
@@ -5076,8 +5086,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		hba->is_init_prefetch = true;
 
 	/* Resume devfreq after UFS device is detected */
-	if (ufshcd_is_clkscaling_enabled(hba))
-		devfreq_resume_device(hba->devfreq);
+	ufshcd_resume_clkscaling(hba);
 
 out:
 	/*
@@ -5583,6 +5592,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 	if (hba->is_powered) {
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
+		ufshcd_suspend_clkscaling(hba);
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
@@ -5911,10 +5921,8 @@ disable_clks:
 	 * for pending clock scaling work to be done before clocks are
 	 * turned off.
 	 */
-	if (ufshcd_is_clkscaling_enabled(hba)) {
-		devfreq_suspend_device(hba->devfreq);
-		hba->clk_scaling.window_start_t = 0;
-	}
+	ufshcd_suspend_clkscaling(hba);
+
 	/*
 	 * Call vendor specific suspend callback. As these callbacks may access
 	 * vendor specific host controller register space call them before the
@@ -5941,6 +5949,7 @@ disable_clks:
 	goto out;
 
 set_link_active:
+	ufshcd_resume_clkscaling(hba);
 	ufshcd_vreg_set_hpm(hba);
 	if (ufshcd_is_link_hibern8(hba) && !ufshcd_uic_hibern8_exit(hba))
 		ufshcd_set_link_active(hba);
@@ -6028,8 +6037,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_urgent_bkops(hba);
 	hba->clk_gating.is_suspended = false;
 
-	if (ufshcd_is_clkscaling_enabled(hba))
-		devfreq_resume_device(hba->devfreq);
+	ufshcd_resume_clkscaling(hba);
 
 	/* Schedule clock gating in case of no access to UFS device yet */
 	ufshcd_release(hba);
@@ -6043,6 +6051,7 @@ disable_vreg:
 	ufshcd_vreg_set_lpm(hba);
 disable_irq_and_vops_clks:
 	ufshcd_disable_irq(hba);
+	ufshcd_suspend_clkscaling(hba);
 	ufshcd_setup_clocks(hba, false);
 out:
 	hba->pm_op_in_progress = 0;
@@ -6559,8 +6568,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			goto out_remove_scsi_host;
 		}
 		/* Suspend devfreq until the UFS device is detected */
-		devfreq_suspend_device(hba->devfreq);
-		hba->clk_scaling.window_start_t = 0;
+		ufshcd_suspend_clkscaling(hba);
 	}
 
 	/* Hold auto suspend until async scan completes */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
