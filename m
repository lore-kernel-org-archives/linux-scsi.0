From: John Garry <john.garry@huawei.com>
Subject: [PATCH 09/23] scsi: hisi_sas: modify hisi_sas_abort_task() for SSP
Date: Thu, 23 Mar 2017 01:25:25 +0800
Message-ID: <1490203539-228029-10-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:4384 "EHLO
        dggrg02-dlp.huawei.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S935525AbdCVQ7Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Mar 2017 12:59:25 -0400
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>, Xiang Chen <chenxiang66@hisilicon.com>

Currently an internal abort is executed regardless
of the result of the TMF. We should also check the
result of the internal abort to see if we should
free the slot.

So change the status code STAT_IO_COMPLETE to
TMF_RESP_FUNC_SUCC, meaning the slot has been
successfully aborted.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 28 ++++++++++++++++++----------
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  2 +-
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 00068d2..36d4e5a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -935,6 +935,7 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		struct scsi_cmnd *cmnd = task->uldd_task;
 		struct hisi_sas_slot *slot = task->lldd_task;
 		u32 tag = slot->idx;
+		int rc2;
 
 		int_to_scsilun(cmnd->device->lun, &lun);
 		tmf_task.tmf = TMF_ABORT_TASK;
@@ -943,21 +944,22 @@ static int hisi_sas_abort_task(struct sas_task *task)
 		rc = hisi_sas_debug_issue_ssp_tmf(task->dev, lun.scsi_lun,
 						  &tmf_task);
 
-		/* if successful, clear the task and callback forwards.*/
-		if (rc == TMF_RESP_FUNC_COMPLETE) {
+		rc2 = hisi_sas_internal_task_abort(hisi_hba, device,
+						   HISI_SAS_INT_ABT_CMD, tag);
+		/*
+		 * If the TMF finds that the IO is not in the device and also
+		 * the internal abort does not succeed, then it is safe to
+		 * free the slot.
+		 * Note: if the internal abort succeeds then the slot
+		 * will have already been completed
+		 */
+		if (rc == TMF_RESP_FUNC_COMPLETE && rc2 != TMF_RESP_FUNC_SUCC) {
 			if (task->lldd_task) {
-				struct hisi_sas_slot *slot;
-
-				slot = &hisi_hba->slot_info
-					[tmf_task.tag_of_task_to_be_managed];
 				spin_lock_irqsave(&hisi_hba->lock, flags);
-				hisi_hba->hw->slot_complete(hisi_hba, slot);
+				hisi_sas_do_release_task(hisi_hba, task, slot);
 				spin_unlock_irqrestore(&hisi_hba->lock, flags);
 			}
 		}
-
-		hisi_sas_internal_task_abort(hisi_hba, device,
-					     HISI_SAS_INT_ABT_CMD, tag);
 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
 		task->task_proto & SAS_PROTOCOL_STP) {
 		if (task->dev->dev_type == SAS_SATA_DEV) {
@@ -1220,6 +1222,12 @@ static int hisi_sas_query_task(struct sas_task *task)
 		goto exit;
 	}
 
+	if (task->task_status.resp == SAS_TASK_COMPLETE &&
+		task->task_status.stat == TMF_RESP_FUNC_SUCC) {
+		res = TMF_RESP_FUNC_SUCC;
+		goto exit;
+	}
+
 	/* TMF timed out, return direct. */
 	if ((task->task_state_flags & SAS_TASK_STATE_ABORTED)) {
 		if (!(task->task_state_flags & SAS_TASK_STATE_DONE)) {
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a35f881..ad5a7e6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1766,7 +1766,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		goto out;
 	case STAT_IO_COMPLETE:
 		/* internal abort command complete */
-		ts->stat = TMF_RESP_FUNC_COMPLETE;
+		ts->stat = TMF_RESP_FUNC_SUCC;
 		goto out;
 	case STAT_IO_NO_DEVICE:
 		ts->stat = TMF_RESP_FUNC_COMPLETE;
-- 
1.9.1
