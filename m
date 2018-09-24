From: John Garry <john.garry@huawei.com>
Subject: [PATCH 4/7] scsi: hisi_sas: Free slot later in slot_complete_vx_hw()
Date: Mon, 24 Sep 2018 23:06:31 +0800
Message-ID: <1537801594-207139-5-git-send-email-john.garry@huawei.com>
References: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537801594-207139-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If an SSP/SMP IO times out, it may be actually in reality be
simultaneously processing completion of the slot in slot_complete_vx_hw().

Then if the slot is freed in slot_complete_vx_hw() (this IPTT is freed and
it may be re-used by other slot), and we may abort the wrong slot in
hisi_sas_abort_task().

So to solve the issue, free the slot after the check of
SAS_TASK_STATE_ABORTED in slot_complete_vx_hw().

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 9c5c5a6..67134b4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2483,7 +2483,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 
 out:
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
@@ -2493,6 +2492,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 08b503e2..3995ff6 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1751,7 +1751,6 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	}
 
 out:
-	hisi_sas_slot_task_free(hisi_hba, task, slot);
 	sts = ts->stat;
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_ABORTED) {
@@ -1761,6 +1760,7 @@ static irqreturn_t fatal_axi_int_v3_hw(int irq_no, void *p)
 	}
 	task->task_state_flags |= SAS_TASK_STATE_DONE;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
 
 	if (!is_internal && (task->task_proto != SAS_PROTOCOL_SMP)) {
 		spin_lock_irqsave(&device->done_lock, flags);
-- 
1.9.1
