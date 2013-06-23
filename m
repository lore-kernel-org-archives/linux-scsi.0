From: Oleksandr Khoshaba <oleksandr.khoshaba@gmail.com>
Subject: [PATCH 1/1] scsi: qla2xxx: change some variables to hexadecimal string via %*phC or %*phN format
Date: Sun, 23 Jun 2013 15:26:42 +0300
Message-ID: <1371990402-2884-1-git-send-email-Oleksandr.Khoshaba@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:52252 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3FWM0v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Jun 2013 08:26:51 -0400
Received: by mail-ee0-f47.google.com with SMTP id e49so5356489eek.20
        for <linux-scsi@vger.kernel.org>; Sun, 23 Jun 2013 05:26:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Oleksandr Khoshaba <khoshaba@mail.ru>, Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>

The patch modifies some variables using the format '%*ph[CN]' and prints them as a hexadecimal string with the separator ':' or ''.

Signed-off-by: Oleksandr Khoshaba <Oleksandr.Khoshaba@gmail.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c     |    8 +---
 drivers/scsi/qla2xxx/qla_gs.c      |   82 ++++++------------------------------
 drivers/scsi/qla2xxx/qla_init.c    |   25 +++--------
 drivers/scsi/qla2xxx/qla_os.c      |   10 +----
 drivers/scsi/qla2xxx/qla_target.c  |   74 +++++++++-----------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |   18 +++-----
 6 files changed, 51 insertions(+), 166 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 39719f8..8e19079 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1333,12 +1333,8 @@ qla24xx_iidma(struct fc_bsg_job *bsg_job)
 
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x704c,
-		    "iIDMA cmd failed for %02x%02x%02x%02x%02x%02x%02x%02x -- "
-		    "%04x %x %04x %04x.\n", fcport->port_name[0],
-		    fcport->port_name[1], fcport->port_name[2],
-		    fcport->port_name[3], fcport->port_name[4],
-		    fcport->port_name[5], fcport->port_name[6],
-		    fcport->port_name[7], rval, fcport->fp_speed, mb[0], mb[1]);
+		    "iIDMA cmd failed for %8phN -- %04x %x %04x %04x.\n",
+		    fcport->port_name, rval, fcport->fp_speed, mb[0], mb[1]);
 		rval = (DID_ERROR << 16);
 	} else {
 		if (!port_param->mode) {
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index d0ea8b9..8b2f75a 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -226,17 +226,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2063,
-		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name[0], fcport->node_name[1],
-		    fcport->node_name[2], fcport->node_name[3],
-		    fcport->node_name[4], fcport->node_name[5],
-		    fcport->node_name[6], fcport->node_name[7],
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
+		    "GA_NXT entry - nn %8phN pn %8phN port_id=%02x%02x%02x.\n",
+		    fcport->node_name, fcport->port_name,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa);
 	}
@@ -448,17 +439,9 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    ct_rsp->rsp.gnn_id.node_name, WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x2058,
-			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02X%02x "
-			    "pn %02x%02x%02x%02x%02x%02x%02X%02x "
+			    "GID_PT entry - nn %8phN pn %8phN "
 			    "portid=%02x%02x%02x.\n",
-			    list[i].node_name[0], list[i].node_name[1],
-			    list[i].node_name[2], list[i].node_name[3],
-			    list[i].node_name[4], list[i].node_name[5],
-			    list[i].node_name[6], list[i].node_name[7],
-			    list[i].port_name[0], list[i].port_name[1],
-			    list[i].port_name[2], list[i].port_name[3],
-			    list[i].port_name[4], list[i].port_name[5],
-			    list[i].port_name[6], list[i].port_name[7],
+			    list[i].node_name, list[i].port_name,
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
 			    list[i].d_id.b.al_pa);
 		}
@@ -798,17 +781,8 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 			fcport->d_id.b.domain = 0xf0;
 
 		ql_dbg(ql_dbg_disc, vha, 0x2061,
-		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "port_id=%02x%02x%02x.\n",
-		    fcport->node_name[0], fcport->node_name[1],
-		    fcport->node_name[2], fcport->node_name[3],
-		    fcport->node_name[4], fcport->node_name[5],
-		    fcport->node_name[6], fcport->node_name[7],
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
+		    "GA_NXT entry - nn %8phN pn %8phN port_id=%02x%02x%02x.\n",
+		    fcport->node_name, fcport->port_name,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa);
 	}
