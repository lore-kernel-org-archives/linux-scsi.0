From: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 14/25] scsi: hisi_sas: add ssp command function
Date: Mon, 12 Oct 2015 23:20:26 +0800
Message-ID: <1444663237-238302-15-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org
Cc: linux-kernel-u79uwXL29TZ19SzzRMN9sA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, zhangfei.gao-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org, john.garry2-s/0ZXS5h9803lw97EnAbAg@public.gmane.org, hare-l3A5Bk7waGM@public.gmane.org, John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Add path to send ssp command to HW.

Signed-off-by: John Garry <john.garry-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  23 +++
 drivers/scsi/hisi_sas/hisi_sas_init.c  |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 246 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 206 +++++++++++++++++++++++++++
 4 files changed, 476 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 802c000..908baf3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -33,6 +33,7 @@
 #define HISI_SAS_COMMAND_TABLE_SZ \
 		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
 
+#define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
 #define HISI_SAS_NAME_LEN 32
 #define HISI_SAS_RESET_REG_CNT 5
 
@@ -109,6 +110,20 @@ struct hisi_sas_slot {
 	dma_addr_t sge_page_dma;
 };
 
+struct hisi_sas_tmf_task {
+	u8 tmf;
+	u16 tag_of_task_to_be_managed;
+};
+
+struct hisi_sas_tei {
+	struct sas_task	*task;
+	struct hisi_sas_cmd_hdr	*hdr;
+	struct hisi_sas_port	*port;
+	struct hisi_sas_slot	*slot;
+	int	n_elem;
+	int	iptt;
+};
+
 enum hisi_sas_wq_event {
 	PHYUP,
 };
@@ -158,9 +173,11 @@ struct hisi_hba {
 	struct hisi_sas_cq cq[HISI_SAS_MAX_QUEUES];
 	struct hisi_sas_phy phy[HISI_SAS_MAX_PHYS];
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
+
 	int	id;
 	int	queue_count;
 	char	*int_names;
+	struct hisi_sas_slot	*slot_prep;
 
 	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
 	struct dma_pool *command_table_pool;
@@ -328,7 +345,13 @@ union hisi_sas_command_table {
 
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
+int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
 void hisi_sas_wq_process(struct work_struct *work);
+extern void start_delivery_v1_hw(struct hisi_hba *hisi_hba);
+extern int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s);
+extern int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
+			  struct hisi_sas_tei *tei, int is_tmf,
+			  struct hisi_sas_tmf_task *tmf);
 extern int interrupt_init_v1_hw(struct hisi_hba *hisi_hba);
 extern int interrupt_openall_v1_hw(struct hisi_hba *hisi_hba);
 extern int hw_init_v1_hw(struct hisi_hba *hisi_hba);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_init.c b/drivers/scsi/hisi_sas/hisi_sas_init.c
index 67bfa58..c681b21 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_init.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_init.c
@@ -33,6 +33,7 @@ static struct scsi_host_template hisi_sas_sht = {
 };
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
+	.lldd_execute_task	= hisi_sas_queue_command,
 };
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 72831db..3a82262 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -12,6 +12,14 @@
 #include "hisi_sas.h"
 
 
+#define DEV_IS_GONE(dev) \
+	((!dev) || (dev->dev_type == SAS_PHY_UNUSED))
+
+static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
+{
+	return device->port->ha->lldd_ha;
+}
+
 static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 {
 	void *bitmap = hisi_hba->slot_index_tags;
@@ -19,6 +27,31 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
 	clear_bit(slot_idx, bitmap);
 }
 
+static void hisi_sas_slot_index_free(struct hisi_hba *hisi_hba, int slot_idx)
+{
+	hisi_sas_slot_index_clear(hisi_hba, slot_idx);
+}
+
+static void hisi_sas_slot_index_set(struct hisi_hba *hisi_hba, int slot_idx)
+{
+	void *bitmap = hisi_hba->slot_index_tags;
+
+	set_bit(slot_idx, bitmap);
+}
+
+static int hisi_sas_slot_index_alloc(struct hisi_hba *hisi_hba, int *slot_idx)
+{
+	unsigned int index;
+	void *bitmap = hisi_hba->slot_index_tags;
+
+	index = find_first_zero_bit(bitmap, hisi_hba->slot_index_count);
+	if (index >= hisi_hba->slot_index_count)
+		return -SAS_QUEUE_FULL;
+	hisi_sas_slot_index_set(hisi_hba, index);
+	*slot_idx = index;
+	return 0;
+}
+
 void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -28,6 +61,214 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 }
 
 
