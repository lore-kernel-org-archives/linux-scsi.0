From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 25/25] qla2xxx: Simplify debug printing of portid.
Date: Fri, 19 May 2017 14:53:44 -0700
Message-ID: <20170519215344.2168-26-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-dm3nam03on0052.outbound.protection.outlook.com ([104.47.41.52]:1248
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756815AbdESWae (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 18:30:34 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_attr.c   |  4 +-
 drivers/scsi/qla2xxx/qla_bsg.c    | 15 +++----
 drivers/scsi/qla2xxx/qla_gs.c     | 54 +++++++++-----------------
 drivers/scsi/qla2xxx/qla_init.c   | 82 ++++++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_inline.h |  8 ++--
 drivers/scsi/qla2xxx/qla_iocb.c   | 18 ++++-----
 drivers/scsi/qla2xxx/qla_isr.c    | 58 +++++++++++----------------
 drivers/scsi/qla2xxx/qla_mbx.c    |  7 ++--
 8 files changed, 91 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index a7ac81b473a4..4ab771cc0c15 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -769,9 +769,7 @@ qla2x00_issue_logo(struct file *filp, struct kobject *kobj,
 	did.b.area = (type & 0x0000ff00) >> 8;
 	did.b.al_pa = (type & 0x000000ff);
 
-	ql_log(ql_log_info, vha, 0xd04d, "portid=%02x%02x%02x done\n",
-	    did.b.domain, did.b.area, did.b.al_pa);
-
+	ql_log(ql_log_info, vha, 0xd04d, "portid=%06x done\n", did.b24);
 	ql_log(ql_log_info, vha, 0x70e4, "%s: %d\n", __func__, type);
 
 	qla24xx_els_dcmd_iocb(vha, ELS_DCMD_LOGO, did);
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index eb2b873f12ba..7d025aec7b9d 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -382,10 +382,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	sp->done = qla2x00_bsg_job_done;
 
 	ql_dbg(ql_dbg_user, vha, 0x700a,
-	    "bsg rqst type: %s els type: %x - loop-id=%x "
-	    "portid=%-2x%02x%02x.\n", type,
-	    bsg_request->rqst_data.h_els.command_code, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "bsg rqst type: %s els type: %x - loop-id=%x portid=%06x.\n",
+	    type, bsg_request->rqst_data.h_els.command_code, fcport->loop_id,
+	    fcport->d_id.b24);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -529,11 +528,9 @@ qla2x00_process_ct(struct bsg_job *bsg_job)
 	sp->done = qla2x00_bsg_job_done;
 
 	ql_dbg(ql_dbg_user, vha, 0x7016,
-	    "bsg rqst type: %s else type: %x - "
-	    "loop-id=%x portid=%02x%02x%02x.\n", type,
-	    (bsg_request->rqst_data.h_ct.preamble_word2 >> 16),
-	    fcport->loop_id, fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa);
+	    "bsg rqst type: %s else type: %x - loop-id=%x portid=%06x.\n",
+	    type, bsg_request->rqst_data.h_ct.preamble_word2 >> 16,
+	    fcport->loop_id, fcport->d_id.b24);
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 7a2fe05baf4f..1b6fc3d80ec8 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -129,9 +129,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 	rval = QLA_FUNCTION_FAILED;
 	if (ms_pkt->entry_status != 0) {
 		ql_dbg(ql_dbg_disc, vha, 0x2031,
-		    "%s failed, error status (%x) on port_id: %02x%02x%02x.\n",
-		    routine, ms_pkt->entry_status, vha->d_id.b.domain,
-		    vha->d_id.b.area, vha->d_id.b.al_pa);
+		    "%s failed, error status (%x) on port_id: %06x.\n",
+		    routine, ms_pkt->entry_status, vha->d_id.b24);
 	} else {
 		if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
@@ -145,10 +144,9 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			if (ct_rsp->header.response !=
 			    cpu_to_be16(CT_ACCEPT_RESPONSE)) {
 				ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2077,
-				    "%s failed rejected request on port_id: %02x%02x%02x Completion status 0x%x, response 0x%x\n",
-				    routine, vha->d_id.b.domain,
-				    vha->d_id.b.area, vha->d_id.b.al_pa,
-				    comp_status, ct_rsp->header.response);
+				    "%s failed rejected request on port_id: %06x Compeltion status 0x%x, response 0x%x\n",
+				    routine, vha->d_id.b24, comp_status,
+				    ct_rsp->header.response);
 				ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha,
 				    0x2078, (uint8_t *)&ct_rsp->header,
 				    sizeof(struct ct_rsp_hdr));
