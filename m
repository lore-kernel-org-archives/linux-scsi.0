From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/6] hisi_sas: use slot abort in v1 hw
Date: Tue, 16 Feb 2016 20:22:28 +0800
Message-ID: <1455625351-165881-4-git-send-email-john.garry@huawei.com>
References: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455625351-165881-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When TRANS_TX_CREDIT_TIMEOUT_ERR or
TRANS_TX_CLOSE_NORMAL_ERR errors occur for a
command, the command should be re-attempted.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index ce5f65d..34f71a1c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1118,9 +1118,8 @@ static int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 }
 
 /* by default, task resp is complete */
-static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
-			   struct sas_task *task,
-			   struct hisi_sas_slot *slot)
+static void slot_err_v1_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
+			   struct hisi_sas_slot *slot, int *abort_slot)
 {
 	struct task_status_struct *ts = &task->task_status;
 	struct hisi_sas_err_record_v1 *err_record = slot->status_buffer;
@@ -1212,6 +1211,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 			ts->stat = SAS_NAK_R_ERR;
 			break;
 		}
+		case TRANS_TX_CREDIT_TIMEOUT_ERR:
+		case TRANS_TX_CLOSE_NORMAL_ERR:
+		{
+			/* This will request a retry */
+			ts->stat = SAS_QUEUE_FULL;
+			++(*abort_slot);
+			break;
+		}
 		default:
 		{
 			ts->stat = SAM_STAT_CHECK_CONDITION;
@@ -1317,8 +1324,14 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 
 	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK &&
 		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
+		int abort_slot = 0;
 
-		slot_err_v1_hw(hisi_hba, task, slot);
+		slot_err_v1_hw(hisi_hba, task, slot,  &abort_slot);
+		if (unlikely(abort_slot)) {
+			queue_work(hisi_hba->wq, &slot->abort_slot);
+			sts = ts->stat;
+			goto out_1;
+		}
 		goto out;
 	}
 
@@ -1375,6 +1388,7 @@ out:
 
 	if (task->task_done)
 		task->task_done(task);
+out_1:
 
 	return sts;
 }
-- 
1.9.1
