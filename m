From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: changes in multiq code
Date: Thu, 18 Dec 2008 10:06:15 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0812180950290.1015@ac-mac.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:33423 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYLRSGR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Dec 2008 13:06:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

Following changes have been made:
 1. Scan outstanding commands only in the queue where it is submitted
 2. Update queue registers directly in the fast path
 3. Queue specific BAR is remapped only for multiq capable adapters

Please apply.
Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_def.h    |    7 ++-
 drivers/scsi/qla2xxx/qla_gbl.h    |    6 ++
 drivers/scsi/qla2xxx/qla_init.c   |    4 +-
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |   68 +++++++++-----
 drivers/scsi/qla2xxx/qla_isr.c    |   22 ++++--
 drivers/scsi/qla2xxx/qla_mbx.c    |    4 +-
 drivers/scsi/qla2xxx/qla_os.c     |  178 ++++++++++++++++++++----------------
 8 files changed, 175 insertions(+), 116 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 5ecf292..a29c952 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -181,11 +181,14 @@
 #define RESPONSE_ENTRY_CNT_2100		64	/* Number of response entries.*/
 #define RESPONSE_ENTRY_CNT_2300		512	/* Number of response entries.*/
 
+struct req_que;
+
 /*
  * SCSI Request Block
  */
 typedef struct srb {
 	struct scsi_qla_host *vha;	/* HA the SP is queued on */
+	struct req_que *que;
 	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
@@ -2045,7 +2048,6 @@ typedef struct vport_params {
 #define VP_RET_CODE_NOT_FOUND		6
 
 struct qla_hw_data;
-struct req_que;
 
 /*
  * ISP operations
@@ -2101,6 +2103,9 @@ struct isp_operations {
 
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
 	int (*start_scsi) (srb_t *);
+	void (*wrt_req_reg) (struct qla_hw_data *, uint16_t, uint16_t);
+	void (*wrt_rsp_reg) (struct qla_hw_data *, uint16_t, uint16_t);
+	uint16_t (*rd_req_reg) (struct qla_hw_data *, uint16_t);
 };
 
 /* MSI-X Support *************************************************************/
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index d9712b5..0011e31 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -391,4 +391,10 @@ extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_queues(struct scsi_qla_host *, uint8_t);
 extern int qla25xx_delete_queues(struct scsi_qla_host *, uint8_t);
+extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
+extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
+extern void qla24xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
+extern void qla25xx_wrt_req_reg(struct qla_hw_data *, uint16_t, uint16_t);
+extern void qla25xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
+extern void qla24xx_wrt_rsp_reg(struct qla_hw_data *, uint16_t, uint16_t);
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index b1495ec..52ed56e 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -796,7 +796,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 		if (!tc) {
 			qla_printk(KERN_WARNING, ha, "Unable to allocate "
 			    "(%d KB) for FCE.\n", FCE_SIZE / 1024);
-			goto cont_alloc;
+			goto try_eft;
 		}
 
 		memset(tc, 0, FCE_SIZE);
@@ -808,7 +808,7 @@ qla2x00_alloc_fw_dump(scsi_qla_host_t *vha)
 			dma_free_coherent(&ha->pdev->dev, FCE_SIZE, tc,
 			    tc_dma);
 			ha->flags.fce_enabled = 0;
-			goto cont_alloc;
+			goto try_eft;
 		}
 
 		qla_printk(KERN_INFO, ha, "Allocated (%d KB) for FCE...\n",
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 507a6e9..5e0a709 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -63,4 +63,4 @@ qla2x00_is_reserved_id(scsi_qla_host_t *vha, uint16_t loop_id)
 
 	return ((loop_id > ha->max_loop_id && loop_id < SNS_FIRST_LOOP_ID) ||
 	    loop_id == MANAGEMENT_SERVER || loop_id == BROADCAST);
-};
+}
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 6d2bd97..5bedc9d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -160,7 +160,6 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scatterlist *sg;
 	int i;
 	struct req_que *req;
-	uint16_t que_id;
 
 	cmd = sp->cmd;
 
@@ -175,8 +174,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->vha;
-	que_id = vha->req_ques[0];
-	req = vha->hw->req_q_map[que_id];
+	req = sp->que;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -223,7 +221,6 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scatterlist *sg;
 	int i;
 	struct req_que *req;
