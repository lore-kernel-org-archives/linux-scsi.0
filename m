From: giridhar.malavali@qlogic.com
Subject: [PATCH 4/5] qla2xxx: Code changes to support new dynamic logging infrastructure (contd..)
Date: Thu, 14 Jul 2011 12:00:16 -0700
Message-ID: <1310670016-30216-6-git-send-email-giridhar.malavali@qlogic.com>
References: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:42437 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753328Ab1GNTJM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 15:09:12 -0400
In-Reply-To: <1310670016-30216-1-git-send-email-giridhar.malavali@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c    |   79 ++--
 drivers/scsi/qla2xxx/qla_dfs.c    |   16 +-
 drivers/scsi/qla2xxx/qla_gbl.h    |    5 +-
 drivers/scsi/qla2xxx/qla_gs.c     |  371 +++++++-------
 drivers/scsi/qla2xxx/qla_inline.h |    8 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |  120 ++---
 drivers/scsi/qla2xxx/qla_mbx.c    | 1091 ++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_mid.c    |  160 ++++--
 8 files changed, 923 insertions(+), 927 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index dba9eed..5c1e69f 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -11,18 +11,18 @@
  * -----------------------------------------------------
  * |             Level            |   Last Value Used  |
  * -----------------------------------------------------
- * | Module Init and Probe        |       0x0109       |
- * | Mailbox commands             |       0x1120       |
- * | Device Discovery             |       0x207d       |
- * | Queue Command and IO tracing |       0x304f       |
+ * | Module Init and Probe        |       0x0116       |
+ * | Mailbox commands             |       0x111e       |
+ * | Device Discovery             |       0x2083       |
+ * | Queue Command and IO tracing |       0x302e       |
  * | DPC Thread                   |       0x401c       |
- * | Async Events                 |       0x5058       |
+ * | Async Events                 |       0x5059       |
  * | Timer Routines               |       0x600d       |
- * | User Space Interactions      |       0x70a1       |
- * | Task Management              |       0x8032       |
- * | AER/EEH                      |       0x9010       |
+ * | User Space Interactions      |       0x709c       |
+ * | Task Management              |       0x8043       |
+ * | AER/EEH                      |       0x900f       |
  * | Virtual Port                 |       0xa007       |
- * | ISP82XX Specific             |       0xb028       |
+ * | ISP82XX Specific             |       0xb027       |
  * | MultiQ                       |       0xc00b       |
  * | Misc                         |       0xd00b       |
  * -----------------------------------------------------
@@ -409,11 +409,11 @@ qla2xxx_dump_post_process(scsi_qla_host_t *vha, int rval)
 	struct qla_hw_data *ha = vha->hw;
 
 	if (rval != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha,
-		    "Failed to dump firmware (%x)!!!\n", rval);
+		ql_log(ql_log_warn, vha, 0xd000,
+		    "Failed to dump firmware (%x).\n", rval);
 		ha->fw_dumped = 0;
 	} else {
-		qla_printk(KERN_INFO, ha,
+		ql_log(ql_log_info, vha, 0xd001,
 		    "Firmware dump saved to temp buffer (%ld/%p).\n",
 		    vha->host_no, ha->fw_dump);
 		ha->fw_dumped = 1;
@@ -445,15 +445,16 @@ qla2300_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "No buffer available for dump!!!\n");
+		ql_log(ql_log_warn, vha, 0xd002,
+		    "No buffer available for dump.\n");
 		goto qla2300_fw_dump_failed;
 	}
 
 	if (ha->fw_dumped) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		ql_log(ql_log_warn, vha, 0xd003,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n",
+		    ha->fw_dump);
 		goto qla2300_fw_dump_failed;
 	}
 	fw = &ha->fw_dump->isp.isp23;
@@ -608,15 +609,16 @@ qla2100_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "No buffer available for dump!!!\n");
+		ql_log(ql_log_warn, vha, 0xd004,
+		    "No buffer available for dump.\n");
 		goto qla2100_fw_dump_failed;
 	}
 
 	if (ha->fw_dumped) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		ql_log(ql_log_warn, vha, 0xd005,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n",
+		    ha->fw_dump);
 		goto qla2100_fw_dump_failed;
 	}
 	fw = &ha->fw_dump->isp.isp21;
@@ -805,15 +807,16 @@ qla24xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "No buffer available for dump!!!\n");
+		ql_log(ql_log_warn, vha, 0xd006,
+		    "No buffer available for dump.\n");
 		goto qla24xx_fw_dump_failed;
 	}
 
 	if (ha->fw_dumped) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		ql_log(ql_log_warn, vha, 0xd007,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n",
+		    ha->fw_dump);
 		goto qla24xx_fw_dump_failed;
 	}
 	fw = &ha->fw_dump->isp.isp24;
@@ -1043,15 +1046,16 @@ qla25xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "No buffer available for dump!!!\n");
+		ql_log(ql_log_warn, vha, 0xd008,
+		    "No buffer available for dump.\n");
 		goto qla25xx_fw_dump_failed;
 	}
 
 	if (ha->fw_dumped) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		ql_log(ql_log_warn, vha, 0xd009,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n",
+		    ha->fw_dump);
 		goto qla25xx_fw_dump_failed;
 	}
 	fw = &ha->fw_dump->isp.isp25;
@@ -1354,15 +1358,16 @@ qla81xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 		spin_lock_irqsave(&ha->hardware_lock, flags);
 
 	if (!ha->fw_dump) {
-		qla_printk(KERN_WARNING, ha,
-		    "No buffer available for dump!!!\n");
+		ql_log(ql_log_warn, vha, 0xd00a,
+		    "No buffer available for dump.\n");
 		goto qla81xx_fw_dump_failed;
 	}
 
 	if (ha->fw_dumped) {
-		qla_printk(KERN_WARNING, ha,
-		    "Firmware has been previously dumped (%p) -- ignoring "
-		    "request...\n", ha->fw_dump);
+		ql_log(ql_log_warn, vha, 0xd00b,
+		    "Firmware has been previously dumped (%p) "
+		    "-- ignoring request.\n",
+		    ha->fw_dump);
 		goto qla81xx_fw_dump_failed;
 	}
 	fw = &ha->fw_dump->isp.isp81;
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index a5a4e12..0b4c2b7 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -64,7 +64,7 @@ qla2x00_dfs_fce_open(struct inode *inode, struct file *file)
 	/* Pause tracing to flush FCE buffers. */
 	rval = qla2x00_disable_fce_trace(vha, &ha->fce_wr, &ha->fce_rd);
 	if (rval)
-		qla_printk(KERN_WARNING, ha,
+		ql_dbg(ql_dbg_user, vha, 0x705c,
 		    "DebugFS: Unable to disable FCE (%d).\n", rval);
 
 	ha->flags.fce_enabled = 0;
@@ -92,7 +92,7 @@ qla2x00_dfs_fce_release(struct inode *inode, struct file *file)
 	rval = qla2x00_enable_fce_trace(vha, ha->fce_dma, ha->fce_bufs,
 	    ha->fce_mb, &ha->fce_bufs);
 	if (rval) {
-		qla_printk(KERN_WARNING, ha,
+		ql_dbg(ql_dbg_user, vha, 0x700d,
 		    "DebugFS: Unable to reinitialize FCE (%d).\n", rval);
 		ha->flags.fce_enabled = 0;
 	}
@@ -125,8 +125,8 @@ qla2x00_dfs_setup(scsi_qla_host_t *vha)
 	atomic_set(&qla2x00_dfs_root_count, 0);
 	qla2x00_dfs_root = debugfs_create_dir(QLA2XXX_DRIVER_NAME, NULL);
 	if (!qla2x00_dfs_root) {
-		qla_printk(KERN_NOTICE, ha,
-		    "DebugFS: Unable to create root directory.\n");
+		ql_log(ql_log_warn, vha, 0x00f7,
+		    "Unable to create debugfs root directory.\n");
 		goto out;
 	}
 
@@ -137,8 +137,8 @@ create_dir:
 	mutex_init(&ha->fce_mutex);
 	ha->dfs_dir = debugfs_create_dir(vha->host_str, qla2x00_dfs_root);
 	if (!ha->dfs_dir) {
-		qla_printk(KERN_NOTICE, ha,
-		    "DebugFS: Unable to create ha directory.\n");
+		ql_log(ql_log_warn, vha, 0x00f8,
+		    "Unable to create debugfs ha directory.\n");
 		goto out;
 	}
 
@@ -148,8 +148,8 @@ create_nodes:
 	ha->dfs_fce = debugfs_create_file("fce", S_IRUSR, ha->dfs_dir, vha,
 	    &dfs_fce_ops);
 	if (!ha->dfs_fce) {
-		qla_printk(KERN_NOTICE, ha,
-		    "DebugFS: Unable to fce node.\n");
+		ql_log(ql_log_warn, vha, 0x00f9,
+		    "Unable to create debugfs fce node.\n");
 		goto out;
 	}
 out:
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 38aef5d..29b1a3e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -185,7 +185,7 @@ extern int qla24xx_start_scsi(srb_t *sp);
 int qla2x00_marker(struct scsi_qla_host *, struct req_que *, struct rsp_que *,
 						uint16_t, uint16_t, uint8_t);
 extern int qla2x00_start_sp(srb_t *);
-extern uint16_t qla24xx_calc_iocbs(uint16_t);
+extern uint16_t qla24xx_calc_iocbs(scsi_qla_host_t *, uint16_t);
 extern void qla24xx_build_scsi_iocbs(srb_t *, struct cmd_type_7 *, uint16_t);
 extern int qla24xx_dif_start_scsi(srb_t *);
 
@@ -481,7 +481,8 @@ extern int qla2x00_loopback_test(scsi_qla_host_t *, struct msg_echo_lb *, uint16
 extern int qla2x00_echo_test(scsi_qla_host_t *,
 	struct msg_echo_lb *, uint16_t *);
 extern int qla24xx_update_all_fcp_prio(scsi_qla_host_t *);
-extern int qla24xx_fcp_prio_cfg_valid(struct qla_fcp_prio_cfg *, uint8_t);
+extern int qla24xx_fcp_prio_cfg_valid(scsi_qla_host_t *,
+	struct qla_fcp_prio_cfg *, uint8_t);
 
 /*
  * Global Function Prototypes in qla_dfs.c source file.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 8cd9066..37937aa 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -121,11 +121,10 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 
 	rval = QLA_FUNCTION_FAILED;
 	if (ms_pkt->entry_status != 0) {
-		DEBUG2_3(printk(KERN_WARNING "scsi(%ld): %s failed, error status "
-		    "(%x) on port_id: %02x%02x%02x.\n",
-		    vha->host_no, routine, ms_pkt->entry_status,
-		    vha->d_id.b.domain, vha->d_id.b.area,
-		    vha->d_id.b.al_pa));
+		ql_dbg(ql_dbg_disc, vha, 0x2031,
+		    "%s failed, error status (%x) on port_id: %02x%02x%02x.\n",
+		    routine, ms_pkt->entry_status, vha->d_id.b.domain,
+		    vha->d_id.b.area, vha->d_id.b.al_pa);
 	} else {
 		if (IS_FWI2_CAPABLE(ha))
 			comp_status = le16_to_cpu(
@@ -138,24 +137,24 @@ qla2x00_chk_ms_status(scsi_qla_host_t *vha, ms_iocb_entry_t *ms_pkt,
 		case CS_DATA_OVERRUN:		/* Overrun? */
 			if (ct_rsp->header.response !=
 			    __constant_cpu_to_be16(CT_ACCEPT_RESPONSE)) {
-				DEBUG2_3(printk("scsi(%ld): %s failed, "
-				    "rejected request on port_id: %02x%02x%02x\n",
-				    vha->host_no, routine,
+				ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2077,
+				    "%s failed rejected request on port_id: "
+				    "%02x%02x%02x.\n", routine,
 				    vha->d_id.b.domain, vha->d_id.b.area,
-				    vha->d_id.b.al_pa));
-				DEBUG2_3(qla2x00_dump_buffer(
-				    (uint8_t *)&ct_rsp->header,
-				    sizeof(struct ct_rsp_hdr)));
+				    vha->d_id.b.al_pa);
+				ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha,
+				    0x2078, (uint8_t *)&ct_rsp->header,
+				    sizeof(struct ct_rsp_hdr));
 				rval = QLA_INVALID_COMMAND;
 			} else
 				rval = QLA_SUCCESS;
 			break;
 		default:
-			DEBUG2_3(printk("scsi(%ld): %s failed, completion "
-			    "status (%x) on port_id: %02x%02x%02x.\n",
-			    vha->host_no, routine, comp_status,
+			ql_dbg(ql_dbg_disc, vha, 0x2033,
+			    "%s failed, completion status (%x) on port_id: "
+			    "%02x%02x%02x.\n", routine, comp_status,
 			    vha->d_id.b.domain, vha->d_id.b.area,
-			    vha->d_id.b.al_pa));
+			    vha->d_id.b.al_pa);
 			break;
 		}
 	}
@@ -202,8 +201,8 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): GA_NXT issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2062,
+		    "GA_NXT issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "GA_NXT") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
@@ -222,11 +221,10 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    ct_rsp->rsp.ga_nxt.port_type != NS_NL_PORT_TYPE)
 			fcport->d_id.b.domain = 0xf0;
 
-		DEBUG2_3(printk("scsi(%ld): GA_NXT entry - "
-		    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
+		ql_dbg(ql_dbg_disc, vha, 0x2063,
+		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "portid=%02x%02x%02x.\n",
-		    vha->host_no,
+		    "port_id=%02x%02x%02x.\n",
 		    fcport->node_name[0], fcport->node_name[1],
 		    fcport->node_name[2], fcport->node_name[3],
 		    fcport->node_name[4], fcport->node_name[5],
@@ -236,7 +234,7 @@ qla2x00_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    fcport->port_name[4], fcport->port_name[5],
 		    fcport->port_name[6], fcport->port_name[7],
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa));
+		    fcport->d_id.b.al_pa);
 	}
 
 	return (rval);
@@ -287,8 +285,8 @@ qla2x00_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): GID_PT issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2055,
+		    "GID_PT issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "GID_PT") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
@@ -364,8 +362,8 @@ qla2x00_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GPN_ID issue IOCB failed "
-			    "(%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x2056,
+			    "GPN_ID issue IOCB failed (%d).\n", rval);
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
@@ -424,8 +422,8 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GNN_ID issue IOCB failed "
-			    "(%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x2057,
+			    "GNN_ID issue IOCB failed (%d).\n", rval);
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GNN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
@@ -434,11 +432,10 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			memcpy(list[i].node_name,
 			    ct_rsp->rsp.gnn_id.node_name, WWN_SIZE);
 
-			DEBUG2_3(printk("scsi(%ld): GID_PT entry - "
-			    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
-			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
+			ql_dbg(ql_dbg_disc, vha, 0x2058,
+			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02X%02x "
+			    "pn %02x%02x%02x%02x%02x%02x%02X%02x "
 			    "portid=%02x%02x%02x.\n",
-			    vha->host_no,
 			    list[i].node_name[0], list[i].node_name[1],
 			    list[i].node_name[2], list[i].node_name[3],
 			    list[i].node_name[4], list[i].node_name[5],
@@ -448,7 +445,7 @@ qla2x00_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    list[i].port_name[4], list[i].port_name[5],
 			    list[i].port_name[6], list[i].port_name[7],
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
-			    list[i].d_id.b.al_pa));
+			    list[i].d_id.b.al_pa);
 		}
 
 		/* Last device exit. */
@@ -499,14 +496,14 @@ qla2x00_rft_id(scsi_qla_host_t *vha)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RFT_ID issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2043,
+		    "RFT_ID issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RFT_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RFT_ID exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2044,
+		    "RFT_ID exiting normally.\n");
 	}
 
 	return (rval);
@@ -528,8 +525,8 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 	struct ct_sns_rsp	*ct_rsp;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		DEBUG2(printk("scsi(%ld): RFF_ID call unsupported on "
-		    "ISP2100/ISP2200.\n", vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2046,
+		    "RFF_ID call not supported on ISP2100/ISP2200.\n");
 		return (QLA_SUCCESS);
 	}
 
@@ -556,14 +553,14 @@ qla2x00_rff_id(scsi_qla_host_t *vha)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RFF_ID issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2047,
+		    "RFF_ID issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RFF_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RFF_ID exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2048,
+		    "RFF_ID exiting normally.\n");
 	}
 
 	return (rval);
@@ -609,14 +606,14 @@ qla2x00_rnn_id(scsi_qla_host_t *vha)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RNN_ID issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x204d,
+		    "RNN_ID issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RNN_ID") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RNN_ID exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x204e,
+		    "RNN_ID exiting normally.\n");
 	}
 
 	return (rval);
@@ -647,8 +644,8 @@ qla2x00_rsnn_nn(scsi_qla_host_t *vha)
 	struct ct_sns_rsp	*ct_rsp;
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha)) {
-		DEBUG2(printk("scsi(%ld): RSNN_ID call unsupported on "
-		    "ISP2100/ISP2200.\n", vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2050,
+		    "RSNN_ID call unsupported on ISP2100/ISP2200.\n");
 		return (QLA_SUCCESS);
 	}
 
@@ -682,14 +679,14 @@ qla2x00_rsnn_nn(scsi_qla_host_t *vha)
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RSNN_NN issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2051,
+		    "RSNN_NN issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RSNN_NN") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RSNN_NN exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2052,
+		    "RSNN_NN exiting normally.\n");
 	}
 
 	return (rval);
@@ -757,13 +754,14 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): GA_NXT Send SNS failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x205f,
+		    "GA_NXT Send SNS failed (%d).\n", rval);
 	} else if (sns_cmd->p.gan_data[8] != 0x80 ||
 	    sns_cmd->p.gan_data[9] != 0x02) {
-		DEBUG2_3(printk("scsi(%ld): GA_NXT failed, rejected request, "
-		    "ga_nxt_rsp:\n", vha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gan_data, 16));
+		ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x207d,
+		    "GA_NXT failed, rejected request ga_nxt_rsp:\n");
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2074,
+		    sns_cmd->p.gan_data, 16);
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* Populate fc_port_t entry. */
@@ -778,11 +776,10 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    sns_cmd->p.gan_data[16] != NS_NL_PORT_TYPE)
 			fcport->d_id.b.domain = 0xf0;
 
