From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 10/43] qla2xxx: Replace GPDB with async ADISC command
Date: Tue, 19 Dec 2017 22:56:11 -0800
Message-ID: <20171220065644.21511-11-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0059.outbound.protection.outlook.com ([104.47.36.59]:62584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932388AbdLTG5G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:06 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

Replace call to Get Port DataBase MB with PDO_FORCE_ADISC
flag with async ADISC command so driver can see ADISC command
has error or not.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  2 ++
 drivers/scsi/qla2xxx/qla_gs.c   | 20 +++++++-----
 drivers/scsi/qla2xxx/qla_init.c | 68 +++++++++++++++++++++++------------------
 3 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 8fbe1736a1a4..18b393453002 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2320,6 +2320,7 @@ enum discovery_state {
 	DSC_GPSC,
 	DSC_UPD_FCPORT,
 	DSC_LOGIN_COMPLETE,
+	DSC_ADISC,
 	DSC_DELETE_PEND,
 };
 
@@ -2346,6 +2347,7 @@ enum fcport_mgt_event {
 	FCME_GPNID_DONE,
 	FCME_GFFID_DONE,
 	FCME_DELETE_DONE,
+	FCME_ADISC_DONE,
 };
 
 enum rscn_addr_format {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 6aa6dd74fe86..b1c6485c307b 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2867,15 +2867,19 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 					    "%s %d %8phC post %s\n", __func__,
 					    __LINE__, fcport->port_name,
 					    (atomic_read(&fcport->state) ==
-					    FCS_ONLINE) ? "gpdb" : "gnl");
+					    FCS_ONLINE) ? "adisc" : "gnl");
 
 					if (atomic_read(&fcport->state) ==
-					    FCS_ONLINE)
-						qla24xx_post_gpdb_work(vha,
-						    fcport, PDO_FORCE_ADISC);
-					else
+					    FCS_ONLINE) {
+						u16 data[2];
+
+						data[0] = data[1] = 0;
+						qla2x00_post_async_adisc_work(
+						    vha, fcport, data);
+					} else {
 						qla24xx_post_gnl_work(vha,
 						    fcport);
+					}
 					break;
 				}
 			} else { /* fcport->d_id.b24 != ea->id.b24 */
@@ -3216,6 +3220,7 @@ void qla24xx_async_gpnid_done(scsi_qla_host_t *vha, srb_t *sp)
 void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
 	fc_port_t *fcport, *conflict, *t;
+	u16 data[2];
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "%s %d port_id: %06x\n",
@@ -3290,8 +3295,9 @@ void qla24xx_handle_gpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 				ql_dbg(ql_dbg_disc, vha, 0x210d,
 				    "%s %d %8phC revalidate session with ADISC\n",
 				    __func__, __LINE__, fcport->port_name);
-				qla24xx_post_gpdb_work(vha, fcport,
-				    PDO_FORCE_ADISC);
+				data[0] = data[1] = 0;
+				qla2x00_post_async_adisc_work(vha, fcport,
+				    data);
 				break;
 			case DSC_DELETED:
 				ql_dbg(ql_dbg_disc, vha, 0x210d,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 5cd04bfa5cae..0a1c287c2d66 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -41,6 +41,7 @@ static void qla24xx_handle_plogi_done_event(struct scsi_qla_host *,
     struct event_arg *);
 static void qla24xx_handle_prli_done_event(struct scsi_qla_host *,
     struct event_arg *);
+static void qla24xx_handle_gpdb_event(scsi_qla_host_t *, struct event_arg *);
 
 /* SRB Extensions ---------------------------------------------------------- */
 
@@ -277,17 +278,31 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
+static
+void qla24xx_handle_adisc_event(scsi_qla_host_t *vha, struct event_arg *ea)
+{
+	qla24xx_handle_gpdb_event(vha, ea);
+}
 
 static void
 qla2x00_async_adisc_sp_done(void *ptr, int res)
 {
 	srb_t *sp = ptr;
 	struct scsi_qla_host *vha = sp->vha;
-	struct srb_iocb *lio = &sp->u.iocb_cmd;
+	struct event_arg ea;
+
+	ql_dbg(ql_dbg_disc, vha, 0x2066,
+	    "Async done-%s res %x %8phC\n",
+	    sp->name, res, sp->fcport->port_name);
+
+	memset(&ea, 0, sizeof(ea));
+	ea.event = FCME_ADISC_DONE;
+	ea.rc = res;
+	ea.fcport = sp->fcport;
+	ea.sp = sp;
+
+	qla2x00_fcport_event_handler(vha, &ea);
 
-	if (!test_bit(UNLOADING, &vha->dpc_flags))
-		qla2x00_post_async_adisc_done_work(sp->vha, sp->fcport,
-		    lio->u.logio.data);
 	sp->free(sp);
 }
 
@@ -305,8 +320,11 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (!sp)
 		goto done;
 
+	fcport->disc_state = DSC_ADISC;
 	sp->type = SRB_ADISC_CMD;
 	sp->name = sp_to_str(SPCN_ADISC);
+	sp->gen1 = fcport->rscn_gen;
+	sp->gen2 = fcport->login_gen;
 	qla2x00_init_timer(sp, qla2x00_get_async_timeout(vha) + 2);
 
 	lio = &sp->u.iocb_cmd;
@@ -319,15 +337,15 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x206f,
-	    "Async-adisc - hdl=%x loopid=%x portid=%02x%02x%02x.\n",
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "Async-adisc - hdl=%x loopid=%x portid=%06x %8phC.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24, fcport->port_name);
 	return rval;
 
 done_free_sp:
 	sp->free(sp);
 done:
 	fcport->flags &= ~FCF_ASYNC_SENT;
+	qla2x00_post_async_adisc_work(vha, fcport, data);
 	return rval;
 }
 
@@ -869,7 +887,6 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	int rval = ea->rc;
 	fc_port_t *fcport = ea->fcport;
 	unsigned long flags;
-	u16 opt = ea->sp->u.iocb_cmd.u.mbx.out_mb[10];
 
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
@@ -900,8 +917,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	}
 
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
-	if (opt != PDO_FORCE_ADISC)
-		ea->fcport->login_gen++;
+	ea->fcport->login_gen++;
 	ea->fcport->deleted = 0;
 	ea->fcport->logout_on_delete = 1;
 
