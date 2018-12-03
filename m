From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 4/4] scsi: hisi_sas: Add support for DIF feature for v3 hw
Date: Mon, 3 Dec 2018 20:09:54 +0800
Message-ID: <1543838994-30028-5-git-send-email-john.garry@huawei.com>
References: <1543838994-30028-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543838994-30028-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

For v3 hw, we support DIF operation for SAS, but not SATA.

In addition, DIF CRC16 is supported.

This patchset adds the SW support for the described features. The main
components are as follows:
- Allocate memory for PI
- Fill PI fields
- Fill related to DIF in DQ and protection iu memories

DIX support seems to have some issue when enabled with SCSI MQ, so we'll
omit support for now. This was discusse here:
https://marc.info/?l=linux-scsi&m=154357719329297&w=2

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  18 ++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  99 ++++++++++++++---
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 187 +++++++++++++++++++++++++++++++--
 3 files changed, 286 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 912d234..6389b86 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -55,6 +55,11 @@
 #define hisi_sas_sge_addr_mem(slot) hisi_sas_sge_addr(slot->buf)
 #define hisi_sas_sge_addr_dma(slot) hisi_sas_sge_addr(slot->buf_dma)
 
+#define hisi_sas_sge_dif_addr(buf) \
+	(buf + offsetof(struct hisi_sas_slot_dif_buf_table, sge_dif_page))
+#define hisi_sas_sge_dif_addr_mem(slot) hisi_sas_sge_dif_addr(slot->buf)
+#define hisi_sas_sge_dif_addr_dma(slot) hisi_sas_sge_dif_addr(slot->buf_dma)
+
 #define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
 #define HISI_SAS_MAX_SMP_RESP_SZ 1028
 #define HISI_SAS_MAX_STP_RESP_SZ 28
