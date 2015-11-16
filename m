From: John Garry <john.garry@huawei.com>
Subject: [PATCH v4 23/32] scsi: hisi_sas: add cq interrupt handler
Date: Mon, 16 Nov 2015 21:06:09 +0800
Message-ID: <1447679178-220222-24-git-send-email-john.garry@huawei.com>
References: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447679178-220222-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org

Add cq interrupt handler and also slot error handler
function.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   9 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  35 ++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 345 +++++++++++++++++++++++++++++++++
 3 files changed, 389 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 72657eb..fe4055b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -93,6 +93,8 @@ struct hisi_sas_slot {
 	u64	n_elem;
 	int	dlvry_queue;
 	int	dlvry_queue_slot;
+	int	cmplt_queue;
+	int	cmplt_queue_slot;
 	int	idx;
 	void	*cmd_hdr;
 	dma_addr_t cmd_hdr_dma;
@@ -117,6 +119,10 @@ struct hisi_sas_hw {
 	int (*prep_ssp)(struct hisi_hba *hisi_hba,
 			struct hisi_sas_slot *slot, int is_tmf,
 			struct hisi_sas_tmf_task *tmf);
+	int (*slot_complete)(struct hisi_hba *hisi_hba,
+			     struct hisi_sas_slot *slot, int abort);
+	void (*free_device)(struct hisi_hba *hisi_hba,
+			    struct hisi_sas_device *dev);
 	int complete_hdr_size;
 };
 
@@ -311,4 +317,7 @@ extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
 
+extern void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
+				    struct sas_task *task,
+				    struct hisi_sas_slot *slot);
 #endif
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 660ef6c..ddbd2b71 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -60,6 +60,41 @@ static void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 	for (i = 0; i < hisi_hba->slot_index_count; ++i)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
+
+void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
+			     struct hisi_sas_slot *slot)
+{
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	if (!slot->task)
+		return;
+
+	if (!sas_protocol_ata(task->task_proto))
+		if (slot->n_elem)
+			dma_unmap_sg(dev, task->scatter, slot->n_elem,
+				     task->data_dir);
+
+	if (slot->command_table)
+		dma_pool_free(hisi_hba->command_table_pool,
+			      slot->command_table, slot->command_table_dma);
+
+	if (slot->status_buffer)
+		dma_pool_free(hisi_hba->status_buffer_pool,
+			      slot->status_buffer, slot->status_buffer_dma);
+
+	if (slot->sge_page)
+		dma_pool_free(hisi_hba->sge_page_pool, slot->sge_page,
+			      slot->sge_page_dma);
+
+	list_del_init(&slot->entry);
+	task->lldd_task = NULL;
+	slot->task = NULL;
+	slot->port = NULL;
+	hisi_sas_slot_index_free(hisi_hba, slot->idx);
+	memset(slot, 0, sizeof(*slot));
+}
+EXPORT_SYMBOL_GPL(hisi_sas_slot_task_free);
+
 static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
 				  struct hisi_sas_slot *slot, int is_tmf,
 				  struct hisi_sas_tmf_task *tmf)
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 07b9750..6711c0a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -498,6 +498,28 @@ static void init_id_frame_v1_hw(struct hisi_hba *hisi_hba)
 		config_id_frame_v1_hw(hisi_hba, i);
 }
 
