From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v4 11/12] qla2xxx: Improve RSCN handling in driver
Date: Thu, 19 Jan 2017 22:28:03 -0800
Message-ID: <1484893684-1255-12-git-send-email-himanshu.madhani@cavium.com>
References: <1484893684-1255-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0059.outbound.protection.outlook.com ([104.47.32.59]:3131
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751324AbdATG2s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 01:28:48 -0500
In-Reply-To: <1484893684-1255-1-git-send-email-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

From: Quinn Tran <quinn.tran@cavium.com>

Current code blindly does State Change Registration when
the link is up. Move SCR behind fabric scan, so that arbitrated
loop scan would not get erroneous error message.

Some of the other improvements are as follows

- Add session deletion for TPRLO and send acknowledgment for TPRLO.
- Enable FW option to move ABTS, RIDA & PUREX from RSPQ to ATIOQ.
- Save NPort ID early in link init.
- Move ABTS & RIDA to ATIOQ helps in keeping command ordering and
  link up sequence ordering.
- Save Nport ID and update VP map so that SCSI CMD/ATIO won't be dropped.
- fcport alloc does the initializes memory to zero. Remove memset to
  zero since It might corrupt link list.
- Turn off Registration for State Change MB in loop mode.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_def.h    |  11 +-
 drivers/scsi/qla2xxx/qla_fw.h     |  75 +++++++++---
 drivers/scsi/qla2xxx/qla_gbl.h    |   2 +
 drivers/scsi/qla2xxx/qla_gs.c     |   4 +-
 drivers/scsi/qla2xxx/qla_init.c   | 150 ++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_isr.c    |   6 +-
 drivers/scsi/qla2xxx/qla_mbx.c    | 144 +++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c     |  48 ++++----
 drivers/scsi/qla2xxx/qla_target.c | 238 ++++++++++++++++++++++++++++++++++----
 9 files changed, 533 insertions(+), 145 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index b447b01..329aebf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2226,6 +2226,13 @@ enum fcport_mgt_event {
 	FCME_DELETE_DONE,
 };
 
+enum rscn_addr_format {
+	RSCN_PORT_ADDR,
+	RSCN_AREA_ADDR,
+	RSCN_DOM_ADDR,
+	RSCN_FAB_ADDR,
+};
+
 /*
  * Fibre channel port structure.
  */
@@ -3957,7 +3964,7 @@ struct qla_tgt_counters {
 #define FCOE_CTX_RESET_NEEDED	18	/* Initiate FCoE context reset */
 #define MPI_RESET_NEEDED	19	/* Initiate MPI FW reset */
 #define ISP_QUIESCE_NEEDED	20	/* Driver need some quiescence */
-#define SCR_PENDING		21	/* SCR in target mode */
+#define FREE_BIT 21
 #define PORT_UPDATE_NEEDED	22
 #define FX00_RESET_RECOVERY	23
 #define FX00_TARGET_SCAN	24
@@ -4011,7 +4018,9 @@ struct qla_tgt_counters {
 	/* list of commands waiting on workqueue */
 	struct list_head	qla_cmd_list;
 	struct list_head	qla_sess_op_cmd_list;
+	struct list_head	unknown_atio_list;
 	spinlock_t		cmd_list_lock;
+	struct delayed_work	unknown_atio_work;
 
 	/* Counter to detect races between ELS and RSCN events */
 	atomic_t		generation_tick;
diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index ee135cf..1f80892 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -1301,27 +1301,76 @@ struct vp_config_entry_24xx {
 };
 
 #define VP_RPT_ID_IOCB_TYPE	0x32	/* Report ID Acquisition entry. */
+enum VP_STATUS {
+	VP_STAT_COMPL,
+	VP_STAT_FAIL,
+	VP_STAT_ID_CHG,
+	VP_STAT_SNS_TO,				/* timeout */
+	VP_STAT_SNS_RJT,
+	VP_STAT_SCR_TO,				/* timeout */
+	VP_STAT_SCR_RJT,
+};
+
+enum VP_FLAGS {
+	VP_FLAGS_CON_FLOOP = 1,
+	VP_FLAGS_CON_P2P = 2,
+	VP_FLAGS_CON_FABRIC = 3,
+	VP_FLAGS_NAME_VALID = BIT_5,
+};
+
 struct vp_rpt_id_entry_24xx {
 	uint8_t entry_type;		/* Entry type. */
 	uint8_t entry_count;		/* Entry count. */
 	uint8_t sys_define;		/* System defined. */
 	uint8_t entry_status;		/* Entry Status. */
-
-	uint32_t handle;		/* System handle. */
-
-	uint16_t vp_count;		/* Format 0 -- | VP setup | VP acq |. */
-					/* Format 1 -- | VP count |. */
-	uint16_t vp_idx;		/* Format 0 -- Reserved. */
-					/* Format 1 -- VP status and index. */
+	uint32_t resv1;
+	uint8_t vp_acquired;
+	uint8_t vp_setup;
+	uint8_t vp_idx;		/* Format 0=reserved */
+	uint8_t vp_status;	/* Format 0=reserved */
 
 	uint8_t port_id[3];
 	uint8_t format;
-
-	uint8_t vp_idx_map[16];
-
-	uint8_t reserved_4[24];
-	uint16_t bbcr;
-	uint8_t reserved_5[6];
+	union {
+		struct {
+			/* format 0 loop */
+			uint8_t vp_idx_map[16];
+			uint8_t reserved_4[32];
+		} f0;
+		struct {
+			/* format 1 fabric */
+			uint8_t vpstat1_subcode; /* vp_status=1 subcode */
+			uint8_t flags;
+			uint16_t fip_flags;
+			uint8_t rsv2[12];
+
+			uint8_t ls_rjt_vendor;
+			uint8_t ls_rjt_explanation;
+			uint8_t ls_rjt_reason;
+			uint8_t rsv3[5];
+
+			uint8_t port_name[8];
+			uint8_t node_name[8];
+			uint16_t bbcr;
+			uint8_t reserved_5[6];
+		} f1;
+		struct { /* format 2: N2N direct connect */
+		    uint8_t vpstat1_subcode;
+		    uint8_t flags;
+		    uint16_t rsv6;
+		    uint8_t rsv2[12];
+
+		    uint8_t ls_rjt_vendor;
+		    uint8_t ls_rjt_explanation;
+		    uint8_t ls_rjt_reason;
+		    uint8_t rsv3[5];
+
+		    uint8_t port_name[8];
+		    uint8_t node_name[8];
+		    uint32_t remote_nport_id;
+		    uint32_t reserved_5;
+		} f2;
+	} u;
 };
 
 #define VF_EVFP_IOCB_TYPE       0x26    /* Exchange Virtual Fabric Parameters entry. */
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index dd95ff6..e091457 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -138,6 +138,7 @@ int qla24xx_post_newsess_work(struct scsi_qla_host *, port_id_t *, u8 *,
 extern int ql2xexlogins;
 extern int ql2xexchoffld;
 extern int ql2xfwholdabts;
+extern int ql2xmvasynctoatio;
 
 extern int qla2x00_loop_reset(scsi_qla_host_t *);
 extern void qla2x00_abort_all_cmds(scsi_qla_host_t *, int);
@@ -844,5 +845,6 @@ void qlt_plogi_ack_link(struct scsi_qla_host *, struct qlt_plogi_ack_t *,
 extern struct fc_port *qlt_find_sess_invalidate_other(scsi_qla_host_t *,
 	uint64_t wwn, port_id_t port_id, uint16_t loop_id, struct fc_port **);
 void qla24xx_delete_sess_fn(struct work_struct *);
+void qlt_unknown_atio_work_fn(struct work_struct *);
 
 #endif /* _QLA_GBL_H */
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8f7054d..d1074fb 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -2914,8 +2914,10 @@ int qla24xx_async_gidpn(scsi_qla_host_t *vha, fc_port_t *fcport)
 int qla24xx_post_gidpn_work(struct scsi_qla_host *vha, fc_port_t *fcport)
 {
 	struct qla_work_evt *e;
+	int ls;
 
-	if ((atomic_read(&vha->loop_state) != LOOP_READY) ||
+	ls = atomic_read(&vha->loop_state);
+	if (((ls != LOOP_READY) && (ls != LOOP_UP)) ||
 		test_bit(UNLOADING, &vha->dpc_flags))
 		return 0;
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 4c0a2d8..6843093 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1071,10 +1071,10 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t *vha,
 	qla24xx_fcport_handle_login(vha, fcport);
 }
 
-void qla2x00_fcport_event_handler(scsi_qla_host_t *vha,
-	struct event_arg *ea)
+void qla2x00_fcport_event_handler(scsi_qla_host_t *vha, struct event_arg *ea)
 {
-	fc_port_t *fcport;
+	fc_port_t *fcport, *f, *tf;
+	uint32_t id = 0, mask, rid;
 	int rc;
 
 	switch (ea->event) {
@@ -1087,20 +1087,55 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha,
 	case FCME_RSCN:
 		if (test_bit(UNLOADING, &vha->dpc_flags))
 			return;
+		switch (ea->id.b.rsvd_1) {
+		case RSCN_PORT_ADDR:
+			fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
+			if (!fcport) {
+				/* cable moved */
+				rc = qla24xx_post_gpnid_work(vha, &ea->id);
+				if (rc) {
+					ql_log(ql_log_warn, vha, 0xffff,
+						"RSCN GPNID work failed %02x%02x%02x\n",
+						ea->id.b.domain, ea->id.b.area,
+						ea->id.b.al_pa);
+				}
+			} else {
+				ea->fcport = fcport;
+				qla24xx_handle_rscn_event(fcport, ea);
+			}
+			break;
+		case RSCN_AREA_ADDR:
+		case RSCN_DOM_ADDR:
+			if (ea->id.b.rsvd_1 == RSCN_AREA_ADDR) {
+				mask = 0xffff00;
+				ql_log(ql_dbg_async, vha, 0xffff,
+					   "RSCN: Area 0x%06x was affected\n",
+					   ea->id.b24);
+			} else {
+				mask = 0xff0000;
+				ql_log(ql_dbg_async, vha, 0xffff,
+					   "RSCN: Domain 0x%06x was affected\n",
+					   ea->id.b24);
+			}
 
-		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
-		if (!fcport) {
-			/* cable moved */
-			rc = qla24xx_post_gpnid_work(vha, &ea->id);
-			if (rc) {
-				ql_log(ql_log_warn, vha, 0xffff,
-					"RSCN GPNID work failed %02x%02x%02x\n",
-					ea->id.b.domain, ea->id.b.area,
-					ea->id.b.al_pa);
+			rid = ea->id.b24 & mask;
+			list_for_each_entry_safe(f, tf, &vha->vp_fcports,
+			    list) {
+				id = f->d_id.b24 & mask;
+				if (rid == id) {
+					ea->fcport = f;
+					qla24xx_handle_rscn_event(f, ea);
+				}
 			}
-		} else {
-			ea->fcport = fcport;
-			qla24xx_handle_rscn_event(fcport, ea);
+			break;
+		case RSCN_FAB_ADDR:
+		default:
+			ql_log(ql_log_warn, vha, 0xffff,
+				"RSCN: Fabric was affected. Addr format %d\n",
+				ea->id.b.rsvd_1);
+			qla2x00_mark_all_devices_lost(vha, 1);
+			set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
+			set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		}
 		break;
 	case FCME_GIDPN_DONE:
@@ -2947,6 +2982,21 @@ void qla2x00_fcport_event_handler(scsi_qla_host_t *vha,
 			__func__, ha->fw_options[2]);
 	}
 
+	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
+	if (ql2xmvasynctoatio) {
+		if (qla_tgt_mode_enabled(vha) ||
+		    qla_dual_mode_enabled(vha))
+			ha->fw_options[2] |= BIT_11;
+		else
+			ha->fw_options[2] &= ~BIT_11;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0xffff,
+		"%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
+		__func__, ha->fw_options[1], ha->fw_options[2],
+		ha->fw_options[3], vha->host->active_mode);
+	qla2x00_set_fw_options(vha, ha->fw_options);
+
 	/* Update Serial Link options. */
 	if ((le16_to_cpu(ha->fw_seriallink_options24[0]) & BIT_0) == 0)
 		return;
@@ -3953,10 +4003,11 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 
 	} else if (ha->current_topology == ISP_CFG_N) {
 		clear_bit(RSCN_UPDATE, &flags);
-
+	} else if (ha->current_topology == ISP_CFG_NL) {
+		clear_bit(RSCN_UPDATE, &flags);
+		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	} else if (!vha->flags.online ||
 	    (test_bit(ABORT_ISP_ACTIVE, &flags))) {
-
 		set_bit(RSCN_UPDATE, &flags);
 		set_bit(LOCAL_LOOP_UPDATE, &flags);
 	}
@@ -4058,6 +4109,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	uint16_t	loop_id;
 	uint8_t		domain, area, al_pa;
 	struct qla_hw_data *ha = vha->hw;
+	unsigned long flags;
 
 	found_devs = 0;
 	new_fcport = NULL;
@@ -4098,7 +4150,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			    "Marking port lost loop_id=0x%04x.\n",
 			    fcport->loop_id);
 
-			qla2x00_set_fcport_state(fcport, FCS_DEVICE_LOST);
+			qla2x00_mark_device_lost(vha, fcport, 0, 0);
 		}
 	}
 
@@ -4129,13 +4181,14 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 		if (loop_id > LAST_LOCAL_LOOP_ID)
 			continue;
 
-		memset(new_fcport, 0, sizeof(fc_port_t));
+		memset(new_fcport->port_name, 0, WWN_SIZE);
 
 		/* Fill in member data. */
 		new_fcport->d_id.b.domain = domain;
 		new_fcport->d_id.b.area = area;
 		new_fcport->d_id.b.al_pa = al_pa;
 		new_fcport->loop_id = loop_id;
+
 		rval2 = qla2x00_get_port_database(vha, new_fcport, 0);
 		if (rval2 != QLA_SUCCESS) {
 			ql_dbg(ql_dbg_disc, vha, 0x201a,
@@ -4148,6 +4201,7 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			continue;
 		}
 
+		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 		/* Check for matching device in port list. */
 		found = 0;
 		fcport = NULL;
@@ -4163,6 +4217,12 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 			memcpy(fcport->node_name, new_fcport->node_name,
 			    WWN_SIZE);
 
+			if (!fcport->login_succ) {
+				vha->fcport_count++;
+				fcport->login_succ = 1;
+				fcport->disc_state = DSC_LOGIN_COMPLETE;
+			}
+
 			found++;
 			break;
 		}
@@ -4173,16 +4233,28 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 
 			/* Allocate a new replacement fcport. */
 			fcport = new_fcport;
+			if (!fcport->login_succ) {
+				vha->fcport_count++;
+				fcport->login_succ = 1;
+				fcport->disc_state = DSC_LOGIN_COMPLETE;
+			}
+
+			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
 			new_fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
+
 			if (new_fcport == NULL) {
 				ql_log(ql_log_warn, vha, 0x201c,
 				    "Failed to allocate memory for fcport.\n");
 				rval = QLA_MEMORY_ALLOC_FAILED;
 				goto cleanup_allocation;
 			}
+			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
 			new_fcport->flags &= ~FCF_FABRIC_DEVICE;
 		}
 
+		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+
 		/* Base iIDMA settings on HBA port speed. */
 		fcport->fp_speed = ha->link_data_rate;
 
@@ -4371,6 +4443,16 @@ static void qla2xxx_nvram_wwn_from_ofw(scsi_qla_host_t *vha, nvram_t *nv)
 	}
 	vha->device_flags |= SWITCH_FOUND;
 
+
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)) {
+		rval = qla2x00_send_change_request(vha, 0x3, 0);
+		if (rval != QLA_SUCCESS)
+			ql_log(ql_log_warn, vha, 0x121,
+				"Failed to enable receiving of RSCN requests: 0x%x.\n",
+				rval);
+	}
+
+
 	do {
 		qla2x00_mgmt_svr_login(vha);
 
@@ -6116,6 +6198,7 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 
 	for (chksum = 0; cnt--; wptr++)
 		chksum += le32_to_cpu(*wptr);
+
 	if (chksum) {
 		ql_dbg(ql_dbg_init, vha, 0x018c,
 		    "Checksum validation failed for primary image (0x%x)\n",
@@ -7128,6 +7211,10 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 		vha->flags.process_response_queue = 1;
 	}
 
+	 /* enable RIDA Format2 */
+	if (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha))
+		icb->firmware_options_3 |= BIT_0;
+
 	if (rval) {
 		ql_log(ql_log_warn, vha, 0x0076,
 		    "NVRAM configuration failed.\n");
@@ -7252,13 +7339,26 @@ uint8_t qla27xx_find_valid_image(struct scsi_qla_host *vha)
 			__func__, ha->fw_options[2]);
 	}
 
-	if (!ql2xetsenable)
-		goto out;
+	/* Move PUREX, ABTS RX & RIDA to ATIOQ */
+	if (ql2xmvasynctoatio) {
+		if (qla_tgt_mode_enabled(vha) ||
+		    qla_dual_mode_enabled(vha))
+			ha->fw_options[2] |= BIT_11;
+		else
+			ha->fw_options[2] &= ~BIT_11;
+	}
+
+	if (ql2xetsenable) {
+		/* Enable ETS Burst. */
+		memset(ha->fw_options, 0, sizeof(ha->fw_options));
+		ha->fw_options[2] |= BIT_9;
+	}
+
+	ql_dbg(ql_dbg_init, vha, 0xffff,
+		"%s, add FW options 1-3 = 0x%04x 0x%04x 0x%04x mode %x\n",
+		__func__, ha->fw_options[1], ha->fw_options[2],
+		ha->fw_options[3], vha->host->active_mode);
 
-	/* Enable ETS Burst. */
-	memset(ha->fw_options, 0, sizeof(ha->fw_options));
-	ha->fw_options[2] |= BIT_9;
-out:
 	qla2x00_set_fw_options(vha, ha->fw_options);
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c67b52c..cadbde1 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1029,10 +1029,6 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 
 		qla2x00_mark_all_devices_lost(vha, 1);
 
-		if (vha->vp_idx == 0 &&
-		    (qla_tgt_mode_enabled(vha) || qla_dual_mode_enabled(vha)))
-			set_bit(SCR_PENDING, &vha->dpc_flags);
-
 		set_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags);
 		set_bit(LOCAL_LOOP_UPDATE, &vha->dpc_flags);
 		set_bit(VP_CONFIG_OK, &vha->vp_flags);
