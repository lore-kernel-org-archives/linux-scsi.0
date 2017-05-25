From: John Garry <john.garry@huawei.com>
Subject: [PATCH v2 05/22] scsi: hisi_sas: relocate get_ncq_tag_v2_hw()
Date: Thu, 25 May 2017 20:04:54 +0800
Message-ID: <1495713911-80476-6-git-send-email-john.garry@huawei.com>
References: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495713911-80476-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Relocate get_ncq_tag_v2_hw() to a common location, as
future hw versions will require it.
Also rename with "hisi_sas_" prefix for consistency.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 15 +++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 16 +---------------
 3 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index d0c0844..210daec 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -359,6 +359,7 @@ struct hisi_sas_command_table_ssp {
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
+extern int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3f2bb8e..aaa7f5d 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -103,6 +103,21 @@ void hisi_sas_sata_done(struct sas_task *task,
 }
 EXPORT_SYMBOL_GPL(hisi_sas_sata_done);
 
+int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag)
+{
+	struct ata_queued_cmd *qc = task->uldd_task;
+
+	if (qc) {
+		if (qc->tf.command == ATA_CMD_FPDMA_WRITE ||
+			qc->tf.command == ATA_CMD_FPDMA_READ) {
+			*tag = qc->tag;
+			return 1;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_get_ncq_tag);
+
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
 	return device->port->ha->lldd_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 51140dc..e64047c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -2328,20 +2328,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	return sts;
 }
 
-static int get_ncq_tag_v2_hw(struct sas_task *task, u32 *tag)
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
 static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 			  struct hisi_sas_slot *slot)
 {
@@ -2389,7 +2375,7 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 	hdr->dw1 = cpu_to_le32(dw1);
 
 	/* dw2 */
-	if (task->ata_task.use_ncq && get_ncq_tag_v2_hw(task, &hdr_tag)) {
+	if (task->ata_task.use_ncq && hisi_sas_get_ncq_tag(task, &hdr_tag)) {
 		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
 		dw2 |= hdr_tag << CMD_HDR_NCQ_TAG_OFF;
 	}
-- 
1.9.1
