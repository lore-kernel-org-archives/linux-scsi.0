From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 03/11] qla2xxx: delay plogi/prli ack until existing sessions are deleted
Date: Thu, 25 Jun 2015 12:33:43 -0400
Message-ID: <1435250031-20525-4-git-send-email-himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:5873 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752627AbbFYRSK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 13:18:10 -0400
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

- keep qla_tgt_sess object on the session list until it's freed

- modify use of sess->deleted flag to differentiate delayed
  session deletion that can be cancelled from irreversible one:
  QLA_SESS_DELETION_PENDING vs QLA_SESS_DELETION_IN_PROGRESS

- during IN_PROGRESS deletion all newly arrived commands and TMRs will
  be rejected, existing commands and TMRs will be terminated when
  given by the core to the fabric or simply dropped if session logout
  has already happened (logout terminates all existing exchanges)

- new PLOGI will initiate deletion of the following sessions
  (unless deletion is already IN_PROGRESS):
  - with the same port_name (with logout)
  - different port_name, different loop_id but the same port_id
    (with logout)
  - different port_name, different port_id, but the same loop_id
    (without logout)

- additionally each new PLOGI will store imm notify iocb in the
  same port_name session being deleted. When deletion process
  completes this iocb will be acked. Only the most recent PLOGI
  iocb is stored. The older ones will be terminated when replaced.

- new PRLI will initiate deletion of the following sessions
  (unless deletion is already IN_PROGRESS):
  - different port_name, different port_id, but the same loop_id
   (without logout)

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Acked-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c     |    6 +-
 drivers/scsi/qla2xxx/qla_def.h     |    2 +
 drivers/scsi/qla2xxx/qla_init.c    |    7 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |    3 +
 drivers/scsi/qla2xxx/qla_target.c  |  438 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_target.h  |   43 ++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    4 +
 7 files changed, 481 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index e63aa07..05793b7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -67,10 +67,10 @@
  * |                              |                    | 0xd031-0xd0ff	|
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
- * | Target Mode		  |	  0xe079       |		|
- * | Target Mode Management	  |	  0xf083       | 0xf002		|
+ * | Target Mode		  |	  0xe080       |		|
+ * | Target Mode Management	  |	  0xf091       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
- * | Target Mode Task Management  |	  0x1000b      |		|
+ * | Target Mode Task Management  |	  0x1000d      |		|
  * ----------------------------------------------------------------------
  */
 
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 2c10f1f..b036f1a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -274,6 +274,7 @@
 #define RESPONSE_ENTRY_CNT_FX00		256     /* Number of response entries.*/
 
 struct req_que;
+struct qla_tgt_sess;
 
 /*
  * (sd.h is not exported, hence local inclusion)
@@ -2026,6 +2027,7 @@ typedef struct fc_port {
 	uint16_t port_id;
 
 	unsigned long retry_delay_timestamp;
+	struct qla_tgt_sess *tgt_session;
 } fc_port_t;
 
 #include "qla_mr.h"
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4895a4a..14456b1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -115,6 +115,8 @@ qla2x00_async_iocb_timeout(void *data)
 			QLA_LOGIO_LOGIN_RETRIED : 0;
 		qla2x00_post_async_login_done_work(fcport->vha, fcport,
 			lio->u.logio.data);
+	} else if (sp->type == SRB_LOGOUT_CMD) {
+		qlt_logo_completion_handler(fcport, QLA_FUNCTION_TIMEOUT);
 	}
 }
 
@@ -497,7 +499,10 @@ void
 qla2x00_async_logout_done(struct scsi_qla_host *vha, fc_port_t *fcport,
     uint16_t *data)
 {
-	qla2x00_mark_device_lost(vha, fcport, 1, 0);
+	/* Don't re-login in target mode */
+	if (!fcport->tgt_session)
+		qla2x00_mark_device_lost(vha, fcport, 1, 0);
+	qlt_logo_completion_handler(fcport, data[0]);
 	return;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42d0e44..6b23970 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1944,6 +1944,9 @@ qla24xx_logout_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->entry_type = LOGINOUT_PORT_IOCB_TYPE;
 	logio->control_flags =
 	    cpu_to_le16(LCF_COMMAND_LOGO|LCF_IMPL_LOGO);