+
+static void free_device_v1_hw(struct hisi_hba *hisi_hba,
+			      struct hisi_sas_device *sas_dev)
+{
+	u64 dev_id = sas_dev->device_id;
+	struct hisi_sas_itct *itct = &hisi_hba->itct[dev_id];
+	u32 qw0, reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
+
+	reg_val |= CFG_AGING_TIME_ITCT_REL_MSK;
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, reg_val);
+
+	/* free itct */
+	udelay(1);
+	reg_val = hisi_sas_read32(hisi_hba, CFG_AGING_TIME);
+	reg_val &= ~CFG_AGING_TIME_ITCT_REL_MSK;
+	hisi_sas_write32(hisi_hba, CFG_AGING_TIME, reg_val);
+
+	qw0 = cpu_to_le64(itct->qw0);
+	qw0 &= ~ITCT_HDR_VALID_MSK;
+	itct->qw0 = cpu_to_le64(qw0);
+}
+
 static int reset_hw_v1_hw(struct hisi_hba *hisi_hba)
 {
 	int i;
@@ -932,6 +954,253 @@ static int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+/* by default, task resp is complete */
+static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
+			   struct sas_task *task,
+			   struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct hisi_sas_err_record *err_record = slot->status_buffer;
+	struct device *dev = &hisi_hba->pdev->dev;
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		int error = -1;
+		u32 dma_err_type = cpu_to_le32(err_record->dma_err_type);
+		u32 dma_tx_err_type = ((dma_err_type &
+					ERR_HDR_DMA_TX_ERR_TYPE_MSK)) >>
+					ERR_HDR_DMA_TX_ERR_TYPE_OFF;
+		u32 dma_rx_err_type = ((dma_err_type &
+					ERR_HDR_DMA_RX_ERR_TYPE_MSK)) >>
+					ERR_HDR_DMA_RX_ERR_TYPE_OFF;
+		u32 trans_tx_fail_type =
+				cpu_to_le32(err_record->trans_tx_fail_type);
+		u32 trans_rx_fail_type =
+				cpu_to_le32(err_record->trans_rx_fail_type);
+
+		if (dma_tx_err_type) {
+			/* dma tx err */
+			error = ffs(dma_tx_err_type)
+				- 1 + DMA_TX_ERR_BASE;
+		} else if (dma_rx_err_type) {
+			/* dma rx err */
+			error = ffs(dma_rx_err_type)
+				- 1 + DMA_RX_ERR_BASE;
+		} else if (trans_tx_fail_type) {
+			/* trans tx err */
+			error = ffs(trans_tx_fail_type)
+				- 1 + TRANS_TX_FAIL_BASE;
+		} else if (trans_rx_fail_type) {
+			/* trans rx err */
+			error = ffs(trans_rx_fail_type)
+				- 1 + TRANS_RX_FAIL_BASE;
+		}
+
+		switch (error) {
+		case DMA_TX_DATA_UNDERFLOW_ERR:
+		case DMA_RX_DATA_UNDERFLOW_ERR:
+		{
+			ts->residual = 0;
+			ts->stat = SAS_DATA_UNDERRUN;
+			break;
+		}
+		case DMA_TX_DATA_SGL_OVERFLOW_ERR:
+		case DMA_TX_DIF_SGL_OVERFLOW_ERR:
+		case DMA_TX_XFER_RDY_LENGTH_OVERFLOW_ERR:
+		case DMA_RX_DATA_OVERFLOW_ERR:
+		case TRANS_RX_FRAME_OVERRUN_ERR:
+		case TRANS_RX_LINK_BUF_OVERRUN_ERR:
+		{
+			ts->stat = SAS_DATA_OVERRUN;
+			ts->residual = 0;
+			break;
+		}
+		case TRANS_TX_PHY_NOT_ENABLE_ERR:
+		{
+			ts->stat = SAS_PHY_DOWN;
+			break;
+		}
+		case TRANS_TX_OPEN_REJCT_WRONG_DEST_ERR:
+		case TRANS_TX_OPEN_REJCT_ZONE_VIOLATION_ERR:
+		case TRANS_TX_OPEN_REJCT_BY_OTHER_ERR:
+		case TRANS_TX_OPEN_REJCT_AIP_TIMEOUT_ERR:
+		case TRANS_TX_OPEN_REJCT_STP_BUSY_ERR:
+		case TRANS_TX_OPEN_REJCT_PROTOCOL_NOT_SUPPORT_ERR:
+		case TRANS_TX_OPEN_REJCT_RATE_NOT_SUPPORT_ERR:
+		case TRANS_TX_OPEN_REJCT_BAD_DEST_ERR:
+		case TRANS_TX_OPEN_BREAK_RECEIVE_ERR:
+		case TRANS_TX_OPEN_REJCT_PATHWAY_BLOCKED_ERR:
+		case TRANS_TX_OPEN_REJCT_NO_DEST_ERR:
+		case TRANS_TX_OPEN_RETRY_ERR:
+		{
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+			break;
+		}
+		case TRANS_TX_OPEN_TIMEOUT_ERR:
+		{
+			ts->stat = SAS_OPEN_TO;
+			break;
+		}
+		case TRANS_TX_NAK_RECEIVE_ERR:
+		case TRANS_TX_ACK_NAK_TIMEOUT_ERR:
+		{
+			ts->stat = SAS_NAK_R_ERR;
+			break;
+		}
+		default:
+		{
+			ts->stat = SAM_STAT_CHECK_CONDITION;
+			break;
+		}
+		}
+	}
+		break;
+	case SAS_PROTOCOL_SMP:
+		ts->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		dev_err(dev, "slot err: SATA/STP not supported");
+	}
+		break;
+	default:
+		break;
+	}
+
+}
+
+static int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
+			       struct hisi_sas_slot *slot, int abort)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_device *sas_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct task_status_struct *ts;
+	struct domain_device *device;
+	enum exec_status sts;
+	struct hisi_sas_complete_v1_hdr *complete_queue =
+			(struct hisi_sas_complete_v1_hdr *)
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_v1_hdr *complete_hdr;
+	u32 cmplt_hdr_data;
+
+	complete_hdr = &complete_queue[slot->cmplt_queue_slot];
+	cmplt_hdr_data = le32_to_cpu(complete_hdr->data);
+
+	if (unlikely(!task || !task->lldd_task || !task->dev))
+		return -EINVAL;
+
+	ts = &task->task_status;
+	device = task->dev;
+	sas_dev = device->lldd_dev;
+
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+
+	memset(ts, 0, sizeof(*ts));
+	ts->resp = SAS_TASK_COMPLETE;
+
+	if (unlikely(!sas_dev || abort)) {
+		if (!sas_dev)
+			dev_dbg(dev, "slot complete: port has not device\n");
+		ts->stat = SAS_PHY_DOWN;
+		goto out;
+	}
+
+	if (cmplt_hdr_data & CMPLT_HDR_IO_CFG_ERR_MSK) {
+		u32 info_reg = hisi_sas_read32(hisi_hba, HGC_INVLD_DQE_INFO);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_DQ_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq IPTT err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_TYPE_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq type err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_FORCE_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq force phy err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_PHY_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq phy id err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_ABORT_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq abort flag err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_IPTT_OF_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq IPTT or ICT err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_SSP_ERR_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq SSP frame type err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		if (info_reg & HGC_INVLD_DQE_INFO_OFL_MSK)
+			dev_err(dev, "slot complete: [%d:%d] has dq order frame len err",
+				slot->cmplt_queue, slot->cmplt_queue_slot);
+
+		ts->stat = SAS_OPEN_REJECT;
+		ts->open_rej_reason = SAS_OREJ_UNKNOWN;
+		goto out;
+	}
+
+	if (cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK) {
+		if (!(cmplt_hdr_data & CMPLT_HDR_CMD_CMPLT_MSK) ||
+		    !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK))
+			ts->stat = SAS_DATA_OVERRUN;
+		else
+			slot_err_v1_hw(hisi_hba, task, slot);
+
+		goto out;
+	}
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		struct ssp_response_iu *iu = slot->status_buffer +
+			sizeof(struct hisi_sas_err_record);
+		sas_ssp_task_response(dev, task, iu);
+		break;
+	}
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+		dev_err(dev, "slot complete: SATA/STP not supported");
+		break;
+
+	default:
+		ts->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+	}
+
+	if (!slot->port->port_attached) {
+		dev_err(dev, "slot complete: port %d has removed\n",
+			slot->port->sas_port.id);
+		ts->stat = SAS_PHY_DOWN;
+	}
+
+out:
+	if (sas_dev && sas_dev->running_req)
+		sas_dev->running_req--;
+
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	sts = ts->stat;
+
+	if (task->task_done)
+		task->task_done(task);
+
+	return sts;
+}
+
 /* Interrupts */
 static irqreturn_t int_phyup_v1_hw(int irq_no, void *p)
 {
@@ -1011,9 +1280,61 @@ end:
 
 	return res;
 }
