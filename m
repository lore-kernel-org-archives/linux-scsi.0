From: John Garry <john.garry@huawei.com>
Subject: [PATCH v3 22/32] scsi: hisi_sas: add ssp command function
Date: Tue, 10 Nov 2015 00:32:27 +0800
Message-ID: <1447086757-147706-23-git-send-email-john.garry@huawei.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:13331 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbbKIQSR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2015 11:18:17 -0500
In-Reply-To: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, John Garry <john.garry@huawei.com>

Add path to send ssp command to HW

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |  30 +++++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 234 +++++++++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 194 +++++++++++++++++++++++++++
 3 files changed, 458 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index de40202..70365cd 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -35,6 +35,8 @@
 #define HISI_SAS_COMMAND_TABLE_SZ \
 		(((sizeof(union hisi_sas_command_table)+3)/4)*4)
 
+#define HISI_SAS_MAX_SSP_RESP_SZ (sizeof(struct ssp_frame_hdr) + 1024)
+
 #define HISI_SAS_NAME_LEN 32
 
 
@@ -82,15 +84,41 @@ struct hisi_sas_cq {
 struct hisi_sas_device {
 	enum sas_device_type	dev_type;
 	u64 device_id;
+	u64 running_req;
 	u8 dev_status;
 };
 
 struct hisi_sas_slot {
+	struct list_head entry;
+	struct sas_task *task;
+	struct hisi_sas_port	*port;
+	u64	n_elem;
+	int	dlvry_queue;
+	int	dlvry_queue_slot;
+	int	idx;
+	void	*cmd_hdr;
+	dma_addr_t cmd_hdr_dma;
+	void	*status_buffer;
+	dma_addr_t status_buffer_dma;
+	void *command_table;
+	dma_addr_t command_table_dma;
+	struct hisi_sas_sge_page *sge_page;
+	dma_addr_t sge_page_dma;
+};
+
+struct hisi_sas_tmf_task {
+	u8 tmf;
+	u16 tag_of_task_to_be_managed;
 };
 
 struct hisi_sas_hw {
 	int (*hw_init)(struct hisi_hba *hisi_hba);
 	void (*sl_notify)(struct hisi_hba *hisi_hba, int phy_no);
+	int (*get_free_slot)(struct hisi_hba *hisi_hba, int *q, int *s);
+	void (*start_delivery)(struct hisi_hba *hisi_hba);
+	int (*prep_ssp)(struct hisi_hba *hisi_hba,
+			struct hisi_sas_slot *slot, int is_tmf,
+			struct hisi_sas_tmf_task *tmf);
 	int complete_hdr_size;
 };
 
@@ -124,7 +152,9 @@ struct hisi_hba {
 	struct hisi_sas_port port[HISI_SAS_MAX_PHYS];
 
 	int	queue_count;
+	int	queue;
 	char	*int_names;
+	struct hisi_sas_slot	*slot_prep;
 
 	struct dma_pool *sge_page_pool;
 	struct hisi_sas_device	devices[HISI_SAS_MAX_DEVICES];
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 2af09db..e818c4f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -12,6 +12,15 @@
 #include "hisi_sas.h"
 #define DRV_NAME "hisi_sas"
 
+
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
@@ -19,6 +28,31 @@ static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int slot_idx)
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
 static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -26,6 +60,199 @@ static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 	for (i = 0; i < hisi_hba->slot_index_count; ++i)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
+static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
+				  struct hisi_sas_slot *slot, int is_tmf,
+				  struct hisi_sas_tmf_task *tmf)
+{
+	return hisi_hba->hw->prep_ssp(hisi_hba, slot, is_tmf, tmf);
+}
+
+static int hisi_sas_task_prep(struct sas_task *task, struct hisi_hba *hisi_hba,
+			      int is_tmf, struct hisi_sas_tmf_task *tmf,
+			      int *pass)
+{
+	struct domain_device *device = task->dev;
+	struct hisi_sas_device *sas_dev = device->lldd_dev;
+	struct hisi_sas_port *port;
+	struct hisi_sas_slot *slot;
+	struct hisi_sas_cmd_hdr	*cmd_hdr_base;
+	struct device *dev = &hisi_hba->pdev->dev;
+	int dlvry_queue_slot, dlvry_queue, n_elem = 0, rc, slot_idx;
+
+	if (!device->port) {
+		struct task_status_struct *ts = &task->task_status;
+
+		ts->resp = SAS_TASK_UNDELIVERED;
+		ts->stat = SAS_PHY_DOWN;
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
+	port = device->port->lldd_port;
+	if (port && !port->port_attached && !tmf) {
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
+			n_elem = dma_map_sg(dev, task->scatter,
+					    task->num_scatter, task->data_dir);
+			if (!n_elem) {
+				rc = -ENOMEM;
+				goto prep_out;
+			}
+		}
+	} else
+		n_elem = task->num_scatter;
+
+	rc = hisi_sas_slot_index_alloc(hisi_hba, &slot_idx);
+	if (rc)
+		goto err_out;
+	rc = hisi_hba->hw->get_free_slot(hisi_hba, &dlvry_queue,
+					 &dlvry_queue_slot);
+	if (rc)
+		goto err_out_tag;
+
+	slot = &hisi_hba->slot_info[slot_idx];
+	memset(slot, 0, sizeof(struct hisi_sas_slot));
+
+	slot->idx = slot_idx;
+	slot->n_elem = n_elem;
+	slot->dlvry_queue = dlvry_queue;
+	slot->dlvry_queue_slot = dlvry_queue_slot;
+	cmd_hdr_base = hisi_hba->cmd_hdr[dlvry_queue];
+	slot->cmd_hdr = &cmd_hdr_base[dlvry_queue_slot];
+	slot->task = task;
+	slot->port = port;
+	task->lldd_task = slot;
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
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+		rc = hisi_sas_task_prep_ssp(hisi_hba, slot, is_tmf, tmf);
+		break;
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
+	list_add_tail(&slot->entry, &port->list);
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
+static int hisi_sas_task_exec(struct sas_task *task, gfp_t gfp_flags,
+			      int is_tmf, struct hisi_sas_tmf_task *tmf)
+{
+	u32 rc;
+	u32 pass = 0;
+	unsigned long flags;
+	struct hisi_hba *hisi_hba = dev_to_hisi_hba(task->dev);
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	/* protect task_prep and start_delivery sequence */
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	rc = hisi_sas_task_prep(task, hisi_hba, is_tmf, tmf, &pass);
+	if (rc)
+		dev_err(dev, "task exec: failed[%d]!\n", rc);
+
+	if (likely(pass))
+		hisi_hba->hw->start_delivery(hisi_hba);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+
+	return rc;
+}
 
 static void hisi_sas_bytes_dmaed(struct hisi_hba *hisi_hba, int phy_no)
 {
@@ -100,6 +327,12 @@ static void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int phy_no)
 	INIT_WORK(&phy->phyup_ws, hisi_sas_phyup_work);
 }
 