+	if (!sp->fcport->tgt_session ||
+	    !sp->fcport->tgt_session->keep_nport_handle)
+		logio->control_flags |= cpu_to_le16(LCF_FREE_NPORT);
 	logio->nport_handle = cpu_to_le16(sp->fcport->loop_id);
 	logio->port_id[0] = sp->fcport->d_id.b.al_pa;
 	logio->port_id[1] = sp->fcport->d_id.b.area;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 95066ac..34f7f4d 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -114,6 +114,10 @@ static void qlt_alloc_qfull_cmd(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint16_t status, int qfull);
 static void qlt_disable_vha(struct scsi_qla_host *vha);
 static void qlt_clear_tgt_db(struct qla_tgt *tgt);
+static void qlt_send_notify_ack(struct scsi_qla_host *vha,
+	struct imm_ntfy_from_isp *ntfy,
+	uint32_t add_flags, uint16_t resp_code, int resp_code_valid,
+	uint16_t srr_flags, uint16_t srr_reject_code, uint8_t srr_explan);
 /*
  * Global Variables
  */
@@ -382,14 +386,73 @@ static void qlt_free_session_done(struct work_struct *work)
 	struct qla_tgt *tgt = sess->tgt;
 	struct scsi_qla_host *vha = sess->vha;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	bool logout_started = false;
+	fc_port_t fcport;
+
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
+		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
+		" s_id %02x:%02x:%02x logout %d keep %d plogi %d\n",
+		__func__, sess->se_sess, sess, sess->port_name, sess->loop_id,
+		sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+		sess->logout_on_delete, sess->keep_nport_handle,
+		sess->plogi_ack_needed);
 
 	BUG_ON(!tgt);
+
+	if (sess->logout_on_delete) {
+		int rc;
+
+		memset(&fcport, 0, sizeof(fcport));
+		fcport.loop_id = sess->loop_id;
+		fcport.d_id = sess->s_id;
+		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
+		fcport.vha = vha;
+		fcport.tgt_session = sess;
+
+		rc = qla2x00_post_async_logout_work(vha, &fcport, NULL);
+		if (rc != QLA_SUCCESS)
+			ql_log(ql_log_warn, vha, 0xf085,
+			       "Schedule logo failed sess %p rc %d\n",
+			       sess, rc);
+		else
+			logout_started = true;
+	}
+
 	/*
 	 * Release the target session for FC Nexus from fabric module code.
 	 */
 	if (sess->se_sess != NULL)
 		ha->tgt.tgt_ops->free_session(sess);
 
+	if (logout_started) {
+		bool traced = false;
+
+		while (!ACCESS_ONCE(sess->logout_completed)) {
+			if (!traced) {
+				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf086,
+					"%s: waiting for sess %p logout\n",
+					__func__, sess);
+				traced = true;
+			}
+			msleep(100);
+		}
+
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf087,
+			"%s: sess %p logout completed\n",
+			__func__, sess);
+	}
+
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
+	if (sess->plogi_ack_needed)
+		qlt_send_notify_ack(vha, &sess->tm_iocb,
+				    0, 0, 0, 0, 0, 0);
+
+	list_del(&sess->sess_list_entry);
+
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
 	    "Unregistration of sess %p finished\n", sess);
 
@@ -410,9 +473,9 @@ void qlt_unreg_sess(struct qla_tgt_sess *sess)
 
 	vha->hw->tgt.tgt_ops->clear_nacl_from_fcport_map(sess);
 
-	list_del(&sess->sess_list_entry);
-	if (sess->deleted)
-		list_del(&sess->del_list_entry);
+	if (!list_empty(&sess->del_list_entry))
+		list_del_init(&sess->del_list_entry);
+	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 
 	INIT_WORK(&sess->free_work, qlt_free_session_done);
 	schedule_work(&sess->free_work);
@@ -490,27 +553,36 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	struct qla_tgt *tgt = sess->tgt;
 	uint32_t dev_loss_tmo = tgt->ha->port_down_retry_count + 5;
 
