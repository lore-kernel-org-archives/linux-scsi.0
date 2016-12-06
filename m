From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 11/22] qla2xxx: Refactor session management code.
Date: Tue, 6 Dec 2016 12:30:40 -0800
Message-ID: <1481056251-2310-12-git-send-email-himanshu.madhani@cavium.com>
References: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1481056251-2310-1-git-send-email-himanshu.madhani@cavium.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com
List-Id: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Current code has 2 structures/codes tracking the same
remote port (fc_port & qla_tgt_sess). Merge these structures
and code under same fc_port.

In target mode, current code does not communicate session
state change to initiator side, Merget target and initiator
mode sessions into same session.

In driver unload path, schedule all session for deletion
and wait for deletion complete before allowing driver unload
to advance.

This patch also refactors unused session deletion in target mode
and does cleanup of dead code.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h     |   3 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |   1 +
 drivers/scsi/qla2xxx/qla_gs.c      |  58 ++-
 drivers/scsi/qla2xxx/qla_init.c    | 159 ++++---
 drivers/scsi/qla2xxx/qla_isr.c     |  43 +-
 drivers/scsi/qla2xxx/qla_os.c      |  46 +-
 drivers/scsi/qla2xxx/qla_target.c  | 905 ++++++++++++++++++++++---------------
 drivers/scsi/qla2xxx/qla_target.h  |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  17 +-
 9 files changed, 762 insertions(+), 474 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index f281f3d..6370aca 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2162,6 +2162,7 @@ enum fcport_mgt_event {
 	unsigned int keep_nport_handle:1;
 	unsigned int send_els_logo:1;
 	unsigned int login_pause:1;
+	unsigned int login_succ:1;
 
 	struct fc_port *conflict;
 	unsigned char logout_completed;
@@ -2254,7 +2255,6 @@ struct event_arg {
 #define FCF_FCP2_DEVICE		BIT_2
 #define FCF_ASYNC_SENT		BIT_3
 #define FCF_CONF_COMP_SUPPORTED BIT_4
-#define FCF_DELETE_DEV		BIT_5
 
 /* No loop ID flag. */
 #define FC_NO_LOOP_ID		0x1000
@@ -4008,6 +4008,7 @@ struct qla_tgt_counters {
 	struct name_list_extended gnl;
 	/* Count of active session/fcport */
 	int fcport_count;
+	wait_queue_head_t fcport_waitQ;
 } scsi_qla_host_t;
 
 struct qla27xx_image_status {
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 94fc7b4..3593a39 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -844,6 +844,7 @@ void qlt_plogi_ack_link(struct scsi_qla_host *, qlt_plogi_ack_t *,
 	struct fc_port *, qlt_plogi_link_t);
 void qlt_plogi_ack_unref(struct scsi_qla_host *, qlt_plogi_ack_t *);
 extern void qlt_schedule_sess_for_deletion(struct fc_port *, bool);
+extern void qlt_schedule_sess_for_deletion_lock(struct fc_port *);
 extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
 void qla24xx_delete_sess_fn(struct work_struct *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d7164da..fa49470 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2777,28 +2777,55 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 				default:
 					if (atomic_read(&fcport->state) == FCS_ONLINE)
 						break;
+
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+						   "%s %d %8phC post gnl\n",
+						   __func__, __LINE__, fcport->port_name);
+
 					qla24xx_post_gnl_work(vha, fcport);
 					break;
 				}
 			} else { /* fcport->d_id.b24 != ea->id.b24 */
 				fcport->d_id.b24 = ea->id.b24;
 
-				if (fcport->deleted == QLA_SESS_DELETED)
-					qlt_schedule_sess_for_deletion(fcport, true);
+				if (fcport->deleted == QLA_SESS_DELETED) {
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+						   "%s %d %8phC post del sess\n",
+						   __func__, __LINE__, fcport->port_name);
+					qlt_schedule_sess_for_deletion_lock(fcport);
+				}
 			}
 		} else { /* ea->sp->gen1 != fcport->rscn_gen */
 			/* rscn came in while cmd was out */
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn\n",
+			   __func__, __LINE__, fcport->port_name);
+
 			qla24xx_post_gidpn_work(vha, fcport);
 		}
 	} else { /* ea->rc */
 		/* cable pulled */
 		if (ea->sp->gen1 == fcport->rscn_gen) {
-			if (ea->sp->gen2 == fcport->login_gen)
-				qlt_schedule_sess_for_deletion(fcport, true);
-			else
+			if (ea->sp->gen2 == fcport->login_gen) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC post del sess\n",
+					   __func__, __LINE__, fcport->port_name);
+
+				qlt_schedule_sess_for_deletion_lock(fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC login\n",
+					   __func__, __LINE__, fcport->port_name);
+
 				qla24xx_fcport_handle_login(vha, fcport);
-		} else
+			}
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn\n",
+			   __func__, __LINE__, fcport->port_name);
+
 			qla24xx_post_gidpn_work(vha, fcport);
+		}
 	}
 } /* gidpn_event */
 
@@ -2836,6 +2863,9 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
+	if (!vha->flags.online)
+		goto done;
+
 	fcport->flags |= FCF_ASYNC_SENT;
 	fcport->disc_state = DSC_GID_PN;
 	fcport->scan_state = QLA_FCPORT_SCAN;
@@ -2995,6 +3025,9 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 	struct ct_sns_req       *ct_req;
 	srb_t *sp;
 
+	if (!vha->flags.online)
+		goto done;
+
 	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
@@ -3090,14 +3123,22 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 	if (fcport) {
 		/* cable moved. just plugged in */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post del sess\n",
+			   __func__, __LINE__, fcport->port_name);
+
 		fcport->rscn_gen++;
 		fcport->d_id = ea->id;
 		fcport->scan_state = QLA_FCPORT_FOUND;
 		fcport->flags |= FCF_FABRIC_DEVICE;
 
-		qlt_schedule_sess_for_deletion(fcport, true);
+		qlt_schedule_sess_for_deletion_lock(fcport);
 	} else {
 		/* create new fcport */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post new sess\n",
+			   __func__, __LINE__, ea->port_name);
+
 		qla24xx_post_newsess_work(vha, &ea->id, ea->port_name, NULL);
 	}
 }
@@ -3163,6 +3204,9 @@ int qla24xx_async_gpnid(scsi_qla_host_t *vha, port_id_t *id)
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 
+	if (!vha->flags.online)
+		goto done;
+
 	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
 	if (!sp)
 		goto done;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 857fa09..cfdfb02 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -187,6 +187,8 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 		goto done;
 
 	fcport->flags |= FCF_ASYNC_SENT;
+	fcport->logout_completed = 0;
+
 	sp->type = SRB_LOGIN_CMD;
 	sp->name = "login";
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
@@ -293,6 +295,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 	int rval;
 
 	rval = QLA_FUNCTION_FAILED;
+	fcport->flags |= FCF_ASYNC_SENT;
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -319,6 +322,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
 done_free_sp:
 	sp->free(fcport->vha, sp);
 done:
+	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
 
@@ -395,7 +399,10 @@ void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		if ((id.b24 != fcport->d_id.b24) ||
 		    ((fcport->loop_id != FC_NO_LOOP_ID) &&
 			(fcport->loop_id != loop_id))) {
-			qlt_schedule_sess_for_deletion(fcport, true);
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post del sess\n",
+			   __func__, __LINE__, fcport->port_name);
+			qlt_schedule_sess_for_deletion(fcport, 1);
 			return;
 		}
 
@@ -415,7 +422,16 @@ void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		}
 
 		switch (e->current_login_state) {
+		case DSC_LS_PRLI_COMP:
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb\n",
+			   __func__, __LINE__, fcport->port_name);
+			opt = PDO_FORCE_ADISC;
+			qla24xx_post_gpdb_work(vha, fcport, opt);
+			break;
+
 		case DSC_LS_PORT_UNAVAIL:
+		default:
 			if (fcport->loop_id == FC_NO_LOOP_ID) {
 				qla2x00_find_new_loop_id(vha, fcport);
 				fcport->fw_login_state = DSC_LS_PORT_UNAVAIL;
@@ -425,16 +441,6 @@ void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 			   __func__, __LINE__, fcport->port_name);
 			qla24xx_fcport_handle_login(vha, fcport);
 			break;
-
-		case DSC_LS_PRLI_COMP:
-			ql_dbg(ql_dbg_disc, vha, 0xffff,
-			   "%s %d %8phC post gpdb\n",
-			   __func__, __LINE__, fcport->port_name);
-			opt = PDO_FORCE_ADISC;
-			qla24xx_post_gpdb_work(vha, fcport, opt);
-			break;
-		default:
-			break;
 		}
 	}
 
@@ -456,8 +462,13 @@ void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 					conflict_fcport =
 					    qla2x00_find_fcport_by_wwpn(vha,
 						e->port_name, 0);
+
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    conflict_fcport->port_name);
 					qlt_schedule_sess_for_deletion
-						(conflict_fcport, true);
+						(conflict_fcport, 1);
 				}
 
 				if (fcport->loop_id == loop_id) {
@@ -623,7 +634,7 @@ int qla24xx_post_gnl_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return qla2x00_post_work(vha, e);
 }
 
