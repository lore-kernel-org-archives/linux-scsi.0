From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 19/43] qla2xxx: Fix session cleanup for N2N
Date: Tue, 19 Dec 2017 22:56:20 -0800
Message-ID: <20171220065644.21511-20-himanshu.madhani@cavium.com>
References: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:10624
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932433AbdLTG5P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Dec 2017 01:57:15 -0500
In-Reply-To: <20171220065644.21511-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

When connection type is N_Port to N_Port (point-to-point), there
is a possibilty where initiator will not send PLOGI request and
will directly send PRLI. In N2N connection the port has higher
port name sends the PLOGI but not allow to send PRLI if is a
target mode. Only initiator is allowed to send PRLI.

Current driver code deletes old session when it receives PLOGI
request. If we will not receive PLOGI request then we will not
delete old session and create new session. Add check for N2N
with PRLI receive only and trigger cleanup. For this case, the
cleanup requires individual cmd abort instead of using implicit
logout as a broad stroke flush.

Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Alexei Potashnik <alexei@purestorage.com>
Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  11 ++
 drivers/scsi/qla2xxx/qla_fw.h     |   2 +-
 drivers/scsi/qla2xxx/qla_init.c   | 151 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_isr.c    |   4 +-
 drivers/scsi/qla2xxx/qla_mbx.c    |  38 ++++-
 drivers/scsi/qla2xxx/qla_os.c     |  41 +++++-
 drivers/scsi/qla2xxx/qla_target.c | 286 +++++++++++++++++++++++++-------------
 7 files changed, 378 insertions(+), 155 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ba659aa9ae83..9fcc0a5ff8df 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -3575,6 +3575,7 @@ struct qla_hw_data {
 		uint32_t	fw_init_done:1;
 		uint32_t	detected_lr_sfp:1;
 		uint32_t	using_lr_setting:1;
+		uint32_t	rida_fmt2:1;
 	} flags;
 
 	uint16_t max_exchg;
@@ -4615,6 +4616,16 @@ struct sff_8247_a0 {
 #define USER_CTRL_IRQ(_ha) (ql2xuctrlirq && QLA_TGT_MODE_ENABLED() && \
 	(IS_QLA27XX(_ha) || IS_QLA83XX(_ha)))
 
+#define SAVE_TOPO(_ha) { \
+	if (_ha->current_topology)				\
+		_ha->prev_topology = _ha->current_topology;     \
+}
+
+#define N2N_TOPO(ha) \
+	((ha->prev_topology == ISP_CFG_N && !ha->current_topology) || \
+	 ha->current_topology == ISP_CFG_N || \
+	 !ha->current_topology)
+
 #include "qla_target.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index d5cef0727e72..5d8688e5bc7c 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1392,7 +1392,7 @@ struct vp_rpt_id_entry_24xx {
 
 		    uint8_t port_name[8];
 		    uint8_t node_name[8];
-		    uint32_t remote_nport_id;
+		    uint8_t remote_nport_id[4];
 		    uint32_t reserved_5;
 		} f2;
 	} u;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 7a8c6ead6d0e..b4a96c80853f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -181,11 +181,6 @@ qla2x00_async_login(struct scsi_qla_host *vha, fc_port_t *fcport,
 	if (!vha->flags.online)
 		goto done;
 
-	if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
-	    (fcport->fw_login_state == DSC_LS_PLOGI_COMP) ||
-	    (fcport->fw_login_state == DSC_LS_PRLI_PEND))
-		goto done;
-
 	sp = qla2x00_get_sp(vha, fcport, GFP_KERNEL);
 	if (!sp)
 		goto done;
@@ -1016,6 +1011,43 @@ void qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 } /* gpdb event */
 
+
+static void qla_chk_n2n_b4_login(struct scsi_qla_host *vha, fc_port_t *fcport)
+{
+	u8 login = 0;
+
+	if (qla_tgt_mode_enabled(vha))
+		return;
+
+	if (qla_dual_mode_enabled(vha)) {
+		if (N2N_TOPO(vha->hw)) {
+			u64 mywwn, wwn;
+
+			mywwn = wwn_to_u64(vha->port_name);
+			wwn = wwn_to_u64(fcport->port_name);
+			if (mywwn > wwn)
+				login = 1;
+			else if ((fcport->fw_login_state == DSC_LS_PLOGI_COMP)
+			    && time_after_eq(jiffies,
+				    fcport->plogi_nack_done_deadline))
+				login = 1;
+		} else {
+			login = 1;
+		}
+	} else {
+		/* initiator mode */
+		login = 1;
+	}
+
+	if (login) {
+		ql_dbg(ql_dbg_disc, vha, 0x20bf,
+		    "%s %d %8phC post login\n",
+		    __func__, __LINE__, fcport->port_name);
+		fcport->disc_state = DSC_LOGIN_PEND;
+		qla2x00_post_async_login_work(vha, fcport, NULL);
+	}
+}
+
 int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	u16 data[2];
