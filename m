From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 3/6] hisi_sas: use slot abort in v1 hw
Date: Thu, 25 Feb 2016 17:42:12 +0800
Message-ID: <1456393335-38294-4-git-send-email-john.garry@huawei.com>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When TRANS_TX_CREDIT_TIMEOUT_ERR or
TRANS_TX_CLOSE_NORMAL_ERR error occur in
a slot, the command should be re-attempted.
This error is equivalent to meaning that the queue
is full in the sdev (and not the host).

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index ce5f65d..1abbc2e 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -1212,6 +1212,14 @@ static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
 			ts->stat = SAS_NAK_R_ERR;
 			break;
 		}
+		case TRANS_TX_CREDIT_TIMEOUT_ERR:
+		case TRANS_TX_CLOSE_NORMAL_ERR:
+		{
+			/* This will request a retry */
+			ts->stat = SAS_QUEUE_FULL;
+			slot->abort = 1;
+			break;
+		}
 		default:
 		{
 			ts->stat = SAM_STAT_CHECK_CONDITION;
@@ -1319,6 +1327,11 @@ static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
 		!(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
 
 		slot_err_v1_hw(hisi_hba, task, slot);
+		if (unlikely(slot->abort)) {
+			queue_work(hisi_hba->wq, &slot->abort_slot);
+			/* immediately return and do not complete */
+			return ts->stat;
+		}
 		goto out;
 	}
 
-- 
1.9.1
