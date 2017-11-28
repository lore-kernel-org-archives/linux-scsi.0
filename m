From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 10/22] qla2xxx: Relogin to target port on a cable swap
Date: Tue, 28 Nov 2017 11:34:51 -0800
Message-ID: <20171128193503.13695-11-himanshu.madhani@cavium.com>
References: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0040.outbound.protection.outlook.com ([104.47.38.40]:63153
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932091AbdK1TfU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 28 Nov 2017 14:35:20 -0500
In-Reply-To: <20171128193503.13695-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

If user swaps one target port for another target port for same
switch port, the new target port is not being recognized by the
driver. Current code assumes that old Target port has recovered
from link down. The fix will ask switch what is the WWPN of a
specific NportID (GPNID) rather than assuming it's the same Target
port which has came back.

Fixes: 726b85487067d ("qla2xxx: Add framework for async fabric discovery")
Cc: <stable@vger.kernel.org> # 4.10+
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_gs.c     | 164 ++++++++++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_init.c   |   6 +-
 drivers/scsi/qla2xxx/qla_os.c     |  35 +++++++-
 drivers/scsi/qla2xxx/qla_target.c |  35 ++++++--
 4 files changed, 194 insertions(+), 46 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 59ecc4eda6cd..4486c9cc72e6 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3171,43 +3171,136 @@ void qla24xx_async_gpnid_done(scsi_qla_host_t *vha, srb_t *sp)
 
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-	fc_port_t *fcport;
-	unsigned long flags;
+	fc_port_t *fcport, *conflict, *t;
 
-	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	fcport = qla2x00_find_fcport_by_wwpn(vha, ea->port_name, 1);
-	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %d port_id: %06x\n",
+	    __func__, __LINE__, ea->id.b24);
 
-	if (fcport) {
-		/* cable moved. just plugged in */
-		fcport->rscn_gen++;
-		fcport->d_id = ea->id;
-		fcport->scan_state = QLA_FCPORT_FOUND;
-		fcport->flags |= FCF_FABRIC_DEVICE;
-
-		switch (fcport->disc_state) {
-		case DSC_DELETED:
-			ql_dbg(ql_dbg_disc, vha, 0x210d,
-			    "%s %d %8phC login\n", __func__, __LINE__,
-			    fcport->port_name);
-			qla24xx_fcport_handle_login(vha, fcport);
-			break;
-		case DSC_DELETE_PEND:
-			break;
-		default:
-			ql_dbg(ql_dbg_disc, vha, 0x2064,
-			    "%s %d %8phC post del sess\n",
-			    __func__, __LINE__, fcport->port_name);
-			qlt_schedule_sess_for_deletion_lock(fcport);
-			break;
+	if (ea->rc) {
+		/* cable is disconnected */
+		list_for_each_entry_safe(fcport, t, &vha->vp_fcports, list) {
+			if (fcport->d_id.b24 == ea->id.b24) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC DS %d\n",
+				    __func__, __LINE__,
+				    fcport->port_name,
+				    fcport->disc_state);
+				fcport->scan_state = QLA_FCPORT_SCAN;
+				switch (fcport->disc_state) {
+				case DSC_DELETED:
+				case DSC_DELETE_PEND:
+					break;
+				default:
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    fcport->port_name);
+					qlt_schedule_sess_for_deletion_lock
+						(fcport);
+					break;
+				}
+			}
 		}
 	} else {
-		/* create new fcport */
-		ql_dbg(ql_dbg_disc, vha, 0x2065,
-		    "%s %d %8phC post new sess\n",
-		    __func__, __LINE__, ea->port_name);
+		/* cable is connected */
+		fcport = qla2x00_find_fcport_by_wwpn(vha, ea->port_name, 1);
+		if (fcport) {
+			list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
+			    list) {
+				if ((conflict->d_id.b24 == ea->id.b24) &&
+				    (fcport != conflict)) {
+					/* 2 fcports with conflict Nport ID or
+					 * an existing fcport is having nport ID
+					 * conflict with new fcport.
+					 */
+
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC DS %d\n",
+					    __func__, __LINE__,
+					    conflict->port_name,
+					    conflict->disc_state);
+					conflict->scan_state = QLA_FCPORT_SCAN;
+					switch (conflict->disc_state) {
+					case DSC_DELETED:
+					case DSC_DELETE_PEND:
+						break;
+					default:
+						ql_dbg(ql_dbg_disc, vha, 0xffff,
+						    "%s %d %8phC post del sess\n",
+						    __func__, __LINE__,
+						    conflict->port_name);
+						qlt_schedule_sess_for_deletion_lock
+							(conflict);
+						break;
+					}
+				}
+			}
 
