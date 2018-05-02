From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/11] scsi: hisi_sas: check host frozen before calling "done" function
Date: Wed, 2 May 2018 23:56:26 +0800
Message-ID: <1525276594-92173-4-git-send-email-john.garry@huawei.com>
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

When the host is frozen in SCSI EH state, at any point after
the LLDD sets SAS_TASK_STATE_DONE for the sas_task task state,
libsas may free the task; see sas_scsi_find_task().

This puts the LLDD in a difficult position, in that once it
sets SAS_TASK_STATE_DONE for the task state it should not
reference the sas_task again. But the LLDD needs will check
the sas_task indirectly in calling
task->task_done()->sas_scsi_task_done() or sas_ata_task_done()
(to check if the host is frozen state actually).

And the LLDD cannot set SAS_TASK_STATE_DONE for the task
state after task->task_done() is called (as the sas_task is
free'd at this point).

This situation would seem to be a problem made by libsas.

To work around, check in the LLDD whether the host is in
frozen state to ensure it is ok to call task->task_done()
function. If in the frozen state, we rely on SCSI EH and
libsas to free the sas_task directly.

We do not do this for the following IO types:
- SMP - they are managed in libsas directly, outside SCSI EH
- Any internally originated IO, for similar reason

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  3 +++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 14 ++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d413d05..147cfaf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -196,6 +196,7 @@ struct hisi_sas_slot {
 	dma_addr_t cmd_hdr_dma;
 	struct work_struct abort_slot;
 	struct timer_list internal_abort_timer;
+	bool is_internal;
 };
 
 struct hisi_sas_tmf_task {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 52746e2..8f8e642 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -382,6 +382,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
 	slot->task = task;
 	slot->port = port;
+	if (is_tmf)
+		slot->is_internal = true;
 	task->lldd_task = slot;
 	INIT_WORK(&slot->abort_slot, hisi_sas_slot_abort);
 
@@ -1486,6 +1488,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
 	slot->task = task;
 	slot->port = port;
+	slot->is_internal = true;
 	task->lldd_task = slot;
 
 	slot->buf = dma_pool_alloc(hisi_hba->buffer_pool,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8ca0044..6dda6eb 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2380,18 +2380,21 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	struct device *dev = hisi_hba->dev;
 	struct task_status_struct *ts;
 	struct domain_device *device;
+	struct sas_ha_struct *ha;
 	enum exec_status sts;
 	struct hisi_sas_complete_v2_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v2_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
 	unsigned long flags;
+	bool is_internal = slot->is_internal;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -EINVAL;
 
 	ts = &task->task_status;
 	device = task->dev;
+	ha = device->port->ha;
 	sas_dev = device->lldd_dev;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
@@ -2523,6 +2526,17 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
+	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
+		spin_lock_irqsave(&device->done_lock, flags);
+		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
+			spin_unlock_irqrestore(&device->done_lock, flags);
+			dev_info(dev, "slot complete: task(%p) ignored\n ",
+				 task);
+			return sts;
+		}
+		spin_unlock_irqrestore(&device->done_lock, flags);
+	}
+
 	if (task->task_done)
 		task->task_done(task);
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 7346110..5c0d968 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1571,18 +1571,21 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	struct device *dev = hisi_hba->dev;
 	struct task_status_struct *ts;
 	struct domain_device *device;
+	struct sas_ha_struct *ha;
 	enum exec_status sts;
 	struct hisi_sas_complete_v3_hdr *complete_queue =
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v3_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
 	unsigned long flags;
+	bool is_internal = slot->is_internal;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -EINVAL;
 
 	ts = &task->task_status;
 	device = task->dev;
+	ha = device->port->ha;
 	sas_dev = device->lldd_dev;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
@@ -1700,6 +1703,17 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
+	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
+		spin_lock_irqsave(&device->done_lock, flags);
+		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
+			spin_unlock_irqrestore(&device->done_lock, flags);
+			dev_info(dev, "slot complete: task(%p) ignored\n ",
+				 task);
+			return sts;
+		}
+		spin_unlock_irqrestore(&device->done_lock, flags);
+	}
+
 	if (task->task_done)
 		task->task_done(task);
 
-- 
1.9.1