-	if (sess->deleted)
-		return;
+	if (sess->deleted) {
+		/* Upgrade to unconditional deletion in case it was temporary */
+		if (immediate && sess->deleted == QLA_SESS_DELETION_PENDING)
+			list_del(&sess->del_list_entry);
+		else
+			return;
+	}
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion\n", sess);
-	list_add_tail(&sess->del_list_entry, &tgt->del_sess_list);
-	sess->deleted = 1;
 
-	if (immediate)
+	if (immediate) {
 		dev_loss_tmo = 0;
+		sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
+		list_add(&sess->del_list_entry, &tgt->del_sess_list);
+	} else {
+		sess->deleted = QLA_SESS_DELETION_PENDING;
+		list_add_tail(&sess->del_list_entry, &tgt->del_sess_list);
+	}
 
 	sess->expires = jiffies + dev_loss_tmo * HZ;
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
 	    "qla_target(%d): session for port %8phC (loop ID %d) scheduled for "
-	    "deletion in %u secs (expires: %lu) immed: %d\n",
+	    "deletion in %u secs (expires: %lu) immed: %d, logout: %d\n",
 	    sess->vha->vp_idx, sess->port_name, sess->loop_id, dev_loss_tmo,
-	    sess->expires, immediate);
+	    sess->expires, immediate, sess->logout_on_delete);
 
 	if (immediate)
-		schedule_delayed_work(&tgt->sess_del_work, 0);
+		mod_delayed_work(system_wq, &tgt->sess_del_work, 0);
 	else
 		schedule_delayed_work(&tgt->sess_del_work,
 		    sess->expires - jiffies);
@@ -579,9 +651,9 @@ out_free_id_list:
 /* ha->hardware_lock supposed to be held on entry */
 static void qlt_undelete_sess(struct qla_tgt_sess *sess)
 {
-	BUG_ON(!sess->deleted);
+	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
 
-	list_del(&sess->del_list_entry);
+	list_del_init(&sess->del_list_entry);
 	sess->deleted = 0;
 }
 
@@ -600,7 +672,9 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 		    del_list_entry);
 		elapsed = jiffies;
 		if (time_after_eq(elapsed, sess->expires)) {
-			qlt_undelete_sess(sess);
+			/* No turning back */
+			list_del_init(&sess->del_list_entry);
+			sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
 			    "Timeout: sess %p about to be deleted\n",
@@ -644,6 +718,13 @@ static struct qla_tgt_sess *qlt_create_sess(
 			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
 			    fcport->loop_id);
 
+			/* Cannot undelete at this point */
+			if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+				spin_unlock_irqrestore(&ha->hardware_lock,
+				    flags);
+				return NULL;
+			}
+
 			if (sess->deleted)
 				qlt_undelete_sess(sess);
 
