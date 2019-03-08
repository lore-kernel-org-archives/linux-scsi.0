From: Rajendra Nayak <rnayak@codeaurora.org>
Subject: [PATCH 3/3] scsi: ufs: qcom: Remove unnecessary runtime pm calls
Date: Fri,  8 Mar 2019 14:00:53 +0530
Message-ID: <20190308083053.30631-4-rnayak@codeaurora.org>
References: <20190308083053.30631-1-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190308083053.30631-1-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, alim.akhtar@samsung.com, pedrom.Sousa@synopsys.com
Cc: subhashj@codeaurora.org, asutoshd@codeaurora.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Doing a runtime pm get/put as part of ufs_qcom_testbus_config()
seems completely unnecessary, since this is called only early
during ufs_qcom_init() when the runtime operations are not
completely setup for ufs runtime suspend/resume to even work.

Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 3aeadb14aae1..3590741eea2f 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1558,7 +1558,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	}
 	mask <<= offset;
 
-	pm_runtime_get_sync(host->hba->dev);
 	ufshcd_hold(host->hba, false);
 	ufshcd_rmwl(host->hba, TEST_BUS_SEL,
 		    (u32)host->testbus.select_major << 19,
@@ -1573,7 +1572,6 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 */
 	mb();
 	ufshcd_release(host->hba);
-	pm_runtime_put_sync(host->hba->dev);
 
 	return 0;
 }
-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
