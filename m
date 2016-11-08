From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v2 2/2] scsi: ufs: Use the resource-managed function to add
 devfreq device
Date: Tue, 08 Nov 2016 18:16:59 +0900
Message-ID: <1478596619-3064-1-git-send-email-cw00.choi@samsung.com>
References: <1478596408-2958-1-git-send-email-cw00.choi@samsung.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-reply-to: <1478596408-2958-1-git-send-email-cw00.choi@samsung.com>
Sender: linux-pm-owner@vger.kernel.org
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com
Cc: rjw@rjwysocki.net, subhashj@codeaurora.org, cpgs@samsung.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch uses the resource-managed to add the devfreq device.
This function will make it easy to handle the devfreq device.

- struct devfreq *devm_devfreq_add_device(struct device *dev,
				  struct devfreq_dev_profile *profile,
				  const char *governor_name,
				  void *data);
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James E.J. Bottomley <jejb@linux.vnet.ibm.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e491c4bda32f..e8c5ba274830 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6250,8 +6250,6 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufshcd_hba_stop(hba, true);
 
 	ufshcd_exit_clk_gating(hba);
-	if (ufshcd_is_clkscaling_enabled(hba))
-		devfreq_remove_device(hba->devfreq);
 	ufshcd_hba_exit(hba);
 }
 EXPORT_SYMBOL_GPL(ufshcd_remove);
@@ -6579,7 +6577,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	if (ufshcd_is_clkscaling_enabled(hba)) {
-		hba->devfreq = devfreq_add_device(dev, &ufs_devfreq_profile,
+		hba->devfreq = devm_devfreq_add_device(dev, &ufs_devfreq_profile,
 						   "simple_ondemand", NULL);
 		if (IS_ERR(hba->devfreq)) {
 			dev_err(hba->dev, "Unable to register with devfreq %ld\n",
-- 
1.9.1