@@ -178,10 +176,8 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 			break;
 		default:
 			ql_dbg(ql_dbg_disc, vha, 0x2033,
-			    "%s failed, completion status (%x) on port_id: "
-			    "%02x%02x%02x.\n", routine, comp_status,
-			    vha->d_id.b.domain, vha->d_id.b.area,
-			    vha->d_id.b.al_pa);
+			    "%s failed, completion status (%x) on port_id: %06x.\n",
+			    routine, comp_status, vha->d_id.b24);
 			break;
 		}
 	}
@@ -259,11 +255,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2063,
-		    "GA_NXT entry - nn %8phN pn %8phN "
-		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name, fcport->port_name,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
+		    "GA_NXT entry - nn %8phN pn %8phN port_id=%06x.\n",
+		    fcport->node_name, fcport->port_name, fcport->d_id.b24);
 	}
 
 	return (rval);
@@ -494,11 +487,9 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    ct_rsp->rsp.gnn_id.node_name, WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x2058,
-			    "GID_PT entry - nn %8phN pn %8phN "
-			    "portid=%02x%02x%02x.\n",
+			    "GID_PT entry - nn %8phN pn %8phN portid=%06x.\n",
 			    list[i].node_name, list[i].port_name,
-			    list[i].d_id.b.domain, list[i].d_id.b.area,
-			    list[i].d_id.b.al_pa);
+			    list[i].d_id.b24);
 		}
 
 		/* Last device exit. */
@@ -868,11 +859,8 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2061,
-		    "GA_NXT entry - nn %8phN pn %8phN "
-		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name, fcport->port_name,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
+		    "GA_NXT entry - nn %8phN pn %8phN port_id=%06x.\n",
+		    fcport->node_name, fcport->port_name, fcport->d_id.b24);
 	}
 
 	return (rval);
@@ -1055,11 +1043,9 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x206e,
-			    "GID_PT entry - nn %8phN pn %8phN "
-			    "port_id=%02x%02x%02x.\n",
+			    "GID_PT entry - nn %8phN pn %8phN port_id=%06x.\n",
 			    list[i].node_name, list[i].port_name,
-			    list[i].d_id.b.domain, list[i].d_id.b.area,
-			    list[i].d_id.b.al_pa);
+			    list[i].d_id.b24);
 		}
 
 		/* Last device exit. */
@@ -2919,10 +2905,9 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20a4,
-	    "Async-%s - %8phC hdl=%x loopid=%x portid %02x%02x%02x.\n",
+	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
 	    sp->name, fcport->port_name,
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    sp->handle, fcport->loop_id, fcport->d_id.b24);
 	return rval;
 
 done_free_sp:
@@ -3077,10 +3062,9 @@ int qla24xx_async_gpsc(scsi_qla_host_t *vha, fc_port_t *fcport)
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x205e,
-	    "Async-%s %8phC hdl=%x loopid=%x portid=%02x%02x%02x.\n",
+	    "Async-%s %8phC hdl=%x loopid=%x portid=%06x.\n",
 	    sp->name, fcport->port_name, sp->handle,
-	    fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    fcport->loop_id, fcport->d_id.b24);
 	return rval;
 
 done_free_sp:
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 497cba4ba72f..e44daf66e1d9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -202,10 +202,9 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	}
 
 	ql_dbg(ql_dbg_disc, vha, 0x2072,
-	    "Async-login - %8phC hdl=%x, loopid=%x portid=%02x%02x%02x "
-		"retries=%d.\n", fcport->port_name, sp->handle, fcport->loop_id,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
-	    fcport->login_retry);
+	    "Async-login - %8phC hdl=%x, loopid=%x portid=%06x retries=%d.\n",
+	    fcport->port_name, sp->handle, fcport->loop_id,
+	    fcport->d_id.b24, fcport->login_retry);
 	return rval;
 
 done_free_sp:
@@ -253,10 +252,8 @@ qla2x00_async_logout(struct scsi_qla_host *vha, fc_port_t *fcport)
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2070,
-	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-		fcport->d_id.b.area, fcport->d_id.b.al_pa,
-		fcport->port_name);
+	    "Async-logout - hdl=%x loop-id=%x portid=%06x %8phC.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24, fcport->port_name);
 	return rval;
 
 done_free_sp:
@@ -307,9 +304,8 @@ qla2x00_async_adisc(struct scsi_qla_host *vha, fc_port_t *fcport,
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_disc, vha, 0x206f,
-	    "Async-adisc - hdl=%x loopid=%x portid=%02x%02x%02x.\n",
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "Async-adisc - hdl=%x loopid=%x portid=%06x.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24);
 	return rval;
 
 done_free_sp:
@@ -359,10 +355,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	n = ea->data[0] / sizeof(struct get_name_list_extended);
 
 	ql_dbg(ql_dbg_disc, vha, 0x20e1,
-	    "%s %d %8phC n %d %02x%02x%02x lid %d \n",
-	    __func__, __LINE__, fcport->port_name, n,
-	    fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa, fcport->loop_id);
+	    "%s %d %8phC n %d %06x lid %d \n", __func__, __LINE__,
+	    fcport->port_name, n, fcport->d_id.b24, fcport->loop_id);
 
 	for (i = 0; i < n; i++) {
 		e = &vha->gnl.l[i];
@@ -381,12 +375,10 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		loop_id = (loop_id & 0x7fff);
 
 		ql_dbg(ql_dbg_disc, vha, 0x20e2,
-		    "%s found %8phC CLS [%d|%d] ID[%02x%02x%02x|%02x%02x%02x] lid[%d|%d]\n",
+		    "%s found %8phC CLS [%d|%d] ID[%06x|%06x] lid[%d|%d]\n",
 		    __func__, fcport->port_name,
 		    e->current_login_state, fcport->fw_login_state,
-		    id.b.domain, id.b.area, id.b.al_pa,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, loop_id, fcport->loop_id);
+		    id.b24, fcport->d_id.b24, loop_id, fcport->loop_id);
 
 		if ((id.b24 != fcport->d_id.b24) ||
 		    ((fcport->loop_id != FC_NO_LOOP_ID) &&
@@ -1071,9 +1063,8 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 				rc = qla24xx_post_gpnid_work(vha, &ea->id);
 				if (rc) {
 					ql_log(ql_log_warn, vha, 0xd044,
-					    "RSCN GPNID work failed %02x%02x%02x\n",
-					    ea->id.b.domain, ea->id.b.area,
-					    ea->id.b.al_pa);
+					    "RSCN GPNID work failed %06x\n",
+					    ea->id.b24);
 				}
 			} else {
 				ea->fcport = fcport;
@@ -1189,9 +1180,8 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 		goto done_free_sp;
 
 	ql_dbg(ql_dbg_taskm, vha, 0x802f,
-	    "Async-tmf hdl=%x loop-id=%x portid=%02x%02x%02x.\n",
-	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "Async-tmf hdl=%x loop-id=%x portid=%06x.\n",
+	    sp->handle, fcport->loop_id, fcport->d_id.b24);
 
 	wait_for_completion(&tm_iocb->u.tmf.comp);
 
@@ -1359,10 +1349,9 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 		break;
 	case MBS_PORT_ID_USED:
 		ql_dbg(ql_dbg_disc, vha, 0x20ed,
-		    "%s %d %8phC NPortId %02x%02x%02x inuse post gidpn\n",
-		    __func__, __LINE__, ea->fcport->port_name,
-		    ea->fcport->d_id.b.domain, ea->fcport->d_id.b.area,
-		    ea->fcport->d_id.b.al_pa);
+			"%s %d %8phC NPortId %06x inuse post gidpn\n",
+			__func__, __LINE__, ea->fcport->port_name,
+			ea->fcport->d_id.b24);
 
 		qla2x00_clear_loop_id(ea->fcport);
 		qla24xx_post_gidpn_work(vha, ea->fcport);
@@ -4667,10 +4656,7 @@ qla2x00_find_all_fabric_devs(scsi_qla_host_t *vha)
 			first_dev = 0;
 		} else if (new_fcport->d_id.b24 == wrap.b24) {
 			ql_dbg(ql_dbg_disc, vha, 0x209f,
-			    "Device wrap (%02x%02x%02x).\n",
-			    new_fcport->d_id.b.domain,
-			    new_fcport->d_id.b.area,
-			    new_fcport->d_id.b.al_pa);
+			    "Device wrap (%06x).\n", new_fcport->d_id.b24);
 			break;
 		}
 