@@ -993,17 +967,9 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    WWN_SIZE);
 
 			ql_dbg(ql_dbg_disc, vha, 0x206e,
-			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
-			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
+			    "GID_PT entry - nn %8phN pn %8phN "
 			    "port_id=%02x%02x%02x.\n",
-			    list[i].node_name[0], list[i].node_name[1],
-			    list[i].node_name[2], list[i].node_name[3],
-			    list[i].node_name[4], list[i].node_name[5],
-			    list[i].node_name[6], list[i].node_name[7],
-			    list[i].port_name[0], list[i].port_name[1],
-			    list[i].port_name[2], list[i].port_name[3],
-			    list[i].port_name[4], list[i].port_name[5],
-			    list[i].port_name[6], list[i].port_name[7],
+			    list[i].node_name, list[i].port_name,
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
 			    list[i].d_id.b.al_pa);
 		}
@@ -1324,11 +1290,7 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	size += 4 + WWN_SIZE;
 
 	ql_dbg(ql_dbg_disc, vha, 0x2025,
-	    "NodeName = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    eiter->a.node_name[0], eiter->a.node_name[1],
-	    eiter->a.node_name[2], eiter->a.node_name[3],
-	    eiter->a.node_name[4], eiter->a.node_name[5],
-	    eiter->a.node_name[6], eiter->a.node_name[7]);
+	    "NodeName = %8phN.\n", eiter->a.node_name);
 
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1499,11 +1461,7 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 	memcpy(ct_req->req.dhba.port_name, vha->port_name, WWN_SIZE);
 
 	ql_dbg(ql_dbg_disc, vha, 0x2036,
-	    "DHBA portname = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    ct_req->req.dhba.port_name[0], ct_req->req.dhba.port_name[1],
-	    ct_req->req.dhba.port_name[2], ct_req->req.dhba.port_name[3],
-	    ct_req->req.dhba.port_name[4], ct_req->req.dhba.port_name[5],
-	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]);
+	    "DHBA portname = %8phN.\n", ct_req->req.dhba.port_name);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
@@ -1684,12 +1642,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
 	ql_dbg(ql_dbg_disc, vha, 0x203e,
-	    "RPA portname= %02x%02x%02x%02x%02X%02x%02x%02x size=%d.\n",
-	    ct_req->req.rpa.port_name[0], ct_req->req.rpa.port_name[1],
-	    ct_req->req.rpa.port_name[2], ct_req->req.rpa.port_name[3],
-	    ct_req->req.rpa.port_name[4], ct_req->req.rpa.port_name[5],
-	    ct_req->req.rpa.port_name[6], ct_req->req.rpa.port_name[7],
-	    size);
+	    "RPA portname= %8pnN size=%d.\n",
+	    ct_req->req.rpa.port_name, size);
 	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2079,
 	    entries, size);
 
@@ -1945,17 +1899,9 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 			}
 
 			ql_dbg(ql_dbg_disc, vha, 0x205b,
-			    "GPSC ext entry - fpn "
-			    "%02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
+			    "GPSC ext entry - fpn %8phN speeds=%04x "
 			    "speed=%04x.\n",
-			    list[i].fabric_port_name[0],
-			    list[i].fabric_port_name[1],
-			    list[i].fabric_port_name[2],
-			    list[i].fabric_port_name[3],
-			    list[i].fabric_port_name[4],
-			    list[i].fabric_port_name[5],
-			    list[i].fabric_port_name[6],
-			    list[i].fabric_port_name[7],
+			    list[i].fabric_port_name,
 			    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
 			    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
 		}
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3565dfd..9e8b30a 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -564,12 +564,8 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 	if (ha->flags.disable_serdes) {
 		/* Mask HBA via NVRAM settings? */
 		ql_log(ql_log_info, vha, 0x0077,
-		    "Masking HBA WWPN "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x (via NVRAM).\n",
-		    vha->port_name[0], vha->port_name[1],
-		    vha->port_name[2], vha->port_name[3],
-		    vha->port_name[4], vha->port_name[5],
-		    vha->port_name[6], vha->port_name[7]);
+		    "Masking HBA WWPN %8phN (via NVRAM).\n",
+		    vha->port_name);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -3069,22 +3065,13 @@ qla2x00_iidma_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    mb);
 	if (rval != QLA_SUCCESS) {
 		ql_dbg(ql_dbg_disc, vha, 0x2004,
-		    "Unable to adjust iIDMA "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x -- %04x %x %04x "
-		    "%04x.\n", fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7], rval,
-		    fcport->fp_speed, mb[0], mb[1]);
+		    "Unable to adjust iIDMA %8phN -- %04x %x %04x %04x.\n",
+		    fcport->port_name, rval, fcport->fp_speed, mb[0], mb[1]);
 	} else {
 		ql_dbg(ql_dbg_disc, vha, 0x2005,
-		    "iIDMA adjusted to %s GB/s "
-		    "on %02x%02x%02x%02x%02x%02x%02x%02x.\n",
+		    "iIDMA adjusted to %s GB/s on %8phN.\n",
 		    qla2x00_get_link_speed_str(ha, fcport->fp_speed),
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]);
+		    fcport->port_name);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad72c1d..75ba850 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3214,14 +3214,8 @@ void qla2x00_mark_device_lost(scsi_qla_host_t *vha, fc_port_t *fcport,
 		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 
 		ql_dbg(ql_dbg_disc, vha, 0x2067,
-		    "Port login retry "
-		    "%02x%02x%02x%02x%02x%02x%02x%02x, "
-		    "id = 0x%04x retry cnt=%d.\n",
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    fcport->loop_id, fcport->login_retry);
+		    "Port login retry %8phN, id = 0x%04x retry cnt=%d.\n",
+		    fcport->port_name, fcport->loop_id, fcport->login_retry);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index fcdc223..37e7e9f 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -431,13 +431,8 @@ static int qlt_reset(struct scsi_qla_host *vha, void *iocb, int mcmd)
 
 	ql_dbg(ql_dbg_tgt, vha, 0xe047,
 	    "scsi(%ld): resetting (session %p from port "
-	    "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x, "
-	    "mcmd %x, loop_id %d)\n", vha->host_no, sess,
-	    sess->port_name[0], sess->port_name[1],
-	    sess->port_name[2], sess->port_name[3],
-	    sess->port_name[4], sess->port_name[5],
-	    sess->port_name[6], sess->port_name[7],
-	    mcmd, loop_id);
+	    "%8phC, mcmd %x, loop_id %d)\n", vha->host_no, sess,
+	    sess->port_name, mcmd, loop_id);
 
 	lun = a->u.isp24.fcp_cmnd.lun;
 	unpacked_lun = scsilun_to_int((struct scsi_lun *)&lun);
