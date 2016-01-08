From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 20/23] hisi_sas: add v2 path to send ATA command
Date: Fri, 8 Jan 2016 22:15:39 +0800
Message-ID: <1452262542-64589-21-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: JBottomley-wo1vFcy6AUs@public.gmane.org, martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   4 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |   8 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 160 +++++++++++++++++++++++++++++++++
 3 files changed, 172 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index b2e4b26..f00b55b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -18,6 +18,7 @@
 #include <linux/of_address.h>
 #include <linux/platform_device.h>
 #include <linux/regmap.h>
+#include <scsi/sas_ata.h>
 #include <scsi/libsas.h>
 
 #define DRV_VERSION "v1.0"
@@ -35,6 +36,7 @@
 
 #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
 #define HISI_SAS_MAX_SMP_RESP_SZ 1028
+#define HISI_SAS_MAX_STP_RESP_SZ 28
 
 #define DEV_IS_EXPANDER(type) \
 	((type == SAS_EDGE_EXPANDER_DEVICE) || \
@@ -135,6 +137,8 @@ struct hisi_sas_hw {
 			struct hisi_sas_tmf_task *tmf);
 	int (*prep_smp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot);
+	int (*prep_stp)(struct hisi_hba *hisi_hba,
+			struct hisi_sas_slot *slot);
 	int (*slot_complete)(struct hisi_hba *hisi_hba,
 			     struct hisi_sas_slot *slot, int abort);
 	void (*phy_enable)(struct hisi_hba *hisi_hba, int phy_no);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index c48df6d..406b515 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -107,6 +107,12 @@ static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
 	return hisi_hba->hw->prep_ssp(hisi_hba, slot, is_tmf, tmf);
 }
 
+static int hisi_sas_task_prep_ata(struct hisi_hba *hisi_hba,
+				  struct hisi_sas_slot *slot)
+{
+	return hisi_hba->hw->prep_stp(hisi_hba, slot);
+}
+
 static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 			      int is_tmf, struct hisi_sas_tmf_task *tmf,
 			      int *pass)
@@ -230,6 +236,8 @@ static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
 	case SAS_PROTOCOL_SATA:
 	case SAS_PROTOCOL_STP:
 	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+		rc = hisi_sas_task_prep_ata(hisi_hba, slot);
+		break;
 	default:
 		dev_err(dev, "task prep: unknown/unsupported proto (0x%x)\n",
 			task->task_proto);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index eca505f..1c5be50 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -269,6 +269,12 @@ enum {
 #define DIR_TO_DEVICE 2
 #define DIR_RESERVED 3
 
+#define SATA_PROTOCOL_NONDATA		0x1
+#define SATA_PROTOCOL_PIO		0x2
+#define SATA_PROTOCOL_DMA		0x4
+#define SATA_PROTOCOL_FPDMA		0x8
+#define SATA_PROTOCOL_ATAPI		0x10
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -992,6 +998,19 @@ static int prep_ssp_v2_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+static void sata_done_v2_hw(struct hisi_hba *hisi_hba, struct sas_task *task,
+			    struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct ata_task_resp *resp = (struct ata_task_resp *)ts->buf;
+	struct dev_to_host_fis *d2h = slot->status_buffer +
+				      sizeof(struct hisi_sas_err_record);
+
+	resp->frame_len = sizeof(struct dev_to_host_fis);
+	memcpy(&resp->ending_fis[0], d2h, sizeof(struct dev_to_host_fis));
+
+	ts->buf_valid_size = sizeof(*resp);
+}
 static int
 slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 		    int abort)
@@ -1098,6 +1117,146 @@ out:
 	return sts;
 }
 
