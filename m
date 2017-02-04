From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 6/8] scsi: ufs: kick start clock scaling only after device detection
Date: Fri,  3 Feb 2017 16:58:01 -0800
Message-ID: <1486169881-22894-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

UFS clock scaling might start kicking in even before the device
is running at the fastest interface speed which is undesirable.
This change moves the clock scaling kick start only after the
device is detected and running at the fastest interface speed.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4f6ba24..a99a673 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6330,19 +6330,31 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		if (ufshcd_scsi_add_wlus(hba))
 			goto out;
 
+		/* Initialize devfreq after UFS device is detected */
+		if (ufshcd_is_clkscaling_supported(hba)) {
+			memcpy(&hba->clk_scaling.saved_pwr_info.info,
+				&hba->pwr_info,
+				sizeof(struct ufs_pa_layer_attr));
+			hba->clk_scaling.saved_pwr_info.is_valid = true;
+			if (!hba->devfreq) {
+				hba->devfreq = devm_devfreq_add_device(hba->dev,
+							&ufs_devfreq_profile,
+							"simple_ondemand",
+							NULL);
+				if (IS_ERR(hba->devfreq)) {
+					ret = PTR_ERR(hba->devfreq);
+					dev_err(hba->dev, "Unable to register with devfreq %d\n",
+							ret);
+					goto out;
+				}
+			}
+			hba->clk_scaling.is_allowed = true;
+		}
+
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
 
-	/* Resume devfreq after UFS device is detected */
-	if (ufshcd_is_clkscaling_supported(hba)) {
-		memcpy(&hba->clk_scaling.saved_pwr_info.info, &hba->pwr_info,
-		       sizeof(struct ufs_pa_layer_attr));
-		hba->clk_scaling.saved_pwr_info.is_valid = true;
-		ufshcd_resume_clkscaling(hba);
-		hba->clk_scaling.is_allowed = true;
-	}
-
 	if (!hba->is_init_prefetch)
 		hba->is_init_prefetch = true;
 
@@ -6865,7 +6877,8 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		ufshcd_setup_vreg(hba, false);
 		ufshcd_suspend_clkscaling(hba);
 		if (ufshcd_is_clkscaling_supported(hba)) {
-			ufshcd_suspend_clkscaling(hba);
+			if (hba->devfreq)
+				ufshcd_suspend_clkscaling(hba);
 			destroy_workqueue(hba->clk_scaling.workq);
 		}
 		ufshcd_setup_clocks(hba, false);
@@ -7859,16 +7872,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	if (ufshcd_is_clkscaling_supported(hba)) {
 		char wq_name[sizeof("ufs_clkscaling_00")];
 
-		hba->devfreq = devm_devfreq_add_device(dev, &ufs_devfreq_profile,
-						   "simple_ondemand", NULL);
-		if (IS_ERR(hba->devfreq)) {
-			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
-					PTR_ERR(hba->devfreq));
-			err = PTR_ERR(hba->devfreq);
-			goto out_remove_scsi_host;
-		}
-		hba->clk_scaling.is_suspended = false;
-
 		INIT_WORK(&hba->clk_scaling.suspend_work,
 			  ufshcd_clk_scaling_suspend_work);
 		INIT_WORK(&hba->clk_scaling.resume_work,
@@ -7878,8 +7881,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			 host->host_no);
 		hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
 
-		/* Suspend devfreq until the UFS device is detected */
-		ufshcd_suspend_clkscaling(hba);
 		ufshcd_clkscaling_init_sysfs(hba);
 	}
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