@@ -4905,10 +4891,8 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 
 	for (;;) {
 		ql_dbg(ql_dbg_disc, vha, 0x2000,
-		    "Trying Fabric Login w/loop id 0x%04x for port "
-		    "%02x%02x%02x.\n",
-		    fcport->loop_id, fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+		    "Trying Fabric Login w/loop id 0x%04x for port %06x.\n",
+		    fcport->loop_id, fcport->d_id.b24);
 
 		/* Login fcport on switch. */
 		rval = ha->isp_ops->fabric_login(vha, fcport->loop_id,
@@ -4930,10 +4914,8 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			fcport->loop_id = mb[1];
 
 			ql_dbg(ql_dbg_disc, vha, 0x2001,
-			    "Fabric Login: port in use - next loop "
-			    "id=0x%04x, port id= %02x%02x%02x.\n",
-			    fcport->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+			    "Fabric Login: port in use - next loop id=0x%04x, port id= %06x.\n",
+			    fcport->loop_id, fcport->d_id.b24);
 
 		} else if (mb[0] == MBS_COMMAND_COMPLETE) {
 			/*
@@ -5001,10 +4983,8 @@ qla2x00_fabric_login(scsi_qla_host_t *vha, fc_port_t *fcport,
 			 * unrecoverable / not handled error
 			 */
 			ql_dbg(ql_dbg_disc, vha, 0x2002,
-			    "Failed=%x port_id=%02x%02x%02x loop_id=%x "
-			    "jiffies=%lx.\n", mb[0], fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa,
-			    fcport->loop_id, jiffies);
+			    "Failed=%x port_id=%06x loop_id=%x jiffies=%lx.\n",
+			    mb[0], fcport->d_id.b24, fcport->loop_id, jiffies);
 
 			*next_loopid = fcport->loop_id;
 			ha->isp_ops->fabric_logout(vha, fcport->loop_id,
@@ -7542,17 +7522,13 @@ qla24xx_update_fcport_fcp_prio(scsi_qla_host_t *vha, fc_port_t *fcport)
 	if (ret == QLA_SUCCESS) {
 		if (fcport->fcp_prio != priority)
 			ql_dbg(ql_dbg_user, vha, 0x709e,
-			    "Updated FCP_CMND priority - value=%d loop_id=%d "
-			    "port_id=%02x%02x%02x.\n", priority,
-			    fcport->loop_id, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+			    "Updated FCP_CMND priority - value=%d loop_id=%d port_id=%06x.\n",
+			    priority, fcport->loop_id, fcport->d_id.b24);
 		fcport->fcp_prio = priority & 0xf;
 	} else
 		ql_dbg(ql_dbg_user, vha, 0x704f,
-		    "Unable to update FCP_CMND priority - ret=0x%x for "
-		    "loop_id=%d port_id=%02x%02x%02x.\n", ret, fcport->loop_id,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
+		    "Unable to update FCP_CMND priority - ret=0x%x for loop_id=%d port_id=%06x.\n",
+		    ret, fcport->loop_id, fcport->d_id.b24);
 	return  ret;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 2ad74353f21e..bc55775f8a11 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -154,11 +154,9 @@ qla2x00_set_fcport_state(fc_port_t *fcport, int state)
 	/* Don't print state transitions during initial allocation of fcport */
 	if (old_state && old_state != state) {
 		ql_dbg(ql_dbg_disc, fcport->vha, 0x207d,
-		    "FCPort %8phC state transitioned from %s to %s - "
-			"portid=%02x%02x%02x.\n", fcport->port_name,
-		    port_state_str[old_state], port_state_str[state],
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa);
+		    "FCPort %8phC state transitioned from %s to %s - portid=%06x.\n",
+		    fcport->port_name, port_state_str[old_state],
+		    port_state_str[state], fcport->d_id.b24);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 8404f17f3c6c..34767a1d294e 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2366,9 +2366,8 @@ qla2x00_els_dcmd_iocb_timeout(void *data)
 	unsigned long flags = 0;
 
 	ql_dbg(ql_dbg_io, vha, 0x3069,
-	    "%s Timeout, hdl=%x, portid=%02x%02x%02x\n",
-	    sp->name, sp->handle, fcport->d_id.b.domain, fcport->d_id.b.area,
-	    fcport->d_id.b.al_pa);
+	    "%s Timeout, hdl=%x, portid=%06x\n",
+	    sp->name, sp->handle, fcport->d_id.b24);
 
 	/* Abort the exchange */
 	spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -2393,9 +2392,8 @@ qla2x00_els_dcmd_sp_done(void *ptr, int res)
 	struct scsi_qla_host *vha = sp->vha;
 
 	ql_dbg(ql_dbg_io, vha, 0x3072,
-	    "%s hdl=%x, portid=%02x%02x%02x done\n",
-	    sp->name, sp->handle, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "%s hdl=%x, portid=%06x done\n",
+	    sp->name, sp->handle, fcport->d_id.b24);
 
 	complete(&lio->u.els_logo.comp);
 }
