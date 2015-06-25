From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 05/11] qla2xxx: added sess generations to detect RSCN update races
Date: Thu, 25 Jun 2015 12:33:45 -0400
Message-ID: <1435250031-20525-6-git-send-email-himanshu.madhani@qlogic.com>
References: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:48334 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752690AbbFYRSM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jun 2015 13:18:12 -0400
In-Reply-To: <1435250031-20525-1-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: hch@lst.de, giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Alexei Potashnik <alexei@purestorage.com>

RSCN processing in qla2xxx driver can run in parallel with ELS/IO
processing. As such the decision to remove disappeared fc port's
session could be stale, because a new login sequence has occurred
since and created a brand new session.

Previous mechanism of dealing with this by delaying deletion request
was prone to erroneous deletions if the event that was supposed to
cancel the deletion never arrived or has been delayed in processing.

New mechanism relies on a time-like generation counter to serialize
RSCN updates relative to ELS/IO updates.

Cc: <stable@vger.kernel.org>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |    2 +-
 drivers/scsi/qla2xxx/qla_def.h    |    5 +++
 drivers/scsi/qla2xxx/qla_init.c   |   32 ++++++++++++-------
 drivers/scsi/qla2xxx/qla_os.c     |    5 ++-
 drivers/scsi/qla2xxx/qla_target.c |   60 ++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_target.h |    5 ++-
 6 files changed, 83 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 05793b7..8b011ae 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -68,7 +68,7 @@
  * |                              |                    | 0xd101-0xd1fe	|
  * |                              |                    | 0xd214-0xd2fe	|
  * | Target Mode		  |	  0xe080       |		|
- * | Target Mode Management	  |	  0xf091       | 0xf002		|
+ * | Target Mode Management	  |	  0xf096       | 0xf002		|
  * |                              |                    | 0xf046-0xf049  |
  * | Target Mode Task Management  |	  0x1000d      |		|
  * ----------------------------------------------------------------------
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b036f1a..4a7aadc 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3607,6 +3607,11 @@ typedef struct scsi_qla_host {
 	struct list_head	qla_sess_op_cmd_list;
 	spinlock_t		cmd_list_lock;
 
+	/* Counter to detect races between ELS and RSCN events */
+	atomic_t		generation_tick;
+	/* Time when global fcport update has been scheduled */
+	int			total_fcport_update_gen;
+
 	uint32_t	vp_abort_cnt;
 
 	struct fc_vport	*fc_vport;	/* holds fc_vport * for each vport */
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 14456b1..3f3cdbf 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2925,24 +2925,14 @@ qla2x00_rport_del(void *data)
 {
 	fc_port_t *fcport = data;
 	struct fc_rport *rport;
-	scsi_qla_host_t *vha = fcport->vha;
 	unsigned long flags;
-	unsigned long vha_flags;
 
 	spin_lock_irqsave(fcport->vha->host->host_lock, flags);
 	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
-	if (rport) {
+	if (rport)
 		fc_remote_port_delete(rport);
-		/*
-		 * Release the target mode FC NEXUS in qla_target.c code
-		 * if target mod is enabled.
-		 */
-		spin_lock_irqsave(&vha->hw->hardware_lock, vha_flags);
-		qlt_fc_port_deleted(vha, fcport);
-		spin_unlock_irqrestore(&vha->hw->hardware_lock, vha_flags);
-	}
 }
 
 /**
@@ -3382,6 +3372,7 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	LIST_HEAD(new_fcports);
 	struct qla_hw_data *ha = vha->hw;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
+	int		discovery_gen;
 
 	/* If FL port exists, then SNS is present */
 	if (IS_FWI2_CAPABLE(ha))
@@ -3452,6 +3443,14 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			fcport->scan_state = QLA_FCPORT_SCAN;
 		}
 
+		/* Mark the time right before querying FW for connected ports.
+		 * This process is long, asynchronous and by the time it's done,
+		 * collected information might not be accurate anymore. E.g.
+		 * disconnected port might have re-connected and a brand new
+		 * session has been created. In this case session's generation
+		 * will be newer than discovery_gen. */
+		qlt_do_generation_tick(vha, &discovery_gen);
+
 		rval = qla2x00_find_all_fabric_devs(vha, &new_fcports);
 		if (rval != QLA_SUCCESS)
 			break;