+static u8 get_ata_protocol(u8 cmd, int direction)
+{
+	switch (cmd) {
+	case ATA_CMD_FPDMA_WRITE:
+	case ATA_CMD_FPDMA_READ:
+	return SATA_PROTOCOL_FPDMA;
+
+	case ATA_CMD_ID_ATA:
+	case ATA_CMD_PMP_READ:
+	case ATA_CMD_READ_LOG_EXT:
+	case ATA_CMD_PIO_READ:
+	case ATA_CMD_PIO_READ_EXT:
+	case ATA_CMD_PMP_WRITE:
+	case ATA_CMD_WRITE_LOG_EXT:
+	case ATA_CMD_PIO_WRITE:
+	case ATA_CMD_PIO_WRITE_EXT:
+	return SATA_PROTOCOL_PIO;
+
+	case ATA_CMD_READ:
+	case ATA_CMD_READ_EXT:
+	case ATA_CMD_READ_LOG_DMA_EXT:
+	case ATA_CMD_WRITE:
+	case ATA_CMD_WRITE_EXT:
+	case ATA_CMD_WRITE_QUEUED:
+	case ATA_CMD_WRITE_LOG_DMA_EXT:
+	return SATA_PROTOCOL_DMA;
+
+	case ATA_CMD_DOWNLOAD_MICRO:
+	case ATA_CMD_DEV_RESET:
+	case ATA_CMD_CHK_POWER:
+	case ATA_CMD_FLUSH:
+	case ATA_CMD_FLUSH_EXT:
+	case ATA_CMD_VERIFY:
+	case ATA_CMD_VERIFY_EXT:
+	case ATA_CMD_SET_FEATURES:
+	case ATA_CMD_STANDBY:
+	case ATA_CMD_STANDBYNOW1:
+	return SATA_PROTOCOL_NONDATA;
+	default:
+		if (direction == DMA_NONE)
+			return SATA_PROTOCOL_NONDATA;
+		return SATA_PROTOCOL_PIO;
+	}
+}
+
+static int get_ncq_tag_v2_hw(struct sas_task *task, u32 *tag)
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
+
+static int prep_ata_v2_hw(struct hisi_hba *hisi_hba,
+		struct hisi_sas_slot *slot)
+{
+	struct sas_task *task = slot->task;
+	struct domain_device *device = task->dev;
+	struct domain_device *parent_dev = device->parent;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
+	struct asd_sas_port *sas_port = device->port;
+	u8 *buf_cmd;
+	int has_data = 0, rc = 0, hdr_tag = 0;
+	u32 dw1 = 0, dw2 = 0;
+
+	/* create header */
+	/* dw0 */
+	hdr->dw0 = cpu_to_le32(sas_port->id << CMD_HDR_PORT_OFF);
+	if (parent_dev && DEV_IS_EXPANDER(parent_dev->dev_type))
+		hdr->dw0 |= cpu_to_le32(3 << CMD_HDR_CMD_OFF);
+	else
+		hdr->dw0 |= cpu_to_le32(4 << CMD_HDR_CMD_OFF);
+
+	/* dw1 */
+	switch (task->data_dir) {
+	case DMA_TO_DEVICE:
+		has_data = 1;
+		dw1 |= DIR_TO_DEVICE << CMD_HDR_DIR_OFF;
+		break;
+	case DMA_FROM_DEVICE:
+		has_data = 1;
+		dw1 |= DIR_TO_INI << CMD_HDR_DIR_OFF;
+		break;
+	default:
+		dw1 &= ~CMD_HDR_DIR_MSK;
+	}
+
+	if (0 == task->ata_task.fis.command)
+		dw1 |= 1 << CMD_HDR_RESET_OFF;
+
+	dw1 |= (get_ata_protocol(task->ata_task.fis.command, task->data_dir))
+		<< CMD_HDR_FRAME_TYPE_OFF;
+	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
+	hdr->dw1 = cpu_to_le32(dw1);
+
+	/* dw2 */
+	if (task->ata_task.use_ncq && get_ncq_tag_v2_hw(task, &hdr_tag)) {
+		task->ata_task.fis.sector_count |= (u8) (hdr_tag << 3);
+		dw2 |= hdr_tag << CMD_HDR_NCQ_TAG_OFF;
+	}
+
+	dw2 |= (HISI_SAS_MAX_STP_RESP_SZ / 4) << CMD_HDR_CFL_OFF |
+			2 << CMD_HDR_SG_MOD_OFF;
+	hdr->dw2 = cpu_to_le32(dw2);
+
+	/* dw3 */
+	hdr->transfer_tags = cpu_to_le32(slot->idx);
+
+	if (has_data) {
+		rc = prep_prd_sge_v2_hw(hisi_hba, slot, hdr, task->scatter,
+					slot->n_elem);
+		if (rc)
+			return rc;
+	}
+
+
+	hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len);
+	hdr->cmd_table_addr = cpu_to_le64(slot->command_table_dma);
+	hdr->sts_buffer_addr = cpu_to_le64(slot->status_buffer_dma);
+
+	buf_cmd = slot->command_table;
+
+	if (likely(!task->ata_task.device_control_reg_update))
+		task->ata_task.fis.flags |= 0x80; /* C=1: update ATA cmd reg */
+	/* fill in command FIS and ATAPI CDB */
+	memcpy(buf_cmd, &task->ata_task.fis, sizeof(struct host_to_dev_fis));
+	if (device->sata_dev.class == ATA_DEV_ATAPI)
+		memcpy(buf_cmd + 0x20, task->ata_task.atapi_packet,
+		       ATAPI_CDB_LEN);
+
+	return 0;
+}
+
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -1562,6 +1721,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.free_device = free_device_v2_hw,
 	.prep_smp = prep_smp_v2_hw,
 	.prep_ssp = prep_ssp_v2_hw,
+	.prep_stp = prep_ata_v2_hw,
 	.get_free_slot = get_free_slot_v2_hw,
 	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
