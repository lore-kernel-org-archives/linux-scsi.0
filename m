From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 31/43] qla2xxx: Add ability to use GPNFT/GNNFT for RSCN handling
Date: Tue, 19 Dec 2017 22:56:32 -0800
Message-ID: <20171220065644.21511-32-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0072.outbound.protection.outlook.com ([104.47.37.72]:10627
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932480AbdLTG5X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:23 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

add ability to use gpnft/gnnft to handle RSCN.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |  7 +++
 drivers/scsi/qla2xxx/qla_gbl.h  |  1 +
 drivers/scsi/qla2xxx/qla_gs.c   | 99 ++++++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_init.c | 65 ++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_os.c   |  1 +
 5 files changed, 113 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index db1f68c3e074..f061483475ce 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3022,6 +3022,11 @@ struct ct_sns_gpnft_pkt {
 	} p;
 };
 
+enum scan_flags_t {
+	SF_SCANNING = BIT_0,
+	SF_QUEUED = BIT_1,
+};
+
 struct fab_scan_rp {
 	port_id_t id;
 	u8 port_name[8];
@@ -3031,6 +3036,8 @@ struct fab_scan_rp {
 struct fab_scan {
 	struct fab_scan_rp *l;
 	u32 size;
+	enum scan_flags_t scan_flags;
+	struct delayed_work scan_work;
 };
 
 /*
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 650ec54e3255..91db1924ca79 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -669,6 +669,7 @@ int qla24xx_post_gfpnid_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *ea);
 void qla24xx_sp_unmap(scsi_qla_host_t *, srb_t *);
+void qla_scan_work_fn(struct work_struct *);
 
 /*
  * Global Function Prototypes in qla_attr.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 0fcbdcaba127..903f924f6273 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3025,8 +3025,10 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fc_port_t *fcport = ea->fcport;
 
 	ql_dbg(ql_dbg_disc, vha, 0x201d,
-	    "%s %8phC login state %d\n",
-	    __func__, fcport->port_name, fcport->fw_login_state);
+	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d lid %d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, ea->rc, fcport->login_gen, ea->sp->gen2,
+	    fcport->rscn_gen, ea->sp->gen1, fcport->loop_id);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -3034,9 +3036,9 @@ void qla24xx_handle_gidpn_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* PLOGI/PRLI/LOGO came in while cmd was out.*/
 		ql_dbg(ql_dbg_disc, vha, 0x201e,
-		    "%s %8phC generation changed rscn %d|%d login %d|%d \n",
+		    "%s %8phC generation changed rscn %d|%d n",
 		    __func__, fcport->port_name, fcport->last_rscn_gen,
-		    fcport->rscn_gen, fcport->last_login_gen, fcport->login_gen);
+		    fcport->rscn_gen);
 		return;
 	}
 
@@ -3264,11 +3266,10 @@ void qla24xx_handle_gpsc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	struct fc_port *fcport = ea->fcport;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d rscn %d|%d login %d|%d lid %d\n",
+	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d lid %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
-	    fcport->fw_login_state, fcport->last_rscn_gen, fcport->rscn_gen,
-	    fcport->last_login_gen, fcport->login_gen,
-	    fcport->loop_id);
+	    fcport->fw_login_state, ea->rc, ea->sp->gen2, fcport->login_gen,
+	    ea->sp->gen2, fcport->rscn_gen|ea->sp->gen1, fcport->loop_id);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -3276,10 +3277,8 @@ void qla24xx_handle_gpsc_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
 		ql_dbg(ql_dbg_disc, vha, 0x20d3,
-		    "%s %8phC generation changed rscn %d|%d login %d|%d\n",
-		    __func__, fcport->port_name, fcport->last_rscn_gen,
-		    fcport->rscn_gen, fcport->last_login_gen,
-		    fcport->login_gen);
+		    "%s %8phC generation changed\n",
+		    __func__, fcport->port_name);
 		return;
 	} else if (ea->sp->gen1 != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20d4, "%s %d %8phC post gidpn\n",
@@ -3911,6 +3910,7 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 	bool found;
 	u8 fc4type = sp->gen2;
 	struct fab_scan_rp *rp;
+	unsigned long flags;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "%s enter\n", __func__);
@@ -3988,16 +3988,15 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 		if ((fcport->flags & FCF_FABRIC_DEVICE) == 0)
 			continue;
 