-		qla24xx_post_newsess_work(vha, &ea->id, ea->port_name, NULL);
+			fcport->rscn_gen++;
+			fcport->scan_state = QLA_FCPORT_FOUND;
+			fcport->flags |= FCF_FABRIC_DEVICE;
+			switch (fcport->disc_state) {
+			case DSC_LOGIN_COMPLETE:
+				/* recheck session is still intact. */
+				ql_dbg(ql_dbg_disc, vha, 0x210d,
+				    "%s %d %8phC revalidate session with ADISC\n",
+				    __func__, __LINE__, fcport->port_name);
+				qla24xx_post_gpdb_work(vha, fcport,
+				    PDO_FORCE_ADISC);
+				break;
+			case DSC_DELETED:
+				ql_dbg(ql_dbg_disc, vha, 0x210d,
+				    "%s %d %8phC login\n", __func__, __LINE__,
+				    fcport->port_name);
+				fcport->d_id = ea->id;
+				qla24xx_fcport_handle_login(vha, fcport);
+				break;
+			case DSC_DELETE_PEND:
+				fcport->d_id = ea->id;
+				break;
+			default:
+				fcport->d_id = ea->id;
+				break;
+			}
+		} else {
+			list_for_each_entry_safe(conflict, t, &vha->vp_fcports,
+			    list) {
+				if (conflict->d_id.b24 == ea->id.b24) {
+					/* 2 fcports with conflict Nport ID or
+					 * an existing fcport is having nport ID
+					 * conflict with new fcport.
+					 */
+					ql_dbg(ql_dbg_disc, vha, 0xffff,
+					    "%s %d %8phC DS %d\n",
+					    __func__, __LINE__,
+					    conflict->port_name,
+					    conflict->disc_state);
+
+					conflict->scan_state = QLA_FCPORT_SCAN;
+					switch (conflict->disc_state) {
+					case DSC_DELETED:
+					case DSC_DELETE_PEND:
+						break;
+					default:
+						ql_dbg(ql_dbg_disc, vha, 0xffff,
+						    "%s %d %8phC post del sess\n",
+						    __func__, __LINE__,
+						    conflict->port_name);
+						qlt_schedule_sess_for_deletion_lock
+							(conflict);
+						break;
+					}
+				}
+			}
+
+			/* create new fcport */
+			ql_dbg(ql_dbg_disc, vha, 0x2065,
+			    "%s %d %8phC post new sess\n",
+			    __func__, __LINE__, ea->port_name);
+			qla24xx_post_newsess_work(vha, &ea->id,
+			    ea->port_name, NULL);
+		}
 	}
 }
 