-		DEBUG2_3(printk("scsi(%ld): GA_NXT entry - "
-		    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
+		ql_dbg(ql_dbg_disc, vha, 0x2061,
+		    "GA_NXT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
 		    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
-		    "portid=%02x%02x%02x.\n",
-		    vha->host_no,
+		    "port_id=%02x%02x%02x.\n",
 		    fcport->node_name[0], fcport->node_name[1],
 		    fcport->node_name[2], fcport->node_name[3],
 		    fcport->node_name[4], fcport->node_name[5],
@@ -792,7 +789,7 @@ qla2x00_sns_ga_nxt(scsi_qla_host_t *vha, fc_port_t *fcport)
 		    fcport->port_name[4], fcport->port_name[5],
 		    fcport->port_name[6], fcport->port_name[7],
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa));
+		    fcport->d_id.b.al_pa);
 	}
 
 	return (rval);
@@ -831,13 +828,14 @@ qla2x00_sns_gid_pt(scsi_qla_host_t *vha, sw_info_t *list)
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): GID_PT Send SNS failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x206d,
+		    "GID_PT Send SNS failed (%d).\n", rval);
 	} else if (sns_cmd->p.gid_data[8] != 0x80 ||
 	    sns_cmd->p.gid_data[9] != 0x02) {
-		DEBUG2_3(printk("scsi(%ld): GID_PT failed, rejected request, "
-		    "gid_rsp:\n", vha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gid_data, 16));
+		ql_dbg(ql_dbg_disc, vha, 0x202f,
+		    "GID_PT failed, rejected request, gid_rsp:\n");
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2081,
+		    sns_cmd->p.gid_data, 16);
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* Set port IDs in switch info list. */
@@ -900,13 +898,14 @@ qla2x00_sns_gpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GPN_ID_SNS_CMD_SIZE / 2, sizeof(struct sns_cmd_pkt));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GPN_ID Send SNS failed "
-			    "(%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x2032,
+			    "GPN_ID Send SNS failed (%d).\n", rval);
 		} else if (sns_cmd->p.gpn_data[8] != 0x80 ||
 		    sns_cmd->p.gpn_data[9] != 0x02) {
-			DEBUG2_3(printk("scsi(%ld): GPN_ID failed, rejected "
-			    "request, gpn_rsp:\n", vha->host_no));
-			DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gpn_data, 16));
+			ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x207e,
+			    "GPN_ID failed, rejected request, gpn_rsp:\n");
+			ql_dump_buffer(ql_dbg_disc, vha, 0x207f,
+			    sns_cmd->p.gpn_data, 16);
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Save portname */
@@ -955,24 +954,24 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    GNN_ID_SNS_CMD_SIZE / 2, sizeof(struct sns_cmd_pkt));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GNN_ID Send SNS failed "
-			    "(%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x203f,
+			    "GNN_ID Send SNS failed (%d).\n", rval);
 		} else if (sns_cmd->p.gnn_data[8] != 0x80 ||
 		    sns_cmd->p.gnn_data[9] != 0x02) {
-			DEBUG2_3(printk("scsi(%ld): GNN_ID failed, rejected "
-			    "request, gnn_rsp:\n", vha->host_no));
-			DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.gnn_data, 16));
+			ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2082,
+			    "GNN_ID failed, rejected request, gnn_rsp:\n");
+			ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x207a,
+			    sns_cmd->p.gnn_data, 16);
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Save nodename */
 			memcpy(list[i].node_name, &sns_cmd->p.gnn_data[16],
 			    WWN_SIZE);
 
-			DEBUG2_3(printk("scsi(%ld): GID_PT entry - "
-			    "nn %02x%02x%02x%02x%02x%02x%02x%02x "
+			ql_dbg(ql_dbg_disc, vha, 0x206e,
+			    "GID_PT entry - nn %02x%02x%02x%02x%02x%02x%02x%02x "
 			    "pn %02x%02x%02x%02x%02x%02x%02x%02x "
-			    "portid=%02x%02x%02x.\n",
-			    vha->host_no,
+			    "port_id=%02x%02x%02x.\n",
 			    list[i].node_name[0], list[i].node_name[1],
 			    list[i].node_name[2], list[i].node_name[3],
 			    list[i].node_name[4], list[i].node_name[5],
@@ -982,7 +981,7 @@ qla2x00_sns_gnn_id(scsi_qla_host_t *vha, sw_info_t *list)
 			    list[i].port_name[4], list[i].port_name[5],
 			    list[i].port_name[6], list[i].port_name[7],
 			    list[i].d_id.b.domain, list[i].d_id.b.area,
-			    list[i].d_id.b.al_pa));
+			    list[i].d_id.b.al_pa);
 		}
 
 		/* Last device exit. */
@@ -1025,17 +1024,18 @@ qla2x00_sns_rft_id(scsi_qla_host_t *vha)
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RFT_ID Send SNS failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2060,
+		    "RFT_ID Send SNS failed (%d).\n", rval);
 	} else if (sns_cmd->p.rft_data[8] != 0x80 ||
 	    sns_cmd->p.rft_data[9] != 0x02) {
-		DEBUG2_3(printk("scsi(%ld): RFT_ID failed, rejected request, "
-		    "rft_rsp:\n", vha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.rft_data, 16));
+		ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x2083,
+		    "RFT_ID failed, rejected request rft_rsp:\n");
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2080,
+		    sns_cmd->p.rft_data, 16);
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RFT_ID exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2073,
+		    "RFT_ID exiting normally.\n");
 	}
 
 	return (rval);
@@ -1081,17 +1081,18 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *vha)
 	    sizeof(struct sns_cmd_pkt));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RNN_ID Send SNS failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x204a,
+		    "RNN_ID Send SNS failed (%d).\n", rval);
 	} else if (sns_cmd->p.rnn_data[8] != 0x80 ||
 	    sns_cmd->p.rnn_data[9] != 0x02) {
-		DEBUG2_3(printk("scsi(%ld): RNN_ID failed, rejected request, "
-		    "rnn_rsp:\n", vha->host_no));
-		DEBUG2_3(qla2x00_dump_buffer(sns_cmd->p.rnn_data, 16));
+		ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x207b,
+		    "RNN_ID failed, rejected request, rnn_rsp:\n");
+		ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x207c,
+		    sns_cmd->p.rnn_data, 16);
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RNN_ID exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x204c,
+		    "RNN_ID exiting normally.\n");
 	}
 
 	return (rval);
@@ -1116,10 +1117,10 @@ qla2x00_mgmt_svr_login(scsi_qla_host_t *vha)
 	ha->isp_ops->fabric_login(vha, vha->mgmt_svr_loop_id, 0xff, 0xff, 0xfa,
 	    mb, BIT_1|BIT_0);
 	if (mb[0] != MBS_COMMAND_COMPLETE) {
-		DEBUG2_13(printk("%s(%ld): Failed MANAGEMENT_SERVER login: "
-		    "loop_id=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x\n",
-		    __func__, vha->host_no, vha->mgmt_svr_loop_id, mb[0], mb[1],
-		    mb[2], mb[6], mb[7]));
+		ql_dbg(ql_dbg_disc, vha, 0x2024,
+		    "Failed management_server login: loopid=%x mb[0]=%x "
+		    "mb[1]=%x mb[2]=%x mb[6]=%x mb[7]=%x.\n",
+		    vha->mgmt_svr_loop_id, mb[0], mb[1], mb[2], mb[6], mb[7]);
 		ret = QLA_FUNCTION_FAILED;
 	} else
 		vha->flags.management_server_logged_in = 1;
@@ -1292,11 +1293,12 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	memcpy(eiter->a.node_name, vha->node_name, WWN_SIZE);
 	size += 4 + WWN_SIZE;
 
-	DEBUG13(printk("%s(%ld): NODENAME=%02x%02x%02x%02x%02x%02x%02x%02x.\n",
-	    __func__, vha->host_no,
-	    eiter->a.node_name[0], eiter->a.node_name[1], eiter->a.node_name[2],
-	    eiter->a.node_name[3], eiter->a.node_name[4], eiter->a.node_name[5],
-	    eiter->a.node_name[6], eiter->a.node_name[7]));
+	ql_dbg(ql_dbg_disc, vha, 0x2025,
+	    "NodeName = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
+	    eiter->a.node_name[0], eiter->a.node_name[1],
+	    eiter->a.node_name[2], eiter->a.node_name[3],
+	    eiter->a.node_name[4], eiter->a.node_name[5],
+	    eiter->a.node_name[6], eiter->a.node_name[7]);
 
 	/* Manufacturer. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1307,8 +1309,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MANUFACTURER=%s.\n", __func__, vha->host_no,
-	    eiter->a.manufacturer));
+	ql_dbg(ql_dbg_disc, vha, 0x2026,
+	    "Manufacturer = %s.\n", eiter->a.manufacturer);
 
 	/* Serial number. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1320,8 +1322,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): SERIALNO=%s.\n", __func__, vha->host_no,
-	    eiter->a.serial_num));
+	ql_dbg(ql_dbg_disc, vha, 0x2027,
+	    "Serial no. = %s.\n", eiter->a.serial_num);
 
 	/* Model name. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1332,8 +1334,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MODEL_NAME=%s.\n", __func__, vha->host_no,
-	    eiter->a.model));
+	ql_dbg(ql_dbg_disc, vha, 0x2028,
+	    "Model Name = %s.\n", eiter->a.model);
 
 	/* Model description. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1345,8 +1347,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): MODEL_DESC=%s.\n", __func__, vha->host_no,
-	    eiter->a.model_desc));
+	ql_dbg(ql_dbg_disc, vha, 0x2029,
+	    "Model Desc = %s.\n", eiter->a.model_desc);
 
 	/* Hardware version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1357,8 +1359,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): HARDWAREVER=%s.\n", __func__, vha->host_no,
-	    eiter->a.hw_version));
+	ql_dbg(ql_dbg_disc, vha, 0x202a,
+	    "Hardware ver = %s.\n", eiter->a.hw_version);
 
 	/* Driver version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1369,8 +1371,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): DRIVERVER=%s.\n", __func__, vha->host_no,
-	    eiter->a.driver_version));
+	ql_dbg(ql_dbg_disc, vha, 0x202b,
+	    "Driver ver = %s.\n", eiter->a.driver_version);
 
 	/* Option ROM version. */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1381,8 +1383,8 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): OPTROMVER=%s.\n", __func__, vha->host_no,
-	    eiter->a.orom_version));
+	ql_dbg(ql_dbg_disc, vha , 0x202c,
+	    "Optrom vers = %s.\n", eiter->a.orom_version);
 
 	/* Firmware version */
 	eiter = (struct ct_fdmi_hba_attr *) (entries + size);
@@ -1393,44 +1395,46 @@ qla2x00_fdmi_rhba(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): FIRMWAREVER=%s.\n", __func__, vha->host_no,
-	    eiter->a.fw_version));
+	ql_dbg(ql_dbg_disc, vha, 0x202d,
+	    "Firmware vers = %s.\n", eiter->a.fw_version);
 
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
-	DEBUG13(printk("%s(%ld): RHBA identifier="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
-	    vha->host_no, ct_req->req.rhba.hba_identifier[0],
+	ql_dbg(ql_dbg_disc, vha, 0x202e,
+	    "RHBA identifier = "
+	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n",
+	    ct_req->req.rhba.hba_identifier[0],
 	    ct_req->req.rhba.hba_identifier[1],
 	    ct_req->req.rhba.hba_identifier[2],
 	    ct_req->req.rhba.hba_identifier[3],
 	    ct_req->req.rhba.hba_identifier[4],
 	    ct_req->req.rhba.hba_identifier[5],
 	    ct_req->req.rhba.hba_identifier[6],
-	    ct_req->req.rhba.hba_identifier[7], size));
-	DEBUG13(qla2x00_dump_buffer(entries, size));
+	    ct_req->req.rhba.hba_identifier[7], size);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2076,
+	    entries, size);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RHBA issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2030,
+		    "RHBA issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RHBA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 		if (ct_rsp->header.reason_code == CT_REASON_CANNOT_PERFORM &&
 		    ct_rsp->header.explanation_code ==
 		    CT_EXPL_ALREADY_REGISTERED) {
-			DEBUG2_13(printk("%s(%ld): HBA already registered.\n",
-			    __func__, vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x2034,
+			    "HBA already registered.\n");
 			rval = QLA_ALREADY_REGISTERED;
 		}
 	} else {
-		DEBUG2(printk("scsi(%ld): RHBA exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2035,
+		    "RHBA exiting normally.\n");
 	}
 
 	return rval;
@@ -1464,26 +1468,26 @@ qla2x00_fdmi_dhba(scsi_qla_host_t *vha)
 	/* Prepare FDMI command arguments -- portname. */
 	memcpy(ct_req->req.dhba.port_name, vha->port_name, WWN_SIZE);
 
-	DEBUG13(printk("%s(%ld): DHBA portname="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x.\n", __func__, vha->host_no,
+	ql_dbg(ql_dbg_disc, vha, 0x2036,
+	    "DHBA portname = %02x%02x%02x%02x%02x%02x%02x%02x.\n",
 	    ct_req->req.dhba.port_name[0], ct_req->req.dhba.port_name[1],
 	    ct_req->req.dhba.port_name[2], ct_req->req.dhba.port_name[3],
 	    ct_req->req.dhba.port_name[4], ct_req->req.dhba.port_name[5],
-	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]));
+	    ct_req->req.dhba.port_name[6], ct_req->req.dhba.port_name[7]);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): DHBA issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2037,
+		    "DHBA issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "DHBA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): DHBA exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2038,
+		    "DHBA exiting normally.\n");
 	}
 
 	return rval;
@@ -1534,9 +1538,10 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter->a.fc4_types[2] = 0x01;
 	size += 4 + 32;
 
-	DEBUG13(printk("%s(%ld): FC4_TYPES=%02x %02x.\n", __func__,
-		vha->host_no, eiter->a.fc4_types[2],
-		eiter->a.fc4_types[1]));
+	ql_dbg(ql_dbg_disc, vha, 0x2039,
+	    "FC4_TYPES=%02x %02x.\n",
+	    eiter->a.fc4_types[2],
+	    eiter->a.fc4_types[1]);
 
 	/* Supported speed. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
@@ -1561,8 +1566,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 		    FDMI_PORT_SPEED_1GB);
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): SUPPORTED_SPEED=%x.\n", __func__, vha->host_no,
-	    eiter->a.sup_speed));
+	ql_dbg(ql_dbg_disc, vha, 0x203a,
+	    "Supported_Speed=%x.\n", eiter->a.sup_speed);
 
 	/* Current speed. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
@@ -1596,8 +1601,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	}
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): CURRENT_SPEED=%x.\n", __func__, vha->host_no,
-	    eiter->a.cur_speed));
+	ql_dbg(ql_dbg_disc, vha, 0x203b,
+	    "Current_Speed=%x.\n", eiter->a.cur_speed);
 
 	/* Max frame size. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
@@ -1609,8 +1614,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter->a.max_frame_size = cpu_to_be32(max_frame_size);
 	size += 4 + 4;
 
-	DEBUG13(printk("%s(%ld): MAX_FRAME_SIZE=%x.\n", __func__, vha->host_no,
-	    eiter->a.max_frame_size));
+	ql_dbg(ql_dbg_disc, vha, 0x203c,
+	    "Max_Frame_Size=%x.\n", eiter->a.max_frame_size);
 
 	/* OS device name. */
 	eiter = (struct ct_fdmi_port_attr *) (entries + size);
@@ -1621,8 +1626,8 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 	eiter->len = cpu_to_be16(4 + alen);
 	size += 4 + alen;
 
-	DEBUG13(printk("%s(%ld): OS_DEVICE_NAME=%s.\n", __func__, vha->host_no,
-	    eiter->a.os_dev_name));
+	ql_dbg(ql_dbg_disc, vha, 0x204b,
+	    "OS_Device_Name=%s.\n", eiter->a.os_dev_name);
 
 	/* Hostname. */
 	if (strlen(fc_host_system_hostname(vha->host))) {
@@ -1637,35 +1642,36 @@ qla2x00_fdmi_rpa(scsi_qla_host_t *vha)
 		eiter->len = cpu_to_be16(4 + alen);
 		size += 4 + alen;
 
-		DEBUG13(printk("%s(%ld): HOSTNAME=%s.\n", __func__,
-		    vha->host_no, eiter->a.host_name));
+		ql_dbg(ql_dbg_disc, vha, 0x203d,
+		    "HostName=%s.\n", eiter->a.host_name);
 	}
 
 	/* Update MS request size. */
 	qla2x00_update_ms_fdmi_iocb(vha, size + 16);
 
-	DEBUG13(printk("%s(%ld): RPA portname="
-	    "%02x%02x%02x%02x%02x%02x%02x%02x size=%d.\n", __func__,
-	    vha->host_no, ct_req->req.rpa.port_name[0],
-	    ct_req->req.rpa.port_name[1], ct_req->req.rpa.port_name[2],
-	    ct_req->req.rpa.port_name[3], ct_req->req.rpa.port_name[4],
-	    ct_req->req.rpa.port_name[5], ct_req->req.rpa.port_name[6],
-	    ct_req->req.rpa.port_name[7], size));
-	DEBUG13(qla2x00_dump_buffer(entries, size));
+	ql_dbg(ql_dbg_disc, vha, 0x203e,
+	    "RPA portname= %02x%02x%02x%02x%02X%02x%02x%02x size=%d.\n",
+	    ct_req->req.rpa.port_name[0], ct_req->req.rpa.port_name[1],
+	    ct_req->req.rpa.port_name[2], ct_req->req.rpa.port_name[3],
+	    ct_req->req.rpa.port_name[4], ct_req->req.rpa.port_name[5],
+	    ct_req->req.rpa.port_name[6], ct_req->req.rpa.port_name[7],
+	    size);
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x2079,
+	    entries, size);
 
 	/* Execute MS IOCB */
 	rval = qla2x00_issue_iocb(vha, ha->ms_iocb, ha->ms_iocb_dma,
 	    sizeof(ms_iocb_entry_t));
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3(printk("scsi(%ld): RPA issue IOCB failed (%d).\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_disc, vha, 0x2040,
+		    "RPA issue IOCB failed (%d).\n", rval);
 	} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp, "RPA") !=
 	    QLA_SUCCESS) {
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("scsi(%ld): RPA exiting normally.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_disc, vha, 0x2041,
+		    "RPA exiting nornally.\n");
 	}
 
 	return rval;
@@ -1749,8 +1755,8 @@ qla2x00_gfpn_id(scsi_qla_host_t *vha, sw_info_t *list)
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GFPN_ID issue IOCB "
-			    "failed (%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x2023,
+			    "GFPN_ID issue IOCB failed (%d).\n", rval);
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GFPN_ID") != QLA_SUCCESS) {
 			rval = QLA_FUNCTION_FAILED;