-
+static
 void qla24xx_async_gpdb_sp_done(void *v, void *s, int res)
 {
 	struct scsi_qla_host *vha = (struct scsi_qla_host *)v;
@@ -792,7 +803,7 @@ int qla24xx_async_gpdb(struct scsi_qla_host *vha, fc_port_t *fcport, u8 opt)
 	return rval;
 }
 
-
+static
 void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
 	int rval = ea->rc;
@@ -815,36 +826,50 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		    fcport->last_login_gen, fcport->login_gen);
 		return;
 	} else if (ea->sp->gen1 != fcport->rscn_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn\n",
+			   __func__, __LINE__, fcport->port_name);
+
 		qla24xx_post_gidpn_work(vha, fcport);
 		return;
 	}
 
 	if (rval != QLA_SUCCESS) {
-		qlt_schedule_sess_for_deletion(fcport, true);
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post del sess\n",
+			   __func__, __LINE__, fcport->port_name);
+
+		qlt_schedule_sess_for_deletion_lock(fcport);
 		return;
 	}
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	ea->fcport->login_gen++;
 	ea->fcport->deleted = 0;
-	vha->fcport_count++;
 	ea->fcport->logout_on_delete = 1;
-	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
-	if (!IS_IIDMA_CAPABLE(vha->hw) || !vha->hw->flags.gpsc_supported) {
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-			"%s %d %8phC post upd_fcport fcp_cnt %d\n",
-			__func__, __LINE__, fcport->port_name,
-			vha->fcport_count);
+	if (!ea->fcport->login_succ && !IS_SW_RESV_ADDR(ea->fcport->d_id)) {
+		vha->fcport_count++;
+		ea->fcport->login_succ = 1;
 
-		qla24xx_post_upd_fcport_work(vha, fcport);
-	} else {
-		ql_dbg(ql_dbg_disc, vha, 0xffff,
-		    "%s %d %8phC post gpsc fcp_cnt %d\n",
-		    __func__, __LINE__, fcport->port_name, vha->fcport_count);
+		if (!IS_IIDMA_CAPABLE(vha->hw) ||
+		    !vha->hw->flags.gpsc_supported) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post upd_fcport fcp_cnt %d\n",
+			    __func__, __LINE__, fcport->port_name,
+			    vha->fcport_count);
 
-		qla24xx_post_gpsc_work(vha, fcport);
+			qla24xx_post_upd_fcport_work(vha, fcport);
+		} else {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "%s %d %8phC post gpsc fcp_cnt %d\n",
+			    __func__, __LINE__, fcport->port_name,
+			    vha->fcport_count);
+
+			qla24xx_post_gpsc_work(vha, fcport);
+		}
 	}
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 } /* gpdb event */
 
 
@@ -927,7 +952,24 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		}
 
 		break;
-	case DSC_LOGIN_PEND:
+
+	case DSC_LOGIN_FAILED:
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn \n",
+			   __func__, __LINE__, fcport->port_name);
+
+		qla24xx_post_gidpn_work(vha, fcport);
+		break;
+
+	case DSC_LOGIN_COMPLETE:
+		/* recheck login state */
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gpdb \n",
+			   __func__, __LINE__, fcport->port_name);
+
+		qla24xx_post_gpdb_work(vha, fcport, PDO_FORCE_ADISC);
+		break;
+
 	default:
 		break;
 	}
@@ -935,7 +977,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	return 0;
 }
 
-
+static
 void qla24xx_handle_rscn_event(fc_port_t *fcport, struct event_arg *ea)
 {
 	fcport->rscn_gen++;
@@ -974,6 +1016,7 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *vha, port_id_t *id,
 	return qla2x00_post_work(vha, e);
 }
 
+static
 int qla24xx_handle_delete_done_event(scsi_qla_host_t *vha,
 	struct event_arg *ea)
 {
@@ -998,7 +1041,7 @@ int qla24xx_handle_delete_done_event(scsi_qla_host_t *vha,
 	return 0;
 }
 
-
+static
 void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	struct event_arg *ea)
 {
@@ -1035,13 +1078,14 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	}
 
 	if (fcport->last_rscn_gen != fcport->rscn_gen) {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+			   "%s %d %8phC post gidpn\n",
+			   __func__, __LINE__, fcport->port_name);
 		qla24xx_async_gidpn(vha, fcport);
-	} else {
-		if (fcport->deleted)
-			qla24xx_fcport_handle_login(vha, fcport);
-		else
-			qlt_schedule_sess_for_deletion(fcport, true);
+		return;
 	}
+
+	qla24xx_fcport_handle_login(vha, fcport);
 }
 
 void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
@@ -1050,9 +1094,6 @@ void qla2x00_fcport_event_handler (scsi_qla_host_t *vha,
 	fc_port_t *fcport;
 	int rc;
 
-	if (ea->fcport && (ea->fcport->chip_reset != vha->hw->chip_reset))
-		qlt_schedule_sess_for_deletion(ea->fcport, true);
-
 
 	switch (ea->event) {
 	case FCME_RELOGIN:
@@ -3813,8 +3854,14 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	rport = fcport->drport ? fcport->drport: fcport->rport;
 	fcport->drport = NULL;
 	spin_unlock_irqrestore(fcport->vha->host->host_lock, flags);
-	if (rport)
+	if (rport) {
+		ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+			"%s %8phN. rport %p roles %x \n",
+			__func__, fcport->port_name, rport,
+			rport->roles);
+
 		fc_remote_port_delete(rport);
+	}
 }
 
 /**
@@ -4244,6 +4291,12 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_INITIATOR;
 	if (fcport->port_type == FCT_TARGET)
 		rport_ids.roles |= FC_RPORT_ROLE_FCP_TARGET;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		"%s %8phN. rport %p is %s mode \n",
+		__func__, fcport->port_name, rport,
+		(fcport->port_type == FCT_TARGET) ? "tgt" : "ini");
+
 	fc_remote_port_rolechg(rport, rport_ids.roles);
 }
 
@@ -4643,15 +4696,6 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 
 			fcport->d_id.b24 = new_fcport->d_id.b24;
 			fcport->flags |= FCF_LOGIN_NEEDED;
-			if (fcport->loop_id != FC_NO_LOOP_ID &&
-			    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
-			    (fcport->flags & FCF_ASYNC_SENT) == 0 &&
-			    fcport->port_type != FCT_INITIATOR &&
-			    fcport->port_type != FCT_BROADCAST) {
-				/* cable moved */
-				fcport->flags |= FCF_DELETE_DEV;
-			}
-
 			break;
 		}
 
@@ -4702,21 +4746,18 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
 				    fcport->port_type != FCT_INITIATOR &&
 				    fcport->port_type != FCT_BROADCAST) {
-					/* cable disconnected */
-					qlt_schedule_sess_for_deletion(fcport,
-					    true);
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    fcport->port_name);
+
+					qlt_schedule_sess_for_deletion_lock
+						(fcport);
 					continue;
 				}
 			}
 		}
 
-		if (fcport->flags & FCF_DELETE_DEV) {
-			/* cable move detected */
-			fcport->flags &= ~FCF_DELETE_DEV;
-			qlt_schedule_sess_for_deletion(fcport, true);
-			continue;
-		}
-
 		if (fcport->scan_state == QLA_FCPORT_FOUND)
 			qla24xx_fcport_handle_login(vha, fcport);
 	}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c5a1ce4..7a7a8c6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -974,7 +974,11 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 			ql_dbg(ql_dbg_async, vha, 0x508a,
 			    "Marking port lost loopid=%04x portid=%06x.\n",
 			    fcport->loop_id, fcport->d_id.b24);
-			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			if (qla_ini_mode_enabled(vha)) {
+				qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+				fcport->logout_on_delete = 0;
+				qlt_schedule_sess_for_deletion_lock(fcport);
+			}
 			break;
 
 global_port_update:
@@ -1064,19 +1068,6 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 		if (qla2x00_is_a_vp_did(vha, rscn_entry))
 			break;
 
-		/*
-		 * Search for the rport related to this RSCN entry and mark it
-		 * as lost.
-		 */
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			if (atomic_read(&fcport->state) != FCS_ONLINE)
-				continue;
-			if (fcport->d_id.b24 == rscn_entry) {
-				qla2x00_mark_device_lost(vha, fcport, 0, 0);
-				break;
-			}
-		}
-
 		atomic_set(&vha->loop_down_timer, 0);
 		vha->flags.management_server_logged_in = 0;
 		{
@@ -1279,7 +1270,8 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 	index = LSW(pkt->handle);
 	if (index >= req->num_outstanding_cmds) {
 		ql_log(ql_log_warn, vha, 0x5031,
-		    "Invalid command index (%x).\n", index);
+			   "Invalid command index (%x) type %8ph.\n",
+			   index, iocb);
 		if (IS_P3P_TYPE(ha))
 			set_bit(FCOE_CTX_RESET_NEEDED, &vha->dpc_flags);
 		else
@@ -2194,6 +2186,7 @@ struct scsi_dif_tuple {
 	int res = 0;
 	uint16_t state_flags = 0;
 	uint16_t retry_delay = 0;
+	uint8_t no_logout = 0;
 
 	sts = (sts_entry_t *) pkt;
 	sts24 = (struct sts_entry_24xx *) pkt;
@@ -2454,6 +2447,7 @@ struct scsi_dif_tuple {
 		break;
 
 	case CS_PORT_LOGGED_OUT:
+		no_logout = 1;
 	case CS_PORT_CONFIG_CHG:
 	case CS_PORT_BUSY:
 	case CS_INCOMPLETE:
@@ -2476,14 +2470,21 @@ struct scsi_dif_tuple {
 				break;
 		}
 
-		ql_dbg(ql_dbg_io, fcport->vha, 0x3021,
-		    "Port to be marked lost on fcport=%02x%02x%02x, current "
-		    "port state= %s.\n", fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
-		    port_state_str[atomic_read(&fcport->state)]);
+		if (atomic_read(&fcport->state) == FCS_ONLINE) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
+				"Port to be marked lost on fcport=%02x%02x%02x, current "
+				"port state= %s comp_status %x.\n", fcport->d_id.b.domain,
+				fcport->d_id.b.area, fcport->d_id.b.al_pa,
+				port_state_str[atomic_read(&fcport->state)],
+				comp_status);
+
+			if (no_logout)
+				fcport->logout_on_delete = 0;
 
-		if (atomic_read(&fcport->state) == FCS_ONLINE)
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
+			qlt_schedule_sess_for_deletion_lock(fcport);
+		}
+
 		break;
 
 	case CS_ABORTED:
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 133d92a..4be58b0 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1040,6 +1040,34 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	return (return_status);
 }
 
