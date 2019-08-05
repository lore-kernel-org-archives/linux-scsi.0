From: John Garry <john.garry@huawei.com>
Subject: [PATCH 14/15] scsi: hisi_sas: replace "%p" with "%pK"
Date: Mon, 5 Aug 2019 21:48:11 +0800
Message-ID: <1565012892-75940-15-git-send-email-john.garry@huawei.com>
References: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The format specifier "%p" can leak kernel address, and use "%pK" instead.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 6 +++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e1c52811f4c7..acb87b4f9622 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -2102,7 +2102,7 @@ _hisi_sas_internal_task_abort(struct hisi_hba *hisi_hba,
 	}
 
 exit:
-	dev_dbg(dev, "internal task abort: task to dev %016llx task=%p resp: 0x%x sts 0x%x\n",
+	dev_dbg(dev, "internal task abort: task to dev %016llx task=%pK resp: 0x%x sts 0x%x\n",
 		SAS_ADDR(device->sas_addr), task,
 		task->task_status.resp, /* 0 is complete, -1 is undelivered */
 		task->task_status.stat);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index a3f8c51b3500..fba4fcad4735 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2393,7 +2393,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 			slot_err_v2_hw(hisi_hba, task, slot, 2);
 
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
 				 slot->idx, task, sas_dev->device_id,
 				 complete_hdr->dw0, complete_hdr->dw1,
 				 complete_hdr->act, complete_hdr->dw3,
@@ -2455,7 +2455,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		dev_info(dev, "slot complete: task(%p) aborted\n", task);
+		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
 		return SAS_ABORTED_TASK;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
@@ -2466,7 +2466,7 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 		spin_lock_irqsave(&device->done_lock, flags);
 		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
 			spin_unlock_irqrestore(&device->done_lock, flags);
-			dev_info(dev, "slot complete: task(%p) ignored\n",
+			dev_info(dev, "slot complete: task(%pK) ignored\n",
 				 task);
 			return sts;
 		}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index db8c7e4b1954..2adb5c93bd81 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2190,7 +2190,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 
 		slot_err_v3_hw(hisi_hba, task, slot);
 		if (ts->stat != SAS_DATA_UNDERRUN)
-			dev_info(dev, "erroneous completion iptt=%d task=%p dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
+			dev_info(dev, "erroneous completion iptt=%d task=%pK dev id=%d CQ hdr: 0x%x 0x%x 0x%x 0x%x Error info: 0x%x 0x%x 0x%x 0x%x\n",
 				 slot->idx, task, sas_dev->device_id,
 				 dw0, dw1, complete_hdr->act, dw3,
 				 error_info[0], error_info[1],
@@ -2245,7 +2245,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
-		dev_info(dev, "slot complete: task(%p) aborted\n", task);
+		dev_info(dev, "slot complete: task(%pK) aborted\n", task);
 		return SAS_ABORTED_TASK;
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
@@ -2256,7 +2256,7 @@ slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
 		spin_lock_irqsave(&device->done_lock, flags);
 		if (test_bit(SAS_HA_FROZEN, &ha->state)) {
 			spin_unlock_irqrestore(&device->done_lock, flags);
-			dev_info(dev, "slot complete: task(%p) ignored\n ",
+			dev_info(dev, "slot complete: task(%pK) ignored\n ",
 				 task);
 			return sts;
 		}
-- 
2.17.1