+
+static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	struct hisi_sas_slot *slot;
+	int queue = cq->id;
+	struct hisi_sas_complete_v1_hdr *complete_queue =
+			(struct hisi_sas_complete_v1_hdr *)
+			hisi_hba->complete_hdr[queue];
+	u32 irq_value, rd_point, wr_point;
+
+	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
+
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+
+	rd_point = hisi_sas_read32(hisi_hba,
+			COMPL_Q_0_RD_PTR + (0x14 * queue));
+	wr_point = hisi_sas_read32(hisi_hba,
+			COMPL_Q_0_WR_PTR + (0x14 * queue));
+
+	while (rd_point != wr_point) {
+		struct hisi_sas_complete_v1_hdr *complete_hdr;
+		int idx;
+		u32 cmplt_hdr_data;
+
+		complete_hdr = &complete_queue[rd_point];
+		cmplt_hdr_data = cpu_to_le32(complete_hdr->data);
+		idx = (cmplt_hdr_data & CMPLT_HDR_IPTT_MSK) >>
+		      CMPLT_HDR_IPTT_OFF;
+		slot = &hisi_hba->slot_info[idx];
+
+		/* The completion queue and queue slot index are not
+		 * necessarily the same as the delivery queue and
+		 * queue slot index.
+		 */
+		slot->cmplt_queue_slot = rd_point;
+		slot->cmplt_queue = queue;
+		slot_complete_v1_hw(hisi_hba, slot, 0);
+
+		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
+			rd_point = 0;
+	}
+
+	/* update rd_point */
+	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+
+	return IRQ_HANDLED;
+}
+
 static const char phy_int_names[HISI_SAS_PHY_INT_NR][32] = {
 	{"Phy Up"},
 };