@@ -467,14 +462,9 @@ static void qlt_schedule_sess_for_deletion(struct qla_tgt_sess *sess,
 	sess->expires = jiffies + dev_loss_tmo * HZ;
 
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe048,
-	    "qla_target(%d): session for port %02x:%02x:%02x:"
-	    "%02x:%02x:%02x:%02x:%02x (loop ID %d) scheduled for "
-	    "deletion in %u secs (expires: %lu) immed: %d\n",
-	    sess->vha->vp_idx,
-	    sess->port_name[0], sess->port_name[1],
-	    sess->port_name[2], sess->port_name[3],
-	    sess->port_name[4], sess->port_name[5],
-	    sess->port_name[6], sess->port_name[7],
+	    "qla_target(%d): session for port %8phC (loop ID %d) scheduled"
+	    " for deletion in %u secs (expires: %lu) immed: %d\n",
+	    sess->vha->vp_idx, sess->port_name,
 	    sess->loop_id, dev_loss_tmo, sess->expires, immediate);
 
 	if (immediate)
@@ -682,15 +672,9 @@ static void qlt_del_sess_work_fn(struct delayed_work *work)
 				}
 
 				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf049,
-				    "qla_target(%d): cancel deletion of "
-				    "session for port %02x:%02x:%02x:%02x:%02x:"
-				    "%02x:%02x:%02x (loop ID %d), because "
-				    " it isn't deleted by firmware",
-				    vha->vp_idx, sess->port_name[0],
-				    sess->port_name[1], sess->port_name[2],
-				    sess->port_name[3], sess->port_name[4],
-				    sess->port_name[5], sess->port_name[6],
-				    sess->port_name[7], sess->loop_id);
+				    "qla_target(%d): cancel deletion of session for port %8phC (loop ID %d), because it isn't deleted by firmware",
+				    vha->vp_idx, sess->port_name,
+				    sess->loop_id);
 			} else {
 				ql_dbg(ql_dbg_tgt_mgt, vha, 0xf004,
 				    "Timeout: sess %p about to be deleted\n",
@@ -756,13 +740,9 @@ static struct qla_tgt_sess *qlt_create_sess(
 	sess = kzalloc(sizeof(*sess), GFP_KERNEL);
 	if (!sess) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04a,
-		    "qla_target(%u): session allocation failed, "
-		    "all commands from port %02x:%02x:%02x:%02x:"
-		    "%02x:%02x:%02x:%02x will be refused", vha->vp_idx,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7]);
+		    "qla_target(%u): session allocation failed, all commands "
+		    "from port %8phC will be refused",
+		    vha->vp_idx, fcport->port_name);
 
 		return NULL;
 	}
