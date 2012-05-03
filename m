From: Roland Dreier <roland@kernel.org>
Subject: [PATCH 3/3] qla2xxx: Don't create duplicate target sessions
Date: Thu,  3 May 2012 12:43:00 -0700
Message-ID: <1336074180-20577-4-git-send-email-roland@kernel.org>
References: <1336074180-20577-1-git-send-email-roland@kernel.org>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1336074180-20577-1-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Arun Easi <arun.easi@qlogic.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Steve Hodgson <steve@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

We run into problems when tearing down ACLs with IO in flight from the
initiator with current code.  What happens is that when removing an ACL,
we tear down the associated session; then when more commands come in, we
queue them up and create a new session in qla_tgt_do_work() for each
command.  If multiple commands get queued up, we create multiple
sessions, each with its own associated dynamic ACL.

Then when we reestablish the ACL, we find the wrong dynamic ACL and
convert it back to a normal ACL -- unfortunately the session in the
session table that points to the normal ACL has already been overwritten
and so all future commands find a session that still points to a dynamic
ACL (which rejects all commands except INQUIRY / REPORT LUNS).

Fix this by just always looking up the session in qla_tgt_do_work() and
avoiding creating duplicate sessions.  This also simplifies the code
(since we don't have two places to look up sessions) and moves more
work out of the interrupt handler and into the work queue.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/scsi/qla2xxx/qla_target.c |   95 ++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 55 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6542da4..58dfbd8 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -720,9 +720,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 	unsigned char be_sid[3];
 
 	/* Check to avoid double sessions */
-#if 0
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
+	list_for_each_entry(sess, &ha->tgt.qla_tgt->sess_list, sess_list_entry) {
 		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
 			    "Double sess %p found (s_id %x:%x:%x, "
@@ -731,12 +730,12 @@ static struct qla_tgt_sess *qlt_create_sess(
 			    sess->s_id.b.al_pa, sess->s_id.b.area,
 			    sess->loop_id, fcport->d_id.b.domain,
 			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
-			    fcport->loop_id)
+			    fcport->loop_id);
 
 			if (sess->deleted)
 				qlt_undelete_sess(sess);
 
-			qlt_sess_get(sess);
+			kref_get(&sess->se_sess->sess_kref);
 			sess->s_id = fcport->d_id;
 			sess->loop_id = fcport->loop_id;
 			sess->conf_compl_supported = !!(fcport->flags &
@@ -744,12 +743,11 @@ static struct qla_tgt_sess *qlt_create_sess(
 			if (sess->local && !local)
 				sess->local = 0;
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			goto out;
+
+			return sess;
 		}
 	}
-	spin_unlock_irq_restore(&ha->hardware_lock, flags);
-#endif
-	/* We are under tgt_mutex, so a new sess can't be added behind us */
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
@@ -2634,7 +2632,7 @@ static void qlt_do_work(struct work_struct *work)
 	scsi_qla_host_t *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = ha->tgt.qla_tgt;
-	struct qla_tgt_sess *sess = cmd->sess;
+	struct qla_tgt_sess *sess = NULL;
 	atio_from_isp_t *atio = &cmd->atio;
 	unsigned char *cdb;
 	unsigned long flags;
@@ -2642,25 +2640,49 @@ static void qlt_do_work(struct work_struct *work)
 	int ret, fcp_task_attr, data_dir, bidi = 0;;
 
 	if (tgt->tgt_stop)
-		goto out_term;	
+		goto out_term;
 
-	if (!sess) {
-		uint8_t *s_id = NULL;
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
+	    atio->u.isp24.fcp_hdr.s_id);
+	if (sess) {
+		if (unlikely(sess->tearing_down)) {
+			sess = NULL;
+			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			goto out_term;
+		} else {
+			/* Do the extra kref_get() before dropping qla_hw_data->hardware_lock. */
+			kref_get(&sess->se_sess->sess_kref);
+		}
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	if (unlikely(!sess)) {
+		uint8_t *s_id =	atio->u.isp24.fcp_hdr.s_id;
 
-		s_id = atio->u.isp24.fcp_hdr.s_id;
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xe125, "qla_target(%d):"
+		       " Unable to find wwn login (s_id %x:%x:%x),"
+		       " trying to create it manually\n", vha->vp_idx,
+		       s_id[0], s_id[1], s_id[2]);
+
+		if (atio->u.raw.entry_count > 1) {
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xe127, "Dropping multy entry"
+					" cmd %p\n", cmd);
+			goto out_term;
+		}
 
 		mutex_lock(&ha->tgt.tgt_mutex);
-		cmd->sess = sess = qlt_make_local_sess(vha, s_id);
-		/* sess has got an extra creation ref */
+		sess = qlt_make_local_sess(vha, s_id);
+		/* sess has an extra creation ref. */
 		mutex_unlock(&ha->tgt.tgt_mutex);
 
 		if (!sess)
 			goto out_term;
-		cmd->loop_id = sess->loop_id;
 	}
 
-	if (tgt->tgt_stop)
-		goto out_term;
+	cmd->sess = sess;
+	cmd->loop_id = sess->loop_id;
+	cmd->conf_compl_supported = sess->conf_compl_supported;
 
 	cdb = &atio->u.isp24.fcp_cmnd.cdb[0];
 	cmd->tag = atio->u.isp24.exchange_addr;
@@ -2716,9 +2738,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 {
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt *tgt = ha->tgt.qla_tgt;
-	struct qla_tgt_sess *sess;
 	struct qla_tgt_cmd *cmd;
-	int res = 0;
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf021,
@@ -2740,45 +2760,10 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	cmd->tgt = ha->tgt.qla_tgt;
 	cmd->vha = vha;
 
-	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
-	    atio->u.isp24.fcp_hdr.s_id);
-	if (unlikely(!sess)) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf022,
-		    "qla_target(%d): Unable to find wwn login (s_id %x:%x:%x),"
-		    " trying to create it manually\n", vha->vp_idx,
-		    atio->u.isp24.fcp_hdr.s_id[0],
-		    atio->u.isp24.fcp_hdr.s_id[1],
-		    atio->u.isp24.fcp_hdr.s_id[2]);
-
-		if (atio->u.raw.entry_count > 1) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf023,
-			    "Dropping multy entry cmd %p\n", cmd);
-			goto out_free_cmd;
-		}
-		goto out_sched;
-	}
-
-	if (sess->tearing_down || tgt->tgt_stop)
-		goto out_free_cmd;
-
-	cmd->sess = sess;
-	cmd->loop_id = sess->loop_id;
-	cmd->conf_compl_supported = sess->conf_compl_supported;
-	/*
-	 * Get the extra kref_get() before dropping qla_hw_data->hardware_lock,
-	 * and call kref_put() in qlt_do_work() process context to drop the
-	 * extra reference.
-	*/
-	kref_get(&sess->se_sess->sess_kref);
-
-out_sched:
 	INIT_WORK(&cmd->work, qlt_do_work);
 	queue_work(qla_tgt_wq, &cmd->work);
 	return 0;
 
-out_free_cmd:
-	qlt_free_cmd(cmd);
-	return res;
 }
 
 /* ha->hardware_lock supposed to be held on entry */
-- 
1.7.9.5
