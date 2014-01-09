From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH] qla2xxx: Enhancements to enable NPIV support for QLOGIC ISPs with TCM/LIO.
Date: Thu, 9 Jan 2014 15:13:44 -0500
Message-ID: <1389298424-10371-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_attr.c    |    2 +
 drivers/scsi/qla2xxx/qla_def.h     |   12 ++-
 drivers/scsi/qla2xxx/qla_target.c  |  150 +++++++++++++++++++-----------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  110 +++++++++++++++-----------
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |    4 -
 5 files changed, 153 insertions(+), 125 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index ba94874..b0a0ed7 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -2117,6 +2117,8 @@ qla24xx_vport_delete(struct fc_vport *fc_vport)
 
 	vha->flags.delete_progress = 1;
 
+	qlt_remove_target(ha, vha);
+
 	fc_remove_host(vha->host);
 
 	scsi_remove_host(vha->host);
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index d514f1e..52a806e 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2728,6 +2728,13 @@ struct qlfc_fw {
 	uint32_t len;
 };
 
+struct scsi_qlt_host {
+	void *target_lport_ptr;
+	struct mutex tgt_mutex;
+	struct mutex tgt_host_action_mutex;
+	struct qla_tgt *qla_tgt;
+};
+
 struct qlt_hw_data {
 	/* Protected by hw lock */
 	uint32_t enable_class_2:1;
@@ -2743,15 +2750,11 @@ struct qlt_hw_data {
 	uint32_t __iomem *atio_q_in;
 	uint32_t __iomem *atio_q_out;
 
-	void *target_lport_ptr;
 	struct qla_tgt_func_tmpl *tgt_ops;
-	struct qla_tgt *qla_tgt;
 	struct qla_tgt_cmd *cmds[DEFAULT_OUTSTANDING_COMMANDS];
 	uint16_t current_handle;
 
 	struct qla_tgt_vp_map *tgt_vp_map;
-	struct mutex tgt_mutex;
-	struct mutex tgt_host_action_mutex;
 
 	int saved_set;
 	uint16_t saved_exchange_count;
@@ -3427,6 +3430,7 @@ typedef struct scsi_qla_host {
 #define VP_ERR_FAB_LOGOUT	4
 #define VP_ERR_ADAP_NORESOURCES	5
 	struct qla_hw_data *hw;
+	struct scsi_qlt_host vha_tgt;
 	struct req_que *req;
 	int		fw_heartbeat_counter;
 	int		seconds_since_last_heartbeat;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 38a1257..45b5d45 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -590,7 +590,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 	/* Check to avoid double sessions */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	list_for_each_entry(sess, &ha->tgt.qla_tgt->sess_list,
+	list_for_each_entry(sess, &vha->vha_tgt.qla_tgt->sess_list,
 				sess_list_entry) {
 		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
@@ -627,7 +627,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 		return NULL;
 	}
-	sess->tgt = ha->tgt.qla_tgt;
+	sess->tgt = vha->vha_tgt.qla_tgt;
 	sess->vha = vha;
 	sess->s_id = fcport->d_id;
 	sess->loop_id = fcport->loop_id;
@@ -635,7 +635,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
 	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
-	    sess, ha->tgt.qla_tgt);
+	    sess, vha->vha_tgt.qla_tgt);
 
 	be_sid[0] = sess->s_id.b.domain;
 	be_sid[1] = sess->s_id.b.area;
@@ -662,8 +662,8 @@ static struct qla_tgt_sess *qlt_create_sess(
 	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	list_add_tail(&sess->sess_list_entry, &ha->tgt.qla_tgt->sess_list);
-	ha->tgt.qla_tgt->sess_count++;
+	list_add_tail(&sess->sess_list_entry, &vha->vha_tgt.qla_tgt->sess_list);
+	vha->vha_tgt.qla_tgt->sess_count++;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
@@ -682,7 +682,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess;
 	unsigned long flags;
 
@@ -692,6 +692,9 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (!tgt || (fcport->port_type != FCT_INITIATOR))
 		return;
 
+	if (qla_ini_mode_enabled(vha))
+		return;
+
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	if (tgt->tgt_stop) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -701,9 +704,9 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		mutex_lock(&ha->tgt.tgt_mutex);
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
 		sess = qlt_create_sess(vha, fcport, false);
-		mutex_unlock(&ha->tgt.tgt_mutex);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 	} else {
@@ -739,7 +742,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess;
 	unsigned long flags;
 
@@ -806,12 +809,12 @@ void qlt_stop_phase1(struct qla_tgt *tgt)
 	 * Mutex needed to sync with qla_tgt_fc_port_[added,deleted].
 	 * Lock is needed, because we still can get an incoming packet.
 	 */
-	mutex_lock(&ha->tgt.tgt_mutex);
+	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	tgt->tgt_stop = 1;
 	qlt_clear_tgt_db(tgt, true);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	mutex_unlock(&ha->tgt.tgt_mutex);
+	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 	flush_delayed_work(&tgt->sess_del_work);
 
@@ -845,20 +848,21 @@ EXPORT_SYMBOL(qlt_stop_phase1);
 void qlt_stop_phase2(struct qla_tgt *tgt)
 {
 	struct qla_hw_data *ha = tgt->ha;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	unsigned long flags;
 
 	if (tgt->tgt_stopped) {
-		ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xf04f,
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04f,
 		    "Already in tgt->tgt_stopped state\n");
 		dump_stack();
 		return;
 	}
 
-	ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xf00b,
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00b,
 	    "Waiting for %d IRQ commands to complete (tgt %p)",
 	    tgt->irq_cmd_count, tgt);
 
-	mutex_lock(&ha->tgt.tgt_mutex);
+	mutex_lock(&vha->vha_tgt.tgt_mutex);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	while (tgt->irq_cmd_count != 0) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -868,9 +872,9 @@ void qlt_stop_phase2(struct qla_tgt *tgt)
 	tgt->tgt_stop = 0;
 	tgt->tgt_stopped = 1;
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-	mutex_unlock(&ha->tgt.tgt_mutex);
+	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xf00c, "Stop of tgt %p finished",
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00c, "Stop of tgt %p finished",
 	    tgt);
 }
 EXPORT_SYMBOL(qlt_stop_phase2);