@@ -3503,7 +3502,8 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 					    atomic_read(&fcport->state),
 					    fcport->flags, fcport->fc4_type,
 					    fcport->scan_state);
-					qlt_fc_port_deleted(vha, fcport);
+					qlt_fc_port_deleted(vha, fcport,
+					    discovery_gen);
 				}
 			}
 		}
@@ -4280,6 +4280,14 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 			    atomic_read(&fcport->state) != FCS_UNCONFIGURED) {
 				spin_unlock_irqrestore(&ha->vport_slock, flags);
 				qla2x00_rport_del(fcport);
+
+				/*
+				 * Release the target mode FC NEXUS in
+				 * qla_target.c, if target mod is enabled.
+				 */
+				qlt_fc_port_deleted(vha, fcport,
+				    base_vha->total_fcport_update_gen);
+
 				spin_lock_irqsave(&ha->vport_slock, flags);
 			}
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7ce395a..be6de2a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3230,11 +3230,14 @@ qla2x00_schedule_rport_del(struct scsi_qla_host *vha, fc_port_t *fcport,
 		spin_lock_irqsave(vha->host->host_lock, flags);
 		fcport->drport = rport;
 		spin_unlock_irqrestore(vha->host->host_lock, flags);
+		qlt_do_generation_tick(vha, &base_vha->total_fcport_update_gen);
 		set_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		qla2xxx_wake_dpc(base_vha);
 	} else {
+		int now;
 		fc_remote_port_delete(rport);
-		qlt_fc_port_deleted(vha, fcport);
+		qlt_do_generation_tick(vha, &now);
+		qlt_fc_port_deleted(vha, fcport, now);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 74afe92..b14623c 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -127,6 +127,16 @@ static struct workqueue_struct *qla_tgt_wq;
 static DEFINE_MUTEX(qla_tgt_mutex);
 static LIST_HEAD(qla_tgt_glist);
 
+/* This API intentionally takes dest as a parameter, rather than returning
+ * int value to avoid caller forgetting to issue wmb() after the store */
+void qlt_do_generation_tick(struct scsi_qla_host *vha, int *dest)
+{
+	scsi_qla_host_t *base_vha = pci_get_drvdata(vha->hw->pdev);
+	*dest = atomic_inc_return(&base_vha->generation_tick);
+	/* memory barrier */
+	wmb();
+}
+
 /* ha->hardware_lock supposed to be held on entry (to protect tgt->sess_list) */
 static struct qla_tgt_sess *qlt_find_sess_by_port_name(
 	struct qla_tgt *tgt,
@@ -576,10 +586,12 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	sess->expires = jiffies + dev_loss_tmo * HZ;
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
-	    "qla_target(%d): session for port %8phC (loop ID %d) scheduled for "
-	    "deletion in %u secs (expires: %lu) immed: %d, logout: %d\n",
-	    sess->vha->vp_idx, sess->port_name, sess->loop_id, dev_loss_tmo,
-	    sess->expires, immediate, sess->logout_on_delete);
+	    "qla_target(%d): session for port %8phC (loop ID %d s_id %02x:%02x:%02x)"
+	    " scheduled for deletion in %u secs (expires: %lu) immed: %d, logout: %d, gen: %#x\n",
+	    sess->vha->vp_idx, sess->port_name, sess->loop_id,
+	    sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
+	    dev_loss_tmo, sess->expires, immediate, sess->logout_on_delete,
+	    sess->generation);
 
 	if (immediate)
 		mod_delayed_work(system_wq, &tgt->sess_del_work, 0);
@@ -734,6 +746,9 @@ static struct qla_tgt_sess *qlt_create_sess(
 
 			if (sess->local && !local)
 				sess->local = 0;
+
+			qlt_do_generation_tick(vha, &sess->generation);
+
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 			return sess;
@@ -795,6 +810,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	list_add_tail(&sess->sess_list_entry, &vha->vha_tgt.qla_tgt->sess_list);
 	vha->vha_tgt.qla_tgt->sess_count++;
+	qlt_do_generation_tick(vha, &sess->generation);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
@@ -808,7 +824,7 @@ static struct qla_tgt_sess *qlt_create_sess(
 }
 
 /*
- * Called from drivers/scsi/qla2xxx/qla_init.c:qla2x00_reg_remote_port()
+ * Called from qla2x00_reg_remote_port()
  */
 void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
@@ -874,7 +890,12 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 }
 
