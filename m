From: John Garry <john.garry@huawei.com>
Subject: [PATCH 13/22] scsi: hisi_sas: add v3 cq interrupt handler
Date: Wed, 17 May 2017 18:49:48 +0800
Message-ID: <1495018197-120535-14-git-send-email-john.garry@huawei.com>
References: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1495018197-120535-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

Add v3 cq interrupt handler.

Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h       |   1 +
 drivers/scsi/hisi_sas/hisi_sas_main.c  |  32 ++++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 332 +++++++++++++++++++++++++++++++++
 3 files changed, 365 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 9fd874d..c7d1144 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -385,6 +385,7 @@ extern int hisi_sas_pci_probe(struct pci_dev *pdev,
 extern void hisi_sas_sata_done(struct sas_task *task,
 			    struct hisi_sas_slot *slot);
 extern int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag);
+extern bool hisi_sas_is_rw_cmd(struct sas_task *task);
 extern int hisi_sas_probe(struct platform_device *pdev,
 			  const struct hisi_sas_hw *ops);
 extern int hisi_sas_remove(struct platform_device *pdev);
diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index 33bd3c45..156b66b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -118,6 +118,38 @@ int hisi_sas_get_ncq_tag(struct sas_task *task, u32 *tag)
 }
 EXPORT_SYMBOL_GPL(hisi_sas_get_ncq_tag);
 
