From: John Garry <john.garry@huawei.com>
Subject: [PATCH 8/9] scsi: hisi_sas: add memory barrier in task delivery function
Date: Wed, 18 Jul 2018 22:14:32 +0800
Message-ID: <1531923273-193768-9-git-send-email-john.garry@huawei.com>
References: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

In task start delivery function, we need to add a memory barrier to
prevent re-ordering of reading memory by hardware. Because the slot data
is set in task prepare function and it could be running in another CPU.

This patch adds an memory barrier after s->ready is read in the task start
delivery function, and uses WRITE_ONCE() in the places where s->ready
is set to ensure that the compiler does not re-order.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  4 ++--
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 15 ++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 15 ++++++++++-----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 15 ++++++++++-----
 4 files changed, 32 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 432a38a..a4e2e6a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -446,7 +446,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
 	++(*pass);
-	slot->ready = 1;
+	WRITE_ONCE(slot->ready, 1);
 
 	return 0;
 
@@ -1749,7 +1749,7 @@ static int hisi_sas_query_task(struct sas_task *task)
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
 
-	slot->ready = 1;
+	WRITE_ONCE(slot->ready, 1);
 	/* send abort command to the chip */
 	spin_lock_irqsave(&dq->lock, flags);
 	list_add_tail(&slot->entry, &sas_dev->list);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 7dc6874..8f60f0e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -903,23 +903,28 @@ static int get_wideport_bitmap_v1_hw(struct hisi_hba *hisi_hba, int port_id)
 static void start_delivery_v1_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
-	struct hisi_sas_slot *s, *s1;
+	struct hisi_sas_slot *s, *s1, *s2 = NULL;
 	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
-	int wp, count = 0;
+	int wp;
 
 	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
-		count++;
-		wp = (s->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+		s2 = s;
 		list_del(&s->delivery);
 	}
 
-	if (!count)
+	if (!s2)
 		return;
 
+	/*
+	 * Ensure that memories for slots built on other CPUs is observed.
+	 */
+	smp_rmb();
+	wp = (s2->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14), wp);
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 159576e..5a3d6a7 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1665,23 +1665,28 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 static void start_delivery_v2_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
-	struct hisi_sas_slot *s, *s1;
+	struct hisi_sas_slot *s, *s1, *s2 = NULL;
 	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
-	int wp, count = 0;
+	int wp;
 
 	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
-		count++;
-		wp = (s->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+		s2 = s;
 		list_del(&s->delivery);
 	}
 
-	if (!count)
+	if (!s2)
 		return;
 
+	/*
+	 * Ensure that memories for slots built on other CPUs is observed.
+	 */
+	smp_rmb();
+	wp = (s2->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14), wp);
 }
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 3d20fcf..70e2299 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -882,23 +882,28 @@ static int get_wideport_bitmap_v3_hw(struct hisi_hba *hisi_hba, int port_id)
 static void start_delivery_v3_hw(struct hisi_sas_dq *dq)
 {
 	struct hisi_hba *hisi_hba = dq->hisi_hba;
-	struct hisi_sas_slot *s, *s1;
+	struct hisi_sas_slot *s, *s1, *s2 = NULL;
 	struct list_head *dq_list;
 	int dlvry_queue = dq->id;
-	int wp, count = 0;
+	int wp;
 
 	dq_list = &dq->list;
 	list_for_each_entry_safe(s, s1, &dq->list, delivery) {
 		if (!s->ready)
 			break;
-		count++;
-		wp = (s->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+		s2 = s;
 		list_del(&s->delivery);
 	}
 
-	if (!count)
+	if (!s2)
 		return;
 
+	/*
+	 * Ensure that memories for slots built on other CPUs is observed.
+	 */
+	smp_rmb();
+	wp = (s2->dlvry_queue_slot + 1) % HISI_SAS_QUEUE_SLOTS;
+
 	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14), wp);
 }
 
-- 
1.9.1
