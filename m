From: John Garry <john.garry@huawei.com>
Subject: [PATCH 16/19] scsi: hisi_sas: add internal abort dev in some places
Date: Sat, 9 Dec 2017 01:16:47 +0800
Message-ID: <1512753410-50924-17-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

We should do internal abort dev before
TMF_ABORT_TASK_SET and TMF_LU_RESET. Because we may
only have done internal abort for single IO in the
earlier part of SCSI EH process. Even the internal abort
to the single IO, we also don't know whether it is
successful.

Besides, we should release slots of the device in
hisi_sas_abort_task_set() if the abort is successful.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 1b9c48c..302da84 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1238,12 +1238,29 @@ static int hisi_sas_abort_task(struct sas_task *task)
 
 static int hisi_sas_abort_task_set(struct domain_device *device, u8 *lun)
 {
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
+	struct device *dev = hisi_hba->dev;
 	struct hisi_sas_tmf_task tmf_task;
 	int rc = TMF_RESP_FUNC_FAILED;
+	unsigned long flags;
+
+	rc = hisi_sas_internal_task_abort(hisi_hba, device,
+					HISI_SAS_INT_ABT_DEV, 0);
+	if (rc < 0) {
+		dev_err(dev, "abort task set: internal abort rc=%d\n", rc);
+		return TMF_RESP_FUNC_FAILED;
+	}
+	hisi_sas_dereg_device(hisi_hba, device);
 
 	tmf_task.tmf = TMF_ABORT_TASK_SET;
 	rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
 
+	if (rc == TMF_RESP_FUNC_COMPLETE) {
+		spin_lock_irqsave(&hisi_hba->lock, flags);
+		hisi_sas_release_task(hisi_hba, device);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	}
+
 	return rc;
 }
 
@@ -1333,6 +1350,14 @@ static int hisi_sas_lu_reset(struct domain_device *device, u8 *lun)
 	} else {
 		struct hisi_sas_tmf_task tmf_task = { .tmf =  TMF_LU_RESET };
 
+		rc = hisi_sas_internal_task_abort(hisi_hba, device,
+						HISI_SAS_INT_ABT_DEV, 0);
+		if (rc < 0) {
+			dev_err(dev, "lu_reset: internal abort failed\n");
+			goto out;
+		}
+		hisi_sas_dereg_device(hisi_hba, device);
+
 		rc = hisi_sas_debug_issue_ssp_tmf(device, lun, &tmf_task);
 		if (rc == TMF_RESP_FUNC_COMPLETE) {
 			spin_lock_irqsave(&hisi_hba->lock, flags);
-- 
1.9.1
