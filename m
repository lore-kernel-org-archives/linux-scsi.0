From: John Garry <john.garry@huawei.com>
Subject: [RFC PATCH v5 2/2] scsi: hisi_sas: Add support for DIX feature for v3 hw as experimental
Date: Mon, 17 Dec 2018 22:40:08 +0800
Message-ID: <1545057608-89965-3-git-send-email-john.garry@huawei.com>
References: <1545057608-89965-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545057608-89965-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

This patchset adds support for DIX to v3 hw driver.

As discussed in the following thread, DIX seems to be in conflict with
SCSI MQ, so this is why we mark the support for this driver as
experimental:
https://marc.info/?l=linux-scsi&m=154392687627603&w=2,

As for DIX support itself, we build upon support for DIF, most
significantly is adding new DMA map and unmap paths.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       | 22 +++++++-
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 97 ++++++++++++++++++++++++++++++----
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 75 +++++++++++++++++++++++---
 3 files changed, 174 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index af29194..4663f19 100644
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
@@ -73,7 +78,11 @@
 				SHOST_DIF_TYPE2_PROTECTION | \
 				SHOST_DIF_TYPE3_PROTECTION)
 
-#define HISI_SAS_PROT_MASK (HISI_SAS_DIF_PROT_MASK)
+#define HISI_SAS_DIX_PROT_MASK (SHOST_DIX_TYPE1_PROTECTION | \
+				SHOST_DIX_TYPE2_PROTECTION | \
+				SHOST_DIX_TYPE3_PROTECTION)
+
+#define HISI_SAS_PROT_MASK (HISI_SAS_DIF_PROT_MASK | HISI_SAS_DIX_PROT_MASK)
 
 struct hisi_hba;
 
@@ -203,6 +212,7 @@ struct hisi_sas_slot {
 	struct sas_task *task;
 	struct hisi_sas_port	*port;
 	u64	n_elem;
+	u64	n_elem_dif;
 	int	dlvry_queue;
 	int	dlvry_queue_slot;
 	int	cmplt_queue;
@@ -430,6 +440,11 @@ struct hisi_sas_sge_page {
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
@@ -460,6 +475,11 @@ struct hisi_sas_slot_buf_table {
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
index eed7fc5..a518ac7 100644
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
@@ -2144,19 +2214,24 @@ int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
 
 	/* roundup to avoid overly large block size */
 	max_command_entries_ru = roundup(max_command_entries, 64);
-	sz_slot_buf_ru = roundup(sizeof(struct hisi_sas_slot_buf_table), 64);
+	if (hisi_hba->prot_mask & HISI_SAS_DIX_PROT_MASK)
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
index 6cd3c1a..a8dd80f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -969,7 +969,34 @@ static void prep_prd_sge_v3_hw(struct hisi_hba *hisi_hba,
 
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
 }
 
 static u32 get_prot_chk_msk_v3_hw(struct scsi_cmnd *scsi_cmnd)
@@ -992,15 +1019,33 @@ static void fill_prot_v3_hw(struct scsi_cmnd *scsi_cmnd,
 	u32 lbrt_chk_val = t10_pi_ref_tag(scsi_cmnd->request);
 
 	switch (prot_op) {
+	case SCSI_PROT_READ_INSERT:
+		prot->dw0 |= T10_INSRT_EN_MSK;
+		prot->lbrtgv = lbrt_chk_val;
+		break;
 	case SCSI_PROT_READ_STRIP:
 		prot->dw0 |= (T10_RMV_EN_MSK | T10_CHK_EN_MSK);
 		prot->lbrtcv = lbrt_chk_val;
 		prot->dw4 |= get_prot_chk_msk_v3_hw(scsi_cmnd);
 		break;
+	case SCSI_PROT_READ_PASS:
+		prot->dw0 |= T10_CHK_EN_MSK;
+		prot->lbrtcv = lbrt_chk_val;
+		prot->dw4 |= get_prot_chk_msk_v3_hw(scsi_cmnd);
+		break;
 	case SCSI_PROT_WRITE_INSERT:
 		prot->dw0 |= T10_INSRT_EN_MSK;
 		prot->lbrtgv = lbrt_chk_val;
 		break;
+	case SCSI_PROT_WRITE_STRIP:
+		prot->dw0 |= (T10_RMV_EN_MSK | T10_CHK_EN_MSK);
+		prot->lbrtcv = lbrt_chk_val;
+		break;
+	case SCSI_PROT_WRITE_PASS:
+		prot->dw0 |= T10_CHK_EN_MSK;
+		prot->lbrtcv = lbrt_chk_val;
+		prot->dw4 |= get_prot_chk_msk_v3_hw(scsi_cmnd);
+		break;
 	default:
 		WARN(1, "prot_op(0x%x) is not valid\n", prot_op);
 		break;
@@ -1076,9 +1121,15 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
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
 
 	hdr->cmd_table_addr = cpu_to_le64(hisi_sas_cmd_hdr_addr_dma(slot));
 	hdr->sts_buffer_addr = cpu_to_le64(hisi_sas_status_buf_addr_dma(slot));
@@ -1119,18 +1170,19 @@ static void prep_ssp_v3_hw(struct hisi_hba *hisi_hba,
 		fill_prot_v3_hw(scsi_cmnd, &prot);
 		memcpy(buf_cmd_prot, &prot,
 		       sizeof(struct hisi_sas_protect_iu_v3_hw));
-
 		/*
 		 * For READ, we need length of info read to memory, while for
 		 * WRITE we need length of data written to the disk.
 		 */
-		if (prot_op == SCSI_PROT_WRITE_INSERT) {
+		if ((prot_op == SCSI_PROT_WRITE_INSERT) ||
+			(prot_op == SCSI_PROT_READ_INSERT) ||
+			(prot_op == SCSI_PROT_WRITE_PASS) ||
+			(prot_op == SCSI_PROT_READ_PASS)) {
 			unsigned int interval = scsi_prot_interval(scsi_cmnd);
 			unsigned int ilog2_interval = ilog2(interval);
 
 			len = (task->total_xfer_len >> ilog2_interval) * 8;
 		}
-
 	}
 
 	hdr->dw1 = cpu_to_le32(dw1);
@@ -2346,6 +2398,7 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	.bios_param		= sas_bios_param,
 	.this_id		= -1,
 	.sg_tablesize		= HISI_SAS_SGE_PAGE_CNT,
+	.sg_prot_tablesize	= HISI_SAS_SGE_PAGE_CNT,
 	.max_sectors		= SCSI_DEFAULT_MAX_SECTORS,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.eh_device_reset_handler = sas_eh_device_reset_handler,
@@ -2522,10 +2575,16 @@ static ssize_t intr_coal_count_v3_hw_store(struct device *dev,
 	if (rc)
 		goto err_out_register_ha;
 
+
 	if (hisi_hba->prot_mask) {
-		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x\n",
-			 prot_mask);
+		int dix = hisi_hba->prot_mask & HISI_SAS_DIX_PROT_MASK;
+
+		dev_info(dev, "Registering for DIF/DIX prot_mask=0x%x %s\n",
+			 prot_mask, dix ? "(DIX experimental)" : "");
 		scsi_host_set_prot(hisi_hba->shost, prot_mask);
+		if (hisi_hba->prot_mask & HISI_SAS_DIX_PROT_MASK)
+			scsi_host_set_guard(hisi_hba->shost,
+					    SHOST_DIX_GUARD_CRC);
 	}
 
 	scsi_scan_host(shost);
-- 
1.9.1
