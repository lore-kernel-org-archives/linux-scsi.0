From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/11] scsi: hisi_sas: Add some checks to avoid free'ing a sas_task twice
Date: Wed, 2 May 2018 23:56:25 +0800
Message-ID: <1525276594-92173-3-git-send-email-john.garry@huawei.com>
References: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525276594-92173-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If the SCSI host enters EH, any pending IO will be processed
by SCSI EH. However it is possible that SCSI EH will try to
abort the IO and also at the same time the IO completes in the
driver. In this situation there is a small changes of freeing the
sas_task twice.

Then if another IO re-uses freed sas_task before the second time
of free'ing sas_task, it is possible that freeing incorrect sas_task.

So to avoid this situation, add some checks to crease reliability.
The sas_task task state flag SAS_TASK_STATE_ABORTED is used to
mutually protect the LLDD and libsas free'ing the task.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  4 ++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 22 +++++++---------------
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 21 +++++++--------------
 3 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index d1a61b1..52746e2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -1174,10 +1174,14 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		return TMF_RESP_FUNC_FAILED;
 	}
 
+	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
 		rc = TMF_RESP_FUNC_COMPLETE;
 		goto out;
 	}
+	task->task_state_flags |= SAS_TASK_STATE_ABORTED;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	sas_dev->dev_status = HISI_SAS_DEV_EH;
 	if (task->lldd_task && task->task_proto & SAS_PROTOCOL_SSP) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 384e4ef..8ca0044 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2386,7 +2386,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	struct hisi_sas_complete_v2_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
 	unsigned long flags;
-	int aborted;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -EINVAL;
@@ -2396,7 +2395,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	sas_dev = device->lldd_dev;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -2404,15 +2402,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
 
-	if (unlikely(aborted)) {
-		dev_dbg(dev, "slot_complete: task(%p) aborted\n", task);
-		ts->stat = SAS_ABORTED_TASK;
-		spin_lock_irqsave(&hisi_hba->lock, flags);
-		hisi_sas_slot_task_free(hisi_hba, task, slot);
-		spin_unlock_irqrestore(&hisi_hba->lock, flags);
-		return ts->stat;
-	}
-
 	if (unlikely(!sas_dev)) {
 		dev_dbg(dev, "slot complete: port has no device\n");
 		ts->stat = SAS_PHY_DOWN;
@@ -2523,13 +2512,16 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		dev_info(dev, "slot complete: task(%p) aborted\n", task);
+		return SAS_ABORTED_TASK;
+	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
-	sts = ts->stat;
 
 	if (task->task_done)
 		task->task_done(task);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index afc1242..7346110 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1576,7 +1576,6 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v3_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
-	int aborted;
 	unsigned long flags;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
@@ -1587,21 +1586,12 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	sas_dev = device->lldd_dev;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
-	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
-	if (unlikely(aborted)) {
-		dev_dbg(dev, "slot complete: task(%p) aborted\n", task);
-		ts->stat = SAS_ABORTED_TASK;
-		spin_lock_irqsave(&hisi_hba->lock, flags);
-		hisi_sas_slot_task_free(hisi_hba, task, slot);
-		spin_unlock_irqrestore(&hisi_hba->lock, flags);
-		return ts->stat;
-	}
 
 	if (unlikely(!sas_dev)) {
 		dev_dbg(dev, "slot complete: port has not device\n");
@@ -1699,13 +1689,16 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	}
 
 out:
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
+	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
+		spin_unlock_irqrestore(&task->task_state_lock, flags);
+		dev_info(dev, "slot complete: task(%p) aborted\n", task);
+		return SAS_ABORTED_TASK;
+	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
-	sts = ts->stat;
 
 	if (task->task_done)
 		task->task_done(task);
-- 
1.9.1
