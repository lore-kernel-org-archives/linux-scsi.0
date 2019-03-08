From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [PATCH 1/3] scsi: ufs: Fix runtime pm handling in ufshcd-pltfrm
Date: Fri,  8 Mar 2019 14:00:51 +0530
Message-ID: <20190308083053.30631-2-rnayak@codeaurora.org>
References: <20190308083053.30631-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308083053.30631-1-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, alim.akhtar@samsung.com, pedrom.Sousa@synopsys.com
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

runtime pm calls as part of ufshcd_init() can trigger a
ufshcd_runtime_suspend() which always fails until the point
we do a platform_set_drvdata(), setting the devices 'power.runtime_error'

Use pm_runtime_get_noresume()/pm_runtime_put_noidle() to prevent
this from happening.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd-pltfrm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 895a9b5ac989..974441fa4e75 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -340,6 +340,7 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 		goto dealloc_host;
 	}
 
+	pm_runtime_get_noresume(&pdev->dev);
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
@@ -352,12 +353,14 @@ int ufshcd_pltfrm_init(struct platform_device *pdev,
 	}
 
 	platform_set_drvdata(pdev, hba);
+	pm_runtime_put_noidle(&pdev->dev);
 
 	return 0;
 
 out_disable_rpm:
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
+	pm_runtime_put_noidle(&pdev->dev);
 dealloc_host:
 	ufshcd_dealloc_host(hba);
 out:
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
