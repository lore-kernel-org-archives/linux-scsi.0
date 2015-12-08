From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 13/20] qla2xxx: Remove dependency on hardware_lock to reduce lock contention.
Date: Mon, 7 Dec 2015 19:49:00 -0500
Message-ID: <1449535747-2850-14-git-send-email-himanshu.madhani@qlogic.com>
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

Sessions management (add, deleted, modify) currently are serialized
through the hardware_lock.  Hardware_lock is a high traffic lock.
This lock is accessed by both the transmit & receive sides.

Sessions management is now moved off to another lock call sess_lock.
This is done to reduce lock contention and increase traffic throughput.

Signed-off-by: Quinn Tran <quinn.tran@qlogic.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |    1 +
 drivers/scsi/qla2xxx/qla_target.c  |  131 ++++++++++++++++++++++++------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   28 ++++----
 4 files changed, 105 insertions(+), 56 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 46abba8..7c6369b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2929,6 +2929,7 @@ struct qlt_hw_data {
 	uint32_t num_qfull_cmds_dropped;
 	spinlock_t q_full_lock;
 	uint32_t leak_exchg_thresh_hold;
+	spinlock_t sess_lock;
 };
 
 #define MAX_QFULL_CMDS_ALLOC	8192
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index eb47272..8b45642 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2336,6 +2336,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	ha->tgt.enable_class_2 = ql2xenableclass2;
 	INIT_LIST_HEAD(&ha->tgt.q_full_list);
 	spin_lock_init(&ha->tgt.q_full_lock);
+	spin_lock_init(&ha->tgt.sess_lock);
 
 	/* Clear our data area */
 	ha->bars = bars;
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 5fca846..d4b7e25 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -635,7 +635,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		wake_up_all(&tgt->waitQ);
 }
 
-/* ha->hardware_lock supposed to be held on entry */
+/* ha->tgt.sess_lock supposed to be held on entry */
 void qlt_unreg_sess(struct qla_tgt_sess *sess)
 {
 	struct scsi_qla_host *vha = sess->vha;
@@ -651,7 +651,7 @@ void qlt_unreg_sess(struct qla_tgt_sess *sess)
 }
 EXPORT_SYMBOL(qlt_unreg_sess);
 
-/* ha->hardware_lock supposed to be held on entry */
+
 static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 {
 	struct qla_hw_data *ha = vha->hw;
@@ -661,12 +661,15 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	int res = 0;
 	struct imm_ntfy_from_isp *n = (struct imm_ntfy_from_isp *)iocb;
 	struct atio_from_isp *a = (struct atio_from_isp *)iocb;
+	unsigned long flags;
 
 	loop_id = le16_to_cpu(n->u.isp24.nport_handle);
 	if (loop_id == 0xFFFF) {
 		/* Global event */
 		atomic_inc(&vha->vha_tgt.qla_tgt->tgt_global_resets_count);
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		qlt_clear_tgt_db(vha->vha_tgt.qla_tgt);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 #if 0 /* FIXME: do we need to choose a session here? */
 		if (!list_empty(&ha->tgt.qla_tgt->sess_list)) {
 			sess = list_entry(ha->tgt.qla_tgt->sess_list.next,
@@ -693,7 +696,9 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 			sess = NULL;
 #endif
 	} else {
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		sess = ha->tgt.tgt_ops->find_sess_by_loop_id(vha, loop_id);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	}
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe000,
@@ -715,7 +720,7 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	    iocb, QLA24XX_MGMT_SEND_NACK);
 }
 
-/* ha->hardware_lock supposed to be held on entry */
+/* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	bool immediate)
 {
@@ -759,7 +764,7 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 		    sess->expires - jiffies);
 }
 
-/* ha->hardware_lock supposed to be held on entry */
+/* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 {
 	struct qla_tgt_sess *sess;
@@ -819,7 +824,7 @@ out_free_id_list:
 	return res;
 }
 
-/* ha->hardware_lock supposed to be held on entry */
+/* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_undelete_sess(struct qla_tgt_sess *sess)
 {
 	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
@@ -837,7 +842,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 	struct qla_tgt_sess *sess;
 	unsigned long flags, elapsed;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	while (!list_empty(&tgt->del_sess_list)) {
 		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
 		    del_list_entry);
@@ -858,7 +863,7 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 /*
@@ -876,7 +881,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	unsigned char be_sid[3];
 
 	/* Check to avoid double sessions */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	list_for_each_entry(sess, &vha->vha_tgt.qla_tgt->sess_list,
 				sess_list_entry) {
 		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
@@ -891,7 +896,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 			/* Cannot undelete at this point */
 			if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-				spin_unlock_irqrestore(&ha->hardware_lock,
+				spin_unlock_irqrestore(&ha->tgt.sess_lock,
 				    flags);
 				return NULL;
 			}
@@ -908,12 +913,12 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 			qlt_do_generation_tick(vha, &sess->generation);
 
-			spin_unlock_irqrestore(&ha->hardware_lock, flags);
+			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 			return sess;
 		}
 	}
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
@@ -958,7 +963,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	}
 	/*
 	 * Take an extra reference to ->sess_kref here to handle qla_tgt_sess
-	 * access across ->hardware_lock reaquire.
+	 * access across ->tgt.sess_lock reaquire.
 	 */
 	kref_get(&sess->se_sess->sess_kref);
 
