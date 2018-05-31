From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/9] scsi: hisi_sas: Pre-allocate slot DMA buffers
Date: Thu, 31 May 2018 20:50:48 +0800
Message-ID: <1527771050-200916-8-git-send-email-john.garry@huawei.com>
References: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527771050-200916-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently the driver spends much time allocating and freeing the slot DMA
buffer for command delivery/completion. To boost the performance,
pre-allocate the buffers for all IPTT. The downside of this approach is
that we are reallocating all buffer memory upfront, so hog memory which
we may not need.

However, the current method - DMA buffer pool - also caches all buffers
and does not free them until the pool is destroyed, so is not exactly
efficient either.

On top of this, since the slot DMA buffer is slightly bigger than a 4K
page, we need to allocate 2x4K pages per buffer (for 4K page kernel),
which is quite wasteful. For 64K page size this is not such an issue.

So, for the 4K page case, in order to make memory usage more efficient,
pre-allocating larger blocks of DMA memory for the buffers can be more
efficient.

To make DMA memory usage most efficient, we would choose a single
contiguous DMA memory block, but this could use up all the DMA memory in
the system (when CMA enabled and no IOMMU), or we may just not be able to
allocate a DMA buffer large enough when no CMA or IOMMU.

To decide the block size we use the LCM (least common multiple) of the
buffer size and the page size. We roundup(64) to ensure the LCM is not
too large, even though a little memory may be wasted per block.

So, with this, the total memory requirement is about is about 17MB
for 4096 max IPTT.

Previously (for 4K pages case), it would be 32MB (for all slots
allocated).

With this change, the relative increase of IOPS for bs=4K read when
PAGE_SIZE=4K and PAGE_SIZE=64K is as follows:
    IODEPTH     4K PAGE_SIZE      64K PAGE_SIZE
    32          56%               47%
    64          53%               44%
    128         64%               43%
    256         67%               45%

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  9 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c | 78 +++++++++++++++++------------------
 2 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 78e5a92..beda412 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -16,6 +16,7 @@
 #include <linux/clk.h>
 #include <linux/dmapool.h>
 #include <linux/iopoll.h>
+#include <linux/lcm.h>
 #include <linux/mfd/syscon.h>
 #include <linux/module.h>
 #include <linux/of_address.h>
@@ -199,17 +200,18 @@ struct hisi_sas_slot {
 	int	dlvry_queue_slot;
 	int	cmplt_queue;
 	int	cmplt_queue_slot;
-	int	idx;
 	int	abort;
 	int	ready;
-	void	*buf;
-	dma_addr_t buf_dma;
 	void	*cmd_hdr;
 	dma_addr_t cmd_hdr_dma;
 	struct work_struct abort_slot;
 	struct timer_list internal_abort_timer;
 	bool is_internal;
 	struct hisi_sas_tmf_task *tmf;
+	/* Do not reorder/change members after here */
+	void	*buf;
+	dma_addr_t buf_dma;
+	int	idx;
 };
 
 struct hisi_sas_hw {
@@ -299,7 +301,6 @@ struct hisi_hba {
 
 	int	queue_count;
 
-	struct dma_pool *buffer_pool;
 	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
 	struct hisi_sas_cmd_hdr	*cmd_hdr[HISI_SAS_MAX_QUEUES];
 	dma_addr_t cmd_hdr_dma[HISI_SAS_MAX_QUEUES];
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index da1d5fe..20aab10 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -242,20 +242,16 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 					     task->data_dir);
 	}
 
-	if (slot->buf)
-		dma_pool_free(hisi_hba->buffer_pool, slot->buf, slot->buf_dma);
 
 	spin_lock_irqsave(&dq->lock, flags);
 	list_del_init(&slot->entry);
 	spin_unlock_irqrestore(&dq->lock, flags);
-	slot->buf = NULL;
-	slot->task = NULL;
-	slot->port = NULL;
+
+	memset(slot, 0, offsetof(struct hisi_sas_slot, buf));
+
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_index_free(hisi_hba, slot->idx);
 	spin_unlock_irqrestore(&hisi_hba->lock, flags);
-
-	/* slot memory is fully zeroed when it is reused */
 }
 EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
 
@@ -430,21 +426,13 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		goto err_out_dma_unmap;
 
 	slot = &hisi_hba->slot_info[slot_idx];
-	memset(slot, 0, sizeof(struct hisi_sas_slot));
-
-	slot->buf = dma_pool_alloc(hisi_hba->buffer_pool,
-				   GFP_ATOMIC, &slot->buf_dma);
-	if (!slot->buf) {
-		rc = -ENOMEM;
-		goto err_out_tag;
-	}
 
 	spin_lock_irqsave(&dq->lock, flags_dq);
 	wr_q_index = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (wr_q_index < 0) {
 		spin_unlock_irqrestore(&dq->lock, flags_dq);
 		rc = -EAGAIN;
-		goto err_out_buf;
+		goto err_out_tag;
 	}
 
 	list_add_tail(&slot->delivery, &dq->list);
@@ -453,7 +441,6 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
 