@@ -1860,8 +1866,8 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 		    sizeof(ms_iocb_entry_t));
 		if (rval != QLA_SUCCESS) {
 			/*EMPTY*/
-			DEBUG2_3(printk("scsi(%ld): GPSC issue IOCB "
-			    "failed (%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x2059,
+			    "GPSC issue IOCB failed (%d).\n", rval);
 		} else if ((rval = qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 		    "GPSC")) != QLA_SUCCESS) {
 			/* FM command unsupported? */
@@ -1870,9 +1876,9 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 				CT_REASON_INVALID_COMMAND_CODE ||
 			     ct_rsp->header.reason_code ==
 				CT_REASON_COMMAND_UNSUPPORTED)) {
-				DEBUG2(printk("scsi(%ld): GPSC command "
-				    "unsupported, disabling query...\n",
-				    vha->host_no));
+				ql_dbg(ql_dbg_disc, vha, 0x205a,
+				    "GPSC command unsupported, disabling "
+				    "query.\n");
 				ha->flags.gpsc_supported = 0;
 				rval = QLA_FUNCTION_FAILED;
 				break;
@@ -1898,9 +1904,10 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 				break;
 			}
 
-			DEBUG2_3(printk("scsi(%ld): GPSC ext entry - "
-			    "fpn %02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
-			    "speed=%04x.\n", vha->host_no,
+			ql_dbg(ql_dbg_disc, vha, 0x205b,
+			    "GPSC ext entry - fpn "
+			    "%02x%02x%02x%02x%02x%02x%02x%02x speeds=%04x "
+			    "speed=%04x.\n",
 			    list[i].fabric_port_name[0],
 			    list[i].fabric_port_name[1],
 			    list[i].fabric_port_name[2],
@@ -1910,7 +1917,7 @@ qla2x00_gpsc(scsi_qla_host_t *vha, sw_info_t *list)
 			    list[i].fabric_port_name[6],
 			    list[i].fabric_port_name[7],
 			    be16_to_cpu(ct_rsp->rsp.gpsc.speeds),
-			    be16_to_cpu(ct_rsp->rsp.gpsc.speed)));
+			    be16_to_cpu(ct_rsp->rsp.gpsc.speed));
 		}
 
 		/* Last device exit. */
@@ -1968,14 +1975,12 @@ qla2x00_gff_id(scsi_qla_host_t *vha, sw_info_t *list)
 		   sizeof(ms_iocb_entry_t));
 
 		if (rval != QLA_SUCCESS) {
-			DEBUG2_3(printk(KERN_INFO
-			    "scsi(%ld): GFF_ID issue IOCB failed "
-			    "(%d).\n", vha->host_no, rval));
+			ql_dbg(ql_dbg_disc, vha, 0x205c,
+			    "GFF_ID issue IOCB failed (%d).\n", rval);
 		} else if (qla2x00_chk_ms_status(vha, ms_pkt, ct_rsp,
 			       "GFF_ID") != QLA_SUCCESS) {
-			DEBUG2_3(printk(KERN_INFO
-			    "scsi(%ld): GFF_ID IOCB status had a "
-			    "failure status code\n", vha->host_no));
+			ql_dbg(ql_dbg_disc, vha, 0x205d,
+			    "GFF_ID IOCB status had a failure status code.\n");
 		} else {
 			fcp_scsi_features =
 			   ct_rsp->rsp.gff_id.fc4_features[GFF_FCP_SCSI_OFFSET];
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 4c8167e..d2e904b 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -94,11 +94,11 @@ qla2x00_set_fcport_state(fc_port_t *fcport, int state)
 
 	/* Don't print state transitions during initial allocation of fcport */
 	if (old_state && old_state != state) {
-		DEBUG(qla_printk(KERN_WARNING, fcport->vha->hw,
-		    "scsi(%ld): FCPort state transitioned from %s to %s - "
-		    "portid=%02x%02x%02x.\n", fcport->vha->host_no,
+		ql_dbg(ql_dbg_disc, fcport->vha, 0x207d,
+		    "FCPort state transitioned from %s to %s - "
+		    "portid=%02x%02x%02x.\n",
 		    port_state_str[old_state], port_state_str[state],
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
-		    fcport->d_id.b.al_pa));
+		    fcport->d_id.b.al_pa);
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 7bac3cd..49d6906 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -150,7 +150,8 @@ qla24xx_configure_prot_mode(srb_t *sp, uint16_t *fw_prot_opts)
 
 	/* We only support T10 DIF right now */
 	if (guard != SHOST_DIX_GUARD_CRC) {
-		DEBUG2(printk(KERN_ERR "Unsupported guard: %d\n", guard));
+		ql_dbg(ql_dbg_io, sp->fcport->vha, 0x3007,
+		    "Unsupported guard: %d for cmd=%p.\n", guard, sp->cmd);
 		return 0;
 	}
 
@@ -343,9 +344,10 @@ qla2x00_start_scsi(srb_t *sp)
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL)
-							!= QLA_SUCCESS)
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS) {
 			return (QLA_FUNCTION_FAILED);
+		}
 		vha->marker_needed = 0;
 	}
 
@@ -490,8 +492,8 @@ __qla2x00_marker(struct scsi_qla_host *vha, struct req_que *req,
 	mrk24 = NULL;
 	mrk = (mrk_entry_t *)qla2x00_alloc_iocbs(vha, 0);
 	if (mrk == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Marker IOCB.\n",
-		    __func__, base_vha->host_no));
+		ql_log(ql_log_warn, base_vha, 0x3026,
+		    "Failed to allocate Marker IOCB.\n");
 
 		return (QLA_FUNCTION_FAILED);
 	}
@@ -547,9 +549,10 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
 	device_reg_t __iomem *reg = ISP_QUE_REG(ha, req->id);
 	struct device_reg_2xxx __iomem *ioreg = &ha->iobase->isp;
 
-	DEBUG5(printk("%s(): IOCB data:\n", __func__));
-	DEBUG5(qla2x00_dump_buffer(
-	    (uint8_t *)req->ring_ptr, REQUEST_ENTRY_SIZE));
+	ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x302d,
+	    "IOCB data:\n");
+	ql_dump_buffer(ql_dbg_io + ql_dbg_buffer, vha, 0x302e,
+	    (uint8_t *)req->ring_ptr, REQUEST_ENTRY_SIZE);
 
 	/* Adjust ring index. */
 	req->ring_index++;
@@ -604,7 +607,7 @@ qla2x00_isp_cmd(struct scsi_qla_host *vha, struct req_que *req)
  * Returns the number of IOCB entries needed to store @dsds.
  */
 inline uint16_t
-qla24xx_calc_iocbs(uint16_t dsds)
+qla24xx_calc_iocbs(scsi_qla_host_t *vha, uint16_t dsds)
 {
 	uint16_t iocbs;
 
@@ -614,8 +617,6 @@ qla24xx_calc_iocbs(uint16_t dsds)
 		if ((dsds - 1) % 5)
 			iocbs++;
 	}
-	DEBUG3(printk(KERN_DEBUG "%s(): Required PKT(s) = %d\n",
-	    __func__, iocbs));
 	return iocbs;
 }
 
@@ -712,6 +713,7 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
     unsigned int protcnt)
 {
 	struct sd_dif_tuple *spt;
+	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
 	unsigned char op = scsi_get_prot_op(cmd);
 
 	switch (scsi_get_prot_type(cmd)) {
@@ -768,9 +770,9 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 		    op == SCSI_PROT_WRITE_PASS)) {
 			spt = page_address(sg_page(scsi_prot_sglist(cmd))) +
 			    scsi_prot_sglist(cmd)[0].offset;
-			DEBUG18(printk(KERN_DEBUG
-			    "%s(): LBA from user %p, lba = 0x%x\n",
-			    __func__, spt, (int)spt->ref_tag));
+			ql_dbg(ql_dbg_io, vha, 0x3008,
+			    "LBA from user %p, lba = 0x%x for cmd=%p.\n",
+			    spt, (int)spt->ref_tag, cmd);
 			pkt->ref_tag = swab32(spt->ref_tag);
 			pkt->app_tag_mask[0] = 0x0;
 			pkt->app_tag_mask[1] = 0x0;
@@ -789,11 +791,11 @@ qla24xx_set_t10dif_tags(struct scsi_cmnd *cmd, struct fw_dif_context *pkt,
 		break;
 	}
 
-	DEBUG18(printk(KERN_DEBUG
-	    "%s(): Setting protection Tags: (BIG) ref tag = 0x%x,"
-	    " app tag = 0x%x, prot SG count %d , cmd lba 0x%x,"
-	    " prot_type=%u\n", __func__, pkt->ref_tag, pkt->app_tag, protcnt,
-	    (int)scsi_get_lba(cmd), scsi_get_prot_type(cmd)));
+	ql_dbg(ql_dbg_io, vha, 0x3009,
+	    "Setting protection Tags: (BIG) ref tag = 0x%x, app tag = 0x%x, "
+	    "prot SG count %d, cmd lba 0x%x, prot_type=%u cmd=%p.\n",
+	    pkt->ref_tag, pkt->app_tag, protcnt, (int)scsi_get_lba(cmd),
+	    scsi_get_prot_type(cmd), cmd);
 }
 
 
@@ -809,6 +811,7 @@ qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
 	uint32_t *cur_dsd = dsd;
 	int	i;
 	uint16_t	used_dsds = tot_dsds;
+	scsi_qla_host_t *vha = shost_priv(sp->cmd->device->host);
 
 	uint8_t		*cp;
 
@@ -853,9 +856,10 @@ qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
 			cur_dsd = (uint32_t *)next_dsd;
 		}
 		sle_dma = sg_dma_address(sg);
-		DEBUG18(printk("%s(): %p, sg entry %d - addr =0x%x 0x%x,"
-		    " len =%d\n", __func__ , cur_dsd, i, LSD(sle_dma),
-		    MSD(sle_dma), sg_dma_len(sg)));
+		ql_dbg(ql_dbg_io, vha, 0x300a,
+		    "sg entry %d - addr=0x%x 0x%x, " "len=%d for cmd=%p.\n",
+		    cur_dsd, i, LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg),
+		    sp->cmd);
 		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
 		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
 		*cur_dsd++ = cpu_to_le32(sg_dma_len(sg));
@@ -863,8 +867,8 @@ qla24xx_walk_and_build_sglist(struct qla_hw_data *ha, srb_t *sp, uint32_t *dsd,
 
 		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
 			cp = page_address(sg_page(sg)) + sg->offset;
-			DEBUG18(printk("%s(): User Data buffer= %p:\n",
-			    __func__ , cp));
+			ql_dbg(ql_dbg_io, vha, 0x300b,
+			    "User data buffer=%p for cmd=%p.\n", cp, sp->cmd);
 		}
 	}
 	/* Null termination */
@@ -888,7 +892,7 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 	struct scsi_cmnd *cmd;
 	uint32_t *cur_dsd = dsd;
 	uint16_t	used_dsds = tot_dsds;
-
+	scsi_qla_host_t *vha = pci_get_drvdata(ha->pdev);
 	uint8_t		*cp;
 
 
@@ -935,10 +939,11 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 		}
 		sle_dma = sg_dma_address(sg);
 		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
-			DEBUG18(printk(KERN_DEBUG
-			    "%s(): %p, sg entry %d - addr =0x%x"
-			    "0x%x, len =%d\n", __func__ , cur_dsd, i,
-			    LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg)));
+			ql_dbg(ql_dbg_io, vha, 0x3027,
+			    "%s(): %p, sg_entry %d - "
+			    "addr=0x%x0x%x, len=%d.\n",
+			    __func__, cur_dsd, i,
+			    LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg));
 		}
 		*cur_dsd++ = cpu_to_le32(LSD(sle_dma));
 		*cur_dsd++ = cpu_to_le32(MSD(sle_dma));
@@ -946,8 +951,9 @@ qla24xx_walk_and_build_prot_sglist(struct qla_hw_data *ha, srb_t *sp,
 
 		if (scsi_get_prot_op(sp->cmd) == SCSI_PROT_WRITE_PASS) {
 			cp = page_address(sg_page(sg)) + sg->offset;
-			DEBUG18(printk("%s(): Protection Data buffer = %p:\n",
-			    __func__ , cp));
+			ql_dbg(ql_dbg_io, vha, 0x3028,
+			    "%s(): Protection Data buffer = %p.\n", __func__,
+			    cp);
 		}
 		avail_dsds--;
 	}
@@ -996,22 +1002,16 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	*((uint32_t *)(&cmd_pkt->entry_type)) =
 	    __constant_cpu_to_le32(COMMAND_TYPE_CRC_2);
 
+	vha = sp->fcport->vha;
+	ha = vha->hw;
+
 	/* No data transfer */
 	data_bytes = scsi_bufflen(cmd);
 	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
-		DEBUG18(printk(KERN_INFO "%s: Zero data bytes or DMA-NONE %d\n",
-		    __func__, data_bytes));
 		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
 		return QLA_SUCCESS;
 	}
 
-	vha = sp->fcport->vha;
-	ha = vha->hw;
-
-	DEBUG18(printk(KERN_DEBUG
-	    "%s(%ld): Executing cmd sp %p, prot_op=%u.\n", __func__,
-	    vha->host_no, sp, scsi_get_prot_op(sp->cmd)));
-
 	cmd_pkt->vp_index = sp->fcport->vp_idx;
 
 	/* Set transfer direction */
@@ -1056,8 +1056,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	/* Determine SCSI command length -- align to 4 byte boundary */
 	if (cmd->cmd_len > 16) {
-		DEBUG18(printk(KERN_INFO "%s(): **** SCSI CMD > 16\n",
-		    __func__));
 		additional_fcpcdb_len = cmd->cmd_len - 16;
 		if ((cmd->cmd_len % 4) != 0) {
 			/* SCSI cmd > 16 bytes must be multiple of 4 */
@@ -1108,11 +1106,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
 
-	DEBUG18(printk(KERN_INFO "%s(%ld): Total SG(s) Entries %d, Data"
-	    "entries %d, data bytes %d, Protection entries %d\n",
-	    __func__, vha->host_no, tot_dsds, (tot_dsds-tot_prot_dsds),
-	    data_bytes, tot_prot_dsds));
-
 	/* Compute dif len and adjust data len to incude protection */
 	total_bytes = data_bytes;
 	dif_bytes = 0;
@@ -1150,14 +1143,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	    additional_fcpcdb_len);
 	*fcp_dl = htonl(total_bytes);
 
-	DEBUG18(printk(KERN_INFO "%s(%ld): dif bytes = 0x%x (%d), total bytes"
-	    " = 0x%x (%d), dat block size =0x%x (%d)\n", __func__,
-	    vha->host_no, dif_bytes, dif_bytes, total_bytes, total_bytes,
-	    crc_ctx_pkt->blk_size, crc_ctx_pkt->blk_size));
-
 	if (!data_bytes || cmd->sc_data_direction == DMA_NONE) {
-		DEBUG18(printk(KERN_INFO "%s: Zero data bytes or DMA-NONE %d\n",
-		    __func__, data_bytes));
 		cmd_pkt->byte_count = __constant_cpu_to_le32(0);
 		return QLA_SUCCESS;
 	}
@@ -1182,8 +1168,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	return QLA_SUCCESS;
 
 crc_queuing_error:
-	DEBUG18(qla_printk(KERN_INFO, ha,
-	    "CMD sent FAILED crc_q error:sp = %p\n", sp));
 	/* Cleanup will be performed by the caller */
 
 	return QLA_FUNCTION_FAILED;
@@ -1225,8 +1209,8 @@ qla24xx_start_scsi(srb_t *sp)
 
 	/* Send marker if required */
 	if (vha->marker_needed != 0) {
-		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL)
-							!= QLA_SUCCESS)
+		if (qla2x00_marker(vha, req, rsp, 0, 0, MK_SYNC_ALL) !=
+		    QLA_SUCCESS)
 			return QLA_FUNCTION_FAILED;
 		vha->marker_needed = 0;
 	}
@@ -1243,8 +1227,9 @@ qla24xx_start_scsi(srb_t *sp)
 		if (!req->outstanding_cmds[handle])
 			break;
 	}
-	if (index == MAX_OUTSTANDING_COMMANDS)
+	if (index == MAX_OUTSTANDING_COMMANDS) {
 		goto queuing_error;
+	}
 
 	/* Map the sg table so we have an accurate count of sg entries needed */
 	if (scsi_sg_count(cmd)) {
@@ -1256,8 +1241,7 @@ qla24xx_start_scsi(srb_t *sp)
 		nseg = 0;
 
 	tot_dsds = nseg;
-
-	req_cnt = qla24xx_calc_iocbs(tot_dsds);
+	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = RD_REG_DWORD_RELAXED(req->req_q_out);
 
@@ -1322,7 +1306,6 @@ qla24xx_start_scsi(srb_t *sp)
 	/* Specify response queue number where completion should happen */
 	cmd_pkt->entry_status = (uint8_t) rsp->id;
 	wmb();
-
 	/* Adjust ring index. */
 	req->ring_index++;
 	if (req->ring_index == req->length) {
@@ -1534,9 +1517,6 @@ queuing_error:
 	/* Cleanup will be performed by the caller (queuecommand) */
 
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
-
-	DEBUG18(qla_printk(KERN_INFO, ha,
-	    "CMD sent FAILED SCSI prot_op:%02x\n", scsi_get_prot_op(cmd)));
 	return QLA_FUNCTION_FAILED;
 }
 
@@ -1581,8 +1561,11 @@ qla2x00_alloc_iocbs(scsi_qla_host_t *vha, srb_t *sp)
 		if (!req->outstanding_cmds[handle])
 			break;
 	}
-	if (index == MAX_OUTSTANDING_COMMANDS)
+	if (index == MAX_OUTSTANDING_COMMANDS) {
+		ql_log(ql_log_warn, vha, 0x700b,
+		    "No room on oustanding cmd array.\n");
 		goto queuing_error;
+	}
 
 	/* Prep command array. */
 	req->current_outstanding_cmd = handle;
@@ -1999,8 +1982,11 @@ qla2x00_start_sp(srb_t *sp)
 	rval = QLA_FUNCTION_FAILED;
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	pkt = qla2x00_alloc_iocbs(sp->fcport->vha, sp);
-	if (!pkt)
+	if (!pkt) {
+		ql_log(ql_log_warn, sp->fcport->vha, 0x700c,
+		    "qla2x00_alloc_iocbs failed.\n");
 		goto done;
+	}
 
 	rval = QLA_SUCCESS;
 	switch (ctx->type) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index c26f0ac..f7604ea 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -46,14 +46,18 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	struct qla_hw_data *ha = vha->hw;
 	scsi_qla_host_t *base_vha = pci_get_drvdata(ha->pdev);
 