@@ -3248,10 +3341,11 @@ static void qla2x00_async_gpnid_sp_done(void *s, int res)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	if (res) {
-		if (res == QLA_FUNCTION_TIMEOUT)
+		if (res == QLA_FUNCTION_TIMEOUT) {
 			qla24xx_post_gpnid_work(sp->vha, &ea.id);
-		sp->free(sp);
-		return;
+			sp->free(sp);
+			return;
+		}
 	} else if (sp->gen1) {
 		/* There was anoter RSNC for this Nport ID */
 		qla24xx_post_gpnid_work(sp->vha, &ea.id);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 2f246996d3e2..7dd19785f820 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -925,6 +925,9 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		 * must have triggered the session to be re-validate.
 		 * session is still valid.
 		 */
+		ql_dbg(ql_dbg_disc, vha, 0x20d6,
+		    "%s %d %8phC session revalidate success\n",
+		    __func__, __LINE__, fcport->port_name);
 		fcport->disc_state = DSC_LOGIN_COMPLETE;
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
@@ -1049,9 +1052,8 @@ void qla24xx_handle_rscn_event(fc_port_t *fcport, struct event_arg *ea)
 	switch (fcport->disc_state) {
 	case DSC_DELETED:
 	case DSC_LOGIN_COMPLETE:
-		qla24xx_post_gidpn_work(fcport->vha, fcport);
+		qla24xx_post_gpnid_work(fcport->vha, &ea->id);
 		break;
-
 	default:
 		break;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index e71d99ba57f9..820d1c185beb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4760,10 +4760,39 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	if (fcport) {
-		if (pla)
+		if (pla) {
 			qlt_plogi_ack_unref(vha, pla);
-		else
-			qla24xx_async_gffid(vha, fcport);
+		} else {
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+			tfcp = qla2x00_find_fcport_by_nportid(vha,
+			    &e->u.new_sess.id, 1);
+			if (tfcp && (tfcp != fcport)) {
+				/*
+				 * We have a conflict fcport with same NportID.
+				 */
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %8phC found conflict b4 add. DS %d LS %d\n",
+				    __func__, tfcp->port_name, tfcp->disc_state,
+				    tfcp->fw_login_state);
+
+				switch (tfcp->disc_state) {
+				case DSC_DELETED:
+					break;
+				case DSC_DELETE_PEND:
+					fcport->login_pause = 1;
+					tfcp->conflict = fcport;
+					break;
+				default:
+					fcport->login_pause = 1;
+					tfcp->conflict = fcport;
+					qlt_schedule_sess_for_deletion_lock
+						(tfcp);
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+			qla24xx_async_gnl(vha, fcport);
+		}
 	}
 
 	if (free_fcport) {
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1bec8aebb7b6..283ff316e4b2 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -890,6 +890,17 @@ qlt_plogi_ack_link(struct scsi_qla_host *vha, struct qlt_plogi_ack_t *pla,
 		iocb->u.isp24.port_id[1], iocb->u.isp24.port_id[0],
 		pla->ref_count, pla, link);
 
+	if (link == QLT_PLOGI_LINK_CONFLICT) {
+		switch (sess->disc_state) {
+		case DSC_DELETED:
+		case DSC_DELETE_PEND:
+			pla->ref_count--;
+			return;
+		default:
+			break;
+		}
+	}
+
 	if (sess->plogi_link[link])
 		qlt_plogi_ack_unref(vha, sess->plogi_link[link]);
 
@@ -4737,6 +4748,10 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		sess->d_id = port_id;
 		sess->login_gen++;
 
+		ql_dbg(ql_dbg_disc, vha, 0x20f9,
+		    "%s %d %8phC  DS %d\n",
+		    __func__, __LINE__, sess->port_name, sess->disc_state);
+
 		switch (sess->disc_state) {
 		case DSC_DELETED:
 			qlt_plogi_ack_unref(vha, pla);
@@ -4786,12 +4801,20 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 
 		if (conflict_sess) {
-			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09b,
-			    "PRLI with conflicting sess %p port %8phC\n",
-			    conflict_sess, conflict_sess->port_name);
-			qlt_send_term_imm_notif(vha, iocb, 1);
-			res = 0;
-			break;
+			switch (conflict_sess->disc_state) {
+			case DSC_DELETED:
+			case DSC_DELETE_PEND:
+				break;
+			default:
+				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf09b,
+				    "PRLI with conflicting sess %p port %8phC\n",
+				    conflict_sess, conflict_sess->port_name);
+				conflict_sess->fw_login_state =
+				    DSC_LS_PORT_UNAVAIL;
+				qlt_send_term_imm_notif(vha, iocb, 1);
+				res = 0;
+				break;
+			}
 		}
 
 		if (sess != NULL) {
-- 
2.12.0
