From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 8/9] scsi: ufs: enable runtime pm only after ufshcd init
Date: Fri,  6 Jul 2018 18:00:35 +0530
Message-ID: <6f1fd2b0fbfb73d977a1063bda598d8b9b6005b7.1530880007.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Gilad Broner <gbroner@codeaurora.org>, linux-arm-msm@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Gilad Broner <gbroner@codeaurora.org>

Previous code enables runtime pm before ufshcd_init() is completed,
and before the hba struct is stored in the platform device private
data. This means that pm runtime calls will have null hba pointer
as well as partially initialized driver.
Instead, enable pm runtime only after ufshcd_init() is done and
after hba struct is stored in the platform device private data.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 7dba799..8332d99 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -354,24 +354,21 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	}
 
 	ufshcd_parse_pm_levels(hba);
-	pm_runtime_set_active(&pdev->dev);
-	pm_runtime_enable(&pdev->dev);
 
 	ufshcd_init_lanes_per_dir(hba);
 
 	err = ufshcd_init(hba, mmio_base, irq);
 	if (err) {
 		dev_err(dev, "Initialization failed\n");
-		goto out_disable_rpm;
+		goto dealloc_host;
 	}
 
 	platform_set_drvdata(pdev, hba);
 
-	return 0;
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
 
-out_disable_rpm:
-	pm_runtime_disable(&pdev->dev);
-	pm_runtime_set_suspended(&pdev->dev);
+	return 0;
 dealloc_host:
 	ufshcd_dealloc_host(hba);
 out:
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
