From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 6/8] qla2xxx: Use proper request/response queues with MQ instantiations.
Date: Mon,  5 Jan 2009 11:18:10 -0800
Message-ID: <1231183092-10471-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbZAETSY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:24 -0500
In-Reply-To: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Original code would inadvertanly place I/Os on the default
request-queue.  Also, correctly pass in the proper MSI-X vector
during response-queue initialization.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    1 -
 drivers/scsi/qla2xxx/qla_iocb.c |   12 +++++-------
 drivers/scsi/qla2xxx/qla_isr.c  |    2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_mid.c  |    4 +++-
 drivers/scsi/qla2xxx/qla_os.c   |    3 +--
 6 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index c8e5af5..6b37622 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -187,7 +187,6 @@ struct req_que;
  * SCSI Request Block
  */
 typedef struct srb {
-	struct scsi_qla_host *vha;	/* HA the SP is queued on */
 	struct req_que *que;
 	struct fc_port *fcport;
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5bedc9d..2258152 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -173,7 +173,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->vha;
+	vha = sp->fcport->vha;
 	req = sp->que;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
@@ -234,7 +234,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 		return;
 	}
 
-	vha = sp->vha;
+	vha = sp->fcport->vha;
 	req = sp->que;
 
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
@@ -294,7 +294,7 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Setup device pointers. */
 	ret = 0;
-	vha = sp->vha;
+	vha = sp->fcport->vha;
 	ha = vha->hw;
 	reg = &ha->iobase->isp;
 	cmd = sp->cmd;
@@ -353,7 +353,6 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
-	sp->vha = vha;
 	sp->que = req;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
@@ -656,7 +655,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 		return;
 	}
 
-	vha = sp->vha;
+	vha = sp->fcport->vha;
 	req = sp->que;
 
 	/* Set transfer direction */
@@ -723,7 +722,7 @@ qla24xx_start_scsi(srb_t *sp)
 	struct req_que *req = NULL;
 	struct rsp_que *rsp = NULL;
 	struct scsi_cmnd *cmd = sp->cmd;
-	struct scsi_qla_host *vha = sp->vha;
+	struct scsi_qla_host *vha = sp->fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
 	uint16_t que_id;
 
@@ -791,7 +790,6 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Build command packet. */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
-	sp->vha = vha;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 5ff6f94..dcfec74 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2026,7 +2026,7 @@ qla2x00_get_rsp_host(struct rsp_que *rsp)
 		if (pkt && pkt->handle < MAX_OUTSTANDING_COMMANDS) {
 			sp = req->outstanding_cmds[pkt->handle];
 			if (sp)
-				vha = sp->vha;
+				vha = sp->fcport->vha;
 		}
 	}
 	if (!vha)
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 29bf8bc..4cb6791 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3145,7 +3145,7 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp,
 	mcp->mb[7] = LSW(MSD(rsp->dma));
 	mcp->mb[5] = rsp->length;
 	mcp->mb[11] = rsp->vp_idx;
-	mcp->mb[14] = rsp->msix->vector;
+	mcp->mb[14] = rsp->msix->entry;
 	mcp->mb[13] = rsp->rid;
 
 	reg = (struct device_reg_25xxmq *)((void *)(ha->mqiobase) +
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 386ffea..8863231 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -614,8 +614,10 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->vp_idx = vp_idx;
 	req->qos = qos;
 
-	if (ha->rsp_q_map[rsp_que])
+	if (ha->rsp_q_map[rsp_que]) {
 		req->rsp = ha->rsp_q_map[rsp_que];
+		req->rsp->req = req;
+	}
 	/* Use alternate PCI bus number */
 	if (MSB(req->rid))
 		options |= BIT_4;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 3580c03..1b475c5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -438,7 +438,6 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 	if (!sp)
 		return sp;
 
-	sp->vha = vha;
 	sp->fcport = fcport;
 	sp->cmd = cmd;
 	sp->que = ha->req_q_map[0];
@@ -1182,7 +1181,7 @@ qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
 			continue;
 		for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 			sp = req->outstanding_cmds[cnt];
-			if (sp && sp->vha == vha) {
+			if (sp && sp->fcport->vha == vha) {
 				req->outstanding_cmds[cnt] = NULL;
 				sp->cmd->result = res;
 				qla2x00_sp_compl(ha, sp);
-- 
1.6.1.28.gc32f76

