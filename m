From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 3/5] qla2xxx: Add multiple queue pair functionality.
Date: Wed, 30 Nov 2016 12:24:55 -0800
Message-ID: <1480537497-16429-4-git-send-email-himanshu.madhani@cavium.com>
References: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0077.outbound.protection.outlook.com ([104.47.42.77]:29568
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753868AbcK3UZp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 30 Nov 2016 15:25:45 -0500
In-Reply-To: <1480537497-16429-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Michael Hernandez <michael.hernandez@cavium.com>

Replaced existing multiple queue functionality with framework
that allows for the creation of pairs of request and response queues,
either at start of day or dynamically.

Signed-off-by: Sawan Chandak <sawan.chandak@cavium.com>
Signed-off-by: Michael Hernandez <michael.hernandez@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/Makefile     |   3 +-
 drivers/scsi/qla2xxx/qla_attr.c   |  36 ++--
 drivers/scsi/qla2xxx/qla_bottom.c | 398 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_dbg.c    |   4 +-
 drivers/scsi/qla2xxx/qla_def.h    | 114 +++++++++--
 drivers/scsi/qla2xxx/qla_gbl.h    |  34 +++-
 drivers/scsi/qla2xxx/qla_init.c   |  14 +-
 drivers/scsi/qla2xxx/qla_inline.h |  30 +++
 drivers/scsi/qla2xxx/qla_iocb.c   |  56 ++----
 drivers/scsi/qla2xxx/qla_isr.c    | 109 +++++------
 drivers/scsi/qla2xxx/qla_mbx.c    |  44 +++--
 drivers/scsi/qla2xxx/qla_mid.c    | 116 +++++------
 drivers/scsi/qla2xxx/qla_mq.c     | 279 ++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_os.c     | 235 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_target.c |   4 +
 drivers/scsi/qla2xxx/qla_top.c    |  95 +++++++++
 16 files changed, 1230 insertions(+), 341 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla_bottom.c
 create mode 100644 drivers/scsi/qla2xxx/qla_mq.c
 create mode 100644 drivers/scsi/qla2xxx/qla_top.c

diff --git a/drivers/scsi/qla2xxx/Makefile b/drivers/scsi/qla2xxx/Makefile
index 44def6b..ca04260 100644
--- a/drivers/scsi/qla2xxx/Makefile
+++ b/drivers/scsi/qla2xxx/Makefile
@@ -1,6 +1,7 @@
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
 		qla_dbg.o qla_sup.o qla_attr.o qla_mid.o qla_dfs.o qla_bsg.o \
-		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o
+		qla_nx.o qla_mr.o qla_nx2.o qla_target.o qla_tmpl.o qla_mq.o \
+		qla_top.o qla_bottom.o
 
 obj-$(CONFIG_SCSI_QLA_FC) += qla2xxx.o
 obj-$(CONFIG_TCM_QLA2XXX) += tcm_qla2xxx.o
diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index fe7469c..4d0fe50b 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1988,9 +1988,9 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	scsi_qla_host_t *base_vha = shost_priv(fc_vport->shost);
 	scsi_qla_host_t *vha = NULL;
 	struct qla_hw_data *ha = base_vha->hw;
-	uint16_t options = 0;
 	int	cnt;
 	struct req_que *req = ha->req_q_map[0];
+	struct qla_qpair *qpair;
 
 	ret = qla24xx_vport_create_req_sanity_check(fc_vport);
 	if (ret) {
@@ -2075,15 +2075,9 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	qlt_vport_create(vha, ha);
 	qla24xx_vport_disable(fc_vport, disable);
 
-	if (ha->flags.cpu_affinity_enabled) {
-		req = ha->req_q_map[1];
-		ql_dbg(ql_dbg_multiq, vha, 0xc000,
-		    "Request queue %p attached with "
-		    "VP[%d], cpu affinity =%d\n",
-		    req, vha->vp_idx, ha->flags.cpu_affinity_enabled);
-		goto vport_queue;
-	} else if (ql2xmaxqueues == 1 || !ha->npiv_info)
+	if (!ql2xmqsupport || !ha->npiv_info)
 		goto vport_queue;
+
 	/* Create a request queue in QoS mode for the vport */
 	for (cnt = 0; cnt < ha->nvram_npiv_size; cnt++) {
 		if (memcmp(ha->npiv_info[cnt].port_name, vha->port_name, 8) == 0
@@ -2095,20 +2089,20 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	}
 
 	if (qos) {
-		ret = qla25xx_create_req_que(ha, options, vha->vp_idx, 0, 0,
-			qos);
-		if (!ret)
+		qpair = qla2xxx_create_qpair(vha, 0, qos, vha->vp_idx);
+		if (!qpair)
 			ql_log(ql_log_warn, vha, 0x7084,
-			    "Can't create request queue for VP[%d]\n",
+			    "Can't create qpair for VP[%d]\n",
 			    vha->vp_idx);
 		else {
 			ql_dbg(ql_dbg_multiq, vha, 0xc001,
-			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
-			    ret, qos, vha->vp_idx);
+			    "Queue pair: %d Qos: %d) created for VP[%d]\n",
+			    qpair->id, qos, vha->vp_idx);
 			ql_dbg(ql_dbg_user, vha, 0x7085,
-			    "Request Que:%d Q0s: %d) created for VP[%d]\n",
-			    ret, qos, vha->vp_idx);
-			req = ha->req_q_map[ret];
+			    "Queue Pair: %d Qos: %d) created for VP[%d]\n",
+			    qpair->id, qos, vha->vp_idx);
+			req = qpair->req;
+			vha->qpair = qpair;
 		}
 	}
 
@@ -2162,10 +2156,10 @@ struct device_attribute *qla2x00_host_attrs[] = {
 	clear_bit(vha->vp_idx, ha->vp_idx_map);
 	mutex_unlock(&ha->vport_lock);
 
-	if (vha->req->id && !ha->flags.cpu_affinity_enabled) {
-		if (qla25xx_delete_req_que(vha, vha->req) != QLA_SUCCESS)
+	if (vha->qpair->vp_idx == vha->vp_idx) {
+		if (qla2xxx_delete_qpair(vha, vha->qpair) != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0x7087,
-			    "Queue delete failed.\n");
+			    "Queue Pair delete failed.\n");
 	}
 
 	ql_log(ql_log_info, vha, 0x7088, "VP[%d] deleted.\n", id);
diff --git a/drivers/scsi/qla2xxx/qla_bottom.c b/drivers/scsi/qla2xxx/qla_bottom.c
new file mode 100644
index 0000000..8bf757e
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_bottom.c
@@ -0,0 +1,398 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2016 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+
+/**
+ * qla2xxx_start_scsi_mq() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occurred, else zero.
+ */
+
+static int
+qla2xxx_start_scsi_mq(srb_t *sp)
+{
+	int		nseg;
+	unsigned long   flags;
+	uint32_t	*clr_ptr;
+	uint32_t        index;
+	uint32_t	handle;
+	struct cmd_type_7 *cmd_pkt;
+	uint16_t	cnt;
+	uint16_t	req_cnt;
+	uint16_t	tot_dsds;
+	struct req_que *req = NULL;
+	struct rsp_que *rsp = NULL;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
+	struct scsi_qla_host *vha = sp->fcport->vha;
+	struct qla_hw_data *ha = vha->hw;
+	struct qla_qpair *qpair = sp->qpair;
+
+	/* Setup qpair pointers */
+	rsp = qpair->rsp;
+	req = qpair->req;
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+		vha->marker_needed = 0;
+	}
+
+	/* Acquire qpair specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < req->num_outstanding_cmds; index++) {
+		handle++;
+		if (handle == req->num_outstanding_cmds)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+	if (index == req->num_outstanding_cmds)
+		goto queuing_error;
+
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+	} else
+		nseg = 0;
+
+	tot_dsds = nseg;
+	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+	if (req->cnt < (req_cnt + 2)) {
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length -
+				(req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+	}
+
+	/* Build command packet. */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
+	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+
+	cmd_pkt = (struct cmd_type_7 *)req->ring_ptr;
+	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+
+	/* Zero out remaining portion of packet. */
+	/*    tagged queuing modifier -- default is TSK_SIMPLE (0). */
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* Set NPORT-ID and LUN number*/
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+	cmd_pkt->vp_index = sp->fcport->vha->vp_idx;
+
+	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+	cmd_pkt->task = TSK_SIMPLE;
+
+	/* Load SCSI command packet. */
+	memcpy(cmd_pkt->fcp_cdb, cmd->cmnd, cmd->cmd_len);
+	host_to_fcp_swap(cmd_pkt->fcp_cdb, sizeof(cmd_pkt->fcp_cdb));
+
+	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
+
+	/* Build IOCB segments */
+	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
+
+	/* Set total data segment count. */
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	wmb();
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	sp->flags |= SRB_DMA_VALID;
+
+	/* Set chip new ring index. */
+	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+		rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+	return QLA_SUCCESS;
+
+queuing_error:
+	if (tot_dsds)
+		scsi_dma_unmap(cmd);
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
+	return QLA_FUNCTION_FAILED;
+}
+
+
+/**
+ * qla2xxx_dif_start_scsi_mq() - Send a SCSI command to the ISP
+ * @sp: command to send to the ISP
+ *
+ * Returns non-zero if a failure occurred, else zero.
+ */
+int
+qla2xxx_dif_start_scsi_mq(srb_t *sp)
+{
+	int			nseg;
+	unsigned long		flags;
+	uint32_t		*clr_ptr;
+	uint32_t		index;
+	uint32_t		handle;
+	uint16_t		cnt;
+	uint16_t		req_cnt = 0;
+	uint16_t		tot_dsds;
+	uint16_t		tot_prot_dsds;
+	uint16_t		fw_prot_opts = 0;
+	struct req_que		*req = NULL;
+	struct rsp_que		*rsp = NULL;
+	struct scsi_cmnd	*cmd = GET_CMD_SP(sp);
+	struct scsi_qla_host	*vha = sp->fcport->vha;
+	struct qla_hw_data	*ha = vha->hw;
+	struct cmd_type_crc_2	*cmd_pkt;
+	uint32_t		status = 0;
+	struct qla_qpair	*qpair = sp->qpair;
+
+#define QDSS_GOT_Q_SPACE	BIT_0
+
+	/* Check for host side state */
+	if (!qpair->online) {
+		cmd->result = DID_NO_CONNECT << 16;
+		return QLA_INTERFACE_ERROR;
+	}
+
+	if (!qpair->difdix_supported &&
+		scsi_get_prot_op(cmd) != SCSI_PROT_NORMAL) {
+		cmd->result = DID_NO_CONNECT << 16;
+		return QLA_INTERFACE_ERROR;
+	}
+
+	/* Only process protection or >16 cdb in this routine */
+	if (scsi_get_prot_op(cmd) == SCSI_PROT_NORMAL) {
+		if (cmd->cmd_len <= 16)
+			return qla2xxx_start_scsi_mq(sp);
+	}
+
+	/* Setup qpair pointers */
+	rsp = qpair->rsp;
+	req = qpair->req;
+
+	/* So we know we haven't pci_map'ed anything yet */
+	tot_dsds = 0;
+
+	/* Send marker if required */
+	if (vha->marker_needed != 0) {
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS)
+			return QLA_FUNCTION_FAILED;
+		vha->marker_needed = 0;
+	}
+
+	/* Acquire ring specific lock */
+	spin_lock_irqsave(&qpair->qp_lock, flags);
+
+	/* Check for room in outstanding command list. */
+	handle = req->current_outstanding_cmd;
+	for (index = 1; index < req->num_outstanding_cmds; index++) {
+		handle++;
+		if (handle == req->num_outstanding_cmds)
+			handle = 1;
+		if (!req->outstanding_cmds[handle])
+			break;
+	}
+
+	if (index == req->num_outstanding_cmds)
+		goto queuing_error;
+
+	/* Compute number of required data segments */
+	/* Map the sg table so we have an accurate count of sg entries needed */
+	if (scsi_sg_count(cmd)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_sglist(cmd),
+		    scsi_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+		else
+			sp->flags |= SRB_DMA_VALID;
+
+		if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
+		    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_STRIP)) {
+			struct qla2_sgx sgx;
+			uint32_t	partial;
+
+			memset(&sgx, 0, sizeof(struct qla2_sgx));
+			sgx.tot_bytes = scsi_bufflen(cmd);
+			sgx.cur_sg = scsi_sglist(cmd);
+			sgx.sp = sp;
+
+			nseg = 0;
+			while (qla24xx_get_one_block_sg(
+			    cmd->device->sector_size, &sgx, &partial))
+				nseg++;
+		}
+	} else
+		nseg = 0;
+
+	/* number of required data segments */
+	tot_dsds = nseg;
+
+	/* Compute number of required protection segments */
+	if (qla24xx_configure_prot_mode(sp, &fw_prot_opts)) {
+		nseg = dma_map_sg(&ha->pdev->dev, scsi_prot_sglist(cmd),
+		    scsi_prot_sg_count(cmd), cmd->sc_data_direction);
+		if (unlikely(!nseg))
+			goto queuing_error;
+		else
+			sp->flags |= SRB_CRC_PROT_DMA_VALID;
+
+		if ((scsi_get_prot_op(cmd) == SCSI_PROT_READ_INSERT) ||
+		    (scsi_get_prot_op(cmd) == SCSI_PROT_WRITE_STRIP)) {
+			nseg = scsi_bufflen(cmd) / cmd->device->sector_size;
+		}
+	} else {
+		nseg = 0;
+	}
+
+	req_cnt = 1;
+	/* Total Data and protection sg segment(s) */
+	tot_prot_dsds = nseg;
+	tot_dsds += nseg;
+	if (req->cnt < (req_cnt + 2)) {
+		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
+		    RD_REG_DWORD_RELAXED(req->req_q_out);
+		if (req->ring_index < cnt)
+			req->cnt = cnt - req->ring_index;
+		else
+			req->cnt = req->length -
+				(req->ring_index - cnt);
+		if (req->cnt < (req_cnt + 2))
+			goto queuing_error;
+	}
+
+	status |= QDSS_GOT_Q_SPACE;
+
+	/* Build header part of command packet (excluding the OPCODE). */
+	req->current_outstanding_cmd = handle;
+	req->outstanding_cmds[handle] = sp;
+	sp->handle = handle;
+	cmd->host_scribble = (unsigned char *)(unsigned long)handle;
+	req->cnt -= req_cnt;
+
+	/* Fill-in common area */
+	cmd_pkt = (struct cmd_type_crc_2 *)req->ring_ptr;
+	cmd_pkt->handle = MAKE_HANDLE(req->id, handle);
+
+	clr_ptr = (uint32_t *)cmd_pkt + 2;
+	memset(clr_ptr, 0, REQUEST_ENTRY_SIZE - 8);
+
+	/* Set NPORT-ID and LUN number*/
+	cmd_pkt->nport_handle = cpu_to_le16(sp->fcport->loop_id);
+	cmd_pkt->port_id[0] = sp->fcport->d_id.b.al_pa;
+	cmd_pkt->port_id[1] = sp->fcport->d_id.b.area;
+	cmd_pkt->port_id[2] = sp->fcport->d_id.b.domain;
+
+	int_to_scsilun(cmd->device->lun, &cmd_pkt->lun);
+	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
+
+	/* Total Data and protection segment(s) */
+	cmd_pkt->dseg_count = cpu_to_le16(tot_dsds);
+
+	/* Build IOCB segments and adjust for data protection segments */
+	if (qla24xx_build_scsi_crc_2_iocbs(sp, (struct cmd_type_crc_2 *)
+	    req->ring_ptr, tot_dsds, tot_prot_dsds, fw_prot_opts) !=
+		QLA_SUCCESS)
+		goto queuing_error;
+
+	cmd_pkt->entry_count = (uint8_t)req_cnt;
+	cmd_pkt->timeout = cpu_to_le16(0);
+	wmb();
+
+	/* Adjust ring index. */
+	req->ring_index++;
+	if (req->ring_index == req->length) {
+		req->ring_index = 0;
+		req->ring_ptr = req->ring;
+	} else
+		req->ring_ptr++;
+
+	/* Set chip new ring index. */
+	WRT_REG_DWORD(req->req_q_in, req->ring_index);
+
+	/* Manage unprocessed RIO/ZIO commands in response queue. */
+	if (vha->flags.process_response_queue &&
+	    rsp->ring_ptr->signature != RESPONSE_PROCESSED)
+		qla24xx_process_response_queue(vha, rsp);
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+
+	return QLA_SUCCESS;
+
+queuing_error:
+	if (status & QDSS_GOT_Q_SPACE) {
+		req->outstanding_cmds[handle] = NULL;
+		req->cnt += req_cnt;
+	}
+	/* Cleanup will be performed by the caller (queuecommand) */
+
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
+	return QLA_FUNCTION_FAILED;
+}
+
+irqreturn_t
+qla2xxx_msix_rsp_q(int irq, void *dev_id)
+{
+	struct qla_hw_data *ha;
+	struct qla_qpair *qpair;
+	struct device_reg_24xx __iomem *reg;
+	unsigned long flags;
+
+	qpair = dev_id;
+	if (!qpair) {
+		ql_log(ql_log_info, NULL, 0x505b,
+		    "%s: NULL response queue pointer.\n", __func__);
+		return IRQ_NONE;
+	}
+	ha = qpair->hw;
+
+	/* Clear the interrupt, if enabled, for this response queue */
+	if (unlikely(!ha->flags.disable_msix_handshake)) {
+		reg = &ha->iobase->isp24;
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	}
+
+	queue_work(ha->wq, &qpair->q_work);
+
+	return IRQ_HANDLED;
+}
diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 45af34d..21d9fb7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,7 +11,7 @@
  * ----------------------------------------------------------------------
  * |             Level            |   Last Value Used  |     Holes	|
  * ----------------------------------------------------------------------