@@ -1040,8 +1072,10 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 		return 0;
 
 	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
-		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline))
+		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			return 0;
+		}
 	}
 
 	/* for pure Target Mode. Login will not be initiated */
@@ -1061,11 +1095,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			    __func__, __LINE__, fcport->port_name);
 			qla24xx_post_gnl_work(vha, fcport);
 		} else {
-			ql_dbg(ql_dbg_disc, vha, 0x20bf,
-			    "%s %d %8phC post login\n",
-			    __func__, __LINE__, fcport->port_name);
-			fcport->disc_state = DSC_LOGIN_PEND;
-			qla2x00_post_async_login_work(vha, fcport, NULL);
+			qla_chk_n2n_b4_login(vha, fcport);
 		}
 		break;
 
@@ -1077,19 +1107,17 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			break;
 		}
 
-		ql_dbg(ql_dbg_disc, vha, 0x20cf,
-		    "%s %d %8phC post login\n",
-		    __func__, __LINE__, fcport->port_name);
-		fcport->disc_state = DSC_LOGIN_PEND;
-		qla2x00_post_async_login_work(vha, fcport, NULL);
+		qla_chk_n2n_b4_login(vha, fcport);
 		break;
 
 	case DSC_LOGIN_FAILED:
 		ql_dbg(ql_dbg_disc, vha, 0x20d0,
 		    "%s %d %8phC post gidpn\n",
 		    __func__, __LINE__, fcport->port_name);
-
-		qla24xx_post_gidpn_work(vha, fcport);
+		if (N2N_TOPO(vha->hw))
+			qla_chk_n2n_b4_login(vha, fcport);
+		else
+			qla24xx_post_gidpn_work(vha, fcport);
 		break;
 
 	case DSC_LOGIN_COMPLETE:
@@ -1196,8 +1224,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 		return;
 
 	if (fcport->fw_login_state == DSC_LS_PLOGI_COMP) {
-		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline))
+		if (time_before_eq(jiffies, fcport->plogi_nack_done_deadline)) {
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
 			return;
+		}
 	}
 
 	if (fcport->flags & FCF_ASYNC_SENT) {
@@ -4473,6 +4503,21 @@ qla2x00_configure_loop(scsi_qla_host_t *vha)
 
 	} else if (ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
+		if (ha->flags.rida_fmt2) {
+			/* With Rida Format 2, the login is already triggered.
+			 * We know who is on the other side of the wire.
+			 * No need to login to do login to find out or drop into
+			 * qla2x00_configure_local_loop().
+			 */
+			clear_bit(LOCAL_LOOP_UPDATE, &flags);
+			set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+		} else {
+			if (qla_tgt_mode_enabled(vha)) {
+				/* allow the other side to start the login */
+				clear_bit(LOCAL_LOOP_UPDATE, &flags);
+				set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
+			}
+		}
 	} else if (ha->current_topology == ISP_CFG_NL) {
 		clear_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
@@ -4701,6 +4746,10 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	    (uint8_t *)ha->gid_list,
 	    entries * sizeof(struct gid_list_info));
 
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		fcport->scan_state = QLA_FCPORT_SCAN;
+	}
+
 	/* Allocate temporary fcport for any new fcports discovered. */
 	new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
 	if (new_fcport == NULL) {
@@ -4711,22 +4760,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 	}
 	new_fcport->flags &= ~FCF_FABRIC_DEVICE;
 
