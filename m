From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/19] scsi: hisi_sas: grab hisi_hba.lock when processing slots
Date: Tue, 24 Oct 2017 23:51:34 +0800
Message-ID: <1508860309-212397-5-git-send-email-john.garry@huawei.com>
References: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508860309-212397-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

When adding/removing slots from device list, we need to
lock this operation with hisi_hba lock for safety.

This patch adds missing instances of this.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 5 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 2 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 2 ++
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index e038bdf..254af67 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -401,7 +401,9 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_sas_dq
 		goto err_out_buf;
 	}
 
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	list_add_tail(&slot->entry, &sas_dev->list);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -1387,8 +1389,9 @@ static int hisi_sas_query_task(struct sas_task *task)
 	if (rc)
 		goto err_out_buf;
 
-
+	spin_lock_irqsave(&hisi_hba->lock, flags);
 	list_add_tail(&slot->entry, &sas_dev->list);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
 	spin_unlock_irqrestore(&task->task_state_lock, flags);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 73d12ff..3b2e5b5 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2378,7 +2378,9 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 
 	if (unlikely(aborted)) {
 		ts->stat = SAS_ABORTED_TASK;
+		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_slot_task_free(hisi_hba, task, slot);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 		return -1;
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index d60501f..38eeba9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1400,7 +1400,9 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 	ts->resp = SAS_TASK_COMPLETE;
 	if (unlikely(aborted)) {
 		ts->stat = SAS_ABORTED_TASK;
+		spin_lock_irqsave(&hisi_hba->lock, flags);
 		hisi_sas_slot_task_free(hisi_hba, task, slot);
+		spin_unlock_irqrestore(&hisi_hba->lock, flags);
 		return -1;
 	}
 
-- 
1.9.1