+static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
+				  struct hisi_sas_tei *tei, int is_tmf,
+				  struct hisi_sas_tmf_task *tmf)
+{
+	return prep_ssp_v1_hw(hisi_hba, tei, is_tmf, tmf);
+}
+
+static int hisi_sas_task_prep(struct sas_task *task,
+				struct hisi_hba *hisi_hba,
+				int is_tmf, struct hisi_sas_tmf_task *tmf,
+				int *pass)
+{
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_tei tei;
+	struct hisi_sas_slot *slot;
+	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
+	struct device *dev = &hisi_hba->pdev->dev;
+	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
+
+	if (!device->port) {
+		struct task_status_struct *tsm = &task->task_status;
+
+		tsm->resp = SAS_TASK_UNDELIVERED;
+		tsm->stat = SAS_PHY_DOWN;
+		/*
+		 * libsas will use dev->port, should
+		 * not call task_done for sata
+		 */
+		if (device->dev_type != SAS_SATA_DEV)
+			task->task_done(task);
+		return 0;
+	}
+
+	if (DEV_IS_GONE(sas_dev)) {
+		if (sas_dev)
+			dev_info(dev, "task prep: device %llu not ready\n",
+				 sas_dev->device_id);
+		else
+			dev_info(dev, "task prep: device %016llx not ready\n",
+				 SAS_ADDR(device->sas_addr));
+
+		rc = SAS_PHY_DOWN;
+		return rc;
+	}
+	tei.port = device->port->lldd_port;
+	if (tei.port && !tei.port->port_attached && !tmf) {
+		if (sas_protocol_ata(task->task_proto)) {
+			struct task_status_struct *ts = &task->task_status;
+
+			dev_info(dev,
+				 "task prep: SATA/STP port%d not attach device\n",
+				 device->port->id);
+			ts->resp = SAS_TASK_COMPLETE;
+			ts->stat = SAS_PHY_DOWN;
+			task->task_done(task);
+		} else {
+			struct task_status_struct *ts = &task->task_status;
+
+			dev_info(dev,
+				 "task prep: SAS port%d does not attach device\n",
+				 device->port->id);
+			ts->resp = SAS_TASK_UNDELIVERED;
+			ts->stat = SAS_PHY_DOWN;
+			task->task_done(task);
+		}
+		return 0;
+	}
+
+	if (!sas_protocol_ata(task->task_proto)) {
+		if (task->num_scatter) {
+			n_elem = dma_map_sg(dev,
+					task->scatter,
+					task->num_scatter,
+					task->data_dir);
+			if (!n_elem) {
+				rc = -ENOMEM;
+				goto prep_out;
+			}
+		}
+	} else {
+		n_elem = task->num_scatter;
+	}
+
+	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
+	if (rc)
+		goto err_out;
+	rc = get_free_slot_v1_hw(hisi_hba,
+				 &dlvry_queue,
+				 &dlvry_queue_slot);
+	if (rc)
+		goto err_out_tag;
+
+	slot = &hisi_hba->slot_info[slot_idx];
+	memset(slot, 0, sizeof(struct hisi_sas_slot));
+
+	task->lldd_task = NULL;
+	slot->idx = slot_idx;
+	tei.iptt = slot_idx;
+	slot->n_elem = n_elem;
+	slot->dlvry_queue = dlvry_queue;
+	slot->dlvry_queue_slot = dlvry_queue_slot;
+	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
+	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
+
+	slot->status_buffer = dma_pool_alloc(hisi_hba->status_buffer_pool,
+					     GFP_ATOMIC,
+					     &slot->status_buffer_dma);
+	if (!slot->status_buffer)
+		goto err_out_slot_buf;
+	memset(slot->status_buffer, 0, HISI_SAS_STATUS_BUF_SZ);
+
+	slot->command_table = dma_pool_alloc(hisi_hba->command_table_pool,
+					     GFP_ATOMIC,
+					     &slot->command_table_dma);
+	if (!slot->command_table)
+		goto err_out_status_buf;
+	memset(slot->command_table, 0, HISI_SAS_COMMAND_TABLE_SZ);
+	memset(slot->cmd_hdr, 0, sizeof(struct hisi_sas_cmd_hdr));
+
+	tei.hdr = slot->cmd_hdr;
+	tei.task = task;
+	tei.n_elem = n_elem;
+	tei.slot = slot;
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+		rc = hisi_sas_task_prep_ssp(hisi_hba, &tei, is_tmf, tmf);
+		break;
+	case SAS_PROTOCOL_SMP:
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	default:
+		dev_err(dev, "task prep: unknown/unsupported proto (0x%x)\n",
+			task->task_proto);
+		rc = -EINVAL;
+		break;
+	}
+
+	if (rc) {
+		dev_err(dev, "task prep: rc = 0x%x\n", rc);
+		if (slot->sge_page)
+			goto err_out_sge;
+		goto err_out_command_table;
+	}
+
+	slot->task = task;
+	slot->port = tei.port;
+	task->lldd_task = slot;
+	list_add_tail(&slot->entry, &tei.port->list);
+	spin_lock(&task->task_state_lock);
+	task->task_state_flags |= SAS_TASK_AT_INITIATOR;
+	spin_unlock(&task->task_state_lock);
+
+	hisi_hba->slot_prep = slot;
+
+	sas_dev->running_req++;
+	++(*pass);
+
+	return rc;
+
+err_out_sge:
+	dma_pool_free(hisi_hba->sge_page_pool, slot->sge_page,
+		slot->sge_page_dma);
+err_out_command_table:
+	dma_pool_free(hisi_hba->command_table_pool, slot->command_table,
+		slot->command_table_dma);
+err_out_status_buf:
+	dma_pool_free(hisi_hba->status_buffer_pool, slot->status_buffer,
+		slot->status_buffer_dma);
+err_out_slot_buf:
+	/* Nothing to be done */
+err_out_tag:
+	hisi_sas_slot_index_free(hisi_hba, slot_idx);
+err_out:
+	dev_err(dev, "task prep: failed[%d]!\n", rc);
+	if (!sas_protocol_ata(task->task_proto))
+		if (n_elem)
+			dma_unmap_sg(dev, task->scatter, n_elem,
+				     task->data_dir);
+prep_out:
+	return rc;
+}
+
+static int hisi_sas_task_exec(struct sas_task *task,
+	gfp_t gfp_flags,
+	struct completion *completion,
+	int is_tmf,
+	struct hisi_sas_tmf_task *tmf)
+{
+	u32 rc;
+	u32 pass = 0;
+	unsigned long flags = 0;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	rc = hisi_sas_task_prep(task, hisi_hba, is_tmf, tmf, &pass);
+	if (rc)
+		dev_err(dev, "task exec: failed[%d]!\n", rc);
+
+	if (likely(pass))
+		start_delivery_v1_hw(hisi_hba);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	return rc;
+}
+
 void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 {
 	struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
@@ -112,3 +353,8 @@ void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	sas_phy->ha = (struct sas_ha_struct *)hisi_hba->shost->hostdata;
 	sas_phy->lldd_phy = phy;
 }