+
+static inline int test_fcport_count(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
+	int res;
+
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	ql_dbg(ql_dbg_init, vha, 0xffff,
+		"tgt %p, fcport_count=%d\n",
+		vha, vha->fcport_count);
+	res = (vha->fcport_count == 0);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+	return res;
+}
+
+/* qla2x00_wait_for_sess_deletion can only be called from remove_one.
+ * it has dependency on UNLOADING flag to stop device discovery
+ */
+static void
+qla2x00_wait_for_sess_deletion(scsi_qla_host_t *vha)
+{
+	qla2x00_mark_all_devices_lost(vha, 0);
+
+	wait_event(vha->fcport_waitQ, test_fcport_count(vha));
+}
+
 /*
  * qla2x00_wait_for_hba_ready
  * Wait till the HBA is ready before doing driver unload
@@ -3414,12 +3442,15 @@ static void qla2x00_destroy_mbx_wq(struct qla_hw_data *ha)
 
 	qla2x00_wait_for_hba_ready(base_vha);
 
-	/* if UNLOAD flag is already set, then continue unload,
+	/*
+	 * if UNLOAD flag is already set, then continue unload,
 	 * where it was set first.
 	 */
 	if (test_bit(UNLOADING, &base_vha->dpc_flags))
 		return;
 
+	qla2x00_wait_for_sess_deletion(base_vha);
+
 	set_bit(UNLOADING, &base_vha->dpc_flags);
 
 
@@ -3578,8 +3609,13 @@ void qla2x00_free_fcports(struct scsi_qla_host *vha)
 		qla2xxx_wake_dpc(base_vha);
 	} else {
 		int now;
-		if (rport)
+		if (rport) {
+			ql_dbg(ql_dbg_disc, fcport->vha, 0xffff,
+				"%s %8phN. rport %p roles %x \n",
+				__func__, fcport->port_name, rport,
+				rport->roles);
 			fc_remote_port_delete(rport);
+		}
 		qlt_do_generation_tick(vha, &now);
 	}
 }
@@ -3646,9 +3682,12 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 {
 	fc_port_t *fcport;
 
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+		   "Mark all dev lost\n");
+
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		fcport->scan_state = 0;
-		qlt_schedule_sess_for_deletion(fcport, 1);
+		qlt_schedule_sess_for_deletion_lock(fcport);
 
 		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
 			continue;
@@ -4271,6 +4310,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
+	init_waitqueue_head(&vha->fcport_waitQ);
 
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index b5c20362..cd7494f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -399,6 +399,23 @@ void qlt_response_pkt_all_vps(struct scsi_qla_host *vha, response_t *pkt)
 
 }
 
+/*
+ * All qlt_plogi_ack_t operations are protected by hardware_lock
+ */
+static int qla24xx_post_nack_work(struct scsi_qla_host *vha, fc_port_t *fcport,
+	struct imm_ntfy_from_isp *ntfy, int type)
+{
+	struct qla_work_evt *e;
+	e = qla2x00_alloc_work(vha, QLA_EVT_NACK);
+	if (!e)
+		return QLA_FUNCTION_FAILED;
+
+	e->u.nack.fcport = fcport;
+	e->u.nack.type = type;
+	memcpy(e->u.nack.iocb, ntfy, IOCB_SIZE);
+	return qla2x00_post_work(vha, e);
+}
+
 static
 void qla2x00_async_nack_sp_done(void *v, void *s, int res)
 {
@@ -412,17 +429,44 @@ void qla2x00_async_nack_sp_done(void *v, void *s, int res)
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	sp->fcport->flags &= ~FCF_ASYNC_SENT;
+	sp->fcport->chip_reset = vha->hw->chip_reset;
 
 	switch (sp->type) {
 	case SRB_NACK_PLOGI:
 		sp->fcport->login_gen++;
 		sp->fcport->fw_login_state = DSC_LS_PLOGI_COMP;
+		sp->fcport->logout_on_delete = 1;
 		break;
 
 	case SRB_NACK_PRLI:
 		sp->fcport->fw_login_state = DSC_LS_PRLI_COMP;
 		sp->fcport->deleted = 0;
-		vha->fcport_count++;
+
+		if (!sp->fcport->login_succ &&
+		    !IS_SW_RESV_ADDR(sp->fcport->d_id)) {
+			sp->fcport->login_succ = 1;
+
+			vha->fcport_count++;
+
+			if (!IS_IIDMA_CAPABLE(vha->hw) ||
+			    !vha->hw->flags.gpsc_supported) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					"%s %d %8phC post upd_fcport fcp_cnt %d\n",
+					__func__, __LINE__,
+					sp->fcport->port_name,
+					vha->fcport_count);
+
+				qla24xx_post_upd_fcport_work(vha, sp->fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					"%s %d %8phC post gpsc fcp_cnt %d\n",
+					__func__, __LINE__,
+					sp->fcport->port_name,
+					vha->fcport_count);
+
+				qla24xx_post_gpsc_work(vha, sp->fcport);
+			}
+		}
 		break;
 
 	case SRB_NACK_LOGO:
@@ -530,73 +574,76 @@ void qla24xx_delete_sess_fn(struct work_struct *work)
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
-
 /*
  * Called from qla2x00_reg_remote_port()
  */
 void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
-	struct qla_hw_data *ha = vha->hw;
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct fc_port *sess = fcport;
-	unsigned long flags;
-
-	if (!vha->hw->tgt.tgt_ops)
-		return;
-
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-		return;
-	}
-
-	if (fcport->disc_state == DSC_DELETE_PEND) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-		return;
-	}
-
-	if (!sess->se_sess) {
-		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-		mutex_lock(&vha->vha_tgt.tgt_mutex);
-		sess = qlt_create_sess(vha, fcport, false);
-		mutex_unlock(&vha->vha_tgt.tgt_mutex);
-
-		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	} else {
-		if (fcport->fw_login_state == DSC_LS_PRLI_COMP) {
+	 struct qla_hw_data *ha = vha->hw;
+	 struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	 struct fc_port *sess = fcport;
+	 unsigned long flags;
+
+	 if (!vha->hw->tgt.tgt_ops)
+		 return;
+
+	 spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	 if (tgt->tgt_stop) {
+		 spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		 return;
+	 }
+
+	 if (fcport->disc_state == DSC_DELETE_PEND) {
+		 spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+		 return;
+	 }
+
+	 if (!sess->se_sess) {
+		 spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+		 mutex_lock(&vha->vha_tgt.tgt_mutex);
+		 sess = qlt_create_sess(vha, fcport, false);
+		 mutex_unlock(&vha->vha_tgt.tgt_mutex);
+
+		 spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	 } else {
+		 if (fcport->fw_login_state == DSC_LS_PRLI_COMP) {
+			 spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+			 return;
+		 }
+
+		if (!ha->tgt.tgt_ops->get_sess(sess)) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s: kref_get fail sess %8phC \n",
+				   __func__, sess->port_name);
 			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 			return;
 		}
 
-		ha->tgt.tgt_ops->get_sess(sess);
-
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
-			   "qla_target(%u): %ssession for port %8phC "
-			   "(loop ID %d) reappeared\n", vha->vp_idx,
-			   sess->local ? "local " : "", sess->port_name,
-			   sess->loop_id);
+		 ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
+		     "qla_target(%u): %ssession for port %8phC "
+		     "(loop ID %d) reappeared\n", vha->vp_idx,
+		     sess->local ? "local " : "", sess->port_name,
+		     sess->loop_id);
 
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
-			   "Reappeared sess %p\n", sess);
+		 ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
+		     "Reappeared sess %p\n", sess);
 
-		ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
-					(fcport->flags & FCF_CONF_COMP_SUPPORTED));
-	}
+		 ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
+		     (fcport->flags & FCF_CONF_COMP_SUPPORTED));
+	 }
 