-void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
+/*
+ * max_gen - specifies maximum session generation
+ * at which this deletion requestion is still valid
+ */
+void
+qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct qla_tgt_sess *sess;
@@ -893,6 +914,15 @@ void qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return;
 	}
 
+	if (max_gen - sess->generation < 0) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf092,
+		    "Ignoring stale deletion request for se_sess %p / sess %p"
+		    " for port %8phC, req_gen %d, sess_gen %d\n",
+		    sess->se_sess, sess, sess->port_name, max_gen,
+		    sess->generation);
+		return;
+	}
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
 
 	sess->local = 1;
@@ -3978,7 +4008,7 @@ void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 {
 	if (fcport->tgt_session) {
 		if (rc != MBS_COMMAND_COMPLETE) {
-			ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf088,
+			ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
 				"%s: se_sess %p / sess %p from"
 				" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
 				" LOGO failed: %#x\n",
@@ -4107,6 +4137,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	struct imm_ntfy_from_isp *iocb)
 {
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	struct qla_hw_data *ha = vha->hw;
 	struct qla_tgt_sess *sess = NULL;
 	uint64_t wwn;
 	port_id_t port_id;
@@ -4152,7 +4183,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			 * without acking, new one will get acked when session
 			 * deletion completes.
 			 */
-			ql_log(ql_log_warn, sess->vha, 0xf089,
+			ql_log(ql_log_warn, sess->vha, 0xf094,
 			    "sess %p received double plogi.\n", sess);
 
 			qlt_swap_imm_ntfy_iocb(iocb, &sess->tm_iocb);
@@ -4209,7 +4240,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 				 * PLOGI could finish. Will force him to re-try,
 				 * while last one finishes.
 				 */
-				ql_log(ql_log_warn, sess->vha, 0xf090,
+				ql_log(ql_log_warn, sess->vha, 0xf095,
 				    "sess %p PRLI received, before plogi ack.\n",
 				    sess);
 				qlt_send_term_imm_notif(vha, iocb, 1);
@@ -4221,7 +4252,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			 * This shouldn't happen under normal circumstances,
 			 * since we have deleted the old session during PLOGI
 			 */
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf091,
+			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf096,
 			    "PRLI (loop_id %#04x) for existing sess %p (loop_id %#04x)\n",
 			    sess->loop_id, sess, iocb->u.isp24.nport_handle);
 
@@ -4232,7 +4263,14 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			if (wd3_lo & BIT_7)
 				sess->conf_compl_supported = 1;
 
-			res = 1;
+		}
+		res = 1; /* send notify ack */
+
+		/* Make session global (not used in fabric mode) */
+		if (ha->current_topology != ISP_CFG_F) {
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
 		} else {
 			/* todo: else - create sess here. */
 			res = 1; /* send notify ack */
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 37c0260..e521fbad 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -919,6 +919,8 @@ struct qla_tgt_sess {
 
 	unsigned char logout_completed;
 
+	int generation;
+
 	struct se_session *se_sess;
 	struct scsi_qla_host *vha;
 	struct qla_tgt *tgt;
@@ -1087,7 +1089,7 @@ extern int qlt_lport_register(void *, u64, u64, u64,
 extern void qlt_lport_deregister(struct scsi_qla_host *);
 extern void qlt_unreg_sess(struct qla_tgt_sess *);
 extern void qlt_fc_port_added(struct scsi_qla_host *, fc_port_t *);
-extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *);
+extern void qlt_fc_port_deleted(struct scsi_qla_host *, fc_port_t *, int);
 extern int __init qlt_init(void);
 extern void qlt_exit(void);
 extern void qlt_update_vp_map(struct scsi_qla_host *, int);
@@ -1164,5 +1166,6 @@ extern irqreturn_t qla83xx_msix_atio_q(int, void *);
 extern void qlt_83xx_iospace_config(struct qla_hw_data *);
 extern int qlt_free_qfull_cmds(struct scsi_qla_host *);
 extern void qlt_logo_completion_handler(fc_port_t *, int);
+extern void qlt_do_generation_tick(struct scsi_qla_host *, int *);
 
 #endif /* __QLA_TARGET_H */
-- 
1.7.7