-	if (ha->pdev->error_state > pci_channel_io_frozen)
+	ql_dbg(ql_dbg_mbx, base_vha, 0x1000, "Entered %s.\n", __func__);
+
+	if (ha->pdev->error_state > pci_channel_io_frozen) {
+		ql_log(ql_log_warn, base_vha, 0x1001,
+		    "error_state is greater than pci_channel_io_frozen, "
+		    "exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
+	}
 
 	if (vha->device_flags & DFLG_DEV_FAILED) {
-		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
-			"%s(%ld): Device in failed state, "
-			"timeout MBX Exiting.\n",
-			__func__, base_vha->host_no));
+		ql_log(ql_log_warn, base_vha, 0x1002,
+		    "Device in failed state, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
@@ -63,17 +67,18 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	rval = QLA_SUCCESS;
 	abort_active = test_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, base_vha->host_no));
 
 	if (ha->flags.pci_channel_io_perm_failure) {
-		DEBUG(printk("%s(%ld): Perm failure on EEH, timeout MBX "
-			     "Exiting.\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, base_vha, 0x1003,
+		    "Perm failure on EEH timeout MBX, exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
 	if (ha->flags.isp82xx_fw_hung) {
 		/* Setting Link-Down error */
 		mcp->mb[0] = MBS_LINK_DOWN_ERROR;
+		ql_log(ql_log_warn, base_vha, 0x1004,
+		    "FW hung = %d.\n", ha->flags.isp82xx_fw_hung);
 		rval = QLA_FUNCTION_FAILED;
 		goto premature_exit;
 	}
@@ -85,8 +90,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	 */
 	if (!wait_for_completion_timeout(&ha->mbx_cmd_comp, mcp->tov * HZ)) {
 		/* Timeout occurred. Return error. */
-		DEBUG2_3_11(printk("%s(%ld): cmd access timeout. "
-		    "Exiting.\n", __func__, base_vha->host_no));
+		ql_log(ql_log_warn, base_vha, 0x1005,
+		    "Cmd access timeout, Exiting.\n");
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
@@ -94,8 +99,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* Save mailbox command for debug */
 	ha->mcp = mcp;
 
-	DEBUG11(printk("scsi(%ld): prepare to issue mbox cmd=0x%x.\n",
-	    base_vha->host_no, mcp->mb[0]));
+	ql_dbg(ql_dbg_mbx, base_vha, 0x1006,
+	    "Prepare to issue mbox cmd=0x%x.\n", mcp->mb[0]);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 
@@ -123,27 +128,30 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		iptr++;
 	}
 
-#if defined(QL_DEBUG_LEVEL_1)
-	printk("%s(%ld): Loaded MBX registers (displayed in bytes) = \n",
-	    __func__, base_vha->host_no);
-	qla2x00_dump_buffer((uint8_t *)mcp->mb, 16);
-	printk("\n");
-	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x10), 16);
-	printk("\n");
-	qla2x00_dump_buffer(((uint8_t *)mcp->mb + 0x20), 8);
-	printk("\n");
-	printk("%s(%ld): I/O address = %p.\n", __func__, base_vha->host_no,
-		optr);
-	qla2x00_dump_regs(base_vha);
-#endif
+	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1111,
+	    "Loaded MBX registers (displayed in bytes) =.\n");
+	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1112,
+	    (uint8_t *)mcp->mb, 16);
+	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1113,
+	    ".\n");
+	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1114,
+	    ((uint8_t *)mcp->mb + 0x10), 16);
+	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1115,
+	    ".\n");
+	ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1116,
+	    ((uint8_t *)mcp->mb + 0x20), 8);
+	ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1117,
+	    "I/O Address = %p.\n", optr);
+	ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x100e);
 
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
 	/* Unlock mbx registers and wait for interrupt */
-	DEBUG11(printk("%s(%ld): going to unlock irq & waiting for interrupt. "
-	    "jiffies=%lx.\n", __func__, base_vha->host_no, jiffies));
+	ql_dbg(ql_dbg_mbx, base_vha, 0x100f,
+	    "Going to unlock irq & waiting for interrupts. "
+	    "jiffies=%lx.\n", jiffies);
 
 	/* Wait for mbx cmd completion until timeout */
 
@@ -155,9 +163,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 				HINT_MBX_INT_PENDING) {
 				spin_unlock_irqrestore(&ha->hardware_lock,
 					flags);
-				DEBUG2_3_11(printk(KERN_INFO
-				    "%s(%ld): Pending Mailbox timeout. "
-				    "Exiting.\n", __func__, base_vha->host_no));
+				ql_dbg(ql_dbg_mbx, base_vha, 0x1010,
+				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
 				goto premature_exit;
 			}
@@ -173,17 +180,16 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
 
 	} else {
-		DEBUG3_11(printk("%s(%ld): cmd=%x POLLING MODE.\n", __func__,
-		    base_vha->host_no, command));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x1011,
+		    "Cmd=%x Polling Mode.\n", command);
 
 		if (IS_QLA82XX(ha)) {
 			if (RD_REG_DWORD(&reg->isp82.hint) &
 				HINT_MBX_INT_PENDING) {
 				spin_unlock_irqrestore(&ha->hardware_lock,
 					flags);
-				DEBUG2_3_11(printk(KERN_INFO
-				    "%s(%ld): Pending Mailbox timeout. "
-				    "Exiting.\n", __func__, base_vha->host_no));
+				ql_dbg(ql_dbg_mbx, base_vha, 0x1012,
+				    "Pending mailbox timeout, exiting.\n");
 				rval = QLA_FUNCTION_TIMEOUT;
 				goto premature_exit;
 			}
@@ -207,17 +213,17 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    command == MBC_LOAD_RISC_RAM_EXTENDED))
 				msleep(10);
 		} /* while */
-		DEBUG17(qla_printk(KERN_WARNING, ha,
-			"Waited %d sec\n",
-			(uint)((jiffies - (wait_time - (mcp->tov * HZ)))/HZ)));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x1013,
+		    "Waited %d sec.\n",
+		    (uint)((jiffies - (wait_time - (mcp->tov * HZ)))/HZ));
 	}
 
 	/* Check whether we timed out */
 	if (ha->flags.mbox_int) {
 		uint16_t *iptr2;
 
-		DEBUG3_11(printk("%s(%ld): cmd %x completed.\n", __func__,
-		    base_vha->host_no, command));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x1014,
+		    "Cmd=%x completed.\n", command);
 
 		/* Got interrupt. Clear the flag. */
 		ha->flags.mbox_int = 0;
@@ -229,6 +235,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			mcp->mb[0] = MBS_LINK_DOWN_ERROR;
 			ha->mcp = NULL;
 			rval = QLA_FUNCTION_FAILED;
+			ql_log(ql_log_warn, base_vha, 0x1015,
+			    "FW hung = %d.\n", ha->flags.isp82xx_fw_hung);
 			goto premature_exit;
 		}
 
@@ -249,8 +257,6 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		}
 	} else {
 
-#if defined(QL_DEBUG_LEVEL_2) || defined(QL_DEBUG_LEVEL_3) || \
-		defined(QL_DEBUG_LEVEL_11)
 		uint16_t mb0;
 		uint32_t ictrl;
 
@@ -261,14 +267,13 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			mb0 = RD_MAILBOX_REG(ha, &reg->isp, 0);
 			ictrl = RD_REG_WORD(&reg->isp.ictrl);
 		}
-		printk("%s(%ld): **** MB Command Timeout for cmd %x ****\n",
-		    __func__, base_vha->host_no, command);
-		printk("%s(%ld): icontrol=%x jiffies=%lx\n", __func__,
-		    base_vha->host_no, ictrl, jiffies);
-		printk("%s(%ld): *** mailbox[0] = 0x%x ***\n", __func__,
-		    base_vha->host_no, mb0);
-		qla2x00_dump_regs(base_vha);
-#endif
+		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1119,
+		    "MBX Command timeout for cmd %x.\n", command);
+		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x111a,
+		    "iocontrol=%x jiffies=%lx.\n", ictrl, jiffies);
+		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x111b,
+		    "mb[0] = 0x%x.\n", mb0);
+		ql_dump_regs(ql_dbg_mbx + ql_dbg_buffer, base_vha, 0x1019);
 
 		rval = QLA_FUNCTION_TIMEOUT;
 	}
@@ -279,8 +284,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	ha->mcp = NULL;
 
 	if ((abort_active || !io_lock_on) && !IS_NOPOLLING_TYPE(ha)) {
-		DEBUG11(printk("%s(%ld): checking for additional resp "
-		    "interrupt.\n", __func__, base_vha->host_no));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x101a,
+		    "Checking for additional resp interrupt.\n");
 
 		/* polling mode for non isp_abort commands. */
 		qla2x00_poll(ha->rsp_q_map[0]);
@@ -291,38 +296,32 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		if (!io_lock_on || (mcp->flags & IOCTL_CMD) ||
 		    ha->flags.eeh_busy) {
 			/* not in dpc. schedule it for dpc to take over. */
-			DEBUG(printk("%s(%ld): timeout schedule "
-			"isp_abort_needed.\n", __func__,
-			base_vha->host_no));
-			DEBUG2_3_11(printk("%s(%ld): timeout schedule "
-			"isp_abort_needed.\n", __func__,
-			base_vha->host_no));
+			ql_dbg(ql_dbg_mbx, base_vha, 0x101b,
+			    "Timeout, schedule isp_abort_needed.\n");
 
 			if (!test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) &&
 			    !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
 			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 
-				qla_printk(KERN_WARNING, ha,
-				    "Mailbox command timeout occurred. "
-				    "Scheduling ISP " "abort. eeh_busy: 0x%x\n",
-				    ha->flags.eeh_busy);
+				ql_log(ql_log_info, base_vha, 0x101c,
+				    "Mailbox cmd timeout occured. "
+				    "Scheduling ISP abort eeh_busy=0x%x.\n",
+					ha->flags.eeh_busy);
 				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 				qla2xxx_wake_dpc(vha);
 			}
 		} else if (!abort_active) {
 			/* call abort directly since we are in the DPC thread */
-			DEBUG(printk("%s(%ld): timeout calling abort_isp\n",
-			    __func__, base_vha->host_no));
-			DEBUG2_3_11(printk("%s(%ld): timeout calling "
-			    "abort_isp\n", __func__, base_vha->host_no));
+			ql_dbg(ql_dbg_mbx, base_vha, 0x101d,
+			    "Timeout, calling abort_isp.\n");
 
 			if (!test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) &&
 			    !test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) &&
 			    !test_bit(ISP_ABORT_RETRY, &vha->dpc_flags)) {
 
-				qla_printk(KERN_WARNING, ha,
-				    "Mailbox command timeout occurred. "
-				    "Issuing ISP abort.\n");
+				ql_log(ql_log_info, base_vha, 0x101e,
+				    "Mailbox cmd timeout occured. "
+				    "Scheduling ISP abort.\n");
 
 				set_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
 				clear_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
@@ -332,11 +331,8 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 					    &vha->dpc_flags);
 				}
 				clear_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags);
-				DEBUG(printk("%s(%ld): finished abort_isp\n",
-				    __func__, vha->host_no));
-				DEBUG2_3_11(printk(
-				    "%s(%ld): finished abort_isp\n",
-				    __func__, vha->host_no));
+				ql_dbg(ql_dbg_mbx, base_vha, 0x101f,
+				    "Finished abort_isp.\n");
 			}
 		}
 	}
@@ -346,12 +342,11 @@ premature_exit:
 	complete(&ha->mbx_cmd_comp);
 
 	if (rval) {
-		DEBUG2_3_11(printk("%s(%ld): **** FAILED. mbx0=%x, mbx1=%x, "
-		    "mbx2=%x, cmd=%x ****\n", __func__, base_vha->host_no,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x1020,
+		    "**** Failed mbx[0]=%x, mb[1]=%x, mb[2]=%x, cmd=%x ****.\n",
+		    mcp->mb[0], mcp->mb[1], mcp->mb[2], command);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__,
-		base_vha->host_no));
+		ql_dbg(ql_dbg_mbx, base_vha, 0x1021, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -366,7 +361,7 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1022, "Entered %s.\n", __func__);
 
 	if (MSW(risc_addr) || IS_FWI2_CAPABLE(ha)) {
 		mcp->mb[0] = MBC_LOAD_RISC_RAM_EXTENDED;
@@ -397,10 +392,10 @@ qla2x00_load_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t risc_addr,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1023,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1024, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -430,7 +425,7 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1025, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_EXECUTE_FIRMWARE;
 	mcp->out_mb = MBX_0;
@@ -461,15 +456,14 @@ qla2x00_execute_fw(scsi_qla_host_t *vha, uint32_t risc_addr)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1026,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
 		if (IS_FWI2_CAPABLE(ha)) {
-			DEBUG11(printk("%s(%ld): done exchanges=%x.\n",
-			    __func__, vha->host_no, mcp->mb[1]));
+			ql_dbg(ql_dbg_mbx, vha, 0x1027,
+			    "Done exchanges=%x.\n", mcp->mb[1]);
 		} else {
-			DEBUG11(printk("%s(%ld): done.\n", __func__,
-			    vha->host_no));
+			ql_dbg(ql_dbg_mbx, vha, 0x1028, "Done %s.\n", __func__);
 		}
 	}
 
@@ -501,7 +495,7 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1029, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_VERSION;
 	mcp->out_mb = MBX_0;
@@ -535,11 +529,10 @@ qla2x00_get_fw_version(scsi_qla_host_t *vha, uint16_t *major, uint16_t *minor,
 failed:
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x102a, "Failed=%x.\n", rval);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x102b, "Done %s.\n", __func__);
 	}
 	return rval;
 }
@@ -565,7 +558,7 @@ qla2x00_get_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x102c, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_OPTION;
 	mcp->out_mb = MBX_0;
@@ -576,15 +569,14 @@ qla2x00_get_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x102d, "Failed=%x.\n", rval);
 	} else {
 		fwopts[0] = mcp->mb[0];
 		fwopts[1] = mcp->mb[1];
 		fwopts[2] = mcp->mb[2];
 		fwopts[3] = mcp->mb[3];
 
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x102e, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -612,7 +604,7 @@ qla2x00_set_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x102f, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_SET_FIRMWARE_OPTION;
 	mcp->mb[1] = fwopts[1];
@@ -636,11 +628,11 @@ qla2x00_set_fw_options(scsi_qla_host_t *vha, uint16_t *fwopts)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x/%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1030,
+		    "Failed=%x (%x/%x).\n", rval, mcp->mb[0], mcp->mb[1]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1031, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -668,7 +660,7 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_mbx_reg_test(%ld): entered.\n", vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1032, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_MAILBOX_REGISTER_TEST;
 	mcp->mb[1] = 0xAAAA;
@@ -695,12 +687,10 @@ qla2x00_mbx_reg_test(scsi_qla_host_t *vha)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_mbx_reg_test(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1033, "Failed=%x.\n", rval);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_mbx_reg_test(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1034, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -728,7 +718,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *vha, uint32_t risc_addr)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1035, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_VERIFY_CHECKSUM;
 	mcp->out_mb = MBX_0;
@@ -749,11 +739,11 @@ qla2x00_verify_checksum(scsi_qla_host_t *vha, uint32_t risc_addr)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x chk sum=%x.\n", __func__,
-		    vha->host_no, rval, IS_FWI2_CAPABLE(vha->hw) ?
-		    (mcp->mb[2] << 16) | mcp->mb[1]: mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1036,
+		    "Failed=%x chm sum=%x.\n", rval, IS_FWI2_CAPABLE(vha->hw) ?
+		    (mcp->mb[2] << 16) | mcp->mb[1] : mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1037, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -785,6 +775,8 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x1038, "Entered %s.\n", __func__);
+
 	mcp->mb[0] = MBC_IOCB_COMMAND_A64;
 	mcp->mb[1] = 0;
 	mcp->mb[2] = MSW(phys_addr);
@@ -799,14 +791,14 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG(printk("qla2x00_issue_iocb(%ld): failed rval 0x%x\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1039, "Failed=%x.\n", rval);
 	} else {
 		sts_entry_t *sts_entry = (sts_entry_t *) buffer;
 
 		/* Mask reserved bits. */
 		sts_entry->entry_status &=
 		    IS_FWI2_CAPABLE(vha->hw) ? RF_MASK_24XX : RF_MASK;
+		ql_dbg(ql_dbg_mbx, vha, 0x103a, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -847,7 +839,7 @@ qla2x00_abort_command(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
 
-	DEBUG11(printk("qla2x00_abort_command(%ld): entered.\n", vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x103b, "Entered %s.\n", __func__);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
@@ -876,11 +868,9 @@ qla2x00_abort_command(srb_t *sp)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("qla2x00_abort_command(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x103c, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("qla2x00_abort_command(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x103d, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -896,10 +886,11 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
-
 	l = l;
 	vha = fcport->vha;
+
+	ql_dbg(ql_dbg_mbx, vha, 0x103e, "Entered %s.\n", __func__);
+
 	req = vha->hw->req_q_map[0];
 	rsp = req->rsp;
 	mcp->mb[0] = MBC_ABORT_TARGET;
@@ -919,18 +910,17 @@ qla2x00_abort_target(struct fc_port *fcport, unsigned int l, int tag)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x103f, "Failed=%x.\n", rval);
 	}
 
 	/* Issue marker IOCB. */
 	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, 0,
 							MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, vha->host_no, rval2));
+		ql_dbg(ql_dbg_mbx, vha, 0x1040,
+		    "Failed to issue marker IOCB (%x).\n", rval2);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1041, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -946,9 +936,10 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
-
 	vha = fcport->vha;
+
+	ql_dbg(ql_dbg_mbx, vha, 0x1042, "Entered %s.\n", __func__);
+
 	req = vha->hw->req_q_map[0];
 	rsp = req->rsp;
 	mcp->mb[0] = MBC_LUN_RESET;
@@ -966,18 +957,17 @@ qla2x00_lun_reset(struct fc_port *fcport, unsigned int l, int tag)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1043, "Failed=%x.\n", rval);
 	}
 
 	/* Issue marker IOCB. */
 	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, l,
 								MK_SYNC_ID_LUN);
 	if (rval2 != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, vha->host_no, rval2));
