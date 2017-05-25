From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 02/22] scsi: hisi_sas: optimise the usage of hisi_hba.lock
Date: Thu, 25 May 2017 20:04:51 +0800
Message-ID: <1495713911-80476-3-git-send-email-john.garry@huawei.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently hisi_hba.lock is locked to deliver and receive a
command to/from any hw queue. This causes much
contention at high data-rates.

To boost performance, lock on a per queue basis for
sending and receiving commands to/from hw.

Certain critical regions still need to be locked in the delivery
and completion stages with hisi_hba.lock.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  8 ++---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 59 ++++++++++++++++++++++------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 23 +++++--------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 30 ++++++++---------
 4 files changed, 64 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4e28f32..88f06be 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -102,8 +102,10 @@ struct hisi_sas_cq {
 
 struct hisi_sas_dq {
 	struct hisi_hba *hisi_hba;
+	spinlock_t lock;
 	int	wr_point;
 	int	id;
+	struct hisi_sas_slot	*slot_prep;
 };
 
 struct hisi_sas_device {
@@ -154,9 +156,8 @@ struct hisi_sas_hw {
 				struct domain_device *device);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
 	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
-	int (*get_free_slot)(struct hisi_hba *hisi_hba, u32 dev_id,
-			int *q, int *s);
-	void (*start_delivery)(struct hisi_hba *hisi_hba);
+	int (*get_free_slot)(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq);
+	void (*start_delivery)(struct hisi_sas_dq *dq);
 	int (*prep_ssp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot, int is_tmf,
 			struct hisi_sas_tmf_task *tmf);
@@ -217,7 +218,6 @@ struct hisi_hba {
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 
 	int	queue_count;
-	struct hisi_sas_slot	*slot_prep;
 
 	struct dma_pool *sge_page_pool;
 	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3605d28..d1b7dbf 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -179,10 +179,11 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 		task->task_done(task);
 }
 
-static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
-			      int is_tmf, struct hisi_sas_tmf_task *tmf,
-			      int *pass)
+static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
+		*dq, int is_tmf, struct hisi_sas_tmf_task *tmf,
+		int *pass)
 {
+	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	struct domain_device *device = task->dev;
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_port *port;
@@ -240,18 +241,24 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	} else
 		n_elem = task->num_scatter;
 
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	if (hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, &slot_idx,
 						    device);
 	else
 		rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
-	if (rc)
+	if (rc) {
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 		goto err_out;
-	rc = hisi_hba->hw->get_free_slot(hisi_hba, sas_dev->device_id,
-					&dlvry_queue, &dlvry_queue_slot);
+	}
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (rc)
 		goto err_out_tag;
 
+	dlvry_queue = dq->id;
+	dlvry_queue_slot = dq->wr_point;
 	slot = &hisi_hba->slot_info[slot_idx];
 	memset(slot, 0, sizeof(struct hisi_sas_slot));
 
@@ -316,7 +323,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	hisi_hba->slot_prep = slot;
+	dq->slot_prep = slot;
 
 	atomic64_inc(&sas_dev->running_req);
 	++(*pass);
@@ -354,19 +361,23 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	unsigned long flags;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
 	struct device *dev = &hisi_hba->pdev->dev;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	int queue_id = sas_dev->device_id % hisi_hba->queue_count;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[queue_id];
 
 	if (unlikely(test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)))
 		return -EINVAL;
 
 	/* protect task_prep and start_delivery sequence */
-	spin_lock_irqsave(&hisi_hba->lock, flags);
-	rc = hisi_sas_task_prep(task, hisi_hba, is_tmf, tmf, &pass);
+	spin_lock_irqsave(&dq->lock, flags);
+	rc = hisi_sas_task_prep(task, dq, is_tmf, tmf, &pass);
 	if (rc)
 		dev_err(dev, "task exec: failed[%d]!\n", rc);
 
 	if (likely(pass))
-		hisi_hba->hw->start_delivery(hisi_hba);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+		hisi_hba->hw->start_delivery(dq);
+	spin_unlock_irqrestore(&dq->lock, flags);
 
 	return rc;
 }
@@ -1142,6 +1153,8 @@ static int hisi_sas_query_task(struct sas_task *task)
 	struct hisi_sas_cmd_hdr *cmd_hdr_base;
 	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
 	unsigned long flags;
+	int queue_id = sas_dev->device_id % hisi_hba->queue_count;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[queue_id];
 
 	if (unlikely(test_bit(HISI_SAS_RESET_BIT, &hisi_hba->flags)))
 		return -EINVAL;
@@ -1152,14 +1165,22 @@ static int hisi_sas_query_task(struct sas_task *task)
 	port = to_hisi_sas_port(sas_port);
 
 	/* simply get a slot and send abort command */
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
-	if (rc)
+	if (rc) {
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 		goto err_out;
-	rc = hisi_hba->hw->get_free_slot(hisi_hba, sas_dev->device_id,
-					&dlvry_queue, &dlvry_queue_slot);
+	}
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	spin_lock_irqsave(&dq->lock, flags);
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (rc)
 		goto err_out_tag;
 
+	dlvry_queue = dq->id;
+	dlvry_queue_slot = dq->wr_point;
+
 	slot = &hisi_hba->slot_info[slot_idx];
 	memset(slot, 0, sizeof(struct hisi_sas_slot));
 
@@ -1186,18 +1207,20 @@ static int hisi_sas_query_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	hisi_hba->slot_prep = slot;
+	dq->slot_prep = slot;
 
 	atomic64_inc(&sas_dev->running_req);
 
 	/* send abort command to our chip */