-		if (fcport->scan_state == QLA_FCPORT_SCAN) {
+		if (fcport->scan_state != QLA_FCPORT_FOUND) {
 			if ((qla_dual_mode_enabled(vha) ||
 				qla_ini_mode_enabled(vha)) &&
 			    atomic_read(&fcport->state) == FCS_ONLINE) {
 				qla2x00_mark_device_lost(vha, fcport,
 				    ql2xplogiabsentdevice, 0);
+
 				if (fcport->loop_id != FC_NO_LOOP_ID &&
-				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
-				    fcport->port_type != FCT_INITIATOR &&
-				    fcport->port_type != FCT_BROADCAST) {
+				    (fcport->flags & FCF_FCP2_DEVICE) == 0) {
 					ql_dbg(ql_dbg_disc, vha, 0x20f0,
 					    "%s %d %8phC post del sess\n",
 					    __func__, __LINE__,
@@ -4008,14 +4007,16 @@ void qla24xx_async_gnnft_done(scsi_qla_host_t *vha, srb_t *sp)
 					continue;
 				}
 			}
-		}
-
-		if (fcport->scan_state == QLA_FCPORT_FOUND)
+		} else
 			qla24xx_fcport_handle_login(vha, fcport);
 	}
 
 out:
 	qla24xx_sp_unmap(vha, sp);
+
+	spin_lock_irqsave(&vha->work_lock, flags);
+	vha->scan.scan_flags &= ~SF_SCANNING;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
 
 static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
@@ -4044,6 +4045,9 @@ static void qla2x00_async_gpnft_gnnft_sp_done(void *s, int res)
 		    "Async done-%s timed out.\n",
 		    sp->name);
 		sp->free(sp);
+		spin_lock_irqsave(&vha->work_lock, flags);
+		vha->scan.scan_flags &= ~SF_SCANNING;
+		spin_unlock_irqrestore(&vha->work_lock, flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
@@ -4135,14 +4139,17 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	struct ct_sns_req *ct_req;
 	struct ct_sns_pkt *ct_sns;
 
-	if (!vha->flags.online)
+	if (!vha->flags.online) {
+		vha->scan.scan_flags &= ~SF_SCANNING;
 		goto done_free_sp;
+	}
 
 	if (!sp->u.iocb_cmd.u.ctarg.req || !sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "%s: req %p rsp %p are not setup\n",
 		    __func__, sp->u.iocb_cmd.u.ctarg.req,
 		    sp->u.iocb_cmd.u.ctarg.rsp);
+		vha->scan.scan_flags &= ~SF_SCANNING;
 		WARN_ON(1);
 		goto done_free_sp;
 	}
@@ -4170,8 +4177,10 @@ static int qla24xx_async_gnnft(scsi_qla_host_t *vha, struct srb *sp,
 	sp->done = qla2x00_async_gpnft_gnnft_sp_done;
 
 	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
+		vha->scan.scan_flags &= ~SF_SCANNING;
 		goto done_free_sp;
+	}
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
 	    "Async-%s hdl=%x FC4Type %x.\n", sp->name,
@@ -4215,14 +4224,25 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type)
 	srb_t *sp;
 	struct ct_sns_pkt *ct_sns;
 	u32 rspsz;
+	unsigned long flags;
 
 	if (!vha->flags.online)
 		return rval;
 
-	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
-	if (!sp)
+	spin_lock_irqsave(&vha->work_lock, flags);
+	if (vha->scan.scan_flags & SF_SCANNING) {
+		spin_unlock_irqrestore(&vha->work_lock, flags);
+		ql_dbg(ql_dbg_disc, vha, 0xffff, "scan active\n");
 		return rval;
+	}
+	vha->scan.scan_flags |= SF_SCANNING;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
 
+	sp = qla2x00_get_sp(vha, NULL, GFP_KERNEL);
+	if (!sp) {
+		vha->scan.scan_flags &= ~SF_SCANNING;
+		return rval;
+	}
 
 	sp->type = SRB_CT_PTHRU_CMD;
 	sp->name = sp_to_str(SPCN_GPNFT);
@@ -4236,6 +4256,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type)
 	if (!sp->u.iocb_cmd.u.ctarg.req) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "Failed to allocate ct_sns request.\n");
+		vha->scan.scan_flags &= ~SF_SCANNING;
 		goto done_free_sp;
 	}
 
