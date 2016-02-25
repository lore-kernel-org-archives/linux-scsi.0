From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 2/6] hisi_sas: add hisi_sas_slot_abort()
Date: Thu, 25 Feb 2016 17:42:11 +0800
Message-ID: <1456393335-38294-3-git-send-email-john.garry@huawei.com>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:46197 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760375AbcBYJ2y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2016 04:28:54 -0500
In-Reply-To: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

Add a function to abort a slot (task) in the target
device and then cleanup and complete the task.
The function is called from work queue context as
it cannot be called from the context where it is
triggered (interrupt).
Flag hisi_sas_slot.abort is added as the flag used
in the slot error handler to indicate whether the
slot needs to be aborted in the sdev prior to
cleanup and finish.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h      |  2 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c | 42 +++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 02da7e4..c92e65b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -112,6 +112,7 @@ struct hisi_sas_slot {
 	int	cmplt_queue;
 	int	cmplt_queue_slot;
 	int	idx;
+	int	abort;
 	void	*cmd_hdr;
 	dma_addr_t cmd_hdr_dma;
 	void	*status_buffer;
@@ -120,6 +121,7 @@ struct hisi_sas_slot {
 	dma_addr_t command_table_dma;
 	struct hisi_sas_sge_page *sge_page;
 	dma_addr_t sge_page_dma;
+	struct work_struct abort_slot;
 };
 
 struct hisi_sas_tmf_task {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 58ca336..e51612f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -15,6 +15,9 @@
 #define DEV_IS_GONE(dev) \
 	((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
 
+static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
+				u8 *lun, struct hisi_sas_tmf_task *tmf);
+
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
 	return device->port->ha->lldd_ha;
@@ -113,6 +116,44 @@ static int hisi_sas_task_prep_ata(struct hisi_hba *hisi_hba,
 	return hisi_hba->hw->prep_stp(hisi_hba, slot);
 }
 
+/*
+ * This function will issue an abort TMF regardless of whether the
+ * task is in the sdev or not. Then it will do the task complete
+ * cleanup and callbacks.
+ */
+static void hisi_sas_slot_abort(struct work_struct *work)
+{
+	struct hisi_sas_slot *abort_slot =
+		container_of(work, struct hisi_sas_slot, abort_slot);
+	struct sas_task *task = abort_slot->task;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
+	struct scsi_cmnd *cmnd = task->uldd_task;
+	struct hisi_sas_tmf_task tmf_task;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct scsi_lun lun;
+	struct device *dev = &hisi_hba->pdev->dev;
+	int tag = abort_slot->idx;
+
+	if (!(task->task_proto & SAS_PROTOCOL_SSP)) {
+		dev_err(dev, "cannot abort slot for non-ssp task\n");
+		goto out;
+	}
+
+	int_to_scsilun(cmnd->device->lun, &lun);
+	tmf_task.tmf = TMF_ABORT_TASK;
+	tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
+
+	hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun, &tmf_task);
+out:
+	/* Do cleanup for this task */
+	hisi_sas_slot_task_free(hisi_hba, task, abort_slot);
+	if (task->task_done)
+		task->task_done(task);
+	if (sas_dev && sas_dev->running_req)
+		sas_dev->running_req--;
+}
+
 static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 			      int is_tmf, struct hisi_sas_tmf_task *tmf,
 			      int *pass)
@@ -206,6 +247,7 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	slot->task = task;
 	slot->port = port;
 	task->lldd_task = slot;
+	INIT_WORK(&slot->abort_slot, hisi_sas_slot_abort);
 
 	slot->status_buffer = dma_pool_alloc(hisi_hba->status_buffer_pool,
 					     GFP_ATOMIC,
-- 
1.9.1