-	/*
-	 * Mark local devices that were present with FCF_DEVICE_LOST for now.
-	 */
-	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		if (atomic_read(&fcport->state) == FCS_ONLINE &&
-		    fcport->port_type != FCT_BROADCAST &&
-		    (fcport->flags & FCF_FABRIC_DEVICE) == 0) {
-
-			ql_dbg(ql_dbg_disc, vha, 0x2096,
-			    "Marking port lost loop_id=0x%04x.\n",
-			    fcport->loop_id);
-
-			qla2x00_mark_device_lost(vha, fcport, 0, 0);
-		}
-	}
-
 	/* Inititae N2N login. */
 	if (test_and_clear_bit(N2N_LOGIN_NEEDED, &vha->dpc_flags)) {
 		rval = qla24xx_n2n_handle_login(vha, new_fcport);
@@ -4769,6 +4802,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		new_fcport->d_id.b.area = area;
 		new_fcport->d_id.b.al_pa = al_pa;
 		new_fcport->loop_id = loop_id;
+		new_fcport->scan_state = QLA_FCPORT_FOUND;
 
 		rval2 = qla2x00_get_port_database(vha, new_fcport, 0);
 		if (rval2 != QLA_SUCCESS) {
@@ -4800,13 +4834,7 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 			fcport->d_id.b24 = new_fcport->d_id.b24;
 			memcpy(fcport->node_name, new_fcport->node_name,
 			    WWN_SIZE);
-
-			if (!fcport->login_succ) {
-				vha->fcport_count++;
-				fcport->login_succ = 1;
-				fcport->disc_state = DSC_LOGIN_COMPLETE;
-			}
-
+			fcport->scan_state = QLA_FCPORT_FOUND;
 			found++;
 			break;
 		}
@@ -4817,11 +4845,6 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 
 			/* Allocate a new replacement fcport. */
 			fcport = new_fcport;
-			if (!fcport->login_succ) {
-				vha->fcport_count++;
-				fcport->login_succ = 1;
-				fcport->disc_state = DSC_LOGIN_COMPLETE;
-			}
 
 			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
@@ -4842,11 +4865,39 @@ qla2x00_configure_local_loop(scsi_qla_host_t *vha)
 		/* Base iIDMA settings on HBA port speed. */
 		fcport->fp_speed = ha->link_data_rate;
 
-		qla2x00_update_fcport(vha, fcport);
-
 		found_devs++;
 	}
 
+	list_for_each_entry(fcport, &vha->vp_fcports, list) {
+		if (test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags))
+			break;
+
+		if (fcport->scan_state == QLA_FCPORT_SCAN) {
+			if ((qla_dual_mode_enabled(vha) ||
+			    qla_ini_mode_enabled(vha)) &&
+			    atomic_read(&fcport->state) == FCS_ONLINE) {
+				qla2x00_mark_device_lost(vha, fcport,
+					ql2xplogiabsentdevice, 0);
+				if (fcport->loop_id != FC_NO_LOOP_ID &&
+				    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
+				    fcport->port_type != FCT_INITIATOR &&
+				    fcport->port_type != FCT_BROADCAST) {
+					ql_dbg(ql_dbg_disc, vha, 0x20f0,
+					    "%s %d %8phC post del sess\n",
+					    __func__, __LINE__,
+					    fcport->port_name);
+
+					qlt_schedule_sess_for_deletion_lock
+						(fcport);
+					continue;
+				}
+			}
+		}
+
+		if (fcport->scan_state == QLA_FCPORT_FOUND)
+			qla24xx_fcport_handle_login(vha, fcport);
+	}
+
 cleanup_allocation:
 	kfree(new_fcport);
 
@@ -6154,6 +6205,8 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 	if (!(IS_P3P_TYPE(ha)))
 		ha->isp_ops->reset_chip(vha);
 
+	SAVE_TOPO(ha);
+	ha->flags.rida_fmt2 = 0;
 	ha->flags.n2n_ae = 0;
 	ha->flags.lip_ae = 0;
 	ha->current_topology = 0;
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 7ae8d4d22952..f02c98b3e8a7 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -809,6 +809,7 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		break;
 
 	case MBA_LOOP_DOWN:		/* Loop Down Event */
+		SAVE_TOPO(ha);
 		ha->flags.n2n_ae = 0;
 		ha->flags.lip_ae = 0;
 		ha->current_topology = 0;
@@ -922,7 +923,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
 		set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
 
-		ha->flags.gpsc_supported = 1;
 		vha->flags.management_server_logged_in = 0;
 		break;
 