@@ -4248,6 +4269,7 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type)
 	if (!sp->u.iocb_cmd.u.ctarg.rsp) {
 		ql_log(ql_log_warn, vha, 0xffff,
 		    "Failed to allocate ct_sns request.\n");
+		vha->scan.scan_flags &= ~SF_SCANNING;
 		goto done_free_sp;
 	}
 
@@ -4297,6 +4319,24 @@ int qla24xx_async_gpnft(scsi_qla_host_t *vha, u8 fc4_type)
 	return rval;
 }
 
+void qla_scan_work_fn(struct work_struct *work)
+{
+	struct fab_scan *s = container_of(to_delayed_work(work),
+	    struct fab_scan, scan_work);
+	struct scsi_qla_host *vha = container_of(s, struct scsi_qla_host,
+	    scan);
+	unsigned long flags;
+
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s: schedule loop resync\n", __func__);
+	set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
+	set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+	qla2xxx_wake_dpc(vha);
+	spin_lock_irqsave(&vha->work_lock, flags);
+	vha->scan.scan_flags &= ~SF_QUEUED;
+	spin_unlock_irqrestore(&vha->work_lock, flags);
+}
+
 /* GNN_ID */
 void qla24xx_handle_gnnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
@@ -4416,9 +4456,10 @@ void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fc_port_t *fcport = ea->fcport;
 
 	ql_dbg(ql_dbg_disc, vha, 0xffff,
-	    "%s %d %8phC post gpsc fcp_cnt %d\n",
-	    __func__, __LINE__, fcport->port_name,
-	    vha->fcport_count);
+	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d fcpcnt %d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, ea->rc, fcport->login_gen, ea->sp->gen2,
+	    fcport->rscn_gen, ea->sp->gen1, vha->fcport_count);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -4426,10 +4467,8 @@ void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
 		ql_dbg(ql_dbg_disc, vha, 0x20d3,
-		    "%s %8phC generation changed rscn %d|%d login %d|%d\n",
-		    __func__, fcport->port_name, fcport->last_rscn_gen,
-		    fcport->rscn_gen, fcport->last_login_gen,
-		    fcport->login_gen);
+		    "%s %8phC generation changed\n",
+		    __func__, fcport->port_name);
 		return;
 	} else if (ea->sp->gen1 != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20d4, "%s %d %8phC post gidpn\n",
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index bd28a0e6a95c..ac3f82340315 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -455,6 +455,12 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 	u8 current_login_state;
 
 	fcport = ea->fcport;
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %8phC DS %d LS rc %d %d login %d|%d rscn %d|%d lid %d\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, ea->rc,
+	    fcport->login_gen, fcport->last_login_gen,
+	    fcport->rscn_gen, fcport->last_rscn_gen, vha->loop_id);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -478,9 +484,8 @@ static void qla24xx_handle_gnl_done_event(scsi_qla_host_t *vha,
 		return;
 	} else if (fcport->last_login_gen != fcport->login_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20e0,
-		    "%s %8phC login gen changed login %d|%d\n",
-		    __func__, fcport->port_name,
-		    fcport->last_login_gen, fcport->login_gen);
+		    "%s %8phC login gen changed\n",
+		    __func__, fcport->port_name);
 		return;
 	}
 
@@ -1060,7 +1065,6 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 static
 void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-	int rval = ea->rc;
 	fc_port_t *fcport = ea->fcport;
 	struct port_database_24xx *pd;
 	struct srb *sp = ea->sp;
@@ -1070,8 +1074,8 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	fcport->flags &= ~FCF_ASYNC_SENT;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d2,
-	    "%s %8phC DS %d LS %d rval %d\n", __func__, fcport->port_name,
-	    fcport->disc_state, pd->current_login_state, rval);
+	    "%s %8phC DS %d LS %d rc %d\n", __func__, fcport->port_name,
+	    fcport->disc_state, pd->current_login_state, ea->rc);
 
 	if (fcport->disc_state == DSC_DELETE_PEND)
 		return;
@@ -1141,11 +1145,11 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 	u64 wwn;
 
 	ql_dbg(ql_dbg_disc, vha, 0x20d8,
-	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d|%d retry %d lid %d scan %d\n",
+	    "%s %8phC DS %d LS %d P %d fl %x confl %p rscn %d|%d login %d retry %d lid %d scan %d\n",
 	    __func__, fcport->port_name, fcport->disc_state,
 	    fcport->fw_login_state, fcport->login_pause, fcport->flags,
 	    fcport->conflict, fcport->last_rscn_gen, fcport->rscn_gen,
-	    fcport->last_login_gen, fcport->login_gen, fcport->login_retry,
+	    fcport->login_gen, fcport->login_retry,
 	    fcport->loop_id, fcport->scan_state);
 
 	if (fcport->login_retry == 0)
