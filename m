From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 3/9] qla2xxx: Move percpu_ida_{alloc|free} to tcm_qla2xxx.
Date: Sun, 18 Dec 2016 01:02:43 -0800
Message-ID: <1482051769-22941-4-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0070.outbound.protection.outlook.com ([104.47.32.70]:63789
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757418AbcLRJDg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 18 Dec 2016 04:03:36 -0500
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Moving code to from qla_target to tcm_qla2xxx.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 37 ++++++-------------------------------
 drivers/scsi/qla2xxx/qla_target.h  |  2 ++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 44 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 452ac1d..8ef8219 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -3225,7 +3225,7 @@ static void qlt_init_term_exchange(struct scsi_qla_host *vha)
 			/* This cmd was never sent to TCM.  There is no need
 			 * to schedule free or call free_cmd
 			 */
-			qlt_free_cmd(cmd);
+			vha->hw->tgt.tgt_ops->release_cmd(cmd);
 			vha->hw->tgt.num_qfull_cmds_alloc--;
 		}
 	}
@@ -3291,8 +3291,6 @@ int qlt_abort_cmd(struct qla_tgt_cmd *cmd)
 
 void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 {
-	struct qla_tgt_sess *sess = cmd->sess;
-
 	ql_dbg(ql_dbg_tgt, cmd->vha, 0xe074,
 	    "%s: se_cmd[%p] ox_id %04x\n",
 	    __func__, &cmd->se_cmd,
@@ -3310,13 +3308,6 @@ void qlt_free_cmd(struct qla_tgt_cmd *cmd)
 	cmd->jiffies_at_free = get_jiffies_64();
 	if (unlikely(cmd->free_sg))
 		kfree(cmd->sg);
-
-	if (!sess || !sess->se_sess) {
-		WARN_ON(1);
-		return;
-	}
-	cmd->jiffies_at_free = get_jiffies_64();
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
 }
 EXPORT_SYMBOL(qlt_free_cmd);
 
@@ -3822,7 +3813,7 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	qlt_send_term_exchange(vha, NULL, &cmd->atio, 1, 0);
 
 	qlt_decr_num_pend_cmds(vha);
-	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
+	ha->tgt.tgt_ops->release_cmd(cmd);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -3847,23 +3838,17 @@ static struct qla_tgt_cmd *qlt_get_tag(scsi_qla_host_t *vha,
 				       struct qla_tgt_sess *sess,
 				       struct atio_from_isp *atio)
 {
-	struct se_session *se_sess = sess->se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
 
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
-	if (tag < 0)
+	cmd = vha->hw->tgt.tgt_ops->alloc_cmd(sess);
+	if (!cmd)
 		return NULL;
 
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
-	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 	cmd->state = QLA_TGT_STATE_NEW;
 	cmd->tgt = vha->vha_tgt.qla_tgt;
 	qlt_incr_num_pend_cmds(vha);
 	cmd->vha = vha;
-	cmd->se_cmd.map_tag = tag;
 	cmd->sess = sess;
 	cmd->loop_id = sess->loop_id;
 	cmd->conf_compl_supported = sess->conf_compl_supported;
@@ -5138,9 +5123,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess;
-	struct se_session *se_sess;
 	struct qla_tgt_cmd *cmd;
-	int tag;
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x300a,
@@ -5169,13 +5152,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	if (!sess)
 		return;
 
-	se_sess = sess->se_sess;
-
-	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
-	if (tag < 0)
-		return;
-
-	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	cmd = ha->tgt.tgt_ops->alloc_cmd(sess);
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3009,
 			"qla_target(%d): %s: Allocation of cmd failed\n",
@@ -5191,8 +5168,6 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 		return;
 	}
 
-	memset(cmd, 0, sizeof(struct qla_tgt_cmd));
-
 	qlt_incr_num_pend_cmds(vha);
 	INIT_LIST_HEAD(&cmd->cmd_list);
 	memcpy(&cmd->atio, atio, sizeof(*atio));
@@ -5277,7 +5252,7 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 		/* This cmd was never sent to TCM.  There is no need
 		 * to schedule free or call free_cmd
 		 */
-		qlt_free_cmd(cmd);
+		ha->tgt.tgt_ops->release_cmd(cmd);
 	}
 	return rc;
 }
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 7f11e0c..fbc11f3 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -739,6 +739,8 @@ struct qla_tgt_func_tmpl {
 						const uint8_t *);
 	void (*clear_nacl_from_fcport_map)(struct qla_tgt_sess *);
 	void (*shutdown_sess)(struct qla_tgt_sess *);
+	void (*release_cmd)(struct qla_tgt_cmd *);
+	struct qla_tgt_cmd *(*alloc_cmd)(struct qla_tgt_sess *);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6e98573..9d1fc08 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -327,6 +327,7 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 {
 	struct qla_tgt_cmd *cmd;
+	struct se_session *se_sess;
 
 	if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB) {
 		struct qla_tgt_mgmt_cmd *mcmd = container_of(se_cmd,
@@ -337,6 +338,39 @@ static void tcm_qla2xxx_release_cmd(struct se_cmd *se_cmd)
 
 	cmd = container_of(se_cmd, struct qla_tgt_cmd, se_cmd);
 	qlt_free_cmd(cmd);
+
+	if (!cmd->sess || !cmd->sess->se_sess) {
+		WARN_ON(1);
+		return;
+	}
+
+	se_sess = (struct se_session *)cmd->sess->se_sess;
+
+	cmd->jiffies_at_free = get_jiffies_64();
+	percpu_ida_free(&se_sess->sess_tag_pool, se_cmd->map_tag);
+}
+
+static void tcm_qla2xxx_rel_cmd(struct qla_tgt_cmd *cmd)
+{
+	tcm_qla2xxx_release_cmd(&cmd->se_cmd);
+}
+
+static struct qla_tgt_cmd *tcm_qla2xxx_alloc_cmd(struct qla_tgt_sess *sess)
+{
+	struct se_session *se_sess = (struct se_session *)sess->se_sess;
+	int tag;
+	struct qla_tgt_cmd *cmd = NULL;
+
+	tag = percpu_ida_alloc(&se_sess->sess_tag_pool, TASK_RUNNING);
+	if (tag < 0)
+		return NULL;
+
+	cmd = &((struct qla_tgt_cmd *)se_sess->sess_cmd_map)[tag];
+	if (cmd) {
+		memset(cmd, 0, sizeof(struct qla_tgt_cmd));
+		cmd->se_cmd.map_tag = tag;
+	}
+	return cmd;
 }
 
 static void tcm_qla2xxx_close_session(struct se_session *se_sess)
@@ -1623,6 +1657,8 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
 	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
+	.release_cmd		= tcm_qla2xxx_rel_cmd,
+	.alloc_cmd		= tcm_qla2xxx_alloc_cmd,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
-- 
1.8.3.1