+bool hisi_sas_is_rw_cmd(struct sas_task *task)
+{
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		unsigned char op = task->ssp_task.cmd->cmnd[0];
+
+		if (op == READ_6 || op == WRITE_6 ||
+			op == READ_10 || op == WRITE_10 ||
+			op == READ_12 || op == WRITE_12 ||
+			op == READ_16 || op == WRITE_16)
+			return true;
+		break;
+	}
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		u32 cmd_proto = hisi_sas_get_ata_protocol(
+				task->ata_task.fis.command,
+				task->data_dir);
+		if (cmd_proto != SATA_PROTOCOL_NONDATA)
+			return true;
+		break;
+	}
+	default:
+		break;
+	}
+	return false;
+}
+EXPORT_SYMBOL_GPL(hisi_sas_is_rw_cmd);
+
 static struct hisi_hba *dev_to_hisi_hba(struct domain_device *device)
 {
 	return device->port->ha->lldd_ha;
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index f7872c5..b33781b 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -156,6 +156,33 @@
 #define PHYCTRL_PHY_ENA_MSK		(PORT_BASE + 0x2bc)
 #define SL_RX_BCAST_CHK_MSK		(PORT_BASE + 0x2c0)
 #define PHYCTRL_OOB_RESTART_MSK		(PORT_BASE + 0x2c4)
+
+/* Completion header */
+/* dw0 */
+#define CMPLT_HDR_CMPLT_OFF		0
+#define CMPLT_HDR_CMPLT_MSK		(0x3 << CMPLT_HDR_CMPLT_OFF)
+#define CMPLT_HDR_ERROR_PHASE_OFF   2
+#define CMPLT_HDR_ERROR_PHASE_MSK   (0xff << CMPLT_HDR_ERROR_PHASE_OFF)
+#define CMPLT_HDR_RSPNS_XFRD_OFF	10
+#define CMPLT_HDR_RSPNS_XFRD_MSK	(0x1 << CMPLT_HDR_RSPNS_XFRD_OFF)
+#define CMPLT_HDR_ERX_OFF		12
+#define CMPLT_HDR_ERX_MSK		(0x1 << CMPLT_HDR_ERX_OFF)
+#define CMPLT_HDR_ABORT_STAT_OFF	13
+#define CMPLT_HDR_ABORT_STAT_MSK	(0x7 << CMPLT_HDR_ABORT_STAT_OFF)
+/* abort_stat */
+#define STAT_IO_NOT_VALID		0x1
+#define STAT_IO_NO_DEVICE		0x2
+#define STAT_IO_COMPLETE		0x3
+#define STAT_IO_ABORTED			0x4
+/* dw1 */
+#define CMPLT_HDR_IPTT_OFF		0
+#define CMPLT_HDR_IPTT_MSK		(0xffff << CMPLT_HDR_IPTT_OFF)
+#define CMPLT_HDR_DEV_ID_OFF		16
+#define CMPLT_HDR_DEV_ID_MSK		(0xffff << CMPLT_HDR_DEV_ID_OFF)
+/* dw3 */
+#define CMPLT_HDR_IO_IN_TARGET_OFF	17
+#define CMPLT_HDR_IO_IN_TARGET_MSK	(0x1 << CMPLT_HDR_IO_IN_TARGET_OFF)
+
 struct hisi_sas_complete_v3_hdr {
 	__le32 dw0;
 	__le32 dw1;
@@ -163,6 +190,8 @@ struct hisi_sas_complete_v3_hdr {
 	__le32 dw3;
 };
 
+#define IO_RX_DATA_LEN_UNDERFLOW_OFF	6
+#define IO_RX_DATA_LEN_UNDERFLOW_MSK	(1 << IO_RX_DATA_LEN_UNDERFLOW_OFF)
 #define HISI_SAS_COMMAND_ENTRIES_V3_HW 4096
 #define HISI_SAS_MSI_COUNT_V3_HW 32
 
@@ -624,6 +653,286 @@ static irqreturn_t int_chnl_int_v3_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
+static void slot_err_v3_hw(struct hisi_hba *hisi_hba,
+				struct sas_task *task,
+				struct hisi_sas_slot *slot)
+{
+	struct task_status_struct *ts = &task->task_status;
+	struct hisi_sas_complete_v3_hdr *complete_queue =
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_v3_hdr *complete_hdr =
+			&complete_queue[slot->cmplt_queue_slot];
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		if (complete_hdr->dw3 & CMPLT_HDR_IO_IN_TARGET_MSK) {
+			ts->stat = SAS_QUEUE_FULL;
+			slot->abort = 1;
+		} else {
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		}
+	}
+		break;
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		if (complete_hdr->dw3 & CMPLT_HDR_IO_IN_TARGET_MSK) {
+			ts->stat = SAS_PHY_DOWN;
+			slot->abort = 1;
+		} else {
+			ts->stat = SAS_OPEN_REJECT;
+			ts->open_rej_reason = SAS_OREJ_RSVD_RETRY;
+		}
+	    hisi_sas_sata_done(task, slot);
+	}
+		break;
+	case SAS_PROTOCOL_SMP:
+	    ts->stat = SAM_STAT_CHECK_CONDITION;
+		break;
+	default:
+		break;
+	}
+}
+
+static int
+slot_complete_v3_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_device *sas_dev;
+	struct device *dev = hisi_hba->dev;
+	struct task_status_struct *ts;
+	struct domain_device *device;
+	enum exec_status sts;
+	u32 *error_info = slot->status_buffer;
+	struct hisi_sas_complete_v3_hdr *complete_queue =
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_v3_hdr *complete_hdr =
+			&complete_queue[slot->cmplt_queue_slot];
+	int aborted;
+	unsigned long flags;
+
+	if (unlikely(!task || !task->lldd_task || !task->dev))
+		return -EINVAL;
+
+	ts = &task->task_status;
+	device = task->dev;
+	sas_dev = device->lldd_dev;
+
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	aborted = task->task_state_flags & SAS_TASK_STATE_ABORTED;
+	task->task_state_flags &=
+		~(SAS_TASK_STATE_PENDING | SAS_TASK_AT_INITIATOR);
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+
+	memset(ts, 0, sizeof(*ts));
+	ts->resp = SAS_TASK_COMPLETE;
+	if (unlikely(aborted)) {
+		ts->stat = SAS_ABORTED_TASK;
+		hisi_sas_slot_task_free(hisi_hba, task, slot);
+		return -1;
+	}
+
+	if (unlikely(!sas_dev)) {
+		dev_dbg(dev, "slot complete: port has not device\n");
+		ts->stat = SAS_PHY_DOWN;
+		goto out;
+	}
+
+	/*
+	 * Use SAS+TMF status codes
+	 */
+	switch ((complete_hdr->dw0 & CMPLT_HDR_ABORT_STAT_MSK)
+			>> CMPLT_HDR_ABORT_STAT_OFF) {
+	case STAT_IO_ABORTED:
+		/* this IO has been aborted by abort command */
+		ts->stat = SAS_ABORTED_TASK;
+		goto out;
+	case STAT_IO_COMPLETE:
+		/* internal abort command complete */
+		ts->stat = TMF_RESP_FUNC_SUCC;
+		goto out;
+	case STAT_IO_NO_DEVICE:
+		ts->stat = TMF_RESP_FUNC_COMPLETE;
+		goto out;
+	case STAT_IO_NOT_VALID:
+		/*
+		 * abort single IO, the controller can't find the IO
+		 */
+		ts->stat = TMF_RESP_FUNC_FAILED;
+		goto out;
+	default:
+		break;
+	}
+
+	if ((complete_hdr->dw0 & CMPLT_HDR_CMPLT_MSK) == 0x3 &&
+				(!(error_info[3] &
+				IO_RX_DATA_LEN_UNDERFLOW_MSK) ||
+				hisi_sas_is_rw_cmd(task))) {
+		if ((complete_hdr->dw0 &
+					CMPLT_HDR_ERROR_PHASE_MSK) == 0x1) {
+			/* error happens on parse DQ entry */
+			dev_dbg(dev, "Error happens on parse DQ entry!\n");
+		} else if ((complete_hdr->dw0 &
+					CMPLT_HDR_ERROR_PHASE_MSK) == 0x80) {
+			/* error happens on ITCT or IOST configuration */
+			dev_dbg(dev, "Error happens on ITCT or IOST configuration!\n");
+		} else {
+			/* error info is recorded in memory*/
+			dev_dbg(dev, "Error info: 0x%x, 0x%x, 0x%x, 0x%x\n",
+					error_info[0], error_info[1],
+					error_info[2], error_info[3]);
+		}
+
+		slot_err_v3_hw(hisi_hba, task, slot);
+		if (unlikely(slot->abort))
+			return ts->stat;
+		goto out;
+	}
+
+	switch (task->task_proto) {
+	case SAS_PROTOCOL_SSP:
+	{
+		struct ssp_response_iu *iu = slot->status_buffer +
+			sizeof(struct hisi_sas_err_record);
+
+		sas_ssp_task_response(dev, task, iu);
+		break;
+	}
+	case SAS_PROTOCOL_SMP:
+	{
+		struct scatterlist *sg_resp = &task->smp_task.smp_resp;
+		void *to;
+
+		ts->stat = SAM_STAT_GOOD;
+		to = kmap_atomic(sg_page(sg_resp));
+
+		dma_unmap_sg(dev, &task->smp_task.smp_resp, 1,
+			     DMA_FROM_DEVICE);
+		dma_unmap_sg(dev, &task->smp_task.smp_req, 1,
+			     DMA_TO_DEVICE);
+		memcpy(to + sg_resp->offset,
+		       slot->status_buffer +
+		       sizeof(struct hisi_sas_err_record),
+		       sg_dma_len(sg_resp));
+		kunmap_atomic(to);
+		break;
+	}
+	case SAS_PROTOCOL_SATA:
+	case SAS_PROTOCOL_STP:
+	case SAS_PROTOCOL_SATA | SAS_PROTOCOL_STP:
+	{
+		ts->stat = SAM_STAT_GOOD;
+		hisi_sas_sata_done(task, slot);
+		break;
+	}
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
+	spin_lock_irqsave(&task->task_state_lock, flags);
+	task->task_state_flags |= SAS_TASK_STATE_DONE;
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	spin_lock_irqsave(&hisi_hba->lock, flags);
+	hisi_sas_slot_task_free(hisi_hba, task, slot);
+	spin_unlock_irqrestore(&hisi_hba->lock, flags);
+	sts = ts->stat;
+
+	if (task->task_done)
+		task->task_done(task);
+
+	return sts;
+}
+
+static void cq_tasklet_v3_hw(unsigned long val)
+{
+	struct hisi_sas_cq *cq = (struct hisi_sas_cq *)val;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	struct hisi_sas_slot *slot;
+	struct hisi_sas_itct *itct;
+	struct hisi_sas_complete_v3_hdr *complete_queue;
+	u32 rd_point = cq->rd_point, wr_point, dev_id;
+	int queue = cq->id;
+	struct hisi_sas_dq *dq = &hisi_hba->dq[queue];
+
+	complete_queue = hisi_hba->complete_hdr[queue];
+
+	spin_lock(&dq->lock);
+	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
+				   (0x14 * queue));
+
+	while (rd_point != wr_point) {
+		struct hisi_sas_complete_v3_hdr *complete_hdr;
+		int iptt;
+
+		complete_hdr = &complete_queue[rd_point];
+
+		/* Check for NCQ completion */
+		if (complete_hdr->act) {
+			u32 act_tmp = complete_hdr->act;
+			int ncq_tag_count = ffs(act_tmp);
+
+			dev_id = (complete_hdr->dw1 & CMPLT_HDR_DEV_ID_MSK) >>
+				 CMPLT_HDR_DEV_ID_OFF;
+			itct = &hisi_hba->itct[dev_id];
+
+			/* The NCQ tags are held in the itct header */
+			while (ncq_tag_count) {
+				__le64 *ncq_tag = &itct->qw4_15[0];
+
+				ncq_tag_count -= 1;
+				iptt = (ncq_tag[ncq_tag_count / 5]
+					>> (ncq_tag_count % 5) * 12) & 0xfff;
+
+				slot = &hisi_hba->slot_info[iptt];
+				slot->cmplt_queue_slot = rd_point;
+				slot->cmplt_queue = queue;
+				slot_complete_v3_hw(hisi_hba, slot);
+
+				act_tmp &= ~(1 << ncq_tag_count);
+				ncq_tag_count = ffs(act_tmp);
+			}
+		} else {
+			iptt = (complete_hdr->dw1) & CMPLT_HDR_IPTT_MSK;
+			slot = &hisi_hba->slot_info[iptt];
+			slot->cmplt_queue_slot = rd_point;
+			slot->cmplt_queue = queue;
+			slot_complete_v3_hw(hisi_hba, slot);
+		}
+
+		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
+			rd_point = 0;
+	}
+
+	/* update rd_point */
+	cq->rd_point = rd_point;
+	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+	spin_unlock(&dq->lock);
+}
+
+static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	int queue = cq->id;
+
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+
+	tasklet_schedule(&cq->tasklet);
+
+	return IRQ_HANDLED;
+}
+
 static irq_handler_t phy_interrupts[HISI_SAS_PHY_INT_NR] = {
 	int_phy_up_down_bcast_v3_hw,
 	int_chnl_int_v3_hw,
@@ -670,6 +979,29 @@ static int interrupt_init_v3_hw(struct hisi_hba *hisi_hba)
 		}
 	}
 
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		int idx = i + 16; /* First cq interrupt is irq16 */
+		struct hisi_sas_cq *cq = &hisi_hba->cq[i];
+		struct tasklet_struct *t = &cq->tasklet;
+
+		irq = msi_vectors[idx];
+		if (!irq) {
+			dev_err(dev,
+				"irq init: could not map cq interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+		rc = devm_request_irq(dev, irq, cq_interrupt_v3_hw, 0,
+				      DRV_NAME " cq", &hisi_hba->cq[i]);
+		if (rc) {
+			dev_err(dev,
+				"irq init: could not request cq interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+		tasklet_init(t, cq_tasklet_v3_hw, (unsigned long)cq);
+	}
+
 	return 0;
 }
 
-- 
1.9.1