+		ql_dbg(ql_dbg_mbx, vha, 0x1044,
+		    "Failed to issue marker IOCB (%x).\n", rval2);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1045, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1011,8 +1001,7 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_get_adapter_id(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1046, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_ADAPTER_LOOP_ID;
 	mcp->mb[9] = vha->vp_idx;
@@ -1038,11 +1027,9 @@ qla2x00_get_adapter_id(scsi_qla_host_t *vha, uint16_t *id, uint8_t *al_pa,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_adapter_id(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1047, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("qla2x00_get_adapter_id(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1048, "Done %s.\n", __func__);
 
 		if (IS_QLA8XXX_TYPE(vha->hw)) {
 			vha->fcoe_vlan_id = mcp->mb[9] & 0xfff;
@@ -1083,8 +1070,7 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *vha, uint8_t *retry_cnt, uint8_t *tov,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_get_retry_cnt(%ld): entered.\n",
-			vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1049, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_RETRY_COUNT;
 	mcp->out_mb = MBX_0;
@@ -1095,8 +1081,8 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *vha, uint8_t *retry_cnt, uint8_t *tov,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_retry_cnt(%ld): failed = %x.\n",
-		    vha->host_no, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x104a,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
 		/* Convert returned data and check our values. */
 		*r_a_tov = mcp->mb[3] / 2;
@@ -1107,8 +1093,8 @@ qla2x00_get_retry_cnt(scsi_qla_host_t *vha, uint8_t *retry_cnt, uint8_t *tov,
 			*tov = ratov;
 		}
 
-		DEBUG11(printk("qla2x00_get_retry_cnt(%ld): done. mb3=%d "
-		    "ratov=%d.\n", vha->host_no, mcp->mb[3], ratov));
+		ql_dbg(ql_dbg_mbx, vha, 0x104b,
+		    "Done %s mb3=%d ratov=%d.\n", __func__, mcp->mb[3], ratov);
 	}
 
 	return rval;
@@ -1139,8 +1125,7 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("qla2x00_init_firmware(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x104c, "Entered %s.\n", __func__);
 
 	if (IS_QLA82XX(ha) && ql2xdbwr)
 		qla82xx_wr_32(ha, ha->nxdb_wr_ptr,
@@ -1174,13 +1159,11 @@ qla2x00_init_firmware(scsi_qla_host_t *vha, uint16_t size)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_init_firmware(%ld): failed=%x "
-		    "mb0=%x.\n",
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x104d,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_init_firmware(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x104e, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1213,13 +1196,13 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 	dma_addr_t pd_dma;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x104f, "Entered %s.\n", __func__);
 
 	pd24 = NULL;
 	pd = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pd_dma);
 	if (pd  == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Port Database "
-		    "structure.\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x1050,
+		    "Failed to allocate port database structure.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pd, 0, max(PORT_DATABASE_SIZE, PORT_DATABASE_24XX_SIZE));
@@ -1261,12 +1244,10 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		/* Check for logged in state. */
 		if (pd24->current_login_state != PDS_PRLI_COMPLETE &&
 		    pd24->last_login_state != PDS_PRLI_COMPLETE) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			   "scsi(%ld): Unable to verify login-state (%x/%x) "
-			   " - portid=%02x%02x%02x.\n", vha->host_no,
-			   pd24->current_login_state, pd24->last_login_state,
-			   fcport->d_id.b.domain, fcport->d_id.b.area,
-			   fcport->d_id.b.al_pa));
+			ql_dbg(ql_dbg_mbx, vha, 0x1051,
+			    "Unable to verify login-state (%x/%x) for "
+			    "loop_id %x.\n", pd24->current_login_state,
+			    pd24->last_login_state, fcport->loop_id);
 			rval = QLA_FUNCTION_FAILED;
 			goto gpd_error_out;
 		}
@@ -1290,12 +1271,11 @@ qla2x00_get_port_database(scsi_qla_host_t *vha, fc_port_t *fcport, uint8_t opt)
 		/* Check for logged in state. */
 		if (pd->master_state != PD_STATE_PORT_LOGGED_IN &&
 		    pd->slave_state != PD_STATE_PORT_LOGGED_IN) {
-			DEBUG2(qla_printk(KERN_WARNING, ha,
-			   "scsi(%ld): Unable to verify login-state (%x/%x) "
-			   " - portid=%02x%02x%02x.\n", vha->host_no,
-			   pd->master_state, pd->slave_state,
-			   fcport->d_id.b.domain, fcport->d_id.b.area,
-			   fcport->d_id.b.al_pa));
+			ql_dbg(ql_dbg_mbx, vha, 0x100a,
+			    "Unable to verify login-state (%x/%x) - "
+			    "portid=%02x%02x%02x.\n", pd->master_state,
+			    pd->slave_state, fcport->d_id.b.domain,
+			    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 			rval = QLA_FUNCTION_FAILED;
 			goto gpd_error_out;
 		}
@@ -1325,10 +1305,11 @@ gpd_error_out:
 	dma_pool_free(ha->s_dma_pool, pd, pd_dma);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1052,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n", rval,
+		    mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1053, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1357,8 +1338,7 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_get_firmware_state(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1054, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
@@ -1381,12 +1361,10 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_firmware_state(%ld): "
-		    "failed=%x.\n", vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1055, "Failed=%x.\n", rval);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_get_firmware_state(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1056, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1418,8 +1396,7 @@ qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_get_port_name(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1057, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_PORT_NAME;
 	mcp->mb[9] = vha->vp_idx;
@@ -1439,8 +1416,7 @@ qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_port_name(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1058, "Failed=%x.\n", rval);
 	} else {
 		if (name != NULL) {
 			/* This function returns name in big endian. */
@@ -1454,8 +1430,7 @@ qla2x00_get_port_name(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t *name,
 			name[7] = LSB(mcp->mb[7]);
 		}
 
-		DEBUG11(printk("qla2x00_get_port_name(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1059, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1483,7 +1458,7 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x105a, "Entered %s.\n", __func__);
 
 	if (IS_QLA8XXX_TYPE(vha->hw)) {
 		/* Logout across all FCFs. */
@@ -1517,11 +1492,10 @@ qla2x00_lip_reset(scsi_qla_host_t *vha)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n",
-		    __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x105b, "Failed=%x.\n", rval);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x105c, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1553,12 +1527,11 @@ qla2x00_send_sns(scsi_qla_host_t *vha, dma_addr_t sns_phys_address,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_send_sns(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x105d, "Entered %s.\n", __func__);
 
-	DEBUG11(printk("qla2x00_send_sns: retry cnt=%d ratov=%d total "
-		"tov=%d.\n", vha->hw->retry_count, vha->hw->login_timeout,
-		mcp->tov));
+	ql_dbg(ql_dbg_mbx, vha, 0x105e,
+	    "Retry cnt=%d ratov=%d total tov=%d.\n",
+	    vha->hw->retry_count, vha->hw->login_timeout, mcp->tov);
 
 	mcp->mb[0] = MBC_SEND_SNS_COMMAND;
 	mcp->mb[1] = cmd_size;
@@ -1575,13 +1548,12 @@ qla2x00_send_sns(scsi_qla_host_t *vha, dma_addr_t sns_phys_address,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
-		DEBUG2_3_11(printk("qla2x00_send_sns(%ld): failed=%x mb[0]=%x "
-		    "mb[1]=%x.\n", vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x105f,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_send_sns(%ld): done.\n", vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1060, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1600,7 +1572,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1061, "Entered %s.\n", __func__);
 
 	if (ha->flags.cpu_affinity_enabled)
 		req = ha->req_q_map[0];
@@ -1610,8 +1582,8 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Login IOCB.\n",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x1062,
+		    "Failed to allocate login IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1631,21 +1603,21 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	lg->vp_index = vha->vp_idx;
 	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Login IOCB "
-		    "(%x).\n", __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1063,
+		    "Failed to issue login IOCB (%x).\n", rval);
 	} else if (lg->entry_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, vha->host_no,
-		    lg->entry_status));
+		ql_dbg(ql_dbg_mbx, vha, 0x1064,
+		    "Failed to complete IOCB -- error status (%x).\n",
+		    lg->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 		iop[1] = le32_to_cpu(lg->io_parameter[1]);
 
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    vha->host_no, le16_to_cpu(lg->comp_status), iop[0],
-		    iop[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1065,
+		    "Failed to complete IOCB -- completion  status (%x) "
+		    "ioparam=%x/%x.\n", le16_to_cpu(lg->comp_status),
+		    iop[0], iop[1]);
 
 		switch (iop[0]) {
 		case LSC_SCODE_PORTID_USED:
@@ -1673,7 +1645,7 @@ qla24xx_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 			break;
 		}
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1066, "Done %s.\n", __func__);
 
 		iop[0] = le32_to_cpu(lg->io_parameter[0]);
 
@@ -1728,7 +1700,7 @@ qla2x00_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("qla2x00_login_fabric(%ld): entered.\n", vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1067, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_LOGIN_FABRIC_PORT;
 	mcp->out_mb = MBX_3|MBX_2|MBX_1|MBX_0;
@@ -1771,13 +1743,12 @@ qla2x00_login_fabric(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 			rval = QLA_SUCCESS;
 
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_login_fabric(%ld): failed=%x "
-		    "mb[0]=%x mb[1]=%x mb[2]=%x.\n", vha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1068,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[2]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_login_fabric(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1069, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1808,13 +1779,13 @@ qla2x00_login_local_device(scsi_qla_host_t *vha, fc_port_t *fcport,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x106a, "Entered %s.\n", __func__);
+
 	if (IS_FWI2_CAPABLE(ha))
 		return qla24xx_login_fabric(vha, fcport->loop_id,
 		    fcport->d_id.b.domain, fcport->d_id.b.area,
 		    fcport->d_id.b.al_pa, mb_ret, opt);
 
-	DEBUG3(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_LOGIN_LOOP_PORT;
 	if (HAS_EXTENDED_IDS(ha))
 		mcp->mb[1] = fcport->loop_id;
@@ -1845,15 +1816,12 @@ qla2x00_login_local_device(scsi_qla_host_t *vha, fc_port_t *fcport,
  		if (mcp->mb[0] == 0x4005 || mcp->mb[0] == 0x4006)
  			rval = QLA_SUCCESS;
 
-		DEBUG(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
-		DEBUG2_3(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[6]=%x mb[7]=%x.\n", __func__, vha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]));
+		ql_dbg(ql_dbg_mbx, vha, 0x106b,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[6]=%x mb[7]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[6], mcp->mb[7]);
 	} else {
 		/*EMPTY*/
-		DEBUG3(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x106c, "Done %s.\n", __func__);
 	}
 
 	return (rval);
@@ -1870,12 +1838,12 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x106d, "Entered %s.\n", __func__);
 
 	lg = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &lg_dma);
 	if (lg == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Logout IOCB.\n",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x106e,
+		    "Failed to allocate logout IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(lg, 0, sizeof(struct logio_entry_24xx));
@@ -1899,22 +1867,22 @@ qla24xx_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	rval = qla2x00_issue_iocb(vha, lg, lg_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Logout IOCB "
-		    "(%x).\n", __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x106f,
+		    "Failed to issue logout IOCB (%x).\n", rval);
 	} else if (lg->entry_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, vha->host_no,
-		    lg->entry_status));
+		ql_dbg(ql_dbg_mbx, vha, 0x1070,
+		    "Failed to complete IOCB -- error status (%x).\n",
+		    lg->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (lg->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2_3_11(printk("%s(%ld %d): failed to complete IOCB "
-		    "-- completion status (%x)  ioparam=%x/%x.\n", __func__,
-		    vha->host_no, vha->vp_idx, le16_to_cpu(lg->comp_status),
+		ql_dbg(ql_dbg_mbx, vha, 0x1071,
+		    "Failed to complete IOCB -- completion status (%x) "
+		    "ioparam=%x/%x.\n", le16_to_cpu(lg->comp_status),
 		    le32_to_cpu(lg->io_parameter[0]),
-		    le32_to_cpu(lg->io_parameter[1])));
+		    le32_to_cpu(lg->io_parameter[1]));
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1072, "Done %s.\n", __func__);
 	}
 
 	dma_pool_free(ha->s_dma_pool, lg, lg_dma);
@@ -1946,8 +1914,7 @@ qla2x00_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_fabric_logout(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1073, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_LOGOUT_FABRIC_PORT;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -1966,12 +1933,11 @@ qla2x00_fabric_logout(scsi_qla_host_t *vha, uint16_t loop_id, uint8_t domain,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_fabric_logout(%ld): failed=%x "
-		    "mbx1=%x.\n", vha->host_no, rval, mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1074,
+		    "Failed=%x mb[1]=%x.\n", rval, mcp->mb[1]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_fabric_logout(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1075, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -1999,8 +1965,7 @@ qla2x00_full_login_lip(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_full_login_lip(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1076, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_LIP_FULL_LOGIN;
 	mcp->mb[1] = IS_FWI2_CAPABLE(vha->hw) ? BIT_3 : 0;
@@ -2014,12 +1979,10 @@ qla2x00_full_login_lip(scsi_qla_host_t *vha)
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_full_login_lip(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1077, "Failed=%x.\n", rval);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("qla2x00_full_login_lip(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1078, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2045,8 +2008,7 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("qla2x00_get_id_list(%ld): entered.\n",
-	    vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1079, "Entered %s.\n", __func__);
 
 	if (id_list == NULL)
 		return QLA_FUNCTION_FAILED;
@@ -2075,12 +2037,10 @@ qla2x00_get_id_list(scsi_qla_host_t *vha, void *id_list, dma_addr_t id_list_dma,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("qla2x00_get_id_list(%ld): failed=%x.\n",
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x107a, "Failed=%x.\n", rval);
 	} else {
 		*entries = mcp->mb[1];
-		DEBUG11(printk("qla2x00_get_id_list(%ld): done.\n",
-		    vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x107b, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2108,7 +2068,7 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x107c, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_RESOURCE_COUNTS;
 	mcp->out_mb = MBX_0;
@@ -2121,14 +2081,14 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed = %x.\n", __func__,
-		    vha->host_no, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x107d,
+		    "Failed mb[0]=%x.\n", mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done. mb1=%x mb2=%x mb3=%x mb6=%x "
-		    "mb7=%x mb10=%x mb11=%x mb12=%x.\n", __func__,
-		    vha->host_no, mcp->mb[1], mcp->mb[2], mcp->mb[3],
-		    mcp->mb[6], mcp->mb[7], mcp->mb[10], mcp->mb[11],
-		    mcp->mb[12]));
+		ql_dbg(ql_dbg_mbx, vha, 0x107e,
+		    "Done %s mb1=%x mb2=%x mb3=%x mb6=%x mb7=%x mb10=%x "
+		    "mb11=%x mb12=%x.\n", __func__, mcp->mb[1], mcp->mb[2],
+		    mcp->mb[3], mcp->mb[6], mcp->mb[7], mcp->mb[10],
+		    mcp->mb[11], mcp->mb[12]);
 
 		if (cur_xchg_cnt)
 			*cur_xchg_cnt = mcp->mb[3];
@@ -2147,7 +2107,6 @@ qla2x00_get_resource_cnts(scsi_qla_host_t *vha, uint16_t *cur_xchg_cnt,
 	return (rval);
 }
 
-#if defined(QL_DEBUG_LEVEL_3)
 /*
  * qla2x00_get_fcal_position_map
  *	Get FCAL (LILP) position map using mailbox command
@@ -2172,10 +2131,12 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 	dma_addr_t pmap_dma;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x107f, "Entered %s.\n", __func__);
+
 	pmap = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &pmap_dma);
 	if (pmap  == NULL) {
-		DEBUG2_3_11(printk("%s(%ld): **** Mem Alloc Failed ****",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x1080,
+		    "Memory alloc failed.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(pmap, 0, FCAL_MAP_SIZE);
@@ -2193,10 +2154,11 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval == QLA_SUCCESS) {
-		DEBUG11(printk("%s(%ld): (mb0=%x/mb1=%x) FC/AL Position Map "
-		    "size (%x)\n", __func__, vha->host_no, mcp->mb[0],
-		    mcp->mb[1], (unsigned)pmap[0]));
-		DEBUG11(qla2x00_dump_buffer(pmap, pmap[0] + 1));
+		ql_dbg(ql_dbg_mbx, vha, 0x1081,
+		    "mb0/mb1=%x/%X FC/AL position map size (%x).\n",
+		    mcp->mb[0], mcp->mb[1], (unsigned)pmap[0]);
+		ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x111d,
+		    pmap, pmap[0] + 1);
 
 		if (pos_map)
 			memcpy(pos_map, pmap, FCAL_MAP_SIZE);
@@ -2204,15 +2166,13 @@ qla2x00_get_fcal_position_map(scsi_qla_host_t *vha, char *pos_map)
 	dma_pool_free(ha->s_dma_pool, pmap, pmap_dma);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1082, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1083, "Done %s.\n", __func__);
 	}
 
 	return rval;
 }
-#endif
 
 /*
  * qla2x00_get_link_status
@@ -2237,7 +2197,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 	uint32_t *siter, *diter, dwords;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1084, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_LINK_STATUS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2266,11 +2226,12 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
-			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, vha->host_no, mcp->mb[0]));
+			ql_dbg(ql_dbg_mbx, vha, 0x1085,
+			    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 			rval = QLA_FUNCTION_FAILED;
 		} else {
 			/* Copy over data -- firmware data is LE. */
+			ql_dbg(ql_dbg_mbx, vha, 0x1086, "Done %s.\n", __func__);
 			dwords = offsetof(struct link_statistics, unused1) / 4;
 			siter = diter = &stats->link_fail_cnt;
 			while (dwords--)
@@ -2278,8 +2239,7 @@ qla2x00_get_link_status(scsi_qla_host_t *vha, uint16_t loop_id,
 		}
 	} else {
 		/* Failed. */
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1087, "Failed=%x.\n", rval);
 	}
 
 	return rval;
@@ -2294,7 +2254,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 	mbx_cmd_t *mcp = &mc;
 	uint32_t *siter, *diter, dwords;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1088, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GET_LINK_PRIV_STATS;
 	mcp->mb[2] = MSW(stats_dma);
@@ -2312,10 +2272,11 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 
 	if (rval == QLA_SUCCESS) {
 		if (mcp->mb[0] != MBS_COMMAND_COMPLETE) {
-			DEBUG2_3_11(printk("%s(%ld): cmd failed. mbx0=%x.\n",
-			    __func__, vha->host_no, mcp->mb[0]));
+			ql_dbg(ql_dbg_mbx, vha, 0x1089,
+			    "Failed mb[0]=%x.\n", mcp->mb[0]);
 			rval = QLA_FUNCTION_FAILED;
 		} else {
+			ql_dbg(ql_dbg_mbx, vha, 0x108a, "Done %s.\n", __func__);
 			/* Copy over data -- firmware data is LE. */
 			dwords = sizeof(struct link_statistics) / 4;
 			siter = diter = &stats->link_fail_cnt;
@@ -2324,8 +2285,7 @@ qla24xx_get_isp_stats(scsi_qla_host_t *vha, struct link_statistics *stats,
 		}
 	} else {
 		/* Failed. */
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x108b, "Failed=%x.\n", rval);
 	}
 
 	return rval;
@@ -2345,7 +2305,7 @@ qla24xx_abort_command(srb_t *sp)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x108c, "Entered %s.\n", __func__);
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (handle = 1; handle < MAX_OUTSTANDING_COMMANDS; handle++) {
@@ -2360,8 +2320,8 @@ qla24xx_abort_command(srb_t *sp)
 
 	abt = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &abt_dma);
 	if (abt == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Abort IOCB.\n",
-		    __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x108d,
+		    "Failed to allocate abort IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(abt, 0, sizeof(struct abort_entry_24xx));
@@ -2380,20 +2340,20 @@ qla24xx_abort_command(srb_t *sp)
 
 	rval = qla2x00_issue_iocb(vha, abt, abt_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue IOCB (%x).\n",
-		    __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x108e,
+		    "Failed to issue IOCB (%x).\n", rval);
 	} else if (abt->entry_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, vha->host_no,
-		    abt->entry_status));
+		ql_dbg(ql_dbg_mbx, vha, 0x108f,
+		    "Failed to complete IOCB -- error status (%x).\n",
+		    abt->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (abt->nport_handle != __constant_cpu_to_le16(0)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, vha->host_no,
-		    le16_to_cpu(abt->nport_handle)));
+		ql_dbg(ql_dbg_mbx, vha, 0x1090,
+		    "Failed to complete IOCB -- completion status (%x).\n",
+		    le16_to_cpu(abt->nport_handle));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1091, "Done %s.\n", __func__);
 	}
 
 	dma_pool_free(ha->s_dma_pool, abt, abt_dma);
@@ -2421,19 +2381,20 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	struct req_que *req;
 	struct rsp_que *rsp;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, fcport->vha->host_no));
-
 	vha = fcport->vha;
 	ha = vha->hw;
 	req = vha->req;
+
+	ql_dbg(ql_dbg_mbx, vha, 0x1092, "Entered %s.\n", __func__);
+
 	if (ha->flags.cpu_affinity_enabled)
 		rsp = ha->rsp_q_map[tag + 1];
 	else
 		rsp = req->rsp;
 	tsk = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &tsk_dma);
 	if (tsk == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Task Management "
-		    "IOCB.\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x1093,
+		    "Failed to allocate task management IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(tsk, 0, sizeof(struct tsk_mgmt_cmd));
@@ -2457,30 +2418,30 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	sts = &tsk->p.sts;
 	rval = qla2x00_issue_iocb(vha, tsk, tsk_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue %s Reset IOCB "
-		    "(%x).\n", __func__, vha->host_no, name, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1094,
+		    "Failed to issue %s reset IOCB (%x).\n", name, rval);
 	} else if (sts->entry_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, vha->host_no,
-		    sts->entry_status));
+		ql_dbg(ql_dbg_mbx, vha, 0x1095,
+		    "Failed to complete IOCB -- error status (%x).\n",
+		    sts->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (sts->comp_status !=
 	    __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__,
-		    vha->host_no, le16_to_cpu(sts->comp_status)));
+		ql_dbg(ql_dbg_mbx, vha, 0x1096,
+		    "Failed to complete IOCB -- completion status (%x).\n",
+		    le16_to_cpu(sts->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else if (le16_to_cpu(sts->scsi_status) &
 	    SS_RESPONSE_INFO_LEN_VALID) {
 		if (le32_to_cpu(sts->rsp_data_len) < 4) {
-			DEBUG2_3_11(printk("%s(%ld): ignoring inconsistent "
-			    "data length -- not enough response info (%d).\n",
-			    __func__, vha->host_no,
-			    le32_to_cpu(sts->rsp_data_len)));
+			ql_dbg(ql_dbg_mbx, vha, 0x1097,
+			    "Ignoring inconsistent data length -- not enough "
+			    "response info (%d).\n",
+			    le32_to_cpu(sts->rsp_data_len));
 		} else if (sts->data[3]) {
-			DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-			    "-- response (%x).\n", __func__,
-			    vha->host_no, sts->data[3]));
+			ql_dbg(ql_dbg_mbx, vha, 0x1098,
+			    "Failed to complete IOCB -- response (%x).\n",
+			    sts->data[3]);
 			rval = QLA_FUNCTION_FAILED;
 		}
 	}
@@ -2489,10 +2450,10 @@ __qla24xx_issue_tmf(char *name, uint32_t type, struct fc_port *fcport,
 	rval2 = qla2x00_marker(vha, req, rsp, fcport->loop_id, l,
 	    type == TCF_LUN_RESET ? MK_SYNC_ID_LUN: MK_SYNC_ID);
 	if (rval2 != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue Marker IOCB "
-		    "(%x).\n", __func__, vha->host_no, rval2));
+		ql_dbg(ql_dbg_mbx, vha, 0x1099,
+		    "Failed to issue marker IOCB (%x).\n", rval2);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x109a, "Done %s.\n", __func__);
 	}
 
 	dma_pool_free(ha->s_dma_pool, tsk, tsk_dma);
@@ -2533,7 +2494,7 @@ qla2x00_system_error(scsi_qla_host_t *vha)
 	if (!IS_QLA23XX(ha) && !IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x109b, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_GEN_SYSTEM_ERROR;
 	mcp->out_mb = MBX_0;
@@ -2543,10 +2504,9 @@ qla2x00_system_error(scsi_qla_host_t *vha)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x109c, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x109d, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2566,7 +2526,7 @@ qla2x00_set_serdes_params(scsi_qla_host_t *vha, uint16_t sw_em_1g,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x109e, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_SERDES_PARAMS;
 	mcp->mb[1] = BIT_0;
@@ -2581,11 +2541,11 @@ qla2x00_set_serdes_params(scsi_qla_host_t *vha, uint16_t sw_em_1g,
 
 	if (rval != QLA_SUCCESS) {
 		/*EMPTY*/
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x109f,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
 		/*EMPTY*/
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a0, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2601,7 +2561,7 @@ qla2x00_stop_firmware(scsi_qla_host_t *vha)
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10a1, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_STOP_FIRMWARE;
 	mcp->out_mb = MBX_0;
@@ -2611,12 +2571,11 @@ qla2x00_stop_firmware(scsi_qla_host_t *vha)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a2, "Failed=%x.\n", rval);
 		if (mcp->mb[0] == MBS_INVALID_COMMAND)
 			rval = QLA_INVALID_COMMAND;
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a3, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2630,14 +2589,14 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10a4, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_ENABLE;
 	mcp->mb[2] = LSW(eft_dma);
@@ -2652,10 +2611,11 @@ qla2x00_enable_eft_trace(scsi_qla_host_t *vha, dma_addr_t eft_dma,
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a5,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a6, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2668,14 +2628,14 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10a7, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_EFT_DISABLE;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -2684,10 +2644,11 @@ qla2x00_disable_eft_trace(scsi_qla_host_t *vha)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a8,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10a9, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2701,14 +2662,14 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10aa, "Entered %s.\n", __func__);
+
 	if (!IS_QLA25XX(vha->hw) && !IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_ENABLE;
 	mcp->mb[2] = LSW(fce_dma);
@@ -2727,10 +2688,11 @@ qla2x00_enable_fce_trace(scsi_qla_host_t *vha, dma_addr_t fce_dma,
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ab,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ac, "Done %s.\n", __func__);
 
 		if (mb)
 			memcpy(mb, mcp->mb, 8 * sizeof(*mb));
@@ -2748,14 +2710,14 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10ad, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
 	if (unlikely(pci_channel_offline(vha->hw->pdev)))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_TRACE_CONTROL;
 	mcp->mb[1] = TC_FCE_DISABLE;
 	mcp->mb[2] = TC_FCE_DISABLE_TRACE;
@@ -2766,10 +2728,11 @@ qla2x00_disable_fce_trace(scsi_qla_host_t *vha, uint64_t *wr, uint64_t *rd)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ae,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10af, "Done %s.\n", __func__);
 
 		if (wr)
 			*wr = (uint64_t) mcp->mb[5] << 48 |
@@ -2794,11 +2757,11 @@ qla2x00_get_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10b0, "Entered %s.\n", __func__);
+
 	if (!IS_IIDMA_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
 	mcp->mb[2] = mcp->mb[3] = 0;
@@ -2817,10 +2780,9 @@ qla2x00_get_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	}
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b1, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b2, "Done %s.\n", __func__);
 		if (port_speed)
 			*port_speed = mcp->mb[3];
 	}
@@ -2836,11 +2798,11 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10b3, "Entered %s.\n", __func__);
+
 	if (!IS_IIDMA_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
 	mcp->mb[2] = BIT_0;
@@ -2863,10 +2825,9 @@ qla2x00_set_idma_speed(scsi_qla_host_t *vha, uint16_t loop_id,
 	}
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b4, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b5, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -2882,33 +2843,36 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha,
 	scsi_qla_host_t *vp;
 	unsigned long   flags;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10b6, "Entered %s.\n", __func__);
+
 	if (rptid_entry->entry_status != 0)
 		return;
 
 	if (rptid_entry->format == 0) {
-		DEBUG15(printk("%s:format 0 : scsi(%ld) number of VPs setup %d,"
-			" number of VPs acquired %d\n", __func__, vha->host_no,
-			MSB(le16_to_cpu(rptid_entry->vp_count)),
-			LSB(le16_to_cpu(rptid_entry->vp_count))));
-		DEBUG15(printk("%s primary port id %02x%02x%02x\n", __func__,
-			rptid_entry->port_id[2], rptid_entry->port_id[1],
-			rptid_entry->port_id[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b7,
+		    "Format 0 : Number of VPs setup %d, number of "
+		    "VPs acquired %d.\n",
+		    MSB(le16_to_cpu(rptid_entry->vp_count)),
+		    LSB(le16_to_cpu(rptid_entry->vp_count)));
+		ql_dbg(ql_dbg_mbx, vha, 0x10b8,
+		    "Primary port id %02x%02x%02x.\n",
+		    rptid_entry->port_id[2], rptid_entry->port_id[1],
+		    rptid_entry->port_id[0]);
 	} else if (rptid_entry->format == 1) {
 		vp_idx = LSB(stat);
-		DEBUG15(printk("%s:format 1: scsi(%ld): VP[%d] enabled "
-		    "- status %d - "
-		    "with port id %02x%02x%02x\n", __func__, vha->host_no,
-		    vp_idx, MSB(stat),
+		ql_dbg(ql_dbg_mbx, vha, 0x10b9,
+		    "Format 1: VP[%d] enabled - status %d - with "
+		    "port id %02x%02x%02x.\n", vp_idx, MSB(stat),
 		    rptid_entry->port_id[2], rptid_entry->port_id[1],
-		    rptid_entry->port_id[0]));
+		    rptid_entry->port_id[0]);
 
 		vp = vha;
 		if (vp_idx == 0 && (MSB(stat) != 1))
 			goto reg_needed;
 
 		if (MSB(stat) == 1) {
-			DEBUG2(printk("scsi(%ld): Could not acquire ID for "
-			    "VP[%d].\n", vha->host_no, vp_idx));
+			ql_dbg(ql_dbg_mbx, vha, 0x10ba,
+			    "Could not acquire ID for VP[%d].\n", vp_idx);
 			return;
 		}
 
@@ -2963,10 +2927,12 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 
 	/* This can be called by the parent */
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10bb, "Entered %s.\n", __func__);
+
 	vpmod = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vpmod_dma);
 	if (!vpmod) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Modify VP "
-		    "IOCB.\n", __func__, vha->host_no));
+		ql_log(ql_log_warn, vha, 0x10bc,
+		    "Failed to allocate modify VP IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -2983,22 +2949,21 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 
 	rval = qla2x00_issue_iocb(base_vha, vpmod, vpmod_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue VP config IOCB"
-			"(%x).\n", __func__, base_vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
+		    "Failed to issue VP config IOCB (%x).\n", rval);
 	} else if (vpmod->comp_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-			"-- error status (%x).\n", __func__, base_vha->host_no,
-			vpmod->comp_status));
+		ql_dbg(ql_dbg_mbx, vha, 0x10be,
+		    "Failed to complete IOCB -- error status (%x).\n",
+		    vpmod->comp_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vpmod->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, base_vha->host_no,
-		    le16_to_cpu(vpmod->comp_status)));
+		ql_dbg(ql_dbg_mbx, vha, 0x10bf,
+		    "Failed to complete IOCB -- completion status (%x).\n",
+		    le16_to_cpu(vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
 		/* EMPTY */
-		DEBUG11(printk("%s(%ld): done.\n", __func__,
-							base_vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10c0, "Done %s.\n", __func__);
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
 	}
 	dma_pool_free(ha->s_dma_pool, vpmod, vpmod_dma);
@@ -3032,17 +2997,16 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	int	vp_index = vha->vp_idx;
 	struct scsi_qla_host *base_vha = pci_get_drvdata(ha->pdev);
 
-	DEBUG11(printk("%s(%ld): entered. Enabling index %d\n", __func__,
-	    vha->host_no, vp_index));
+	ql_dbg(ql_dbg_mbx, vha, 0x10c1,
+	    "Entered %s enabling index %d.\n", __func__, vp_index);
 
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
 	vce = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &vce_dma);
 	if (!vce) {
-		DEBUG2_3(printk("%s(%ld): "
-		    "failed to allocate VP Control IOCB.\n", __func__,
-		    base_vha->host_no));
+		ql_log(ql_log_warn, vha, 0x10c2,
+		    "Failed to allocate VP control IOCB.\n");
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 	memset(vce, 0, sizeof(struct vp_ctrl_entry_24xx));
@@ -3063,28 +3027,20 @@ qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 
 	rval = qla2x00_issue_iocb(base_vha, vce, vce_dma, 0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, base_vha->host_no, rval));
-		printk("%s(%ld): failed to issue VP control IOCB"
-		    "(%x).\n", __func__, base_vha->host_no, rval);
+		ql_dbg(ql_dbg_mbx, vha, 0x10c3,
+		    "Failed to issue VP control IOCB (%x).\n", rval);
 	} else if (vce->entry_status != 0) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, base_vha->host_no,
-		    vce->entry_status));
-		printk("%s(%ld): failed to complete IOCB "
-		    "-- error status (%x).\n", __func__, base_vha->host_no,
+		ql_dbg(ql_dbg_mbx, vha, 0x10c4,
+		    "Failed to complete IOCB -- error status (%x).\n",
 		    vce->entry_status);
 		rval = QLA_FUNCTION_FAILED;
 	} else if (vce->comp_status != __constant_cpu_to_le16(CS_COMPLETE)) {
-		DEBUG2_3_11(printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, base_vha->host_no,
-		    le16_to_cpu(vce->comp_status)));
-		printk("%s(%ld): failed to complete IOCB "
-		    "-- completion status (%x).\n", __func__, base_vha->host_no,
+		ql_dbg(ql_dbg_mbx, vha, 0x10c5,
+		    "Failed to complet IOCB -- completion status (%x).\n",
 		    le16_to_cpu(vce->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		DEBUG2(printk("%s(%ld): done.\n", __func__, base_vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10c6, "Done %s.\n", __func__);
 	}
 
 	dma_pool_free(ha->s_dma_pool, vce, vce_dma);
@@ -3121,6 +3077,8 @@ qla2x00_send_change_request(scsi_qla_host_t *vha, uint16_t format,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10c7, "Entered %s.\n", __func__);
+
 	/*
 	 * This command is implicitly executed by firmware during login for the
 	 * physical hosts
@@ -3155,7 +3113,7 @@ qla2x00_dump_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1009, "Entered %s.\n", __func__);
 
 	if (MSW(addr) || IS_FWI2_CAPABLE(vha->hw)) {
 		mcp->mb[0] = MBC_DUMP_RISC_RAM_EXTENDED;
@@ -3186,10 +3144,10 @@ qla2x00_dump_ram(scsi_qla_host_t *vha, dma_addr_t req_dma, uint32_t addr,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1008,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1007, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3214,12 +3172,10 @@ qla84xx_verify_chip(struct scsi_qla_host *vha, uint16_t *status)
 	unsigned long flags;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG16(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10c8, "Entered %s.\n", __func__);
 
 	mn = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (mn == NULL) {
-		DEBUG2_3(printk("%s(%ld): failed to allocate Verify ISP84XX "
-		    "IOCB.\n", __func__, vha->host_no));
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
@@ -3237,43 +3193,43 @@ qla84xx_verify_chip(struct scsi_qla_host *vha, uint16_t *status)
 		mn->p.req.entry_count = 1;
 		mn->p.req.options = cpu_to_le16(options);
 
-		DEBUG16(printk("%s(%ld): Dump of Verify Request.\n", __func__,
-		    vha->host_no));
-		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
-		    sizeof(*mn)));
+		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x111c,
+		    "Dump of Verify Request.\n");
+		ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x111e,
+		    (uint8_t *)mn, sizeof(*mn));
 
 		rval = qla2x00_issue_iocb_timeout(vha, mn, mn_dma, 0, 120);
 		if (rval != QLA_SUCCESS) {
-			DEBUG2_16(printk("%s(%ld): failed to issue Verify "
-			    "IOCB (%x).\n", __func__, vha->host_no, rval));
+			ql_dbg(ql_dbg_mbx, vha, 0x10cb,
+			    "Failed to issue verify IOCB (%x).\n", rval);
 			goto verify_done;
 		}
 
-		DEBUG16(printk("%s(%ld): Dump of Verify Response.\n", __func__,
-		    vha->host_no));
-		DEBUG16(qla2x00_dump_buffer((uint8_t *)mn,
-		    sizeof(*mn)));
+		ql_dbg(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1110,
+		    "Dump of Verify Response.\n");
+		ql_dump_buffer(ql_dbg_mbx + ql_dbg_buffer, vha, 0x1118,
+		    (uint8_t *)mn, sizeof(*mn));
 
 		status[0] = le16_to_cpu(mn->p.rsp.comp_status);
 		status[1] = status[0] == CS_VCS_CHIP_FAILURE ?
 		    le16_to_cpu(mn->p.rsp.failure_code) : 0;
-		DEBUG2_16(printk("%s(%ld): cs=%x fc=%x\n", __func__,
-		    vha->host_no, status[0], status[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ce,
+		    "cs=%x fc=%x.\n", status[0], status[1]);
 
 		if (status[0] != CS_COMPLETE) {
 			rval = QLA_FUNCTION_FAILED;
 			if (!(options & VCO_DONT_UPDATE_FW)) {
-				DEBUG2_16(printk("%s(%ld): Firmware update "
-				    "failed. Retrying without update "
-				    "firmware.\n", __func__, vha->host_no));
+				ql_dbg(ql_dbg_mbx, vha, 0x10cf,
+				    "Firmware update failed. Retrying "
+				    "without update firmware.\n");
 				options |= VCO_DONT_UPDATE_FW;
 				options &= ~VCO_FORCE_UPDATE;
 				retry = 1;
 			}
 		} else {
-			DEBUG2_16(printk("%s(%ld): firmware updated to %x.\n",
-			    __func__, vha->host_no,
-			    le32_to_cpu(mn->p.rsp.fw_ver)));
+			ql_dbg(ql_dbg_mbx, vha, 0x10d0,
+			    "Firmware updated to %x.\n",
+			    le32_to_cpu(mn->p.rsp.fw_ver));
 
 			/* NOTE: we only update OP firmware. */
 			spin_lock_irqsave(&ha->cs84xx->access_lock, flags);
@@ -3288,10 +3244,9 @@ verify_done:
 	dma_pool_free(ha->s_dma_pool, mn, mn_dma);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_16(printk("%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10d1, "Failed=%x.\n", rval);
 	} else {
-		DEBUG16(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10d2, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3307,6 +3262,8 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	struct device_reg_25xxmq __iomem *reg;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10d3, "Entered %s.\n", __func__);
+
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
 	mcp->mb[1] = req->options;
 	mcp->mb[2] = MSW(LSD(req->dma));
@@ -3344,9 +3301,13 @@ qla25xx_init_req_que(struct scsi_qla_host *vha, struct req_que *req)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	rval = qla2x00_mailbox_command(vha, mcp);
-	if (rval != QLA_SUCCESS)
-		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x mb0=%x.\n",
-			__func__, vha->host_no, rval, mcp->mb[0]));
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x10d4,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx, vha, 0x10d5, "Done %s.\n", __func__);
+	}
+
 	return rval;
 }
 
@@ -3360,6 +3321,8 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	struct device_reg_25xxmq __iomem *reg;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10d6, "Entered %s.\n", __func__);
+
 	mcp->mb[0] = MBC_INITIALIZE_MULTIQ;
 	mcp->mb[1] = rsp->options;
 	mcp->mb[2] = MSW(LSD(rsp->dma));
