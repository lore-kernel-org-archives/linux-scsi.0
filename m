From: John Garry <john.garry@huawei.com>
Subject: [PATCH 10/23] scsi: hisi_sas: hardreset for SATA disk in LU reset
Date: Thu, 23 Mar 2017 01:25:26 +0800
Message-ID: <1490203539-228029-11-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

When issuing an LU reset for a SATA target, issue an
internal abort and a hard reset.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 38 ++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 36d4e5a..19f2892 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1037,23 +1037,43 @@ static int hisi_sas_I_T_nexus_reset(struct domain_device *device)
 
 static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 {
-	struct hisi_sas_tmf_task tmf_task;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct device *dev = &hisi_hba->pdev->dev;
 	unsigned long flags;
 	int rc = TMF_RESP_FUNC_FAILED;
 
-	tmf_task.tmf = TMF_LU_RESET;
 	sas_dev->dev_status = HISI_SAS_DEV_EH;
-	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
-	if (rc == TMF_RESP_FUNC_COMPLETE) {
-		spin_lock_irqsave(&hisi_hba->lock, flags);
-		hisi_sas_release_task(hisi_hba, device);
-		spin_unlock_irqrestore(&hisi_hba->lock, flags);
-	}
+	if (dev_is_sata(device)) {
+		struct sas_phy *phy;
+
+		/* Clear internal IO and then hardreset */
+		rc = hisi_sas_internal_task_abort(hisi_hba, device,
+						  HISI_SAS_INT_ABT_DEV, 0);
+		if (rc == TMF_RESP_FUNC_FAILED)
+			goto out;
 
-	/* If failed, fall-through I_T_Nexus reset */
+		phy = sas_get_local_phy(device);
+
+		rc = sas_phy_reset(phy, 1);
+
+		if (rc == 0) {
+			spin_lock_irqsave(&hisi_hba->lock, flags);
+			hisi_sas_release_task(hisi_hba, device);
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
+		}
+		sas_put_local_phy(phy);
+	} else {
+		struct hisi_sas_tmf_task tmf_task = { .tmf =  TMF_LU_RESET };
+
+		rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
+		if (rc == TMF_RESP_FUNC_COMPLETE) {
+			spin_lock_irqsave(&hisi_hba->lock, flags);
+			hisi_sas_release_task(hisi_hba, device);
+			spin_unlock_irqrestore(&hisi_hba->lock, flags);
+		}
+	}
+out:
 	dev_err(dev, "lu_reset: for device[%llx]:rc= %d\n",
 		sas_dev->device_id, rc);
 	return rc;
-- 
1.9.1