@@ -1060,8 +1060,6 @@ qla2x00_async_event(scsi_qla_host_t *vha, struct rsp_que *rsp, uint16_t *mb)
 		 */
 		atomic_set(&vha->loop_state, LOOP_UP);
 
-		qla2x00_mark_all_devices_lost(vha, 1);
-
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0c8ad7b31294..acf6c7c0f2c8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3733,6 +3733,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	unsigned long   flags;
 	int found;
 	port_id_t id;
+	struct fc_port *fcport;
 
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b6,
 	    "Entered %s.\n", __func__);
@@ -3755,7 +3756,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		    "Primary port id %02x%02x%02x.\n",
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
-
+		ha->current_topology = ISP_CFG_NL;
 		qlt_update_host_map(vha, id);
 
 	} else if (rptid_entry->format == 1) {
@@ -3799,6 +3800,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 			return;
 		}
 
+		ha->flags.gpsc_supported = 1;
+		ha->current_topology = ISP_CFG_F;
 		/* buffer to buffer credit flag */
 		vha->flags.bbcr_enable = (rptid_entry->u.f1.bbcr & 0xf) != 0;
 
@@ -3864,6 +3867,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		    rptid_entry->u.f2.port_name);
 
 		/* N2N.  direct connect */
+		ha->current_topology = ISP_CFG_N;
+		ha->flags.rida_fmt2 = 1;
 		vha->d_id.b.domain = rptid_entry->port_id[2];
 		vha->d_id.b.area = rptid_entry->port_id[1];
 		vha->d_id.b.al_pa = rptid_entry->port_id[0];
@@ -3871,6 +3876,37 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 		spin_lock_irqsave(&ha->vport_slock, flags);
 		qlt_update_vp_map(vha, SET_AL_PA);
 		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
+		list_for_each_entry(fcport, &vha->vp_fcports, list) {
+			fcport->scan_state = QLA_FCPORT_SCAN;
+		}
+
+		fcport = qla2x00_find_fcport_by_wwpn(vha,
+		    rptid_entry->u.f2.port_name, 1);
+
+		if (fcport) {
+			fcport->plogi_nack_done_deadline = jiffies + HZ;
+			fcport->scan_state = QLA_FCPORT_FOUND;
+			switch (fcport->disc_state) {
+			case DSC_DELETED:
+				ql_dbg(ql_dbg_disc, vha, 0x210d,
+				    "%s %d %8phC login\n",
+				    __func__, __LINE__, fcport->port_name);
+				qla24xx_fcport_handle_login(vha, fcport);
+				break;
+			case DSC_DELETE_PEND:
+				break;
+			default:
+				qlt_schedule_sess_for_deletion_lock(fcport);
+				break;
+			}
+		} else {
+			id.b.al_pa  = rptid_entry->u.f2.remote_nport_id[0];
+			id.b.area   = rptid_entry->u.f2.remote_nport_id[1];
+			id.b.domain = rptid_entry->u.f2.remote_nport_id[2];
+			qla24xx_post_newsess_work(vha, &id,
+			    rptid_entry->u.f2.port_name, NULL);
+		}
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 13550a8584ca..4ba249b9921d 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4750,6 +4750,10 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	    (struct qlt_plogi_ack_t *)e->u.new_sess.pla;
 	uint8_t free_fcport = 0;
 