@@ -3393,10 +3356,13 @@ qla25xx_init_rsp_que(struct scsi_qla_host *vha, struct rsp_que *rsp)
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	rval = qla2x00_mailbox_command(vha, mcp);
-	if (rval != QLA_SUCCESS)
-		DEBUG2_3_11(printk(KERN_WARNING "%s(%ld): failed=%x "
-			"mb0=%x.\n", __func__,
-			vha->host_no, rval, mcp->mb[0]));
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_mbx, vha, 0x10d7,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
+	} else {
+		ql_dbg(ql_dbg_mbx, vha, 0x10d8, "Done %s.\n", __func__);
+	}
+
 	return rval;
 }
 
@@ -3407,7 +3373,7 @@ qla81xx_idc_ack(scsi_qla_host_t *vha, uint16_t *mb)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10d9, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_IDC_ACK;
 	memcpy(&mcp->mb[1], mb, QLA_IDC_ACK_REGS * sizeof(uint16_t));
@@ -3418,10 +3384,10 @@ qla81xx_idc_ack(scsi_qla_host_t *vha, uint16_t *mb)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10da,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10db, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3434,11 +3400,11 @@ qla81xx_fac_get_sector_size(scsi_qla_host_t *vha, uint32_t *sector_size)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10dc, "Entered %s.\n", __func__);
+
 	if (!IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
 	mcp->mb[1] = FAC_OPT_CMD_GET_SECTOR_SIZE;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -3448,10 +3414,11 @@ qla81xx_fac_get_sector_size(scsi_qla_host_t *vha, uint32_t *sector_size)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10dd,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10de, "Done %s.\n", __func__);
 		*sector_size = mcp->mb[1];
 	}
 
