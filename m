From: John Garry <john.garry@huawei.com>
Subject: [PATCH 17/23] hisi_sas: add v2 path to send ssp frame
Date: Fri, 8 Jan 2016 22:15:36 +0800
Message-ID: <1452262542-64589-18-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Include code to prep ssp frame and deliver
to hardware.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 185 +++++++++++++++++++++++++++++++++
 1 file changed, 185 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 0beb6a9..e9d3db9 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -264,6 +264,11 @@ enum {
 
 #define HISI_SAS_COMMAND_ENTRIES_V2_HW 4096
 
+#define DIR_NO_DATA 0
+#define DIR_TO_INI 1
+#define DIR_TO_DEVICE 2
+#define DIR_RESERVED 3
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -271,6 +276,13 @@ static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 	return readl(regs);
 }
 
+static u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl_relaxed(regs);
+}
+
 static void hisi_sas_write32(struct hisi_hba *hisi_hba, u32 off, u32 val)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -651,6 +663,176 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 	return bitmap;
 }
 
+/**
+ * This function allocates across all queues to load balance.
+ * Slots are allocated from queues in a round-robin fashion.
+ *
+ * The callpath to this function and upto writing the write
+ * queue pointer should be safe from interruption.
+ */
+static int get_free_slot_v2_hw(struct hisi_hba *hisi_hba, int *q, int *s)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 r, w;
+	int queue = hisi_hba->queue;
+
+	while (1) {
+		w = hisi_sas_read32_relaxed(hisi_hba,
+					    DLVRY_Q_0_WR_PTR + (queue * 0x14));
+		r = hisi_sas_read32_relaxed(hisi_hba,
+					    DLVRY_Q_0_RD_PTR + (queue * 0x14));
+		if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
+			queue = (queue + 1) % hisi_hba->queue_count;
+			if (queue == hisi_hba->queue) {
+				dev_warn(dev, "could not find free slot\n");
+				return -EAGAIN;
+			}
+			continue;
+		}
+		break;
+	}
+	hisi_hba->queue = (queue + 1) % hisi_hba->queue_count;
+	*q = queue;
+	*s = w;
+	return 0;
+}
+
+static void start_delivery_v2_hw(struct hisi_hba *hisi_hba)
+{
+	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
+	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
+
+	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
+			 ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS);
+}
+
+static int prep_prd_sge_v2_hw(struct hisi_hba *hisi_hba,
+			      struct hisi_sas_slot *slot,
+			      struct hisi_sas_cmd_hdr *hdr,
+			      struct scatterlist *scatter,
+			      int n_elem)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct scatterlist *sg;
+	int i;
+
+	if (n_elem > HISI_SAS_SGE_PAGE_CNT) {
+		dev_err(dev, "prd err: n_elem(%d) > HISI_SAS_SGE_PAGE_CNT",
+			n_elem);
+		return -EINVAL;
+	}
+
+	slot->sge_page = dma_pool_alloc(hisi_hba->sge_page_pool, GFP_ATOMIC,
+					&slot->sge_page_dma);
+	if (!slot->sge_page)
+		return -ENOMEM;
+
+	for_each_sg(scatter, sg, n_elem, i) {
+		struct hisi_sas_sge *entry = &slot->sge_page->sge[i];
+
+		entry->addr = cpu_to_le64(sg_dma_address(sg));
+		entry->page_ctrl_0 = entry->page_ctrl_1 = 0;
+		entry->data_len = cpu_to_le32(sg_dma_len(sg));
+		entry->data_off = 0;
+	}
+
+	hdr->prd_table_addr = cpu_to_le64(slot->sge_page_dma);
+
+	hdr->sg_len = cpu_to_le32(n_elem << CMD_HDR_DATA_SGL_LEN_OFF);
+
+	return 0;
+}
+
+static int prep_ssp_v2_hw(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_slot *slot, int is_tmf,
+			  struct hisi_sas_tmf_task *tmf)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_cmd_hdr *hdr = slot->cmd_hdr;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_port *port = slot->port;
+	struct sas_ssp_task *ssp_task = &task->ssp_task;
+	struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
+	int has_data = 0, rc, priority = is_tmf;
+	u8 *buf_cmd;
+	u32 dw1 = 0, dw2 = 0;
+
+	hdr->dw0 = cpu_to_le32((1 << CMD_HDR_RESP_REPORT_OFF) |
+			       (2 << CMD_HDR_TLR_CTRL_OFF) |
+			       (port->id << CMD_HDR_PORT_OFF) |
+			       (priority << CMD_HDR_PRIORITY_OFF) |
+			       (1 << CMD_HDR_CMD_OFF)); /* ssp */
+
+	dw1 = 1 << CMD_HDR_VDTL_OFF;
+	if (is_tmf) {
+		dw1 |= 2 << CMD_HDR_FRAME_TYPE_OFF;
+		dw1 |= DIR_NO_DATA << CMD_HDR_DIR_OFF;
+	} else {
+		dw1 |= 1 << CMD_HDR_FRAME_TYPE_OFF;
+		switch (scsi_cmnd->sc_data_direction) {
+		case DMA_TO_DEVICE:
+			has_data = 1;
+			dw1 |= DIR_TO_DEVICE << CMD_HDR_DIR_OFF;
+			break;
+		case DMA_FROM_DEVICE:
+			has_data = 1;
+			dw1 |= DIR_TO_INI << CMD_HDR_DIR_OFF;
+			break;
+		default:
+			dw1 &= ~CMD_HDR_DIR_MSK;
+		}
+	}
+
+	/* map itct entry */
+	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
+	hdr->dw1 = cpu_to_le32(dw1);
+
+	dw2 = (((sizeof(struct ssp_command_iu) + sizeof(struct ssp_frame_hdr)
+	      + 3) / 4) << CMD_HDR_CFL_OFF) |
+	      ((HISI_SAS_MAX_SSP_RESP_SZ / 4) << CMD_HDR_MRFL_OFF) |
+	      (2 << CMD_HDR_SG_MOD_OFF);
+	hdr->dw2 = cpu_to_le32(dw2);
+
+	hdr->transfer_tags = cpu_to_le32(slot->idx);
+
+	if (has_data) {
+		rc = prep_prd_sge_v2_hw(hisi_hba, slot, hdr, task->scatter,
+					slot->n_elem);
+		if (rc)
+			return rc;
+	}
+
+	hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len);
+	hdr->cmd_table_addr = cpu_to_le64(slot->command_table_dma);
+	hdr->sts_buffer_addr = cpu_to_le64(slot->status_buffer_dma);
+
+	buf_cmd = slot->command_table + sizeof(struct ssp_frame_hdr);
+
+	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
+	if (!is_tmf) {
+		buf_cmd[9] = task->ssp_task.task_attr |
+				(task->ssp_task.task_prio << 3);
+		memcpy(buf_cmd + 12, task->ssp_task.cmd->cmnd,
+				task->ssp_task.cmd->cmd_len);
+	} else {
+		buf_cmd[10] = tmf->tmf;
+		switch (tmf->tmf) {
+		case TMF_ABORT_TASK:
+		case TMF_QUERY_TASK:
+			buf_cmd[12] =
+				(tmf->tag_of_task_to_be_managed >> 8) & 0xff;
+			buf_cmd[13] =
+				tmf->tag_of_task_to_be_managed & 0xff;
+			break;
+		default:
+			break;
+		}
+	}
+
+	return 0;
+}
+
 static int
 slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
 		    int abort)
@@ -1217,6 +1399,9 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.prep_ssp = prep_ssp_v2_hw,
+	.get_free_slot = get_free_slot_v2_hw,
+	.start_delivery = start_delivery_v2_hw,
 	.slot_complete = slot_complete_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
-- 
1.9.1
