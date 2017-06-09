From: John Garry <john.garry@huawei.com>
Subject: [PATCH v5 04/23] scsi: hisi_sas: relocate get_ata_protocol()
Date: Fri, 9 Jun 2017 22:16:17 +0800
Message-ID: <1497017796-105067-5-git-send-email-john.garry@huawei.com>
References: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1497017796-105067-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linuxarm@huawei.com, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hch@infradead.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Relocate get_ata_protocol() to a common location, as future
hw versions will require it.
Also rename with "hisi_sas_" prefix for consistency.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  7 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 59 ++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 67 +---------------------------------
 3 files changed, 68 insertions(+), 65 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 68ba7bd..a50c699 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -46,6 +46,12 @@
 	((type == SAS_EDGE_EXPANDER_DEVICE) || \
 	(type == SAS_FANOUT_EXPANDER_DEVICE))
 
+#define HISI_SAS_SATA_PROTOCOL_NONDATA		0x1
+#define HISI_SAS_SATA_PROTOCOL_PIO			0x2
+#define HISI_SAS_SATA_PROTOCOL_DMA			0x4
+#define HISI_SAS_SATA_PROTOCOL_FPDMA		0x8
+#define HISI_SAS_SATA_PROTOCOL_ATAPI		0x10
+
 struct hisi_hba;
 
 enum {
@@ -356,6 +362,7 @@ struct hisi_sas_command_table_ssp {
 	struct hisi_sas_command_table_stp stp;
 };
 
+extern u8 hisi_sas_get_ata_protocol(u8 cmd, int direction);
 extern struct hisi_sas_port *to_hisi_sas_port(struct asd_sas_port *sas_port);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index b247220..08e33e8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -23,6 +23,65 @@ static int hisi_sas_debug_issue_ssp_tmf(struct domain_device *device,
 			     int abort_flag, int tag);
 static int hisi_sas_softreset_ata_disk(struct domain_device *device);
 
+u8 hisi_sas_get_ata_protocol(u8 cmd, int direction)
+{
+	switch (cmd) {
+	case ATA_CMD_FPDMA_WRITE:
+	case ATA_CMD_FPDMA_READ:
+	case ATA_CMD_FPDMA_RECV:
+	case ATA_CMD_FPDMA_SEND:
+	case ATA_CMD_NCQ_NON_DATA:
+	return HISI_SAS_SATA_PROTOCOL_FPDMA;
+
+	case ATA_CMD_DOWNLOAD_MICRO:
+	case ATA_CMD_ID_ATA:
+	case ATA_CMD_PMP_READ:
+	case ATA_CMD_READ_LOG_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_PMP_WRITE:
+	case ATA_CMD_WRITE_LOG_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	return HISI_SAS_SATA_PROTOCOL_PIO;
+
+	case ATA_CMD_DSM:
+	case ATA_CMD_DOWNLOAD_MICRO_DMA:
+	case ATA_CMD_PMP_READ_DMA:
+	case ATA_CMD_PMP_WRITE_DMA:
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_READ_LOG_DMA_EXT:
+	case ATA_CMD_READ_STREAM_DMA_EXT:
+	case ATA_CMD_TRUSTED_RCV_DMA:
+	case ATA_CMD_TRUSTED_SND_DMA:
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_FUA_EXT:
+	case ATA_CMD_WRITE_QUEUED:
+	case ATA_CMD_WRITE_LOG_DMA_EXT:
+	case ATA_CMD_WRITE_STREAM_DMA_EXT:
+	return HISI_SAS_SATA_PROTOCOL_DMA;
+
+	case ATA_CMD_CHK_POWER:
+	case ATA_CMD_DEV_RESET:
+	case ATA_CMD_EDD:
+	case ATA_CMD_FLUSH:
+	case ATA_CMD_FLUSH_EXT:
+	case ATA_CMD_VERIFY:
+	case ATA_CMD_VERIFY_EXT:
+	case ATA_CMD_SET_FEATURES:
+	case ATA_CMD_STANDBY:
+	case ATA_CMD_STANDBYNOW1:
+	return HISI_SAS_SATA_PROTOCOL_NONDATA;
+	default:
+		if (direction == DMA_NONE)
+			return HISI_SAS_SATA_PROTOCOL_NONDATA;
+		return HISI_SAS_SATA_PROTOCOL_PIO;
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_sas_get_ata_protocol);
+
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
 	return device->port->ha->lldd_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 2607aac..d9314c4 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -554,12 +554,6 @@ enum {
 #define DIR_TO_DEVICE 2
 #define DIR_RESERVED 3
 
-#define SATA_PROTOCOL_NONDATA		0x1
-#define SATA_PROTOCOL_PIO		0x2
-#define SATA_PROTOCOL_DMA		0x4
-#define SATA_PROTOCOL_FPDMA		0x8
-#define SATA_PROTOCOL_ATAPI		0x10
-
 #define ERR_ON_TX_PHASE(err_phase) (err_phase == 0x2 || \
 		err_phase == 0x4 || err_phase == 0x8 ||\
 		err_phase == 0x6 || err_phase == 0xa)
@@ -2352,64 +2346,6 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 	return sts;
 }
 
-static u8 get_ata_protocol(u8 cmd, int direction)
-{
-	switch (cmd) {
-	case ATA_CMD_FPDMA_WRITE:
-	case ATA_CMD_FPDMA_READ:
-	case ATA_CMD_FPDMA_RECV:
-	case ATA_CMD_FPDMA_SEND:
-	case ATA_CMD_NCQ_NON_DATA:
-	return SATA_PROTOCOL_FPDMA;
-
-	case ATA_CMD_DOWNLOAD_MICRO:
-	case ATA_CMD_ID_ATA:
-	case ATA_CMD_PMP_READ:
-	case ATA_CMD_READ_LOG_EXT:
-	case ATA_CMD_PIO_READ:
-	case ATA_CMD_PIO_READ_EXT:
-	case ATA_CMD_PMP_WRITE:
-	case ATA_CMD_WRITE_LOG_EXT:
-	case ATA_CMD_PIO_WRITE:
-	case ATA_CMD_PIO_WRITE_EXT:
-	return SATA_PROTOCOL_PIO;
-
-	case ATA_CMD_DSM:
-	case ATA_CMD_DOWNLOAD_MICRO_DMA:
-	case ATA_CMD_PMP_READ_DMA:
-	case ATA_CMD_PMP_WRITE_DMA:
-	case ATA_CMD_READ:
-	case ATA_CMD_READ_EXT:
-	case ATA_CMD_READ_LOG_DMA_EXT:
-	case ATA_CMD_READ_STREAM_DMA_EXT:
-	case ATA_CMD_TRUSTED_RCV_DMA:
-	case ATA_CMD_TRUSTED_SND_DMA:
-	case ATA_CMD_WRITE:
-	case ATA_CMD_WRITE_EXT:
-	case ATA_CMD_WRITE_FUA_EXT:
-	case ATA_CMD_WRITE_QUEUED:
-	case ATA_CMD_WRITE_LOG_DMA_EXT:
-	case ATA_CMD_WRITE_STREAM_DMA_EXT:
-	return SATA_PROTOCOL_DMA;
-
-	case ATA_CMD_CHK_POWER:
-	case ATA_CMD_DEV_RESET:
-	case ATA_CMD_EDD:
-	case ATA_CMD_FLUSH:
-	case ATA_CMD_FLUSH_EXT:
-	case ATA_CMD_VERIFY:
-	case ATA_CMD_VERIFY_EXT:
-	case ATA_CMD_SET_FEATURES:
-	case ATA_CMD_STANDBY:
-	case ATA_CMD_STANDBYNOW1:
-	return SATA_PROTOCOL_NONDATA;
-	default:
-		if (direction == DMA_NONE)
-			return SATA_PROTOCOL_NONDATA;
-		return SATA_PROTOCOL_PIO;
-	}
-}
-
 static int get_ncq_tag_v2_hw(struct sas_task *task, u32 *tag)
 {
 	struct ata_queued_cmd *qc = task->uldd_task;
@@ -2464,7 +2400,8 @@ static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
 			(task->ata_task.fis.control & ATA_SRST))
 		dw1 |= 1 << CMD_HDR_RESET_OFF;
 
-	dw1 |= (get_ata_protocol(task->ata_task.fis.command, task->data_dir))
+	dw1 |= (hisi_sas_get_ata_protocol(
+		task->ata_task.fis.command, task->data_dir))
 		<< CMD_HDR_FRAME_TYPE_OFF;
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
 	hdr->dw1 = cpu_to_le32(dw1);
-- 
1.9.1
