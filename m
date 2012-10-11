From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 2/2] qla2xxx: Update target lookup session tables when a target session changes
Date: Thu, 11 Oct 2012 13:41:32 -0700
Message-ID: <1349988092-27640-3-git-send-email-roland@kernel.org>
References: <1349988092-27640-1-git-send-email-roland@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:44936 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759286Ab2JKUll (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2012 16:41:41 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so2131935pad.19
        for <linux-scsi@vger.kernel.org>; Thu, 11 Oct 2012 13:41:39 -0700 (PDT)
In-Reply-To: <1349988092-27640-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>

From: Roland Dreier <roland@purestorage.com>

It is possible for the target code to change the loop_id or s_id of a
target session in reaction to an FC fabric change.  However, the
session structures are stored in tables that are indexed by these two
keys, and if we just change the session structure but leave the
pointers to it in the old places in the table, havoc can ensue.  For
example, a new session might come along that should go in the old slot
in the table and overwrite the old session pointer.

To handle this, add a new tgt_ops->update_sess() method that also
updates the "by loop_id" and "by s_id" lookup tables when a session
changes, so that the keys where a session pointer is stored in these
tables always matches the keys in the session structure itself.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c  |   22 +++++------
 drivers/scsi/qla2xxx/qla_target.h  |    1 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   73 ++++++++++++++++++++++++++++++++++++
 3 files changed, 84 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 0e09d8f..556e941 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -557,6 +557,7 @@ static bool qlt_check_fcport_exist(struct scsi_qla_host *vha,
 	int pmap_len;
 	fc_port_t *fcport;
 	int global_resets;
+	unsigned long flags;
 
 retry:
 	global_resets = atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count);
@@ -625,10 +626,10 @@ retry:
 	    sess->s_id.b.area, sess->loop_id, fcport->d_id.b.domain,
 	    fcport->d_id.b.al_pa, fcport->d_id.b.area, fcport->loop_id);
 
-	sess->s_id = fcport->d_id;
-	sess->loop_id = fcport->loop_id;
-	sess->conf_compl_supported = !!(fcport->flags &
-	    FCF_CONF_COMP_SUPPORTED);
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
+				!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	res = true;
 
@@ -740,10 +741,9 @@ static struct qla_tgt_sess *qlt_create_sess(
 				qlt_undelete_sess(sess);
 
 			kref_get(&sess->se_sess->sess_kref);
-			sess->s_id = fcport->d_id;
-			sess->loop_id = fcport->loop_id;
-			sess->conf_compl_supported = !!(fcport->flags &
-			    FCF_CONF_COMP_SUPPORTED);
+			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
+						!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
+
 			if (sess->local && !local)
 				sess->local = 0;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -869,10 +869,8 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
 			    "Reappeared sess %p\n", sess);
 		}
-		sess->s_id = fcport->d_id;
-		sess->loop_id = fcport->loop_id;
-		sess->conf_compl_supported = !!(fcport->flags &
-		    FCF_CONF_COMP_SUPPORTED);
+		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
+					!!(fcport->flags & FCF_CONF_COMP_SUPPORTED));
 	}
 
 	if (sess && sess->local) {
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 170af15..bad7495 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -648,6 +648,7 @@ struct qla_tgt_func_tmpl {
 
 	int (*check_initiator_node_acl)(struct scsi_qla_host *, unsigned char *,
 					void *, uint8_t *, uint16_t);
+	void (*update_sess)(struct qla_tgt_sess *, port_id_t, uint16_t, bool);
 	struct qla_tgt_sess *(*find_sess_by_loop_id)(struct scsi_qla_host *,
 						const uint16_t);
 	struct qla_tgt_sess *(*find_sess_by_s_id)(struct scsi_qla_host *,
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index d8211cc..3d74f2f 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1457,6 +1457,78 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	return 0;
 }
 
+static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
+				    uint16_t loop_id, bool conf_compl_supported)
+{
+	struct qla_tgt *tgt = sess->tgt;
+	struct qla_hw_data *ha = tgt->ha;
+	struct tcm_qla2xxx_lport *lport = ha->tgt.target_lport_ptr;
+	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
+	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
+			struct tcm_qla2xxx_nacl, se_node_acl);
+	u32 key;
+
+
+	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
+		pr_info("Updating session %p from port %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
+			sess,
+			sess->port_name[0], sess->port_name[1],
+			sess->port_name[2], sess->port_name[3],
+			sess->port_name[4], sess->port_name[5],
+			sess->port_name[6], sess->port_name[7],
+			sess->loop_id, loop_id,
+			sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+			s_id.b.domain, s_id.b.area, s_id.b.al_pa);
+
+	if (sess->loop_id != loop_id) {
+		/*
+		 * Because we can shuffle loop IDs around and we
+		 * update different sessions non-atomically, we might
+		 * have overwritten this session's old loop ID
+		 * already, and we might end up overwriting some other
+		 * session that will be updated later.  So we have to
+		 * be extra careful and we can't warn about those things...
+		 */
+		if (lport->lport_loopid_map[sess->loop_id].se_nacl == se_nacl)
+			lport->lport_loopid_map[sess->loop_id].se_nacl = NULL;
+
+		lport->lport_loopid_map[loop_id].se_nacl = se_nacl;
+
+		sess->loop_id = loop_id;
+	}
+
+	if (sess->s_id.b24 != s_id.b24) {
+		key = (((u32) sess->s_id.b.domain << 16) |
+		       ((u32) sess->s_id.b.area   <<  8) |
+		       ((u32) sess->s_id.b.al_pa));
+
+		if (btree_lookup32(&lport->lport_fcport_map, key))
+			WARN(btree_remove32(&lport->lport_fcport_map, key) != se_nacl,
+			     "Found wrong se_nacl when updating s_id %x:%x:%x\n",
+			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+		else
+			WARN(1, "No lport_fcport_map entry for s_id %x:%x:%x\n",
+			     sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa);
+
+		key = (((u32) s_id.b.domain << 16) |
+		       ((u32) s_id.b.area   <<  8) |
+		       ((u32) s_id.b.al_pa));
+
+		if (btree_lookup32(&lport->lport_fcport_map, key)) {
+			WARN(1, "Already have lport_fcport_map entry for s_id %x:%x:%x\n",
+			     s_id.b.domain, s_id.b.area, s_id.b.al_pa);
+			btree_update32(&lport->lport_fcport_map, key, se_nacl);
+		} else {
+			btree_insert32(&lport->lport_fcport_map, key, se_nacl, GFP_ATOMIC);
+		}
+
+		sess->s_id = s_id;
+		nacl->nport_id = key;
+	}
+
+	sess->conf_compl_supported = conf_compl_supported;
+}
+
 /*
  * Calls into tcm_qla2xxx used by qla2xxx LLD I/O path.
  */
@@ -1467,6 +1539,7 @@ static struct qla_tgt_func_tmpl tcm_qla2xxx_template = {
 	.free_cmd		= tcm_qla2xxx_free_cmd,
 	.free_mcmd		= tcm_qla2xxx_free_mcmd,
 	.free_session		= tcm_qla2xxx_free_session,
+	.update_sess		= tcm_qla2xxx_update_sess,
 	.check_initiator_node_acl = tcm_qla2xxx_check_initiator_node_acl,
 	.find_sess_by_s_id	= tcm_qla2xxx_find_sess_by_s_id,
 	.find_sess_by_loop_id	= tcm_qla2xxx_find_sess_by_loop_id,
-- 
1.7.10.4