+
+static int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags)
+{
+	return hisi_sas_task_exec(task, gfp_flags, 0, NULL);
+}
+
 static struct scsi_transport_template *hisi_sas_stt;
 
 static struct scsi_host_template hisi_sas_sht = {
@@ -122,6 +355,7 @@ static struct scsi_host_template hisi_sas_sht = {
 };
 
 static struct sas_domain_function_template hisi_sas_transport_ops = {
+	.lldd_execute_task	= hisi_sas_queue_command,
 };
 
 static int hisi_sas_alloc(struct hisi_hba *hisi_hba, struct Scsi_Host *shost)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index da54925..d148c33 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -412,6 +412,13 @@ static u32 hisi_sas_read32(struct hisi_hba *hisi_hba, u32 off)
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
@@ -741,6 +748,190 @@ static void sl_notify_v1_hw(struct hisi_hba *hisi_hba, int phy_no)
 	hisi_sas_phy_write32(hisi_hba, phy_no, SL_CONTROL, sl_control);
 }
 
+/**
+ * This function allocates across all queues to load balance.
+ * Slots are allocated from queues in a round-robin fashion.
+ *
+ * The callpath to this function and upto writing the write
+ * queue pointer should be safe from interruption.
+ */
+static int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+	u32 r, w;
+	int queue = hisi_hba->queue;
+
+	while (1) {
+		w = hisi_sas_read32_relaxed(hisi_hba,
+				    DLVRY_Q_0_WR_PTR + (queue * 0x14));
+		r = hisi_sas_read32_relaxed(hisi_hba,
+				    DLVRY_Q_0_RD_PTR + (queue * 0x14));
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
+static void start_delivery_v1_hw(struct hisi_hba *hisi_hba)
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
+
+static int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
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
+	u8 *buf_cmd, fburst = 0;
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
+	hdr->transfer_tags = cpu_to_le32(slot->idx << CMD_HDR_IPTT_OFF);
+
+	if (has_data) {
+		rc = prep_prd_sge_v1_hw(hisi_hba, slot, hdr, task->scatter,
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
@@ -920,6 +1111,9 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
 	.sl_notify = sl_notify_v1_hw,
+	.prep_ssp = prep_ssp_v1_hw,
+	.get_free_slot = get_free_slot_v1_hw,
+	.start_delivery = start_delivery_v1_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1