@@ -878,14 +882,14 @@ EXPORT_SYMBOL(qlt_stop_phase2);
 /* Called from qlt_remove_target() -> qla2x00_remove_one() */
 static void qlt_release(struct qla_tgt *tgt)
 {
-	struct qla_hw_data *ha = tgt->ha;
+	scsi_qla_host_t *vha = tgt->vha;
 
-	if ((ha->tgt.qla_tgt != NULL) && !tgt->tgt_stopped)
+	if ((vha->vha_tgt.qla_tgt != NULL) && !tgt->tgt_stopped)
 		qlt_stop_phase2(tgt);
 
-	ha->tgt.qla_tgt = NULL;
+	vha->vha_tgt.qla_tgt = NULL;
 
-	ql_dbg(ql_dbg_tgt_mgt, tgt->vha, 0xf00d,
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf00d,
 	    "Release of tgt %p finished\n", tgt);
 
 	kfree(tgt);
@@ -949,8 +953,8 @@ static void qlt_send_notify_ack(struct scsi_qla_host *vha,
 		return;
 	}
 
-	if (ha->tgt.qla_tgt != NULL)
-		ha->tgt.qla_tgt->notify_ack_expected++;
+	if (vha->vha_tgt.qla_tgt != NULL)
+		vha->vha_tgt.qla_tgt->notify_ack_expected++;
 
 	pkt->entry_type = NOTIFY_ACK_TYPE;
 	pkt->entry_count = 1;
@@ -1054,7 +1058,7 @@ static void qlt_24xx_send_abts_resp(struct scsi_qla_host *vha,
 		/* Other bytes are zero */
 	}
 
-	ha->tgt.qla_tgt->abts_resp_expected++;
+	vha->vha_tgt.qla_tgt->abts_resp_expected++;
 
 	qla2x00_start_iocbs(vha, vha->req);
 }
@@ -1206,7 +1210,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf012,
 		    "qla_target(%d): task abort for non-existant session\n",
 		    vha->vp_idx);