@@ -966,11 +971,11 @@ static struct qla_tgt_sess *qlt_create_sess(
 	BUILD_BUG_ON(sizeof(sess->port_name) != sizeof(fcport->port_name));
 	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	list_add_tail(&sess->sess_list_entry, &vha->vha_tgt.qla_tgt->sess_list);
 	vha->vha_tgt.qla_tgt->sess_count++;
 	qlt_do_generation_tick(vha, &sess->generation);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
 	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
@@ -1001,23 +1006,23 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 	if (qla_ini_mode_enabled(vha))
 		return;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return;
 	}
 	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
 	if (!sess) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 		mutex_lock(&vha->vha_tgt.tgt_mutex);
 		sess = qlt_create_sess(vha, fcport, false);
 		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	} else if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
 		/* Point of no return */
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return;
 	} else {
 		kref_get(&sess->se_sess->sess_kref);
@@ -1046,7 +1051,7 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 		sess->local = 0;
 	}
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 /*
@@ -1058,6 +1063,7 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess;
+	unsigned long flags;
 
 	if (!vha->hw->tgt.tgt_ops)
 		return;
@@ -1065,11 +1071,14 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 	if (!tgt)
 		return;
 
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	if (tgt->tgt_stop) {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
 	sess = qlt_find_sess_by_port_name(tgt, fcport->port_name);
 	if (!sess) {
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 		return;
 	}
 
@@ -1086,6 +1095,7 @@ qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 
 	sess->local = 1;
 	qlt_schedule_sess_for_deletion(sess, false);
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
 static inline int test_tgt_sess_count(struct qla_tgt *tgt)
@@ -1143,10 +1153,10 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	 * Lock is needed, because we still can get an incoming packet.
 	 */
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	tgt->tgt_stop = 1;
 	qlt_clear_tgt_db(tgt);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 	mutex_unlock(&qla_tgt_mutex);
 
@@ -1594,6 +1604,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	uint32_t tag = abts->exchange_addr_to_abort;
 	uint8_t s_id[3];
 	int rc;
+	unsigned long flags;
 
 	if (le32_to_cpu(abts->fcp_hdr_le.parameter) & ABTS_PARAM_ABORT_SEQ) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf053,
@@ -1621,6 +1632,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	s_id[1] = abts->fcp_hdr_le.s_id[1];
 	s_id[2] = abts->fcp_hdr_le.s_id[0];
 
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf012,
@@ -1628,12 +1640,17 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 		    vha->vp_idx);
 		rc = qlt_sched_sess_work(vha->vha_tgt.qla_tgt,
 		    QLA_TGT_SESS_WORK_ABORT, abts, sizeof(*abts));
+
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
 		if (rc != 0) {
 			qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED,
 			    false);
 		}
 		return;
 	}
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
 
 	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
 		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED, false);
@@ -3788,9 +3805,9 @@ static void __qlt_do_work(struct qla_tgt_cmd *cmd)
 	/*
 	 * Drop extra session reference from qla_tgt_handle_cmd_for_atio*(
 	 */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
 out_term:
@@ -3805,8 +3822,11 @@ out_term:
 
 	qlt_decr_num_pend_cmds(vha);
 	percpu_ida_free(&sess->se_sess->sess_tag_pool, cmd->se_cmd.map_tag);
-	ha->tgt.tgt_ops->put_sess(sess);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	ha->tgt.tgt_ops->put_sess(sess);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 static void qlt_do_work(struct work_struct *work)
@@ -4114,13 +4134,18 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 	struct qla_tgt_sess *sess;
 	uint32_t lun, unpacked_lun;
 	int fn;
