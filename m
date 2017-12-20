From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 41/43] qla2xxx: Serialize session deletion by using work_lock
Date: Tue, 19 Dec 2017 22:56:42 -0800
Message-ID: <20171220065644.21511-42-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0045.outbound.protection.outlook.com ([104.47.40.45]:62688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932533AbdLTG5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:46 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

for session deletion, replace sess_lock with work_lock.
Under certain case sess_lock is not feasiable to acquire.
The lock is needed temporarily to make sure a single
call to schedule of the work element.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h    |  1 -
 drivers/scsi/qla2xxx/qla_gs.c     | 14 ++++++--------
 drivers/scsi/qla2xxx/qla_init.c   |  9 +++------
 drivers/scsi/qla2xxx/qla_isr.c    |  4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c    |  2 +-
 drivers/scsi/qla2xxx/qla_os.c     |  5 ++---
 drivers/scsi/qla2xxx/qla_target.c | 29 ++++++++++++++---------------
 7 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index ab8ffd7933c9..733906cb6c69 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -889,7 +889,6 @@ void qlt_plogi_ack_link(struct scsi_qla_host *, struct qlt_plogi_ack_t *,
 	struct fc_port *, enum qlt_plogi_link_t);
 void qlt_plogi_ack_unref(struct scsi_qla_host *, struct qlt_plogi_ack_t *);
 extern void qlt_schedule_sess_for_deletion(struct fc_port *);
-extern void qlt_schedule_sess_for_deletion_lock(struct fc_port *);
 extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
 void qla24xx_delete_sess_fn(struct work_struct *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index dd02cbfd0fb1..f26d680fe6c1 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3096,7 +3096,7 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 					ql_dbg(ql_dbg_disc, vha, 0x2021,
 					    "%s %d %8phC post del sess\n",
 					    __func__, __LINE__, fcport->port_name);
-					qlt_schedule_sess_for_deletion_lock(fcport);
+					qlt_schedule_sess_for_deletion(fcport);
 				}
 			}
 		} else { /* ea->sp->gen1 != fcport->rscn_gen */
@@ -3113,7 +3113,7 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 				ql_dbg(ql_dbg_disc, vha, 0x2042,
 				    "%s %d %8phC post del sess\n", __func__,
 				    __LINE__, fcport->port_name);
-				qlt_schedule_sess_for_deletion_lock(fcport);
+				qlt_schedule_sess_for_deletion(fcport);
 			} else {
 				ql_dbg(ql_dbg_disc, vha, 0x2045,
 				    "%s %d %8phC login\n", __func__, __LINE__,
@@ -3485,8 +3485,7 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 					    "%s %d %8phC post del sess\n",
 					    __func__, __LINE__,
 					    fcport->port_name);
-					qlt_schedule_sess_for_deletion_lock
-						(fcport);
+					qlt_schedule_sess_for_deletion(fcport);
 					break;
 				}
 			}
@@ -3519,7 +3518,7 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 						    "%s %d %8phC post del sess\n",
 						    __func__, __LINE__,
 						    conflict->port_name);
-						qlt_schedule_sess_for_deletion_lock
+						qlt_schedule_sess_for_deletion
 							(conflict);
 						break;
 					}
@@ -3577,7 +3576,7 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 						    "%s %d %8phC post del sess\n",
 						    __func__, __LINE__,
 						    conflict->port_name);
-						qlt_schedule_sess_for_deletion_lock
+						qlt_schedule_sess_for_deletion
 							(conflict);
 						break;
 					}
@@ -4008,8 +4007,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 					    __func__, __LINE__,
 					    fcport->port_name);
 
-					qlt_schedule_sess_for_deletion_lock
-						(fcport);
+					qlt_schedule_sess_for_deletion(fcport);
 					continue;
 				}
 			}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3e03c264f7bd..fdb453fc9708 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1093,7 +1093,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	default:
 		ql_dbg(ql_dbg_disc, vha, 0x20d5, "%s %d %8phC post del sess\n",
 		    __func__, __LINE__, fcport->port_name);
-		qlt_schedule_sess_for_deletion_lock(fcport);
+		qlt_schedule_sess_for_deletion(fcport);
 		return;
 	}
 	__qla24xx_handle_gpdb_event(vha, ea);
@@ -5002,8 +5002,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 					    __func__, __LINE__,
 					    fcport->port_name);
 
-					qlt_schedule_sess_for_deletion_lock
-						(fcport);
+					qlt_schedule_sess_for_deletion(fcport);
 					continue;
 				}
 			}
@@ -5590,9 +5589,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 					    "%s %d %8phC post del sess\n",
 					    __func__, __LINE__,
 					    fcport->port_name);