@@ -2432,8 +2430,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	fcport->d_id.b.area = remote_did.b.area;
 	fcport->d_id.b.al_pa = remote_did.b.al_pa;
 
-	ql_dbg(ql_dbg_io, vha, 0x3073, "portid=%02x%02x%02x done\n",
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	ql_dbg(ql_dbg_io, vha, 0x3073, "portid=%06x done\n", fcport->d_id.b24);
 
 	sp->type = SRB_ELS_DCMD;
 	sp->name = "ELS_DCMD";
@@ -2472,9 +2469,8 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	}
 
 	ql_dbg(ql_dbg_io, vha, 0x3074,
-	    "%s LOGO sent, hdl=%x, loopid=%x, portid=%02x%02x%02x.\n",
-	    sp->name, sp->handle, fcport->loop_id, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+	    "%s LOGO sent, hdl=%x, loopid=%x, portid=%06x.\n",
+	    sp->name, sp->handle, fcport->loop_id, fcport->d_id.b24);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 3508c48a1eee..857418849dc7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1345,11 +1345,10 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	    QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (mbx->entry_status) {
 		ql_dbg(ql_dbg_async, vha, 0x5043,
-		    "Async-%s error entry - hdl=%x portid=%02x%02x%02x "
+		    "Async-%s error entry - hdl=%x portid=%06x "
 		    "entry-status=%x status=%x state-flag=%x "
 		    "status-flags=%x.\n", type, sp->handle,
-		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa, mbx->entry_status,
+		    fcport->d_id.b24, mbx->entry_status,
 		    le16_to_cpu(mbx->status), le16_to_cpu(mbx->state_flags),
 		    le16_to_cpu(mbx->status_flags));
 
@@ -1365,10 +1364,8 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 		status = 0;
 	if (!status && le16_to_cpu(mbx->mb0) == MBS_COMMAND_COMPLETE) {
 		ql_dbg(ql_dbg_async, vha, 0x5045,
-		    "Async-%s complete - hdl=%x portid=%02x%02x%02x mbx1=%x.\n",
-		    type, sp->handle, fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
-		    le16_to_cpu(mbx->mb1));
+		    "Async-%s complete - hdl=%x portid=%06x mbx1=%x.\n",
+		    type, sp->handle, fcport->d_id.b24, le16_to_cpu(mbx->mb1));
 
 		data[0] = MBS_COMMAND_COMPLETE;
 		if (sp->type == SRB_LOGIN_CMD) {
@@ -1394,10 +1391,10 @@ qla2x00_mbx_iocb_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	ql_log(ql_log_warn, vha, 0x5046,
-	    "Async-%s failed - hdl=%x portid=%02x%02x%02x status=%x "
-	    "mb0=%x mb1=%x mb2=%x mb6=%x mb7=%x.\n", type, sp->handle,
-	    fcport->d_id.b.domain, fcport->d_id.b.area, fcport->d_id.b.al_pa,
-	    status, le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
+	    "Async-%s failed - hdl=%x portid=%06x status=%x "
+	    "mb0=%x mb1=%x mb2=%x mb6=%x mb7=%x.\n",
+	    type, sp->handle, fcport->d_id.b24, status,
+	    le16_to_cpu(mbx->mb0), le16_to_cpu(mbx->mb1),
 	    le16_to_cpu(mbx->mb2), le16_to_cpu(mbx->mb6),
 	    le16_to_cpu(mbx->mb7));
 
@@ -1649,10 +1646,8 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 		QLA_LOGIO_LOGIN_RETRIED : 0;
 	if (logio->entry_status) {
 		ql_log(ql_log_warn, fcport->vha, 0x5034,
-		    "Async-%s error entry - %8phC hdl=%x"
-		    "portid=%02x%02x%02x entry-status=%x.\n",
-		    type, fcport->port_name, sp->handle, fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+		    "Async-%s error entry - %8phC hdl=%x portid=%06x entry-status=%x.\n",
+		    type, fcport->port_name, sp->handle, fcport->d_id.b24,
 		    logio->entry_status);
 		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x504d,
 		    (uint8_t *)logio, sizeof(*logio));
@@ -1662,10 +1657,8 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 
 	if (le16_to_cpu(logio->comp_status) == CS_COMPLETE) {
 		ql_dbg(ql_dbg_async, fcport->vha, 0x5036,
-		    "Async-%s complete - %8phC hdl=%x portid=%02x%02x%02x "
-		    "iop0=%x.\n", type, fcport->port_name, sp->handle,
-		    fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+		    "Async-%s complete - %8phC hdl=%x portid=%06x iop0=%x.\n",
+		    type, fcport->port_name, sp->handle, fcport->d_id.b24,
 		    le32_to_cpu(logio->io_parameter[0]));
 
 		vha->hw->exch_starvation = 0;
@@ -1736,10 +1729,9 @@ qla24xx_logio_entry(scsi_qla_host_t *vha, struct req_que *req,
 	}
 
 	ql_dbg(ql_dbg_async, fcport->vha, 0x5037,
-	    "Async-%s failed - %8phC hdl=%x portid=%02x%02x%02x comp=%x "
+	    "Async-%s failed - %8phC hdl=%x portid=%06x comp=%x "
 	    "iop0=%x iop1=%x.\n", type, fcport->port_name,
-	    sp->handle, fcport->d_id.b.domain,
-	    fcport->d_id.b.area, fcport->d_id.b.al_pa,
+	    sp->handle, fcport->d_id.b24,
 	    le16_to_cpu(logio->comp_status),
 	    le32_to_cpu(logio->io_parameter[0]),
 	    le32_to_cpu(logio->io_parameter[1]));
@@ -2513,11 +2505,10 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 
 		if (atomic_read(&fcport->state) == FCS_ONLINE) {
 			ql_dbg(ql_dbg_disc, fcport->vha, 0x3021,
-				"Port to be marked lost on fcport=%02x%02x%02x, current "
-				"port state= %s comp_status %x.\n", fcport->d_id.b.domain,
-				fcport->d_id.b.area, fcport->d_id.b.al_pa,
-				port_state_str[atomic_read(&fcport->state)],
-				comp_status);
+			    "Port to be marked lost on fcport=%06x, current port state=%s comp_status=%x.\n",
+			    fcport->d_id.b24,
+			    port_state_str[atomic_read(&fcport->state)],
+			    comp_status);
 
 			if (no_logout)
 				fcport->logout_on_delete = 0;
@@ -2557,14 +2548,11 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 out:
 	if (logit)
 		ql_dbg(ql_dbg_io, fcport->vha, 0x3022,
-		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu "
-		    "portid=%02x%02x%02x oxid=0x%x cdb=%10phN len=0x%x "
-		    "rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
-		    comp_status, scsi_status, res, vha->host_no,
-		    cp->device->id, cp->device->lun, fcport->d_id.b.domain,
-		    fcport->d_id.b.area, fcport->d_id.b.al_pa, ox_id,
-		    cp->cmnd, scsi_bufflen(cp), rsp_info_len,
-		    resid_len, fw_resid_len, sp, cp);
+		    "FCP command status: 0x%x-0x%x (0x%x) nexus=%ld:%d:%llu portid=%06x oxid=0x%x cdb=%10phN len=0x%x rsp_info=0x%x resid=0x%x fw_resid=0x%x sp=%p cp=%p.\n",
+		    comp_status, scsi_status, res, vha->host_no, cp->device->id,
+		    cp->device->lun, fcport->d_id.b24, ox_id, cp->cmnd,
+		    scsi_bufflen(cp), rsp_info_len, resid_len, fw_resid_len,
+		    sp, cp);
 
 	if (rsp->status_srb == NULL)
 		sp->done(sp, res);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 864a2db3a317..f5c42ffacee9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1783,10 +1783,9 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
 		    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
 			ql_dbg(ql_dbg_mbx, vha, 0x100a,
-			    "Unable to verify login-state (%x/%x) - "
-			    "portid=%02x%02x%02x.\n", pd->master_state,
-			    pd->slave_state, fcport->d_id.b.domain,
-			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
+			    "Unable to verify login-state (%x/%x) - portid=%06x.\n",
+			    pd->master_state, pd->slave_state,
+			    fcport->d_id.b24);
 			rval = QLA_FUNCTION_FAILED;
 			goto gpd_error_out;
 		}
-- 
2.12.0