-	uint16_t que_id;
 
 	cmd = sp->cmd;
 
@@ -238,8 +235,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->vha;
-	que_id = vha->req_ques[0];
-	req = vha->hw->req_q_map[que_id];
+	req = sp->que;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
@@ -358,6 +354,7 @@ qla2x00_start_scsi(srb_t *sp)
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
 	sp->vha = vha;
+	sp->que = req;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
@@ -573,6 +570,7 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 {
 	struct qla_hw_data *ha = vha->hw;
 	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
+	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
@@ -587,8 +585,10 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 		req->ring_ptr++;
 
 	/* Set chip new ring index. */
-	if (ha->mqenable)
-		RD_REG_DWORD(&reg->isp25mq.req_q_out);
+	if (ha->mqenable) {
+		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
+		RD_REG_DWORD(&ioreg->hccr);
+	}
 	else {
 		if (IS_FWI2_CAPABLE(ha)) {
 			WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
@@ -642,7 +642,6 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
-	uint16_t que_id;
 	struct req_que *req;
 
 	cmd = sp->cmd;
@@ -658,8 +657,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->vha;
-	que_id = vha->req_ques[0];
-	req = vha->hw->req_q_map[que_id];
+	req = sp->que;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -727,7 +725,6 @@ qla24xx_start_scsi(srb_t *sp)
 	struct scsi_cmnd *cmd = sp->cmd;
 	struct scsi_qla_host *vha = sp->vha;
 	struct qla_hw_data *ha = vha->hw;
-	device_reg_t __iomem *reg;
 	uint16_t que_id;
 
 	/* Setup device pointers. */
@@ -735,7 +732,7 @@ qla24xx_start_scsi(srb_t *sp)
 	que_id = vha->req_ques[0];
 
 	req = ha->req_q_map[que_id];
-	reg = ISP_QUE_REG(ha, req->id);
+	sp->que = req;
 
 	if (req->rsp)
 		rsp = req->rsp;
@@ -780,12 +777,7 @@ qla24xx_start_scsi(srb_t *sp)
 
 	req_cnt = qla24xx_calc_iocbs(tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
-		if (ha->mqenable)
-			cnt = (uint16_t)
-				RD_REG_DWORD_RELAXED(&reg->isp25mq.req_q_out);
-		else
-			cnt = (uint16_t)
-				RD_REG_DWORD_RELAXED(&reg->isp24.req_q_out);
+		cnt = ha->isp_ops->rd_req_reg(ha, req->id);
 
 		if (req->ring_index < cnt)
 			req->cnt = cnt - req->ring_index;
@@ -846,12 +838,7 @@ qla24xx_start_scsi(srb_t *sp)
 	sp->flags |= SRB_DMA_VALID;
 
 	/* Set chip new ring index. */
-	if (ha->mqenable)
-		WRT_REG_DWORD(&reg->isp25mq.req_q_in, req->ring_index);
-	else {
-		WRT_REG_DWORD(&reg->isp24.req_q_in, req->ring_index);
-		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
-	}
+	ha->isp_ops->wrt_req_reg(ha, req->id, req->ring_index);
 
 	/* Manage unprocessed RIO/ZIO commands in response queue. */
 	if (vha->flags.process_response_queue &&
@@ -870,3 +857,34 @@ queuing_error:
 	return QLA_FUNCTION_FAILED;
 }
 
+uint16_t
+qla24xx_rd_req_reg(struct qla_hw_data *ha, uint16_t id)
+{
+	device_reg_t __iomem *reg = (void *) ha->iobase;
+	return RD_REG_DWORD_RELAXED(&reg->isp24.req_q_out);
+}
+
+uint16_t
+qla25xx_rd_req_reg(struct qla_hw_data *ha, uint16_t id)
+{
+	device_reg_t __iomem *reg = (void *) ha->mqiobase + QLA_QUE_PAGE * id;
+	return RD_REG_DWORD_RELAXED(&reg->isp25mq.req_q_out);
+}
+
+void
+qla24xx_wrt_req_reg(struct qla_hw_data *ha, uint16_t id, uint16_t index)
+{
+	device_reg_t __iomem *reg = (void *) ha->iobase;
+	WRT_REG_DWORD(&reg->isp24.req_q_in, index);
+	RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+}
+
+void
+qla25xx_wrt_req_reg(struct qla_hw_data *ha, uint16_t id, uint16_t index)
+{
+	device_reg_t __iomem *reg = (void *) ha->mqiobase + QLA_QUE_PAGE * id;
+	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
+	WRT_REG_DWORD(&reg->isp25mq.req_q_in, index);
+	RD_REG_DWORD(&ioreg->hccr); /* PCI posting */
+}
+
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index eb4b43d..d5fb79a 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1446,7 +1446,6 @@ void
 qla24xx_process_response_queue(struct rsp_que *rsp)
 {
 	struct qla_hw_data *ha = rsp->hw;
-	device_reg_t __iomem *reg = ISP_QUE_REG(ha, rsp->id);
 	struct sts_entry_24xx *pkt;
 	struct scsi_qla_host *vha;
 
@@ -1500,10 +1499,7 @@ qla24xx_process_response_queue(struct rsp_que *rsp)
 	}
 
 	/* Adjust ring index */
-	if (ha->mqenable)
-		WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, rsp->ring_index);
-	else
-		WRT_REG_DWORD(&reg->isp24.rsp_q_out, rsp->ring_index);
+	ha->isp_ops->wrt_rsp_reg(ha, rsp->id, rsp->ring_index);
 }
 
 static void
@@ -1702,7 +1698,7 @@ qla25xx_msix_rsp_q(int irq, void *dev_id)
 	if (!rsp->id)
 		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_22);
 	else
-		msix_disabled_hccr &= BIT_6;
+		msix_disabled_hccr &= __constant_cpu_to_le32(BIT_6);
 
 	qla24xx_process_response_queue(rsp);
 
@@ -2077,3 +2073,17 @@ int qla25xx_request_irq(struct rsp_que *rsp)
 	return ret;
 }
 