-	if (sess && sess->local) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
-		    "qla_target(%u): local session for "
-		    "port %8phC (loop ID %d) became global\n", vha->vp_idx,
-		    fcport->port_name, sess->loop_id);
-		sess->local = 0;
-	}
-	ha->tgt.tgt_ops->put_sess(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+	 if (sess && sess->local) {
+		 ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
+		     "qla_target(%u): local session for "
+		     "port %8phC (loop ID %d) became global\n", vha->vp_idx,
+		     fcport->port_name, sess->loop_id);
+		 sess->local = 0;
+	 }
+	 ha->tgt.tgt_ops->put_sess(sess);
+	 spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
-
 /*
  * This is a zero-base ref-counting solution, since hardware_lock
  * guarantees that ref_count is not modified concurrently.
@@ -635,20 +682,41 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 {
 	struct imm_ntfy_from_isp *iocb = (struct imm_ntfy_from_isp *)&pla->iocb;
+	port_id_t port_id;
+	uint16_t loop_id;
+	fc_port_t *fcport = pla->fcport;
+
 	BUG_ON(!pla->ref_count);
 	pla->ref_count--;
 
 	if (pla->ref_count)
 		return;
 
-	ql_dbg(ql_dbg_async, vha, 0x5089,
+	ql_dbg(ql_dbg_disc, vha, 0x5089,
 	    "Sending PLOGI ACK to wwn %8phC s_id %02x:%02x:%02x loop_id %#04x"
 	    " exch %#x ox_id %#x\n", iocb->u.isp24.port_name,
 	    iocb->u.isp24.port_id[2], iocb->u.isp24.port_id[1],
 	    iocb->u.isp24.port_id[0],
 	    le16_to_cpu(iocb->u.isp24.nport_handle),
 	    iocb->u.isp24.exchange_address, iocb->ox_id);
-	qlt_send_notify_ack(vha, iocb, 0, 0, 0, 0, 0, 0);
+
+	port_id.b.domain = iocb->u.isp24.port_id[2];
+	port_id.b.area   = iocb->u.isp24.port_id[1];
+	port_id.b.al_pa  = iocb->u.isp24.port_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
+
+	fcport->loop_id = loop_id;
+	fcport->d_id = port_id;
+	qla24xx_post_nack_work(vha, fcport, iocb, SRB_NACK_PLOGI);
+
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (fcport->plogi_link[QLT_PLOGI_LINK_SAME_WWN] == pla)
+			fcport->plogi_link[QLT_PLOGI_LINK_SAME_WWN] = NULL;
+		if (fcport->plogi_link[QLT_PLOGI_LINK_CONFLICT] == pla)
+			fcport->plogi_link[QLT_PLOGI_LINK_CONFLICT] = NULL;
+	}
 
 	list_del(&pla->list);
 	kmem_cache_free(qla_tgt_plogi_cachep, pla);
@@ -662,15 +730,19 @@ void qlt_plogi_ack_unref(struct scsi_qla_host *vha, qlt_plogi_ack_t *pla)
 	/* Inc ref_count first because link might already be pointing at pla */
 	pla->ref_count++;
 
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
+		"Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
+		" s_id %02x:%02x:%02x, ref=%d pla %p link %d\n",
+		sess, link, sess->port_name,
+		iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
+		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
+		pla->ref_count, pla, link);
+
 	if (sess->plogi_link[link])
 		qlt_plogi_ack_unref(vha, sess->plogi_link[link]);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf097,
-	    "Linking sess %p [%d] wwn %8phC with PLOGI ACK to wwn %8phC"
-	    " s_id %02x:%02x:%02x, ref=%d\n", sess, link, sess->port_name,
-	    iocb->u.isp24.port_name, iocb->u.isp24.port_id[2],
-	    iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
-	    pla->ref_count);
+	if (link == QLT_PLOGI_LINK_SAME_WWN)
+		pla->fcport = sess;
 
 	sess->plogi_link[link] = pla;
 }
@@ -730,7 +802,7 @@ static void qlt_free_session_done(struct work_struct *work)
 	struct qla_hw_data *ha = vha->hw;
 	unsigned long flags;
 	bool logout_started = false;
-	fc_port_t fcport;
+	struct event_arg ea;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
@@ -740,8 +812,8 @@ static void qlt_free_session_done(struct work_struct *work)
 		sess->logout_on_delete, sess->keep_nport_handle,
 		sess->send_els_logo);
 
-	BUG_ON(!tgt);
 
+	if (!IS_SW_RESV_ADDR(sess->d_id)) {
 	if (sess->send_els_logo) {
 		qlt_port_logo_t logo;
 		logo.id = sess->d_id;
@@ -751,20 +823,19 @@ static void qlt_free_session_done(struct work_struct *work)
 
 	if (sess->logout_on_delete) {
 		int rc;
-
-		memset(&fcport, 0, sizeof(fcport));
-		fcport.loop_id = sess->loop_id;
-		fcport.d_id = sess->d_id;
-		memcpy(fcport.port_name, sess->port_name, WWN_SIZE);
-		fcport.vha = vha;
-
-		rc = qla2x00_post_async_logout_work(vha, &fcport, NULL);
+		rc = qla2x00_post_async_logout_work(vha, sess, NULL);
 		if (rc != QLA_SUCCESS)
 			ql_log(ql_log_warn, vha, 0xf085,
 			       "Schedule logo failed sess %p rc %d\n",
 			       sess, rc);
 		else
 			logout_started = true;
+	} else if (sess->logo_ack_needed) {
+		sess->logo_ack_needed = 0;
+		qla24xx_async_notify_ack(vha, sess,
+			(struct imm_ntfy_from_isp *)sess->iocb, SRB_NACK_LOGO);
+		logout_started = true;
+	}
 	}
 
 	/*
@@ -786,12 +857,36 @@ static void qlt_free_session_done(struct work_struct *work)
 			msleep(100);
 		}
 
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf087,
+		ql_dbg(ql_dbg_disc, vha, 0xf087,
 			"%s: sess %p logout completed\n",
 			__func__, sess);
 	}
 
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	if (sess->se_sess) {
+		sess->se_sess = NULL;
+		if (tgt && !IS_SW_RESV_ADDR(sess->d_id))
+			tgt->sess_count--;
+	}
+	sess->disc_state = DSC_DELETED;
+	sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
+	sess->deleted = QLA_SESS_DELETED;
+	sess->login_retry = vha->hw->login_retry_count;
+	if (sess->login_succ && !IS_SW_RESV_ADDR(sess->d_id)) {
+		vha->fcport_count--;
+		sess->login_succ = 0;
+	}
+
+	if (sess->chip_reset != sess->vha->hw->chip_reset)
+		qla2x00_clear_loop_id(sess);
+
+
+	if (sess->conflict) {
+		sess->conflict->login_pause = 0;
+		sess->conflict = NULL;
+		if (!test_bit(UNLOADING, &vha->dpc_flags))
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+	}
 
 	{
 		qlt_plogi_ack_t *own = sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
@@ -807,33 +902,46 @@ static void qlt_free_session_done(struct work_struct *work)
 				 own ? own->ref_count : -1,
 				 iocb->u.isp24.port_name, con->ref_count);
 			qlt_plogi_ack_unref(vha, con);
+			sess->plogi_link[QLT_PLOGI_LINK_CONFLICT] = NULL;
 		} else {
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09a,
-			    "se_sess %p / sess %p port %8phC is gone, %s (ref=%d)\n",
-			    sess->se_sess, sess, sess->port_name,
-			    own ? "releasing own PLOGI" :
-			    "no own PLOGI pending",
-			    own ? own->ref_count : -1);
+				 "se_sess %p / sess %p port %8phC is gone, %s (ref=%d)\n",
+				 sess->se_sess, sess, sess->port_name,
+				 own ? "releasing own PLOGI" : "no own PLOGI pending",
+				 own ? own->ref_count : -1);
 		}
 
-		if (own)
+		if (own) {
+			sess->fw_login_state = DSC_LS_PLOGI_PEND;
 			qlt_plogi_ack_unref(vha, own);
+			sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] = NULL;
+		}
 	}
 
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	sess->se_sess = NULL;
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
+
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf001,
-	    "Unregistration of sess %p finished\n", sess);
+	    "Unregistration of sess %p %8phC finished fcp_cnt %d\n",
+		sess, sess->port_name, vha->fcport_count);
 
 	/*
 	 * We need to protect against race, when tgt is freed before or
 	 * inside wake_up()
 	 */
-	tgt->sess_count--;
-	if (tgt->sess_count == 0)
+
+	if (tgt && (tgt->sess_count == 0))
 		wake_up_all(&tgt->waitQ);
+
+	if (vha->fcport_count == 0)
+		wake_up_all(&vha->fcport_waitQ);
+
+	if (!tgt || !tgt->tgt_stop) {
+		memset(&ea, 0, sizeof(ea));
+		ea.event = FCME_DELETE_DONE;
+		ea.fcport = sess;
+		qla2x00_fcport_event_handler(vha, &ea);
+	}
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -899,48 +1007,59 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 	    iocb, QLA24XX_MGMT_SEND_NACK);
 }
 