+	ql_dbg(ql_dbg_disc, vha, 0xffff,
+	    "%s %d %8phC enter\n",
+	    __func__, __LINE__, e->u.new_sess.port_name);
+
 	spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 	fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
 	if (fcport) {
@@ -4811,7 +4815,31 @@ void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 
 	if (fcport) {
+		if (N2N_TOPO(vha->hw))
+			fcport->flags &= ~FCF_FABRIC_DEVICE;
+
 		if (pla) {
+			if (pla->iocb.u.isp24.status_subcode == ELS_PRLI) {
+				u16 wd3_lo;
+
+				fcport->fw_login_state = DSC_LS_PRLI_PEND;
+				fcport->local = 0;
+				fcport->loop_id =
+					le16_to_cpu(
+					    pla->iocb.u.isp24.nport_handle);
+				fcport->fw_login_state = DSC_LS_PRLI_PEND;
+				wd3_lo =
+				    le16_to_cpu(
+					pla->iocb.u.isp24.u.prli.wd3_lo);
+
+				if (wd3_lo & BIT_7)
+					fcport->conf_compl_supported = 1;
+
+				if ((wd3_lo & BIT_4) == 0)
+					fcport->port_type = FCT_INITIATOR;
+				else
+					fcport->port_type = FCT_TARGET;
+			}
 			qlt_plogi_ack_unref(vha, pla);
 		} else {
 			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
@@ -4974,14 +5002,13 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 	struct event_arg ea;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-	/*
-	 * If the port is not ONLINE then try to login
-	 * to it if we haven't run out of retries.
-	 */
+		/*
+		 * If the port is not ONLINE then try to login
+		 * to it if we haven't run out of retries.
+		 */
 		if (atomic_read(&fcport->state) != FCS_ONLINE &&
 		    fcport->login_retry && !(fcport->flags & FCF_ASYNC_SENT)) {
-
-			if (fcport->flags & FCF_FABRIC_DEVICE) {
+			if (vha->hw->current_topology != ISP_CFG_NL) {
 				ql_dbg(ql_dbg_disc, fcport->vha, 0x2108,
 				    "%s %8phC DS %d LS %d\n", __func__,
 				    fcport->port_name, fcport->disc_state,
@@ -4990,7 +5017,7 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 				ea.event = FCME_RELOGIN;
 				ea.fcport = fcport;
 				qla2x00_fcport_event_handler(vha, &ea);
-			} else {
+			} else if (vha->hw->current_topology == ISP_CFG_NL) {
 				fcport->login_retry--;
 				status = qla2x00_local_device_login(vha,
 								fcport);
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index eaa43d3d5a91..71be1a95ba86 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -607,7 +607,7 @@ void qla2x00_async_nack_sp_done(void *s, int res)
 				    __func__, __LINE__,
 				    sp->fcport->port_name,
 				    vha->fcport_count);
-
+				sp->fcport->disc_state = DSC_UPD_FCPORT;
 				qla24xx_post_upd_fcport_work(vha, sp->fcport);
 			} else {
 				ql_dbg(ql_dbg_disc, vha, 0x20f5,
@@ -862,7 +862,10 @@ void qlt_plogi_ack_unref(struct scsi_qla_host *vha,
 
 	fcport->loop_id = loop_id;
 	fcport->d_id = port_id;
-	qla24xx_post_nack_work(vha, fcport, iocb, SRB_NACK_PLOGI);
+	if (iocb->u.isp24.status_subcode == ELS_PLOGI)
+		qla24xx_post_nack_work(vha, fcport, iocb, SRB_NACK_PLOGI);
+	else
+		qla24xx_post_nack_work(vha, fcport, iocb, SRB_NACK_PRLI);
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
 		if (fcport->plogi_link[QLT_PLOGI_LINK_SAME_WWN] == pla)
@@ -968,6 +971,8 @@ static void qlt_free_session_done(struct work_struct *work)
 	bool logout_started = false;
 	struct event_arg ea;
 	scsi_qla_host_t *base_vha;
+	struct qlt_plogi_ack_t *own =
+		sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
@@ -989,13 +994,28 @@ static void qlt_free_session_done(struct work_struct *work)
 		if (sess->logout_on_delete && sess->loop_id != FC_NO_LOOP_ID) {
 			int rc;
 
-			rc = qla2x00_post_async_logout_work(vha, sess, NULL);
-			if (rc != QLA_SUCCESS)
-				ql_log(ql_log_warn, vha, 0xf085,
-				    "Schedule logo failed sess %p rc %d\n",
-				    sess, rc);
-			else
-				logout_started = true;
+			if (!own ||
+			    (own &&
+			     (own->iocb.u.isp24.status_subcode == ELS_PLOGI))) {
+				rc = qla2x00_post_async_logout_work(vha, sess,
+				    NULL);
+				if (rc != QLA_SUCCESS)
+					ql_log(ql_log_warn, vha, 0xf085,
+					    "Schedule logo failed sess %p rc %d\n",
+					    sess, rc);
+				else
+					logout_started = true;
+			} else if (own && (own->iocb.u.isp24.status_subcode ==
+				ELS_PRLI) && ha->flags.rida_fmt2) {
+				rc = qla2x00_post_async_prlo_work(vha, sess,
+				    NULL);
+				if (rc != QLA_SUCCESS)
+					ql_log(ql_log_warn, vha, 0xf085,
+					    "Schedule PRLO failed sess %p rc %d\n",
+					    sess, rc);
+				else
+					logout_started = true;
+			}
 		}
 	}
 
@@ -1019,7 +1039,7 @@ static void qlt_free_session_done(struct work_struct *work)
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
-		    "%s: sess %p logout completed\n",__func__, sess);
+		    "%s: sess %p logout completed\n", __func__, sess);
 	}
 
 	if (sess->logo_ack_needed) {
@@ -1055,8 +1075,6 @@ static void qlt_free_session_done(struct work_struct *work)
 	}
 
 	{
-		struct qlt_plogi_ack_t *own =
-		    sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN];
 		struct qlt_plogi_ack_t *con =
 		    sess->plogi_link[QLT_PLOGI_LINK_CONFLICT];
 		struct imm_ntfy_from_isp *iocb;
@@ -1216,6 +1234,8 @@ void qlt_schedule_sess_for_deletion(struct fc_port *sess,
 	ql_dbg(ql_dbg_tgt, sess->vha, 0xe001,
 	    "Scheduling sess %p for deletion\n", sess);
 
+	/* use cancel to push work element through before re-queue */
+	cancel_work_sync(&sess->del_work);
 	INIT_WORK(&sess->del_work, qla24xx_delete_sess_fn);
 	queue_work(sess->vha->hw->wq, &sess->del_work);
 }
@@ -4688,6 +4708,130 @@ static int abort_cmds_for_s_id(struct scsi_qla_host *vha, port_id_t *s_id)
 	return count;
 }
 
+static int qlt_handle_login(struct scsi_qla_host *vha,
+    struct imm_ntfy_from_isp *iocb)
+{
+	struct fc_port *sess = NULL, *conflict_sess = NULL;
+	uint64_t wwn;
+	port_id_t port_id;
+	uint16_t loop_id, wd3_lo;
+	int res = 0;
+	struct qlt_plogi_ack_t *pla;
+	unsigned long flags;
+
+	wwn = wwn_to_u64(iocb->u.isp24.port_name);
+
+	port_id.b.domain = iocb->u.isp24.port_id[2];
+	port_id.b.area   = iocb->u.isp24.port_id[1];
+	port_id.b.al_pa  = iocb->u.isp24.port_id[0];
+	port_id.b.rsvd_1 = 0;
+
+	loop_id = le16_to_cpu(iocb->u.isp24.nport_handle);
+
+	/* Mark all stale commands sitting in qla_tgt_wq for deletion */
+	abort_cmds_for_s_id(vha, &port_id);
+
+	if (wwn) {
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
+		sess = qlt_find_sess_invalidate_other(vha, wwn,
+		    port_id, loop_id, &conflict_sess);
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	}
+
+	if (IS_SW_RESV_ADDR(port_id)) {
+		res = 1;
+		goto out;
+	}
+
+	pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
+	if (!pla) {
+		qlt_send_term_imm_notif(vha, iocb, 1);
+		goto out;
+	}
+
+	if (conflict_sess) {
+		conflict_sess->login_gen++;
+		qlt_plogi_ack_link(vha, pla, conflict_sess,
+		    QLT_PLOGI_LINK_CONFLICT);
+	}
+
+	if (!sess) {
+		pla->ref_count++;
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %d %8phC post new sess\n",
+		    __func__, __LINE__, iocb->u.isp24.port_name);
+		qla24xx_post_newsess_work(vha, &port_id,
+		    iocb->u.isp24.port_name, pla);
+		goto out;
+	}
+
+	qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
+	sess->d_id = port_id;
+	sess->login_gen++;
+
+	if (iocb->u.isp24.status_subcode == ELS_PRLI) {
+		sess->fw_login_state = DSC_LS_PRLI_PEND;
+		sess->local = 0;
+		sess->loop_id = loop_id;
+		sess->d_id = port_id;
+		sess->fw_login_state = DSC_LS_PRLI_PEND;
+		wd3_lo = le16_to_cpu(iocb->u.isp24.u.prli.wd3_lo);
+
+		if (wd3_lo & BIT_7)
+			sess->conf_compl_supported = 1;
+
+		if ((wd3_lo & BIT_4) == 0)
+			sess->port_type = FCT_INITIATOR;
+		else
+			sess->port_type = FCT_TARGET;
+
+	} else
+		sess->fw_login_state = DSC_LS_PLOGI_PEND;
+
+
+	ql_dbg(ql_dbg_disc, vha, 0x20f9,
+	    "%s %d %8phC  DS %d\n",
+	    __func__, __LINE__, sess->port_name, sess->disc_state);
+
+	switch (sess->disc_state) {
+	case DSC_DELETED:
+		qlt_plogi_ack_unref(vha, pla);
+		break;
+
+	default:
+		/*
+		 * Under normal circumstances we want to release nport handle
+		 * during LOGO process to avoid nport handle leaks inside FW.
+		 * The exception is when LOGO is done while another PLOGI with
+		 * the same nport handle is waiting as might be the case here.
+		 * Note: there is always a possibily of a race where session
+		 * deletion has already started for other reasons (e.g. ACL
+		 * removal) and now PLOGI arrives:
+		 * 1. if PLOGI arrived in FW after nport handle has been freed,
+		 *    FW must have assigned this PLOGI a new/same handle and we
+		 *    can proceed ACK'ing it as usual when session deletion
+		 *    completes.
+		 * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
+		 *    bit reached it, the handle has now been released. We'll
+		 *    get an error when we ACK this PLOGI. Nothing will be sent
+		 *    back to initiator. Initiator should eventually retry
+		 *    PLOGI and situation will correct itself.
+		 */
+		sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
+		    (sess->d_id.b24 == port_id.b24));
+
+		ql_dbg(ql_dbg_disc, vha, 0x20f9,
+		    "%s %d %8phC post del sess\n",
+		    __func__, __LINE__, sess->port_name);
+
+
+		qlt_schedule_sess_for_deletion_lock(sess);
+		break;
+	}
+out:
+	return res;
+}
+
 /*
  * ha->hardware_lock supposed to be held on entry. Might drop it, then reaquire
  */
@@ -4702,8 +4846,7 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	uint16_t loop_id;
 	uint16_t wd3_lo;
 	int res = 0;
-	struct qlt_plogi_ack_t *pla;
-	unsigned long flags = 0;
+	unsigned long flags;
 
 	wwn = wwn_to_u64(iocb->u.isp24.port_name);
 
@@ -4726,92 +4869,27 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 	 */
 	switch (iocb->u.isp24.status_subcode) {
 	case ELS_PLOGI:
+		res = qlt_handle_login(vha, iocb);
+		break;
 
-		/* Mark all stale commands in qla_tgt_wq for deletion */
-		abort_cmds_for_s_id(vha, &port_id);
-
-		if (wwn) {
-			spin_lock_irqsave(&tgt->ha->tgt.sess_lock, flags);
-			sess = qlt_find_sess_invalidate_other(vha, wwn,
-				port_id, loop_id, &conflict_sess);
-			spin_unlock_irqrestore(&tgt->ha->tgt.sess_lock, flags);
-		}
-
-		if (IS_SW_RESV_ADDR(port_id)) {
-			res = 1;
-			break;
-		}
-
-		pla = qlt_plogi_ack_find_add(vha, &port_id, iocb);
-		if (!pla) {
-			qlt_send_term_imm_notif(vha, iocb, 1);
-			break;
-		}
-
-		res = 0;
-
-		if (conflict_sess) {
-			conflict_sess->login_gen++;
-			qlt_plogi_ack_link(vha, pla, conflict_sess,
-				QLT_PLOGI_LINK_CONFLICT);
-		}
-
-		if (!sess) {
-			pla->ref_count++;
-			qla24xx_post_newsess_work(vha, &port_id,
-				iocb->u.isp24.port_name, pla);
-			res = 0;
-			break;
-		}
-
-		qlt_plogi_ack_link(vha, pla, sess, QLT_PLOGI_LINK_SAME_WWN);
-		sess->fw_login_state = DSC_LS_PLOGI_PEND;
-		sess->d_id = port_id;
-		sess->login_gen++;
-
-		ql_dbg(ql_dbg_disc, vha, 0x20f9,
-		    "%s %d %8phC  DS %d\n",
-		    __func__, __LINE__, sess->port_name, sess->disc_state);
-
-		switch (sess->disc_state) {
-		case DSC_DELETED:
-			qlt_plogi_ack_unref(vha, pla);
-			break;
-
-		default:
-			/*
-			 * Under normal circumstances we want to release nport handle
-			 * during LOGO process to avoid nport handle leaks inside FW.
-			 * The exception is when LOGO is done while another PLOGI with
-			 * the same nport handle is waiting as might be the case here.
-			 * Note: there is always a possibily of a race where session
-			 * deletion has already started for other reasons (e.g. ACL
-			 * removal) and now PLOGI arrives:
-			 * 1. if PLOGI arrived in FW after nport handle has been freed,
-			 *    FW must have assigned this PLOGI a new/same handle and we
-			 *    can proceed ACK'ing it as usual when session deletion
-			 *    completes.
-			 * 2. if PLOGI arrived in FW before LOGO with LCF_FREE_NPORT
-			 *    bit reached it, the handle has now been released. We'll
-			 *    get an error when we ACK this PLOGI. Nothing will be sent
-			 *    back to initiator. Initiator should eventually retry
-			 *    PLOGI and situation will correct itself.
-			 */
-			sess->keep_nport_handle = ((sess->loop_id == loop_id) &&
-			   (sess->d_id.b24 == port_id.b24));
-
-			ql_dbg(ql_dbg_disc, vha, 0x20f9,
-			    "%s %d %8phC post del sess\n",
-			    __func__, __LINE__, sess->port_name);
+	case ELS_PRLI:
+		if (N2N_TOPO(ha)) {
+			sess = qla2x00_find_fcport_by_wwpn(vha,
+			    iocb->u.isp24.port_name, 1);
 
+			if (sess && sess->plogi_link[QLT_PLOGI_LINK_SAME_WWN]) {
+				ql_dbg(ql_dbg_disc, vha, 0xffff,
+				    "%s %d %8phC Term PRLI due to PLOGI ACK not completed\n",
+				    __func__, __LINE__,
+				    iocb->u.isp24.port_name);
+				qlt_send_term_imm_notif(vha, iocb, 1);
+				break;
+			}
 
-			qlt_schedule_sess_for_deletion_lock(sess);
+			res = qlt_handle_login(vha, iocb);
 			break;
 		}
 
-		break;
-
-	case ELS_PRLI:
 		wd3_lo = le16_to_cpu(iocb->u.isp24.u.prli.wd3_lo);
 
 		if (wwn) {
@@ -4988,6 +5066,10 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		break;
 	}
 
+	ql_dbg(ql_dbg_disc, vha, 0xf026,
+	    "qla_target(%d): Exit ELS opcode: 0x%02x res %d\n",
+	    vha->vp_idx, iocb->u.isp24.status_subcode, res);
+
 	return res;
 }
 
@@ -6647,6 +6729,7 @@ void
 qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
+	u32 tmp;
 
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
@@ -6698,6 +6781,14 @@ qlt_24xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_24xx *nv)
 		nv->firmware_options_1 &= cpu_to_le32(~BIT_15);
 		/* Enable target PRLI control */
 		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
+
+		if (IS_QLA25XX(ha)) {
+			/* Change Loop-prefer to Pt-Pt */
+			tmp = ~(BIT_4|BIT_5|BIT_6);
+			nv->firmware_options_2 &= cpu_to_le32(tmp);
+			tmp = P2P << 4;
+			nv->firmware_options_2 |= cpu_to_le32(tmp);
+		}
 	} else {
 		if (ha->tgt.saved_set) {
 			nv->exchange_count = ha->tgt.saved_exchange_count;
@@ -6752,6 +6843,7 @@ void
 qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 {
 	struct qla_hw_data *ha = vha->hw;
+	u32 tmp;
 
 	if (!QLA_TGT_MODE_ENABLED())
 		return;
@@ -6802,6 +6894,12 @@ qlt_81xx_config_nvram_stage1(struct scsi_qla_host *vha, struct nvram_81xx *nv)
 		nv->host_p &= cpu_to_le32(~BIT_10);
 		/* Enable target PRLI control */
 		nv->firmware_options_2 |= cpu_to_le32(BIT_14);
+
+		/* Change Loop-prefer to Pt-Pt */
+		tmp = ~(BIT_4|BIT_5|BIT_6);
+		nv->firmware_options_2 &= cpu_to_le32(tmp);
+		tmp = P2P << 4;
+		nv->firmware_options_2 |= cpu_to_le32(tmp);
 	} else {
 		if (ha->tgt.saved_set) {
 			nv->exchange_count = ha->tgt.saved_exchange_count;
-- 
2.12.0