+void
+qla25xx_wrt_rsp_reg(struct qla_hw_data *ha, uint16_t id, uint16_t index)
+{
+	device_reg_t __iomem *reg = (void *) ha->mqiobase + QLA_QUE_PAGE * id;
+	WRT_REG_DWORD(&reg->isp25mq.rsp_q_out, index);
+}
+
+void
+qla24xx_wrt_rsp_reg(struct qla_hw_data *ha, uint16_t id, uint16_t index)
+{
+	device_reg_t __iomem *reg = (void *) ha->iobase;
+	WRT_REG_DWORD(&reg->isp24.rsp_q_out, index);
+}
+
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c54bc97..a99976f 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3129,7 +3129,7 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req,
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	rval = (int)qla2x00_mailbox_command(vha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS)
 		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x mb0=%x.\n",
 			__func__, vha->host_no, rval, mcp->mb[0]));
@@ -3180,7 +3180,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	rval = (int)qla2x00_mailbox_command(vha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS)
 		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x "
 			"mb0=%x.\n", __func__,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9142025..8ea9277 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -441,6 +441,7 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	sp->vha = vha;
 	sp->fcport = fcport;
 	sp->cmd = cmd;
+	sp->que = ha->req_q_map[0];
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
@@ -775,13 +776,14 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 {
 	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	srb_t *sp;
-	int ret, i, que;
+	int ret, i;
 	unsigned int id, lun;
 	unsigned long serial;
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
+	srb_t *spt;
 
 	qla2x00_block_error_handler(cmd);
 
@@ -793,37 +795,36 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	id = cmd->device->id;
 	lun = cmd->device->lun;
 	serial = cmd->serial_number;
+	spt = (srb_t *) CMD_SP(cmd);
+	if (!spt)
+		return SUCCESS;
+	req = spt->que;
 
 	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
-		req = ha->req_q_map[vha->req_ques[que]];
-		if (!req)
-			continue;
-		for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
-			sp = req->outstanding_cmds[i];
+	for (i = 1; i < MAX_OUTSTANDING_COMMANDS; i++) {
+		sp = req->outstanding_cmds[i];
 
-			if (sp == NULL)
-				continue;
+		if (sp == NULL)
+			continue;
 
-			if (sp->cmd != cmd)
-				continue;
+		if (sp->cmd != cmd)
+			continue;
 
-			DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
-			" pid=%ld.\n", __func__, vha->host_no, sp, serial));
+		DEBUG2(printk("%s(%ld): aborting sp %p from RISC."
+		" pid=%ld.\n", __func__, vha->host_no, sp, serial));
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			if (ha->isp_ops->abort_command(vha, sp, req)) {
-				DEBUG2(printk("%s(%ld): abort_command "
-				"mbx failed.\n", __func__, vha->host_no));
-			} else {
-				DEBUG3(printk("%s(%ld): abort_command "
-				"mbx success.\n", __func__, vha->host_no));
-				wait = 1;
-			}
-			spin_lock_irqsave(&ha->hardware_lock, flags);
-			break;
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		if (ha->isp_ops->abort_command(vha, sp, req)) {
+			DEBUG2(printk("%s(%ld): abort_command "
+			"mbx failed.\n", __func__, vha->host_no));
+		} else {
+			DEBUG3(printk("%s(%ld): abort_command "
+			"mbx success.\n", __func__, vha->host_no));
+			wait = 1;
 		}
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -852,48 +853,46 @@ enum nexus_wait_type {
 
 static int
 qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
-    unsigned int l, enum nexus_wait_type type)
+	unsigned int l, srb_t *sp, enum nexus_wait_type type)
 {
-	int cnt, match, status, que;
-	srb_t *sp;
+	int cnt, match, status;
 	unsigned long flags;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
 	status = QLA_SUCCESS;
+	if (!sp)
+		return status;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < QLA_MAX_HOST_QUES; que++) {
-		req = ha->req_q_map[vha->req_ques[que]];
-		if (!req)
+	req = sp->que;
+	for (cnt = 1; status == QLA_SUCCESS &&
+		cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (!sp)
 			continue;
-		for (cnt = 1; status == QLA_SUCCESS &&
-			cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (!sp)
-				continue;
-
-			if (vha->vp_idx != sp->fcport->vha->vp_idx)
-				continue;
-			match = 0;
-			switch (type) {
-			case WAIT_HOST:
-				match = 1;
-				break;
-			case WAIT_TARGET:
-				match = sp->cmd->device->id == t;
-				break;
-			case WAIT_LUN:
-				match = (sp->cmd->device->id == t &&
-					sp->cmd->device->lun == l);
-				break;
-			}
-			if (!match)
-				continue;
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			status = qla2x00_eh_wait_on_command(sp->cmd);
-			spin_lock_irqsave(&ha->hardware_lock, flags);
+		if (vha->vp_idx != sp->fcport->vha->vp_idx)
+			continue;
+		match = 0;
+		switch (type) {
+		case WAIT_HOST:
+			match = 1;
+			break;
+		case WAIT_TARGET:
+			match = sp->cmd->device->id == t;
+			break;
+		case WAIT_LUN:
+			match = (sp->cmd->device->id == t &&
+				sp->cmd->device->lun == l);
+			break;
 		}
+		if (!match)
+			continue;
+
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		status = qla2x00_eh_wait_on_command(sp->cmd);
+		spin_lock_irqsave(&ha->hardware_lock, flags);
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
@@ -934,7 +933,7 @@ __qla2xxx_eh_generic_reset(char *name, enum nexus_wait_type type,
 		goto eh_reset_failed;
 	err = 3;
 	if (qla2x00_eh_wait_for_pending_commands(vha, cmd->device->id,
-	    cmd->device->lun, type) != QLA_SUCCESS)
+	    cmd->device->lun, (srb_t *) CMD_SP(cmd), type) != QLA_SUCCESS)
 		goto eh_reset_failed;
 
 	qla_printk(KERN_INFO, vha->hw, "scsi(%ld:%d:%d): %s RESET SUCCEEDED.\n",
@@ -992,6 +991,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
+	srb_t *sp = (srb_t *) CMD_SP(cmd);
 
 	qla2x00_block_error_handler(cmd);
 
@@ -1018,7 +1018,7 @@ qla2xxx_eh_bus_reset(struct scsi_cmnd *cmd)
 		goto eh_bus_reset_done;
 
 	/* Flush outstanding commands. */
-	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) !=
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, sp, WAIT_HOST) !=
 	    QLA_SUCCESS)
 		ret = FAILED;
 
