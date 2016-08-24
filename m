From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 1/8] hisi_sas: add internal abort main code
Date: Wed, 24 Aug 2016 19:05:47 +0800
Message-ID: <1472036754-156813-2-git-send-email-john.garry@huawei.com>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Add main code for internal abort functionality.

The internal abort features allows the host controller
to abort commands which are still active in the
controller but have not yet been sent to the slave
device.

Typically a command only spends a relatively
short time in the controller when compared to the
amount of the time after it is sent to the slave
device.
Two modes of internal abort are supported:
- device
- individual command

For device, when the internal abort is issued all
commands in the host for that device are aborted.
For a single command, only that command is aborted
if it is still in the host.

In HW the internal abort command is executed
similar to any other sort of command, like SSP.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |   8 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 163 ++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 4731d32..8311360 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -56,6 +56,11 @@ enum dev_status {
 	HISI_SAS_DEV_EH,
 };
 
+enum {
+	HISI_SAS_INT_ABT_CMD = 0,
+	HISI_SAS_INT_ABT_DEV = 1,
+};
+
 enum hisi_sas_dev_type {
 	HISI_SAS_DEV_TYPE_STP = 0,
 	HISI_SAS_DEV_TYPE_SSP,
@@ -146,6 +151,9 @@ struct hisi_sas_hw {
 			struct hisi_sas_slot *slot);
 	int (*prep_stp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot);
+	int (*prep_abort)(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_slot *slot,
+			  int device_id, int abort_flag, int tag_to_abort);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot, int abort);
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 18dd5ea..763c6c5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -17,6 +17,10 @@
 
 static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 				u8 *lun, struct hisi_sas_tmf_task *tmf);
+static int
+hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
+			     struct domain_device *device,
+			     int abort_flag, int tag);
 
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
@@ -116,6 +120,14 @@ static int hisi_sas_task_prep_ata(struct hisi_hba *hisi_hba,
 	return hisi_hba->hw->prep_stp(hisi_hba, slot);
 }
 
+static int hisi_sas_task_prep_abort(struct hisi_hba *hisi_hba,
+		struct hisi_sas_slot *slot,
+		int device_id, int abort_flag, int tag_to_abort)
+{
+	return hisi_hba->hw->prep_abort(hisi_hba, slot,
+			device_id, abort_flag, tag_to_abort);
+}
+
 /*
  * This function will issue an abort TMF regardless of whether the
  * task is in the sdev or not. Then it will do the task complete
@@ -954,6 +966,157 @@ static int hisi_sas_query_task(struct sas_task *task)
 	return rc;
 }
 
+static int
+hisi_sas_internal_abort_task_exec(struct hisi_hba *hisi_hba, u64 device_id,
+				  struct sas_task *task, int abort_flag,
+				  int task_tag)
+{
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct hisi_sas_port *port;
+	struct hisi_sas_slot *slot;
+	struct hisi_sas_cmd_hdr *cmd_hdr_base;
+	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
+
+	if (!device->port)
+		return -1;
+
+	port = device->port->lldd_port;
+
+	/* simply get a slot and send abort command */
+	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
+	if (rc)
+		goto err_out;
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, &dlvry_queue,
+					 &dlvry_queue_slot);
+	if (rc)
+		goto err_out_tag;
+
+	slot = &hisi_hba->slot_info[slot_idx];
+	memset(slot, 0, sizeof(struct hisi_sas_slot));
+
+	slot->idx = slot_idx;
+	slot->n_elem = n_elem;
+	slot->dlvry_queue = dlvry_queue;
+	slot->dlvry_queue_slot = dlvry_queue_slot;
+	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
+	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
+	slot->task = task;
+	slot->port = port;
+	task->lldd_task = slot;
+
+	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
+
+	rc = hisi_sas_task_prep_abort(hisi_hba, slot, device_id,
+				      abort_flag, task_tag);
+	if (rc)
+		goto err_out_tag;
+
+	/* Port structure is static for the HBA, so
+	*  even if the port is deformed it is ok
+	*  to reference.
+	*/
+	list_add_tail(&slot->entry, &port->list);
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+	spin_unlock(&task->task_state_lock);
+
+	hisi_hba->slot_prep = slot;
+
+	sas_dev->running_req++;
+	/* send abort command to our chip */
+	hisi_hba->hw->start_delivery(hisi_hba);
+
+	return 0;
+
+err_out_tag:
+	hisi_sas_slot_index_free(hisi_hba, slot_idx);
+err_out:
+	dev_err(dev, "internal abort task prep: failed[%d]!\n", rc);
+
+	return rc;
+}
+
+/**
+ * hisi_sas_internal_task_abort -- execute an internal
+ * abort command for single IO command or a device
+ * @hisi_hba: host controller struct
+ * @device: domain device
+ * @abort_flag: mode of operation, device or single IO
+ * @tag: tag of IO to be aborted (only relevant to single
+ *       IO mode)
+ */
+static int
+hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
+			     struct domain_device *device,
+			     int abort_flag, int tag)
+{
+	struct sas_task *task;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	int res;
+	unsigned long flags;
+
+	if (!hisi_hba->hw->prep_abort)
+		return -EOPNOTSUPP;
+
+	task = sas_alloc_slow_task(GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->dev = device;
+	task->task_proto = device->tproto;
+	task->task_done = hisi_sas_task_done;
+	task->slow_task->timer.data = (unsigned long)task;
+	task->slow_task->timer.function = hisi_sas_tmf_timedout;
+	task->slow_task->timer.expires = jiffies + 20*HZ;
+	add_timer(&task->slow_task->timer);
+
+	/* Lock as we are alloc'ing a slot, which cannot be interrupted */
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	res = hisi_sas_internal_abort_task_exec(hisi_hba, sas_dev->device_id,
+						task, abort_flag, tag);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	if (res) {
+		del_timer(&task->slow_task->timer);
+		dev_err(dev, "internal task abort: executing internal task failed: %d\n",
+			res);
+		goto exit;
+	}
+	wait_for_completion(&task->slow_task->completion);
+	res = TMF_RESP_FUNC_FAILED;
+
+	if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		task->task_status.stat == TMF_RESP_FUNC_COMPLETE) {
+		res = TMF_RESP_FUNC_COMPLETE;
+		goto exit;
+	}
+
+	/* TMF timed out, return direct. */
+	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
+		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
+			dev_err(dev, "internal task abort: timeout.\n");
+			if (task->lldd_task) {
+				struct hisi_sas_slot *slot = task->lldd_task;
+
+				hisi_sas_slot_task_free(hisi_hba, task, slot);
+			}
+		}
+	}
+
+exit:
+	dev_info(dev, "internal task abort: task to dev %016llx task=%p "
+		"resp: 0x%x sts 0x%x\n",
+		SAS_ADDR(device->sas_addr),
+		task,
+		task->task_status.resp, /* 0 is complete, -1 is undelivered */
+		task->task_status.stat);
+	sas_free_task(task);
+
+	return res;
+}
+
 static void hisi_sas_port_formed(struct asd_sas_phy *sas_phy)
 {
 	hisi_sas_port_notify_formed(sas_phy);
-- 
1.9.1
