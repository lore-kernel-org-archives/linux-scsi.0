From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [PATCH 2/3] scsi: ufs: Add error checks for pm_runtime_get_sync()
Date: Fri,  8 Mar 2019 14:00:52 +0530
Message-ID: <20190308083053.30631-3-rnayak@codeaurora.org>
References: <20190308083053.30631-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308083053.30631-1-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, alim.akhtar@samsung.com, pedrom.Sousa@synopsys.com
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Add an error check for pm_runtime_get_sync(), ignoring this can
hide issues with the runtime pm handling in the driver.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2ddf24466a62..060dc38cc582 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8357,7 +8357,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/* Hold auto suspend until async scan completes */
-	pm_runtime_get_sync(dev);
+	err = pm_runtime_get_sync(dev);
+	if (err < 0)
+		goto out_remove_scsi_host;
+
 	atomic_set(&hba->scsi_block_reqs_cnt, 0);
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
