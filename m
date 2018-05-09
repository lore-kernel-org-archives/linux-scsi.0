From: John Garry <john.garry@huawei.com>
Subject: [PATCH 6/6] scsi: hisi_sas: add check of device in hisi_sas_task_exec()
Date: Wed, 9 May 2018 23:10:50 +0800
Message-ID: <1525878650-213087-7-git-send-email-john.garry@huawei.com>
References: <1525878650-213087-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525878650-213087-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, Xiaofei Tan <tanxiaofei@huawei.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiaofei Tan <tanxiaofei@huawei.com>

Currently we don't check that device is not gone before
dereferencing it's elements in the function
hisi_sas_task_exec() (specifically, the DQ pointer).

This patch fixes this issue by filling in the DQ
pointer in hisi_sas_task_prep(), after we check
that the device pointer is still safe to
reference.

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index a451625..39f694e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -310,12 +310,13 @@ static void hisi_sas_slot_abort(struct work_struct *work)
 		task->task_done(task);
 }
 
-static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq *dq,
+static int hisi_sas_task_prep(struct sas_task *task,
+			      struct hisi_sas_dq **dq_pointer,
 			      int is_tmf, struct hisi_sas_tmf_task *tmf,
 			      int *pass)
 {
-	struct hisi_hba *hisi_hba = dq->hisi_hba;
 	struct domain_device *device = task->dev;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(device);
 	struct hisi_sas_device *sas_dev = device->lldd_dev;
 	struct hisi_sas_port *port;
 	struct hisi_sas_slot *slot;
@@ -323,8 +324,9 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq *dq,
 	struct asd_sas_port *sas_port = device->port;
 	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
-	int  n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
+	int n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
 	unsigned long flags, flags_dq;
+	struct hisi_sas_dq *dq;
 	int wr_q_index;
 
 	if (!sas_port) {
@@ -352,6 +354,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq *dq,
 		return -ECOMM;
 	}
 
+	*dq_pointer = dq = sas_dev->dq;
+
 	port = to_hisi_sas_port(sas_port);
 	if (port && !port->port_attached) {
 		dev_info(dev, "task prep: %s port%d not attach device\n",
@@ -520,22 +524,21 @@ static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
 	unsigned long flags;
 	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
 	struct device *dev = hisi_hba->dev;
-	struct domain_device *device = task->dev;
-	struct hisi_sas_device *sas_dev = device->lldd_dev;
-	struct hisi_sas_dq *dq = sas_dev->dq;
+	struct hisi_sas_dq *dq = NULL;
 
 	if (unlikely(test_bit(HISI_SAS_REJECT_CMD_BIT, &hisi_hba->flags)))
 		return -EINVAL;
 
 	/* protect task_prep and start_delivery sequence */
-	rc = hisi_sas_task_prep(task, dq, is_tmf, tmf, &pass);
+	rc = hisi_sas_task_prep(task, &dq, is_tmf, tmf, &pass);
 	if (rc)
 		dev_err(dev, "task exec: failed[%d]!\n", rc);
 
-	spin_lock_irqsave(&dq->lock, flags);
-	if (likely(pass))
+	if (likely(pass)) {
+		spin_lock_irqsave(&dq->lock, flags);
 		hisi_hba->hw->start_delivery(dq);
-	spin_unlock_irqrestore(&dq->lock, flags);
+		spin_unlock_irqrestore(&dq->lock, flags);
+	}
 
 	return rc;
 }
-- 
1.9.1