+	unsigned long flags;
 
 	tgt = vha->vha_tgt.qla_tgt;
 
 	lun = a->u.isp24.fcp_cmnd.lun;
 	fn = a->u.isp24.fcp_cmnd.task_mgmt_flags;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    a->u.isp24.fcp_hdr.s_id);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
 
 	if (!sess) {
@@ -4184,10 +4209,14 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess;
 	int loop_id;
+	unsigned long flags;
 
 	loop_id = GET_TARGET_ID(ha, (struct atio_from_isp *)iocb);
 
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_loop_id(vha, loop_id);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
 	if (sess == NULL) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf025,
 		    "qla_target(%d): task abort for unexisting "
@@ -4334,6 +4363,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	uint16_t wd3_lo;
 	int res = 0;
 	qlt_plogi_ack_t *pla;
+	unsigned long flags;
 
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
 
@@ -4357,9 +4387,12 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		/* Mark all stale commands in qla_tgt_wq for deletion */
 		abort_cmds_for_s_id(vha, &port_id);
 
-		if (wwn)
+		if (wwn) {
+			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
 			sess = qlt_find_sess_invalidate_other(tgt, wwn,
 			    port_id, loop_id, &conflict_sess);
+			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
+		}
 
 		if (IS_SW_RESV_ADDR(port_id) || (!sess && !conflict_sess)) {
 			res = 1;
@@ -4410,9 +4443,12 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	case ELS_PRLI:
 		wd3_lo = le16_to_cpu(iocb->u.isp24.u.prli.wd3_lo);
 
-		if (wwn)
+		if (wwn) {
+			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
 			sess = qlt_find_sess_invalidate_other(tgt, wwn, port_id,
 			    loop_id, &conflict_sess);
+			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
+		}
 
 		if (conflict_sess) {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09b,
@@ -5091,9 +5127,12 @@ static int __qlt_send_busy(struct scsi_qla_host *vha,
 	struct qla_hw_data *ha = vha->hw;
 	request_t *pkt;
 	struct qla_tgt_sess *sess = NULL;
+	unsigned long flags;
 
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    atio->u.isp24.fcp_hdr.s_id);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	if (!sess) {
 		qlt_send_term_exchange(vha, NULL, atio, 1, 0);
 		return 0;
@@ -5794,15 +5833,15 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	struct scsi_qla_host *vha = tgt->vha;
 	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess = NULL;
-	unsigned long flags;
+	unsigned long flags = 0, flags2 = 0;
 	uint32_t be_s_id;
 	uint8_t s_id[3];
 	int rc;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags2);
 
 	if (tgt->tgt_stop)
-		goto out_term;
+		goto out_term2;
 
 	s_id[0] = prm->abts.fcp_hdr_le.s_id[2];
 	s_id[1] = prm->abts.fcp_hdr_le.s_id[1];
@@ -5811,39 +5850,47 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha,
 	    (unsigned char *)&be_s_id);
 	if (!sess) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 
 		sess = qlt_make_local_sess(vha, s_id);
 		/* sess has got an extra creation ref */
 
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags2);
 		if (!sess)
-			goto out_term;
+			goto out_term2;
 	} else {
 		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
 			sess = NULL;
-			goto out_term;
+			goto out_term2;
 		}
 
 		kref_get(&sess->se_sess->sess_kref);
 	}
 
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
 	if (tgt->tgt_stop)
 		goto out_term;
 
 	rc = __qlt_24xx_handle_abts(vha, &prm->abts, sess);
 	if (rc != 0)
 		goto out_term;
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 	return;
 
+out_term2:
+	spin_lock_irqsave(&ha->hardware_lock, flags);
+
 out_term:
 	qlt_24xx_send_abts_resp(vha, &prm->abts, FCP_TMF_REJECTED, false);