+static void qla24xx_chk_fcp_state(struct fc_port *sess)
+{
+	if (sess->chip_reset != sess->vha->hw->chip_reset) {
+		sess->logout_on_delete = 0;
+		sess->logo_ack_needed = 0;
+		sess->fw_login_state = DSC_LS_PORT_UNAVAIL;
+		sess->scan_state = 0;
+	}
+}
+
+
 /* ha->tgt.sess_lock supposed to be held on entry */
 void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	bool immediate)
 {
 	struct qla_tgt *tgt = sess->tgt;
-	uint32_t dev_loss_tmo = tgt->ha->port_down_retry_count + 5;
 
-	if (sess->deleted) {
-		/* Upgrade to unconditional deletion in case it was temporary */
-		if (immediate && sess->deleted == QLA_SESS_DELETION_PENDING)
-			list_del(&sess->del_list_entry);
-		else
+	if (sess->disc_state == DSC_DELETE_PEND)
+		return;
+
+	if (sess->disc_state == DSC_DELETED) {
+		if (tgt && tgt->tgt_stop && (tgt->sess_count == 0))
+			wake_up_all(&tgt->waitQ);
+		if (sess->vha->fcport_count == 0)
+			wake_up_all(&sess->vha->fcport_waitQ);
+
+		if (!sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN] &&
+			!sess->plogi_link[QLT_PLOGI_LINK_CONFLICT])
 			return;
 	}
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
-	    "Scheduling sess %p for deletion\n", sess);
+	sess->disc_state = DSC_DELETE_PEND;
 
-	if (immediate) {
-		dev_loss_tmo = 0;
-		sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-		list_add(&sess->del_list_entry, &tgt->del_sess_list);
-	} else {
-		sess->deleted = QLA_SESS_DELETION_PENDING;
-		list_add_tail(&sess->del_list_entry, &tgt->del_sess_list);
-	}
+	if (sess->deleted == QLA_SESS_DELETED)
+		sess->logout_on_delete = 0;
 
-	sess->expires = jiffies + dev_loss_tmo * HZ;
+	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
+	qla24xx_chk_fcp_state(sess);
 
-	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
-	    "qla_target(%d): session for port %8phC (loop ID %d s_id %02x:%02x:%02x)"
-	    " scheduled for deletion in %u secs (expires: %lu) immed: %d, logout: %d, gen: %#x\n",
-	    sess->vha->vp_idx, sess->port_name, sess->loop_id,
-	    sess->d_id.b.domain, sess->d_id.b.area, sess->d_id.b.al_pa,
-	    dev_loss_tmo, sess->expires, immediate, sess->logout_on_delete,
-	    sess->generation);
+	ql_dbg(ql_dbg_disc, sess->vha, 0xe001,
+	    "Scheduling sess %p for deletion %8phC\n",
+		sess, sess->port_name);
 
-	if (immediate)
-		mod_delayed_work(system_wq, &tgt->sess_del_work, 0);
-	else
-		schedule_delayed_work(&tgt->sess_del_work,
-		    sess->expires - jiffies);
+	schedule_work(&sess->del_work);
+}
+
+void qlt_schedule_sess_for_deletion_lock(struct fc_port *sess)
+{
+	unsigned long flags;
+	struct qla_hw_data *ha = sess->vha->hw;
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	qlt_schedule_sess_for_deletion(sess, 1);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 }
 
 /* ha->tgt.sess_lock supposed to be held on entry */
@@ -951,7 +1070,7 @@ static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 
 	list_for_each_entry(sess, &vha->vp_fcports, list) {
 		if (sess->se_sess)
-			qlt_schedule_sess_for_deletion(sess, true);
+			qlt_schedule_sess_for_deletion(sess, 1);
 	}
 
 	/* At this point tgt could be already dead */
@@ -1006,49 +1125,6 @@ static int qla24xx_get_loop_id(struct scsi_qla_host *vha, const uint8_t *s_id,
 	return res;
 }
 
-/* ha->tgt.sess_lock supposed to be held on entry */
-static void qlt_undelete_sess(struct fc_port *sess)
-{
-	BUG_ON(sess->deleted != QLA_SESS_DELETION_PENDING);
-
-	list_del_init(&sess->del_list_entry);
-	sess->deleted = 0;
-}
-
-static void qlt_del_sess_work_fn(struct delayed_work *work)
-{
-	struct qla_tgt *tgt = container_of(work, struct qla_tgt,
-	    sess_del_work);
-	struct scsi_qla_host *vha = tgt->vha;
-	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess;
-	unsigned long flags, elapsed;
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	while (!list_empty(&tgt->del_sess_list)) {
-		sess = list_entry(tgt->del_sess_list.next, typeof(*sess),
-		    del_list_entry);
-		elapsed = jiffies;
-		if (time_after_eq(elapsed, sess->expires)) {
-			/* No turning back */
-			list_del_init(&sess->del_list_entry);
-			sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
-
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
-			    "Timeout: sess %p about to be deleted\n",
-			    sess);
-			if (sess->se_sess)
-				ha->tgt.tgt_ops->shutdown_sess(sess);
-			ha->tgt.tgt_ops->put_sess(sess);
-		} else {
-			schedule_delayed_work(&tgt->sess_del_work,
-			    sess->expires - elapsed);
-			break;
-		}
-	}
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-}
-
 /*
  * Adds an extra ref to allow to drop hw lock after adding sess to the list.
  * Caller must put it.
@@ -1059,73 +1135,23 @@ static struct fc_port *qlt_create_sess(
 	bool local)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct fc_port *sess;
+	struct fc_port *sess = fcport;
 	unsigned long flags;
+	unsigned char be_sid[3];
 
-	/* Check to avoid double sessions */
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_for_each_entry(sess, &vha->vp_fcports, list) {
-		if (!memcmp(sess->port_name, fcport->port_name, WWN_SIZE)) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf005,
-			    "Double sess %p found (s_id %x:%x:%x, "
-			    "loop_id %d), updating to d_id %x:%x:%x, "
-			    "loop_id %d", sess, sess->d_id.b.domain,
-			    sess->d_id.b.al_pa, sess->d_id.b.area,
-			    sess->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.al_pa, fcport->d_id.b.area,
-			    fcport->loop_id);
-
-			/* Cannot undelete at this point */
-			if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
-				spin_unlock_irqrestore(&ha->tgt.sess_lock,
-				    flags);
-				return NULL;
-			}
-
-			if (sess->deleted)
-				qlt_undelete_sess(sess);
-
-			if (!sess->se_sess) {
-				if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
-				    &sess->port_name[0], sess) < 0) {
-					spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-					return NULL;
-				}
-			}
-
-			ha->tgt.tgt_ops->get_sess(sess);
-
-			ha->tgt.tgt_ops->update_sess(sess, fcport->d_id, fcport->loop_id,
-						(fcport->flags & FCF_CONF_COMP_SUPPORTED));
-
-			if (sess->local && !local)
-				sess->local = 0;
-
-			qlt_do_generation_tick(vha, &sess->generation);
-
-			spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-			return sess;
+	if (fcport->se_sess) {
+		if (!ha->tgt.tgt_ops->get_sess(sess)) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				"%s: kref_get fail sess %8phC \n",
+				__func__, sess->port_name);
+			return NULL;
 		}
+		return fcport;
 	}
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
-	if (!sess) {
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04a,
-		    "qla_target(%u): session allocation failed, all commands "
-		    "from port %8phC will be refused", vha->vp_idx,
-		    fcport->port_name);
 
-		return NULL;
-	}
 	sess->tgt = vha->vha_tgt.qla_tgt;
-	sess->vha = vha;
-	sess->d_id = fcport->d_id;
-	sess->loop_id = fcport->loop_id;
 	sess->local = local;
 	kref_init(&sess->sess_kref);
-	INIT_LIST_HEAD(&sess->del_list_entry);
 
 	/* Under normal circumstances we want to logout from firmware when
 	 * session eventually ends and release corresponding nport handle.
@@ -1133,28 +1159,10 @@ static struct fc_port *qlt_create_sess(
 	 * code will adjust these flags as necessary. */
 	sess->logout_on_delete = 1;
 	sess->keep_nport_handle = 0;
