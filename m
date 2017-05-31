From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 15/23] scsi: hisi_sas: add v3 code to send SSP frame
Date: Wed, 31 May 2017 22:33:07 +0800
Message-ID: <1496241195-217678-16-git-send-email-john.garry@huawei.com>
References: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1496241195-217678-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add code to prepare SSP frame and deliver it to hardware.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 208 +++++++++++++++++++++++++++++++++
 1 file changed, 208 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 4259047..7be3a53 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -157,6 +157,41 @@
 #define SL_RX_BCAST_CHK_MSK		(PORT_BASE + 0x2c0)
 #define PHYCTRL_OOB_RESTART_MSK		(PORT_BASE + 0x2c4)
 
+/* HW dma structures */
+/* Delivery queue header */
+/* dw0 */
+#define CMD_HDR_RESP_REPORT_OFF		5
+#define CMD_HDR_RESP_REPORT_MSK		(0x1 << CMD_HDR_RESP_REPORT_OFF)
+#define CMD_HDR_TLR_CTRL_OFF		6
+#define CMD_HDR_TLR_CTRL_MSK		(0x3 << CMD_HDR_TLR_CTRL_OFF)
+#define CMD_HDR_PORT_OFF		18
+#define CMD_HDR_PORT_MSK		(0xf << CMD_HDR_PORT_OFF)
+#define CMD_HDR_PRIORITY_OFF		27
+#define CMD_HDR_PRIORITY_MSK		(0x1 << CMD_HDR_PRIORITY_OFF)
+#define CMD_HDR_CMD_OFF			29
+#define CMD_HDR_CMD_MSK			(0x7 << CMD_HDR_CMD_OFF)
+/* dw1 */
+#define CMD_HDR_DIR_OFF			5
+#define CMD_HDR_DIR_MSK			(0x3 << CMD_HDR_DIR_OFF)
+#define CMD_HDR_VDTL_OFF		10
+#define CMD_HDR_VDTL_MSK		(0x1 << CMD_HDR_VDTL_OFF)
+#define CMD_HDR_FRAME_TYPE_OFF		11
+#define CMD_HDR_FRAME_TYPE_MSK		(0x1f << CMD_HDR_FRAME_TYPE_OFF)
+#define CMD_HDR_DEV_ID_OFF		16
+#define CMD_HDR_DEV_ID_MSK		(0xffff << CMD_HDR_DEV_ID_OFF)
+/* dw2 */
+#define CMD_HDR_CFL_OFF			0
+#define CMD_HDR_CFL_MSK			(0x1ff << CMD_HDR_CFL_OFF)
+#define CMD_HDR_MRFL_OFF		15
+#define CMD_HDR_MRFL_MSK		(0x1ff << CMD_HDR_MRFL_OFF)
+#define CMD_HDR_SG_MOD_OFF		24
+#define CMD_HDR_SG_MOD_MSK		(0x3 << CMD_HDR_SG_MOD_OFF)
+/* dw6 */
+#define CMD_HDR_DIF_SGL_LEN_OFF		0
+#define CMD_HDR_DIF_SGL_LEN_MSK		(0xffff << CMD_HDR_DIF_SGL_LEN_OFF)
+#define CMD_HDR_DATA_SGL_LEN_OFF	16
+#define CMD_HDR_DATA_SGL_LEN_MSK	(0xffff << CMD_HDR_DATA_SGL_LEN_OFF)
+
 /* Completion header */
 /* dw0 */
 #define CMPLT_HDR_CMPLT_OFF		0
@@ -201,6 +236,11 @@ enum {
 	HISI_SAS_PHY_INT_NR
 };
 
+#define DIR_NO_DATA 0
+#define DIR_TO_INI 1
+#define DIR_TO_DEVICE 2
+#define DIR_RESERVED 3
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -208,6 +248,13 @@ static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
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
@@ -432,6 +479,163 @@ static void sl_notify_v3_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+/**
+ * The callpath to this function and upto writing the write
+ * queue pointer should be safe from interruption.
+ */
+static int
+get_free_slot_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_dq *dq)
+{
+	struct device *dev = hisi_hba->dev;
+	int queue = dq->id;
+	u32 r, w;
+
+	w = dq->wr_point;
+	r = hisi_sas_read32_relaxed(hisi_hba,
+				DLVRY_Q_0_RD_PTR + (queue * 0x14));
+	if (r == (w+1) % HISI_SAS_QUEUE_SLOTS) {
+		dev_warn(dev, "full queue=%d r=%d w=%d\n\n",
+				queue, r, w);
+		return -EAGAIN;
+	}
+
+	return 0;
+}
+
+static void start_delivery_v3_hw(struct hisi_sas_dq *dq)
+{
+	struct hisi_hba *hisi_hba = dq->hisi_hba;
+	int dlvry_queue = dq->slot_prep->dlvry_queue;
+	int dlvry_queue_slot = dq->slot_prep->dlvry_queue_slot;
+
+	dq->wr_point = ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS;
+	hisi_sas_write32(hisi_hba, DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
+			 dq->wr_point);
+}
+
+static int prep_prd_sge_v3_hw(struct hisi_hba *hisi_hba,
+			      struct hisi_sas_slot *slot,
+			      struct hisi_sas_cmd_hdr *hdr,
+			      struct scatterlist *scatter,
+			      int n_elem)
+{
+	struct device *dev = hisi_hba->dev;
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
+	hdr->sg_len = cpu_to_le32(n_elem << CMD_HDR_DATA_SGL_LEN_OFF);
+
+	return 0;
+}
+
+static int prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
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
+	hdr->transfer_tags = cpu_to_le32(slot->idx);
+
+	if (has_data) {
+		rc = prep_prd_sge_v3_hw(hisi_hba, slot, hdr, task->scatter,
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
+	memcpy(buf_cmd, ssp_task->LUN, 8);
+
+	if (!is_tmf) {
+		buf_cmd[9] = ssp_task->task_attr | (ssp_task->task_prio << 3);
+		memcpy(buf_cmd + 12, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
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
 static int phy_up_v3_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -1025,6 +1229,10 @@ static int hisi_sas_v3_init(struct hisi_hba *hisi_hba)
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V3_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v3_hdr),
 	.sl_notify = sl_notify_v3_hw,
+	.prep_ssp = prep_ssp_v3_hw,
+	.get_free_slot = get_free_slot_v3_hw,
+	.start_delivery = start_delivery_v3_hw,
+	.slot_complete = slot_complete_v3_hw,
 	.phys_init = phys_init_v3_hw,
 };
 
-- 
1.9.1