@@ -674,6 +755,14 @@ static struct qla_tgt_sess *qlt_create_sess(
 	sess->s_id = fcport->d_id;
 	sess->loop_id = fcport->loop_id;
 	sess->local = local;
+	INIT_LIST_HEAD(&sess->del_list_entry);
+
+	/* Under normal circumstances we want to logout from firmware when
+	 * session eventually ends and release corresponding nport handle.
+	 * In the exception cases (e.g. when new PLOGI is waiting) corresponding
+	 * code will adjust these flags as necessary. */
+	sess->logout_on_delete = 1;
+	sess->keep_nport_handle = 0;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
 	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
@@ -751,6 +840,10 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+	} else if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		/* Point of no return */
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return;
 	} else {
 		kref_get(&sess->se_sess->sess_kref);
 
@@ -2373,6 +2466,19 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	unsigned long flags = 0;
 	int res;
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+	if (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		cmd->state = QLA_TGT_STATE_PROCESSED;
+		if (cmd->sess->logout_completed)
+			/* no need to terminate. FW already freed exchange. */
+			qlt_abort_cmd_on_host_reset(cmd->vha, cmd);
+		else
+			qlt_send_term_exchange(vha, cmd, &cmd->atio, 1);
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		return 0;
+	}
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	memset(&prm, 0, sizeof(prm));
 	qlt_check_srr_debug(cmd, &xmit_type);
 
@@ -2539,7 +2645,8 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
-	if (qla2x00_reset_active(vha) || cmd->reset_count != ha->chip_reset) {
+	if (qla2x00_reset_active(vha) || (cmd->reset_count != ha->chip_reset) ||
+	    (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)) {
 		/*
 		 * Either a chip reset is active or this request was from
 		 * previous life, just abort the processing.
@@ -2732,6 +2839,89 @@ out:
 
 /* If hardware_lock held on entry, might drop it, then reaquire */
 /* This function sends the appropriate CTIO to ISP 2xxx or 24xx */
+static int __qlt_send_term_imm_notif(struct scsi_qla_host *vha,
+	struct imm_ntfy_from_isp *ntfy)
+{
+	struct nack_to_isp *nack;
+	struct qla_hw_data *ha = vha->hw;
+	request_t *pkt;
+	int ret = 0;
+
+	ql_dbg(ql_dbg_tgt_tmr, vha, 0xe01c,
+	    "Sending TERM ELS CTIO (ha=%p)\n", ha);
+
+	pkt = (request_t *)qla2x00_alloc_iocbs_ready(vha, NULL);
+	if (pkt == NULL) {
+		ql_dbg(ql_dbg_tgt, vha, 0xe080,
+		    "qla_target(%d): %s failed: unable to allocate "
+		    "request packet\n", vha->vp_idx, __func__);
+		return -ENOMEM;
+	}
+
+	pkt->entry_type = NOTIFY_ACK_TYPE;
+	pkt->entry_count = 1;
+	pkt->handle = QLA_TGT_SKIP_HANDLE | CTIO_COMPLETION_HANDLE_MARK;
+
+	nack = (struct nack_to_isp *)pkt;
+	nack->ox_id = ntfy->ox_id;
+
+	nack->u.isp24.nport_handle = ntfy->u.isp24.nport_handle;
+	if (le16_to_cpu(ntfy->u.isp24.status) == IMM_NTFY_ELS) {
+		nack->u.isp24.flags = ntfy->u.isp24.flags &
+			__constant_cpu_to_le32(NOTIFY24XX_FLAGS_PUREX_IOCB);
+	}
+
+	/* terminate */
+	nack->u.isp24.flags |=
+		__constant_cpu_to_le16(NOTIFY_ACK_FLAGS_TERMINATE);
+
+	nack->u.isp24.srr_rx_id = ntfy->u.isp24.srr_rx_id;
+	nack->u.isp24.status = ntfy->u.isp24.status;
+	nack->u.isp24.status_subcode = ntfy->u.isp24.status_subcode;
+	nack->u.isp24.fw_handle = ntfy->u.isp24.fw_handle;
+	nack->u.isp24.exchange_address = ntfy->u.isp24.exchange_address;
+	nack->u.isp24.srr_rel_offs = ntfy->u.isp24.srr_rel_offs;
+	nack->u.isp24.srr_ui = ntfy->u.isp24.srr_ui;
+	nack->u.isp24.vp_index = ntfy->u.isp24.vp_index;
+
+	qla2x00_start_iocbs(vha, vha->req);
+	return ret;
+}
+
+static void qlt_send_term_imm_notif(struct scsi_qla_host *vha,
+	struct imm_ntfy_from_isp *imm, int ha_locked)
+{
+	unsigned long flags = 0;
+	int rc;
+
+	if (qlt_issue_marker(vha, ha_locked) < 0)
+		return;
+
+	if (ha_locked) {
+		rc = __qlt_send_term_imm_notif(vha, imm);
+
+#if 0	/* Todo  */
+		if (rc == -ENOMEM)
+			qlt_alloc_qfull_cmd(vha, imm, 0, 0);
+#endif
+		goto done;
+	}
+
+	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	rc = __qlt_send_term_imm_notif(vha, imm);
+
+#if 0	/* Todo */
+	if (rc == -ENOMEM)
+		qlt_alloc_qfull_cmd(vha, imm, 0, 0);
+#endif
+
+done:
+	if (!ha_locked)
+		spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+}
+
+/* If hardware_lock held on entry, might drop it, then reaquire */
+/* This function sends the appropriate CTIO to ISP 2xxx or 24xx */
 static int __qlt_send_term_exchange(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd,
 	struct atio_from_isp *atio)
@@ -3784,22 +3974,237 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 	return __qlt_abort_task(vha, iocb, sess);
 }
 
+void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
+{
+	if (fcport->tgt_session) {
+		if (rc != MBS_COMMAND_COMPLETE) {
+			ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf088,
+				"%s: se_sess %p / sess %p from"
+				" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
+				" LOGO failed: %#x\n",
+				__func__,
+				fcport->tgt_session->se_sess,
+				fcport->tgt_session,
+				fcport->port_name, fcport->loop_id,
+				fcport->d_id.b.domain, fcport->d_id.b.area,
+				fcport->d_id.b.al_pa, rc);
+		}
+
+		fcport->tgt_session->logout_completed = 1;
+	}
+}
+
+static void qlt_swap_imm_ntfy_iocb(struct imm_ntfy_from_isp *a,
+    struct imm_ntfy_from_isp *b)
+{
+	struct imm_ntfy_from_isp tmp;
+	memcpy(&tmp, a, sizeof(struct imm_ntfy_from_isp));
+	memcpy(a, b, sizeof(struct imm_ntfy_from_isp));
+	memcpy(b, &tmp, sizeof(struct imm_ntfy_from_isp));
+}
+
+/*
+* ha->hardware_lock supposed to be held on entry (to protect tgt->sess_list)
+*
+* Schedules sessions with matching port_id/loop_id but different wwn for
+* deletion. Returns existing session with matching wwn if present.
+* Null otherwise.
+*/
+static struct qla_tgt_sess *
+qlt_find_sess_invalidate_other(struct qla_tgt *tgt, uint64_t wwn,
+    port_id_t port_id, uint16_t loop_id)
+{
+	struct qla_tgt_sess *sess = NULL, *other_sess;
+	uint64_t other_wwn;
+
+	list_for_each_entry(other_sess, &tgt->sess_list, sess_list_entry) {
+
+		other_wwn = wwn_to_u64(other_sess->port_name);
+
+		if (wwn == other_wwn) {
+			WARN_ON(sess);
+			sess = other_sess;
+			continue;
+		}
+
+		/* find other sess with nport_id collision */
+		if (port_id.b24 == other_sess->s_id.b24) {
+			if (loop_id != other_sess->loop_id) {
+				ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000c,
+				    "Invalidating sess %p loop_id %d wwn %llx.\n",
+				    other_sess, other_sess->loop_id, other_wwn);
+
+				/*
+				 * logout_on_delete is set by default, but another
+				 * session that has the same s_id/loop_id combo
+				 * might have cleared it when requested this session
+				 * deletion, so don't touch it
+				 */
+				qlt_schedule_sess_for_deletion(other_sess, true);
+			} else {
+				/*
+				 * Another wwn used to have our s_id/loop_id
+				 * combo - kill the session, but don't log out
+				 */
+				sess->logout_on_delete = 0;
+				qlt_schedule_sess_for_deletion(other_sess,
+				    true);
+			}
+			continue;
+		}
+
+		/* find other sess with nport handle collision */
+		if (loop_id == other_sess->loop_id) {
+			ql_dbg(ql_dbg_tgt_tmr, tgt->vha, 0x1000d,
+			       "Invalidating sess %p loop_id %d wwn %llx.\n",
+			       other_sess, other_sess->loop_id, other_wwn);
+
+			/* Same loop_id but different s_id
+			 * Ok to kill and logout */
+			qlt_schedule_sess_for_deletion(other_sess, true);
+		}
+	}
+
+	return sess;
+}
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
 static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	struct qla_tgt_sess *sess = NULL;
