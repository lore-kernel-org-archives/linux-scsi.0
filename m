From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 08/20] qla2xxx: Replace QLA_TGT_STATE_ABORTED with a bit.
Date: Mon, 7 Dec 2015 19:48:55 -0500
Message-ID: <1449535747-2850-9-git-send-email-himanshu.madhani@qlogic.com>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@qlogic.com>

Replace QLA_TGT_STATE_ABORTED state with a bit because
the current state of the command is lost when an abort
is requested by upper layer.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   23 ++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.h |    3 ++-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 57b4294..638940f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1468,7 +1468,7 @@ static int abort_cmd_for_tag(struct scsi_qla_host *vha, uint32_t tag)
 
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		if (tag == cmd->atio.u.isp24.exchange_addr) {
-			cmd->state = QLA_TGT_STATE_ABORTED;
+			cmd->aborted = 1;
 			spin_unlock(&vha->cmd_list_lock);
 			return 1;
 		}
@@ -1510,7 +1510,7 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 		cmd_lun = scsilun_to_int(
 			(struct scsi_lun *)&cmd->atio.u.isp24.fcp_cmnd.lun);
 		if (cmd_key == key && cmd_lun == lun)
-			cmd->state = QLA_TGT_STATE_ABORTED;
+			cmd->aborted = 1;
 	}
 	spin_unlock(&vha->cmd_list_lock);
 }
@@ -3174,7 +3174,7 @@ static void qlt_send_term_exchange(struct scsi_qla_host *vha,
 		qlt_alloc_qfull_cmd(vha, atio, 0, 0);
 
 done:
-	if (cmd && ((cmd->state != QLA_TGT_STATE_ABORTED) ||
+	if (cmd && (!cmd->aborted ||
 	    !cmd->cmd_sent_to_fw)) {
 		if (cmd->sg_mapped)
 			qlt_unmap_sg(vha, cmd);
@@ -3245,7 +3245,7 @@ void qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
 	    se_cmd->tag);
 
-	cmd->state = QLA_TGT_STATE_ABORTED;
+	cmd->aborted = 1;
 	cmd->cmd_flags |= BIT_6;
 
 	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0);
@@ -3465,9 +3465,6 @@ qlt_abort_cmd_on_host_reset(struct scsi_qla_host *vha, struct qla_tgt_cmd *cmd)
 
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
-	} else if (cmd->state == QLA_TGT_STATE_ABORTED) {
-		ql_dbg(ql_dbg_io, vha, 0xff02,
-		    "HOST-ABORT: handle=%d, state=ABORTED.\n", handle);
 	} else {
 		ql_dbg(ql_dbg_io, vha, 0xff03,
 		    "HOST-ABORT: handle=%d, state=BAD(%d).\n", handle,
@@ -3632,14 +3629,14 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 		}
 
 
-		/* "cmd->state == QLA_TGT_STATE_ABORTED" means
+		/* "cmd->aborted" means
 		 * cmd is already aborted/terminated, we don't
 		 * need to terminate again.  The exchange is already
 		 * cleaned up/freed at FW level.  Just cleanup at driver
 		 * level.
 		 */
 		if ((cmd->state != QLA_TGT_STATE_NEED_DATA) &&
-		    (cmd->state != QLA_TGT_STATE_ABORTED)) {
+		    (!cmd->aborted)) {
 			cmd->cmd_flags |= BIT_13;
 			if (qlt_term_ctio_exchange(vha, ctio, cmd, status))
 				return;
@@ -3657,7 +3654,7 @@ skip_term:
 
 		ha->tgt.tgt_ops->handle_data(cmd);
 		return;
-	} else if (cmd->state == QLA_TGT_STATE_ABORTED) {
+	} else if (cmd->aborted) {
 		cmd->cmd_flags |= BIT_18;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01e,
 		  "Aborted command %p (tag %lld) finished\n", cmd, se_cmd->tag);
@@ -3669,7 +3666,7 @@ skip_term:
 	}
 
 	if (unlikely(status != CTIO_SUCCESS) &&
-		(cmd->state != QLA_TGT_STATE_ABORTED)) {
+		!cmd->aborted) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf01f, "Finishing failed CTIO\n");
 		dump_stack();
 	}
@@ -3731,7 +3728,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	if (tgt->tgt_stop)
 		goto out_term;
 
-	if (cmd->state == QLA_TGT_STATE_ABORTED) {
+	if (cmd->aborted) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf082,
 		    "cmd with tag %u is aborted\n",
 		    cmd->atio.u.isp24.exchange_addr);
@@ -4289,7 +4286,7 @@ static int abort_cmds_for_s_id(struct scsi_qla_host *vha, port_id_t *s_id)
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		uint32_t cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
 		if (cmd_key == key) {
-			cmd->state = QLA_TGT_STATE_ABORTED;
+			cmd->aborted = 1;
 			count++;
 		}
 	}
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 0a78545..f5dbeab 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -787,7 +787,7 @@ int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
 #define QLA_TGT_STATE_NEED_DATA		1 /* target needs data to continue */
 #define QLA_TGT_STATE_DATA_IN		2 /* Data arrived + target processing */
 #define QLA_TGT_STATE_PROCESSED		3 /* target done processing */
-#define QLA_TGT_STATE_ABORTED		4 /* Command aborted */
+
 
 /* Special handles */
 #define QLA_TGT_NULL_HANDLE	0
@@ -960,6 +960,7 @@ struct qla_tgt_cmd {
 	unsigned int term_exchg:1;
 	unsigned int cmd_sent_to_fw:1;
 	unsigned int cmd_in_wq:1;
+	unsigned int aborted:1;
 
 	struct scatterlist *sg;	/* cmd data buffer SG vector */
 	int sg_cnt;		/* SG segments count */
-- 
1.7.7