- * | Module Init and Probe        |       0x0191       | 0x0146         |
+ * | Module Init and Probe        |       0x0193       | 0x0146         |
  * |                              |                    | 0x015b-0x0160	|
  * |                              |                    | 0x016e		|
  * | Mailbox commands             |       0x1199       | 0x1193		|
@@ -58,7 +58,7 @@
  * |                              |                    | 0xb13a,0xb142  |
  * |                              |                    | 0xb13c-0xb140  |
  * |                              |                    | 0xb149		|
- * | MultiQ                       |       0xc00c       |		|
+ * | MultiQ                       |       0xc010       |		|
  * | Misc                         |       0xd301       | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9a6ddcb..7c3ed9d 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -401,6 +401,7 @@ struct srb_iocb {
 	uint16_t type;
 	char *name;
 	int iocbs;
+	struct qla_qpair *qpair;
 	union {
 		struct srb_iocb iocb_cmd;
 		struct bsg_job *bsg_job;
@@ -2719,6 +2720,7 @@ struct isp_operations {
 
 	int (*get_flash_version) (struct scsi_qla_host *, void *);
 	int (*start_scsi) (srb_t *);
+	int (*start_scsi_mq) (srb_t *);
 	int (*abort_isp) (struct scsi_qla_host *);
 	int (*iospace_config)(struct qla_hw_data*);
 	int (*initialize_adapter)(struct scsi_qla_host *);
@@ -2730,8 +2732,9 @@ struct isp_operations {
 #define QLA_MSIX_FW_MODE(m)	(((m) & (BIT_7|BIT_8|BIT_9)) >> 7)
 #define QLA_MSIX_FW_MODE_1(m)	(QLA_MSIX_FW_MODE(m) == 1)
 
-#define QLA_MSIX_DEFAULT	0x00
-#define QLA_MSIX_RSP_Q		0x01
+#define QLA_MSIX_DEFAULT		0x00
+#define QLA_MSIX_RSP_Q			0x01
+#define QLA_MSIX_QPAIR_MULTIQ_RSP_Q	0x02
 
 #define QLA_MIDX_DEFAULT	0
 #define QLA_MIDX_RSP_Q		1
@@ -2745,9 +2748,12 @@ struct isp_operations {
 
 struct qla_msix_entry {
 	int have_irq;
+	int in_use;
 	uint32_t vector;
 	uint16_t entry;
 	struct rsp_que *rsp;
+	char name[30];
+	void *handle;
 	struct irq_affinity_notify irq_notify;
 	int cpuid;
 };
@@ -2872,7 +2878,6 @@ struct rsp_que {
 	struct qla_msix_entry *msix;
 	struct req_que *req;
 	srb_t *status_srb; /* status continuation entry */
-	struct work_struct q_work;
 
 	dma_addr_t  dma_fx00;
 	response_t *ring_fx00;
@@ -2909,6 +2914,44 @@ struct req_que {
 	uint8_t req_pkt[REQUEST_ENTRY_SIZE];
 };
 
+/*Queue pair data structure */
+struct qla_qpair {
+	spinlock_t qp_lock;
+	atomic_t ref_count;
+	/* distill these fields down to 'online=0/1'
+	 * ha->flags.eeh_busy
+	 * ha->flags.pci_channel_io_perm_failure
+	 * base_vha->loop_state
+	 */
+	uint32_t online:1;
+	/* move vha->flags.difdix_supported here */
+	uint32_t difdix_supported:1;
+	uint32_t delete_in_progress:1;
+
+	uint16_t id;			/* qp number used with FW */
+	uint16_t num_active_cmd;	/* cmds down at firmware */
+	cpumask_t cpu_mask; /* CPU mask for cpu affinity operation */
+	uint16_t vp_idx;		/* vport ID */
+
+	mempool_t *srb_mempool;
+
+	/* to do: New driver: move queues to here instead of pointers */
+	struct req_que *req;
+	struct rsp_que *rsp;
+	struct atio_que *atio;
+	struct qla_msix_entry *msix; /* point to &ha->msix_entries[x] */
+	struct qla_hw_data *hw;
+	struct work_struct q_work;
+	struct list_head qp_list_elem; /* vha->qp_list */
+};
+
+struct qla_percpu_qp_hint {
+	int change_in_progress;
+	struct qla_qpair *qp;
+	int redirect_to_cpuid;
+	struct qla_qpair *alternate_qp;
+};
+
 /* Place holder for FW buffer parameters */
 struct qlfc_fw {
 	void *fw_buf;
@@ -3004,7 +3047,6 @@ struct qla_hw_data {
 		uint32_t	chip_reset_done		:1;
 		uint32_t	running_gold_fw		:1;
 		uint32_t	eeh_busy		:1;
-		uint32_t	cpu_affinity_enabled	:1;
 		uint32_t	disable_msix_handshake	:1;
 		uint32_t	fcp_prio_enabled	:1;
 		uint32_t	isp82xx_fw_hung:1;
@@ -3061,10 +3103,15 @@ struct qla_hw_data {
 	uint8_t         mqenable;
 	struct req_que **req_q_map;
 	struct rsp_que **rsp_q_map;
+	struct qla_qpair **queue_pair_map;
 	unsigned long req_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
 	unsigned long rsp_qid_map[(QLA_MAX_QUEUES / 8) / sizeof(unsigned long)];
+	unsigned long qpair_qid_map[(QLA_MAX_QUEUES / 8)
+		/ sizeof(unsigned long)];
 	uint8_t 	max_req_queues;
 	uint8_t 	max_rsp_queues;
+	uint8_t		max_qpairs;
+	struct qla_qpair *base_qpair;
 	struct qla_npiv_entry *npiv_info;
 	uint16_t	nvram_npiv_size;
 
@@ -3328,6 +3375,7 @@ struct qla_hw_data {
 
 	struct mutex vport_lock;        /* Virtual port synchronization */
 	spinlock_t vport_slock; /* order is hardware_lock, then vport_slock */
+	struct mutex mq_lock;        /* multi-queue synchronization */
 	struct completion mbx_cmd_comp; /* Serialize mbx access */
 	struct completion mbx_intr_comp;  /* Used for completion notification */
 	struct completion dcbx_comp;	/* For set port config notification */
@@ -3611,6 +3659,7 @@ struct qla_tgt_counters {
 
 		uint32_t	fw_tgt_reported:1;
 		uint32_t	bbcr_enable:1;
+		uint32_t	qpairs_available:1;
 	} flags;
 
 	atomic_t	loop_state;
@@ -3649,6 +3698,7 @@ struct qla_tgt_counters {
 #define FX00_TARGET_SCAN	24
 #define FX00_CRITEMP_RECOVERY	25
 #define FX00_HOST_INFO_RESEND	26
+#define QPAIR_ONLINE_CHECK_NEEDED	27
 
 	unsigned long	pci_flags;
 #define PFLG_DISCONNECTED	0	/* PCI device removed */
@@ -3707,10 +3757,13 @@ struct qla_tgt_counters {
 	/* List of pending PLOGI acks, protected by hw lock */
 	struct list_head	plogi_ack_list;
 
+	struct list_head	qp_list;
+
 	uint32_t	vp_abort_cnt;
 
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
 	uint16_t        vp_idx;		/* vport ID */
+	struct qla_qpair *qpair;	/* base qpair */
 
 	unsigned long		vp_flags;
 #define VP_IDX_ACQUIRED		0	/* bit no 0 */
@@ -3735,6 +3788,7 @@ struct qla_tgt_counters {
 	struct qla_hw_data *hw;
 	struct scsi_qlt_host vha_tgt;
 	struct req_que *req;
+	struct qla_percpu_qp_hint *qps_hint;
 	int		fw_heartbeat_counter;
 	int		seconds_since_last_heartbeat;
 	struct fc_host_statistics fc_host_stat;
@@ -3766,6 +3820,23 @@ struct qla_tgt_vp_map {
 	scsi_qla_host_t *vha;
 };
 
+struct qla2_sgx {
+	dma_addr_t		dma_addr;	/* OUT */
+	uint32_t		dma_len;	/* OUT */
+
+	uint32_t		tot_bytes;	/* IN */
+	struct scatterlist	*cur_sg;	/* IN */
+
+	/* for book keeping, bzero on initial invocation */
+	uint32_t		bytes_consumed;
+	uint32_t		num_bytes;
+	uint32_t		tot_partial;
+
+	/* for debugging */
+	uint32_t		num_sg;
+	srb_t			*sp;
+};
+
 /*
  * Macros to help code, maintain, etc.
  */
@@ -3778,21 +3849,34 @@ struct qla_tgt_vp_map {
 		(test_bit(ISP_ABORT_NEEDED, &ha->dpc_flags) || \
 			 test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))
 
-#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		     \
-	atomic_inc(&__vha->vref_count);			     \
-	mb();						     \
-	if (__vha->flags.delete_progress) {		     \
-		atomic_dec(&__vha->vref_count);		     \
-		__bail = 1;				     \
-	} else {					     \
-		__bail = 0;				     \
-	}						     \
+#define QLA_VHA_MARK_BUSY(__vha, __bail) do {		\
+	atomic_inc(&__vha->vref_count);			\
+	mb();						\
+	if (__vha->flags.delete_progress) {		\
+		atomic_dec(&__vha->vref_count);		\
+		__bail = 1;				\
+	} else {					\
+		__bail = 0;				\
+	}						\
 } while (0)
 
-#define QLA_VHA_MARK_NOT_BUSY(__vha) do {		     \
-	atomic_dec(&__vha->vref_count);			     \
+#define QLA_VHA_MARK_NOT_BUSY(__vha)			\
+	atomic_dec(&__vha->vref_count);			\
+
+#define QLA_QPAIR_MARK_BUSY(__qpair, __bail) do {	\
+	atomic_inc(&__qpair->ref_count);		\
+	mb();						\
+	if (__qpair->delete_in_progress) {		\
+		atomic_dec(&__qpair->ref_count);	\
+		__bail = 1;				\
+	} else {					\
+	       __bail = 0;				\
+	}						\
 } while (0)
 
+#define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
+	atomic_dec(&__qpair->ref_count);		\
+
 /*
  * qla2x00 local function return status codes
  */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index c51d9f3..6faa328 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -97,6 +97,8 @@ extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
  */
 extern char qla2x00_version_str[];
 
+extern struct kmem_cache *srb_cachep;
+
 extern int ql2xlogintimeout;
 extern int qlport_down_retry;
 extern int ql2xplogiabsentdevice;
@@ -105,8 +107,7 @@ extern void qla2x00_async_adisc_done(struct scsi_qla_host *, fc_port_t *,
 extern int ql2xallocfwdump;
 extern int ql2xextended_error_logging;
 extern int ql2xiidmaenable;
-extern int ql2xmaxqueues;
-extern int ql2xmultique_tag;
+extern int ql2xmqsupport;
 extern int ql2xfwloadbin;
 extern int ql2xetsenable;
 extern int ql2xshiftctondsd;
@@ -172,6 +173,7 @@ extern struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *,
 
 extern int qla2x00_post_uevent_work(struct scsi_qla_host *, u32);
 extern void qla2x00_disable_board_on_pci_error(struct work_struct *);
+extern void qla2x00_sp_compl(void *, void *, int);
 
 /*
  * Global Functions in qla_mid.c source file.
@@ -220,6 +222,8 @@ extern void qla2x00_async_event(scsi_qla_host_t *, struct rsp_que *,
 extern uint16_t qla2x00_calc_iocbs_64(uint16_t);
 extern void qla2x00_build_scsi_iocbs_32(srb_t *, cmd_entry_t *, uint16_t);
 extern void qla2x00_build_scsi_iocbs_64(srb_t *, cmd_entry_t *, uint16_t);
+extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *,
+	uint16_t, struct req_que *);
 extern int qla2x00_start_scsi(srb_t *sp);
 extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
@@ -237,7 +241,10 @@ extern int qla24xx_walk_and_build_sglist(struct qla_hw_data *, srb_t *,
 	uint32_t *, uint16_t, struct qla_tgt_cmd *);
 extern int qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *, srb_t *,
 	uint32_t *, uint16_t, struct qla_tgt_cmd *);
-
+extern int qla24xx_get_one_block_sg(uint32_t, struct qla2_sgx *, uint32_t *);
+extern int qla24xx_configure_prot_mode(srb_t *, uint16_t *);
+extern int qla24xx_build_scsi_crc_2_iocbs(srb_t *,
+	struct cmd_type_crc_2 *, uint16_t, uint16_t, uint16_t);
 
 /*
  * Global Function Prototypes in qla_mbx.c source file.
@@ -468,6 +475,8 @@ extern int qla24xx_set_fcp_prio(scsi_qla_host_t *, uint16_t, uint16_t,
 extern void
 qla2x00_process_completed_request(struct scsi_qla_host *, struct req_que *,
 	uint32_t);
+extern irqreturn_t
+qla2xxx_msix_rsp_q(int irq, void *dev_id);
 
 /*
  * Global Function Prototypes in qla_sup.c source file.
@@ -603,15 +612,18 @@ extern int qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *,
 extern int qla2x00_dfs_remove(scsi_qla_host_t *);
 
 /* Globa function prototypes for multi-q */
-extern int qla25xx_request_irq(struct rsp_que *);
+extern int qla25xx_request_irq(struct qla_hw_data *, struct qla_qpair *,
+	struct qla_msix_entry *, int);
 extern int qla25xx_init_req_que(struct scsi_qla_host *, struct req_que *);
 extern int qla25xx_init_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_create_req_que(struct qla_hw_data *, uint16_t, uint8_t,
 	uint16_t, int, uint8_t);
 extern int qla25xx_create_rsp_que(struct qla_hw_data *, uint16_t, uint8_t,
-	uint16_t, int);
+	uint16_t, struct qla_qpair *);
+
 extern void qla2x00_init_response_q_entries(struct rsp_que *);
 extern int qla25xx_delete_req_que(struct scsi_qla_host *, struct req_que *);
+extern int qla25xx_delete_rsp_que(struct scsi_qla_host *, struct rsp_que *);
 extern int qla25xx_delete_queues(struct scsi_qla_host *);
 extern uint16_t qla24xx_rd_req_reg(struct qla_hw_data *, uint16_t);
 extern uint16_t qla25xx_rd_req_reg(struct qla_hw_data *, uint16_t);
@@ -784,5 +796,17 @@ extern int qla_get_exlogin_status(scsi_qla_host_t *, uint16_t *,
 extern int qla_get_exchoffld_status(scsi_qla_host_t *, uint16_t *, uint16_t *);
 extern int qla_set_exchoffld_mem_cfg(scsi_qla_host_t *, dma_addr_t);
 extern void qlt_handle_abts_recv(struct scsi_qla_host *, response_t *);
+extern size_t qlt_add_vtarget(u64, u64, u64);
+extern size_t qlt_del_vtarget(u64);
+
+/* Function declarations for queue pairs */
+extern struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *,
+	cpumask_var_t, int, int);
+extern int qla2xxx_delete_qpair(struct scsi_qla_host *, struct qla_qpair *);
+extern int qla2xxx_mqueuecommand(struct Scsi_Host *, struct scsi_cmnd *,
+	struct qla_qpair *);
+extern int qla2xxx_dif_start_scsi_mq(srb_t *);
+extern void qla2xxx_qpair_sp_free_dma(void *, void *);
+extern void qla2xxx_qpair_sp_compl(void *, void *, int);
 
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5b09296..6e2458d 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1769,8 +1769,7 @@ static int qla2x00_fabric_dev_login(scsi_qla_host_t *, fc_port_t *,
 	if (req->outstanding_cmds)
 		return QLA_SUCCESS;
 
-	if (!IS_FWI2_CAPABLE(ha) || (ha->mqiobase &&
-	    (ql2xmultique_tag || ql2xmaxqueues > 1)))
+	if (!IS_FWI2_CAPABLE(ha))
 		req->num_outstanding_cmds = DEFAULT_OUTSTANDING_COMMANDS;
 	else {
 		if (ha->cur_fw_xcb_count <= ha->cur_fw_iocb_count)
@@ -4248,10 +4247,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	if (vha->hw->flags.cpu_affinity_enabled)
-		req = vha->hw->req_q_map[0];
-	else
-		req = vha->req;
+	req = vha->req;
 	rsp = req->rsp;
 
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
@@ -6040,10 +6036,10 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		return -EINVAL;
 
 	rval = qla2x00_fw_ready(base_vha);
-	if (ha->flags.cpu_affinity_enabled)
-		req = ha->req_q_map[0];
+	if (vha->qpair)
+		req = vha->qpair->req;
 	else
-		req = vha->req;
+		req = ha->req_q_map[0];
 	rsp = req->rsp;
 
 	if (rval == QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index edc48f3..44e4045 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -216,6 +216,36 @@
 }
 
 static inline srb_t *
+qla2xxx_get_qpair_sp(struct qla_qpair *qpair, fc_port_t *fcport, gfp_t flag)
+{
+	srb_t *sp = NULL;
+	uint8_t bail;
+
+	QLA_QPAIR_MARK_BUSY(qpair, bail);
+	if (unlikely(bail))
+		return NULL;
+
+	sp = mempool_alloc(qpair->srb_mempool, flag);
+	if (!sp)
+		goto done;
+
+	memset(sp, 0, sizeof(*sp));
+	sp->fcport = fcport;
+	sp->iocbs = 1;
+done:
+	if (!sp)
+		QLA_QPAIR_MARK_NOT_BUSY(qpair);
+	return sp;
+}
+
+static inline void
+qla2xxx_rel_qpair_sp(struct qla_qpair *qpair, srb_t *sp)
+{
+	mempool_free(sp, qpair->srb_mempool);
+	QLA_QPAIR_MARK_NOT_BUSY(qpair);
+}
+
+static inline srb_t *
 qla2x00_get_sp(scsi_qla_host_t *vha, fc_port_t *fcport, gfp_t flag)
 {
 	srb_t *sp = NULL;
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 221ad89..de0f4fb 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -12,7 +12,6 @@
 
 #include <scsi/scsi_tcq.h>
 
-static void qla25xx_set_que(srb_t *, struct rsp_que **);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
  * @cmd: SCSI command
@@ -143,7 +142,7 @@
 	return (cont_pkt);
 }
 
-static inline int
+inline int
 qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
 {
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
@@ -693,10 +692,11 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
  * @sp: SRB command to process
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
+ * @req: pointer to request queue
  */
-static inline void
+inline void
 qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
-    uint16_t tot_dsds)
+	uint16_t tot_dsds, struct req_que *req)
 {
 	uint16_t	avail_dsds;
 	uint32_t	*cur_dsd;
@@ -745,7 +745,7 @@ int qla2x00_issue_marker(scsi_qla_host_t *vha, int ha_locked)
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, vha->req);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha, req);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -845,24 +845,7 @@ struct fw_dif_context {
 	}
 }
 
-struct qla2_sgx {
-	dma_addr_t		dma_addr;	/* OUT */
-	uint32_t		dma_len;	/* OUT */
-
-	uint32_t		tot_bytes;	/* IN */
-	struct scatterlist	*cur_sg;	/* IN */
-
-	/* for book keeping, bzero on initial invocation */
-	uint32_t		bytes_consumed;
-	uint32_t		num_bytes;
-	uint32_t		tot_partial;
-
-	/* for debugging */
-	uint32_t		num_sg;
-	srb_t			*sp;
-};
-
-static int
+int
 qla24xx_get_one_block_sg(uint32_t blk_sz, struct qla2_sgx *sgx,
 	uint32_t *partial)
 {
@@ -1207,7 +1190,7 @@ struct qla2_sgx {
  * @cmd_pkt: Command type 3 IOCB
  * @tot_dsds: Total number of segments to transfer
  */
-static inline int
+inline int
 qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
     uint16_t tot_dsds, uint16_t tot_prot_dsds, uint16_t fw_prot_opts)
 {
@@ -1436,8 +1419,8 @@ struct qla2_sgx {
 	struct qla_hw_data *ha = vha->hw;
 
 	/* Setup device pointers. */
-	qla25xx_set_que(sp, &rsp);
 	req = vha->req;
+	rsp = req->rsp;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -1523,12 +1506,10 @@ struct qla2_sgx {
 	cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
 	/* Build IOCB segments */
-	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds);
+	qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
 
 	/* Set total data segment count. */
 	cmd_pkt->entry_count = (uint8_t)req_cnt;
-	/* Specify response queue number where completion should happen */
-	cmd_pkt->entry_status = (uint8_t) rsp->id;
 	wmb();
 	/* Adjust ring index. */
 	req->ring_index++;
@@ -1597,9 +1578,8 @@ struct qla2_sgx {
 	}
 
 	/* Setup device pointers. */
-
-	qla25xx_set_que(sp, &rsp);
 	req = vha->req;
+	rsp = req->rsp;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
@@ -1764,20 +1744,6 @@ struct qla2_sgx {
 	return QLA_FUNCTION_FAILED;
 }
 
-
-static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
-{
-	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
-	struct qla_hw_data *ha = sp->fcport->vha->hw;
-	int affinity = cmd->request->cpu;
-
-	if (ha->flags.cpu_affinity_enabled && affinity >= 0 &&
-		affinity < ha->max_rsp_queues - 1)
-		*rsp = ha->rsp_q_map[affinity + 1];
-	 else
-		*rsp = ha->rsp_q_map[0];
-}
-
 /* Generic Control-SRB manipulation functions. */
 
 /* hardware_lock assumed to be held. */
@@ -2664,7 +2630,7 @@ static void qla25xx_set_que(srb_t *sp, struct rsp_que **rsp)
 		cmd_pkt->byte_count = cpu_to_le32((uint32_t)scsi_bufflen(cmd));
 
 		/* Build IOCB segments */
-		qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds);
+		qla24xx_build_scsi_iocbs(sp, cmd_pkt, tot_dsds, req);
 
 		/* Set total data segment count. */
 		cmd_pkt->entry_count = (uint8_t)req_cnt;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 19f1848..0c4910b 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2871,41 +2871,6 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
 }
 
 static irqreturn_t
-qla25xx_msix_rsp_q(int irq, void *dev_id)
-{
-	struct qla_hw_data *ha;
-	scsi_qla_host_t *vha;
-	struct rsp_que *rsp;
-	struct device_reg_24xx __iomem *reg;
-	unsigned long flags;
-	uint32_t hccr = 0;
-
-	rsp = (struct rsp_que *) dev_id;
-	if (!rsp) {
-		ql_log(ql_log_info, NULL, 0x505b,
-		    "%s: NULL response queue pointer.\n", __func__);
-		return IRQ_NONE;
-	}
-	ha = rsp->hw;
-	vha = pci_get_drvdata(ha->pdev);
-
-	/* Clear the interrupt, if enabled, for this response queue */
-	if (!ha->flags.disable_msix_handshake) {
-		reg = &ha->iobase->isp24;
-		spin_lock_irqsave(&ha->hardware_lock, flags);
-		WRT_REG_DWORD(&reg->hccr, HCCRX_CLR_RISC_INT);
-		hccr = RD_REG_DWORD_RELAXED(&reg->hccr);
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	}
-	if (qla2x00_check_reg32_for_disconnect(vha, hccr))
-		goto out;
-	queue_work_on((int) (rsp->id - 1), ha->wq, &rsp->q_work);
-
-out:
-	return IRQ_HANDLED;
-}
-
-static irqreturn_t
 qla24xx_msix_default(int irq, void *dev_id)
 {
 	scsi_qla_host_t	*vha;
@@ -3008,18 +2973,18 @@ struct qla_init_msix_entry {
 	irq_handler_t handler;
 };
 
-static struct qla_init_msix_entry msix_entries[3] = {
+static struct qla_init_msix_entry msix_entries[] = {
 	{ "qla2xxx (default)", qla24xx_msix_default },
 	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
-	{ "qla2xxx (multiq)", qla25xx_msix_rsp_q },
+	{ "qla2xxx (qpair_multiq)", qla2xxx_msix_rsp_q },
 };
 
-static struct qla_init_msix_entry qla82xx_msix_entries[2] = {
+static struct qla_init_msix_entry qla82xx_msix_entries[] = {
 	{ "qla2xxx (default)", qla82xx_msix_default },
 	{ "qla2xxx (rsp_q)", qla82xx_msix_rsp_q },
 };
 
-static struct qla_init_msix_entry qla83xx_msix_entries[3] = {
+static struct qla_init_msix_entry qla83xx_msix_entries[] = {
 	{ "qla2xxx (default)", qla24xx_msix_default },
 	{ "qla2xxx (rsp_q)", qla24xx_msix_rsp_q },
 	{ "qla2xxx (atio_q)", qla83xx_msix_atio_q },
@@ -3037,7 +3002,7 @@ struct qla_init_msix_entry {
 		if (qentry->have_irq) {
 			/* un-register irq cpu affinity notification */
 			irq_set_affinity_notifier(qentry->vector, NULL);
-			free_irq(qentry->vector, qentry->rsp);
+			free_irq(qentry->vector, qentry->handle);
 		}
 	}
 	pci_disable_msix(ha->pdev);
@@ -3057,6 +3022,7 @@ struct qla_init_msix_entry {
 	struct msix_entry *entries;
 	struct qla_msix_entry *qentry;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	int cpus;
 
 	entries = kzalloc(sizeof(struct msix_entry) * ha->msix_count,
 			GFP_KERNEL);
@@ -3080,10 +3046,24 @@ struct qla_init_msix_entry {
 	} else if (ret < ha->msix_count) {
 		ql_log(ql_log_warn, vha, 0x00c6,
 		    "MSI-X: Failed to enable support "
-		    "-- %d/%d\n Retry with %d vectors.\n",
-		    ha->msix_count, ret, ret);
+		     "with %d vectors, using %d vectors.\n",
+		    ha->msix_count, ret);
 		ha->msix_count = ret;
-		ha->max_rsp_queues = ha->msix_count - 1;
+		/* Recalculate queue values */
+		if (ql2xmqsupport) {
+			cpus = num_online_cpus();
+			ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
+				(cpus + 1) : (ha->msix_count - 1);
+			ha->max_rsp_queues = ha->max_req_queues;
+
+			/* ATIOQ needs 1 vector. That's 1 less QPair */
+			if (QLA_TGT_MODE_ENABLED())
+				ha->max_req_queues--;
+
+			ha->max_qpairs = ha->max_req_queues - 1;
+			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0190,
+			    "Adjusted Max no of queues pairs: %d.\n", ha->max_qpairs);
+		}
 	}
 	ha->msix_entries = kzalloc(sizeof(struct qla_msix_entry) *
 				ha->msix_count, GFP_KERNEL);
@@ -3100,7 +3080,8 @@ struct qla_init_msix_entry {
 		qentry->vector = entries[i].vector;
 		qentry->entry = entries[i].entry;
 		qentry->have_irq = 0;
-		qentry->rsp = NULL;
+		qentry->in_use = 0;
+		qentry->handle = NULL;
 		qentry->irq_notify.notify  = qla_irq_affinity_notify;
 		qentry->irq_notify.release = qla_irq_affinity_release;
 		qentry->cpuid = -1;
@@ -3109,8 +3090,10 @@ struct qla_init_msix_entry {
 	/* Enable MSI-X vectors for the base queue */
 	for (i = 0; i < 2; i++) {
 		qentry = &ha->msix_entries[i];
-		qentry->rsp = rsp;
+		qentry->handle = rsp;
 		rsp->msix = qentry;
+		scnprintf(qentry->name, sizeof(qentry->name),
+		    msix_entries[i].name);
 		if (IS_P3P_TYPE(ha))
 			ret = request_irq(qentry->vector,
 				qla82xx_msix_entries[i].handler,
@@ -3142,8 +3125,10 @@ struct qla_init_msix_entry {
 	 */
 	if (QLA_TGT_MODE_ENABLED() && IS_ATIO_MSIX_CAPABLE(ha)) {
 		qentry = &ha->msix_entries[ATIO_VECTOR];
-		qentry->rsp = rsp;
 		rsp->msix = qentry;
+		qentry->handle = rsp;
+		scnprintf(qentry->name, sizeof(qentry->name),
+		    qla83xx_msix_entries[ATIO_VECTOR].name);
 		ret = request_irq(qentry->vector,
 			qla83xx_msix_entries[ATIO_VECTOR].handler,
 			0, qla83xx_msix_entries[ATIO_VECTOR].name, rsp);
@@ -3163,11 +3148,13 @@ struct qla_init_msix_entry {
 	/* Enable MSI-X vector for response queue update for queue 0 */
 	if (IS_QLA83XX(ha) || IS_QLA27XX(ha)) {
 		if (ha->msixbase && ha->mqiobase &&
-		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1))
+		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
+		     ql2xmqsupport))
 			ha->mqenable = 1;
 	} else
-		if (ha->mqiobase
-		    && (ha->max_rsp_queues > 1 || ha->max_req_queues > 1))
+		if (ha->mqiobase &&
+		    (ha->max_rsp_queues > 1 || ha->max_req_queues > 1 ||
+		     ql2xmqsupport))
 			ha->mqenable = 1;
 	ql_dbg(ql_dbg_multiq, vha, 0xc005,
 	    "mqiobase=%p, max_rsp_queues=%d, max_req_queues=%d.\n",
@@ -3293,16 +3280,16 @@ struct qla_init_msix_entry {
 		free_irq(ha->pdev->irq, rsp);
 }
 
-
-int qla25xx_request_irq(struct rsp_que *rsp)
+int qla25xx_request_irq(struct qla_hw_data *ha, struct qla_qpair *qpair,
+	struct qla_msix_entry *msix, int vector_type)
 {
-	struct qla_hw_data *ha = rsp->hw;
-	struct qla_init_msix_entry *intr = &msix_entries[2];
-	struct qla_msix_entry *msix = rsp->msix;
+	struct qla_init_msix_entry *intr = &msix_entries[vector_type];
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	int ret;
 
-	ret = request_irq(msix->vector, intr->handler, 0, intr->name, rsp);
+	scnprintf(msix->name, sizeof(msix->name),
+	    "qla2xxx%lu_qpair%d", vha->host_no, qpair->id);
+	ret = request_irq(msix->vector, intr->handler, 0, msix->name, qpair);
 	if (ret) {
 		ql_log(ql_log_fatal, vha, 0x00e6,
 		    "MSI-X: Unable to register handler -- %x/%d.\n",
@@ -3310,7 +3297,7 @@ int qla25xx_request_irq(struct rsp_que *rsp)
 		return ret;
 	}
 	msix->have_irq = 1;
-	msix->rsp = rsp;
+	msix->handle = qpair;
 	return ret;
 }
 
@@ -3323,11 +3310,14 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *notify,
 		container_of(notify, struct qla_msix_entry, irq_notify);
 	struct qla_hw_data *ha;
 	struct scsi_qla_host *base_vha;
+	struct rsp_que *rsp;
 
 	/* user is recommended to set mask to just 1 cpu */
 	e->cpuid = cpumask_first(mask);
 
-	ha = e->rsp->hw;
+	rsp = (struct rsp_que *)e->handle;
+	ha = rsp->hw;
+
 	base_vha = pci_get_drvdata(ha->pdev);
 
 	ql_dbg(ql_dbg_init, base_vha, 0xffff,
@@ -3351,9 +3341,10 @@ static void qla_irq_affinity_release(struct kref *ref)
 		container_of(ref, struct irq_affinity_notify, kref);
 	struct qla_msix_entry *e =
 		container_of(notify, struct qla_msix_entry, irq_notify);
-	struct scsi_qla_host *base_vha = pci_get_drvdata(e->rsp->hw->pdev);
+	struct rsp_que *rsp = (struct rsp_que *)e->handle;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(rsp->hw->pdev);
 
 	ql_dbg(ql_dbg_init, base_vha, 0xffff,
-	    "%s: host%ld: vector %d cpu %d \n", __func__,
+		"%s: host%ld: vector %d cpu %d\n", __func__,
 	    base_vha->host_no, e->vector, e->cpuid);
 }
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 14068fb..383679d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1286,12 +1286,17 @@ static int is_rom_cmd(uint16_t cmd)
 	fc_port_t	*fcport = sp->fcport;
 	scsi_qla_host_t *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = vha->req;
+	struct req_que *req;
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103b,
 	    "Entered %s.\n", __func__);
 
+	if (sp->qpair)
+		req = sp->qpair->req;
+	else
+		req = vha->req;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < req->num_outstanding_cmds; handle++) {
 		if (req->outstanding_cmds[handle] == sp)
@@ -2244,10 +2249,10 @@ static int is_rom_cmd(uint16_t cmd)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1061,
 	    "Entered %s.\n", __func__);
 
-	if (ha->flags.cpu_affinity_enabled)
-		req = ha->req_q_map[0];
+	if (vha->qpair)
+		req = vha->qpair->req;
 	else
-		req = vha->req;
+		req = ha->req_q_map[0];
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
@@ -2527,10 +2532,7 @@ static int is_rom_cmd(uint16_t cmd)
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
 
-	if (ql2xmaxqueues > 1)
-		req = ha->req_q_map[0];
-	else
-		req = vha->req;
+	req = vha->req;
 	lg->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	lg->entry_count = 1;
 	lg->handle = MAKE_HANDLE(req->id, lg->handle);
@@ -2996,6 +2998,9 @@ static int is_rom_cmd(uint16_t cmd)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x108c,
 	    "Entered %s.\n", __func__);
 
+	if (vha->flags.qpairs_available && sp->qpair)
+		req = sp->qpair->req;
+
 	if (ql2xasynctmfenable)
 		return qla24xx_async_abort_command(sp);
 
@@ -3076,6 +3081,8 @@ struct tsk_mgmt_cmd {
 	struct qla_hw_data *ha;
 	struct req_que *req;
 	struct rsp_que *rsp;
+	struct qla_qpair *qpair;
+	struct qla_percpu_qp_hint *hint;
 
 	vha = fcport->vha;
 	ha = vha->hw;
@@ -3084,10 +3091,25 @@ struct tsk_mgmt_cmd {
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1092,
 	    "Entered %s.\n", __func__);
 
-	if (ha->flags.cpu_affinity_enabled)
-		rsp = ha->rsp_q_map[tag + 1];
-	else
+	if (vha->flags.qpairs_available) {
+		hint = (struct qla_percpu_qp_hint *)this_cpu_ptr(vha->qps_hint);
+		if (hint->qp) {
+			qpair = hint->qp;
+		} else if (vha->qpair) {
+			/* NPIV port */
+			qpair = vha->qpair;
+		} else {
+			/* should not happen */
+			rsp = req->rsp;
+			goto qpair_out;
+		}
+		rsp = qpair->rsp;
+		req = qpair->req;
+	} else {
 		rsp = req->rsp;
+	}
+
+qpair_out:
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
 		ql_log(ql_log_warn, vha, 0x1093,
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index cf7ba52..c6d6f0d 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -540,9 +540,10 @@
 	uint16_t que_id = rsp->id;
 
 	if (rsp->msix && rsp->msix->have_irq) {
-		free_irq(rsp->msix->vector, rsp);
+		free_irq(rsp->msix->vector, rsp->msix->handle);
 		rsp->msix->have_irq = 0;
-		rsp->msix->rsp = NULL;
+		rsp->msix->in_use = 0;
+		rsp->msix->handle = NULL;
 	}
 	dma_free_coherent(&ha->pdev->dev, (rsp->length + 1) *
 		sizeof(response_t), rsp->ring, rsp->dma);
@@ -573,7 +574,7 @@
 	return ret;
 }
 
-static int
+int
 qla25xx_delete_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 {
 	int ret = -1;
@@ -596,34 +597,42 @@
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct qla_hw_data *ha = vha->hw;
+	struct qla_qpair *qpair, *tqpair;
 
-	/* Delete request queues */
-	for (cnt = 1; cnt < ha->max_req_queues; cnt++) {
-		req = ha->req_q_map[cnt];
-		if (req && test_bit(cnt, ha->req_qid_map)) {
-			ret = qla25xx_delete_req_que(vha, req);
-			if (ret != QLA_SUCCESS) {
-				ql_log(ql_log_warn, vha, 0x00ea,
-				    "Couldn't delete req que %d.\n",
-				    req->id);
-				return ret;
+	if (ql2xmqsupport) {
+		list_for_each_entry_safe(qpair, tqpair, &vha->qp_list,
+		    qp_list_elem)
+			qla2xxx_delete_qpair(vha, qpair);
+	} else {
+		/* Delete request queues */
+		for (cnt = 1; cnt < ha->max_req_queues; cnt++) {
+			req = ha->req_q_map[cnt];
+			if (req && test_bit(cnt, ha->req_qid_map)) {
+				ret = qla25xx_delete_req_que(vha, req);
+				if (ret != QLA_SUCCESS) {
+					ql_log(ql_log_warn, vha, 0x00ea,
+					    "Couldn't delete req que %d.\n",
+					    req->id);
+					return ret;
+				}
 			}
 		}
-	}
 
-	/* Delete response queues */
-	for (cnt = 1; cnt < ha->max_rsp_queues; cnt++) {
-		rsp = ha->rsp_q_map[cnt];
-		if (rsp && test_bit(cnt, ha->rsp_qid_map)) {
-			ret = qla25xx_delete_rsp_que(vha, rsp);
-			if (ret != QLA_SUCCESS) {
-				ql_log(ql_log_warn, vha, 0x00eb,
-				    "Couldn't delete rsp que %d.\n",
-				    rsp->id);
-				return ret;
+		/* Delete response queues */
+		for (cnt = 1; cnt < ha->max_rsp_queues; cnt++) {
+			rsp = ha->rsp_q_map[cnt];
+			if (rsp && test_bit(cnt, ha->rsp_qid_map)) {
+				ret = qla25xx_delete_rsp_que(vha, rsp);
+				if (ret != QLA_SUCCESS) {
+					ql_log(ql_log_warn, vha, 0x00eb,
+					    "Couldn't delete rsp que %d.\n",
+					    rsp->id);
+					return ret;
+				}
 			}
 		}
 	}
+
 	return ret;
 }
 
@@ -659,10 +668,10 @@
 	if (ret != QLA_SUCCESS)
 		goto que_failed;
 
-	mutex_lock(&ha->vport_lock);
+	mutex_lock(&ha->mq_lock);
 	que_id = find_first_zero_bit(ha->req_qid_map, ha->max_req_queues);
 	if (que_id >= ha->max_req_queues) {
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 		ql_log(ql_log_warn, base_vha, 0x00db,
 		    "No resources to create additional request queue.\n");
 		goto que_failed;
@@ -708,7 +717,7 @@
 	req->req_q_out = &reg->isp25mq.req_q_out;
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	req->out_ptr = (void *)(req->ring + req->length);
-	mutex_unlock(&ha->vport_lock);
+	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
 	    "ring_ptr=%p ring_index=%d, "
 	    "cnt=%d id=%d max_q_depth=%d.\n",
@@ -724,9 +733,9 @@
 	if (ret != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, base_vha, 0x00df,
 		    "%s failed.\n", __func__);
-		mutex_lock(&ha->vport_lock);
+		mutex_lock(&ha->mq_lock);
 		clear_bit(que_id, ha->req_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 		goto que_failed;
 	}
 
@@ -741,20 +750,20 @@
 static void qla_do_work(struct work_struct *work)
 {
 	unsigned long flags;
-	struct rsp_que *rsp = container_of(work, struct rsp_que, q_work);
+	struct qla_qpair *qpair = container_of(work, struct qla_qpair, q_work);
 	struct scsi_qla_host *vha;
-	struct qla_hw_data *ha = rsp->hw;
+	struct qla_hw_data *ha = qpair->hw;
 
-	spin_lock_irqsave(&rsp->hw->hardware_lock, flags);
+	spin_lock_irqsave(&qpair->qp_lock, flags);
 	vha = pci_get_drvdata(ha->pdev);
-	qla24xx_process_response_queue(vha, rsp);
-	spin_unlock_irqrestore(&rsp->hw->hardware_lock, flags);
+	qla24xx_process_response_queue(vha, qpair->rsp);
+	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 }
 
 /* create response queue */
 int
 qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
-	uint8_t vp_idx, uint16_t rid, int req)
+	uint8_t vp_idx, uint16_t rid, struct qla_qpair *qpair)
 {
 	int ret = 0;
 	struct rsp_que *rsp = NULL;
@@ -779,28 +788,24 @@ static void qla_do_work(struct work_struct *work)
 		goto que_failed;
 	}
 
-	mutex_lock(&ha->vport_lock);
+	mutex_lock(&ha->mq_lock);
 	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_rsp_queues);
 	if (que_id >= ha->max_rsp_queues) {
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 		ql_log(ql_log_warn, base_vha, 0x00e2,
 		    "No resources to create additional request queue.\n");
 		goto que_failed;
 	}
 	set_bit(que_id, ha->rsp_qid_map);
 
-	if (ha->flags.msix_enabled)
-		rsp->msix = &ha->msix_entries[que_id + 1];
-	else
-		ql_log(ql_log_warn, base_vha, 0x00e3,
-		    "MSIX not enabled.\n");
+	rsp->msix = qpair->msix;
 
 	ha->rsp_q_map[que_id] = rsp;
 	rsp->rid = rid;
 	rsp->vp_idx = vp_idx;
 	rsp->hw = ha;
 	ql_dbg(ql_dbg_init, base_vha, 0x00e4,
-	    "queue_id=%d rid=%d vp_idx=%d hw=%p.\n",
+	    "rsp queue_id=%d rid=%d vp_idx=%d hw=%p.\n",
 	    que_id, rsp->rid, rsp->vp_idx, rsp->hw);
 	/* Use alternate PCI bus number */
 	if (MSB(rsp->rid))
@@ -812,23 +817,27 @@ static void qla_do_work(struct work_struct *work)
 	if (!IS_MSIX_NACK_CAPABLE(ha))
 		options |= BIT_6;
 
+	/* Set option to indicate response queue creation */
+	options |= BIT_1;
+
 	rsp->options = options;
 	rsp->id = que_id;
 	reg = ISP_QUE_REG(ha, que_id);
 	rsp->rsp_q_in = &reg->isp25mq.rsp_q_in;
 	rsp->rsp_q_out = &reg->isp25mq.rsp_q_out;
 	rsp->in_ptr = (void *)(rsp->ring + rsp->length);
-	mutex_unlock(&ha->vport_lock);
+	mutex_unlock(&ha->mq_lock);
 	ql_dbg(ql_dbg_multiq, base_vha, 0xc00b,
-	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p",
+	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p\n",
 	    rsp->options, rsp->id, rsp->rsp_q_in,
 	    rsp->rsp_q_out);
 	ql_dbg(ql_dbg_init, base_vha, 0x00e5,
-	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p",
+	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p\n",
 	    rsp->options, rsp->id, rsp->rsp_q_in,
 	    rsp->rsp_q_out);
 
-	ret = qla25xx_request_irq(rsp);
+	ret = qla25xx_request_irq(ha, qpair, qpair->msix,
+	    QLA_MSIX_QPAIR_MULTIQ_RSP_Q);
 	if (ret)
 		goto que_failed;
 
@@ -836,19 +845,16 @@ static void qla_do_work(struct work_struct *work)
 	if (ret != QLA_SUCCESS) {
 		ql_log(ql_log_fatal, base_vha, 0x00e7,
 		    "%s failed.\n", __func__);
-		mutex_lock(&ha->vport_lock);
+		mutex_lock(&ha->mq_lock);
 		clear_bit(que_id, ha->rsp_qid_map);
-		mutex_unlock(&ha->vport_lock);
+		mutex_unlock(&ha->mq_lock);
 		goto que_failed;
 	}
-	if (req >= 0)
-		rsp->req = ha->req_q_map[req];
-	else
-		rsp->req = NULL;
+	rsp->req = NULL;
 
 	qla2x00_init_response_q_entries(rsp);
-	if (rsp->hw->wq)
-		INIT_WORK(&rsp->q_work, qla_do_work);
+	if (qpair->hw->wq)
+		INIT_WORK(&qpair->q_work, qla_do_work);
 	return rsp->id;
 
 que_failed:
diff --git a/drivers/scsi/qla2xxx/qla_mq.c b/drivers/scsi/qla2xxx/qla_mq.c
new file mode 100644
index 0000000..c183461
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_mq.c
@@ -0,0 +1,279 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2003-2016 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+#include "qla_gbl.h"
+
+static int
+qla2xxx_set_affinity_hint(struct qla_qpair *qpair, cpumask_var_t cpu_mask)
+{
+	int ret;
+
+	if (!qpair || !qpair->msix)
+		return -EINVAL;
+
+	ret = irq_set_affinity_hint(qpair->msix->vector, cpu_mask);
+
+	return ret;
+}
+
+void
+qla2xxx_qpair_sp_free_dma(void *vha, void *ptr)
+{
+	srb_t *sp = (srb_t *)ptr;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
+	struct qla_hw_data *ha = sp->fcport->vha->hw;
+	void *ctx = GET_CMD_CTX_SP(sp);
+
+	if (sp->flags & SRB_DMA_VALID) {
+		scsi_dma_unmap(cmd);
+		sp->flags &= ~SRB_DMA_VALID;
+	}
+
+	if (sp->flags & SRB_CRC_PROT_DMA_VALID) {
+		dma_unmap_sg(&ha->pdev->dev, scsi_prot_sglist(cmd),
+		    scsi_prot_sg_count(cmd), cmd->sc_data_direction);
+		sp->flags &= ~SRB_CRC_PROT_DMA_VALID;
+	}
+
+	if (sp->flags & SRB_CRC_CTX_DSD_VALID) {
+		/* List assured to be having elements */
+		qla2x00_clean_dsd_pool(ha, sp, NULL);
+		sp->flags &= ~SRB_CRC_CTX_DSD_VALID;
+	}
+
+	if (sp->flags & SRB_CRC_CTX_DMA_VALID) {
+		dma_pool_free(ha->dl_dma_pool, ctx,
+		    ((struct crc_context *)ctx)->crc_ctx_dma);
+		sp->flags &= ~SRB_CRC_CTX_DMA_VALID;
+	}
+
+	if (sp->flags & SRB_FCP_CMND_DMA_VALID) {
+		struct ct6_dsd *ctx1 = (struct ct6_dsd *)ctx;
+
+		dma_pool_free(ha->fcp_cmnd_dma_pool, ctx1->fcp_cmnd,
+		    ctx1->fcp_cmnd_dma);
+		list_splice(&ctx1->dsd_list, &ha->gbl_dsd_list);
+		ha->gbl_dsd_inuse -= ctx1->dsd_use_cnt;
+		ha->gbl_dsd_avail += ctx1->dsd_use_cnt;
+		mempool_free(ctx1, ha->ctx_mempool);
+	}
+
+	CMD_SP(cmd) = NULL;
+	qla2xxx_rel_qpair_sp(sp->qpair, sp);
+}
+
+void
+qla2xxx_qpair_sp_compl(void *data, void *ptr, int res)
+{
+	srb_t *sp = (srb_t *)ptr;
+	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
+
+	cmd->result = res;
+
+	if (atomic_read(&sp->ref_count) == 0) {
+		ql_dbg(ql_dbg_io, sp->fcport->vha, 0x3079,
+		    "SP reference-count to ZERO -- sp=%p cmd=%p.\n",
+		    sp, GET_CMD_SP(sp));
+		if (ql2xextended_error_logging & ql_dbg_io)
+			WARN_ON(atomic_read(&sp->ref_count) == 0);
+		return;
+	}
+	if (!atomic_dec_and_test(&sp->ref_count))
+		return;
+
+	qla2xxx_qpair_sp_free_dma(sp->fcport->vha, sp);
+	cmd->scsi_done(cmd);
+}
+
+struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, cpumask_var_t cpu_mask, int qos, int vp_idx)
+{
+	int rsp_id = 0;
+	int  req_id = 0;
+	int i;
+	int cpu_id;
+	struct qla_hw_data *ha = vha->hw;
+	uint16_t qpair_id = 0;
+	struct qla_qpair *qpair = NULL;
+	struct qla_msix_entry *msix;
+	struct qla_percpu_qp_hint *hint;
+
+	if (!(ha->fw_attributes & BIT_6) || !ha->flags.msix_enabled) {
+		ql_log(ql_log_warn, vha, 0x00181,
+		    "FW/Driver is not multi-queue capable.\n");
+		return NULL;
+	}
+	if (ql2xmqsupport) {
+		qpair = kzalloc(sizeof(struct qla_qpair), GFP_KERNEL);
+		if (qpair == NULL) {
+			ql_log(ql_log_warn, vha, 0x0182,
+			    "Failed to allocate memory for queue pair.\n");
+			return NULL;
+		}
+		memset(qpair, 0, sizeof(struct qla_qpair));
+
+		qpair->hw = vha->hw;
+
+		/* Assign available que pair id */
+		mutex_lock(&ha->mq_lock);
+		qpair_id = find_first_zero_bit(ha->qpair_qid_map, ha->max_qpairs);
+		if (qpair_id >= ha->max_qpairs) {
+			mutex_unlock(&ha->mq_lock);
+			ql_log(ql_log_warn, vha, 0x0183,
+			    "No resources to create additional q pair.\n");
+			goto fail_qid_map;
+		}
+		set_bit(qpair_id, ha->qpair_qid_map);
+		ha->queue_pair_map[qpair_id] = qpair;
+		qpair->id = qpair_id;
+		qpair->vp_idx = vp_idx;
+
+		for (i = 0; i < ha->msix_count; i++) {
+			msix = &ha->msix_entries[i + 2];
+			if (msix->in_use)
+				continue;
+			qpair->msix = msix;
+			ql_log(ql_dbg_multiq, vha, 0xc00f,
+			    "Vector %x selected for qpair\n", msix->vector);
+			break;
+		}
+		if (!qpair->msix) {
+			ql_log(ql_log_warn, vha, 0x0184,
+			    "Out of MSI-X vectors!.\n");
+			goto fail_msix;
+		}
+
+		qpair->msix->in_use = 1;
+		list_add_tail(&qpair->qp_list_elem, &vha->qp_list);
+
+		mutex_unlock(&ha->mq_lock);
+
+		/* Create response queue first */
+		rsp_id = qla25xx_create_rsp_que(ha, 0, 0, 0, qpair);
+		if (!rsp_id) {
+			ql_log(ql_log_warn, vha, 0x0185,
+			    "Failed to create response queue.\n");
+			goto fail_rsp;
+		}
+
+		qpair->rsp = ha->rsp_q_map[rsp_id];
+
+		/* Create request queue */
+		req_id = qla25xx_create_req_que(ha, 0, vp_idx, 0, rsp_id, qos);
+		if (!req_id) {
+			ql_log(ql_log_warn, vha, 0x0186,
+			    "Failed to create request queue.\n");
+			goto fail_req;
+		}
+
+		qpair->req = ha->req_q_map[req_id];
+		qpair->rsp->req = qpair->req;
+
+		if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif) {
+			if (ha->fw_attributes & BIT_4)
+				qpair->difdix_supported = 1;
+		}
+
+		qpair->srb_mempool = mempool_create_slab_pool(SRB_MIN_REQ, srb_cachep);
+		if (!qpair->srb_mempool) {
+			ql_log(ql_log_warn, vha, 0x0191,
+			    "Failed to create srb mempool for qpair %d\n",
+			    qpair->id);
+			goto fail_mempool;
+		}
+
+		/* Set CPU affinity hint */
+		if (cpu_mask)
+			qla2xxx_set_affinity_hint(qpair, cpu_mask);
+
+		if (cpu_mask) {
+			cpumask_copy(&qpair->cpu_mask, cpu_mask);
+			for_each_cpu(cpu_id, cpu_mask) {
+				hint = per_cpu_ptr(vha->qps_hint, cpu_id);
+				hint->change_in_progress = 1;
+				hint->qp = qpair;
+				hint->change_in_progress = 0;
+			}
+		}
+
+		/* Mark as online */
+		qpair->online = 1;
+
+		if (!vha->flags.qpairs_available)
+			vha->flags.qpairs_available = 1;
+
+		ql_dbg(ql_dbg_multiq, vha, 0xc00d,
+		    "Request/Response queue pair created, id %d\n",
+		    qpair->id);
+		ql_dbg(ql_dbg_init, vha, 0x0187,
+		    "Request/Response queue pair created, id %d\n",
+		    qpair->id);
+	}
+	return qpair;
+
+fail_mempool:
+fail_req:
+	qla25xx_delete_rsp_que(vha, qpair->rsp);
+fail_rsp:
+	mutex_lock(&ha->mq_lock);
+	qpair->msix->in_use = 0;
+	list_del(&qpair->qp_list_elem);
+	if (list_empty(&vha->qp_list))
+		vha->flags.qpairs_available = 0;
+	if (cpu_mask) {
+		for_each_cpu(cpu_id, cpu_mask) {
+			hint = per_cpu_ptr(vha->qps_hint, cpu_id);
+			hint->change_in_progress = 1;
+			hint->qp = NULL;
+			hint->change_in_progress = 0;
+		}
+	}
+fail_msix:
+	ha->queue_pair_map[qpair_id] = NULL;
+	clear_bit(qpair_id, ha->qpair_qid_map);
+	mutex_unlock(&ha->mq_lock);
+fail_qid_map:
+	kfree(qpair);
+	return NULL;
+}
+
+int qla2xxx_delete_qpair(struct scsi_qla_host *vha, struct qla_qpair *qpair)
+{
+	int ret, cpu_id;
+	struct qla_hw_data *ha = qpair->hw;
+	struct qla_percpu_qp_hint *hint;
+
+	qpair->delete_in_progress = 1;
+	while (atomic_read(&qpair->ref_count))
+		msleep(500);
+
+	ret = qla25xx_delete_req_que(vha, qpair->req);
+	if (ret != QLA_SUCCESS)
+		goto fail;
+	ret = qla25xx_delete_rsp_que(vha, qpair->rsp);
+	if (ret != QLA_SUCCESS)
+		goto fail;
+
+	mutex_lock(&ha->mq_lock);
+	ha->queue_pair_map[qpair->id] = NULL;
+	clear_bit(qpair->id, ha->qpair_qid_map);
+	list_del(&qpair->qp_list_elem);
+	for_each_cpu(cpu_id, &qpair->cpu_mask) {
+		hint = per_cpu_ptr(vha->qps_hint, cpu_id);
+		hint->change_in_progress = 1;
+		hint->qp = NULL;
+		hint->change_in_progress = 0;
+	}
+	if (list_empty(&vha->qp_list))
+		vha->flags.qpairs_available = 0;
+	mempool_destroy(qpair->srb_mempool);
+	kfree(qpair);
+	mutex_unlock(&ha->mq_lock);
+
+	return QLA_SUCCESS;
+fail:
+	return ret;
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 4616424..fc578d3 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -30,7 +30,7 @@
 /*
  * SRB allocation cache
  */
-static struct kmem_cache *srb_cachep;
+struct kmem_cache *srb_cachep;
 
 /*
  * CT6 CTX allocation cache
@@ -143,19 +143,12 @@
 		"Enables iIDMA settings "
 		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
 
-int ql2xmaxqueues = 1;
-module_param(ql2xmaxqueues, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xmaxqueues,
-		"Enables MQ settings "
-		"Default is 1 for single queue. Set it to number "
-		"of queues in MQ mode.");
-
-int ql2xmultique_tag;
-module_param(ql2xmultique_tag, int, S_IRUGO);
-MODULE_PARM_DESC(ql2xmultique_tag,
-		"Enables CPU affinity settings for the driver "
-		"Default is 0 for no affinity of request and response IO. "
-		"Set it to 1 to turn on the cpu affinity.");
+int ql2xmqsupport;
+module_param(ql2xmqsupport, int, S_IRUGO);
+MODULE_PARM_DESC(ql2xmqsupport,
+		"Enable on demand multiple queue pairs support "
+		"Default is 0 for no support. "
+		"Set it to 1 to turn on mq qpair support.");
 
 int ql2xfwloadbin;
 module_param(ql2xfwloadbin, int, S_IRUGO|S_IWUSR);
@@ -360,6 +353,25 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 		    "Unable to allocate memory for response queue ptrs.\n");
 		goto fail_rsp_map;
 	}
+
+	if (ql2xmqsupport) {
+		ha->queue_pair_map = kzalloc(sizeof(struct qla_qpair *)
+			* ha->max_qpairs, GFP_KERNEL);
+		if (!ha->queue_pair_map) {
+			ql_log(ql_log_fatal, vha, 0x0180,
+			    "Unable to allocate memory for queue pair ptrs.\n");
+			goto fail_qpair_map;
+		}
+		ha->base_qpair = kzalloc(sizeof(struct qla_qpair), GFP_KERNEL);
+		if (ha->base_qpair == NULL) {
+			ql_log(ql_log_warn, vha, 0x0182,
+			    "Failed to allocate base queue pair memory.\n");
+			goto fail_base_qpair;
+		}
+		ha->base_qpair->req = req;
+		ha->base_qpair->rsp = rsp;
+	}
+
 	/*
 	 * Make sure we record at least the request and response queue zero in
 	 * case we need to free them if part of the probe fails.
@@ -370,6 +382,11 @@ static int qla2x00_alloc_queues(struct qla_hw_data *ha, struct req_que *req,
 	set_bit(0, ha->req_qid_map);
 	return 1;
 
+fail_base_qpair:
+	kfree(ha->queue_pair_map);
+fail_qpair_map:
+	kfree(ha->rsp_q_map);
+	ha->rsp_q_map = NULL;
 fail_rsp_map:
 	kfree(ha->req_q_map);
 	ha->req_q_map = NULL;
@@ -439,62 +456,6 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	ha->rsp_q_map = NULL;
 }
 
-static int qla25xx_setup_mode(struct scsi_qla_host *vha)
-{
-	uint16_t options = 0;
-	int ques, req, ret;
-	struct qla_hw_data *ha = vha->hw;
-
-	if (!(ha->fw_attributes & BIT_6)) {
-		ql_log(ql_log_warn, vha, 0x00d8,
-		    "Firmware is not multi-queue capable.\n");
-		goto fail;
-	}
-	if (ql2xmultique_tag) {
-		/* create a request queue for IO */
-		options |= BIT_7;
-		req = qla25xx_create_req_que(ha, options, 0, 0, -1,
-			QLA_DEFAULT_QUE_QOS);
-		if (!req) {
-			ql_log(ql_log_warn, vha, 0x00e0,
-			    "Failed to create request queue.\n");
-			goto fail;
-		}
-		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
-		vha->req = ha->req_q_map[req];
-		options |= BIT_1;
-		for (ques = 1; ques < ha->max_rsp_queues; ques++) {
-			ret = qla25xx_create_rsp_que(ha, options, 0, 0, req);
-			if (!ret) {
-				ql_log(ql_log_warn, vha, 0x00e8,
-				    "Failed to create response queue.\n");
-				goto fail2;
-			}
-		}
-		ha->flags.cpu_affinity_enabled = 1;
-		ql_dbg(ql_dbg_multiq, vha, 0xc007,
-		    "CPU affinity mode enabled, "
-		    "no. of response queues:%d no. of request queues:%d.\n",
-		    ha->max_rsp_queues, ha->max_req_queues);
-		ql_dbg(ql_dbg_init, vha, 0x00e9,
-		    "CPU affinity mode enabled, "
-		    "no. of response queues:%d no. of request queues:%d.\n",
-		    ha->max_rsp_queues, ha->max_req_queues);
-	}
-	return 0;
-fail2:
-	qla25xx_delete_queues(vha);
-	destroy_workqueue(ha->wq);
-	ha->wq = NULL;
-	vha->req = ha->req_q_map[0];
-fail:
-	ha->mqenable = 0;
-	kfree(ha->req_q_map);
-	kfree(ha->rsp_q_map);
-	ha->max_req_queues = ha->max_rsp_queues = 1;
-	return 1;
-}
-
 static char *
 qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str)
 {
@@ -669,7 +630,7 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	qla2x00_rel_sp(sp->fcport->vha, sp);
 }
 
-static void
+void
 qla2x00_sp_compl(void *data, void *ptr, int res)
 {
 	struct qla_hw_data *ha = (struct qla_hw_data *)data;
@@ -706,12 +667,18 @@ static int qla25xx_setup_mode(struct scsi_qla_host *vha)
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 	srb_t *sp;
 	int rval;
+	struct qla_qpair *qpair;
 
 	if (unlikely(test_bit(UNLOADING, &base_vha->dpc_flags))) {
 		cmd->result = DID_NO_CONNECT << 16;
 		goto qc24_fail_command;
 	}
 
+	if (vha->vp_idx && vha->qpair) {
+		qpair = vha->qpair;
+		return qla2xxx_mqueuecommand(host, cmd, qpair);
+	}
+
 	if (ha->flags.eeh_busy) {
 		if (ha->flags.pci_channel_io_perm_failure) {
 			ql_dbg(ql_dbg_aer, vha, 0x9010,
@@ -1658,9 +1625,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 
 	/* Determine queue resources */
 	ha->max_req_queues = ha->max_rsp_queues = 1;
-	if ((ql2xmaxqueues <= 1 && !ql2xmultique_tag) ||
-		(ql2xmaxqueues > 1 && ql2xmultique_tag) ||
-		(!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
+	if (!ql2xmqsupport || (!IS_QLA25XX(ha) && !IS_QLA81XX(ha)))
 		goto mqiobase_exit;
 
 	ha->mqiobase = ioremap(pci_resource_start(ha->pdev, 3),
@@ -1670,26 +1635,22 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		    "MQIO Base=%p.\n", ha->mqiobase);
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev, QLA_PCI_MSIX_CONTROL, &msix);
-		ha->msix_count = msix;
-		/* Max queues are bounded by available msix vectors */
-		/* queue 0 uses two msix vectors */
-		if (ql2xmultique_tag) {
-			cpus = num_online_cpus();
-			ha->max_rsp_queues = (ha->msix_count - 1 > cpus) ?
-				(cpus + 1) : (ha->msix_count - 1);
-			ha->max_req_queues = 2;
-		} else if (ql2xmaxqueues > 1) {
-			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
-			    QLA_MQ_SIZE : ql2xmaxqueues;
-			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc008,
-			    "QoS mode set, max no of request queues:%d.\n",
-			    ha->max_req_queues);
-			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0019,
-			    "QoS mode set, max no of request queues:%d.\n",
-			    ha->max_req_queues);
-		}
+		ha->msix_count = msix + 1;
+		cpus = num_online_cpus();
+		/* Max queues are bounded by available msix vectors and CPUs */
+		/* MB interrupt uses 1 vector */
+		ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
+			(cpus + 1) : (ha->msix_count - 1);
+		ha->max_rsp_queues = ha->max_req_queues;
+		/* Queue pairs is the max value minus the base queue pair */
+		ha->max_qpairs = ha->max_rsp_queues - 1;
+		ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc00e,
+		    "Max no of queues pairs: %d.\n", ha->max_qpairs);
+		ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0188,
+		    "Max no of queues pairs: %d.\n", ha->max_qpairs);
+
 		ql_log_pci(ql_log_info, ha->pdev, 0x001a,
-		    "MSI-X vector count: %d.\n", msix);
+		    "MSI-X vector count: %d.\n", ha->msix_count);
 	} else
 		ql_log_pci(ql_log_info, ha->pdev, 0x001b,
 		    "BAR 3 not enabled.\n");
@@ -1761,26 +1722,25 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 		/* Read MSIX vector size of the board */
 		pci_read_config_word(ha->pdev,
 		    QLA_83XX_PCI_MSIX_CONTROL, &msix);
-		ha->msix_count = msix;
+		ha->msix_count = msix + 1;
 		/* Max queues are bounded by available msix vectors */
 		/* queue 0 uses two msix vectors */
-		if (ql2xmultique_tag) {
+		if (ql2xmqsupport) {
 			cpus = num_online_cpus();
-			ha->max_rsp_queues = (ha->msix_count - 1 > cpus) ?
+			/* MB interrupt uses 1 vector */
+			ha->max_req_queues = (ha->msix_count - 1 > cpus) ?
 				(cpus + 1) : (ha->msix_count - 1);
-			ha->max_req_queues = 2;
-		} else if (ql2xmaxqueues > 1) {
-			ha->max_req_queues = ql2xmaxqueues > QLA_MQ_SIZE ?
-						QLA_MQ_SIZE : ql2xmaxqueues;
-			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc00c,
-			    "QoS mode set, max no of request queues:%d.\n",
-			    ha->max_req_queues);
-			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x011b,
-			    "QoS mode set, max no of request queues:%d.\n",
-			    ha->max_req_queues);
+			ha->max_rsp_queues = ha->max_req_queues;
+			/* Queue pairs is the max value minus
+			 * the base queue pair */
+			ha->max_qpairs = ha->max_req_queues - 1;
+			ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc010,
+			    "Max no of queues pairs: %d.\n", ha->max_qpairs);
+			ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0190,
+			    "Max no of queues pairs: %d.\n", ha->max_qpairs);
 		}
 		ql_log_pci(ql_log_info, ha->pdev, 0x011c,
-		    "MSI-X vector count: %d.\n", msix);
+		    "MSI-X vector count: %d.\n", ha->msix_count);
 	} else
 		ql_log_pci(ql_log_info, ha->pdev, 0x011e,
 		    "BAR 1 not enabled.\n");
@@ -1831,6 +1791,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config     	= qla2x00_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -1869,6 +1830,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla2x00_write_optrom_data,
 	.get_flash_version	= qla2x00_get_flash_version,
 	.start_scsi		= qla2x00_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla2x00_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -1907,6 +1869,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla2x00_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -1945,6 +1908,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_dif_start_scsi,
+	.start_scsi_mq          = qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla2x00_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -1983,6 +1947,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_dif_start_scsi,
+	.start_scsi_mq          = qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla2x00_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -2021,6 +1986,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla82xx_write_optrom_data,
 	.get_flash_version	= qla82xx_get_flash_version,
 	.start_scsi             = qla82xx_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qla82xx_abort_isp,
 	.iospace_config     	= qla82xx_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -2059,6 +2025,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla8044_write_optrom_data,
 	.get_flash_version	= qla82xx_get_flash_version,
 	.start_scsi             = qla82xx_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qla8044_abort_isp,
 	.iospace_config		= qla82xx_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -2097,6 +2064,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_dif_start_scsi,
+	.start_scsi_mq          = qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla83xx_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -2135,6 +2103,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qlafx00_start_scsi,
+	.start_scsi_mq          = NULL,
 	.abort_isp		= qlafx00_abort_isp,
 	.iospace_config		= qlafx00_iospace_config,
 	.initialize_adapter	= qlafx00_initialize_adapter,
@@ -2173,6 +2142,7 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	.write_optrom		= qla24xx_write_optrom_data,
 	.get_flash_version	= qla24xx_get_flash_version,
 	.start_scsi		= qla24xx_dif_start_scsi,
+	.start_scsi_mq          = qla2xxx_dif_start_scsi_mq,
 	.abort_isp		= qla2x00_abort_isp,
 	.iospace_config		= qla83xx_iospace_config,
 	.initialize_adapter	= qla2x00_initialize_adapter,
@@ -2398,6 +2368,7 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	uint16_t req_length = 0, rsp_length = 0;
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
+
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
 	sht = &qla2xxx_driver_template;
 	if (pdev->device == PCI_DEVICE_ID_QLOGIC_ISP2422 ||
@@ -2661,6 +2632,7 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	    "Found an ISP%04X irq %d iobase 0x%p.\n",
 	    pdev->device, pdev->irq, ha->iobase);
 	mutex_init(&ha->vport_lock);
+	mutex_init(&ha->mq_lock);
 	init_completion(&ha->mbx_cmd_comp);
 	complete(&ha->mbx_cmd_comp);
 	init_completion(&ha->mbx_intr_comp);
@@ -2748,7 +2720,11 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	    host->max_cmd_len, host->max_channel, host->max_lun,
 	    host->transportt, sht->vendor_id);
 
-que_init:
+	/* Set up the irqs */
+	ret = qla2x00_request_irqs(ha, rsp);
+	if (ret)
+		goto probe_init_failed;
+
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha, req, rsp)) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
@@ -2759,11 +2735,6 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 
 	qlt_probe_one_stage1(base_vha, ha);
 
-	/* Set up the irqs */
-	ret = qla2x00_request_irqs(ha, rsp);
-	if (ret)
-		goto probe_init_failed;
-
 	pci_save_state(pdev);
 
 	/* Assign back pointers */
@@ -2863,11 +2834,8 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 	    base_vha->mgmt_svr_loop_id, host->sg_tablesize);
 
 	if (ha->mqenable) {
-		if (qla25xx_setup_mode(base_vha)) {
-			ql_log(ql_log_warn, base_vha, 0x00ec,
-			    "Failed to create queues, falling back to single queue mode.\n");
-			goto que_init;
-		}
+		base_vha->qps_hint = alloc_percpu(struct qla_percpu_qp_hint);
+		ha->wq = alloc_workqueue("qla2xxx_wq", WQ_MEM_RECLAIM, 1);
 	}
 
 	if (ha->flags.running_gold_fw)
@@ -4056,6 +4024,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	INIT_LIST_HEAD(&vha->qla_sess_op_cmd_list);
 	INIT_LIST_HEAD(&vha->logo_list);
 	INIT_LIST_HEAD(&vha->plogi_ack_list);
+	INIT_LIST_HEAD(&vha->qp_list);
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
@@ -5097,6 +5066,8 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 {
 	scsi_qla_host_t *base_vha;
 	struct qla_hw_data *ha;
+	uint32_t online;
+	struct qla_qpair *qpair;
 
 	ha = (struct qla_hw_data *)data;
 	base_vha = pci_get_drvdata(ha->pdev);
@@ -5358,6 +5329,22 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 				ha->isp_ops->beacon_blink(base_vha);
 		}
 
+		/* qpair online check */
+		if (test_and_clear_bit(QPAIR_ONLINE_CHECK_NEEDED,
+		    &base_vha->dpc_flags)) {
+			if (ha->flags.eeh_busy ||
+			    ha->flags.pci_channel_io_perm_failure)
+				online = 0;
+			else
+				online = 1;
+
+			mutex_lock(&ha->mq_lock);
+			list_for_each_entry(qpair, &base_vha->qp_list,
+			    qp_list_elem)
+			qpair->online = online;
+			mutex_unlock(&ha->mq_lock);
+		}
+
 		if (!IS_QLAFX00(ha))
 			qla2x00_do_dpc_all_vps(base_vha);
 
@@ -5700,6 +5687,10 @@ struct fw_blob *
 	switch (state) {
 	case pci_channel_io_normal:
 		ha->flags.eeh_busy = 0;
+		if (ql2xmqsupport) {
+			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		ha->flags.eeh_busy = 1;
@@ -5713,10 +5704,18 @@ struct fw_blob *
 		pci_disable_device(pdev);
 		/* Return back all IOs */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
+		if (ql2xmqsupport) {
+			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		ha->flags.pci_channel_io_perm_failure = 1;
 		qla2x00_abort_all_cmds(vha, DID_NO_CONNECT << 16);
+		if (ql2xmqsupport) {
+			set_bit(QPAIR_ONLINE_CHECK_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
+		}
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 	return PCI_ERS_RESULT_NEED_RESET;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index bff9689..7d0723d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6545,6 +6545,10 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 		/* Disable Full Login after LIP */
 		nv->host_p &= cpu_to_le32(~BIT_10);
+		/* clear BIT 15 explicitly as we have seen at least
+		 * a couple of instances where this was set
+		 * and this was causing the firmware to not be initialized. */
+		nv->firmware_options_1 &= __constant_cpu_to_le32(~BIT_15);
 		/* Enable target PRLI control */
 		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
 	} else {
diff --git a/drivers/scsi/qla2xxx/qla_top.c b/drivers/scsi/qla2xxx/qla_top.c
new file mode 100644
index 0000000..d4a22ca
--- /dev/null
+++ b/drivers/scsi/qla2xxx/qla_top.c
@@ -0,0 +1,95 @@
+/*
+ * QLogic Fibre Channel HBA Driver
+ * Copyright (c)  2016 QLogic Corporation
+ *
+ * See LICENSE.qla2xxx for copyright and licensing details.
+ */
+#include "qla_def.h"
+
+
+int
+qla2xxx_mqueuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd, struct qla_qpair *qpair)
+{
+	scsi_qla_host_t *vha = shost_priv(host);
+	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
+	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	srb_t *sp;
+	int rval;
+
+	rval = fc_remote_port_chkready(rport);
+	if (rval) {
+		cmd->result = rval;
+		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3076,
+		    "fc_remote_port_chkready failed for cmd=%p, rval=0x%x.\n",
+		    cmd, rval);
+		goto qc24_fail_command;
+	}
+
+	if (!fcport) {
+		cmd->result = DID_NO_CONNECT << 16;
+		goto qc24_fail_command;
+	}
+
+	if (atomic_read(&fcport->state) != FCS_ONLINE) {
+		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
+			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
+			ql_dbg(ql_dbg_io, vha, 0x3077,
+			    "Returning DNC, fcport_state=%d loop_state=%d.\n",
+			    atomic_read(&fcport->state),
+			    atomic_read(&base_vha->loop_state));
+			cmd->result = DID_NO_CONNECT << 16;
+			goto qc24_fail_command;
+		}
+		goto qc24_target_busy;
+	}
+
+	/*
+	 * Return target busy if we've received a non-zero retry_delay_timer
+	 * in a FCP_RSP.
+	 */
+	if (fcport->retry_delay_timestamp == 0) {
+		/* retry delay not set */
+	} else if (time_after(jiffies, fcport->retry_delay_timestamp))
+		fcport->retry_delay_timestamp = 0;
+	else
+		goto qc24_target_busy;
+
+	sp = qla2xxx_get_qpair_sp(qpair, fcport, GFP_ATOMIC);
+	if (!sp)
+		goto qc24_host_busy;
+
+	sp->u.scmd.cmd = cmd;
+	sp->type = SRB_SCSI_CMD;
+	atomic_set(&sp->ref_count, 1);
+	CMD_SP(cmd) = (void *)sp;
+	sp->free = qla2xxx_qpair_sp_free_dma;
+	sp->done = qla2xxx_qpair_sp_compl;
+	sp->qpair = qpair;
+
+	rval = ha->isp_ops->start_scsi_mq(sp);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
+		    "Start scsi failed rval=%d for cmd=%p.\n", rval, cmd);
+		if (rval == QLA_INTERFACE_ERROR)
+			goto qc24_fail_command;
+		goto qc24_host_busy_free_sp;
+	}
+
+	return 0;
+
+qc24_host_busy_free_sp:
+	qla2xxx_qpair_sp_free_dma(vha, sp);
+
+qc24_host_busy:
+	return SCSI_MLQUEUE_HOST_BUSY;
+
+qc24_target_busy:
+	return SCSI_MLQUEUE_TARGET_BUSY;
+
+qc24_fail_command:
+	cmd->scsi_done(cmd);
+
+	return 0;
+}
-- 
1.8.3.1