+	uint64_t wwn;
+	port_id_t port_id;
+	uint16_t loop_id;
+	uint16_t wd3_lo;
 	int res = 0;
 
+	wwn = wwn_to_u64(iocb->u.isp24.port_name);
+
+	port_id.b.domain = iocb->u.isp24.port_id[2];
+	port_id.b.area   = iocb->u.isp24.port_id[1];
+	port_id.b.al_pa  = iocb->u.isp24.port_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf026,
 	    "qla_target(%d): Port ID: 0x%3phC ELS opcode: 0x%02x\n",
 	    vha->vp_idx, iocb->u.isp24.port_id, iocb->u.isp24.status_subcode);
 
+	/* res = 1 means ack at the end of thread
+	 * res = 0 means ack async/later.
+	 */
 	switch (iocb->u.isp24.status_subcode) {
 	case ELS_PLOGI:
-	case ELS_FLOGI:
+
+		if (wwn)
+			sess = qlt_find_sess_invalidate_other(tgt, wwn,
+			    port_id, loop_id);
+
+		if (!sess || IS_SW_RESV_ADDR(sess->s_id)) {
+			res = 1;
+			break;
+		}
+
+		if (sess->plogi_ack_needed) {
+			/*
+			 * Initiator sent another PLOGI before last PLOGI could
+			 * finish. Swap plogi iocbs and terminate old one
+			 * without acking, new one will get acked when session
+			 * deletion completes.
+			 */
+			ql_log(ql_log_warn, sess->vha, 0xf089,
+			    "sess %p received double plogi.\n", sess);
+
+			qlt_swap_imm_ntfy_iocb(iocb, &sess->tm_iocb);
+
+			qlt_send_term_imm_notif(vha, iocb, 1);
+
+			res = 0;
+			break;
+		}
+
+		res = 0;
+
+		/*
+		 * Save immediate Notif IOCB for Ack when sess is done
+		 * and being deleted.
+		 */
+		memcpy(&sess->tm_iocb, iocb, sizeof(sess->tm_iocb));
+		sess->plogi_ack_needed  = 1;
+
+		 /*
+		  * Under normal circumstances we want to release nport handle
+		  * during LOGO process to avoid nport handle leaks inside FW.
+		  * The exception is when LOGO is done while another PLOGI with
+		  * the same nport handle is waiting as might be the case here.
+		  * Note: there is always a possibily of a race where session
+		  * deletion has already started for other reasons (e.g. ACL
+		  * removal) and now PLOGI arrives:
+		  * 1. if PLOGI arrived in FW after nport handle has been freed,
+		  *    FW must have assigned this PLOGI a new/same handle and we
+		  *    can proceed ACK'ing it as usual when session deletion
+		  *    completes.
+		  * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
+		  *    bit reached it, the handle has now been released. We'll
+		  *    get an error when we ACK this PLOGI. Nothing will be sent
+		  *    back to initiator. Initiator should eventually retry
+		  *    PLOGI and situation will correct itself.
+		  */
+		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
+					   (sess->s_id.b24 == port_id.b24));
+		qlt_schedule_sess_for_deletion(sess, true);
+		break;
+
 	case ELS_PRLI:
+		wd3_lo = le16_to_cpu(iocb->u.isp24.u.prli.wd3_lo);
+
+		if (wwn)
+			sess = qlt_find_sess_invalidate_other(tgt, wwn, port_id,
+			    loop_id);
+
+		if (sess != NULL) {
+			if (sess->deleted) {
+				/*
+				 * Impatient initiator sent PRLI before last
+				 * PLOGI could finish. Will force him to re-try,
+				 * while last one finishes.
+				 */
+				ql_log(ql_log_warn, sess->vha, 0xf090,
+				    "sess %p PRLI received, before plogi ack.\n",
+				    sess);
+				qlt_send_term_imm_notif(vha, iocb, 1);
+				res = 0;
+				break;
+			}
+
+			/*
+			 * This shouldn't happen under normal circumstances,
+			 * since we have deleted the old session during PLOGI
+			 */
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf091,
+			    "PRLI (loop_id %#04x) for existing sess %p (loop_id %#04x)\n",
+			    sess->loop_id, sess, iocb->u.isp24.nport_handle);
+
+			sess->local = 0;
+			sess->loop_id = loop_id;
+			sess->s_id = port_id;
+
+			if (wd3_lo & BIT_7)
+				sess->conf_compl_supported = 1;
+
+			res = 1;
+		} else {
+			/* todo: else - create sess here. */
+			res = 1; /* send notify ack */
+		}
+
+		break;
+
 	case ELS_LOGO:
 	case ELS_PRLO:
 		res = qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS);