-	memcpy(sess->port_name, fcport->port_name, sizeof(sess->port_name));
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
-	    "Adding sess %p to tgt %p via ->check_initiator_node_acl()\n",
-	    sess, vha->vha_tgt.qla_tgt);
-
-	sess->conf_compl_supported = (fcport->flags & FCF_CONF_COMP_SUPPORTED);
-	BUILD_BUG_ON(sizeof(sess->port_name) != sizeof(fcport->port_name));
-
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	list_add_tail(&sess->list, &vha->vp_fcports);
-
-	vha->vha_tgt.qla_tgt->sess_count++;
-	qlt_do_generation_tick(vha, &sess->generation);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
-	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
-	    "s_id %x:%x:%x, confirmed completion %ssupported) added\n",
-	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
-	    fcport->loop_id, sess->d_id.b.domain, sess->d_id.b.area,
-	    sess->d_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
+	sess->logout_completed = 0;
+	be_sid[0] = sess->d_id.b.domain;
+	be_sid[1] = sess->d_id.b.area;
+	be_sid[2] = sess->d_id.b.al_pa;
 
 	/*
 	 * Determine if this fc_port->port_name is allowed to access
@@ -1164,6 +1172,9 @@ static struct fc_port *qlt_create_sess(
 	 */
 	if (ha->tgt.tgt_ops->check_initiator_node_acl(vha,
 	    &fcport->port_name[0], sess) < 0) {
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xffff,
+			"(%d) %8phC check_initiator_node_acl failed\n",
+			vha->vp_idx, fcport->port_name);
 		return NULL;
 	} else {
 		/*
@@ -1173,51 +1184,25 @@ static struct fc_port *qlt_create_sess(
 		ha->tgt.tgt_ops->get_sess(sess);
 	}
 
-	return sess;
-}
-
-/*
- * max_gen - specifies maximum session generation
- * at which this deletion requestion is still valid
- */
-void
-qlt_fc_port_deleted(struct scsi_qla_host *vha, fc_port_t *fcport, int max_gen)
-{
-	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
-	struct fc_port *sess = fcport;
-	unsigned long flags;
-
-	if (!vha->hw->tgt.tgt_ops)
-		return;
-
-	if (!tgt)
-		return;
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+	if (!IS_SW_RESV_ADDR(sess->d_id))
+		vha->vha_tgt.qla_tgt->sess_count++;
 
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	if (tgt->tgt_stop) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		return;
-	}
-	if (!sess->se_sess) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		return;
-	}
+	qlt_do_generation_tick(vha, &sess->generation);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
-	if (max_gen - sess->generation < 0) {
-		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
-		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf092,
-		    "Ignoring stale deletion request for se_sess %p / sess %p"
-		    " for port %8phC, req_gen %d, sess_gen %d\n",
-		    sess->se_sess, sess, sess->port_name, max_gen,
-		    sess->generation);
-		return;
-	}
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf006,
+	    "Adding sess %p se_sess %p to tgt %p via ->check_initiator_node_acl()\n",
+	    sess, sess->se_sess, vha->vha_tgt.qla_tgt);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf008, "qla_tgt_fc_port_deleted %p", sess);
+	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
+	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, "
+	    "s_id %x:%x:%x, confirmed completion %ssupported) added\n",
+	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
+	    fcport->loop_id, sess->d_id.b.domain, sess->d_id.b.area,
+	    sess->d_id.b.al_pa, sess->conf_compl_supported ?  "" : "not ");
 
-	sess->local = 1;
-	qlt_schedule_sess_for_deletion(sess, false);
-	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	return sess;
 }
 
 static inline int test_tgt_sess_count(struct qla_tgt *tgt)
@@ -1229,12 +1214,12 @@ static inline int test_tgt_sess_count(struct qla_tgt *tgt)
 	 * We need to protect against race, when tgt is freed before or
 	 * inside wake_up()
 	 */
-	spin_lock_irqsave(&ha->hardware_lock, flags);
+	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 	ql_dbg(ql_dbg_tgt, tgt->vha, 0xe002,
 	    "tgt %p, sess_count=%d\n",
 	    tgt, tgt->sess_count);
 	res = (tgt->sess_count == 0);
-	spin_unlock_irqrestore(&ha->hardware_lock, flags);
+	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 	return res;
 }
@@ -1282,8 +1267,6 @@ int qlt_stop_phase1(struct qla_tgt *tgt)
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 	mutex_unlock(&qla_tgt_mutex);
 
-	flush_delayed_work(&tgt->sess_del_work);
-
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf009,
 	    "Waiting for sess works (tgt %p)", tgt);
 	spin_lock_irqsave(&tgt->sess_work_lock, flags);
@@ -1759,7 +1742,7 @@ static void qlt_24xx_handle_abts(struct scsi_qla_host *vha,
 	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 
 
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (sess->deleted) {
 		qlt_24xx_send_abts_resp(vha, abts, FCP_TMF_REJECTED, false);
 		return;
 	}
@@ -1944,10 +1927,19 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 		return;
 	}
 
-	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK)
-		qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
-		    0, 0, 0, 0, 0, 0);
-	else {
+	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK) {
+		if (mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
+		    ELS_LOGO) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+			    "TM response logo %phC status %#x state %#x",
+			    mcmd->sess->port_name, mcmd->fc_tm_rsp,
+			    mcmd->flags);
+			qlt_schedule_sess_for_deletion_lock(mcmd->sess);
+		} else {
+			qlt_send_notify_ack(vha, &mcmd->orig_iocb.imm_ntfy,
+				0, 0, 0, 0, 0, 0);
+		}
+	} else {
 		if (mcmd->orig_iocb.atio.u.raw.entry_type == ABTS_RECV_24XX)
 			qlt_24xx_send_abts_resp(vha, &mcmd->orig_iocb.abts,
 			    mcmd->fc_tm_rsp, false);
@@ -2924,7 +2916,7 @@ int qlt_xmit_response(struct qla_tgt_cmd *cmd, int xmit_type,
 	int res;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
-	if (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (cmd->sess && cmd->sess->deleted) {
 		cmd->state = QLA_TGT_STATE_PROCESSED;
 		if (cmd->sess->logout_completed)
 			/* no need to terminate. FW already freed exchange. */
@@ -3104,7 +3096,7 @@ int qlt_rdy_to_xfer(struct qla_tgt_cmd *cmd)
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!vha->flags.online || (cmd->reset_count != ha->chip_reset) ||
-	    (cmd->sess && cmd->sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)) {
+	    (cmd->sess && cmd->sess->deleted)) {
 		/*
 		 * Either the port is not online or this request was from
 		 * previous life, just abort the processing.
@@ -3906,7 +3898,11 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha, uint32_t handle,
 				 */
 				cmd->sess->logout_on_delete = 0;
 				cmd->sess->send_els_logo = 1;
-				qlt_schedule_sess_for_deletion(cmd->sess, true);
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC post del sess\n",
+					   __func__, __LINE__, cmd->sess->port_name);
+
+				qlt_schedule_sess_for_deletion_lock(cmd->sess);
 			}
 			break;
 		}
@@ -4190,6 +4186,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
 	struct fc_port *sess;
 	struct qla_tgt_cmd *cmd;
+	unsigned long flags;
 
 	if (unlikely(tgt->tgt_stop)) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
@@ -4218,7 +4215,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 
 	/* Another WWN used to have our s_id. Our PLOGI scheduled its
 	 * session deletion, but it's still in sess_del_work wq */
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+	if (sess->deleted) {
 		ql_dbg(ql_dbg_io, vha, 0x3061,
 		    "New command while old session %p is being deleted\n",
 		    sess);
@@ -4228,13 +4225,22 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
 	/*
 	 * Do kref_get() before returning + dropping qla_hw_data->hardware_lock.
 	 */
-	ha->tgt.tgt_ops->get_sess(sess);
+	if (!ha->tgt.tgt_ops->get_sess(sess)) {
+		ql_dbg(ql_dbg_tgt, vha, 0xffff,
+			"%s: kref_get fail, %8phC oxid %x \n",
+			__func__, sess->port_name,
+			be16_to_cpu(atio->u.isp24.fcp_hdr.ox_id));
+		return -EFAULT;
+	}
 
 	cmd = qlt_get_tag(vha, sess, atio);
 	if (!cmd) {
 		ql_dbg(ql_dbg_io, vha, 0x3062,
 		    "qla_target(%d): Allocation of cmd failed\n", vha->vp_idx);
+
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
 		ha->tgt.tgt_ops->put_sess(sess);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
 		return -ENOMEM;
 	}
 
@@ -4336,7 +4342,7 @@ static int qlt_handle_task_mgmt(struct scsi_qla_host *vha, void *iocb)
 		    sizeof(struct atio_from_isp));
 	}
 
-	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS)
+	if (sess->deleted)
 		return -EFAULT;
 
 	return qlt_issue_task_mgmt(sess, unpacked_lun, fn, iocb, 0);
@@ -4409,22 +4415,20 @@ static int qlt_abort_task(struct scsi_qla_host *vha,
 
 void qlt_logo_completion_handler(fc_port_t *fcport, int rc)
 {
-	if (fcport->tgt_session) {
-		if (rc != MBS_COMMAND_COMPLETE) {
-			ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
-				"%s: se_sess %p / sess %p from"
-				" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
-				" LOGO failed: %#x\n",
-				__func__,
-				fcport->se_sess,
-				fcport->tgt_session,
-				fcport->port_name, fcport->loop_id,
-				fcport->d_id.b.domain, fcport->d_id.b.area,
-				fcport->d_id.b.al_pa, rc);
-		}
-
-		fcport->logout_completed = 1;
+	if (rc != MBS_COMMAND_COMPLETE) {
+		ql_dbg(ql_dbg_tgt_mgt, fcport->vha, 0xf093,
+			"%s: se_sess %p / sess %p from"
+			" port %8phC loop_id %#04x s_id %02x:%02x:%02x"
+			" LOGO failed: %#x\n",
+			__func__,
+			fcport->se_sess,
+			fcport,
+			fcport->port_name, fcport->loop_id,
+			fcport->d_id.b.domain, fcport->d_id.b.area,
+			fcport->d_id.b.al_pa, rc);
 	}
+
+	fcport->logout_completed = 1;
 }
 
 /*
@@ -4472,6 +4476,11 @@ struct fc_port *
 				 * Another wwn used to have our s_id/loop_id
 				 * kill the session, but don't free the loop_id
 				 */
+				ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+				    "Invalidating sess %p loop_id %d wwn %llx.\n",
+				    other_sess, other_sess->loop_id, other_wwn);
+
+
 				other_sess->keep_nport_handle = 1;
 				*conflict_sess = other_sess;
 				qlt_schedule_sess_for_deletion(other_sess,
@@ -4481,7 +4490,8 @@ struct fc_port *
 		}
 
 		/* find other sess with nport handle collision */