@@ -197,6 +202,7 @@ struct hisi_sas_slot {
 	struct sas_task *task;
 	struct hisi_sas_port	*port;
 	u64	n_elem;
+	u64	n_elem_dif;
 	int	dlvry_queue;
 	int	dlvry_queue_slot;
 	int	cmplt_queue;
@@ -268,6 +274,8 @@ struct hisi_hba {
 	struct pci_dev *pci_dev;
 	struct device *dev;
 
+	bool enable_dif;
+
 	void __iomem *regs;
 	void __iomem *sgpio_regs;
 	struct regmap *ctrl;
@@ -422,6 +430,11 @@ struct hisi_sas_sge_page {
 	struct hisi_sas_sge sge[HISI_SAS_SGE_PAGE_CNT];
 }  __aligned(16);
 
+#define HISI_SAS_SGE_DIF_PAGE_CNT   SG_CHUNK_SIZE
+struct hisi_sas_sge_dif_page {
+	struct hisi_sas_sge sge[HISI_SAS_SGE_DIF_PAGE_CNT];
+}  __aligned(16);
+
 struct hisi_sas_command_table_ssp {
 	struct ssp_frame_hdr hdr;
 	union {
@@ -452,6 +465,11 @@ struct hisi_sas_slot_buf_table {
 	struct hisi_sas_sge_page sge_page;
 };
 
+struct hisi_sas_slot_dif_buf_table {
+	struct hisi_sas_slot_buf_table slot_buf;
+	struct hisi_sas_sge_dif_page sge_dif_page;
+};
+
 extern struct scsi_transport_template *hisi_sas_stt;
 extern void hisi_sas_stop_phys(struct hisi_hba *hisi_hba);
 extern int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index eed7fc5..146fce3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -252,14 +252,21 @@ void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
 
 		task->lldd_task = NULL;
 
-		if (!sas_protocol_ata(task->task_proto))
+		if (!sas_protocol_ata(task->task_proto)) {
+			struct sas_ssp_task *ssp_task = &task->ssp_task;
+			struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
+
 			if (slot->n_elem)
 				dma_unmap_sg(dev, task->scatter,
 					     task->num_scatter,
 					     task->data_dir);
+			if (slot->n_elem_dif)
+				dma_unmap_sg(dev, scsi_prot_sglist(scsi_cmnd),
+					     scsi_prot_sg_count(scsi_cmnd),
+					     task->data_dir);
+		}
 	}
 
-
 	spin_lock_irqsave(&dq->lock, flags);
 	list_del_init(&slot->entry);
 	spin_unlock_irqrestore(&dq->lock, flags);
@@ -380,6 +387,59 @@ static int hisi_sas_dma_map(struct hisi_hba *hisi_hba,
 	return rc;
 }
 
+static void hisi_sas_dif_dma_unmap(struct hisi_hba *hisi_hba,
+				   struct sas_task *task, int n_elem_dif)
+{
+	struct device *dev = hisi_hba->dev;
+
+	if (n_elem_dif) {
+		struct sas_ssp_task *ssp_task = &task->ssp_task;
+		struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
+
+		dma_unmap_sg(dev, scsi_prot_sglist(scsi_cmnd),
+			     scsi_prot_sg_count(scsi_cmnd),
+			     task->data_dir);
+	}
+}
+
+static int hisi_sas_dif_dma_map(struct hisi_hba *hisi_hba,
+				int *n_elem_dif, struct sas_task *task)
+{
+	struct device *dev = hisi_hba->dev;
+	struct sas_ssp_task *ssp_task;
+	struct scsi_cmnd *scsi_cmnd;
+	int rc;
+
+	if (task->num_scatter) {
+		ssp_task = &task->ssp_task;
+		scsi_cmnd = ssp_task->cmd;
+
+		if (scsi_prot_sg_count(scsi_cmnd)) {
+			*n_elem_dif = dma_map_sg(dev,
+						 scsi_prot_sglist(scsi_cmnd),
+						 scsi_prot_sg_count(scsi_cmnd),
+						 task->data_dir);
+
+			if (!*n_elem_dif)
+				return -ENOMEM;
+
+			if (*n_elem_dif > HISI_SAS_SGE_DIF_PAGE_CNT) {
+				dev_err(dev, "task prep: n_elem_dif(%d) too large\n",
+					*n_elem_dif);
+				rc = -EINVAL;
+				goto err_out_dif_dma_unmap;
+			}
+		}
+	}
+
+	return 0;
+
+err_out_dif_dma_unmap:
+	dma_unmap_sg(dev, scsi_prot_sglist(scsi_cmnd),
+		     scsi_prot_sg_count(scsi_cmnd), task->data_dir);
+	return rc;
+}
+
 static int hisi_sas_task_prep(struct sas_task *task,
 			      struct hisi_sas_dq **dq_pointer,
 			      bool is_tmf, struct hisi_sas_tmf_task *tmf,
@@ -394,7 +454,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	struct asd_sas_port *sas_port = device->port;
 	struct device *dev = hisi_hba->dev;
 	int dlvry_queue_slot, dlvry_queue, rc, slot_idx;
-	int n_elem = 0, n_elem_req = 0, n_elem_resp = 0;
+	int n_elem = 0, n_elem_dif = 0, n_elem_req = 0, n_elem_resp = 0;
 	struct hisi_sas_dq *dq;
 	unsigned long flags;
 	int wr_q_index;
@@ -427,6 +487,12 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	if (rc < 0)
 		goto prep_out;
 
+	if (!sas_protocol_ata(task->task_proto)) {
+		rc = hisi_sas_dif_dma_map(hisi_hba, &n_elem_dif, task);
+		if (rc < 0)
+			goto err_out_dma_unmap;
+	}
+
 	if (hisi_hba->hw->slot_index_alloc)
 		rc = hisi_hba->hw->slot_index_alloc(hisi_hba, device);
 	else {
@@ -445,7 +511,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 		rc  = hisi_sas_slot_index_alloc(hisi_hba, scsi_cmnd);
 	}
 	if (rc < 0)
-		goto err_out_dma_unmap;
+		goto err_out_dif_dma_unmap;
 
 	slot_idx = rc;
 	slot = &hisi_hba->slot_info[slot_idx];
@@ -466,6 +532,7 @@ static int hisi_sas_task_prep(struct sas_task *task,
 	dlvry_queue_slot = wr_q_index;
 
 	slot->n_elem = n_elem;
+	slot->n_elem_dif = n_elem_dif;
 	slot->dlvry_queue = dlvry_queue;
 	slot->dlvry_queue_slot = dlvry_queue_slot;
 	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
@@ -509,6 +576,9 @@ static int hisi_sas_task_prep(struct sas_task *task,
 
 err_out_tag:
 	hisi_sas_slot_index_free(hisi_hba, slot_idx);
+err_out_dif_dma_unmap:
+	if (!sas_protocol_ata(task->task_proto))
+		hisi_sas_dif_dma_unmap(hisi_hba, task, n_elem_dif);
 err_out_dma_unmap:
 	hisi_sas_dma_unmap(hisi_hba, task, n_elem,
 			   n_elem_req, n_elem_resp);
@@ -2142,21 +2212,26 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 	if (!hisi_hba->slot_info)
 		goto err_out;
 
-	/* roundup to avoid overly large block size */
+	/* roundup to avoid an overly large block size */
 	max_command_entries_ru = roundup(max_command_entries, 64);
-	sz_slot_buf_ru = roundup(sizeof(struct hisi_sas_slot_buf_table), 64);
+	if (hisi_hba->enable_dif)
+		sz_slot_buf_ru = sizeof(struct hisi_sas_slot_dif_buf_table);
+	else
+		sz_slot_buf_ru = sizeof(struct hisi_sas_slot_buf_table);
+	sz_slot_buf_ru = roundup(sz_slot_buf_ru, 64);
 	s = lcm(max_command_entries_ru, sz_slot_buf_ru);
 	blk_cnt = (max_command_entries_ru * sz_slot_buf_ru) / s;
 	slots_per_blk = s / sz_slot_buf_ru;
+
 	for (i = 0; i < blk_cnt; i++) {
-		struct hisi_sas_slot_buf_table *buf;
-		dma_addr_t buf_dma;
 		int slot_index = i * slots_per_blk;
+		dma_addr_t buf_dma;
+		void *buf;
 
-		buf = dmam_alloc_coherent(dev, s, &buf_dma, GFP_KERNEL);
+		buf = dmam_alloc_coherent(dev, s, &buf_dma,
+					  GFP_KERNEL | __GFP_ZERO);
 		if (!buf)
 			goto err_out;
-		memset(buf, 0, s);
 
 		for (j = 0; j < slots_per_blk; j++, slot_index++) {
 			struct hisi_sas_slot *slot;
@@ -2166,8 +2241,8 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 			slot->buf_dma = buf_dma;
 			slot->idx = slot_index;
 
-			buf++;
-			buf_dma += sizeof(*buf);
+			buf += sz_slot_buf_ru;
+			buf_dma += sz_slot_buf_ru;
 		}
 	}
 
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 44781e3..ec22eee 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -127,6 +127,8 @@
 #define PHY_CTRL			(PORT_BASE + 0x14)
 #define PHY_CTRL_RESET_OFF		0
 #define PHY_CTRL_RESET_MSK		(0x1 << PHY_CTRL_RESET_OFF)
+#define CMD_HDR_PIR_OFF			8
+#define CMD_HDR_PIR_MSK			(0x1 << CMD_HDR_PIR_OFF)
 #define SL_CFG				(PORT_BASE + 0x84)
 #define AIP_LIMIT			(PORT_BASE + 0x90)
 #define SL_CONTROL			(PORT_BASE + 0x94)
@@ -333,6 +335,16 @@
 #define ITCT_HDR_RTOLT_OFF		48
 #define ITCT_HDR_RTOLT_MSK		(0xffffULL << ITCT_HDR_RTOLT_OFF)
 
+struct hisi_sas_protect_iu_v3_hw {
+	u32 dw0;
+	u32 lbrtcv;
+	u32 lbrtgv;
+	u32 dw3;
+	u32 dw4;
+	u32 dw5;
+	u32 rsv;
+};
+
 struct hisi_sas_complete_v3_hdr {
 	__le32 dw0;
 	__le32 dw1;
@@ -372,9 +384,27 @@ struct hisi_sas_err_record_v3 {
 	((fis.command == ATA_CMD_DEV_RESET) && \
 	((fis.control & ATA_SRST) != 0)))
 
+#define T10_INSRT_EN_OFF    0
+#define T10_INSRT_EN_MSK    (1 << T10_INSRT_EN_OFF)
+#define T10_RMV_EN_OFF	    1
+#define T10_RMV_EN_MSK	    (1 << T10_RMV_EN_OFF)
+#define T10_RPLC_EN_OFF	    2
+#define T10_RPLC_EN_MSK	    (1 << T10_RPLC_EN_OFF)
+#define T10_CHK_EN_OFF	    3
+#define T10_CHK_EN_MSK	    (1 << T10_CHK_EN_OFF)
+#define INCR_LBRT_OFF	    5
+#define INCR_LBRT_MSK	    (1 << INCR_LBRT_OFF)
+#define USR_DATA_BLOCK_SZ_OFF	20
+#define USR_DATA_BLOCK_SZ_MSK	(0x3 << USR_DATA_BLOCK_SZ_OFF)
+#define T10_CHK_MSK_OFF	    16
+
 static bool hisi_sas_intr_conv;
 MODULE_PARM_DESC(intr_conv, "interrupt converge enable (0-1)");
 
+static bool enable_dif;
+module_param(enable_dif, bool, 0444);
+MODULE_PARM_DESC(enable_dif, "DIF enable (0-1)");
+
 static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 {
 	void __iomem *regs = hisi_hba->regs + off;
@@ -938,7 +968,107 @@ static void prep_prd_sge_v3_hw(struct hisi_hba *hisi_hba,
 
 	hdr->prd_table_addr = cpu_to_le64(hisi_sas_sge_addr_dma(slot));
 
-	hdr->sg_len = cpu_to_le32(n_elem << CMD_HDR_DATA_SGL_LEN_OFF);
+	hdr->sg_len |= cpu_to_le32(n_elem << CMD_HDR_DATA_SGL_LEN_OFF);
+}
+
+static void prep_prd_sge_dif_v3_hw(struct hisi_hba *hisi_hba,
+				  struct hisi_sas_slot *slot,
+				  struct hisi_sas_cmd_hdr *hdr,
+				  struct scatterlist *scatter,
+				  int n_elem)
+{
+	struct hisi_sas_sge_dif_page *sge_dif_page;
+	struct scatterlist *sg;
+	int i;
+
+	sge_dif_page = hisi_sas_sge_dif_addr_mem(slot);
+
+	for_each_sg(scatter, sg, n_elem, i) {
+		struct hisi_sas_sge *entry = &sge_dif_page->sge[i];
+
+		entry->addr = cpu_to_le64(sg_dma_address(sg));
+		entry->page_ctrl_0 = entry->page_ctrl_1 = 0;
+		entry->data_len = cpu_to_le32(sg_dma_len(sg));
+		entry->data_off = 0;
+	}
+
+	hdr->dif_prd_table_addr = cpu_to_le64(
+			hisi_sas_sge_dif_addr_dma(slot));
+
+	hdr->sg_len |= cpu_to_le32(n_elem << CMD_HDR_DIF_SGL_LEN_OFF);
+}
+
+static void fill_prot_v3_hw(struct scsi_cmnd *scsi_cmnd,
+			    struct hisi_sas_protect_iu_v3_hw *prot)
+{
+	u8 prot_type = scsi_get_prot_type(scsi_cmnd);
+	u8 prot_op = scsi_get_prot_op(scsi_cmnd);
+	unsigned int interval = scsi_prot_interval(scsi_cmnd);
+	u32 lbrt_chk_val;
+
+	if (interval == 4096)
+		lbrt_chk_val = (u32)(scsi_get_lba(scsi_cmnd) >> 3);
+	else
+		lbrt_chk_val = (u32)scsi_get_lba(scsi_cmnd);
+
+	switch (prot_op) {
+	case SCSI_PROT_READ_INSERT:
+		prot->dw0 |= T10_INSRT_EN_MSK;
+		prot->lbrtgv = lbrt_chk_val;
+		break;
+	case SCSI_PROT_READ_STRIP:
+		prot->dw0 |= (T10_RMV_EN_MSK | T10_CHK_EN_MSK);
+		prot->lbrtcv = lbrt_chk_val;
+		if (prot_type == SCSI_PROT_DIF_TYPE1)
+			prot->dw4 |= (0xc << 16);
+		else if (prot_type == SCSI_PROT_DIF_TYPE3)
+			prot->dw4 |= (0xfc << 16);
+		break;
+	case SCSI_PROT_READ_PASS:
+		prot->dw0 |= T10_CHK_EN_MSK;
+		prot->lbrtcv = lbrt_chk_val;
+		if (prot_type == SCSI_PROT_DIF_TYPE1)
+			prot->dw4 |= (0xc << 16);
+		else if (prot_type == SCSI_PROT_DIF_TYPE3)
+			prot->dw4 |= (0xfc << 16);
+		break;
+	case SCSI_PROT_WRITE_INSERT:
+		prot->dw0 |= T10_INSRT_EN_MSK;
+		prot->lbrtgv = lbrt_chk_val;
+		break;
+	case SCSI_PROT_WRITE_STRIP:
+		prot->dw0 |= (T10_RMV_EN_MSK | T10_CHK_EN_MSK);
+		prot->lbrtcv = lbrt_chk_val;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		prot->dw0 |= T10_CHK_EN_MSK;
+		prot->lbrtcv = lbrt_chk_val;
+		if (prot_type == SCSI_PROT_DIF_TYPE1)
+			prot->dw4 |= (0xc << 16);
+		else if (prot_type == SCSI_PROT_DIF_TYPE3)
+			prot->dw4 |= (0xfc << 16);
+		break;
+	default:
+		WARN(1, "prot_op(0x%x) is not valid\n", prot_op);
+		break;
+	}
+
+	switch (interval) {
+	case 512:
+		break;
+	case 4096:
+		prot->dw0 |= (0x1 << USR_DATA_BLOCK_SZ_OFF);
+		break;
+	case 520:
+		prot->dw0 |= (0x2 << USR_DATA_BLOCK_SZ_OFF);
+		break;
+	default:
+		WARN(1, "protection interval (0x%x) invalid\n",
+		     interval);
+		break;
+	}
+
+	prot->dw0 |= INCR_LBRT_MSK;
 }
 
 static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
@@ -952,9 +1082,10 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	struct sas_ssp_task *ssp_task = &task->ssp_task;
 	struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
 	struct hisi_sas_tmf_task *tmf = slot->tmf;
+	unsigned char prot_op = scsi_get_prot_op(scsi_cmnd);
 	int has_data = 0, priority = !!tmf;
 	u8 *buf_cmd;
-	u32 dw1 = 0, dw2 = 0;
+	u32 dw1 = 0, dw2 = 0, len = 0;
 
 	hdr->dw0 = cpu_to_le32((1 << CMD_HDR_RESP_REPORT_OFF) |
 			       (2 << CMD_HDR_TLR_CTRL_OFF) |
@@ -984,7 +1115,6 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 
 	/* map itct entry */
 	dw1 |= sas_dev->device_id << CMD_HDR_DEV_ID_OFF;
-	hdr->dw1 = cpu_to_le32(dw1);
 
 	dw2 = (((sizeof(struct ssp_command_iu) + sizeof(struct ssp_frame_hdr)
 	      + 3) / 4) << CMD_HDR_CFL_OFF) |
@@ -993,11 +1123,16 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 	hdr->dw2 = cpu_to_le32(dw2);
 	hdr->transfer_tags = cpu_to_le32(slot->idx);
 
-	if (has_data)
+	if (has_data) {
 		prep_prd_sge_v3_hw(hisi_hba, slot, hdr, task->scatter,
-					slot->n_elem);
+				   slot->n_elem);
+
+		if (scsi_prot_sg_count(scsi_cmnd))
+			prep_prd_sge_dif_v3_hw(hisi_hba, slot, hdr,
+					       scsi_prot_sglist(scsi_cmnd),
+					       slot->n_elem_dif);
+	}
 
-	hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len);
 	hdr->cmd_table_addr = cpu_to_le64(hisi_sas_cmd_hdr_addr_dma(slot));
 	hdr->sts_buffer_addr = cpu_to_le64(hisi_sas_status_buf_addr_dma(slot));
 
@@ -1022,6 +1157,36 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 			break;
 		}
 	}
+
+	if (has_data && (prot_op != SCSI_PROT_NORMAL)) {
+		struct hisi_sas_protect_iu_v3_hw prot;
+		u8 *buf_cmd_prot;
+
+		hdr->dw7 |= cpu_to_le32(1 << CMD_HDR_ADDR_MODE_SEL_OFF);
+		dw1 |= CMD_HDR_PIR_MSK;
+		buf_cmd_prot = hisi_sas_cmd_hdr_addr_mem(slot) +
+			       sizeof(struct ssp_frame_hdr) +
+			       sizeof(struct ssp_command_iu);
+
+		memset(&prot, 0, sizeof(struct hisi_sas_protect_iu_v3_hw));
+		fill_prot_v3_hw(scsi_cmnd, &prot);
+		memcpy(buf_cmd_prot, &prot,
+		       sizeof(struct hisi_sas_protect_iu_v3_hw));
+
+		if ((prot_op == SCSI_PROT_READ_INSERT) ||
+		    (prot_op == SCSI_PROT_WRITE_INSERT) ||
+		    (prot_op == SCSI_PROT_WRITE_PASS) ||
+		    (prot_op == SCSI_PROT_READ_PASS)) {
+			unsigned int interval = scsi_prot_interval(scsi_cmnd);
+			unsigned int ilog2_interval = ilog2(interval);
+
+			len = (task->total_xfer_len >> ilog2_interval) * 8;
+		}
+	}
+
+	hdr->dw1 = cpu_to_le32(dw1);
+
+	hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len + len);
 }
 
 static void prep_smp_v3_hw(struct hisi_hba *hisi_hba,
@@ -2232,6 +2397,7 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	.bios_param		= sas_bios_param,
 	.this_id		= -1,
 	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
+	.sg_prot_tablesize	= HISI_SAS_SGE_PAGE_CNT,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
@@ -2291,6 +2457,7 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	hisi_hba->dev = dev;
 	hisi_hba->shost = shost;
 	SHOST_TO_SAS_HA(shost) = &hisi_hba->sha;
+	hisi_hba->enable_dif = enable_dif;
 
 	timer_setup(&hisi_hba->timer, NULL, 0);
 
@@ -2402,6 +2569,14 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	if (rc)
 		goto err_out_register_ha;
 
+	if (hisi_hba->enable_dif) {
+		dev_info(dev, "Registering for DIF type 1/2/3 protection.\n");
+		scsi_host_set_prot(hisi_hba->shost,
+				   SHOST_DIF_TYPE1_PROTECTION |
+				   SHOST_DIF_TYPE2_PROTECTION |
+				   SHOST_DIF_TYPE3_PROTECTION);
+	}
+
 	scsi_scan_host(shost);
 
 	return 0;
-- 
1.9.1