@@ -3817,6 +4222,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		break;
 	}
 
+	case ELS_FLOGI:	/* should never happen */
 	default:
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf061,
 		    "qla_target(%d): Unsupported ELS command %x "
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 7d90f27..37c0260 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -167,7 +167,24 @@ struct imm_ntfy_from_isp {
 			uint32_t srr_rel_offs;
 			uint16_t srr_ui;
 			uint16_t srr_ox_id;
-			uint8_t  reserved_4[19];
+			union {
+				struct {
+					uint8_t node_name[8];
+				} plogi; /* PLOGI/ADISC/PDISC */
+				struct {
+					/* PRLI word 3 bit 0-15 */
+					uint16_t wd3_lo;
+					uint8_t resv0[6];
+				} prli;
+				struct {
+					uint8_t port_id[3];
+					uint8_t resv1;
+					uint16_t nport_handle;
+					uint16_t resv2;
+				} req_els;
+			} u;
+			uint8_t port_name[8];
+			uint8_t resv3[3];
 			uint8_t  vp_index;
 			uint32_t reserved_5;
 			uint8_t  port_id[3];
@@ -234,6 +251,7 @@ struct nack_to_isp {
 	uint8_t  reserved[2];
 	uint16_t ox_id;
 } __packed;
+#define NOTIFY_ACK_FLAGS_TERMINATE	BIT_3
 #define NOTIFY_ACK_SRR_FLAGS_ACCEPT	0
 #define NOTIFY_ACK_SRR_FLAGS_REJECT	1
 
@@ -878,6 +896,13 @@ struct qla_tgt_sess_op {
 	bool aborted;
 };
 
+enum qla_sess_deletion {
+	QLA_SESS_DELETION_NONE		= 0,
+	QLA_SESS_DELETION_PENDING	= 1, /* hopefully we can get rid of
+					      * this one */
+	QLA_SESS_DELETION_IN_PROGRESS	= 2,
+};
+
 /*
  * Equivilant to IT Nexus (Initiator-Target)
  */
@@ -886,8 +911,13 @@ struct qla_tgt_sess {
 	port_id_t s_id;
 
 	unsigned int conf_compl_supported:1;
-	unsigned int deleted:1;
+	unsigned int deleted:2;
 	unsigned int local:1;
+	unsigned int logout_on_delete:1;
+	unsigned int plogi_ack_needed:1;
+	unsigned int keep_nport_handle:1;
+
+	unsigned char logout_completed;
 
 	struct se_session *se_sess;
 	struct scsi_qla_host *vha;
@@ -899,6 +929,10 @@ struct qla_tgt_sess {
 
 	uint8_t port_name[WWN_SIZE];
 	struct work_struct free_work;
+
+	union {
+		struct imm_ntfy_from_isp tm_iocb;
+	};
 };
 
 struct qla_tgt_cmd {
@@ -1032,6 +1066,10 @@ struct qla_tgt_srr_ctio {
 	struct qla_tgt_cmd *cmd;
 };
 
+/* Check for Switch reserved address */
+#define IS_SW_RESV_ADDR(_s_id) \
+	((_s_id.b.domain == 0xff) && (_s_id.b.area == 0xfc))
+
 #define QLA_TGT_XMIT_DATA		1
 #define QLA_TGT_XMIT_STATUS		2
 #define QLA_TGT_XMIT_ALL		(QLA_TGT_XMIT_STATUS|QLA_TGT_XMIT_DATA)
@@ -1125,5 +1163,6 @@ extern void qlt_stop_phase2(struct qla_tgt *);
 extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_83xx_iospace_config(struct qla_hw_data *);
 extern int qlt_free_qfull_cmds(struct scsi_qla_host *);
+extern void qlt_logo_completion_handler(fc_port_t *, int);
 
 #endif /* __QLA_TARGET_H */
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index ff994ec..7bf3043 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1717,6 +1717,10 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 	}
 
 	sess->conf_compl_supported = conf_compl_supported;
+
+	/* Reset logout parameters to default */
+	sess->logout_on_delete = 1;
+	sess->keep_nport_handle = 0;
 }
 
 /*
-- 
1.7.7