-	hisi_hba->hw->start_delivery(hisi_hba);
+	hisi_hba->hw->start_delivery(dq);
+	spin_unlock_irqrestore(&dq->lock, flags);
 
 	return 0;
 
 err_out_tag:
 	hisi_sas_slot_index_free(hisi_hba, slot_idx);
 err_out:
+	spin_unlock_irqrestore(&dq->lock, flags);
 	dev_err(dev, "internal abort task prep: failed[%d]!\n", rc);
 
 	return rc;
@@ -1221,7 +1244,6 @@ static int hisi_sas_query_task(struct sas_task *task)
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct device *dev = &hisi_hba->pdev->dev;
 	int res;
-	unsigned long flags;
 
 	if (!hisi_hba->hw->prep_abort)
 		return -EOPNOTSUPP;
@@ -1238,11 +1260,8 @@ static int hisi_sas_query_task(struct sas_task *task)
 	task->slow_task->timer.expires = jiffies + msecs_to_jiffies(110);
 	add_timer(&task->slow_task->timer);
 
-	/* Lock as we are alloc'ing a slot, which cannot be interrupted */
-	spin_lock_irqsave(&hisi_hba->lock, flags);
 	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
 						task, abort_flag, tag);
-	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	if (res) {
 		del_timer(&task->slow_task->timer);
 		dev_err(dev, "internal task abort: executing internal task failed: %d\n",
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index fc1c1b2..7d7d2a7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -900,22 +900,17 @@ static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
 	return bitmap;
 }
 
-/**
- * This function allocates across all queues to load balance.
- * Slots are allocated from queues in a round-robin fashion.
- *
+/*
  * The callpath to this function and upto writing the write
  * queue pointer should be safe from interruption.
  */
-static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, u32 dev_id,
-				int *q, int *s)
+static int
+get_free_slot_v1_hw(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
-	struct hisi_sas_dq *dq;
+	int queue = dq->id;
 	u32 r, w;
-	int queue = dev_id % hisi_hba->queue_count;
 
-	dq = &hisi_hba->dq[queue];
 	w = dq->wr_point;
 	r = hisi_sas_read32_relaxed(hisi_hba,
 				DLVRY_Q_0_RD_PTR + (queue * 0x14));
@@ -924,16 +919,14 @@ static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, u32 dev_id,
 		return -EAGAIN;
 	}
 
-	*q = queue;
-	*s = w;
 	return 0;
 }
 
-static void start_delivery_v1_hw(struct hisi_hba *hisi_hba)
+static void start_delivery_v1_hw(struct hisi_sas_dq *dq)
 {
-	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
-	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
-	struct hisi_sas_dq *dq = &hisi_hba->dq[dlvry_queue];
+	struct hisi_hba *hisi_hba = dq->hisi_hba;
+	int dlvry_queue = dq->slot_prep->dlvry_queue;
+	int dlvry_queue_slot = dq->slot_prep->dlvry_queue_slot;
 
 	dq->wr_point = ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS;
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index e241921..193cc43 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1454,22 +1454,17 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 	return bitmap;
 }
 
-/**
- * This function allocates across all queues to load balance.
- * Slots are allocated from queues in a round-robin fashion.
- *
+/*
  * The callpath to this function and upto writing the write
  * queue pointer should be safe from interruption.
  */
-static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, u32 dev_id,
-				int *q, int *s)
+static int
+get_free_slot_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
-	struct hisi_sas_dq *dq;
+	int queue = dq->id;
 	u32 r, w;
-	int queue = dev_id % hisi_hba->queue_count;
 
-	dq = &hisi_hba->dq[queue];
 	w = dq->wr_point;
 	r = hisi_sas_read32_relaxed(hisi_hba,
 				DLVRY_Q_0_RD_PTR + (queue * 0x14));
@@ -1479,16 +1474,14 @@ static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, u32 dev_id,
 		return -EAGAIN;
 	}
 
-	*q = queue;
-	*s = w;
 	return 0;
 }
 
-static void start_delivery_v2_hw(struct hisi_hba *hisi_hba)
+static void start_delivery_v2_hw(struct hisi_sas_dq *dq)
 {
-	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
-	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
-	struct hisi_sas_dq *dq = &hisi_hba->dq[dlvry_queue];
+	struct hisi_hba *hisi_hba = dq->hisi_hba;
+	int dlvry_queue = dq->slot_prep->dlvry_queue;
+	int dlvry_queue_slot = dq->slot_prep->dlvry_queue_slot;
 
 	dq->wr_point = ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS;
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
@@ -2344,7 +2337,9 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	sts = ts->stat;
 
 	if (task->task_done)
@@ -3162,13 +3157,14 @@ static void cq_tasklet_v2_hw(unsigned long val)
 	struct hisi_sas_complete_v2_hdr *complete_queue;
 	u32 rd_point = cq->rd_point, wr_point, dev_id;
 	int queue = cq->id;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[queue];
 
 	if (unlikely(hisi_hba->reject_stp_links_msk))
 		phys_try_accept_stp_links_v2_hw(hisi_hba);
 
 	complete_queue = hisi_hba->complete_hdr[queue];
 
-	spin_lock(&hisi_hba->lock);
+	spin_lock(&dq->lock);
 	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
 				   (0x14 * queue));
 
@@ -3218,7 +3214,7 @@ static void cq_tasklet_v2_hw(unsigned long val)
 	/* update rd_point */
 	cq->rd_point = rd_point;
 	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
-	spin_unlock(&hisi_hba->lock);
+	spin_unlock(&dq->lock);
 }
 
 static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
-- 
1.9.1
