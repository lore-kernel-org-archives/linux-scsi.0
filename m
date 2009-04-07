From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 06/15] qla2xxx: Remove reference to request queue from scsi request block.
Date: Mon,  6 Apr 2009 22:33:42 -0700
Message-ID: <1239082431-19496-7-git-send-email-andrew.vasquez@qlogic.com>
References: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29400 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbZDGFeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 01:34:03 -0400
In-Reply-To: <1239082431-19496-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

srbs used to maintain a reference to the request queue on which
it was enqueued. This is no longer required as the request queue
pointer is now maintained in the scsi host that issues the srb.

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    2 --
 drivers/scsi/qla2xxx/qla_init.c |   20 ++++++++++++++++----
 drivers/scsi/qla2xxx/qla_iocb.c |   22 ++++++++--------------
 drivers/scsi/qla2xxx/qla_mbx.c  |    2 +-
 drivers/scsi/qla2xxx/qla_os.c   |    6 ++----
 5 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 09190ba..6911b9b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -188,7 +188,6 @@ struct req_que;
  * SCSI Request Block
  */
 typedef struct srb {
-	struct req_que *que;
 	struct fc_port *fcport;
 
 	struct scsi_cmnd *cmd;		/* Linux SCSI command pkt */
@@ -2010,7 +2009,6 @@ typedef struct vport_params {
 #define VP_RET_CODE_NOT_FOUND		6
 
 struct qla_hw_data;
-struct req_que;
 struct rsp_que;
 /*
  * ISP operations
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 059909c..4c14cde 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3177,8 +3177,14 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 {
 	int rval = QLA_SUCCESS;
 	uint32_t wait_time;
-	struct req_que *req = vha->req;
-	struct rsp_que *rsp = req->rsp;
+	struct req_que *req;
+	struct rsp_que *rsp;
+
+	if (ql2xmultique_tag)
+		req = vha->hw->req_q_map[0];
+	else
+		req = vha->req;
+	rsp = req->rsp;
 
 	atomic_set(&vha->loop_state, LOOP_UPDATE);
 	clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
@@ -4163,13 +4169,19 @@ qla24xx_configure_vhba(scsi_qla_host_t *vha)
 	uint16_t mb[MAILBOX_REGISTER_COUNT];
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
-	struct req_que *req = vha->req;
-	struct rsp_que *rsp = req->rsp;
+	struct req_que *req;
+	struct rsp_que *rsp;
 
 	if (!vha->vp_idx)
 		return -EINVAL;
 
 	rval = qla2x00_fw_ready(base_vha);
+	if (ql2xmultique_tag)
+		req = ha->req_q_map[0];
+	else
+		req = vha->req;
+	rsp = req->rsp;
+
 	if (rval == QLA_SUCCESS) {
 		clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags);
 		qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL);
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7b15ded..b4c6010 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -93,9 +93,10 @@ qla2x00_calc_iocbs_64(uint16_t dsds)
  * Returns a pointer to the Continuation Type 0 IOCB packet.
  */
 static inline cont_entry_t *
-qla2x00_prep_cont_type0_iocb(struct req_que *req, struct scsi_qla_host *vha)
+qla2x00_prep_cont_type0_iocb(struct scsi_qla_host *vha)
 {
 	cont_entry_t *cont_pkt;
+	struct req_que *req = vha->req;
 	/* Adjust ring index. */
 	req->ring_index++;
 	if (req->ring_index == req->length) {
@@ -121,10 +122,11 @@ qla2x00_prep_cont_type0_iocb(struct req_que *req, struct scsi_qla_host *vha)
  * Returns a pointer to the continuation type 1 IOCB packet.
  */
 static inline cont_a64_entry_t *
-qla2x00_prep_cont_type1_iocb(struct req_que *req, scsi_qla_host_t *vha)
+qla2x00_prep_cont_type1_iocb(scsi_qla_host_t *vha)
 {
 	cont_a64_entry_t *cont_pkt;
 
+	struct req_que *req = vha->req;
 	/* Adjust ring index. */
 	req->ring_index++;
 	if (req->ring_index == req->length) {
@@ -160,7 +162,6 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
-	struct req_que *req;
 
 	cmd = sp->cmd;
 
@@ -175,8 +176,6 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
-
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Three DSDs are available in the Command Type 2 IOCB */
@@ -193,7 +192,7 @@ void qla2x00_build_scsi_iocbs_32(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Seven DSDs are available in the Continuation
 			 * Type 0 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type0_iocb(req, vha);
+			cont_pkt = qla2x00_prep_cont_type0_iocb(vha);
 			cur_dsd = (uint32_t *)&cont_pkt->dseg_0_address;
 			avail_dsds = 7;
 		}
@@ -221,7 +220,6 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	struct scsi_cmnd *cmd;
 	struct scatterlist *sg;
 	int i;
-	struct req_que *req;
 
 	cmd = sp->cmd;
 
@@ -236,8 +234,6 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
-
 	cmd_pkt->control_flags |= cpu_to_le16(qla2x00_get_cmd_direction(sp));
 
 	/* Two DSDs are available in the Command Type 3 IOCB */
@@ -255,7 +251,7 @@ void qla2x00_build_scsi_iocbs_64(srb_t *sp, cmd_entry_t *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(req, vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -354,7 +350,6 @@ qla2x00_start_scsi(srb_t *sp)
 	/* Build command packet */
 	req->current_outstanding_cmd = handle;
 	req->outstanding_cmds[handle] = sp;
-	sp->que = req;
 	sp->cmd->host_scribble = (unsigned char *)(unsigned long)handle;
 	req->cnt -= req_cnt;
 
@@ -655,7 +650,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 	}
 
 	vha = sp->fcport->vha;
-	req = sp->que;
+	req = vha->req;
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
@@ -686,7 +681,7 @@ qla24xx_build_scsi_iocbs(srb_t *sp, struct cmd_type_7 *cmd_pkt,
 			 * Five DSDs are available in the Continuation
 			 * Type 1 IOCB.
 			 */
-			cont_pkt = qla2x00_prep_cont_type1_iocb(req, vha);
+			cont_pkt = qla2x00_prep_cont_type1_iocb(vha);
 			cur_dsd = (uint32_t *)cont_pkt->dseg_0_address;
 			avail_dsds = 5;
 		}
@@ -728,7 +723,6 @@ qla24xx_start_scsi(srb_t *sp)
 	ret = 0;
 
 	qla25xx_set_que(sp, &req, &rsp);
-	sp->que = req;
 
 	/* So we know we haven't pci_map'ed anything yet */
 	tot_dsds = 0;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 366522e..258c39d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2232,7 +2232,7 @@ qla24xx_abort_command(srb_t *sp)
 	fc_port_t	*fcport = sp->fcport;
 	struct scsi_qla_host *vha = fcport->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req = sp->que;
+	struct req_que *req = vha->req;
 
 	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0ca92f2..540d731 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -441,7 +441,6 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	sp->fcport = fcport;
 	sp->cmd = cmd;
-	sp->que = ha->req_q_map[0];
 	sp->flags = 0;
 	CMD_SP(cmd) = (void *)sp;
 	cmd->scsi_done = done;
@@ -742,7 +741,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	unsigned long flags;
 	int wait = 0;
 	struct qla_hw_data *ha = vha->hw;
-	struct req_que *req;
+	struct req_que *req = vha->req;
 	srb_t *spt;
 
 	qla2x00_block_error_handler(cmd);
@@ -758,7 +757,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	spt = (srb_t *) CMD_SP(cmd);
 	if (!spt)
 		return SUCCESS;
-	req = spt->que;
 
 	/* Check active list for command command. */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -826,7 +824,7 @@ qla2x00_eh_wait_for_pending_commands(scsi_qla_host_t *vha, unsigned int t,
 		return status;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	req = sp->que;
+	req = vha->req;
 	for (cnt = 1; status == QLA_SUCCESS &&
 		cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
 		sp = req->outstanding_cmds[cnt];
-- 
1.6.2.2.404.ge96f3

