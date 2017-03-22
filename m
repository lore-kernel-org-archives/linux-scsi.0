From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/23] scsi: hisi_sas: fix some sas_task.task_state_lock locking
Date: Thu, 23 Mar 2017 01:25:29 +0800
Message-ID: <1490203539-228029-14-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

Some more locking needs to be added/modified for when
read-modify-writing sas_task.task_state_flags.

Note: since we can attempt to grab this lock in interrupt
      context we should use irq variant of spin_lock.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 13 ++++++-------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  7 +++++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 49cac22..f9ea5cc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -188,6 +188,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	struct asd_sas_port *sas_port = device->port;
 	struct device *dev = &hisi_hba->pdev->dev;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
+	unsigned long flags;
 
 	if (!sas_port) {
 		struct task_status_struct *ts = &task->task_status;
@@ -308,9 +309,9 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	}
 
 	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_lock(&task->task_state_lock);
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
-	spin_unlock(&task->task_state_lock);
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	hisi_hba->slot_prep = slot;
 
@@ -922,14 +923,11 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		return TMF_RESP_FUNC_FAILED;
 	}
 
-	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
-		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}
 
-	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	sas_dev->dev_status = HISI_SAS_DEV_EH;
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
 		struct scsi_cmnd *cmnd = task->uldd_task;
@@ -1127,6 +1125,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 	struct asd_sas_port *sas_port = device->port;
 	struct hisi_sas_cmd_hdr *cmd_hdr_base;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
+	unsigned long flags;
 
 	if (unlikely(test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)))
 		return -EINVAL;
@@ -1167,9 +1166,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 
 	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_lock(&task->task_state_lock);
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
-	spin_unlock(&task->task_state_lock);
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	hisi_hba->slot_prep = slot;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 2f3e877..fc1c1b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1288,6 +1288,7 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_complete_v1_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v1_hdr *complete_hdr;
+	unsigned long flags;
 	u32 cmplt_hdr_data;
 
 	complete_hdr = &complete_queue[slot->cmplt_queue_slot];
@@ -1300,9 +1301,11 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 	device = task->dev;
 	sas_dev = device->lldd_dev;
 
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index f4d8200..2b6e64c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1737,6 +1737,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v2_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
+	unsigned long flags;
 	int aborted;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
@@ -1746,11 +1747,11 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	device = task->dev;
 	sas_dev = device->lldd_dev;
 
-	spin_lock(&task->task_state_lock);
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
-	spin_unlock(&task->task_state_lock);
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
@@ -1849,7 +1850,9 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 
-- 
1.9.1
