From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: [PATCH 1/1] scsi/ufshcd: Fix NULL pointer dereference for in ufshcd_init
Date: Tue,  7 Aug 2018 23:17:39 +0530
Message-ID: <20180807174739.23379-1-vivek.gautam@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org, Vivek Gautam <vivek.gautam@codeaurora.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthias Kaehlcke <mka@chromium.org>, Evan Green <evgreen@chromium.org>
List-Id: linux-scsi@vger.kernel.org

Error paths in ufshcd_init() ufshcd_hba_exit() killed clk_scaling
workqueue when the workqueue is actually created quite late in
ufshcd_init().
So, we end up getting NULL pointer dereference in such error paths.
Fix this by moving clk_scaling initialization and kill codes to
two separate methods, and call them at required places.

Fixes: 401f1e4490ee ("scsi: ufs: don't suspend clock scaling during clock
gating")

Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Matthias Kaehlcke <mka@chromium.org>
Cc: Evan Green <evgreen@chromium.org>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---

Bjorn, Subhash,
I am not certain of some of these devfreq, and clk_scaling bits
that are moved as part of this patch. Please help in reviewing the
change in the light of these features, and related sequence should
be followed.
Thanks.

 drivers/scsi/ufs/ufshcd.c | 53 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 397081d320b1..7273aec95a6c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1749,6 +1749,34 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 	return count;
 }
 
+static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
+{
+	char wq_name[sizeof("ufs_clkscaling_00")];
+
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	INIT_WORK(&hba->clk_scaling.suspend_work,
+		  ufshcd_clk_scaling_suspend_work);
+	INIT_WORK(&hba->clk_scaling.resume_work,
+		  ufshcd_clk_scaling_resume_work);
+
+	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
+		 hba->host->host_no);
+	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+
+	ufshcd_clkscaling_init_sysfs(hba);
+}
+
+static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
+{
+	if (!ufshcd_is_clkscaling_supported(hba))
+		return;
+
+	destroy_workqueue(hba->clk_scaling.workq);
+	ufshcd_devfreq_remove(hba);
+}
+
 static void ufshcd_init_clk_gating(struct ufs_hba *hba)
 {
 	char wq_name[sizeof("ufs_clk_gating_00")];
@@ -6652,6 +6680,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	 */
 	if (ret && !ufshcd_eh_in_progress(hba) && !hba->pm_op_in_progress) {
 		pm_runtime_put_sync(hba->dev);
+		ufshcd_exit_clk_scaling(hba);
 		ufshcd_hba_exit(hba);
 	}
 
@@ -7187,12 +7216,9 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_variant_hba_exit(hba);
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_suspend_clkscaling(hba);
-		if (ufshcd_is_clkscaling_supported(hba)) {
+		if (ufshcd_is_clkscaling_supported(hba))
 			if (hba->devfreq)
 				ufshcd_suspend_clkscaling(hba);
-			destroy_workqueue(hba->clk_scaling.workq);
-			ufshcd_devfreq_remove(hba);
-		}
 		ufshcd_setup_clocks(hba, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
@@ -7867,6 +7893,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba, true);
 
+	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
 	if (ufshcd_is_clkscaling_supported(hba))
 		device_remove_file(hba->dev, &hba->clk_scaling.enable_attr);
@@ -8031,6 +8058,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	ufshcd_init_clk_gating(hba);
 
+	ufshcd_init_clk_scaling(hba);
+
 	/*
 	 * In order to avoid any spurious interrupt immediately after
 	 * registering UFS controller interrupt handler, clear any pending UFS
@@ -8069,21 +8098,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 		goto out_remove_scsi_host;
 	}
 
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		char wq_name[sizeof("ufs_clkscaling_00")];
-
-		INIT_WORK(&hba->clk_scaling.suspend_work,
-			  ufshcd_clk_scaling_suspend_work);
-		INIT_WORK(&hba->clk_scaling.resume_work,
-			  ufshcd_clk_scaling_resume_work);
-
-		snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
-			 host->host_no);
-		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
-
-		ufshcd_clkscaling_init_sysfs(hba);
-	}
-
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
@@ -8121,6 +8135,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
 exit_gating:
+	ufshcd_exit_clk_scaling(hba);
 	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