@@ -1077,7 +1073,9 @@ static void qla_irq_affinity_notify(struct irq_affinity_notify *,
 			memset(&ea, 0, sizeof(ea));
 			ea.event = FCME_RSCN;
 			ea.id.b24 = rscn_entry;
+			ea.id.b.rsvd_1 = rscn_entry >> 24;
 			qla2x00_fcport_event_handler(vha, &ea);
+			qla2x00_post_aen_work(vha, FCH_EVT_RSCN, rscn_entry);
 		}
 		break;
 	/* case MBA_RIO_RESPONSE: */
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e8be16a..0c92e54 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -3601,10 +3601,8 @@ struct tsk_mgmt_cmd {
 qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	struct vp_rpt_id_entry_24xx *rptid_entry)
 {
-	uint8_t vp_idx;
-	uint16_t stat = le16_to_cpu(rptid_entry->vp_idx);
 	struct qla_hw_data *ha = vha->hw;
-	scsi_qla_host_t *vp;
+	scsi_qla_host_t *vp = NULL;
 	unsigned long   flags;
 	int found;
 
@@ -3615,80 +3613,124 @@ struct tsk_mgmt_cmd {
 		return;
 
 	if (rptid_entry->format == 0) {
+		/* loop */
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b7,
 		    "Format 0 : Number of VPs setup %d, number of "
-		    "VPs acquired %d.\n",
-		    MSB(le16_to_cpu(rptid_entry->vp_count)),
-		    LSB(le16_to_cpu(rptid_entry->vp_count)));
+		    "VPs acquired %d.\n", rptid_entry->vp_setup,
+		    rptid_entry->vp_acquired);
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b8,
 		    "Primary port id %02x%02x%02x.\n",
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
+
+		vha->d_id.b.domain = rptid_entry->port_id[2];
+		vha->d_id.b.area = rptid_entry->port_id[1];
+		vha->d_id.b.al_pa = rptid_entry->port_id[0];
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		qlt_update_vp_map(vha, SET_AL_PA);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
+
 	} else if (rptid_entry->format == 1) {
-		vp_idx = LSB(stat);
+		/* fabric */
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10b9,
 		    "Format 1: VP[%d] enabled - status %d - with "
-		    "port id %02x%02x%02x.\n", vp_idx, MSB(stat),
+		    "port id %02x%02x%02x.\n", rptid_entry->vp_idx,
+			rptid_entry->vp_status,
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
 		    rptid_entry->port_id[0]);
 
 		/* buffer to buffer credit flag */
