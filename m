From: John Garry <john.garry@huawei.com>
Subject: [PATCH 7/9] scsi: hisi_sas: Tidy hisi_sas_task_prep()
Date: Wed, 18 Jul 2018 22:14:31 +0800
Message-ID: <1531923273-193768-8-git-send-email-john.garry@huawei.com>
References: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

To decrease the usage of spinlock during delivery IO, relocate some code
in hisi_sas_task_prep().

Also an invalid comment is removed.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b0bcd14..432a38a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -296,8 +296,8 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
 	int n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
-	unsigned long flags, flags_dq;
 	struct hisi_sas_dq *dq;
+	unsigned long flags;
 	int wr_q_index;
 
 	if (!sas_port) {
@@ -393,16 +393,17 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 	slot = &hisi_hba->slot_info[slot_idx];
 
-	spin_lock_irqsave(&dq->lock, flags_dq);
+	spin_lock_irqsave(&dq->lock, flags);
 	wr_q_index = hisi_hba->hw->get_free_slot(hisi_hba, dq);
 	if (wr_q_index < 0) {
-		spin_unlock_irqrestore(&dq->lock, flags_dq);
+		spin_unlock_irqrestore(&dq->lock, flags);
 		rc = -EAGAIN;
 		goto err_out_tag;
 	}
 
 	list_add_tail(&slot->delivery, &dq->list);
-	spin_unlock_irqrestore(&dq->lock, flags_dq);
+	list_add_tail(&slot->entry, &sas_dev->list);
+	spin_unlock_irqrestore(&dq->lock, flags);
 
 	dlvry_queue = dq->id;
 	dlvry_queue_slot = wr_q_index;
@@ -440,9 +441,6 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		break;
 	}
 
-	spin_lock_irqsave(&dq->lock, flags);
-	list_add_tail(&slot->entry, &sas_dev->list);
-	spin_unlock_irqrestore(&dq->lock, flags);
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -818,7 +816,6 @@ static void hisi_sas_do_release_task(struct hisi_hba *hisi_hba, struct sas_task
 	hisi_sas_slot_task_free(hisi_hba, task, slot);
 }
 
-/* hisi_hba.lock should be locked */
 static void hisi_sas_release_task(struct hisi_hba *hisi_hba,
 			struct domain_device *device)
 {
-- 
1.9.1
