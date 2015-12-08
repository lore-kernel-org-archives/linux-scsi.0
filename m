From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 11/20] qla2xxx: Add TAS detection for kernel 3.15 n newer
Date: Mon, 7 Dec 2015 19:48:58 -0500
Message-ID: <1449535747-2850-12-git-send-email-himanshu.madhani@qlogic.com>
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

For kernel 3.15 and newer with TCM API change, add detection
for TCM support of TAS.  Instead of default command terminate
for LUN/TARGET reset error handling, allow SCSI status to go
out if we know sequece Initiative is own by FW (cmd_sent_to_fw=0)

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |   36 +++++++++++++++++-------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   20 ++++++++++++++++++++
 2 files changed, 37 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4d42b79..5fca846 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3239,36 +3239,34 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 	struct qla_tgt *tgt = cmd->tgt;
 	struct scsi_qla_host *vha = tgt->vha;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
-	unsigned long flags,refcount;
+	unsigned long flags, refcount;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf014,
 	    "qla_target(%d): terminating exchange for aborted cmd=%p "
 	    "(se_cmd=%p, tag=%llu)", vha->vp_idx, cmd, &cmd->se_cmd,
 	    se_cmd->tag);
 
-    spin_lock_irqsave(&cmd->cmd_lock, flags);
-    if (cmd->aborted) {
-        spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+	spin_lock_irqsave(&cmd->cmd_lock, flags);
 
-        /* It's normal to see 2 calls in this path:
-         *  1) XFER Rdy completion + CMD_T_ABORT
-         *  2) TCM TMR - drain_state_list
-         */
-        refcount = atomic_read(&cmd->se_cmd.cmd_kref.refcount);
-        ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
-               "multiple abort. %p refcount %lx"
-               "transport_state %x, t_state %x, se_cmd_flags %x \n",
-               cmd, refcount,cmd->se_cmd.transport_state,
-               cmd->se_cmd.t_state,cmd->se_cmd.se_cmd_flags);
+	if (cmd->aborted) {
+		spin_unlock_irqrestore(&cmd->cmd_lock, flags);
+		/* It's normal to see 2 calls in this path:
+		 *  1) XFER Rdy completion + CMD_T_ABORT
+		 *  2) TCM TMR - drain_state_list
+		 */
+		refcount = atomic_read(&cmd->se_cmd.cmd_kref.refcount);
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+		    "multiple abort. %p refcount %lx"
+		    "transport_state %x, t_state %x, se_cmd_flags %x \n",
+		    cmd, refcount, cmd->se_cmd.transport_state,
+		    cmd->se_cmd.t_state, cmd->se_cmd.se_cmd_flags);
 
-        return EIO;
-    }
+		return EIO;
+	}
 
 	cmd->aborted = 1;
 	cmd->cmd_flags |= BIT_6;
-    spin_unlock_irqrestore(&cmd->cmd_lock, flags);
-
-	qlt_send_term_exchange(vha, cmd, &cmd->atio, 0, 1);
+	spin_unlock_irqrestore(&cmd->cmd_lock, flags);
 
 	return 0;
 }
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 842fcca..2e9c194 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -617,6 +617,26 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
 				struct qla_tgt_cmd, se_cmd);
 	int xmit_type = QLA_TGT_XMIT_STATUS;
 
+	if (se_cmd->transport_state & CMD_T_ABORTED) {
+		/* For TCM TAS support n kernel >= 3.15:
+		 * This cmd is attempting to respond with "Task Aborted Status".
+		 */
+		if (cmd->aborted) {
+			return 0;
+		} else if ((cmd->state == QLA_TGT_STATE_NEED_DATA) &&
+		    cmd->cmd_sent_to_fw) {
+			qlt_abort_cmd(cmd);
+			return 0;
+		} else if (cmd->state == QLA_TGT_STATE_PROCESSED) {
+			if (cmd->cmd_sent_to_fw) {
+				qlt_abort_cmd(cmd);
+				return 0;
+			} else {	/* about to be free */
+				return 0;
+			}
+		}
+	}
+
 	cmd->bufflen = se_cmd->data_length;
 	cmd->sg = NULL;
 	cmd->sg_cnt = 0;
-- 
1.7.7