-	slot->idx = slot_idx;
 	slot->n_elem = n_elem;
 	slot->dlvry_queue = dlvry_queue;
 	slot->dlvry_queue_slot = dlvry_queue_slot;
@@ -500,9 +487,6 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 	return 0;
 
-err_out_buf:
-	dma_pool_free(hisi_hba->buffer_pool, slot->buf,
-		      slot->buf_dma);
 err_out_tag:
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_index_free(hisi_hba, slot_idx);
@@ -1749,21 +1733,13 @@ static int hisi_sas_query_task(struct sas_task *task)
 	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 
 	slot = &hisi_hba->slot_info[slot_idx];
-	memset(slot, 0, sizeof(struct hisi_sas_slot));
-
-	slot->buf = dma_pool_alloc(hisi_hba->buffer_pool,
-			GFP_ATOMIC, &slot->buf_dma);
-	if (!slot->buf) {
-		rc = -ENOMEM;
-		goto err_out_tag;
-	}
 
 	spin_lock_irqsave(&dq->lock, flags_dq);
 	wr_q_index = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (wr_q_index < 0) {
 		spin_unlock_irqrestore(&dq->lock, flags_dq);
 		rc = -EAGAIN;
-		goto err_out_buf;
+		goto err_out_tag;
 	}
 	list_add_tail(&slot->delivery, &dq->list);
 	spin_unlock_irqrestore(&dq->lock, flags_dq);
@@ -1771,7 +1747,6 @@ static int hisi_sas_query_task(struct sas_task *task)
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
 
-	slot->idx = slot_idx;
 	slot->n_elem = n_elem;
 	slot->dlvry_queue = dlvry_queue;
 	slot->dlvry_queue_slot = dlvry_queue_slot;
@@ -1802,9 +1777,6 @@ static int hisi_sas_query_task(struct sas_task *task)
 
 	return 0;
 
-err_out_buf:
-	dma_pool_free(hisi_hba->buffer_pool, slot->buf,
-		      slot->buf_dma);
 err_out_tag:
 	spin_lock_irqsave(&hisi_hba->lock, flags);
 	hisi_sas_slot_index_free(hisi_hba, slot_idx);
@@ -2041,7 +2013,9 @@ void hisi_sas_init_mem(struct hisi_hba *hisi_hba)
 int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 {
 	struct device *dev = hisi_hba->dev;
-	int i, s, max_command_entries = hisi_hba->hw->max_command_entries;
+	int i, j, s, max_command_entries = hisi_hba->hw->max_command_entries;
+	int max_command_entries_ru, sz_slot_buf_ru;
+	int blk_cnt, slots_per_blk;
 
 	sema_init(&hisi_hba->sem, 1);
 	spin_lock_init(&hisi_hba->lock);
@@ -2088,11 +2062,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 			goto err_out;
 	}
 
-	s = sizeof(struct hisi_sas_slot_buf_table);
-	hisi_hba->buffer_pool = dma_pool_create("dma_buffer", dev, s, 16, 0);
-	if (!hisi_hba->buffer_pool)
-		goto err_out;
-
 	s = HISI_SAS_MAX_ITCT_ENTRIES * sizeof(struct hisi_sas_itct);
 	hisi_hba->itct = dmam_alloc_coherent(dev, s, &hisi_hba->itct_dma,
 					     GFP_KERNEL);
@@ -2106,6 +2075,35 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	if (!hisi_hba->slot_info)
 		goto err_out;
 
+	/* roundup to avoid overly large block size */
+	max_command_entries_ru = roundup(max_command_entries, 64);
+	sz_slot_buf_ru = roundup(sizeof(struct hisi_sas_slot_buf_table), 64);
+	s = lcm(max_command_entries_ru, sz_slot_buf_ru);
+	blk_cnt = (max_command_entries_ru * sz_slot_buf_ru) / s;
+	slots_per_blk = s / sz_slot_buf_ru;
+	for (i = 0; i < blk_cnt; i++) {
+		struct hisi_sas_slot_buf_table *buf;
+		dma_addr_t buf_dma;
+		int slot_index = i * slots_per_blk;
+
+		buf = dmam_alloc_coherent(dev, s, &buf_dma, GFP_KERNEL);
+		if (!buf)
+			goto err_out;
+		memset(buf, 0, s);
+
+		for (j = 0; j < slots_per_blk; j++, slot_index++) {
+			struct hisi_sas_slot *slot;
+
+			slot = &hisi_hba->slot_info[slot_index];
+			slot->buf = buf;
+			slot->buf_dma = buf_dma;
+			slot->idx = slot_index;
+
+			buf++;
+			buf_dma += sizeof(*buf);
+		}
+	}
+
 	s = max_command_entries * sizeof(struct hisi_sas_iost);
 	hisi_hba->iost = dmam_alloc_coherent(dev, s, &hisi_hba->iost_dma,
 					     GFP_KERNEL);
@@ -2156,8 +2154,6 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 void hisi_sas_free(struct hisi_hba *hisi_hba)
 {
-	dma_pool_destroy(hisi_hba->buffer_pool);
-
 	if (hisi_hba->wq)
 		destroy_workqueue(hisi_hba->wq);
 }
-- 
1.9.1