-		if (loop_id == other_sess->loop_id) {
+		if ((loop_id == other_sess->loop_id) &&
+			(loop_id != FC_NO_LOOP_ID)) {
 			ql_dbg(ql_dbg_tgt_tmr, vha, 0x1000d,
 			       "Invalidating sess %p loop_id %d wwn %llx.\n",
 			       other_sess, other_sess->loop_id, other_wwn);
@@ -4553,9 +4563,12 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 
 	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
 
-	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf026,
-	    "qla_target(%d): Port ID: 0x%3phC ELS opcode: 0x%02x\n",
-	    vha->vp_idx, iocb->u.isp24.port_id, iocb->u.isp24.status_subcode);
+	ql_dbg(ql_dbg_disc, vha, 0xf026,
+	    "qla_target(%d): Port ID: %02x:%02x:%02x ELS opcode: 0x%02x lid %d %8phC\n",
+	    vha->vp_idx, iocb->u.isp24.port_id[2],
+		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
+		   iocb->u.isp24.status_subcode, loop_id,
+		iocb->u.isp24.port_name);
 
 	/* res = 1 means ack at the end of thread
 	 * res = 0 means ack async/later.
@@ -4573,7 +4586,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
 		}
 
-		if (IS_SW_RESV_ADDR(port_id) || (!sess && !conflict_sess)) {
+		if (IS_SW_RESV_ADDR(port_id)) {
 			res = 1;
 			break;
 		}
@@ -4581,42 +4594,66 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
 		if (!pla) {
 			qlt_send_term_imm_notif(vha, iocb, 1);
-
-			res = 0;
 			break;
 		}
 
 		res = 0;
 
-		if (conflict_sess)
+		if (conflict_sess) {
+			conflict_sess->login_gen++;
 			qlt_plogi_ack_link(vha, pla, conflict_sess,
-			    QLT_PLOGI_LINK_CONFLICT);
+				QLT_PLOGI_LINK_CONFLICT);
+		}
 
-		if (!sess)
+		if (!sess) {
+			pla->ref_count++;
+			qla24xx_post_newsess_work(vha, &port_id,
+				iocb->u.isp24.port_name, pla);
+			res = 0;
 			break;
+		}
 
 		qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
-		 /*
-		  * Under normal circumstances we want to release nport handle
-		  * during LOGO process to avoid nport handle leaks inside FW.
-		  * The exception is when LOGO is done while another PLOGI with
-		  * the same nport handle is waiting as might be the case here.
-		  * Note: there is always a possibily of a race where session
-		  * deletion has already started for other reasons (e.g. ACL
-		  * removal) and now PLOGI arrives:
-		  * 1. if PLOGI arrived in FW after nport handle has been freed,
-		  *    FW must have assigned this PLOGI a new/same handle and we
-		  *    can proceed ACK'ing it as usual when session deletion
-		  *    completes.
-		  * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
-		  *    bit reached it, the handle has now been released. We'll
-		  *    get an error when we ACK this PLOGI. Nothing will be sent
-		  *    back to initiator. Initiator should eventually retry
-		  *    PLOGI and situation will correct itself.
-		  */
-		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
-					   (sess->d_id.b24 == port_id.b24));
-		qlt_schedule_sess_for_deletion(sess, true);
+		sess->fw_login_state = DSC_LS_PLOGI_PEND;
+		sess->d_id = port_id;
+		sess->login_gen++;
+
+		switch (sess->disc_state) {
+		case DSC_DELETED:
+			qlt_plogi_ack_unref(vha, pla);
+			break;
+
+		default:
+			/*
+			 * Under normal circumstances we want to release nport handle
+			 * during LOGO process to avoid nport handle leaks inside FW.
+			 * The exception is when LOGO is done while another PLOGI with
+			 * the same nport handle is waiting as might be the case here.
+			 * Note: there is always a possibily of a race where session
+			 * deletion has already started for other reasons (e.g. ACL
+			 * removal) and now PLOGI arrives:
+			 * 1. if PLOGI arrived in FW after nport handle has been freed,
+			 *    FW must have assigned this PLOGI a new/same handle and we
+			 *    can proceed ACK'ing it as usual when session deletion
+			 *    completes.
+			 * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
+			 *    bit reached it, the handle has now been released. We'll
+			 *    get an error when we ACK this PLOGI. Nothing will be sent
+			 *    back to initiator. Initiator should eventually retry
+			 *    PLOGI and situation will correct itself.
+			 */
+			sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
+			   (sess->d_id.b24 == port_id.b24));
+
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post del sess\n",
+				   __func__, __LINE__, sess->port_name);
+
+
+			qlt_schedule_sess_for_deletion_lock(sess);
+			break;
+		}
+
 		break;
 
 	case ELS_PRLI:
@@ -4639,7 +4676,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (sess != NULL) {
-			if (sess->deleted) {
+			if (sess->fw_login_state == DSC_LS_PLOGI_PEND) {
 				/*
 				 * Impatient initiator sent PRLI before last
 				 * PLOGI could finish. Will force him to re-try,
@@ -4664,10 +4701,15 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			sess->local = 0;
 			sess->loop_id = loop_id;
 			sess->d_id = port_id;
+			sess->fw_login_state = DSC_LS_PRLI_PEND;
 
 			if (wd3_lo & BIT_7)
 				sess->conf_compl_supported = 1;
 
+			if ((wd3_lo & BIT_4) == 0)
+				sess->port_type = FCT_INITIATOR;
+			else
+				sess->port_type = FCT_TARGET;
 		}
 		res = 1; /* send notify ack */
 
@@ -4677,15 +4719,50 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
 		} else {
-			/* todo: else - create sess here. */
-			res = 1; /* send notify ack */
-		}
+			if (sess) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+					   "%s %d %8phC post nack\n",
+					   __func__, __LINE__, sess->port_name);
 
+				qla24xx_post_nack_work(vha, sess, iocb,
+					SRB_NACK_PRLI);
+				res = 0;
+			}
+		}
 		break;
 
 	case ELS_LOGO:
 	case ELS_PRLO:
+		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
+		sess = qla2x00_find_fcport_by_loopid(vha, loop_id);
+		spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
+
+		if (sess) {
+			sess->login_gen++;
+			sess->fw_login_state = DSC_LS_LOGO_PEND;
+			sess->logout_on_delete = 0;
+			sess->logo_ack_needed = 1;
+			memcpy(sess->iocb, iocb, IOCB_SIZE);
+		}
+
 		res = qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS_SESS);
+
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s: logo %llx res %d sess %p ",
+		    __func__, wwn, res, sess);
+		if (res == 0) {
+			/* cmd went up to ULP. look for qlt_xmit_tm_rsp()
+			   for LOGO_ACK */
+			BUG_ON(!sess);
+			res = 0;
+		} else {
+			/* cmd did not go upstair. */
+			if (sess) {
+				qlt_schedule_sess_for_deletion_lock(sess);
+				res = 0;
+			}
+			/* else logo will be ack */
+		}
 		break;
 	case ELS_PDISC:
 	case ELS_ADISC:
@@ -4696,6 +4773,16 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 			    0, 0, 0, 0, 0, 0);
 			tgt->link_reinit_iocb_pending = 0;
 		}
+
+		sess = qla2x00_find_fcport_by_wwpn(vha,
+		    iocb->u.isp24.port_name, 1);
+		if (sess) {
+			ql_dbg(ql_dbg_disc, vha, 0xffff,
+				"sess %p lid %d|%d DS %d LS %d\n",
+				sess, sess->loop_id, loop_id,
+				sess->disc_state, sess->fw_login_state);
+		}
+
 		res = 1; /* send notify ack */
 		break;
 	}
@@ -5929,8 +6016,10 @@ void qlt_async_event(uint16_t code, struct scsi_qla_host *vha,
 static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 	uint16_t loop_id)
 {
-	fc_port_t *fcport;
+	fc_port_t *fcport, *tfcp, *del;
 	int rc;
+	unsigned long flags;
+	u8 newfcport = 0;
 
 	fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (!fcport) {
@@ -5952,6 +6041,59 @@ static fc_port_t *qlt_get_port_database(struct scsi_qla_host *vha,
 		return NULL;
 	}
 
+	del = NULL;
+	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+	tfcp = qla2x00_find_fcport_by_wwpn(vha, fcport->port_name, 1);
+
+	if (tfcp) {
+		tfcp->d_id = fcport->d_id;
+		tfcp->port_type = fcport->port_type;
+		tfcp->supported_classes = fcport->supported_classes;
+		tfcp->flags |= fcport->flags;
+
+		del = fcport;
+		fcport = tfcp;
+	} else {
+		if (vha->hw->current_topology == ISP_CFG_F)
+			fcport->flags |= FCF_FABRIC_DEVICE;
+
+		list_add_tail(&fcport->list, &vha->vp_fcports);
+		if (!IS_SW_RESV_ADDR(fcport->d_id))
+		   vha->fcport_count++;
+		fcport->login_gen++;
+		fcport->disc_state = DSC_LOGIN_COMPLETE;
+		fcport->login_succ = 1;
+		newfcport = 1;
+	}
+
+	fcport->deleted = 0;
+	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
+	switch (vha->host->active_mode) {
+	case MODE_INITIATOR:
+	case MODE_DUAL:
+		if (newfcport) {
+			if (!IS_IIDMA_CAPABLE(vha->hw) || !vha->hw->flags.gpsc_supported) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post upd_fcport fcp_cnt %d\n",
+				   __func__, __LINE__, fcport->port_name, vha->fcport_count);
+				qla24xx_post_upd_fcport_work(vha, fcport);
+			} else {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				   "%s %d %8phC post gpsc fcp_cnt %d\n",
+				   __func__, __LINE__, fcport->port_name, vha->fcport_count);
+				qla24xx_post_gpsc_work(vha, fcport);
+			}
+		}
+		break;
+
+	case MODE_TARGET:
+	default:
+		break;
+	}
+	if (del)
+		qla2x00_free_fcport(del);
+
 	return fcport;
 }
 
