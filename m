From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/9] scsi: hisi_sas: Drop hisi_sas_slot_abort()
Date: Wed, 18 Jul 2018 22:14:25 +0800
Message-ID: <1531923273-193768-2-git-send-email-john.garry@huawei.com>
References: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531923273-193768-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxarm@huawei.com, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

For some time now we have not used hisi_sas_slot_abort() to handle
erroring slots, apart from in archaic v1 hw.

As such, remove this function and associated code. For v1 hw, move error
handling to same scheme as other hw revisions, where we allow erroring
commands to timeout.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 -
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 35 ----------------------------------
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  5 +----
 3 files changed, 1 insertion(+), 40 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index beda412..0ff9115 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -204,7 +204,6 @@ struct hisi_sas_slot {
 	int	ready;
 	void	*cmd_hdr;
 	dma_addr_t cmd_hdr_dma;
-	struct work_struct abort_slot;
 	struct timer_list internal_abort_timer;
 	bool is_internal;
 	struct hisi_sas_tmf_task *tmf;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 781b2af..ed671af 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -281,40 +281,6 @@ static void hisi_sas_task_prep_abort(struct hisi_hba *hisi_hba,
 			device_id, abort_flag, tag_to_abort);
 }
 
-/*
- * This function will issue an abort TMF regardless of whether the
- * task is in the sdev or not. Then it will do the task complete
- * cleanup and callbacks.
- */
-static void hisi_sas_slot_abort(struct work_struct *work)
-{
-	struct hisi_sas_slot *abort_slot =
-		container_of(work, struct hisi_sas_slot, abort_slot);
-	struct sas_task *task = abort_slot->task;
-	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
-	struct scsi_cmnd *cmnd = task->uldd_task;
-	struct hisi_sas_tmf_task tmf_task;
-	struct scsi_lun lun;
-	struct device *dev = hisi_hba->dev;
-	int tag = abort_slot->idx;
-
-	if (!(task->task_proto & SAS_PROTOCOL_SSP)) {
-		dev_err(dev, "cannot abort slot for non-ssp task\n");
-		goto out;
-	}
-
-	int_to_scsilun(cmnd->device->lun, &lun);
-	tmf_task.tmf = TMF_ABORT_TASK;
-	tmf_task.tag_of_task_to_be_managed = cpu_to_le16(tag);
-
-	hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun, &tmf_task);
-out:
-	/* Do cleanup for this task */
-	hisi_sas_slot_task_free(hisi_hba, task, abort_slot);
-	if (task->task_done)
-		task->task_done(task);
-}
-
 static int hisi_sas_task_prep(struct sas_task *task,
 			      struct hisi_sas_dq **dq_pointer,
 			      bool is_tmf, struct hisi_sas_tmf_task *tmf,
@@ -451,7 +417,6 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	slot->tmf = tmf;
 	slot->is_internal = is_tmf;
 	task->lldd_task = slot;
-	INIT_WORK(&slot->abort_slot, hisi_sas_slot_abort);
 
 	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
 	memset(hisi_sas_cmd_hdr_addr_mem(slot), 0, HISI_SAS_COMMAND_TABLE_SZ);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 3277442..7dc6874 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1296,11 +1296,8 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
 
 		slot_err_v1_hw(hisi_hba, task, slot);
-		if (unlikely(slot->abort)) {
-			queue_work(hisi_hba->wq, &slot->abort_slot);
-			/* immediately return and do not complete */
+		if (unlikely(slot->abort))
 			return ts->stat;
-		}
 		goto out;
 	}
 
-- 
1.9.1
