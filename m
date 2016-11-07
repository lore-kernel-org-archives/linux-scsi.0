From: John Garry <john.garry@huawei.com>
Subject: [PATCH 02/11] hisi_sas: alloc queue id of slot according to device id
Date: Mon, 7 Nov 2016 20:48:31 +0800
Message-ID: <1478522920-108145-3-git-send-email-john.garry@huawei.com>
References: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478522920-108145-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, john.garry2@mail.dcu.ie, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Currently slots are allocated from queues in a round-robin fashion.
This causes a problem for internal commands in device mode. For this
mode, we should ensure that the internal abort command is the last
command seen in the host for that device. We can only ensure this when
we place the internal abort command after the preceding commands for
device that in the same queue, as there is no order in which the host
will select a queue to execute the next command.

This queue restriction makes supporting scsi mq more tricky in
the future, but should not be a blocker.

Note: Even though v1 hw does not support internal abort, the
      allocation method is chosen to be the same for consistency.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  8 ++++----
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 30 ++++++++++++------------------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 29 ++++++++++++-----------------
 4 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 64046c5..bf59fab 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -150,7 +150,8 @@ struct hisi_sas_hw {
 				struct domain_device *device);
 	struct hisi_sas_device *(*alloc_dev)(struct domain_device *device);
 	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
-	int (*get_free_slot)(struct hisi_hba *hisi_hba, int *q, int *s);
+	int (*get_free_slot)(struct hisi_hba *hisi_hba, u32 dev_id,
+			int *q, int *s);
 	void (*start_delivery)(struct hisi_hba *hisi_hba);
 	int (*prep_ssp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot, int is_tmf,
@@ -207,7 +208,6 @@ struct hisi_hba {
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 
 	int	queue_count;
-	int	queue;
 	struct hisi_sas_slot	*slot_prep;
 
 	struct dma_pool *sge_page_pool;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 9afc697..9f5ccc5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -232,8 +232,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 		rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
 	if (rc)
 		goto err_out;
-	rc = hisi_hba->hw->get_free_slot(hisi_hba, &dlvry_queue,
-					 &dlvry_queue_slot);
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, sas_dev->device_id,
+					&dlvry_queue, &dlvry_queue_slot);
 	if (rc)
 		goto err_out_tag;
 
@@ -987,8 +987,8 @@ static int hisi_sas_query_task(struct sas_task *task)
 	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
 	if (rc)
 		goto err_out;
-	rc = hisi_hba->hw->get_free_slot(hisi_hba, &dlvry_queue,
-					 &dlvry_queue_slot);
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, sas_dev->device_id,
+					&dlvry_queue, &dlvry_queue_slot);
 	if (rc)
 		goto err_out_tag;
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index c0ac49d..bbc5760 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -862,29 +862,23 @@ static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
  * The callpath to this function and upto writing the write
  * queue pointer should be safe from interruption.
  */
-static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s)
+static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, u32 dev_id,
+				int *q, int *s)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
 	struct hisi_sas_dq *dq;
 	u32 r, w;
-	int queue = hisi_hba->queue;
-
-	while (1) {
-		dq = &hisi_hba->dq[queue];
-		w = dq->wr_point;
-		r = hisi_sas_read32_relaxed(hisi_hba,
-				    DLVRY_Q_0_RD_PTR + (queue * 0x14));
-		if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
-			queue = (queue + 1) % hisi_hba->queue_count;
-			if (queue == hisi_hba->queue) {
-				dev_warn(dev, "could not find free slot\n");
-				return -EAGAIN;
-			}
-			continue;
-		}
-		break;
+	int queue = dev_id % hisi_hba->queue_count;
+
+	dq = &hisi_hba->dq[queue];
+	w = dq->wr_point;
+	r = hisi_sas_read32_relaxed(hisi_hba,
+				DLVRY_Q_0_RD_PTR + (queue * 0x14));
+	if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
+		dev_warn(dev, "could not find free slot\n");
+		return -EAGAIN;
 	}
-	hisi_hba->queue = (queue + 1) % hisi_hba->queue_count;
+
 	*q = queue;
 	*s = w;
 	return 0;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9e70e6d..cb19e73 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1089,29 +1089,24 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
  * The callpath to this function and upto writing the write
  * queue pointer should be safe from interruption.
  */
-static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, int *q, int *s)
+static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, u32 dev_id,
+				int *q, int *s)
 {
 	struct device *dev = &hisi_hba->pdev->dev;
 	struct hisi_sas_dq *dq;
 	u32 r, w;
-	int queue = hisi_hba->queue;
+	int queue = dev_id % hisi_hba->queue_count;
 
-	while (1) {
-		dq = &hisi_hba->dq[queue];
-		w = dq->wr_point;
-		r = hisi_sas_read32_relaxed(hisi_hba,
-					    DLVRY_Q_0_RD_PTR + (queue * 0x14));
-		if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
-			queue = (queue + 1) % hisi_hba->queue_count;
-			if (queue == hisi_hba->queue) {
-				dev_warn(dev, "could not find free slot\n");
-				return -EAGAIN;
-			}
-			continue;
-		}
-		break;
+	dq = &hisi_hba->dq[queue];
+	w = dq->wr_point;
+	r = hisi_sas_read32_relaxed(hisi_hba,
+				DLVRY_Q_0_RD_PTR + (queue * 0x14));
+	if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
+		dev_warn(dev, "full queue=%d r=%d w=%d\n\n",
+				queue, r, w);
+		return -EAGAIN;
 	}
-	hisi_hba->queue = (queue + 1) % hisi_hba->queue_count;
+
 	*q = queue;
 	*s = w;
 	return 0;
-- 
1.9.1