-		vha->flags.bbcr_enable = (rptid_entry->bbcr & 0xf) != 0;
-
-		/* FA-WWN is only for physical port */
-		if (!vp_idx) {
-			void *wwpn = ha->init_cb->port_name;
+		vha->flags.bbcr_enable = (rptid_entry->u.f1.bbcr & 0xf) != 0;
+
+		if (rptid_entry->vp_idx == 0) {
+			if (rptid_entry->vp_status == VP_STAT_COMPL) {
+				/* FA-WWN is only for physical port */
+				if (qla_ini_mode_enabled(vha) &&
+				    ha->flags.fawwpn_enabled &&
+				    (rptid_entry->u.f1.flags &
+				     VP_FLAGS_NAME_VALID)) {
+					memcpy(vha->port_name,
+					    rptid_entry->u.f1.port_name,
+					    WWN_SIZE);
+				}
 
-			if (!MSB(stat)) {
-				if (rptid_entry->vp_idx_map[1] & BIT_6)
-					wwpn = rptid_entry->reserved_4 + 8;
+				vha->d_id.b.domain = rptid_entry->port_id[2];
+				vha->d_id.b.area = rptid_entry->port_id[1];
+				vha->d_id.b.al_pa = rptid_entry->port_id[0];
+				spin_lock_irqsave(&ha->vport_slock, flags);
+				qlt_update_vp_map(vha, SET_AL_PA);
+				spin_unlock_irqrestore(&ha->vport_slock, flags);
 			}
-			memcpy(vha->port_name, wwpn, WWN_SIZE);
+
 			fc_host_port_name(vha->host) =
 			    wwn_to_u64(vha->port_name);
-			ql_dbg(ql_dbg_mbx, vha, 0x1018,
-			    "FA-WWN portname %016llx (%x)\n",
-			    fc_host_port_name(vha->host), MSB(stat));
-		}
-
-		vp = vha;
-		if (vp_idx == 0)
-			goto reg_needed;
 
-		if (MSB(stat) != 0 && MSB(stat) != 2) {
-			ql_dbg(ql_dbg_mbx, vha, 0x10ba,
-			    "Could not acquire ID for VP[%d].\n", vp_idx);
-			return;
-		}
+			if (qla_ini_mode_enabled(vha))
+				ql_dbg(ql_dbg_mbx, vha, 0x1018,
+				    "FA-WWN portname %016llx (%x)\n",
+				    fc_host_port_name(vha->host),
+				    rptid_entry->vp_status);
 
-		found = 0;
-		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &ha->vp_list, list) {
-			if (vp_idx == vp->vp_idx) {
-				found = 1;
-				break;
+			set_bit(REGISTER_FC4_NEEDED, &vha->dpc_flags);
+			set_bit(REGISTER_FDMI_NEEDED, &vha->dpc_flags);
+		} else {
+			if (rptid_entry->vp_status != VP_STAT_COMPL &&
+				rptid_entry->vp_status != VP_STAT_ID_CHG) {
+				ql_dbg(ql_dbg_mbx, vha, 0x10ba,
+				    "Could not acquire ID for VP[%d].\n",
+				    rptid_entry->vp_idx);
+				return;
 			}
-		}
-		spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-		if (!found)
-			return;
+			found = 0;
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			list_for_each_entry(vp, &ha->vp_list, list) {
+				if (rptid_entry->vp_idx == vp->vp_idx) {
+					found = 1;
+					break;
+				}
+			}
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-		vp->d_id.b.domain = rptid_entry->port_id[2];
-		vp->d_id.b.area =  rptid_entry->port_id[1];
-		vp->d_id.b.al_pa = rptid_entry->port_id[0];
+			if (!found)
+				return;
 
-		/*
-		 * Cannot configure here as we are still sitting on the
-		 * response queue. Handle it in dpc context.
-		 */
-		set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
+			vp->d_id.b.domain = rptid_entry->port_id[2];
+			vp->d_id.b.area =  rptid_entry->port_id[1];
+			vp->d_id.b.al_pa = rptid_entry->port_id[0];
+			spin_lock_irqsave(&ha->vport_slock, flags);
+			qlt_update_vp_map(vp, SET_AL_PA);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
-reg_needed:
-		set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
-		set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+			/*
+			 * Cannot configure here as we are still sitting on the
+			 * response queue. Handle it in dpc context.
+			 */
+			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
+			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
+			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
+		}
 		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
 		qla2xxx_wake_dpc(vha);
+	} else if (rptid_entry->format == 2) {
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "RIDA: format 2/N2N Primary port id %02x%02x%02x.\n",
+		    rptid_entry->port_id[2], rptid_entry->port_id[1],
+		    rptid_entry->port_id[0]);
+
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "N2N: Remote WWPN %8phC.\n",
+		    rptid_entry->u.f2.port_name);
+
+		/* N2N.  direct connect */
+		vha->d_id.b.domain = rptid_entry->port_id[2];
+		vha->d_id.b.area = rptid_entry->port_id[1];
+		vha->d_id.b.al_pa = rptid_entry->port_id[0];
+
+		spin_lock_irqsave(&ha->vport_slock, flags);
+		qlt_update_vp_map(vha, SET_AL_PA);
+		spin_unlock_irqrestore(&ha->vport_slock, flags);
 	}
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1656cff..008ac9a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -237,6 +237,13 @@
 		"0 (Default) Do not set fw option. "
 		"1 - Set fw option to hold ABTS.");
 