-
-					qlt_schedule_sess_for_deletion_lock
-						(fcport);
+					qlt_schedule_sess_for_deletion(fcport);
 					continue;
 				}
 			}
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6974657dd8c6..8c771aaa523c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1009,7 +1009,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 			if (qla_ini_mode_enabled(vha)) {
 				qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
 				fcport->logout_on_delete = 0;
-				qlt_schedule_sess_for_deletion_lock(fcport);
+				qlt_schedule_sess_for_deletion(fcport);
 			}
 			break;
 
@@ -2706,7 +2706,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				comp_status);
 
 			qla2x00_mark_device_lost(fcport->vha, fcport, 1, 1);
-			qlt_schedule_sess_for_deletion_lock(fcport);
+			qlt_schedule_sess_for_deletion(fcport);
 		}
 
 		break;
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 68587e631f60..663509e58d9d 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3897,7 +3897,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			case DSC_DELETE_PEND:
 				break;
 			default:
-				qlt_schedule_sess_for_deletion_lock(fcport);
+				qlt_schedule_sess_for_deletion(fcport);
 				break;
 			}
 		} else {
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 22ab1a6dd577..a58b9de73afa 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3858,7 +3858,7 @@ qla2x00_mark_all_devices_lost(scsi_qla_host_t *vha, int defer)
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		fcport->scan_state = 0;
-		qlt_schedule_sess_for_deletion_lock(fcport);
+		qlt_schedule_sess_for_deletion(fcport);
 
 		if (vha->vp_idx != 0 && vha->vp_idx != fcport->vha->vp_idx)
 			continue;
@@ -4886,8 +4886,7 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 				default:
 					fcport->login_pause = 1;
 					tfcp->conflict = fcport;
-					qlt_schedule_sess_for_deletion_lock
-						(tfcp);
+					qlt_schedule_sess_for_deletion(tfcp);
 					break;
 				}
 			}
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 6b16f0dbd588..814dfb1036de 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -1214,6 +1214,7 @@ static void qla24xx_chk_fcp_state(struct fc_port *sess)
 void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 {
 	struct qla_tgt *tgt = sess->tgt;
+	unsigned long flags;
 
 	if (sess->disc_state == DSC_DELETE_PEND)
 		return;
@@ -1229,12 +1230,19 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 			return;
 	}
 
-	sess->disc_state = DSC_DELETE_PEND;
-
 	if (sess->deleted == QLA_SESS_DELETED)
 		sess->logout_on_delete = 0;
 
+	spin_lock_irqsave(&sess->vha->work_lock, flags);
+	if (sess->deleted == QLA_SESS_DELETION_IN_PROGRESS) {
+		spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+		return;
+	}
 	sess->deleted = QLA_SESS_DELETION_IN_PROGRESS;
+	spin_unlock_irqrestore(&sess->vha->work_lock, flags);
+
+	sess->disc_state = DSC_DELETE_PEND;
+
 	qla24xx_chk_fcp_state(sess);
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
@@ -1244,15 +1252,6 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess)
 	queue_work(sess->vha->hw->wq, &sess->del_work);
 }
 
-void qlt_schedule_sess_for_deletion_lock(struct fc_port *sess)
-{
-	unsigned long flags;
-	struct qla_hw_data *ha = sess->vha->hw;
-	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
-	qlt_schedule_sess_for_deletion(sess);
-	spin_unlock_irqrestore(&ha->tgt.sess_lock, flags);
-}
-
 /* ha->tgt.sess_lock supposed to be held on entry */
 static void qlt_clear_tgt_db(struct qla_tgt *tgt)
 {
@@ -2208,7 +2207,7 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 			    "TM response logo %phC status %#x state %#x",
 			    mcmd->sess->port_name, mcmd->fc_tm_rsp,
 			    mcmd->flags);
-			qlt_schedule_sess_for_deletion_lock(mcmd->sess);
+			qlt_schedule_sess_for_deletion(mcmd->sess);
 		} else {
 			qlt_send_notify_ack(vha->hw->base_qpair,
 			    &mcmd->orig_iocb.imm_ntfy, 0, 0, 0, 0, 0, 0);
@@ -3924,7 +3923,7 @@ static void qlt_do_ctio_completion(struct scsi_qla_host *vha,
 				    "%s %d %8phC post del sess\n",
 				    __func__, __LINE__, cmd->sess->port_name);
 
-				qlt_schedule_sess_for_deletion_lock(cmd->sess);
+				qlt_schedule_sess_for_deletion(cmd->sess);
 			}
 			break;
 		}
@@ -4742,7 +4741,7 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 		    __func__, __LINE__, sess->port_name);
 
 
-		qlt_schedule_sess_for_deletion_lock(sess);
+		qlt_schedule_sess_for_deletion(sess);
 		break;
 	}
 out:
@@ -4970,7 +4969,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		} else {
 			/* cmd did not go to upper layer. */
 			if (sess) {
-				qlt_schedule_sess_for_deletion_lock(sess);
+				qlt_schedule_sess_for_deletion(sess);
 				res = 0;
 			}
 			/* else logo will be ack */
-- 
2.12.0
