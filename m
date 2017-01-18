From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/7] scsi: hisi_sas: decrease running_req in hisi_sas_slot_task_free()
Date: Thu, 19 Jan 2017 00:32:53 +0800
Message-ID: <1484757173-235951-8-git-send-email-john.garry@huawei.com>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

There is an issue that hisi_sas_dev.running_req is not
decremented properly for internal abort and TMF.

To resolve, only decrease running_req in hisi_sas_slot_task_free()

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 8 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 8601cec..53637a9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -71,6 +71,8 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 			     struct hisi_sas_slot *slot)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
 
 	if (!slot->task)
 		return;
@@ -97,6 +99,8 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 	slot->task = NULL;
 	slot->port = NULL;
 	hisi_sas_slot_index_free(hisi_hba, slot->idx);
+	if (sas_dev)
+		atomic64_dec(&sas_dev->running_req);
 	/* slot memory is fully zeroed when it is reused */
 }
 EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
@@ -141,8 +145,6 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
 	struct scsi_cmnd *cmnd = task->uldd_task;
 	struct hisi_sas_tmf_task tmf_task;
-	struct domain_device *device = task->dev;
-	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct scsi_lun lun;
 	struct device *dev = &hisi_hba->pdev->dev;
 	int tag = abort_slot->idx;
@@ -165,8 +167,6 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	if (task->task_done)
 		task->task_done(task);
-	if (sas_dev)
-		atomic64_dec(&sas_dev->running_req);
 }
 
 static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 62655c7..de240d2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1827,8 +1827,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	if (sas_dev)
-		atomic64_dec(&sas_dev->running_req);
 
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
-- 
1.9.1