+
+int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
+{
+	return hisi_sas_task_exec(task, gfp_flags, NULL, 0, NULL);
+}
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index df56b3a..6e54054 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -407,6 +407,13 @@ static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
 	return readl(regs);
 }
 
+static u32 hisi_sas_read32_relaxed(struct hisi_hba *hisi_hba, u32 off)
+{
+	void __iomem *regs = hisi_hba->regs + off;
+
+	return readl_relaxed(regs);
+}
+
 static void hisi_sas_write32(struct hisi_hba *hisi_hba,
 				    u32 off, u32 val)
 {
@@ -751,6 +758,205 @@ void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+/**
+ * This function allocates across all queues to load balance.
+ * It uses the current cpu as the method to balance the
+ * queues.
+ *
+ * The callpath to this function and upto writing the write
+ * queue pointer should be safe from interruption.
+ */
+int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 r, w;
+	int queue = smp_processor_id() % hisi_hba->queue_count;
+
+	while (1) {
+		w = hisi_sas_read32_relaxed(hisi_hba,
+				    DLVRY_Q_0_WR_PTR + (queue * 0x14));
+		r = hisi_sas_read32_relaxed(hisi_hba,
+				    DLVRY_Q_0_RD_PTR + (queue * 0x14));
+
+		if (r == w+1 % HISI_SAS_QUEUE_SLOTS) {
+			dev_warn(dev, "delivery queue%d full, r=%d w=%d\n",
+				 queue, r, w);
+			queue = (queue + 1) % hisi_hba->queue_count;
+			continue;
+		}
+		break;
+	}
+
+	*q = queue;
+	*s = w;
+
+	return 0;
+}
+
+void start_delivery_v1_hw(struct hisi_hba *hisi_hba)
+{
+	int dlvry_queue = hisi_hba->slot_prep->dlvry_queue;
+	int dlvry_queue_slot = hisi_hba->slot_prep->dlvry_queue_slot;
+
+	hisi_sas_write32(hisi_hba,
+			 DLVRY_Q_0_WR_PTR + (dlvry_queue * 0x14),
+			 ++dlvry_queue_slot % HISI_SAS_QUEUE_SLOTS);
+}
+
+static int prep_prd_sge_v1_hw(struct hisi_hba *hisi_hba,
+				 struct hisi_sas_slot *slot,
+				 struct hisi_sas_cmd_hdr *hdr,
+				 struct scatterlist *scatter,
+				 int n_elem)
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
+		entry->addr_lo = cpu_to_le32(lower_32_bits(sg_dma_address(sg)));
+		entry->addr_hi = cpu_to_le32(upper_32_bits(sg_dma_address(sg)));
+		entry->page_ctrl_0 = entry->page_ctrl_1 = 0;
+		entry->data_len = cpu_to_le32(sg_dma_len(sg));
+		entry->data_off = 0;
+	}
+
+	hdr->prd_table_addr_lo =
+		cpu_to_le32(lower_32_bits(slot->sge_page_dma));
+	hdr->prd_table_addr_hi =
+		cpu_to_le32(upper_32_bits(slot->sge_page_dma));
+
+	hdr->sg_len = cpu_to_le32(n_elem << CMD_HDR_DATA_SGL_LEN_OFF);
+
+	return 0;
+}
+
+
+int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
+		   struct hisi_sas_tei *tei, int is_tmf,
+		   struct hisi_sas_tmf_task *tmf)
+{
+	struct sas_task *task = tei->task;
+	struct hisi_sas_cmd_hdr *hdr = tei->hdr;
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_port *port = tei->port;
+	struct sas_ssp_task *ssp_task = &task->ssp_task;
+	struct scsi_cmnd *scsi_cmnd = ssp_task->cmd;
+	int has_data = 0, rc;
+	struct hisi_sas_slot *slot = tei->slot;
+	u8 *buf_cmd, fburst = 0;
+	int priority = is_tmf;
+	u32 dw1, dw2;
+
+	/* create header */
+	hdr->dw0 = cpu_to_le32((1 << CMD_HDR_RESP_REPORT_OFF) |
+			       (0x2 << CMD_HDR_TLR_CTRL_OFF) |
+			       (port->id << CMD_HDR_PORT_OFF) |
+			       (priority << CMD_HDR_PRIORITY_OFF) |
+			       (1 << CMD_HDR_MODE_OFF) | /* ini mode */
+			       (1 << CMD_HDR_CMD_OFF)); /* ssp */
+
+	dw1 = 1 << CMD_HDR_VERIFY_DTL_OFF;
+
+	if (is_tmf) {
+		dw1 |= 3 << CMD_HDR_SSP_FRAME_TYPE_OFF;
+	} else {
+		switch (scsi_cmnd->sc_data_direction) {
+		case DMA_TO_DEVICE:
+			dw1 |= 2 << CMD_HDR_SSP_FRAME_TYPE_OFF;
+			has_data = 1;
+			break;
+		case DMA_FROM_DEVICE:
+			dw1 |= 1 << CMD_HDR_SSP_FRAME_TYPE_OFF;
+			has_data = 1;
+			break;
+		default:
+			dw1 |= 0 << CMD_HDR_SSP_FRAME_TYPE_OFF;
+		}
+	}
+
+	/* map itct entry */
+	dw1 |= sas_dev->device_id << CMD_HDR_DEVICE_ID_OFF;
+	hdr->dw1 = cpu_to_le32(dw1);
+
+	if (is_tmf) {
+		dw2 = ((sizeof(struct ssp_tmf_iu) +
+			sizeof(struct ssp_frame_hdr)+3)/4) <<
+			CMD_HDR_CFL_OFF;
+	} else {
+		dw2 = ((sizeof(struct ssp_command_iu) +
+			sizeof(struct ssp_frame_hdr)+3)/4) <<
+			CMD_HDR_CFL_OFF;
+	}
+
+	dw2 |= (HISI_SAS_MAX_SSP_RESP_SZ/4) << CMD_HDR_MRFL_OFF;
+
+	hdr->transfer_tags = cpu_to_le32(tei->iptt << CMD_HDR_IPTT_OFF);
+
+	if (has_data) {
+		rc = prep_prd_sge_v1_hw(hisi_hba, slot, hdr, task->scatter,
+					tei->n_elem);
+		if (rc)
+			return rc;
+	}
+
+	hdr->data_transfer_len = cpu_to_le32(task->total_xfer_len);
+
+	hdr->cmd_table_addr_lo =
+			cpu_to_le32(lower_32_bits(slot->command_table_dma));
+	hdr->cmd_table_addr_hi =
+			cpu_to_le32(upper_32_bits(slot->command_table_dma));
+
+	hdr->sts_buffer_addr_lo =
+			cpu_to_le32(lower_32_bits(slot->status_buffer_dma));
+	hdr->sts_buffer_addr_hi =
+			cpu_to_le32(upper_32_bits(slot->status_buffer_dma));
+
+	buf_cmd = (u8 *)slot->command_table + sizeof(struct ssp_frame_hdr);
+	if (task->ssp_task.enable_first_burst) {
+		fburst = (1 << 7);
+		dw2 |= 1 << CMD_HDR_FIRST_BURST_OFF;
+	}
+	hdr->dw2 = cpu_to_le32(dw2);
+
+	memcpy(buf_cmd, &task->ssp_task.LUN, 8);
+	if (!is_tmf) {
+		buf_cmd[9] = fburst | task->ssp_task.task_attr |
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
 /* Interrupts */
 static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 {
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