@@ -3468,7 +3435,7 @@ qla81xx_fac_do_write_enable(scsi_qla_host_t *vha, int enable)
 	if (!IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10df, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
 	mcp->mb[1] = enable ? FAC_OPT_CMD_WRITE_ENABLE :
@@ -3480,10 +3447,11 @@ qla81xx_fac_do_write_enable(scsi_qla_host_t *vha, int enable)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e0,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e1, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3499,7 +3467,7 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *vha, uint32_t start, uint32_t finish)
 	if (!IS_QLA81XX(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10e2, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_FLASH_ACCESS_CTRL;
 	mcp->mb[1] = FAC_OPT_CMD_ERASE_SECTOR;
@@ -3514,11 +3482,11 @@ qla81xx_fac_erase_sector(scsi_qla_host_t *vha, uint32_t start, uint32_t finish)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x mb[1]=%x "
-		    "mb[2]=%x.\n", __func__, vha->host_no, rval, mcp->mb[0],
-		    mcp->mb[1], mcp->mb[2]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e3,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[2]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e4, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3531,7 +3499,7 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10e5, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_RESTART_MPI_FW;
 	mcp->out_mb = MBX_0;
@@ -3541,10 +3509,11 @@ qla81xx_restart_mpi_firmware(scsi_qla_host_t *vha)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=0x%x mb[1]=0x%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e6,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e7, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3559,11 +3528,11 @@ qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10e8, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	if (len == 1)
 		opt |= BIT_0;
 
@@ -3586,10 +3555,10 @@ qla2x00_read_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 		*sfp = mcp->mb[1];
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10e9,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ea, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3604,11 +3573,11 @@ qla2x00_write_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10eb, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	if (len == 1)
 		opt |= BIT_0;
 
@@ -3631,10 +3600,10 @@ qla2x00_write_sfp(scsi_qla_host_t *vha, dma_addr_t sfp_dma, uint8_t *sfp,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ec,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ed, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3648,11 +3617,11 @@ qla2x00_get_xgmac_stats(scsi_qla_host_t *vha, dma_addr_t stats_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10ee, "Entered %s.\n", __func__);
+
 	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_GET_XGMAC_STATS;
 	mcp->mb[2] = MSW(stats_dma);
 	mcp->mb[3] = LSW(stats_dma);
@@ -3666,11 +3635,12 @@ qla2x00_get_xgmac_stats(scsi_qla_host_t *vha, dma_addr_t stats_dma,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=0x%x "
-		    "mb[1]=0x%x mb[2]=0x%x.\n", __func__, vha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ef,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[2]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f0, "Done %s.\n", __func__);
+
 
 		*actual_size = mcp->mb[2] << 2;
 	}
@@ -3686,11 +3656,11 @@ qla2x00_get_dcbx_params(scsi_qla_host_t *vha, dma_addr_t tlv_dma,
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10f1, "Entered %s.\n", __func__);
+
 	if (!IS_QLA8XXX_TYPE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_GET_DCBX_PARAMS;
 	mcp->mb[1] = 0;
 	mcp->mb[2] = MSW(tlv_dma);
@@ -3705,11 +3675,11 @@ qla2x00_get_dcbx_params(scsi_qla_host_t *vha, dma_addr_t tlv_dma,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=0x%x "
-		    "mb[1]=0x%x mb[2]=0x%x.\n", __func__, vha->host_no, rval,
-		    mcp->mb[0], mcp->mb[1], mcp->mb[2]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f2,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1], mcp->mb[2]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f3, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3722,11 +3692,11 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x10f4, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_READ_RAM_EXTENDED;
 	mcp->mb[1] = LSW(risc_addr);
 	mcp->mb[8] = MSW(risc_addr);
@@ -3736,10 +3706,10 @@ qla2x00_read_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t *data)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f5,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f6, "Done %s.\n", __func__);
 		*data = mcp->mb[3] << 16 | mcp->mb[2];
 	}
 
@@ -3755,7 +3725,7 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	mbx_cmd_t *mcp = &mc;
 	uint32_t iter_cnt = 0x1;
 
-	DEBUG11(printk("scsi(%ld): entered.\n", vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10f7, "Entered %s.\n", __func__);
 
 	memset(mcp->mb, 0 , sizeof(mcp->mb));
 	mcp->mb[0] = MBC_DIAGNOSTIC_LOOP_BACK;
@@ -3794,15 +3764,12 @@ qla2x00_loopback_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(printk(KERN_WARNING
-			"(%ld): failed=%x mb[0]=0x%x "
-			"mb[1]=0x%x mb[2]=0x%x mb[3]=0x%x mb[18]=0x%x "
-			"mb[19]=0x%x.\n",
-			vha->host_no, rval, mcp->mb[0], mcp->mb[1], mcp->mb[2],
-			mcp->mb[3], mcp->mb[18], mcp->mb[19]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f8,
+		    "Failed=%x mb[0]=%x mb[1]=%x mb[2]=%x mb[3]=%x mb[18]=%x "
+		    "mb[19]=%x.\n", rval, mcp->mb[0], mcp->mb[1], mcp->mb[2],
+		    mcp->mb[3], mcp->mb[18], mcp->mb[19]);
 	} else {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld): done.\n", vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10f9, "Done %s.\n", __func__);
 	}
 
 	/* Copy mailbox information */
@@ -3819,7 +3786,7 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk("scsi(%ld): entered.\n", vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10fa, "Entered %s.\n", __func__);
 
 	memset(mcp->mb, 0 , sizeof(mcp->mb));
 	mcp->mb[0] = MBC_DIAGNOSTIC_ECHO;
@@ -3858,12 +3825,11 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2(printk(KERN_WARNING
-		    "(%ld): failed=%x mb[0]=0x%x mb[1]=0x%x.\n",
-		    vha->host_no, rval, mcp->mb[0], mcp->mb[1]));
+		ql_dbg(ql_dbg_mbx, vha, 0x10fb,
+		    "Failed=%x mb[0]=%x mb[1]=%x.\n",
+		    rval, mcp->mb[0], mcp->mb[1]);
 	} else {
-		DEBUG2(printk(KERN_WARNING
-		    "scsi(%ld): done.\n", vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10fc, "Done %s.\n", __func__);
 	}
 
 	/* Copy mailbox information */
@@ -3872,14 +3838,14 @@ qla2x00_echo_test(scsi_qla_host_t *vha, struct msg_echo_lb *mreq,
 }
 
 int
-qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic)
+qla84xx_reset_chip(scsi_qla_host_t *vha, uint16_t enable_diagnostic)
 {
 	int rval;
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG16(printk("%s(%ld): enable_diag=%d entered.\n", __func__,
-		ha->host_no, enable_diagnostic));
+	ql_dbg(ql_dbg_mbx, vha, 0x10fd,
+	    "Entered %s enable_diag=%d.\n", __func__, enable_diagnostic);
 
 	mcp->mb[0] = MBC_ISP84XX_RESET;
 	mcp->mb[1] = enable_diagnostic;
@@ -3887,13 +3853,12 @@ qla84xx_reset_chip(scsi_qla_host_t *ha, uint16_t enable_diagnostic)
 	mcp->in_mb = MBX_1|MBX_0;
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = MBX_DMA_OUT|MBX_DMA_IN|IOCTL_CMD;
-	rval = qla2x00_mailbox_command(ha, mcp);
+	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS)
-		DEBUG16(printk("%s(%ld): failed=%x.\n", __func__, ha->host_no,
-			rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10fe, "Failed=%x.\n", rval);
 	else
-		DEBUG16(printk("%s(%ld): done.\n", __func__, ha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10ff, "Done %s.\n", __func__);
 
 	return rval;
 }
@@ -3905,11 +3870,11 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x1100, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(vha->hw))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk("%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_WRITE_RAM_WORD_EXTENDED;
 	mcp->mb[1] = LSW(risc_addr);
 	mcp->mb[2] = LSW(data);
@@ -3921,10 +3886,10 @@ qla2x00_write_ram_word(scsi_qla_host_t *vha, uint32_t risc_addr, uint32_t data)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk("%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1101,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk("%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1102, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3941,8 +3906,7 @@ qla81xx_write_mpi_register(scsi_qla_host_t *vha, uint16_t *mb)
 
 	rval = QLA_SUCCESS;
 
-	DEBUG11(qla_printk(KERN_INFO, ha,
-	    "%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1103, "Entered %s.\n", __func__);
 
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
@@ -3982,11 +3946,10 @@ qla81xx_write_mpi_register(scsi_qla_host_t *vha, uint16_t *mb)
 		rval = QLA_FUNCTION_FAILED;
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_INFO "%s(%ld): failed=%x mb[0]=%x.\n",
-		    __func__, vha->host_no, rval, mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1104,
+		    "Failed=%x mb[0]=%x.\n", rval, mb[0]);
 	} else {
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1105, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -3999,12 +3962,11 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x1106, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(qla_printk(KERN_INFO, ha,
-		"%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_DATA_RATE;
 	mcp->mb[1] = 0;
 	mcp->out_mb = MBX_1|MBX_0;
@@ -4013,11 +3975,10 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_INFO "%s(%ld): failed=%x mb[0]=%x.\n",
-		    __func__, vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1107,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x1108, "Done %s.\n", __func__);
 		if (mcp->mb[1] != 0x7)
 			ha->link_data_rate = mcp->mb[1];
 	}
@@ -4033,8 +3994,7 @@ qla81xx_get_port_config(scsi_qla_host_t *vha, uint16_t *mb)
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk(KERN_INFO
-	    "%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1109, "Entered %s.\n", __func__);
 
 	if (!IS_QLA81XX(ha))
 		return QLA_FUNCTION_FAILED;
@@ -4047,15 +4007,13 @@ qla81xx_get_port_config(scsi_qla_host_t *vha, uint16_t *mb)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x110a,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
 		/* Copy all bits to preserve original value */
 		memcpy(mb, &mcp->mb[1], sizeof(uint16_t) * 4);
 
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x110b, "Done %s.\n", __func__);
 	}
 	return rval;
 }
@@ -4067,8 +4025,7 @@ qla81xx_set_port_config(scsi_qla_host_t *vha, uint16_t *mb)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
-	DEBUG11(printk(KERN_INFO
-	    "%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x110c, "Entered %s.\n", __func__);
 
 	mcp->mb[0] = MBC_SET_PORT_CONFIG;
 	/* Copy all bits to preserve original setting */
@@ -4080,12 +4037,10 @@ qla81xx_set_port_config(scsi_qla_host_t *vha, uint16_t *mb)
 	rval = qla2x00_mailbox_command(vha, mcp);
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x (%x).\n", __func__,
-		    vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x110d,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x110e, "Done %s.\n", __func__);
 
 	return rval;
 }
@@ -4100,12 +4055,11 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 	mbx_cmd_t *mcp = &mc;
 	struct qla_hw_data *ha = vha->hw;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x110f, "Entered %s.\n", __func__);
