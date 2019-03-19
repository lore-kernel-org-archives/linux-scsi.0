From: Aditya Pakki <pakki001@umn.edu>
Subject: [PATCH] scsi: ufs: Check for return value of create_singlethread_workqueue
Date: Mon, 18 Mar 2019 22:47:28 -0500
Message-ID: <20190319034732.19559-1-pakki001@umn.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: pakki001@umn.edu
Cc: kjlu@umn.edu, Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Subhash Jadavani <subhashj@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, Marc Gonzalez <marc.w.gonzalez@free.fr>, Bjorn Andersson <bjorn.andersson@linaro.org>, Ohad Sharabi <ohad.sharabi@wdc.com>, Vivek Gautam <vivek.gautam@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In case create_singlethread_workqueue fails in ufshcd_init_scaling, the
patch returns the error upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/scsi/ufs/ufshcd.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e040f9dd9ff3..e822f8eb0601 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1748,12 +1748,12 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 	return count;
 }
 
-static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
+static int ufshcd_init_clk_scaling(struct ufs_hba *hba)
 {
 	char wq_name[sizeof("ufs_clkscaling_00")];
 
 	if (!ufshcd_is_clkscaling_supported(hba))
-		return;
+		return 0;
 
 	INIT_WORK(&hba->clk_scaling.suspend_work,
 		  ufshcd_clk_scaling_suspend_work);
@@ -1763,8 +1763,11 @@ static void ufshcd_init_clk_scaling(struct ufs_hba *hba)
 	snprintf(wq_name, sizeof(wq_name), "ufs_clkscaling_%d",
 		 hba->host->host_no);
 	hba->clk_scaling.workq = create_singlethread_workqueue(wq_name);
+	if (!hba->clk_scaling.workq)
+		return -ENOMEM;
 
 	ufshcd_clkscaling_init_sysfs(hba);
+	return 0;
 }
 
 static void ufshcd_exit_clk_scaling(struct ufs_hba *hba)
@@ -8256,7 +8259,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	ufshcd_init_clk_gating(hba);
 
-	ufshcd_init_clk_scaling(hba);
+	err = ufshcd_init_clk_scaling(hba);
+	if (err)
+		goto exit_scaling;
 
 	/*
 	 * In order to avoid any spurious interrupt immediately after
@@ -8332,8 +8337,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 out_remove_scsi_host:
 	scsi_remove_host(hba->host);
-exit_gating:
+exit_scaling:
 	ufshcd_exit_clk_scaling(hba);
+exit_gating:
 	ufshcd_exit_clk_gating(hba);
 out_disable:
 	hba->is_irq_enabled = false;
-- 
2.17.1