+int ql2xmvasynctoatio = 1;
+module_param(ql2xmvasynctoatio, int, S_IRUGO|S_IWUSR);
+MODULE_PARM_DESC(ql2xmvasynctoatio,
+		"Move PUREX, ABTS RX and RIDA IOCBs to ATIOQ"
+		"0 (Default). Do not move IOCBs"
+		"1 - Move IOCBs.");
+
 /*
  * SCSI host template entry points
  */
@@ -2932,18 +2939,6 @@ uint32_t qla2x00_isp_reg_stat(struct qla_hw_data *ha)
 	if (ret)
 		goto probe_init_failed;
 
-	base_vha->gnl.size = (ha->max_loop_id + 1) *
-		sizeof(struct get_name_list_extended);
-	base_vha->gnl.l = dma_alloc_coherent(&ha->pdev->dev,
-		base_vha->gnl.size, &base_vha->gnl.ldma, GFP_KERNEL);
-	INIT_LIST_HEAD(&base_vha->gnl.fcports);
-
-	if (base_vha->gnl.l == NULL) {
-		ql_log(ql_log_fatal, base_vha, 0xffff,
-			"Alloc failed for name list.\n");
-		goto probe_init_failed;
-	}
-
 	/* Alloc arrays of request and response ring ptrs */
 	if (!qla2x00_alloc_queues(ha, req, rsp)) {
 		ql_log(ql_log_fatal, base_vha, 0x003d,
@@ -4250,10 +4245,10 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	struct scsi_qla_host *vha = NULL;
 
 	host = scsi_host_alloc(sht, sizeof(scsi_qla_host_t));
-	if (host == NULL) {
+	if (!host) {
 		ql_log_pci(ql_log_fatal, ha->pdev, 0x0107,
 		    "Failed to allocate host from the scsi layer, aborting.\n");
-		goto fail;
+		return NULL;
 	}
 
 	/* Clear our data area */
@@ -4272,11 +4267,23 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	INIT_LIST_HEAD(&vha->logo_list);
 	INIT_LIST_HEAD(&vha->plogi_ack_list);
 	INIT_LIST_HEAD(&vha->qp_list);
+	INIT_LIST_HEAD(&vha->gnl.fcports);
 
 	spin_lock_init(&vha->work_lock);
 	spin_lock_init(&vha->cmd_list_lock);
 	init_waitqueue_head(&vha->fcport_waitQ);
 
+	vha->gnl.size =
+	    sizeof(struct get_name_list_extended[ha->max_loop_id+1]);
+	vha->gnl.l = dma_alloc_coherent(&ha->pdev->dev,
+	    vha->gnl.size, &vha->gnl.ldma, GFP_KERNEL);
+	if (!vha->gnl.l) {
+		ql_log(ql_log_fatal, vha, 0xffff,
+		    "Alloc failed for name list.\n");
+		scsi_remove_host(vha->host);
+		return NULL;
+	}
+
 	sprintf(vha->host_str, "%s_%ld", QLA2XXX_DRIVER_NAME, vha->host_no);
 	ql_dbg(ql_dbg_init, vha, 0x0041,
 	    "Allocated the host=%p hw=%p vha=%p dev_name=%s",
@@ -4284,9 +4291,6 @@ struct scsi_qla_host *qla2x00_create_host(struct scsi_host_template *sht,
 	    dev_name(&(ha->pdev->dev)));
 
 	return vha;
-
-fail:
-	return vha;
 }
 
 struct qla_work_evt *
@@ -5512,16 +5516,6 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 			qla2x00_update_fcports(base_vha);
 		}
 
-		if (test_bit(SCR_PENDING, &base_vha->dpc_flags)) {
-			int ret;
-			ret = qla2x00_send_change_request(base_vha, 0x3, 0);
-			if (ret != QLA_SUCCESS)
-				ql_log(ql_log_warn, base_vha, 0x121,
-				    "Failed to enable receiving of RSCN "
-				    "requests: 0x%x.\n", ret);
-			clear_bit(SCR_PENDING, &base_vha->dpc_flags);
-		}
-
 		if (IS_QLAFX00(ha))
 			goto loop_resync_check;
 
diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 62cee7b..602d33b 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -224,6 +224,105 @@ static inline void qlt_decr_num_pend_cmds(struct scsi_qla_host *vha)
 	spin_unlock_irqrestore(&vha->hw->tgt.q_full_lock, flags);
 }
 
+
+static void qlt_queue_unknown_atio(scsi_qla_host_t *vha,
+	struct atio_from_isp *atio,	uint8_t ha_locked)
+{
+	struct qla_tgt_sess_op *u;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	unsigned long flags;
+
+	if (tgt->tgt_stop) {
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+			   "qla_target(%d): dropping unknown ATIO_TYPE7, "
+			   "because tgt is being stopped", vha->vp_idx);
+		goto out_term;
+	}
+
+	u = kzalloc(sizeof(*u), GFP_ATOMIC);
+	if (u == NULL) {
+		ql_dbg(ql_dbg_async, vha, 0xffff,
+		    "Alloc of struct unknown_atio (size %zd) failed", sizeof(*u));
+		/* It should be harmless and on the next retry should work well */
+		goto out_term;
+	}
+
+	u->vha = vha;
+	memcpy(&u->atio, atio, sizeof(*atio));
+	INIT_LIST_HEAD(&u->cmd_list);
+
+	spin_lock_irqsave(&vha->cmd_list_lock, flags);
+	list_add_tail(&u->cmd_list, &vha->unknown_atio_list);
+	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+
+	schedule_delayed_work(&vha->unknown_atio_work, 1);
+
+out:
+	return;
+
+out_term:
+	qlt_send_term_exchange(vha, NULL, atio, ha_locked, 0);
+	goto out;
+}
+
+static void qlt_try_to_dequeue_unknown_atios(struct scsi_qla_host *vha,
+	uint8_t ha_locked)
+{
+	struct qla_tgt_sess_op *u, *t;
+	scsi_qla_host_t *host;
+	struct qla_tgt *tgt = vha->vha_tgt.qla_tgt;
+	unsigned long flags;
+	uint8_t queued = 0;
+
+	list_for_each_entry_safe(u, t, &vha->unknown_atio_list, cmd_list) {
+		if (u->aborted) {
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+			    "Freeing unknown %s %p, because of Abort",
+			    "ATIO_TYPE7", u);
+			qlt_send_term_exchange(vha, NULL, &u->atio,
+			    ha_locked, 0);
+			goto abort;
+		}
+
+		host = qlt_find_host_by_d_id(vha, u->atio.u.isp24.fcp_hdr.d_id);
+		if (host != NULL) {
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+				"Requeuing unknown ATIO_TYPE7 %p", u);
+			qlt_24xx_atio_pkt(host, &u->atio, ha_locked);
+		} else if (tgt->tgt_stop) {
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+				"Freeing unknown %s %p, because tgt is being stopped",
+				"ATIO_TYPE7", u);
+			qlt_send_term_exchange(vha, NULL, &u->atio,
+			    ha_locked, 0);
+		} else {
+			ql_dbg(ql_dbg_async, vha, 0xffff,
+				"u %p, vha %p, host %p, sched again..", u,
+				vha, host);
+			if (!queued) {
+				queued = 1;
+				schedule_delayed_work(&vha->unknown_atio_work,
+				    1);
+			}
+			continue;
+		}
+
+abort:
+		spin_lock_irqsave(&vha->cmd_list_lock, flags);
+		list_del(&u->cmd_list);
+		spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
+		kfree(u);
+	}
+}
+
+void qlt_unknown_atio_work_fn(struct work_struct *work)
+{
+	struct scsi_qla_host *vha = container_of(to_delayed_work(work),
+	    struct scsi_qla_host, unknown_atio_work);
+
+	qlt_try_to_dequeue_unknown_atios(vha, 0);
+}
+
 static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 	struct atio_from_isp *atio, uint8_t ha_locked)
 {
@@ -244,8 +343,14 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 			    atio->u.isp24.fcp_hdr.d_id[0],
 			    atio->u.isp24.fcp_hdr.d_id[1],
 			    atio->u.isp24.fcp_hdr.d_id[2]);
