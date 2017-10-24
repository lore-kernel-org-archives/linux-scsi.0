From: John Garry <john.garry@huawei.com>
Subject: [PATCH 01/19] scsi: hisi_sas: delete get_ncq_tag_v3_hw()
Date: Tue, 24 Oct 2017 23:51:31 +0800
Message-ID: <1508860309-212397-2-git-send-email-john.garry@huawei.com>
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

We already relocated hisi_sas_get_ncq_tag() into common
file main.c, so delete get_ncq_tag_v3_hw() and use
hisi_sas_get_ncq_tag() instead.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 2e5fa97..d60501f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -988,20 +988,6 @@ static int prep_smp_v3_hw(struct hisi_hba *hisi_hba,
 	return rc;
 }
 
-static int get_ncq_tag_v3_hw(struct sas_task *task, u32 *tag)
-{
-	struct ata_queued_cmd *qc = task->uldd_task;
-
-	if (qc) {
-		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
-			qc->tf.command == ATA_CMD_FPDMA_READ) {
-			*tag = qc->tag;
-			return 1;
-		}
-	}
-	return 0;
-}
-
 static int prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_slot *slot)
 {
@@ -1050,7 +1036,7 @@ static int prep_ata_v3_hw(struct hisi_hba *hisi_hba,
 	hdr->dw1 = cpu_to_le32(dw1);
 
 	/* dw2 */
-	if (task->ata_task.use_ncq && get_ncq_tag_v3_hw(task, &hdr_tag)) {
+	if (task->ata_task.use_ncq && hisi_sas_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		dw2 |= hdr_tag << CMD_HDR_NCQ_TAG_OFF;
 	}
-- 
1.9.1
