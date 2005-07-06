From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 8/17]  qla2xxx: Add ISP24xx IOCB manipulation routines.
Date: Wed,  6 Jul 2005 10:31:17 -0700 (PDT)
Message-ID: <20050706173117.10568.5255.sendpatchset@plap.qlogic.com>
References: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:32594 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S262421AbVGFRbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2005 13:31:18 -0400
In-Reply-To: <20050706172955.10568.87971.sendpatchset@plap.qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

Add ISP24xx IOCB manipulation routines.

Add appropriate glue-code for ISP24xx support while
manipulting IOCB packets.  Add an ISP24xx specific
'start_scsi' routine due to command-type-7 layout
changes.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---

 drivers/scsi/qla2xxx/qla_gbl.h    |    1 
 drivers/scsi/qla2xxx/qla_inline.h |   13 +
 drivers/scsi/qla2xxx/qla_iocb.c   |  325 +++++++++++++++++++++++++++++++++++--
 3 files changed, 323 insertions(+), 16 deletions(-)

ea9b892ded10bf99b1e155426ddce745cb865d1f
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -94,6 +94,7 @@ extern uint16_t qla2x00_calc_iocbs_64(ui
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
 extern void qla2x00_build_scsi_iocbs_64(srb_t *, cmd_entry_t *, uint16_t);
 extern int qla2x00_start_scsi(srb_t *sp);
+extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
 int __qla2x00_marker(scsi_qla_host_t *, uint16_t, uint16_t, uint8_t);
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -236,6 +236,19 @@ qla2x00_delete_timer_from_cmd(srb_t *sp)
 	}
 }
 
+static inline uint8_t *host_to_fcp_swap(uint8_t *, uint32_t);
+static inline uint8_t *
+host_to_fcp_swap(uint8_t *fcp, uint32_t bsize)
+{
+       uint32_t *ifcp = (uint32_t *) fcp;
+       uint32_t *ofcp = (uint32_t *) fcp;
+       uint32_t iter = bsize >> 2;
+
+       for (; iter ; iter--)
+               *ofcp++ = swab32(*ifcp++);
+
+       return fcp;
+}
 
 static inline int qla2x00_is_reserved_id(scsi_qla_host_t *, uint16_t);
 static inline int
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -468,29 +468,37 @@ queuing_error:
  *
  * Returns non-zero if a failure occured, else zero.
  */
