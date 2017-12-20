From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 08/43] qla2xxx: Chip reset uses wrong lock during IO flush.
Date: Tue, 19 Dec 2017 22:56:09 -0800
Message-ID: <20171220065644.21511-9-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0060.outbound.protection.outlook.com ([104.47.40.60]:46796
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932386AbdLTG5E (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:04 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

As part of chip reset, all commands from all QPairs are
flushed. This patch fixes code to use Q Pair lock for flush
instead of using old hardware_lock.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 139 +++++++++++++++++++-----------------------
 1 file changed, 64 insertions(+), 75 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7f361e93c593..4a542a5a976d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1709,94 +1709,83 @@ qla2x00_loop_reset(scsi_qla_host_t *vha)
 	return QLA_SUCCESS;
 }
 
-void
-qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
+static void
+__qla2x00_abort_all_cmds(struct qla_qpair *qp, int res)
 {
-	int que, cnt, status;
+	int cnt;
 	unsigned long flags;
 	srb_t *sp;
+	scsi_qla_host_t *vha = qp->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_cmd *cmd;
 	uint8_t trace = 0;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
-	for (que = 0; que < ha->max_req_queues; que++) {
-		req = ha->req_q_map[que];
-		if (!req)
-			continue;
-		if (!req->outstanding_cmds)
-			continue;
-		for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
-			sp = req->outstanding_cmds[cnt];
-			if (sp) {
-				req->outstanding_cmds[cnt] = NULL;
-				if (sp->cmd_type == TYPE_SRB) {
-					if (sp->type == SRB_NVME_CMD ||
-					    sp->type == SRB_NVME_LS) {
-						sp_get(sp);
-						spin_unlock_irqrestore(
-						    &ha->hardware_lock, flags);
-						qla_nvme_abort(ha, sp);
-						spin_lock_irqsave(
-						    &ha->hardware_lock, flags);
-					} else if (GET_CMD_SP(sp) &&
-					    !ha->flags.eeh_busy &&
-					    (!test_bit(ABORT_ISP_ACTIVE,
-						&vha->dpc_flags)) &&
-					    (sp->type == SRB_SCSI_CMD)) {
-						/*
-						 * Don't abort commands in
-						 * adapter during EEH
-						 * recovery as it's not
-						 * accessible/responding.
-						 *
-						 * Get a reference to the sp
-						 * and drop the lock. The
-						 * reference ensures this
-						 * sp->done() call and not the
-						 * call in qla2xxx_eh_abort()
-						 * ends the SCSI command (with
-						 * result 'res').
-						 */
-						sp_get(sp);
-						spin_unlock_irqrestore(
-						    &ha->hardware_lock, flags);
-						status = qla2xxx_eh_abort(
-						    GET_CMD_SP(sp));
-						spin_lock_irqsave(
-						    &ha->hardware_lock, flags);
-						/*
-						 * Get rid of extra reference
-						 * if immediate exit from
-						 * ql2xxx_eh_abort
-						 */
-						if (status == FAILED &&
-						    (qla2x00_isp_reg_stat(ha)))
-							atomic_dec(
-							    &sp->ref_count);
-					}
-					qla_put_iocbs(sp->qpair, &sp->iores);
-					sp->done(sp, res);
-				} else {
-					if (!vha->hw->tgt.tgt_ops || !tgt ||
-					    qla_ini_mode_enabled(vha)) {
-						if (!trace)
-							ql_dbg(ql_dbg_tgt_mgt,
-							    vha, 0xf003,
-							    "HOST-ABORT-HNDLR: dpc_flags=%lx. Target mode disabled\n",
-							    vha->dpc_flags);
-						continue;
-					}
-					cmd = (struct qla_tgt_cmd *)sp;
-					qlt_abort_cmd_on_host_reset(cmd->vha,
-					    cmd);
+	spin_lock_irqsave(qp->qp_lock_ptr, flags);
+	req = qp->req;
+	for (cnt = 1; cnt < req->num_outstanding_cmds; cnt++) {
+		sp = req->outstanding_cmds[cnt];
+		if (sp) {
+			req->outstanding_cmds[cnt] = NULL;
+			if (sp->cmd_type == TYPE_SRB) {
+				/*
+				 * Don't abort commands in adapter during EEH
+				 * recovery as it's not accessible/responding.
+				 */
+				if (GET_CMD_SP(sp) && !ha->flags.eeh_busy &&
+				    (!test_bit(ABORT_ISP_ACTIVE,
+					&vha->dpc_flags)) &&
+				    (sp->type == SRB_SCSI_CMD)) {
+					/*
+					 * Get a reference to the sp and drop
+					 * the lock. The reference ensures this
+					 * sp->done() call and
+					 * - not the call in qla2xxx_eh_abort()
+					 * - ends the SCSI command (with result
+					 *   'res').
+					 */
+					sp_get(sp);
+					spin_unlock_irqrestore(qp->qp_lock_ptr,
+					    flags);
+					qla2xxx_eh_abort(GET_CMD_SP(sp));
+					spin_lock_irqsave(qp->qp_lock_ptr,
+					    flags);
 				}
+				qla_put_iocbs(sp->qpair, &sp->iores);
+				sp->done(sp, res);
+			} else {
+				if (!vha->hw->tgt.tgt_ops ||
+				    !tgt || qla_ini_mode_enabled(vha)) {
+					if (!trace)
+						ql_dbg(ql_dbg_tgt_mgt, vha,
+						    0xf003,
+						    "HOST-ABORT-HNDLR: dpc_flags=%lx. Target mode disabled\n",
+						    vha->dpc_flags);
+					continue;
+				}
+				cmd = (struct qla_tgt_cmd *)sp;
+				qlt_abort_cmd_on_host_reset(cmd->vha, cmd);
 			}
 		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+}
+
+void
+qla2x00_abort_all_cmds(scsi_qla_host_t *vha, int res)
+{
+	int que;
+	struct qla_hw_data *ha = vha->hw;
+
+	__qla2x00_abort_all_cmds(ha->base_qpair, res);
+
+	for (que = 0; que < ha->max_qpairs; que++) {
+		if (!ha->queue_pair_map[que])
+			continue;
+
+		__qla2x00_abort_all_cmds(ha->queue_pair_map[que], res);
+	}
 }
 
 static int
-- 
2.12.0
