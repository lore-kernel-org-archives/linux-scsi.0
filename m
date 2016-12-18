From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 4/9] qla2xxx: Cleanup for sess_kref handling
Date: Sun, 18 Dec 2016 01:02:44 -0800
Message-ID: <1482051769-22941-5-git-send-email-himanshu.madhani@cavium.com>
References: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1482051769-22941-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Remove se_session internal knowledge. tcm_qla2xxx
driver is the only one that have this knowledge.

Also check if sess is not NULL before getting kref.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++++------
 drivers/scsi/qla2xxx/qla_target.h  |  3 ++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 16 +++++++++++++---
 3 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 8ef8219..8640561 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -924,7 +924,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 				}
 			}
 
-			kref_get(&sess->sess_kref);
+			ha->tgt.tgt_ops->get_sess(sess);
+
 			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
 						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
 
@@ -999,7 +1000,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 		 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
 		 * access across ->tgt.sess_lock reaquire.
 		 */
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	return sess;
@@ -1043,7 +1044,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return;
 	} else {
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 
 		if (sess->deleted) {
 			qlt_undelete_sess(sess);
@@ -3978,7 +3979,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	/*
 	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
 	 */
-	kref_get(&sess->sess_kref);
+	ha->tgt.tgt_ops->get_sess(sess);
 
 	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
@@ -5814,7 +5815,7 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 			goto out_term2;
 		}
 
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -5878,7 +5879,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 			goto out_term;
 		}
 
-		kref_get(&sess->sess_kref);
+		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
 	iocb = a;
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index fbc11f3..027bed3 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -733,6 +733,7 @@ struct qla_tgt_func_tmpl {
 	int (*check_initiator_node_acl)(struct scsi_qla_host *, unsigned char *,
 					struct qla_tgt_sess *);
 	void (*update_sess)(struct qla_tgt_sess *, port_id_t, uint16_t, bool);
+	void (*get_sess)(struct qla_tgt_sess *);
 	struct qla_tgt_sess *(*find_sess_by_loop_id)(struct scsi_qla_host *,
 						const uint16_t);
 	struct qla_tgt_sess *(*find_sess_by_s_id)(struct scsi_qla_host *,
@@ -932,7 +933,7 @@ struct qla_tgt_sess {
 
 	int generation;
 
-	struct se_session *se_sess;
+	void *se_sess;
 	struct kref sess_kref;
 	struct scsi_qla_host *vha;
 	struct qla_tgt *tgt;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 9d1fc08..7026f3e 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -321,6 +321,14 @@ static int tcm_qla2xxx_check_stop_free(struct se_cmd *se_cmd)
 	return target_put_sess_cmd(se_cmd);
 }
 
+static void tcm_qla2xxx_get_sess(struct qla_tgt_sess *sess)
+{
+	if (!sess)
+		return;
+
+	kref_get(&sess->sess_kref);
+}
+
 /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release underlying
  * fabric descriptor @se_cmd command to release
  */
@@ -808,7 +816,8 @@ static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
  */
 static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 {
-	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
+	struct se_node_acl *se_nacl =
+	    ((struct se_session *)sess->se_sess)->se_node_acl;
 	struct se_portal_group *se_tpg = se_nacl->se_tpg;
 	struct se_wwn *se_wwn = se_tpg->se_tpg_wwn;
 	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
@@ -1574,12 +1583,12 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	struct qla_hw_data *ha = tgt->ha;
 	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	struct tcm_qla2xxx_lport *lport = vha->vha_tgt.target_lport_ptr;
-	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
+	struct se_node_acl *se_nacl =
+	    ((struct se_session *)sess->se_sess)->se_node_acl;
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 			struct tcm_qla2xxx_nacl, se_node_acl);
 	u32 key;
 
-
 	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
 		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
 		    sess, sess->port_name,
@@ -1652,6 +1661,7 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	.free_mcmd		= tcm_qla2xxx_free_mcmd,
 	.free_session		= tcm_qla2xxx_free_session,
 	.update_sess		= tcm_qla2xxx_update_sess,
+	.get_sess		= tcm_qla2xxx_get_sess,
 	.check_initiator_node_acl = tcm_qla2xxx_check_initiator_node_acl,
 	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
-- 
1.8.3.1