-int
+int 
 __qla2x00_marker(scsi_qla_host_t *ha, uint16_t loop_id, uint16_t lun,
     uint8_t type)
 {
-	mrk_entry_t	*pkt;
+	mrk_entry_t *mrk;
+	struct mrk_entry_24xx *mrk24;
 
-	pkt = (mrk_entry_t *)qla2x00_req_pkt(ha);
-	if (pkt == NULL) {
-		DEBUG2_3(printk("%s(): **** FAILED ****\n", __func__));
+	mrk24 = NULL;
+	mrk = (mrk_entry_t *)qla2x00_req_pkt(ha);
+	if (mrk == NULL) {
+		DEBUG2_3(printk("%s(%ld): failed to allocate Marker IOCB.\n",
+		    __func__, ha->host_no));
 
 		return (QLA_FUNCTION_FAILED);
 	}
 
-	pkt->entry_type = MARKER_TYPE;
-	pkt->modifier = type;
-
+	mrk->entry_type = MARKER_TYPE;
+	mrk->modifier = type;
 	if (type != MK_SYNC_ALL) {
-		pkt->lun = cpu_to_le16(lun);
-		SET_TARGET_ID(ha, pkt->target, loop_id);
+		if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+			mrk24 = (struct mrk_entry_24xx *) mrk;
+			mrk24->nport_handle = cpu_to_le16(loop_id);
+			mrk24->lun[1] = LSB(lun);
+			mrk24->lun[2] = MSB(lun);
+		} else {
+			SET_TARGET_ID(ha, mrk->target, loop_id);
+			mrk->lun = cpu_to_le16(lun);
+		}
 	}
 	wmb();
 
-	/* Issue command to ISP */
 	qla2x00_isp_cmd(ha);
 
 	return (QLA_SUCCESS);
@@ -521,7 +529,7 @@ qla2x00_marker(scsi_qla_host_t *ha, uint
 static request_t *
 qla2x00_req_pkt(scsi_qla_host_t *ha)
 {
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	device_reg_t __iomem *reg = ha->iobase;
 	request_t	*pkt = NULL;
 	uint16_t	cnt;
 	uint32_t	*dword_ptr;
@@ -532,7 +540,12 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 	for (timer = HZ; timer; timer--) {
 		if ((req_cnt + 2) >= ha->req_q_cnt) {
 			/* Calculate number of free request entries. */
-			cnt = qla2x00_debounce_register(ISP_REQ_Q_OUT(ha, reg));
+			if (IS_QLA24XX(ha) || IS_QLA25XX(ha))
+				cnt = (uint16_t)RD_REG_DWORD(
+				    &reg->isp24.req_q_out);
+			else
+				cnt = qla2x00_debounce_register(
+				    ISP_REQ_Q_OUT(ha, &reg->isp));
 			if  (ha->req_ring_index < cnt)
 				ha->req_q_cnt = cnt - ha->req_ring_index;
 			else
@@ -586,7 +599,7 @@ qla2x00_req_pkt(scsi_qla_host_t *ha)
 void
 qla2x00_isp_cmd(scsi_qla_host_t *ha)
 {
-	struct device_reg_2xxx __iomem *reg = &ha->iobase->isp;
+	device_reg_t __iomem *reg = ha->iobase;
 
 	DEBUG5(printk("%s(): IOCB data:\n", __func__));
 	DEBUG5(qla2x00_dump_buffer(
@@ -601,6 +614,286 @@ qla2x00_isp_cmd(scsi_qla_host_t *ha)
 		ha->request_ring_ptr++;
 
 	/* Set chip new ring index. */
-	WRT_REG_WORD(ISP_REQ_Q_IN(ha, reg), ha->req_ring_index);
-	RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, reg));	/* PCI Posting. */
+	if (IS_QLA24XX(ha) || IS_QLA25XX(ha)) {
+		WRT_REG_DWORD(&reg->isp24.req_q_in, ha->req_ring_index);
+		RD_REG_DWORD_RELAXED(&reg->isp24.req_q_in);
+	} else {
+		WRT_REG_WORD(ISP_REQ_Q_IN(ha, &reg->isp), ha->req_ring_index);
+		RD_REG_WORD_RELAXED(ISP_REQ_Q_IN(ha, &reg->isp));
+	}
+
+}
+
+/**
+ * qla24xx_calc_iocbs() - Determine number of Command Type 3 and
+ * Continuation Type 1 IOCBs to allocate.
+ *
+ * @dsds: number of data segment decriptors needed
+ *
+ * Returns the number of IOCB entries needed to store @dsds.
+ */
+static inline uint16_t
+qla24xx_calc_iocbs(uint16_t dsds)
+{
+	uint16_t iocbs;
+
+	iocbs = 1;
+	if (dsds > 1) {
+		iocbs += (dsds - 1) / 5;
+		if ((dsds - 1) % 5)
+			iocbs++;
+	}
+	return iocbs;
+}
+
+/**
+ * qla24xx_build_scsi_iocbs() - Build IOCB command utilizing Command Type 7
+ * IOCB types.
+ *
+ * @sp: SRB command to process
+ * @cmd_pkt: Command type 3 IOCB
+ * @tot_dsds: Total number of segments to transfer
+ */
+static inline void
+qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
+    uint16_t tot_dsds)
+{
+	uint16_t	avail_dsds;
+	uint32_t	*cur_dsd;
+	scsi_qla_host_t	*ha;
+	struct scsi_cmnd *cmd;
+
+	cmd = sp->cmd;
+
+	/* Update entry type to indicate Command Type 3 IOCB */
+	*((uint32_t *)(&cmd_pkt->entry_type)) =
+	    __constant_cpu_to_le32(COMMAND_TYPE_7);
+
+	/* No data transfer */
+	if (cmd->request_bufflen == 0 || cmd->sc_data_direction == DMA_NONE) {
+		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
+		return;
+	}
+
+	ha = sp->ha;
+
+	/* Set transfer direction */
+	if (cmd->sc_data_direction == DMA_TO_DEVICE)
+		cmd_pkt->task_mgmt_flags =
+		    __constant_cpu_to_le16(TMF_WRITE_DATA);
+	else if (cmd->sc_data_direction == DMA_FROM_DEVICE)
+		cmd_pkt->task_mgmt_flags =
+		    __constant_cpu_to_le16(TMF_READ_DATA);
+
+	/* One DSD is available in the Command Type 3 IOCB */
+	avail_dsds = 1;
+	cur_dsd = (uint32_t *)&cmd_pkt->dseg_0_address;
+
+	/* Load data segments */
+	if (cmd->use_sg != 0) {
+		struct	scatterlist *cur_seg;
+		struct	scatterlist *end_seg;
+
+		cur_seg = (struct scatterlist *)cmd->request_buffer;
+		end_seg = cur_seg + tot_dsds;
+		while (cur_seg < end_seg) {
+			dma_addr_t	sle_dma;
+			cont_a64_entry_t *cont_pkt;
+
+			/* Allocate additional continuation packets? */
+			if (avail_dsds == 0) {
+				/*
+				 * Five DSDs are available in the Continuation
+				 * Type 1 IOCB.
+				 */
+				cont_pkt = qla2x00_prep_cont_type1_iocb(ha);
+				cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
+				avail_dsds = 5;
+			}
+
+			sle_dma = sg_dma_address(cur_seg);
+			*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
+			*cur_dsd++ = cpu_to_le32(sg_dma_len(cur_seg));
+			avail_dsds--;
+
+			cur_seg++;
+		}
+	} else {
+		*cur_dsd++ = cpu_to_le32(LSD(sp->dma_handle));
+		*cur_dsd++ = cpu_to_le32(MSD(sp->dma_handle));
+		*cur_dsd++ = cpu_to_le32(cmd->request_bufflen);
+	}
+}
+
+
+/**
+ * qla24xx_start_scsi() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occured, else zero.
+ */
+int
+qla24xx_start_scsi(srb_t *sp)
+{
+	int		ret;
+	unsigned long   flags;
+	scsi_qla_host_t	*ha;
+	struct scsi_cmnd *cmd;
+	uint32_t	*clr_ptr;
+	uint32_t        index;
+	uint32_t	handle;
+	struct cmd_type_7 *cmd_pkt;
+	struct scatterlist *sg;
+	uint16_t	cnt;
+	uint16_t	req_cnt;
+	uint16_t	tot_dsds;
+	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
+	char		tag[2];
+
+	/* Setup device pointers. */
+	ret = 0;
+	ha = sp->ha;
+	reg = &ha->iobase->isp24;
+	cmd = sp->cmd;
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (ha->marker_needed != 0) {
+		if (qla2x00_marker(ha, 0, 0, MK_SYNC_ALL) != QLA_SUCCESS) {
+			return QLA_FUNCTION_FAILED;
+		}
+		ha->marker_needed = 0;
+	}
+
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = ha->current_outstanding_cmd;
+	for (index = 1; index < MAX_OUTSTANDING_COMMANDS; index++) {
+		handle++;
+		if (handle == MAX_OUTSTANDING_COMMANDS)
+			handle = 1;
+		if (ha->outstanding_cmds[handle] == 0)
+			break;
+	}
+	if (index == MAX_OUTSTANDING_COMMANDS)
+		goto queuing_error;
+
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (cmd->use_sg) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		tot_dsds = pci_map_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+		if (tot_dsds == 0)
+			goto queuing_error;
+	} else if (cmd->request_bufflen) {
+		dma_addr_t      req_dma;
+
+		req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+		if (dma_mapping_error(req_dma))
+			goto queuing_error;
+
+		sp->dma_handle = req_dma;
+		tot_dsds = 1;
+	}
+
+	req_cnt = qla24xx_calc_iocbs(tot_dsds);
+	if (ha->req_q_cnt < (req_cnt + 2)) {
+		cnt = (uint16_t)RD_REG_DWORD_RELAXED(&reg->req_q_out);
+		if (ha->req_ring_index < cnt)
+			ha->req_q_cnt = cnt - ha->req_ring_index;
+		else
+			ha->req_q_cnt = ha->request_q_length -
+				(ha->req_ring_index - cnt);
+	}
+	if (ha->req_q_cnt < (req_cnt + 2)) {
+		if  (cmd->use_sg)
+			pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
+					cmd->sc_data_direction);
+		goto queuing_error;
+	}
+
+	/* Build command packet. */
+	ha->current_outstanding_cmd = handle;
+	ha->outstanding_cmds[handle] = sp;
+	sp->ha = ha;
+	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	ha->req_q_cnt -= req_cnt;
+
+	cmd_pkt = (struct cmd_type_7 *)ha->request_ring_ptr;
+	cmd_pkt->handle = handle;
+
+	/* Zero out remaining portion of packet. */
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* Set NPORT-ID and LUN number*/
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+
+	cmd_pkt->lun[1] = LSB(sp->cmd->device->lun);
+	cmd_pkt->lun[2] = MSB(sp->cmd->device->lun);
+
+	/* Update tagged queuing modifier -- default is TSK_SIMPLE (0). */
+	if (scsi_populate_tag_msg(cmd, tag)) {
+		switch (tag[0]) {
+		case MSG_HEAD_TAG:
+			cmd_pkt->task = TSK_HEAD_OF_QUEUE;
+			break;
+		case MSG_ORDERED_TAG:
+			cmd_pkt->task = TSK_ORDERED;
+			break;
+		}
+	}
+
+	/* Load SCSI command packet. */
+	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)cmd->request_bufflen);
+
+	/* Build IOCB segments */
+	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds);
+
+	/* Set total data segment count. */
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	wmb();
+
+	/* Adjust ring index. */
+	ha->req_ring_index++;
+	if (ha->req_ring_index == ha->request_q_length) {
+		ha->req_ring_index = 0;
+		ha->request_ring_ptr = ha->request_ring;
+	} else
+		ha->request_ring_ptr++;
+
+	sp->flags |= SRB_DMA_VALID;
+	sp->state = SRB_ACTIVE_STATE;
+
+	/* Set chip new ring index. */
+	WRT_REG_DWORD(&reg->req_q_in, ha->req_ring_index);
+	RD_REG_DWORD_RELAXED(&reg->req_q_in);		/* PCI Posting. */
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	return QLA_SUCCESS;
+
+queuing_error:
+	if (cmd->use_sg && tot_dsds) {
+		sg = (struct scatterlist *) cmd->request_buffer;
+		pci_unmap_sg(ha->pdev, sg, cmd->use_sg,
+		    cmd->sc_data_direction);
+	} else if (tot_dsds) {
+		pci_unmap_single(ha->pdev, sp->dma_handle,
+		    cmd->request_bufflen, cmd->sc_data_direction);
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	return QLA_FUNCTION_FAILED;
 }

-- 
Andrew Vasquez