-		rc = qlt_sched_sess_work(ha->tgt.qla_tgt,
+		rc = qlt_sched_sess_work(vha->vha_tgt.qla_tgt,
 		    QLA_TGT_SESS_WORK_ABORT, abts, sizeof(*abts));
 		if (rc != 0) {
 			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED,
@@ -2157,8 +2161,7 @@ static int qlt_prepare_srr_ctio(struct scsi_qla_host *vha,
 	struct qla_tgt_cmd *cmd, void *ctio)
 {
 	struct qla_tgt_srr_ctio *sc;
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_srr_imm *imm;
 
 	tgt->ctio_srr_id++;
@@ -2474,7 +2477,7 @@ static void qlt_do_work(struct work_struct *work)
 	struct qla_tgt_cmd *cmd = container_of(work, struct qla_tgt_cmd, work);
 	scsi_qla_host_t *vha = cmd->vha;
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess = NULL;
 	struct atio_from_isp *atio = &cmd->atio;
 	unsigned char *cdb;
@@ -2507,10 +2510,10 @@ static void qlt_do_work(struct work_struct *work)
 			goto out_term;
 		}
 
-		mutex_lock(&ha->tgt.tgt_mutex);
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
 		sess = qlt_make_local_sess(vha, s_id);
 		/* sess has an extra creation ref. */
-		mutex_unlock(&ha->tgt.tgt_mutex);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 		if (!sess)
 			goto out_term;
@@ -2576,8 +2579,7 @@ out_term:
 static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio)
 {
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_cmd *cmd;
 
 	if (unlikely(tgt->tgt_stop)) {
@@ -2597,7 +2599,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	memcpy(&cmd->atio, atio, sizeof(*atio));
 	cmd->state = QLA_TGT_STATE_NEW;
-	cmd->tgt = ha->tgt.qla_tgt;
+	cmd->tgt = vha->vha_tgt.qla_tgt;
 	cmd->vha = vha;
 
 	INIT_WORK(&cmd->work, qlt_do_work);
@@ -2723,7 +2725,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	uint32_t lun, unpacked_lun;
 	int lun_size, fn;
 
-	tgt = ha->tgt.qla_tgt;
+	tgt = vha->vha_tgt.qla_tgt;
 
 	lun = a->u.isp24.fcp_cmnd.lun;
 	lun_size = sizeof(a->u.isp24.fcp_cmnd.lun);
@@ -2797,7 +2799,7 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf025,
 		    "qla_target(%d): task abort for unexisting "
 		    "session\n", vha->vp_idx);
-		return qlt_sched_sess_work(ha->tgt.qla_tgt,
+		return qlt_sched_sess_work(vha->vha_tgt.qla_tgt,
 		    QLA_TGT_SESS_WORK_ABORT, iocb, sizeof(*iocb));
 	}
 
@@ -2810,7 +2812,6 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
-	struct qla_hw_data *ha = vha->hw;
 	int res = 0;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf026,
@@ -2828,7 +2829,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	case ELS_PDISC:
 	case ELS_ADISC:
 	{
-		struct qla_tgt *tgt = ha->tgt.qla_tgt;
+		struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 		if (tgt->link_reinit_iocb_pending) {
 			qlt_send_notify_ack(vha, &tgt->link_reinit_iocb,
 			    0, 0, 0, 0, 0, 0);
@@ -3202,8 +3203,7 @@ static void qlt_prepare_srr_imm(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
 	struct qla_tgt_srr_imm *imm;
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_srr_ctio *sctio;
 
 	tgt->imm_srr_id++;
@@ -3313,7 +3313,7 @@ static void qlt_handle_imm_notify(struct scsi_qla_host *vha,
 
 	case IMM_NTFY_LIP_LINK_REINIT:
 	{
-		struct qla_tgt *tgt = ha->tgt.qla_tgt;
+		struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf033,
 		    "qla_target(%d): LINK REINIT (loop %#x, "
 		    "subcode %x)\n", vha->vp_idx,
@@ -3489,7 +3489,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	int rc;
 
 	if (unlikely(tgt == NULL)) {
@@ -3591,7 +3591,7 @@ static void qlt_24xx_atio_pkt(struct scsi_qla_host *vha,
 static void qlt_response_pkt(struct scsi_qla_host *vha, response_t *pkt)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 
 	if (unlikely(tgt == NULL)) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe05d,
@@ -3794,7 +3794,7 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 	uint16_t *mailbox)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	int login_code;
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe039,
@@ -3924,14 +3924,14 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 static struct qla_tgt_sess *qlt_make_local_sess(struct scsi_qla_host *vha,
 	uint8_t *s_id)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess = NULL;
 	fc_port_t *fcport = NULL;
 	int rc, global_resets;
 	uint16_t loop_id = 0;
 
 retry:
-	global_resets = atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count);
+	global_resets =
+	    atomic_read(&vha->vha_tgt.qla_tgt->tgt_global_resets_count);
 
 	rc = qla24xx_get_loop_id(vha, s_id, &loop_id);
 	if (rc != 0) {
@@ -3958,12 +3958,13 @@ retry:
 		return NULL;
 
 	if (global_resets !=
-	    atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count)) {
+	    atomic_read(&vha->vha_tgt.qla_tgt->tgt_global_resets_count)) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf043,
 		    "qla_target(%d): global reset during session discovery "
 		    "(counter was %d, new %d), retrying", vha->vp_idx,
 		    global_resets,
-		    atomic_read(&ha->tgt.qla_tgt->tgt_global_resets_count));
+		    atomic_read(&vha->vha_tgt.
+			qla_tgt->tgt_global_resets_count));
 		goto retry;
 	}
 
@@ -3998,10 +3999,10 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		mutex_lock(&ha->tgt.tgt_mutex);
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
 		sess = qlt_make_local_sess(vha, s_id);
 		/* sess has got an extra creation ref */
-		mutex_unlock(&ha->tgt.tgt_mutex);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		if (!sess)
@@ -4052,10 +4053,10 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	if (!sess) {
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-		mutex_lock(&ha->tgt.tgt_mutex);
+		mutex_lock(&vha->vha_tgt.tgt_mutex);
 		sess = qlt_make_local_sess(vha, s_id);
 		/* sess has got an extra creation ref */
-		mutex_unlock(&ha->tgt.tgt_mutex);
+		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 		if (!sess)
@@ -4141,9 +4142,9 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	}
 
 	ql_dbg(ql_dbg_tgt, base_vha, 0xe03b,
-	    "Registering target for host %ld(%p)", base_vha->host_no, ha);
+	    "Registering target for host %ld(%p).\n", base_vha->host_no, ha);
 
-	BUG_ON((ha->tgt.qla_tgt != NULL) || (ha->tgt.tgt_ops != NULL));
+	BUG_ON(base_vha->vha_tgt.qla_tgt != NULL);
 
 	tgt = kzalloc(sizeof(struct qla_tgt), GFP_KERNEL);
 	if (!tgt) {
@@ -4171,7 +4172,7 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	INIT_WORK(&tgt->srr_work, qlt_handle_srr_work);
 	atomic_set(&tgt->tgt_global_resets_count, 0);
 
-	ha->tgt.qla_tgt = tgt;
+	base_vha->vha_tgt.qla_tgt = tgt;
 
 	ql_dbg(ql_dbg_tgt, base_vha, 0xe067,
 		"qla_target(%d): using 64 Bit PCI addressing",
@@ -4192,16 +4193,16 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 /* Must be called under tgt_host_action_mutex */
 int qlt_remove_target(struct qla_hw_data *ha, struct scsi_qla_host *vha)
 {
-	if (!ha->tgt.qla_tgt)
+	if (!vha->vha_tgt.qla_tgt)
 		return 0;
 
 	mutex_lock(&qla_tgt_mutex);
-	list_del(&ha->tgt.qla_tgt->tgt_list_entry);
+	list_del(&vha->vha_tgt.qla_tgt->tgt_list_entry);
 	mutex_unlock(&qla_tgt_mutex);
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe03c, "Unregistering target for host %ld(%p)",
 	    vha->host_no, ha);
-	qlt_release(ha->tgt.qla_tgt);
+	qlt_release(vha->vha_tgt.qla_tgt);
 
 	return 0;
 }
@@ -4255,9 +4256,6 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
 		if (!host)
 			continue;
 
-		if (ha->tgt.tgt_ops != NULL)
-			continue;
-
 		if (!(host->hostt->supported_mode & MODE_TARGET))
 			continue;
 
@@ -4286,11 +4284,11 @@ int qlt_lport_register(struct qla_tgt_func_tmpl *qla_tgt_ops, u64 wwpn,
 		 * Setup passed parameters ahead of invoking callback
 		 */
 		ha->tgt.tgt_ops = qla_tgt_ops;
-		ha->tgt.target_lport_ptr = target_lport_ptr;
+		vha->vha_tgt.target_lport_ptr = target_lport_ptr;
 		rc = (*callback)(vha);
 		if (rc != 0) {
 			ha->tgt.tgt_ops = NULL;
-			ha->tgt.target_lport_ptr = NULL;
+			vha->vha_tgt.target_lport_ptr = NULL;
 			scsi_host_put(host);
 		}
 		mutex_unlock(&qla_tgt_mutex);
@@ -4314,7 +4312,7 @@ void qlt_lport_deregister(struct scsi_qla_host *vha)
 	/*
 	 * Clear the target_lport_ptr qla_target_template pointer in qla_hw_data
 	 */
-	ha->tgt.target_lport_ptr = NULL;
+	vha->vha_tgt.target_lport_ptr = NULL;
 	ha->tgt.tgt_ops = NULL;
 	/*
 	 * Release the Scsi_Host reference for the underlying qla2xxx host
@@ -4376,8 +4374,9 @@ void
 qlt_enable_vha(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	unsigned long flags;
+	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
 	if (!tgt) {
 		ql_dbg(ql_dbg_tgt, vha, 0xe069,
@@ -4392,9 +4391,14 @@ qlt_enable_vha(struct scsi_qla_host *vha)
 	qlt_set_mode(vha);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-	qla2xxx_wake_dpc(vha);
-	qla2x00_wait_for_hba_online(vha);
+	if (vha->vp_idx) {
+		qla24xx_disable_vp(vha);
+		qla24xx_enable_vp(vha);
+	} else {
+		set_bit(ISP_ABORT_NEEDED, &base_vha->dpc_flags);
+		qla2xxx_wake_dpc(base_vha);
+		qla2x00_wait_for_hba_online(base_vha);
+	}
 }
 EXPORT_SYMBOL(qlt_enable_vha);
 
@@ -4407,7 +4411,7 @@ void
 qlt_disable_vha(struct scsi_qla_host *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = ha->tgt.qla_tgt;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	unsigned long flags;
 
 	if (!tgt) {
@@ -4438,8 +4442,10 @@ qlt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 	if (!qla_tgt_mode_enabled(vha))
 		return;
 
-	mutex_init(&ha->tgt.tgt_mutex);
-	mutex_init(&ha->tgt.tgt_host_action_mutex);
+	vha->vha_tgt.qla_tgt = NULL;
+
+	mutex_init(&vha->vha_tgt.tgt_mutex);
+	mutex_init(&vha->vha_tgt.tgt_host_action_mutex);
 
 	qlt_clear_mode(vha);
 
@@ -4450,6 +4456,8 @@ qlt_vport_create(struct scsi_qla_host *vha, struct qla_hw_data *ha)
 	 * assigning the value appropriately.
 	 */
 	ha->tgt.atio_q_length = ATIO_ENTRY_CNT_24XX;
+
+	qlt_add_target(ha, vha);
 }
 
 void
@@ -4768,8 +4776,8 @@ qlt_probe_one_stage1(struct scsi_qla_host *base_vha, struct qla_hw_data *ha)
 		ISP_ATIO_Q_OUT(base_vha) = &ha->iobase->isp24.atio_q_out;
 	}
 
-	mutex_init(&ha->tgt.tgt_mutex);
-	mutex_init(&ha->tgt.tgt_host_action_mutex);
+	mutex_init(&base_vha->vha_tgt.tgt_mutex);
+	mutex_init(&base_vha->vha_tgt.tgt_host_action_mutex);
 	qlt_clear_mode(base_vha);
 }
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7eb19be..113ca95 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -53,16 +53,6 @@
 struct workqueue_struct *tcm_qla2xxx_free_wq;
 struct workqueue_struct *tcm_qla2xxx_cmd_wq;
 
-static int tcm_qla2xxx_check_true(struct se_portal_group *se_tpg)
-{
-	return 1;
-}
-
-static int tcm_qla2xxx_check_false(struct se_portal_group *se_tpg)
-{
-	return 0;
-}
-
 /*
  * Parse WWN.
  * If strict, we require lower-case hex and colon separators to be sure
@@ -174,7 +164,7 @@ static int tcm_qla2xxx_npiv_parse_wwn(
 	*wwnn = 0;
 
 	/* count may include a LF at end of string */
-	if (name[cnt-1] == '\n')
+	if (name[cnt-1] == '\n' || name[cnt-1] == 0)
 		cnt--;
 
 	/* validate we have enough characters for WWPN */
@@ -777,6 +767,9 @@ static void tcm_qla2xxx_put_session(struct se_session *se_sess)
 
 static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 {
+	if (!sess)
+		return;
+
 	assert_spin_locked(&sess->vha->hw->hardware_lock);
 	kref_put(&sess->se_sess->sess_kref, tcm_qla2xxx_release_session);
 }
@@ -957,7 +950,6 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 	struct tcm_qla2xxx_lport *lport = container_of(se_wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
 	struct scsi_qla_host *vha = lport->qla_vha;
-	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_tpg *tpg = container_of(se_tpg,
 			struct tcm_qla2xxx_tpg, se_tpg);
 	unsigned long op;
@@ -977,12 +969,12 @@ static ssize_t tcm_qla2xxx_tpg_store_enable(
 		atomic_set(&tpg->lport_tpg_enabled, 1);
 		qlt_enable_vha(vha);
 	} else {
-		if (!ha->tgt.qla_tgt) {
-			pr_err("truct qla_hw_data *ha->tgt.qla_tgt is NULL\n");
+		if (!vha->vha_tgt.qla_tgt) {
+			pr_err("struct qla_hw_data *vha->vha_tgt.qla_tgt is NULL\n");
 			return -ENODEV;
 		}
 		atomic_set(&tpg->lport_tpg_enabled, 0);
-		qlt_stop_phase1(ha->tgt.qla_tgt);
+		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 	}
 
 	return count;
@@ -1011,7 +1003,7 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 	if (kstrtoul(name + 5, 10, &tpgt) || tpgt > USHRT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	if (!lport->qla_npiv_vp && (tpgt != 1)) {
+	if ((tpgt != 1)) {
 		pr_err("In non NPIV mode, a single TPG=1 is used for HW port mappings\n");
 		return ERR_PTR(-ENOSYS);
 	}
@@ -1038,11 +1030,8 @@ static struct se_portal_group *tcm_qla2xxx_make_tpg(
 		kfree(tpg);
 		return NULL;
 	}
-	/*
-	 * Setup local TPG=1 pointer for non NPIV mode.
-	 */
-	if (lport->qla_npiv_vp == NULL)
-		lport->tpg_1 = tpg;
+
+	lport->tpg_1 = tpg;
 
 	return &tpg->se_tpg;
 }
@@ -1053,19 +1042,17 @@ static void tcm_qla2xxx_drop_tpg(struct se_portal_group *se_tpg)
 			struct tcm_qla2xxx_tpg, se_tpg);
 	struct tcm_qla2xxx_lport *lport = tpg->lport;
 	struct scsi_qla_host *vha = lport->qla_vha;
-	struct qla_hw_data *ha = vha->hw;
 	/*
 	 * Call into qla2x_target.c LLD logic to shutdown the active
 	 * FC Nexuses and disable target mode operation for this qla_hw_data
 	 */
-	if (ha->tgt.qla_tgt && !ha->tgt.qla_tgt->tgt_stop)
-		qlt_stop_phase1(ha->tgt.qla_tgt);
+	if (vha->vha_tgt.qla_tgt && !vha->vha_tgt.qla_tgt->tgt_stop)
+		qlt_stop_phase1(vha->vha_tgt.qla_tgt);
 
 	core_tpg_deregister(se_tpg);
 	/*
 	 * Clear local TPG=1 pointer for non NPIV mode.
 	 */
-	if (lport->qla_npiv_vp == NULL)
 		lport->tpg_1 = NULL;
 
 	kfree(tpg);
@@ -1095,12 +1082,22 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 	tpg->lport = lport;
 	tpg->lport_tpgt = tpgt;
 
+	/*
+	 * By default allow READ-ONLY TPG demo-mode access w/ cached dynamic
+	 * NodeACLs
+	 */
+	tpg->tpg_attrib.generate_node_acls = 1;
+	tpg->tpg_attrib.demo_mode_write_protect = 1;
+	tpg->tpg_attrib.cache_dynamic_acls = 1;
+	tpg->tpg_attrib.demo_mode_login_only = 1;
+
 	ret = core_tpg_register(&tcm_qla2xxx_npiv_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, tpg, TRANSPORT_TPG_TYPE_NORMAL);
 	if (ret < 0) {
 		kfree(tpg);
 		return NULL;
 	}
+	lport->tpg_1 = tpg;
 	return &tpg->se_tpg;
 }
 
@@ -1111,13 +1108,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 	scsi_qla_host_t *vha,
 	const uint8_t *s_id)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
 	struct se_node_acl *se_nacl;
 	struct tcm_qla2xxx_nacl *nacl;
 	u32 key;
 
-	lport = ha->tgt.target_lport_ptr;
+	lport = vha->vha_tgt.target_lport_ptr;
 	if (!lport) {
 		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
@@ -1221,13 +1217,12 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 	scsi_qla_host_t *vha,
 	const uint16_t loop_id)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
 	struct se_node_acl *se_nacl;
 	struct tcm_qla2xxx_nacl *nacl;
 	struct tcm_qla2xxx_fc_loopid *fc_loopid;
 
-	lport = ha->tgt.target_lport_ptr;
+	lport = vha->vha_tgt.target_lport_ptr;
 	if (!lport) {
 		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
@@ -1341,6 +1336,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
 	struct qla_hw_data *ha = tgt->ha;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	struct se_session *se_sess;
 	struct se_node_acl *se_nacl;
 	struct tcm_qla2xxx_lport *lport;
@@ -1357,7 +1353,7 @@ static void tcm_qla2xxx_free_session(struct qla_tgt_sess *sess)
 	se_nacl = se_sess->se_node_acl;
 	nacl = container_of(se_nacl, struct tcm_qla2xxx_nacl, se_node_acl);
 
-	lport = ha->tgt.target_lport_ptr;
+	lport = vha->vha_tgt.target_lport_ptr;
 	if (!lport) {
 		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
@@ -1391,7 +1387,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	unsigned char port_name[36];
 	unsigned long flags;
 
-	lport = ha->tgt.target_lport_ptr;
+	lport = vha->vha_tgt.target_lport_ptr;
 	if (!lport) {
 		pr_err("Unable to locate struct tcm_qla2xxx_lport\n");
 		dump_stack();
@@ -1455,7 +1451,8 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 {
 	struct qla_tgt *tgt = sess->tgt;
 	struct qla_hw_data *ha = tgt->ha;
-	struct tcm_qla2xxx_lport *lport = ha->tgt.target_lport_ptr;
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
+	struct tcm_qla2xxx_lport *lport = vha->vha_tgt.target_lport_ptr;
 	struct se_node_acl *se_nacl = sess->se_sess->se_node_acl;
 	struct tcm_qla2xxx_nacl *nacl = container_of(se_nacl,
 			struct tcm_qla2xxx_nacl, se_node_acl);
@@ -1564,13 +1561,12 @@ static int tcm_qla2xxx_init_lport(struct tcm_qla2xxx_lport *lport)
 
 static int tcm_qla2xxx_lport_register_cb(struct scsi_qla_host *vha)
 {
-	struct qla_hw_data *ha = vha->hw;
 	struct tcm_qla2xxx_lport *lport;
 	/*
 	 * Setup local pointer to vha, NPIV VP pointer (if present) and
 	 * vha->tcm_lport pointer
 	 */
-	lport = (struct tcm_qla2xxx_lport *)ha->tgt.target_lport_ptr;
+	lport = (struct tcm_qla2xxx_lport *)vha->vha_tgt.target_lport_ptr;
 	lport->qla_vha = vha;
 
 	return 0;
@@ -1621,7 +1617,6 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 	struct tcm_qla2xxx_lport *lport = container_of(wwn,
 			struct tcm_qla2xxx_lport, lport_wwn);
 	struct scsi_qla_host *vha = lport->qla_vha;
-	struct qla_hw_data *ha = vha->hw;
 	struct se_node_acl *node;
 	u32 key = 0;
 
@@ -1630,8 +1625,8 @@ static void tcm_qla2xxx_drop_lport(struct se_wwn *wwn)
 	 * shutdown of struct qla_tgt after the call to
 	 * qlt_stop_phase1() from tcm_qla2xxx_drop_tpg() above..
 	 */
-	if (ha->tgt.qla_tgt && !ha->tgt.qla_tgt->tgt_stopped)
-		qlt_stop_phase2(ha->tgt.qla_tgt);
+	if (vha->vha_tgt.qla_tgt && !vha->vha_tgt.qla_tgt->tgt_stopped)
+		qlt_stop_phase2(vha->vha_tgt.qla_tgt);
 
 	qlt_lport_deregister(vha);
 
@@ -1650,6 +1645,9 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 	struct tcm_qla2xxx_lport *lport;
 	u64 npiv_wwpn, npiv_wwnn;
 	int ret;
+	struct scsi_qla_host *vha = NULL;
+	struct qla_hw_data *ha = NULL;
+	scsi_qla_host_t *base_vha = NULL;
 
 	if (tcm_qla2xxx_npiv_parse_wwn(name, strlen(name)+1,
 				&npiv_wwpn, &npiv_wwnn) < 0)
@@ -1666,12 +1664,29 @@ static struct se_wwn *tcm_qla2xxx_npiv_make_lport(
 			TCM_QLA2XXX_NAMELEN, npiv_wwpn, npiv_wwnn);
 	sprintf(lport->lport_naa_name, "naa.%016llx", (unsigned long long) npiv_wwpn);
 
-/* FIXME: tcm_qla2xxx_npiv_make_lport */
-	ret = -ENOSYS;
+	ret = tcm_qla2xxx_init_lport(lport);
 	if (ret != 0)
 		goto out;
 
+	ret = qlt_lport_register(&tcm_qla2xxx_template, npiv_wwpn,
+				tcm_qla2xxx_lport_register_cb, lport);
+
+	if (ret != 0)
+		goto out_lport;
+
+	vha = lport->qla_vha;
+	ha = vha->hw;
+	base_vha = pci_get_drvdata(ha->pdev);
+
+	if (!qla_tgt_mode_enabled(base_vha)) {
+		ret = -EPERM;
+		goto out_lport;
+	}
+
 	return &lport->lport_wwn;
+out_lport:
+	vfree(lport->lport_loopid_map);
+	btree_destroy32(&lport->lport_fcport_map);
 out:
 	kfree(lport);
 	return ERR_PTR(ret);
@@ -1684,9 +1699,9 @@ static void tcm_qla2xxx_npiv_drop_lport(struct se_wwn *wwn)
 	struct scsi_qla_host *vha = lport->qla_vha;
 	struct Scsi_Host *sh = vha->host;
 	/*
-	 * Notify libfc that we want to release the lport->npiv_vport
+	 * Notify libfc that we want to release the vha->fc_vport
 	 */
-	fc_vport_terminate(lport->npiv_vport);
+	fc_vport_terminate(vha->fc_vport);
 
 	scsi_host_put(sh);
 	kfree(lport);
@@ -1769,14 +1784,16 @@ static struct target_core_fabric_ops tcm_qla2xxx_npiv_ops = {
 	.tpg_get_pr_transport_id	= tcm_qla2xxx_get_pr_transport_id,
 	.tpg_get_pr_transport_id_len	= tcm_qla2xxx_get_pr_transport_id_len,
 	.tpg_parse_pr_out_transport_id	= tcm_qla2xxx_parse_pr_out_transport_id,
-	.tpg_check_demo_mode		= tcm_qla2xxx_check_false,
-	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_true,
-	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_true,
-	.tpg_check_prod_mode_write_protect = tcm_qla2xxx_check_false,
+	.tpg_check_demo_mode		= tcm_qla2xxx_check_demo_mode,
+	.tpg_check_demo_mode_cache	= tcm_qla2xxx_check_demo_mode_cache,
+	.tpg_check_demo_mode_write_protect = tcm_qla2xxx_check_demo_mode,
+	.tpg_check_prod_mode_write_protect =
+	    tcm_qla2xxx_check_prod_write_protect,
 	.tpg_check_demo_mode_login_only	= tcm_qla2xxx_check_demo_mode_login_only,
 	.tpg_alloc_fabric_acl		= tcm_qla2xxx_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= tcm_qla2xxx_release_fabric_acl,
 	.tpg_get_inst_index		= tcm_qla2xxx_tpg_get_inst_index,
+	.check_stop_free                = tcm_qla2xxx_check_stop_free,
 	.release_cmd			= tcm_qla2xxx_release_cmd,
 	.put_session			= tcm_qla2xxx_put_session,
 	.shutdown_session		= tcm_qla2xxx_shutdown_session,
@@ -1871,7 +1888,8 @@ static int tcm_qla2xxx_register_configfs(void)
 	 * Setup default attribute lists for various npiv_fabric->tf_cit_tmpl
 	 */
 	npiv_fabric->tf_cit_tmpl.tfc_wwn_cit.ct_attrs = tcm_qla2xxx_wwn_attrs;
-	npiv_fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs = NULL;
+	npiv_fabric->tf_cit_tmpl.tfc_tpg_base_cit.ct_attrs =
+	    tcm_qla2xxx_tpg_attrs;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_attrib_cit.ct_attrs = NULL;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_param_cit.ct_attrs = NULL;
 	npiv_fabric->tf_cit_tmpl.tfc_tpg_np_base_cit.ct_attrs = NULL;
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.h b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
index 771f7b8..275d8b9 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.h
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.h
@@ -70,12 +70,8 @@ struct tcm_qla2xxx_lport {
 	struct tcm_qla2xxx_fc_loopid *lport_loopid_map;
 	/* Pointer to struct scsi_qla_host from qla2xxx LLD */
 	struct scsi_qla_host *qla_vha;
-	/* Pointer to struct scsi_qla_host for NPIV VP from qla2xxx LLD */
-	struct scsi_qla_host *qla_npiv_vp;
 	/* Pointer to struct qla_tgt pointer */
 	struct qla_tgt lport_qla_tgt;
-	/* Pointer to struct fc_vport for NPIV vport from libfc */
-	struct fc_vport *npiv_vport;
 	/* Pointer to TPG=1 for non NPIV mode */
 	struct tcm_qla2xxx_tpg *tpg_1;
 	/* Returned by tcm_qla2xxx_make_lport() */
-- 
1.7.7