+
 	if (!IS_QLA24XX_TYPE(ha) && !IS_QLA25XX(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(printk(KERN_INFO
-	    "%s(%ld): entered.\n", __func__, vha->host_no));
-
 	mcp->mb[0] = MBC_PORT_PARAMS;
 	mcp->mb[1] = loop_id;
 	if (ha->flags.fcp_prio_enabled)
@@ -4127,12 +4081,9 @@ qla24xx_set_fcp_prio(scsi_qla_host_t *vha, uint16_t loop_id, uint16_t priority,
 	}
 
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x.\n", __func__,
-		    vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10cd, "Failed=%x.\n", rval);
 	} else {
-		DEBUG11(printk(KERN_INFO
-		    "%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x10cc, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -4145,13 +4096,12 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 	uint8_t byte;
 	struct qla_hw_data *ha = vha->hw;
 
-	DEBUG11(printk(KERN_INFO "%s(%ld): entered.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x10ca, "Entered %s.\n", __func__);
 
 	/* Integer part */
 	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x01, 1, BIT_13|BIT_0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x.\n", __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x10c9, "Failed=%x.\n", rval);
 		ha->flags.thermal_supported = 0;
 		goto fail;
 	}
@@ -4160,14 +4110,13 @@ qla2x00_get_thermal_temp(scsi_qla_host_t *vha, uint16_t *temp, uint16_t *frac)
 	/* Fraction part */
 	rval = qla2x00_read_sfp(vha, 0, &byte, 0x98, 0x10, 1, BIT_13|BIT_0);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(printk(KERN_WARNING
-		    "%s(%ld): failed=%x.\n", __func__, vha->host_no, rval));
+		ql_dbg(ql_dbg_mbx, vha, 0x1019, "Failed=%x.\n", rval);
 		ha->flags.thermal_supported = 0;
 		goto fail;
 	}
 	*frac = (byte >> 6) * 25;
 
-	DEBUG11(printk(KERN_INFO "%s(%ld): done.\n", __func__, vha->host_no));
+	ql_dbg(ql_dbg_mbx, vha, 0x1018, "Done %s.\n", __func__);
 fail:
 	return rval;
 }
@@ -4180,12 +4129,11 @@ qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x1017, "Entered %s.\n", __func__);
+
 	if (!IS_FWI2_CAPABLE(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(qla_printk(KERN_INFO, ha,
-		"%s(%ld): entered.\n", __func__, vha->host_no));
-
 	memset(mcp, 0, sizeof(mbx_cmd_t));
 	mcp->mb[0] = MBC_TOGGLE_INTERRUPT;
 	mcp->mb[1] = 1;
@@ -4197,12 +4145,10 @@ qla82xx_mbx_intr_enable(scsi_qla_host_t *vha)
 
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
-			"%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-			vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x1016,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(qla_printk(KERN_INFO, ha,
-			"%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x100e, "Done %s.\n", __func__);
 	}
 
 	return rval;
@@ -4216,12 +4162,11 @@ qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
 	mbx_cmd_t mc;
 	mbx_cmd_t *mcp = &mc;
 
+	ql_dbg(ql_dbg_mbx, vha, 0x100d, "Entered %s.\n", __func__);
+
 	if (!IS_QLA82XX(ha))
 		return QLA_FUNCTION_FAILED;
 
-	DEBUG11(qla_printk(KERN_INFO, ha,
-		"%s(%ld): entered.\n", __func__, vha->host_no));
-
 	memset(mcp, 0, sizeof(mbx_cmd_t));
 	mcp->mb[0] = MBC_TOGGLE_INTERRUPT;
 	mcp->mb[1] = 0;
@@ -4233,12 +4178,10 @@ qla82xx_mbx_intr_disable(scsi_qla_host_t *vha)
 
 	rval = qla2x00_mailbox_command(vha, mcp);
 	if (rval != QLA_SUCCESS) {
-		DEBUG2_3_11(qla_printk(KERN_WARNING, ha,
-			"%s(%ld): failed=%x mb[0]=%x.\n", __func__,
-			vha->host_no, rval, mcp->mb[0]));
+		ql_dbg(ql_dbg_mbx, vha, 0x100c,
+		    "Failed=%x mb[0]=%x.\n", rval, mcp->mb[0]);
 	} else {
-		DEBUG11(qla_printk(KERN_INFO, ha,
-			"%s(%ld): done.\n", __func__, vha->host_no));
+		ql_dbg(ql_dbg_mbx, vha, 0x100b, "Done %s.\n", __func__);
 	}
 
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 5e34391..c706ed3 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -36,8 +36,9 @@ qla24xx_allocate_vp_id(scsi_qla_host_t *vha)
 	mutex_lock(&ha->vport_lock);
 	vp_id = find_first_zero_bit(ha->vp_idx_map, ha->max_npiv_vports + 1);
 	if (vp_id > ha->max_npiv_vports) {
-		DEBUG15(printk ("vp_id %d is bigger than max-supported %d.\n",
-		    vp_id, ha->max_npiv_vports));
+		ql_dbg(ql_dbg_vport, vha, 0xa000,
+		    "vp_id %d is bigger than max-supported %d.\n",
+		    vp_id, ha->max_npiv_vports);
 		mutex_unlock(&ha->vport_lock);
 		return vp_id;
 	}
@@ -131,9 +132,9 @@ qla2x00_mark_vp_devices_dead(scsi_qla_host_t *vha)
 	fc_port_t *fcport;
 
 	list_for_each_entry(fcport, &vha->vp_fcports, list) {
-		DEBUG15(printk("scsi(%ld): Marking port dead, "
-		    "loop_id=0x%04x :%x\n",
-		    vha->host_no, fcport->loop_id, fcport->vp_idx));
+		ql_dbg(ql_dbg_vport, vha, 0xa001,
+		    "Marking port dead, loop_id=0x%04x : %x.\n",
+		    fcport->loop_id, fcport->vp_idx);
 
 		qla2x00_mark_device_lost(vha, fcport, 0, 0);
 		qla2x00_set_fcport_state(fcport, FCS_UNCONFIGURED);
@@ -187,13 +188,13 @@ qla24xx_enable_vp(scsi_qla_host_t *vha)
 		goto enable_failed;
 	}
 
-	DEBUG15(qla_printk(KERN_INFO, ha,
-	    "Virtual port with id: %d - Enabled\n", vha->vp_idx));
+	ql_dbg(ql_dbg_taskm, vha, 0x801a,
+	    "Virtual port with id: %d - Enabled.\n", vha->vp_idx);
 	return 0;
 
 enable_failed:
-	DEBUG15(qla_printk(KERN_INFO, ha,
-	    "Virtual port with id: %d - Disabled\n", vha->vp_idx));
+	ql_dbg(ql_dbg_taskm, vha, 0x801b,
+	    "Virtual port with id: %d - Disabled.\n", vha->vp_idx);
 	return 1;
 }
 
@@ -205,12 +206,12 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
 
 	fc_vport = vha->fc_vport;
 
-	DEBUG15(printk("scsi(%ld): %s: change request #3 for this host.\n",
-	    vha->host_no, __func__));
+	ql_dbg(ql_dbg_vport, vha, 0xa002,
+	    "%s: change request #3.\n", __func__);
 	ret = qla2x00_send_change_request(vha, 0x3, vha->vp_idx);
 	if (ret != QLA_SUCCESS) {
-		DEBUG15(qla_printk(KERN_ERR, vha->hw, "Failed to enable "
-		    "receiving of RSCN requests: 0x%x\n", ret));
+		ql_dbg(ql_dbg_vport, vha, 0xa003, "Failed to enable "
+		    "receiving of RSCN requests: 0x%x.\n", ret);
 		return;
 	} else {
 		/* Corresponds to SCR enabled */
@@ -248,9 +249,9 @@ qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
 			case MBA_CHG_IN_CONNECTION:
 			case MBA_PORT_UPDATE:
 			case MBA_RSCN_UPDATE:
-				DEBUG15(printk("scsi(%ld)%s: Async_event for"
-				" VP[%d], mb = 0x%x, vha=%p\n",
-				vha->host_no, __func__, i, *mb, vha));
+				ql_dbg(ql_dbg_async, vha, 0x5024,
+				    "Async_event for VP[%d], mb=0x%x vha=%p.\n",
+				    i, *mb, vha);
 				qla2x00_async_event(vha, rsp, mb);
 				break;
 			}
@@ -286,37 +287,49 @@ qla2x00_vp_abort_isp(scsi_qla_host_t *vha)
 	if (!test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
 		qla24xx_control_vp(vha, VCE_COMMAND_DISABLE_VPS_LOGO_ALL);
 
-	DEBUG15(printk("scsi(%ld): Scheduling enable of Vport %d...\n",
-	    vha->host_no, vha->vp_idx));
+	ql_dbg(ql_dbg_taskm, vha, 0x801d,
+	    "Scheduling enable of Vport %d.\n", vha->vp_idx);
 	return qla24xx_enable_vp(vha);
 }
 
 static int
 qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 {
+	ql_dbg(ql_dbg_dpc, vha, 0x4012,
+	    "Entering %s.\n", __func__);
+	ql_dbg(ql_dbg_dpc, vha, 0x4013,
+	    "vp_flags: 0x%lx.\n", vha->vp_flags);
+
 	qla2x00_do_work(vha);
 
 	if (test_and_clear_bit(VP_IDX_ACQUIRED, &vha->vp_flags)) {
 		/* VP acquired. complete port configuration */
+		ql_dbg(ql_dbg_dpc, vha, 0x4014,
+		    "Configure VP scheduled.\n");
 		qla24xx_configure_vp(vha);
+		ql_dbg(ql_dbg_dpc, vha, 0x4015,
+		    "Configure VP end.\n");
 		return 0;
 	}
 
 	if (test_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags)) {
+		ql_dbg(ql_dbg_dpc, vha, 0x4016,
+		    "FCPort update scheduled.\n");
 		qla2x00_update_fcports(vha);
 		clear_bit(FCPORT_UPDATE_NEEDED, &vha->dpc_flags);
+		ql_dbg(ql_dbg_dpc, vha, 0x4017,
+		    "FCPort update end.\n");
 	}
 
 	if ((test_and_clear_bit(RELOGIN_NEEDED, &vha->dpc_flags)) &&
 		!test_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags) &&
 		atomic_read(&vha->loop_state) != LOOP_DOWN) {
 
-		DEBUG(printk("scsi(%ld): qla2x00_port_login()\n",
-						vha->host_no));
+		ql_dbg(ql_dbg_dpc, vha, 0x4018,
+		    "Relogin needed scheduled.\n");
 		qla2x00_relogin(vha);
-
-		DEBUG(printk("scsi(%ld): qla2x00_port_login - end\n",
-							vha->host_no));
+		ql_dbg(ql_dbg_dpc, vha, 0x4019,
+		    "Relogin needed end.\n");
 	}
 
 	if (test_and_clear_bit(RESET_MARKER_NEEDED, &vha->dpc_flags) &&
@@ -326,11 +339,17 @@ qla2x00_do_dpc_vp(scsi_qla_host_t *vha)
 
 	if (test_and_clear_bit(LOOP_RESYNC_NEEDED, &vha->dpc_flags)) {
 		if (!(test_and_set_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags))) {
+			ql_dbg(ql_dbg_dpc, vha, 0x401a,
+			    "Loop resync scheduled.\n");
 			qla2x00_loop_resync(vha);
 			clear_bit(LOOP_RESYNC_ACTIVE, &vha->dpc_flags);
+			ql_dbg(ql_dbg_dpc, vha, 0x401b,
+			    "Loop resync end.\n");
 		}
 	}
 
+	ql_dbg(ql_dbg_dpc, vha, 0x401c,
+	    "Exiting %s.\n", __func__);
 	return 0;
 }
 
@@ -396,9 +415,10 @@ qla24xx_vport_create_req_sanity_check(struct fc_vport *fc_vport)
 
 	/* Check up max-npiv-supports */
 	if (ha->num_vhosts > ha->max_npiv_vports) {
-		DEBUG15(printk("scsi(%ld): num_vhosts %ud is bigger than "
-		    "max_npv_vports %ud.\n", base_vha->host_no,
-		    ha->num_vhosts, ha->max_npiv_vports));
+		ql_dbg(ql_dbg_vport, vha, 0xa004,
+		    "num_vhosts %ud is bigger "
+		    "than max_npiv_vports %ud.\n",
+		    ha->num_vhosts, ha->max_npiv_vports);
 		return VPCERR_UNSUPPORTED;
 	}
 	return 0;
@@ -415,7 +435,8 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 
 	vha = qla2x00_create_host(sht, ha);
 	if (!vha) {
-		DEBUG(printk("qla2xxx: scsi_host_alloc() failed for vport\n"));
+		ql_log(ql_log_warn, vha, 0xa005,
+		    "scsi_host_alloc() failed for vport.\n");
 		return(NULL);
 	}
 
@@ -429,8 +450,8 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	vha->device_flags = 0;
 	vha->vp_idx = qla24xx_allocate_vp_id(vha);
 	if (vha->vp_idx > ha->max_npiv_vports) {
-		DEBUG15(printk("scsi(%ld): Couldn't allocate vp_id.\n",
-			vha->host_no));
+		ql_dbg(ql_dbg_vport, vha, 0xa006,
+		    "Couldn't allocate vp_id.\n");
 		goto create_vhost_failed;
 	}
 	vha->mgmt_svr_loop_id = 10 + vha->vp_idx;
@@ -461,8 +482,9 @@ qla24xx_create_vhost(struct fc_vport *fc_vport)
 	host->max_id = MAX_TARGETS_2200;
 	host->transportt = qla2xxx_transport_vport_template;
 
-	DEBUG15(printk("DEBUG: detect vport hba %ld at address = %p\n",
-	    vha->host_no, vha));
+	ql_dbg(ql_dbg_vport, vha, 0xa007,
+	    "Detect vport hba %ld at address = %p.\n",
+	    vha->host_no, vha);
 
 	vha->flags.init_done = 1;
 
@@ -567,9 +589,9 @@ qla25xx_delete_queues(struct scsi_qla_host *vha)
 		if (req) {
 			ret = qla25xx_delete_req_que(vha, req);
 			if (ret != QLA_SUCCESS) {
-				qla_printk(KERN_WARNING, ha,
-				"Couldn't delete req que %d\n",
-				req->id);
+				ql_log(ql_log_warn, vha, 0x00ea,
+				    "Couldn't delete req que %d.\n",
+				    req->id);
 				return ret;
 			}
 		}
@@ -581,9 +603,9 @@ qla25xx_delete_queues(struct scsi_qla_host *vha)
 		if (rsp) {
 			ret = qla25xx_delete_rsp_que(vha, rsp);
 			if (ret != QLA_SUCCESS) {
-				qla_printk(KERN_WARNING, ha,
-				"Couldn't delete rsp que %d\n",
-				rsp->id);
+				ql_log(ql_log_warn, vha, 0x00eb,
+				    "Couldn't delete rsp que %d.\n",
+				    rsp->id);
 				return ret;
 			}
 		}
@@ -604,8 +626,8 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 
 	req = kzalloc(sizeof(struct req_que), GFP_KERNEL);
 	if (req == NULL) {
-		qla_printk(KERN_WARNING, ha, "could not allocate memory"
-			"for request que\n");
+		ql_log(ql_log_fatal, base_vha, 0x00d9,
+		    "Failed to allocate memory for request queue.\n");
 		goto failed;
 	}
 
@@ -614,8 +636,8 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 			(req->length + 1) * sizeof(request_t),
 			&req->dma, GFP_KERNEL);
 	if (req->ring == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		"Memory Allocation failed - request_ring\n");
+		ql_log(ql_log_fatal, base_vha, 0x00da,
+		    "Failed to allocte memory for request_ring.\n");
 		goto que_failed;
 	}
 
@@ -623,8 +645,8 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	que_id = find_first_zero_bit(ha->req_qid_map, ha->max_req_queues);
 	if (que_id >= ha->max_req_queues) {
 		mutex_unlock(&ha->vport_lock);
-		qla_printk(KERN_INFO, ha, "No resources to create "
-			 "additional request queue\n");
+		ql_log(ql_log_warn, base_vha, 0x00db,
+		    "No resources to create additional request queue.\n");
 		goto que_failed;
 	}
 	set_bit(que_id, ha->req_qid_map);
@@ -633,6 +655,12 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	req->vp_idx = vp_idx;
 	req->qos = qos;
 
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc002,
+	    "queue_id=%d rid=%d vp_idx=%d qos=%d.\n",
+	    que_id, req->rid, req->vp_idx, req->qos);
+	ql_dbg(ql_dbg_init, base_vha, 0x00dc,
+	    "queue_id=%d rid=%d vp_idx=%d qos=%d.\n",
+	    que_id, req->rid, req->vp_idx, req->qos);
 	if (rsp_que < 0)
 		req->rsp = NULL;
 	else
@@ -645,6 +673,10 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 		options |= BIT_5;
 	req->options = options;
 
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc003,
+	    "options=0x%x.\n", req->options);
+	ql_dbg(ql_dbg_init, base_vha, 0x00dd,
+	    "options=0x%x.\n", req->options);
 	for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++)
 		req->outstanding_cmds[cnt] = NULL;
 	req->current_outstanding_cmd = 1;
@@ -656,10 +688,21 @@ qla25xx_create_req_que(struct qla_hw_data *ha, uint16_t options,
 	reg = ISP_QUE_REG(ha, que_id);
 	req->max_q_depth = ha->req_q_map[0]->max_q_depth;
 	mutex_unlock(&ha->vport_lock);
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc004,
+	    "ring_ptr=%p ring_index=%d, "
+	    "cnt=%d id=%d max_q_depth=%d.\n",
+	    req->ring_ptr, req->ring_index,
+	    req->cnt, req->id, req->max_q_depth);
+	ql_dbg(ql_dbg_init, base_vha, 0x00de,
+	    "ring_ptr=%p ring_index=%d, "
+	    "cnt=%d id=%d max_q_depth=%d.\n",
+	    req->ring_ptr, req->ring_index, req->cnt,
+	    req->id, req->max_q_depth);
 
 	ret = qla25xx_init_req_que(base_vha, req);
 	if (ret != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
+		ql_log(ql_log_fatal, base_vha, 0x00df,
+		    "%s failed.\n", __func__);
 		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->req_qid_map);
 		mutex_unlock(&ha->vport_lock);
@@ -700,8 +743,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 
 	rsp = kzalloc(sizeof(struct rsp_que), GFP_KERNEL);
 	if (rsp == NULL) {
-		qla_printk(KERN_WARNING, ha, "could not allocate memory for"
-				" response que\n");
+		ql_log(ql_log_warn, base_vha, 0x0066,
+		    "Failed to allocate memory for response queue.\n");
 		goto failed;
 	}
 
@@ -710,8 +753,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 			(rsp->length + 1) * sizeof(response_t),
 			&rsp->dma, GFP_KERNEL);
 	if (rsp->ring == NULL) {
-		qla_printk(KERN_WARNING, ha,
-		"Memory Allocation failed - response_ring\n");
+		ql_log(ql_log_warn, base_vha, 0x00e1,
+		    "Failed to allocate memory for response ring.\n");
 		goto que_failed;
 	}
 
@@ -719,8 +762,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	que_id = find_first_zero_bit(ha->rsp_qid_map, ha->max_rsp_queues);
 	if (que_id >= ha->max_rsp_queues) {
 		mutex_unlock(&ha->vport_lock);
-		qla_printk(KERN_INFO, ha, "No resources to create "
-			 "additional response queue\n");
+		ql_log(ql_log_warn, base_vha, 0x00e2,
+		    "No resources to create additional request queue.\n");
 		goto que_failed;
 	}
 	set_bit(que_id, ha->rsp_qid_map);
@@ -728,12 +771,16 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	if (ha->flags.msix_enabled)
 		rsp->msix = &ha->msix_entries[que_id + 1];
 	else
-		qla_printk(KERN_WARNING, ha, "msix not enabled\n");
+		ql_log(ql_log_warn, base_vha, 0x00e3,
+		    "MSIX not enalbled.\n");
 
 	ha->rsp_q_map[que_id] = rsp;
 	rsp->rid = rid;
 	rsp->vp_idx = vp_idx;
 	rsp->hw = ha;
+	ql_dbg(ql_dbg_init, base_vha, 0x00e4,
+	    "queue_id=%d rid=%d vp_idx=%d hw=%p.\n",
+	    que_id, rsp->rid, rsp->vp_idx, rsp->hw);
 	/* Use alternate PCI bus number */
 	if (MSB(rsp->rid))
 		options |= BIT_4;
@@ -750,6 +797,14 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 	rsp->rsp_q_in = &reg->isp25mq.rsp_q_in;
 	rsp->rsp_q_out = &reg->isp25mq.rsp_q_out;
 	mutex_unlock(&ha->vport_lock);
+	ql_dbg(ql_dbg_multiq, base_vha, 0xc00b,
+	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p",
+	    rsp->options, rsp->id, rsp->rsp_q_in,
+	    rsp->rsp_q_out);
+	ql_dbg(ql_dbg_init, base_vha, 0x00e5,
+	    "options=%x id=%d rsp_q_in=%p rsp_q_out=%p",
+	    rsp->options, rsp->id, rsp->rsp_q_in,
+	    rsp->rsp_q_out);
 
 	ret = qla25xx_request_irq(rsp);
 	if (ret)
@@ -757,7 +812,8 @@ qla25xx_create_rsp_que(struct qla_hw_data *ha, uint16_t options,
 
 	ret = qla25xx_init_rsp_que(base_vha, rsp);
 	if (ret != QLA_SUCCESS) {
-		qla_printk(KERN_WARNING, ha, "%s failed\n", __func__);
+		ql_log(ql_log_fatal, base_vha, 0x00e7,
+		    "%s failed.\n", __func__);
 		mutex_lock(&ha->vport_lock);
 		clear_bit(que_id, ha->rsp_qid_map);
 		mutex_unlock(&ha->vport_lock);
-- 
1.6.0.2

