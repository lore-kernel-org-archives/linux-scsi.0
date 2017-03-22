From: John Garry <john.garry@huawei.com>
Subject: [PATCH 11/23] scsi: hisi_sas: check for SAS_TASK_STATE_ABORTED in slot complete
Date: Thu, 23 Mar 2017 01:25:27 +0800
Message-ID: <1490203539-228029-12-git-send-email-john.garry@huawei.com>
References: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1490203539-228029-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Check in slot_complete_v2_hw() for whether a task has
already been completed by upper layer.

Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index ad5a7e6..f4d8200 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1737,6 +1737,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			hisi_hba->complete_hdr[slot->cmplt_queue];
 	struct hisi_sas_complete_v2_hdr *complete_hdr =
 			&complete_queue[slot->cmplt_queue_slot];
+	int aborted;
 
 	if (unlikely(!task || !task->lldd_task || !task->dev))
 		return -EINVAL;
@@ -1745,12 +1746,21 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	device = task->dev;
 	sas_dev = device->lldd_dev;
 
+	spin_lock(&task->task_state_lock);
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
 	task->task_state_flags &=
 		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	spin_unlock(&task->task_state_lock);
 
 	memset(ts, 0, sizeof(*ts));
 	ts->resp = SAS_TASK_COMPLETE;
 
+	if (unlikely(aborted)) {
+		ts->stat = SAS_ABORTED_TASK;
+		hisi_sas_slot_task_free(hisi_hba, task, slot);
+		return -1;
+	}
+
 	if (unlikely(!sas_dev)) {
 		dev_dbg(dev, "slot complete: port has no device\n");
 		ts->stat = SAS_PHY_DOWN;
-- 
1.9.1