@@ -1053,6 +1053,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	int ret = FAILED;
 	unsigned int id, lun;
 	unsigned long serial;
+	srb_t *sp = (srb_t *) CMD_SP(cmd);
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	qla2x00_block_error_handler(cmd);
@@ -1096,7 +1097,7 @@ qla2xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	}
 
 	/* Waiting for command to be returned to OS.*/
-	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST) ==
+	if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0, sp, WAIT_HOST) ==
 		QLA_SUCCESS)
 		ret = SUCCESS;
 
@@ -1368,6 +1369,9 @@ static struct isp_operations qla2100_isp_ops = {
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.wrt_req_reg		= NULL,
+	.wrt_rsp_reg		= NULL,
+	.rd_req_reg		= NULL,
 };
 
 static struct isp_operations qla2300_isp_ops = {
@@ -1403,6 +1407,9 @@ static struct isp_operations qla2300_isp_ops = {
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.wrt_req_reg		= NULL,
+	.wrt_rsp_reg		= NULL,
+	.rd_req_reg		= NULL,
 };
 
 static struct isp_operations qla24xx_isp_ops = {
@@ -1438,6 +1445,9 @@ static struct isp_operations qla24xx_isp_ops = {
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.wrt_req_reg		= qla24xx_wrt_req_reg,
+	.wrt_rsp_reg		= qla24xx_wrt_rsp_reg,
+	.rd_req_reg		= qla24xx_rd_req_reg,
 };
 
 static struct isp_operations qla25xx_isp_ops = {
@@ -1473,6 +1483,9 @@ static struct isp_operations qla25xx_isp_ops = {
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.wrt_req_reg		= qla24xx_wrt_req_reg,
+	.wrt_rsp_reg		= qla24xx_wrt_rsp_reg,
+	.rd_req_reg		= qla24xx_rd_req_reg,
 };
 
 static inline void
@@ -1616,26 +1629,27 @@ skip_pio:
 
 	/* Determine queue resources */
 	ha->max_queues = 1;
-	if (ql2xmaxqueues > 1) {
-		ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
-				pci_resource_len(ha->pdev, 3));
-		if (ha->mqiobase) {
-			/* Read MSIX vector size of the board */
-			pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL,
-						&msix);
-			ha->msix_count = msix;
-			/* Max queues are bounded by available msix vectors */
-			/* queue 0 uses two msix vectors */
-			if (ha->msix_count - 1 < ql2xmaxqueues)
-				ha->max_queues = ha->msix_count - 1;
-			else if (ql2xmaxqueues > QLA_MQ_SIZE)
-				ha->max_queues = QLA_MQ_SIZE;
-			else
-				ha->max_queues = ql2xmaxqueues;
-			qla_printk(KERN_INFO, ha,
-				"MSI-X vector count: %d\n", msix);
-		}
+	if (ql2xmaxqueues <= 1 || !IS_QLA25XX(ha))
+		goto mqiobase_exit;
+	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
+			pci_resource_len(ha->pdev, 3));
+	if (ha->mqiobase) {
+		/* Read MSIX vector size of the board */
+		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
+		ha->msix_count = msix;
+		/* Max queues are bounded by available msix vectors */
+		/* queue 0 uses two msix vectors */
+		if (ha->msix_count - 1 < ql2xmaxqueues)
+			ha->max_queues = ha->msix_count - 1;
+		else if (ql2xmaxqueues > QLA_MQ_SIZE)
+			ha->max_queues = QLA_MQ_SIZE;
+		else
+			ha->max_queues = ql2xmaxqueues;
+		qla_printk(KERN_INFO, ha,
+			"MSI-X vector count: %d\n", msix);
 	}
+
+mqiobase_exit:
 	ha->msix_count = ha->max_queues + 1;
 	return (0);
 
@@ -1852,6 +1866,12 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->rsp_q_map[0] = rsp;
 	ha->req_q_map[0] = req;
 
+	if (ha->mqenable) {
+		ha->isp_ops->wrt_req_reg = qla25xx_wrt_req_reg;
+		ha->isp_ops->wrt_rsp_reg = qla25xx_wrt_rsp_reg;
+		ha->isp_ops->rd_req_reg = qla25xx_rd_req_reg;
+	}
+
 	if (qla2x00_initialize_adapter(base_vha)) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to initialize adapter\n");
-- 
1.5.4.5