+	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags2);
 }
 
 static void qlt_tmr_work(struct qla_tgt *tgt,
@@ -5860,7 +5907,7 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	int fn;
 	void *iocb;
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 
 	if (tgt->tgt_stop)
 		goto out_term;
@@ -5868,12 +5915,12 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 	s_id = prm->tm_iocb2.u.isp24.fcp_hdr.s_id;
 	sess = ha->tgt.tgt_ops->find_sess_by_s_id(vha, s_id);
 	if (!sess) {
-		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 		sess = qlt_make_local_sess(vha, s_id);
 		/* sess has got an extra creation ref */
 
-		spin_lock_irqsave(&ha->hardware_lock, flags);
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		if (!sess)
 			goto out_term;
 	} else {
@@ -5895,14 +5942,14 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 		goto out_term;
 
 	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	return;
 
 out_term:
-	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 1, 0);
+	qlt_send_term_exchange(vha, NULL, &prm->tm_iocb2, 0, 0);
 	if (sess)
 		ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 static void qlt_sess_work_fn(struct work_struct *work)
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 2e9c194..833dec2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -349,9 +349,9 @@ static int tcm_qla2xxx_shutdown_session(struct se_session *se_sess)
 	BUG_ON(!sess);
 	vha = sess->vha;
 
-	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	target_sess_cmd_list_set_waiting(se_sess);
-	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	return 1;
 }
@@ -365,9 +365,9 @@ static void tcm_qla2xxx_close_session(struct se_session *se_sess)
 	BUG_ON(!sess);
 	vha = sess->vha;
 
-	spin_lock_irqsave(&vha->hw->hardware_lock, flags);
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	qlt_unreg_sess(sess);
-	spin_unlock_irqrestore(&vha->hw->hardware_lock, flags);
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
 
 static u32 tcm_qla2xxx_sess_get_index(struct se_session *se_sess)
@@ -735,7 +735,7 @@ static void tcm_qla2xxx_aborted_task(struct se_cmd *se_cmd)
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *,
 			struct tcm_qla2xxx_nacl *, struct qla_tgt_sess *);
 /*
- * Expected to be called with struct qla_hw_data->hardware_lock held
+ * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
 static void tcm_qla2xxx_clear_nacl_from_fcport_map(struct qla_tgt_sess *sess)
 {
@@ -789,13 +789,13 @@ static void tcm_qla2xxx_put_sess(struct qla_tgt_sess *sess)
 	if (!sess)
 		return;
 
-	assert_spin_locked(&sess->vha->hw->hardware_lock);
+	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	kref_put(&sess->se_sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
 static void tcm_qla2xxx_shutdown_sess(struct qla_tgt_sess *sess)
 {
-	assert_spin_locked(&sess->vha->hw->hardware_lock);
+	assert_spin_locked(&sess->vha->hw->tgt.sess_lock);
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 }
 
@@ -1169,7 +1169,7 @@ static struct se_portal_group *tcm_qla2xxx_npiv_make_tpg(
 }
 
 /*
- * Expected to be called with struct qla_hw_data->hardware_lock held
+ * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
 static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 	scsi_qla_host_t *vha,
@@ -1208,7 +1208,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_s_id(
 }
 
 /*
- * Expected to be called with struct qla_hw_data->hardware_lock held
+ * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
 static void tcm_qla2xxx_set_sess_by_s_id(
 	struct tcm_qla2xxx_lport *lport,
@@ -1274,7 +1274,7 @@ static void tcm_qla2xxx_set_sess_by_s_id(
 }
 
 /*
- * Expected to be called with struct qla_hw_data->hardware_lock held
+ * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
 static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 	scsi_qla_host_t *vha,
@@ -1313,7 +1313,7 @@ static struct qla_tgt_sess *tcm_qla2xxx_find_sess_by_loop_id(
 }
 
 /*
- * Expected to be called with struct qla_hw_data->hardware_lock held
+ * Expected to be called with struct qla_hw_data->tgt.sess_lock held
  */
 static void tcm_qla2xxx_set_sess_by_loop_id(
 	struct tcm_qla2xxx_lport *lport,
@@ -1377,7 +1377,7 @@ static void tcm_qla2xxx_set_sess_by_loop_id(
 }
 
 /*
- * Should always be called with qla_hw_data->hardware_lock held.
+ * Should always be called with qla_hw_data->tgt.sess_lock held.
  */
 static void tcm_qla2xxx_clear_sess_lookup(struct tcm_qla2xxx_lport *lport,
 		struct tcm_qla2xxx_nacl *nacl, struct qla_tgt_sess *sess)
@@ -1493,12 +1493,12 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * And now setup the new se_nacl and session pointers into our HW lport
 	 * mappings for fabric S_ID and LOOP_ID.
 	 */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	tcm_qla2xxx_set_sess_by_s_id(lport, se_nacl, nacl, se_sess,
 			qla_tgt_sess, s_id);
 	tcm_qla2xxx_set_sess_by_loop_id(lport, se_nacl, nacl, se_sess,
 			qla_tgt_sess, loop_id);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 	/*
 	 * Finally register the new FC Nexus with TCM
 	 */
-- 
1.7.7
