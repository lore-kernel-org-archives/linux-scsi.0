From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 4/6] hisi_sas: use slot abort in v2 hw
Date: Thu, 25 Feb 2016 17:42:13 +0800
Message-ID: <1456393335-38294-5-git-send-email-john.garry@huawei.com>
References: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456393335-38294-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

When TRANS_TX_ERR_FRAME_TXED error occurs in
a slot, the command should be re-attempted.
This error is equivalent to meaning that the queue
is full in the sdev (and not the host).
A superflous debug statement is also removed in the
slot complete handler.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 58e1956..b733747 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1299,6 +1299,13 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 			ts->stat = SAS_DATA_UNDERRUN;
 			break;
 		}
+		case TRANS_TX_ERR_FRAME_TXED:
+		{
+			/* This will request a retry */
+			ts->stat = SAS_QUEUE_FULL;
+			slot->abort = 1;
+			break;
+		}
 		case TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS:
 		case TRANS_TX_ERR_PHY_NOT_ENABLE:
 		case TRANS_TX_OPEN_CNX_ERR_BY_OTHER:
@@ -1491,11 +1498,13 @@ slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 
 	if ((complete_hdr->dw0 & CMPLT_HDR_ERX_MSK) &&
 		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
-		dev_dbg(dev, "%s slot %d has error info 0x%x\n",
-			__func__, slot->cmplt_queue_slot,
-			complete_hdr->dw0 & CMPLT_HDR_ERX_MSK);
 
 		slot_err_v2_hw(hisi_hba, task, slot);
+		if (unlikely(slot->abort)) {
+			queue_work(hisi_hba->wq, &slot->abort_slot);
+			/* immediately return and do not complete */
+			return ts->stat;
+		}
 		goto out;
 	}
 
-- 
1.9.1