@@ -806,13 +786,10 @@ static struct qla_tgt_sess *qlt_create_sess(
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04b,
-	    "qla_target(%d): %ssession for wwn %02x:%02x:%02x:%02x:"
-	    "%02x:%02x:%02x:%02x (loop_id %d, s_id %x:%x:%x, confirmed"
-	    " completion %ssupported) added\n",
-	    vha->vp_idx, local ?  "local " : "", fcport->port_name[0],
-	    fcport->port_name[1], fcport->port_name[2], fcport->port_name[3],
-	    fcport->port_name[4], fcport->port_name[5], fcport->port_name[6],
-	    fcport->port_name[7], fcport->loop_id, sess->s_id.b.domain,
+	    "qla_target(%d): %ssession for wwn %8phC (loop_id %d, s_id "
+	    "%x:%x:%x, confirmed completion %ssupported) added\n",
+	    vha->vp_idx, local ?  "local " : "", fcport->port_name,
+	    fcport->loop_id, sess->s_id.b.domain,
 	    sess->s_id.b.area, sess->s_id.b.al_pa, sess->conf_compl_supported ?
 	    "" : "not ");
 
@@ -856,14 +833,10 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 			qlt_undelete_sess(sess);
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04c,
-			    "qla_target(%u): %ssession for port %02x:"
-			    "%02x:%02x:%02x:%02x:%02x:%02x:%02x (loop ID %d) "
-			    "reappeared\n", vha->vp_idx, sess->local ? "local "
-			    : "", sess->port_name[0], sess->port_name[1],
-			    sess->port_name[2], sess->port_name[3],
-			    sess->port_name[4], sess->port_name[5],
-			    sess->port_name[6], sess->port_name[7],
-			    sess->loop_id);
+			    "qla_target(%u): %ssession for port %8phC"
+			    " (loop ID %d) reappeared\n",
+			    vha->vp_idx, sess->local ? "local "
+			    : "", sess->port_name, sess->loop_id);
 
 			ql_dbg(ql_dbg_tgt_mgt, vha, 0xf007,
 			    "Reappeared sess %p\n", sess);
@@ -874,14 +847,9 @@ void qlt_fc_port_added(struct scsi_qla_host *vha, fc_port_t *fcport)
 
 	if (sess && sess->local) {
 		ql_dbg(ql_dbg_tgt_mgt, vha, 0xf04d,
-		    "qla_target(%u): local session for "
-		    "port %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x "
+		    "qla_target(%u): local session for port %8phC "
 		    "(loop ID %d) became global\n", vha->vp_idx,
-		    fcport->port_name[0], fcport->port_name[1],
-		    fcport->port_name[2], fcport->port_name[3],
-		    fcport->port_name[4], fcport->port_name[5],
-		    fcport->port_name[6], fcport->port_name[7],
-		    sess->loop_id);
+		    fcport->port_name, sess->loop_id);
 		sess->local = 0;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 7a3870f..330a6ca 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -1424,9 +1424,7 @@ static int tcm_qla2xxx_check_initiator_node_acl(
 	 * match the format by tcm_qla2xxx explict ConfigFS NodeACLs.
 	 */
 	memset(&port_name, 0, 36);
-	snprintf(port_name, 36, "%02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x",
-		fc_wwpn[0], fc_wwpn[1], fc_wwpn[2], fc_wwpn[3], fc_wwpn[4],
-		fc_wwpn[5], fc_wwpn[6], fc_wwpn[7]);
+	snprintf(port_name, 36, "%8phC", fc_wwpn);
 	/*
 	 * Locate our struct se_node_acl either from an explict NodeACL created
 	 * via ConfigFS, or via running in TPG demo mode.
@@ -1470,15 +1468,11 @@ static void tcm_qla2xxx_update_sess(struct qla_tgt_sess *sess, port_id_t s_id,
 
 
 	if (sess->loop_id != loop_id || sess->s_id.b24 != s_id.b24)
-		pr_info("Updating session %p from port %02x:%02x:%02x:%02x:%02x:%02x:%02x:%02x loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
-			sess,
-			sess->port_name[0], sess->port_name[1],
-			sess->port_name[2], sess->port_name[3],
-			sess->port_name[4], sess->port_name[5],
-			sess->port_name[6], sess->port_name[7],
-			sess->loop_id, loop_id,
-			sess->s_id.b.domain, sess->s_id.b.area, sess->s_id.b.al_pa,
-			s_id.b.domain, s_id.b.area, s_id.b.al_pa);
+		pr_info("Updating session %p from port %8phC loop_id %d -> %d s_id %x:%x:%x -> %x:%x:%x\n",
+			sess, sess->port_name, sess->loop_id, loop_id,
+			sess->s_id.b.domain, sess->s_id.b.area,
+			sess->s_id.b.al_pa, s_id.b.domain, s_id.b.area,
+			s_id.b.al_pa);
 
 	if (sess->loop_id != loop_id) {
 		/*
-- 
1.7.9.5

