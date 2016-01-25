From: j00310691 <john.garry@huawei.com>
Subject: [PATCH v2 16/23] hisi_sas: add v2 cq interrupt handler
Date: Tue, 26 Jan 2016 01:22:05 +0800
Message-ID: <1453742532-53092-17-git-send-email-john.garry@huawei.com>
References: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453742532-53092-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: John Garry <john.garry@huawei.com>

Also include slot_complete_v2_hw handler

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 190 +++++++++++++++++++++++++++++++++
 1 file changed, 190 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index c4a887c..099bc13 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -652,6 +652,106 @@ static int get_wideport_bitmap_v2_hw(struct hisi_hba *hisi_hba, int port_id)
 	return bitmap;
 }
 
+static int
+slot_complete_v2_hw(struct hisi_hba *hisi_hba, struct hisi_sas_slot *slot,
+		    int abort)
+{
+	struct sas_task *task = slot->task;
+	struct hisi_sas_device *sas_dev;
+	struct device *dev = &hisi_hba->pdev->dev;
+	struct task_status_struct *ts;
+	struct domain_device *device;
+	enum exec_status sts;
+	struct hisi_sas_complete_v2_hdr *complete_queue =
+			hisi_hba->complete_hdr[slot->cmplt_queue];
+	struct hisi_sas_complete_v2_hdr *complete_hdr =
+			&complete_queue[slot->cmplt_queue_slot];
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
+	if ((complete_hdr->dw0 & CMPLT_HDR_ERX_MSK) &&
+		(!(complete_hdr->dw0 & CMPLT_HDR_RSPNS_XFRD_MSK))) {
+		dev_dbg(dev, "%s slot %d has error info 0x%x\n",
+			__func__, slot->cmplt_queue_slot,
+			complete_hdr->dw0 & CMPLT_HDR_ERX_MSK);
+
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
 static int phy_up_v2_hw(int phy_no, struct hisi_hba *hisi_hba)
 {
 	int i, res = 0;
@@ -861,6 +961,74 @@ static irqreturn_t int_chnl_int_v2_hw(int irq_no, void *p)
 	return IRQ_HANDLED;
 }
 
+static irqreturn_t cq_interrupt_v2_hw(int irq_no, void *p)
+{
+	struct hisi_sas_cq *cq = p;
+	struct hisi_hba *hisi_hba = cq->hisi_hba;
+	struct hisi_sas_slot *slot;
+	struct hisi_sas_itct *itct;
+	struct hisi_sas_complete_v2_hdr *complete_queue;
+	u32 irq_value, rd_point, wr_point, dev_id;
+	int queue = cq->id;
+
+	complete_queue = hisi_hba->complete_hdr[queue];
+	irq_value = hisi_sas_read32(hisi_hba, OQ_INT_SRC);
+
+	hisi_sas_write32(hisi_hba, OQ_INT_SRC, 1 << queue);
+
+	rd_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_RD_PTR +
+				   (0x14 * queue));
+	wr_point = hisi_sas_read32(hisi_hba, COMPL_Q_0_WR_PTR +
+				   (0x14 * queue));
+
+	while (rd_point != wr_point) {
+		struct hisi_sas_complete_v2_hdr *complete_hdr;
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
+				slot_complete_v2_hw(hisi_hba, slot, 0);
+
+				act_tmp &= ~(1 << ncq_tag_count);
+				ncq_tag_count = ffs(act_tmp);
+			}
+		} else {
+			iptt = (complete_hdr->dw1) & CMPLT_HDR_IPTT_MSK;
+			slot = &hisi_hba->slot_info[iptt];
+			slot->cmplt_queue_slot = rd_point;
+			slot->cmplt_queue = queue;
+			slot_complete_v2_hw(hisi_hba, slot, 0);
+		}
+
+		if (++rd_point >= HISI_SAS_QUEUE_SLOTS)
+			rd_point = 0;
+	}
+
+	/* update rd_point */
+	hisi_sas_write32(hisi_hba, COMPL_Q_0_RD_PTR + (0x14 * queue), rd_point);
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t sata_int_v2_hw(int irq_no, void *p)
 {
 	struct hisi_sas_phy *phy = p;
@@ -1000,6 +1168,27 @@ static int interrupt_init_v2_hw(struct hisi_hba *hisi_hba)
 			return -ENOENT;
 		}
 	}
+
+	for (i = 0; i < hisi_hba->queue_count; i++) {
+		int idx = i + 96; /* First cq interrupt is irq96 */
+
+		irq = irq_map[idx];
+		if (!irq) {
+			dev_err(dev,
+				"irq init: could not map cq interrupt %d\n",
+				idx);
+			return -ENOENT;
+		}
+		rc = devm_request_irq(dev, irq, cq_interrupt_v2_hw, 0,
+				      DRV_NAME " cq", &hisi_hba->cq[i]);
+		if (rc) {
+			dev_err(dev,
+				"irq init: could not request cq interrupt %d, rc=%d\n",
+				irq, rc);
+			return -ENOENT;
+		}
+	}
+
 	return 0;
 }
 
@@ -1024,6 +1213,7 @@ static const struct hisi_sas_hw hisi_sas_v2_hw = {
 	.hw_init = hisi_sas_v2_init,
 	.sl_notify = sl_notify_v2_hw,
 	.get_wideport_bitmap = get_wideport_bitmap_v2_hw,
+	.slot_complete = slot_complete_v2_hw,
 	.max_command_entries = HISI_SAS_COMMAND_ENTRIES_V2_HW,
 	.complete_hdr_size = sizeof(struct hisi_sas_complete_v2_hdr),
 };
-- 
1.9.1
