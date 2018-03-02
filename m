From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 6/8] scsi: hisi_sas: remove unused variable hisi_sas_devices.running_req
Date: Fri, 2 Mar 2018 23:06:20 +0800
Message-ID: <1520003182-26277-7-git-send-email-john.garry@huawei.com>
References: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1520003182-26277-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, robh+dt@kernel.org, mark.rutland@arm.com
Cc: linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The structure element hisi_sas_devices.running_req to count how
many commands are active is in effect only ever written in the
code, so remove it.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 9 ---------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 3 ---
 3 files changed, 13 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index e7fd287..d1153e8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -175,7 +175,6 @@ struct hisi_sas_device {
 	struct hisi_sas_dq	*dq;
 	struct list_head	list;
 	u64 attached_phy;
-	atomic64_t running_req;
 	enum sas_device_type	dev_type;
 	int device_id;
 	int sata_idx;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9ff8790..88ad8d4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -200,8 +200,6 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 
 	if (task) {
 		struct device *dev = hisi_hba->dev;
-		struct domain_device *device = task->dev;
-		struct hisi_sas_device *sas_dev = device->lldd_dev;
 
 		if (!task->lldd_task)
 			return;
@@ -213,9 +211,6 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 				dma_unmap_sg(dev, task->scatter,
 					     task->num_scatter,
 					     task->data_dir);
-
-		if (sas_dev)
-			atomic64_dec(&sas_dev->running_req);
 	}
 
 	if (slot->buf)
@@ -431,8 +426,6 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	dq->slot_prep = slot;
-
-	atomic64_inc(&sas_dev->running_req);
 	++(*pass);
 
 	return 0;
@@ -1517,8 +1510,6 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 	dq->slot_prep = slot;
 
-	atomic64_inc(&sas_dev->running_req);
-
 	/* send abort command to the chip */
 	hisi_hba->hw->start_delivery(dq);
 	spin_unlock_irqrestore(&dq->lock, flags_dq);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2eb8980..8dd0e6a6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1407,9 +1407,6 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	if (sas_dev)
-		atomic64_dec(&sas_dev->running_req);
-
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 
-- 
1.9.1