@@ -941,6 +957,7 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 
 int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
+	u16 data[2];
 	if (fcport->login_retry == 0)
 		return 0;
 
@@ -999,23 +1016,11 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			break;
 		}
 
-		if (fcport->flags & FCF_FCP2_DEVICE) {
-			u8 opt = PDO_FORCE_ADISC;
-
-			ql_dbg(ql_dbg_disc, vha, 0x20c9,
-			    "%s %d %8phC post gpdb\n",
-			    __func__, __LINE__, fcport->port_name);
-
-			fcport->disc_state = DSC_GPDB;
-			qla24xx_post_gpdb_work(vha, fcport, opt);
-		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x20cf,
-			    "%s %d %8phC post login\n",
-			    __func__, __LINE__, fcport->port_name);
-			fcport->disc_state = DSC_LOGIN_PEND;
-			qla2x00_post_async_login_work(vha, fcport, NULL);
-		}
-
+		ql_dbg(ql_dbg_disc, vha, 0x20cf,
+		    "%s %d %8phC post login\n",
+		    __func__, __LINE__, fcport->port_name);
+		fcport->disc_state = DSC_LOGIN_PEND;
+		qla2x00_post_async_login_work(vha, fcport, NULL);
 		break;
 
 	case DSC_LOGIN_FAILED:
@@ -1029,10 +1034,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	case DSC_LOGIN_COMPLETE:
 		/* recheck login state */
 		ql_dbg(ql_dbg_disc, vha, 0x20d1,
-		    "%s %d %8phC post gpdb\n",
+		    "%s %d %8phC post adisc\n",
 		    __func__, __LINE__, fcport->port_name);
-
-		qla24xx_post_gpdb_work(vha, fcport, PDO_FORCE_ADISC);
+		data[0] = data[1] = 0;
+		qla2x00_post_async_adisc_work(vha, fcport, data);
 		break;
 
 	default:
@@ -1264,6 +1269,9 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 	case FCME_DELETE_DONE:
 		qla24xx_handle_delete_done_event(vha, ea);
 		break;
+	case FCME_ADISC_DONE:
+		qla24xx_handle_adisc_event(vha, ea);
+		break;
 	default:
 		BUG_ON(1);
 		break;
-- 
2.12.0