@@ -5964,6 +6106,17 @@ static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 	int rc, global_resets;
 	uint16_t loop_id = 0;
 
+	if ((s_id[0] == 0xFF) && (s_id[1] == 0xFC)) {
+		/*
+		 * This is Domain Controller, so it should be
+		 * OK to drop SCSI commands from it.
+		 */
+		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf042,
+		    "Unable to find initiator with S_ID %x:%x:%x",
+		    s_id[0], s_id[1], s_id[2]);
+		return NULL;
+	}
+
 	mutex_lock(&vha->vha_tgt.tgt_mutex);
 
 retry:
@@ -5974,21 +6127,11 @@ static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 	if (rc != 0) {
 		mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-		if ((s_id[0] == 0xFF) &&
-		    (s_id[1] == 0xFC)) {
-			/*
-			 * This is Domain Controller, so it should be
-			 * OK to drop SCSI commands from it.
-			 */
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf042,
-			    "Unable to find initiator with S_ID %x:%x:%x",
-			    s_id[0], s_id[1], s_id[2]);
-		} else
-			ql_log(ql_log_info, vha, 0xf071,
-			    "qla_target(%d): Unable to find "
-			    "initiator with S_ID %x:%x:%x",
-			    vha->vp_idx, s_id[0], s_id[1],
-			    s_id[2]);
+		ql_log(ql_log_info, vha, 0xf071,
+		    "qla_target(%d): Unable to find "
+		    "initiator with S_ID %x:%x:%x",
+		    vha->vp_idx, s_id[0], s_id[1],
+		    s_id[2]);
 
 		if (rc == -ENOENT) {
 			qlt_port_logo_t logo;
@@ -6021,7 +6164,6 @@ static struct fc_port *qlt_make_local_sess(struct scsi_qla_host *vha,
 
 	mutex_unlock(&vha->vha_tgt.tgt_mutex);
 
-	qla2x00_free_fcport(fcport);
 	return sess;
 }
 
@@ -6057,12 +6199,18 @@ static void qlt_abort_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term2;
 	} else {
-		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		if (sess->deleted) {
 			sess = NULL;
 			goto out_term2;
 		}
 
-		ha->tgt.tgt_ops->get_sess(sess);
+		if (!ha->tgt.tgt_ops->get_sess(sess)) {
+			ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+				"%s: kref_get fail %8pHC \n",
+				__func__, sess->port_name);
+			sess = NULL;
+			goto out_term2;
+		}
 	}
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -6121,12 +6269,18 @@ static void qlt_tmr_work(struct qla_tgt *tgt,
 		if (!sess)
 			goto out_term;
 	} else {
-		if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		if (sess->deleted) {
 			sess = NULL;
 			goto out_term;
 		}
 
-		ha->tgt.tgt_ops->get_sess(sess);
+		if (!ha->tgt.tgt_ops->get_sess(sess)) {
+			ql_dbg(ql_dbg_tgt_tmr, vha, 0xffff,
+				"%s: kref_get fail %8pHC \n",
+				__func__, sess->port_name);
+			sess = NULL;
+			goto out_term;
+		}
 	}
 
 	iocb = a;
@@ -6221,8 +6375,6 @@ int qlt_add_target(struct qla_hw_data *ha, struct scsi_qla_host *base_vha)
 	tgt->vha = base_vha;
 	init_waitqueue_head(&tgt->waitQ);
 	INIT_LIST_HEAD(&tgt->del_sess_list);
-	INIT_DELAYED_WORK(&tgt->sess_del_work,
-		(void (*)(struct work_struct *))qlt_del_sess_work_fn);
 	spin_lock_init(&tgt->sess_work_lock);
 	INIT_WORK(&tgt->sess_work, qlt_sess_work_fn);
 	INIT_LIST_HEAD(&tgt->sess_works_list);
@@ -6400,6 +6552,7 @@ static void qlt_set_mode(struct scsi_qla_host *vha)
 	case QLA2XXX_INI_MODE_ENABLED:
 		vha->host->active_mode |= MODE_TARGET;
 		break;
+
 	default:
 		break;
 	}
@@ -6422,6 +6575,7 @@ static void qlt_clear_mode(struct scsi_qla_host *vha)
 		break;
 	case QLA2XXX_INI_MODE_ENABLED:
 		vha->host->active_mode &= ~MODE_TARGET;
+		vha->host->active_mode |= MODE_INITIATOR;
 		break;
 	default:
 		break;
@@ -6544,13 +6698,12 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	 * FC-4 Feature bit 0 indicates target functionality to the name server.
 	 */
 	if (qla_tgt_mode_enabled(vha)) {
-		if (qla_ini_mode_enabled(vha))
-			ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
-		else
-			ct_req->req.rff_id.fc4_feature = BIT_0;
+		ct_req->req.rff_id.fc4_feature = BIT_0;
 	} else if (qla_ini_mode_enabled(vha)) {
 		ct_req->req.rff_id.fc4_feature = BIT_1;
-	}
+	} else if (qla_dual_mode_enabled(vha))
+		ct_req->req.rff_id.fc4_feature = BIT_0 | BIT_1;
+
 }
 
 /*
@@ -6665,7 +6818,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
-		if (!qla_ini_mode_enabled(vha))
+		if (qla_tgt_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 		/* Disable Full Login after LIP */
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_13);
@@ -6769,7 +6922,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 		nv->firmware_options_1 |= cpu_to_le32(BIT_4);
 
 		/* Disable ini mode, if requested */
-		if (!qla_ini_mode_enabled(vha))
+		if (qla_tgt_mode_enabled(vha))
 			nv->firmware_options_1 |= cpu_to_le32(BIT_5);
 
 		/* Disable Full Login after LIP */
@@ -6880,7 +7033,7 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_5;
 	/* Disable ini mode, if requested */
-	if (!qla_ini_mode_enabled(vha))
+	if (qla_tgt_mode_enabled(vha))
 		vpmod->options_idx1 &= ~BIT_4;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.h b/drivers/scsi/qla2xxx/qla_target.h
index 6db17ab..6d0d738 100644
--- a/drivers/scsi/qla2xxx/qla_target.h
+++ b/drivers/scsi/qla2xxx/qla_target.h
@@ -740,7 +740,7 @@ struct qla_tgt_func_tmpl {
 	struct fc_port *(*find_sess_by_s_id)(struct scsi_qla_host *,
 						const uint8_t *);
 	void (*clear_nacl_from_fcport_map)(struct fc_port *);
-	void (*get_sess)(struct fc_port *);
+	int  (*get_sess)(struct fc_port *);
 	void (*put_sess)(struct fc_port *);
 	void (*shutdown_sess)(struct fc_port *);
 	void (*release_cmd)(struct qla_tgt_cmd *);
@@ -868,7 +868,6 @@ struct qla_tgt {
 
 	/* Protected by hardware_lock */
 	struct list_head del_sess_list;
-	struct delayed_work sess_del_work;
 
 	spinlock_t sess_work_lock;
 	struct list_head sess_works_list;
@@ -904,7 +903,6 @@ struct qla_tgt_sess_op {
 enum qla_sess_deletion {
 	QLA_SESS_DELETION_NONE		= 0,
 	QLA_SESS_DELETION_IN_PROGRESS,
-	QLA_SESS_DELETION_PENDING,
 	QLA_SESS_DELETED,
 };
 
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 8facd3d..c13314a 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -402,12 +402,21 @@ static void tcm_qla2xxx_put_sess(struct fc_port *sess)
 	kref_put(&sess->sess_kref, tcm_qla2xxx_release_session);
 }
 
-static void tcm_qla2xxx_get_sess(struct fc_port *sess)
+/*
+ * return
+ * 1: kref_get success.
+ * 0: kref_get fail
+ */
+static int tcm_qla2xxx_get_sess(struct fc_port *sess)
 {
-	if (!sess)
-		return;
+	struct se_session *se_sess;
+
+	se_sess = (struct se_session *)sess->se_sess;
+
+	if (!se_sess)
+		return 0;
 
-	kref_get(&sess->sess_kref);
+	return kref_get_unless_zero(&sess->sess_kref);
 }
 
 /* tcm_qla2xxx_release_cmd - Callback from TCM Core to release underlying
-- 
1.8.3.1
