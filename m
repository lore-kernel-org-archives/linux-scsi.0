From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/3] tcm_qla2xxx: Add hook so qla_target code can shutdown sessions
Date: Thu,  3 May 2012 12:42:59 -0700
Message-ID: <1336074180-20577-3-git-send-email-roland@kernel.org>
References: <1336074180-20577-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336074180-20577-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

When qla_tgt_del_sess_work_fn() does a ->put_sess, that may drop the
last reference to a session and free it.  We need to make sure the
session release function waits for all pending commands, or else we may
hit use-after-free if those commands complete after the session is gone.

This won't happen unless we do target_splice_sess_cmd_list() via
tcm_qla2xxx_shutdown_session().  So add a hook in qla_tgt_func_tmpl
to let qla_target call ->shutdown_sess before ->put_sess.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |    1 +
 drivers/scsi/qla2xxx/qla_target.h  |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    6 ++++++
 3 files changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 4d51136..6542da4 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -691,6 +691,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
 				    "Timeout: sess %p about to be deleted\n",
 				    sess);
+				ha->tgt.tgt_ops->shutdown_sess(sess);
 				ha->tgt.tgt_ops->put_sess(sess);
 			}
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index a8f3c5c..bacc4e6 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -647,6 +647,7 @@ struct qla_tgt_func_tmpl {
 						const uint8_t *);
 	void (*clear_nacl_from_fcport_map)(struct qla_tgt_sess *);
 	void (*put_sess)(struct qla_tgt_sess *);
+	void (*shutdown_sess)(struct qla_tgt_sess *);
 };
 
 int qla2x00_wait_for_hba_online(struct scsi_qla_host *);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7c3cbc1..0570a8c 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -843,6 +843,11 @@ void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 	target_put_session(sess->se_sess);
 }
 
+void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
+{
+	tcm_qla2xxx_shutdown_session(sess->se_sess);
+}
+
 static struct se_node_acl *tcm_qla2xxx_make_nodeacl(
 	struct se_portal_group *se_tpg,
 	struct config_group *group,
@@ -1526,6 +1531,7 @@ static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
 	.clear_nacl_from_fcport_map = tcm_qla2xxx_clear_nacl_from_fcport_map,
 	.put_sess		= tcm_qla2xxx_put_sess,
+	.shutdown_sess		= tcm_qla2xxx_shutdown_sess,
 };
 
 static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
-- 
1.7.9.5
