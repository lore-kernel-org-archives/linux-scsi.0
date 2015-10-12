From: John Garry <john.garry@huawei.com>
Subject: [PATCH 15/25] scsi: hisi_sas: add cq interrupt handler
Date: Mon, 12 Oct 2015 23:20:27 +0800
Message-ID: <1444663237-238302-16-git-send-email-john.garry@huawei.com>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:11927 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbbJLPFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Oct 2015 11:05:43 -0400
In-Reply-To: <1444663237-238302-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.com, devicetree@vger.kernel.org, arnd@arndb.de, linuxarm@huawei.com, zhangfei.gao@linaro.org, linux-scsi@vger.kernel.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, hare@suse.de, John Garry <john.garry@huawei.com>

Add cq interrupt handler and also slot error handler
function.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   4 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  46 +++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 327 +++++++++++++++++++++++++++++++++
 3 files changed, 377 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 908baf3..976964f 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -347,6 +347,10 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba);
 void hisi_sas_phy_init(struct hisi_hba *hisi_hba, int i);
 int hisi_sas_queue_command(struct sas_task *task, gfp_t gfp_flags);
 void hisi_sas_wq_process(struct work_struct *work);
+void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba, struct sas_task *task,
+			struct hisi_sas_slot *slot);
+
+/* hw specific functions */
 extern void start_delivery_v1_hw(struct hisi_hba *hisi_hba);
 extern int get_free_slot_v1_hw(struct hisi_hba *hisi_hba, int *q, int *s);
 extern int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 3a82262..74084c2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -60,6 +60,52 @@ void hisi_sas_slot_index_init(struct hisi_hba *hisi_hba)
 		hisi_sas_slot_index_clear(hisi_hba, i);
 }
 
+void hisi_sas_slot_task_free(struct hisi_hba *hisi_hba,
+			struct sas_task *task,
+			struct hisi_sas_slot *slot)
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
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SMP:
+		break;
+
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SSP:
+	default:
+		/* do nothing */
+		break;
+	}
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
+			slot->sge_page_dma);
+
+	list_del_init(&slot->entry);
+	task->lldd_task = NULL;
+	slot->task = NULL;
+	slot->port = NULL;
+	hisi_sas_slot_index_free(hisi_hba, slot->idx);
+	memset(slot, 0, sizeof(*slot));
+}
+
 
 static int hisi_sas_task_prep_ssp(struct hisi_hba *hisi_hba,
 				  struct hisi_sas_tei *tei, int is_tmf,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index 6e54054..4cb0e1b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -957,6 +957,257 @@ int prep_ssp_v1_hw(struct hisi_hba *hisi_hba,
 	return 0;
 }
 
+/* by default, task resp is complete */
+static void slot_err_v1_hw(struct hisi_hba *hisi_hba,
+			   struct sas_task *task,
+			   struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *tstat = &task->task_status;
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
+			tstat->residual = 0;
+			tstat->stat = SAS_DATA_UNDERRUN;
+
+			break;
+		}
+		case DMA_TX_DATA_SGL_OVERFLOW_ERR:
+		case DMA_TX_DIF_SGL_OVERFLOW_ERR:
+		case DMA_TX_XFER_RDY_LENGTH_OVERFLOW_ERR:
+		case DMA_RX_DATA_OVERFLOW_ERR:
+		case TRANS_RX_FRAME_OVERRUN_ERR:
+		case TRANS_RX_LINK_BUF_OVERRUN_ERR:
+		{
+			tstat->stat = SAS_DATA_OVERRUN;
+			tstat->residual = 0;
+			break;
+		}
+		case TRANS_TX_PHY_NOT_ENABLE_ERR:
+		{
+			tstat->stat = SAS_PHY_DOWN;
+			tstat->resp = SAS_TASK_UNDELIVERED;
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
+			tstat->stat = SAS_OPEN_REJECT;
+			tstat->open_rej_reason = SAS_OREJ_UNKNOWN;
+			break;
+		}
+		case TRANS_TX_OPEN_TIMEOUT_ERR:
+		{
+			tstat->stat = SAS_OPEN_TO;
+			break;
+		}
+		case TRANS_TX_NAK_RECEIVE_ERR:
+		case TRANS_TX_ACK_NAK_TIMEOUT_ERR:
+		{
+			tstat->stat = SAS_NAK_R_ERR;
+			break;
+		}
+		default:
+		{
+			tstat->stat = SAM_STAT_CHECK_CONDITION;
+			break;
+		}
+		}
+	}
+		break;
+	case SAS_PROTOCOL_SMP:
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		dev_err(dev, "slot err: SMP/SATA/STP not supported");
+	}
+		break;
+	default:
+		break;
+	}
+
+}
+
+int slot_complete_v1_hw(struct hisi_hba *hisi_hba,
+			struct hisi_sas_slot *slot,
+			int abort)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_device *sas_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct task_status_struct *tstat;
+	struct domain_device *device;
+	enum exec_status sts;
+	struct hisi_sas_complete_hdr *complete_queue =
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_hdr *complete_hdr;
+	u32 cmplt_hdr_data;
+
+	complete_hdr = &complete_queue[slot->cmplt_queue_slot];
+	cmplt_hdr_data = le32_to_cpu(complete_hdr->data);
+
+	if (unlikely(!task || !task->lldd_task || !task->dev))
+		return -1;
+
+	tstat = &task->task_status;
+	device = task->dev;
+	sas_dev = device->lldd_dev;
+
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+
+	memset(tstat, 0, sizeof(*tstat));
+	tstat->resp = SAS_TASK_COMPLETE;
+
+	if (unlikely(!sas_dev || abort)) {
+		if (!sas_dev)
+			dev_dbg(dev, "slot complete: port has not device\n");
+		tstat->stat = SAS_PHY_DOWN;
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
+		tstat->resp = SAS_TASK_UNDELIVERED;
+		tstat->stat = SAS_OPEN_REJECT;
+		tstat->open_rej_reason = SAS_OREJ_UNKNOWN;
+		goto out;
+	}
+
+	if (!(cmplt_hdr_data & CMPLT_HDR_ERR_RCRD_XFRD_MSK)) {
+		if (!(cmplt_hdr_data & CMPLT_HDR_CMD_CMPLT_MSK) ||
+		    !(cmplt_hdr_data & CMPLT_HDR_RSPNS_XFRD_MSK)) {
+			tstat->stat = SAS_DATA_OVERRUN;
+			goto out;
+		}
+	} else {
+		slot_err_v1_hw(hisi_hba, task, slot);
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
+	case SAS_PROTOCOL_SMP:
+		dev_err(dev, "slot complete: SMP not supported");
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+		dev_err(dev, "slot complete: SATA/STP not supported");
+		break;
+
+	default:
+		tstat->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+	}
+
+	if (!slot->port->port_attached) {
+		dev_err(dev, "slot complete: port %d has removed\n",
+			slot->port->sas_port.id);
+		tstat->stat = SAS_PHY_DOWN;
+	}
+
+out:
+	if (sas_dev && sas_dev->running_req)
+		sas_dev->running_req--;
+
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	sts = tstat->stat;
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
@@ -1051,10 +1302,63 @@ end:
 }
 
 