+
+
+			qlt_queue_unknown_atio(vha, atio, ha_locked);
 			break;
 		}
+		if (unlikely(!list_empty(&vha->unknown_atio_list)))
+			qlt_try_to_dequeue_unknown_atios(vha, ha_locked);
+
 		qlt_24xx_atio_pkt(host, atio, ha_locked);
 		break;
 	}
@@ -273,6 +378,31 @@ static bool qlt_24xx_atio_pkt_all_vps(struct scsi_qla_host *vha,
 		break;
 	}
 
+	case VP_RPT_ID_IOCB_TYPE:
+		qla24xx_report_id_acquisition(vha,
+			(struct vp_rpt_id_entry_24xx *)atio);
+		break;
+
+	case ABTS_RECV_24XX:
+	{
+		struct abts_recv_from_24xx *entry =
+			(struct abts_recv_from_24xx *)atio;
+		struct scsi_qla_host *host = qlt_find_host_by_vp_idx(vha,
+			entry->vp_index);
+		if (unlikely(!host)) {
+			ql_dbg(ql_dbg_tgt, vha, 0xffff,
+			    "qla_target(%d): Response pkt (ABTS_RECV_24XX) "
+			    "received, with unknown vp_index %d\n",
+			    vha->vp_idx, entry->vp_index);
+			break;
+		}
+		qlt_response_pkt(host, (response_t *)atio);
+		break;
+
+	}
+
+	/* case PUREX_IOCB_TYPE: ql2xmvasynctoatio */
+
 	default:
 		ql_dbg(ql_dbg_tgt, vha, 0xe040,
 		    "qla_target(%d): Received unknown ATIO atio "
@@ -791,6 +921,7 @@ static void qlt_free_session_done(struct work_struct *work)
 	unsigned long flags;
 	bool logout_started = false;
 	struct event_arg ea;
+	scsi_qla_host_t *base_vha;
 
 	ql_dbg(ql_dbg_tgt_mgt, vha, 0xf084,
 		"%s: se_sess %p / sess %p from port %8phC loop_id %#04x"
@@ -802,23 +933,25 @@ static void qlt_free_session_done(struct work_struct *work)
 
 
 	if (!IS_SW_RESV_ADDR(sess->d_id)) {
-	if (sess->send_els_logo) {
-		qlt_port_logo_t logo;
-		logo.id = sess->d_id;
-		logo.cmd_count = 0;
-		qlt_send_first_logo(vha, &logo);
-	}
+		if (sess->send_els_logo) {
+			qlt_port_logo_t logo;
 
-	if (sess->logout_on_delete) {
-		int rc;
-		rc = qla2x00_post_async_logout_work(vha, sess, NULL);
-		if (rc != QLA_SUCCESS)
-			ql_log(ql_log_warn, vha, 0xf085,
-			       "Schedule logo failed sess %p rc %d\n",
-			       sess, rc);
-		else
-			logout_started = true;
-	}
+			logo.id = sess->d_id;
+			logo.cmd_count = 0;
+			qlt_send_first_logo(vha, &logo);
+		}
+
+		if (sess->logout_on_delete) {
+			int rc;
+
+			rc = qla2x00_post_async_logout_work(vha, sess, NULL);
+			if (rc != QLA_SUCCESS)
+				ql_log(ql_log_warn, vha, 0xf085,
+				    "Schedule logo failed sess %p rc %d\n",
+				    sess, rc);
+			else
+				logout_started = true;
+		}
 	}
 
 	/*
@@ -841,8 +974,13 @@ static void qlt_free_session_done(struct work_struct *work)
 		}
 
 		ql_dbg(ql_dbg_disc, vha, 0xf087,
-			"%s: sess %p logout completed\n",
-			__func__, sess);
+		    "%s: sess %p logout completed\n",__func__, sess);
+	}
+
+	if (sess->logo_ack_needed) {
+		sess->logo_ack_needed = 0;
+		qla24xx_async_notify_ack(vha, sess,
+			(struct imm_ntfy_from_isp *)sess->iocb, SRB_NACK_LOGO);
 	}
 
 	spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -917,6 +1055,10 @@ static void qlt_free_session_done(struct work_struct *work)
 	if (vha->fcport_count == 0)
 		wake_up_all(&vha->fcport_waitQ);
 
+	base_vha = pci_get_drvdata(ha->pdev);
+	if (test_bit(PFLG_DRIVER_REMOVING, &base_vha->pci_flags))
+		return;
+
 	if (!tgt || !tgt->tgt_stop) {
 		memset(&ea, 0, sizeof(ea));
 		ea.event = FCME_DELETE_DONE;
@@ -1602,6 +1744,14 @@ static int abort_cmd_for_tag(struct scsi_qla_host *vha, uint32_t tag)
 		}
 	}
 
+	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {
+		if (tag == op->atio.u.isp24.exchange_addr) {
+			op->aborted = true;
+			spin_unlock(&vha->cmd_list_lock);
+			return 1;
+		}
+	}
+
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		if (tag == cmd->atio.u.isp24.exchange_addr) {
 			cmd->aborted = 1;
@@ -1638,6 +1788,18 @@ static void abort_cmds_for_lun(struct scsi_qla_host *vha,
 		if (op_key == key && op_lun == lun)
 			op->aborted = true;
 	}
+
+	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {
+		uint32_t op_key;
+		u64 op_lun;
+
+		op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
+		op_lun = scsilun_to_int(
+			(struct scsi_lun *)&op->atio.u.isp24.fcp_cmnd.lun);
+		if (op_key == key && op_lun == lun)
+			op->aborted = true;
+	}
+
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		uint32_t cmd_key;
 		uint32_t cmd_lun;
@@ -1880,7 +2042,11 @@ void qlt_xmit_tm_rsp(struct qla_tgt_mgmt_cmd *mcmd)
 
 	if (mcmd->flags == QLA24XX_MGMT_SEND_NACK) {
 		if (mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
-		    ELS_LOGO) {
+		    ELS_LOGO ||
+		    mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
+		    ELS_PRLO ||
+		    mcmd->orig_iocb.imm_ntfy.u.isp24.status_subcode ==
+		    ELS_TPRLO) {
 			ql_dbg(ql_dbg_disc, vha, 0xffff,
 			    "TM response logo %phC status %#x state %#x",
 			    mcmd->sess->port_name, mcmd->fc_tm_rsp,
@@ -4249,11 +4415,21 @@ static int abort_cmds_for_s_id(struct scsi_qla_host *vha, port_id_t *s_id)
 	spin_lock(&vha->cmd_list_lock);
 	list_for_each_entry(op, &vha->qla_sess_op_cmd_list, cmd_list) {
 		uint32_t op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
+
 		if (op_key == key) {
 			op->aborted = true;
 			count++;
 		}
 	}
+
+	list_for_each_entry(op, &vha->unknown_atio_list, cmd_list) {
+		uint32_t op_key = sid_to_key(op->atio.u.isp24.fcp_hdr.s_id);
+		if (op_key == key) {
+			op->aborted = true;
+			count++;
+		}
+	}
+
 	list_for_each_entry(cmd, &vha->qla_cmd_list, cmd_list) {
 		uint32_t cmd_key = sid_to_key(cmd->atio.u.isp24.fcp_hdr.s_id);
 		if (cmd_key == key) {
@@ -4460,6 +4636,16 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		}
 		break;
 
+
+	case ELS_TPRLO:
+		if (le16_to_cpu(iocb->u.isp24.flags) &
+			NOTIFY24XX_FLAGS_GLOBAL_TPRLO) {
+			loop_id = 0xFFFF;
+			qlt_reset(vha, iocb, QLA_TGT_NEXUS_LOSS);
+			res = 1;
+			break;
+		}
+		/* drop through */
 	case ELS_LOGO:
 	case ELS_PRLO:
 		spin_lock_irqsave(&ha->tgt.sess_lock, flags);
@@ -4469,7 +4655,6 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		if (sess) {
 			sess->login_gen++;
 			sess->fw_login_state = DSC_LS_LOGO_PEND;
-			sess->logout_on_delete = 0;
 			sess->logo_ack_needed = 1;
 			memcpy(sess->iocb, iocb, IOCB_SIZE);
 		}
@@ -4480,12 +4665,14 @@ static int qlt_24xx_handle_els(struct scsi_qla_host *vha,
 		    "%s: logo %llx res %d sess %p ",
 		    __func__, wwn, res, sess);
 		if (res == 0) {
-			/* cmd went up to ULP. look for qlt_xmit_tm_rsp()
-			   for LOGO_ACK */
+			/*
+			 * cmd went upper layer, look for qlt_xmit_tm_rsp()
+			 * for LOGO_ACK & sess delete
+			 */
 			BUG_ON(!sess);
 			res = 0;
 		} else {
-			/* cmd did not go upstair. */
+			/* cmd did not go to upper layer. */
 			if (sess) {
 				qlt_schedule_sess_for_deletion_lock(sess);
 				res = 0;
@@ -6404,6 +6591,11 @@ static void qlt_disable_vha(struct scsi_qla_host *vha)
 
 	mutex_init(&base_vha->vha_tgt.tgt_mutex);
 	mutex_init(&base_vha->vha_tgt.tgt_host_action_mutex);
+
+	INIT_LIST_HEAD(&base_vha->unknown_atio_list);
+	INIT_DELAYED_WORK(&base_vha->unknown_atio_work,
+	    qlt_unknown_atio_work_fn);
+
 	qlt_clear_mode(base_vha);
 }
 
-- 
1.8.3.1

