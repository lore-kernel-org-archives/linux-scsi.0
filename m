From: John Garry <john.garry@huawei.com>
Subject: [PATCH 08/19] scsi: hisi_sas: change ncq process for v3 hw
Date: Sat, 9 Dec 2017 01:16:39 +0800
Message-ID: <1512753410-50924-9-git-send-email-john.garry@huawei.com>
References: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1512753410-50924-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For v3 hw, each NCQ will return a CQ, so it is no need to
acquire IPTT from ITCT, just acquire it from IPTT field of
CQ.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 40 +++++-----------------------------
 1 file changed, 6 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 44f07bc..69aa7bc 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -1653,9 +1653,8 @@ static void cq_tasklet_v3_hw(unsigned long val)
 	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
 	struct hisi_hba *hisi_hba = cq->hisi_hba;
 	struct hisi_sas_slot *slot;
-	struct hisi_sas_itct *itct;
 	struct hisi_sas_complete_v3_hdr *complete_queue;
-	u32 rd_point = cq->rd_point, wr_point, dev_id;
+	u32 rd_point = cq->rd_point, wr_point;
 	int queue = cq->id;
 	struct hisi_sas_dq *dq = &hisi_hba->dq[queue];
 
@@ -1671,38 +1670,11 @@ static void cq_tasklet_v3_hw(unsigned long val)
 
 		complete_hdr = &complete_queue[rd_point];
 
-		/* Check for NCQ completion */
-		if (complete_hdr->act) {
-			u32 act_tmp = complete_hdr->act;
-			int ncq_tag_count = ffs(act_tmp);
-
-			dev_id = (complete_hdr->dw1 & CMPLT_HDR_DEV_ID_MSK) >>
-				 CMPLT_HDR_DEV_ID_OFF;
-			itct = &hisi_hba->itct[dev_id];
-
-			/* The NCQ tags are held in the itct header */
-			while (ncq_tag_count) {
-				__le64 *ncq_tag = &itct->qw4_15[0];
-
-				ncq_tag_count -= 1;
-				iptt = (ncq_tag[ncq_tag_count / 5]
-					>> (ncq_tag_count % 5) * 12) & 0xfff;
-
-				slot = &hisi_hba->slot_info[iptt];
-				slot->cmplt_queue_slot = rd_point;
-				slot->cmplt_queue = queue;
-				slot_complete_v3_hw(hisi_hba, slot);
-
-				act_tmp &= ~(1 << ncq_tag_count);
-				ncq_tag_count = ffs(act_tmp);
-			}
-		} else {
-			iptt = (complete_hdr->dw1) & CMPLT_HDR_IPTT_MSK;
-			slot = &hisi_hba->slot_info[iptt];
-			slot->cmplt_queue_slot = rd_point;
-			slot->cmplt_queue = queue;
-			slot_complete_v3_hw(hisi_hba, slot);
-		}
+		iptt = (complete_hdr->dw1) & CMPLT_HDR_IPTT_MSK;
+		slot = &hisi_hba->slot_info[iptt];
+		slot->cmplt_queue_slot = rd_point;
+		slot->cmplt_queue = queue;
+		slot_complete_v3_hw(hisi_hba, slot);
 
 		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
 			rd_point = 0;
-- 
1.9.1