@@ -1322,9 +1326,9 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 
 void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-	fc_port_t *fcport, *f, *tf;
+	fc_port_t *f, *tf;
 	uint32_t id = 0, mask, rid;
-	int rc;
+	unsigned long flags;
 
 	switch (ea->event) {
 	case FCME_RSCN:
@@ -1352,20 +1356,15 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 			return;
 		switch (ea->id.b.rsvd_1) {
 		case RSCN_PORT_ADDR:
-			fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
-			if (!fcport) {
-				/* cable moved */
-				rc = qla24xx_post_gpnid_work(vha, &ea->id);
-				if (rc) {
-					ql_log(ql_log_warn, vha, 0xd044,
-					    "RSCN GPNID work failed %02x%02x%02x\n",
-					    ea->id.b.domain, ea->id.b.area,
-					    ea->id.b.al_pa);
-				}
-			} else {
-				ea->fcport = fcport;
-				qla24xx_handle_rscn_event(fcport, ea);
+			spin_lock_irqsave(&vha->work_lock, flags);
+			if (vha->scan.scan_flags == 0) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s: schedule\n", __func__);
+				vha->scan.scan_flags |= SF_QUEUED;
+				schedule_delayed_work(&vha->scan.scan_work, 5);
 			}
+			spin_unlock_irqrestore(&vha->work_lock, flags);
+
 			break;
 		case RSCN_AREA_ADDR:
 		case RSCN_DOM_ADDR:
@@ -1644,6 +1643,13 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 	unsigned long flags;
 	struct fc_port *fcport = ea->fcport;
 
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %8phC DS %d LS %d rc %d login %d|%d rscn %d|%d data %x|%x iop %x|%x\n",
+	    __func__, fcport->port_name, fcport->disc_state,
+	    fcport->fw_login_state, ea->rc, ea->sp->gen2, fcport->login_gen,
+	    ea->sp->gen2, fcport->rscn_gen|ea->sp->gen1,
+	    ea->data[0], ea->data[1], ea->iop[0], ea->iop[1]);
+
 	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
 	    (fcport->fw_login_state == DSC_LS_PRLI_PEND)) {
 		ql_dbg(ql_dbg_disc, vha, 0x20ea,
@@ -1658,10 +1664,9 @@ qla24xx_handle_plogi_done_event(struct scsi_qla_host *vha, struct event_arg *ea)
 	if (ea->sp->gen2 != fcport->login_gen) {
 		/* target side must have changed it. */
 		ql_dbg(ql_dbg_disc, vha, 0x20d3,
-		    "%s %8phC generation changed rscn %d|%d login %d|%d\n",
-		    __func__, fcport->port_name, fcport->last_rscn_gen,
-		    fcport->rscn_gen, fcport->last_login_gen,
-		    fcport->login_gen);
+		    "%s %8phC generation changed\n",
+		    __func__, fcport->port_name);
+		set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 		return;
 	} else if (ea->sp->gen1 != fcport->rscn_gen) {
 		ql_dbg(ql_dbg_disc, vha, 0x20d4, "%s %d %8phC post gidpn\n",
@@ -5252,9 +5257,6 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			}
 		}
 
-		list_for_each_entry(fcport, &vha->vp_fcports, list) {
-			fcport->scan_state = QLA_FCPORT_SCAN;
-		}
 
 		/* Mark the time right before querying FW for connected ports.
 		 * This process is long, asynchronous and by the time it's done,
@@ -5270,6 +5272,9 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 			if (rval)
 				set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		} else  {
+			list_for_each_entry(fcport, &vha->vp_fcports, list)
+				fcport->scan_state = QLA_FCPORT_SCAN;
+
 			rval = qla2x00_find_all_fabric_devs(vha);
 		}
 		if (rval != QLA_SUCCESS)
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d4a967410893..77fa8809cf4a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4589,6 +4589,7 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 		scsi_remove_host(vha->host);
 		return NULL;
 	}
+	INIT_DELAYED_WORK(&vha->scan.scan_work, qla_scan_work_fn);
 
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
-- 
2.12.0