+
+static irqreturn_t cq_interrupt_v1_hw(int irq, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	struct hisi_sas_slot *slot;
+	int queue = cq->id;
+	struct hisi_sas_complete_hdr *complete_queue =
+			(struct hisi_sas_complete_hdr *)
+			hisi_hba->complete_hdr[queue];
+	u32 irq_value;
+	u32 rd_point, wr_point;
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
+		struct hisi_sas_complete_hdr *complete_hdr;
+		int iptt, slot_idx;
+		u32 cmplt_hdr_data;
+
+		complete_hdr = &complete_queue[rd_point];
+		cmplt_hdr_data = cpu_to_le32(complete_hdr->data);
+		iptt = (cmplt_hdr_data & CMPLT_HDR_IPTT_MSK) >>
+			CMPLT_HDR_IPTT_OFF;
+		slot_idx = iptt;
+		slot = &hisi_hba->slot_info[slot_idx];
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
 
+static const char cq_int_name[32] = "cq";
 
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phyup_v1_hw,
@@ -1099,6 +1403,29 @@ int interrupt_init_v1_hw(struct hisi_hba *hisi_hba)
 		}
 	}
 
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		int idx = (hisi_hba->n_phy * HISI_SAS_PHY_INT_NR) + i;
+
+		irq = irq_of_parse_and_map(np, idx);
+		if (!irq) {
+			dev_err(dev, "irq init: [%d] could not map cq interrupt %d\n",
+				hisi_hba->id, idx);
+			return -ENOENT;
+		}
+		(void)snprintf(&int_names[idx * HISI_SAS_NAME_LEN],
+				HISI_SAS_NAME_LEN,
+				DRV_NAME" %s [%d %d]", cq_int_name, id, i);
+		rc = devm_request_irq(dev, irq, cq_interrupt_v1_hw, 0,
+				      &int_names[idx * HISI_SAS_NAME_LEN],
+				      &hisi_hba->cq[i]);
+		if (rc) {
+			dev_err(dev, "irq init: [%d] could not request cq interrupt %d, rc=%d\n",
+				hisi_hba->id, irq, rc);
+			return -ENOENT;
+		}
+		idx++;
+	}
+
 
 	return 0;
 }
-- 
1.9.1