+
+static const char cq_int_name[32] = "cq";
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phyup_v1_hw,
 };
@@ -1056,6 +1377,28 @@ static int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 			}
 		}
 	}
+
+	idx = hisi_hba->n_phy * HISI_SAS_PHY_INT_NR;
+	for (i = 0; i < hisi_hba->queue_count; i++, idx++) {
+		irq = irq_of_parse_and_map(np, idx);
+		if (!irq) {
+			dev_err(dev, "irq init: could not map cq interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+		(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+			       HISI_SAS_NAME_LEN,
+			       "%s %s:%d", dev_name(dev), cq_int_name, i);
+		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
+				      &int_names[idx * HISI_SAS_NAME_LEN],
+				      &hisi_hba->cq[i]);
+		if (rc) {
+			dev_err(dev, "irq init: could not request cq interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+	}
+
 	return 0;
 }
 
@@ -1110,9 +1453,11 @@ static int hisi_sas_v1_init(struct hisi_hba *hisi_hba)
 static const struct hisi_sas_hw hisi_sas_v1_hw = {
 	.hw_init = hisi_sas_v1_init,
 	.sl_notify = sl_notify_v1_hw,
+	.free_device = free_device_v1_hw,
 	.prep_ssp = prep_ssp_v1_hw,
 	.get_free_slot = get_free_slot_v1_hw,
 	.start_delivery = start_delivery_v1_hw,
+	.slot_complete = slot_complete_v1_hw,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v1_hdr),
 };
 
-- 
1.9.1
