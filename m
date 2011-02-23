From: madhu.iyengar@qlogic.com
Subject: [PATCH 05/13] qla2xxx: Abort pending commands for faster recovery during ISP reset.
Date: Wed, 23 Feb 2011 15:27:10 -0800
Message-ID: <1298503638-22396-6-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52623 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755108Ab1BWXaa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:30 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    9 ++-
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   11 +--
 drivers/scsi/qla2xxx/qla_mbx.c  |    4 +-
 drivers/scsi/qla2xxx/qla_nx.c   |  155 +++++++++++++++++++++++++++-----------
 drivers/scsi/qla2xxx/qla_os.c   |    6 +-
 6 files changed, 125 insertions(+), 61 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index ccfc8e7..6c51c0a 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2402,13 +2402,13 @@ struct qla_hw_data {
 	volatile struct {
 		uint32_t	mbox_int		:1;
 		uint32_t	mbox_busy		:1;
-
 		uint32_t	disable_risc_code_load	:1;
 		uint32_t	enable_64bit_addressing	:1;
 		uint32_t	enable_lip_reset	:1;
 		uint32_t	enable_target_reset	:1;
 		uint32_t	enable_lip_full_login	:1;
 		uint32_t	enable_led_scheme	:1;
+
 		uint32_t	msi_enabled		:1;
 		uint32_t	msix_enabled		:1;
 		uint32_t	disable_serdes		:1;
@@ -2417,6 +2417,7 @@ struct qla_hw_data {
 		uint32_t	pci_channel_io_perm_failure	:1;
 		uint32_t	fce_enabled		:1;
 		uint32_t	fac_supported		:1;
+
 		uint32_t	chip_reset_done		:1;
 		uint32_t	port0			:1;
 		uint32_t	running_gold_fw		:1;
@@ -2424,9 +2425,11 @@ struct qla_hw_data {
 		uint32_t	cpu_affinity_enabled	:1;
 		uint32_t	disable_msix_handshake	:1;
 		uint32_t	fcp_prio_enabled	:1;
-		uint32_t	fw_hung	:1;
-		uint32_t        quiesce_owner:1;
+		uint32_t	isp82xx_fw_hung:1;
+
+		uint32_t	quiesce_owner:1;
 		uint32_t	thermal_supported:1;
+		uint32_t	isp82xx_reset_hdlr_active:1;
 		/* 26 bits */
 	} flags;
 
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 89e900a..d48326e 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -565,6 +565,7 @@ extern int qla82xx_mbx_intr_enable(scsi_qla_host_t *);
 extern int qla82xx_mbx_intr_disable(scsi_qla_host_t *);
 extern void qla82xx_start_iocbs(srb_t *);
 extern int qla82xx_fcoe_ctx_reset(scsi_qla_host_t *);
+extern void qla82xx_chip_reset_cleanup(scsi_qla_host_t *);
 
 /* BSG related functions */
 extern int qla24xx_bsg_request(struct fc_bsg_job *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d9479c3..1bc5d19 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1967,7 +1967,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 		} else {
 			/* Mailbox cmd failed. Timeout on min_wait. */
 			if (time_after_eq(jiffies, mtime) ||
-			    (IS_QLA82XX(ha) && ha->flags.fw_hung))
+				ha->flags.isp82xx_fw_hung)
 				break;
 		}
 
@@ -3982,13 +3982,8 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 
 	if (!ha->flags.eeh_busy) {
 		/* Make sure for ISP 82XX IO DMA is complete */
-		if (IS_QLA82XX(ha)) {
-			if (qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
-				WAIT_HOST) == QLA_SUCCESS) {
-				DEBUG2(qla_printk(KERN_INFO, ha,
-				"Done wait for pending commands\n"));
-			}
-		}
+		if (IS_QLA82XX(ha))
+			qla82xx_chip_reset_cleanup(vha);
 
 		/* Requeue all commands in outstanding command list. */
 		qla2x00_abort_all_cmds(vha, DID_RESET << 16);
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e473e9f..a7f7346 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -83,7 +83,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		return QLA_FUNCTION_TIMEOUT;
 	}
 
-	if (IS_QLA82XX(ha) && ha->flags.fw_hung) {
+	if (ha->flags.isp82xx_fw_hung) {
 		/* Setting Link-Down error */
 		mcp->mb[0] = MBS_LINK_DOWN_ERROR;
 		rval = QLA_FUNCTION_FAILED;
@@ -223,7 +223,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 		ha->flags.mbox_int = 0;
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 
-		if (IS_QLA82XX(ha) && ha->flags.fw_hung) {
+		if (ha->flags.isp82xx_fw_hung) {
 			ha->flags.mbox_busy = 0;
 			/* Setting Link-Down error */
 			mcp->mb[0] = MBS_LINK_DOWN_ERROR;
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 4ff80ee..f1ffee4 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3457,46 +3457,28 @@ qla82xx_need_reset_handler(scsi_qla_host_t *vha)
 	}
 }
 
-static void
+int
 qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 {
-	uint32_t fw_heartbeat_counter, halt_status;
-	struct qla_hw_data *ha = vha->hw;
+	uint32_t fw_heartbeat_counter;
+	int status = 0;
 
-	fw_heartbeat_counter = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+	fw_heartbeat_counter = qla82xx_rd_32(vha->hw,
+		QLA82XX_PEG_ALIVE_COUNTER);
 	/* all 0xff, assume AER/EEH in progress, ignore */
 	if (fw_heartbeat_counter == 0xffffffff)
-		return;
+		return status;
 	if (vha->fw_heartbeat_counter == fw_heartbeat_counter) {
 		vha->seconds_since_last_heartbeat++;
 		/* FW not alive after 2 seconds */
 		if (vha->seconds_since_last_heartbeat == 2) {
 			vha->seconds_since_last_heartbeat = 0;
-			halt_status = qla82xx_rd_32(ha,
-				QLA82XX_PEG_HALT_STATUS1);
-			if (halt_status & HALT_STATUS_UNRECOVERABLE) {
-				set_bit(ISP_UNRECOVERABLE, &vha->dpc_flags);
-			} else {
-				qla_printk(KERN_INFO, ha,
-					"scsi(%ld): %s - detect abort needed\n",
-					vha->host_no, __func__);
-				set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
-			}
-			qla2xxx_wake_dpc(vha);
-			ha->flags.fw_hung = 1;
-			if (ha->flags.mbox_busy) {
-				ha->flags.mbox_int = 1;
-				DEBUG2(qla_printk(KERN_ERR, ha,
-					"Due to fw hung, doing premature "
-					"completion of mbx command\n"));
-				if (test_bit(MBX_INTR_WAIT,
-					&ha->mbx_cmd_flags))
-					complete(&ha->mbx_intr_comp);
-			}
+			status = 1;
 		}
 	} else
 		vha->seconds_since_last_heartbeat = 0;
 	vha->fw_heartbeat_counter = fw_heartbeat_counter;
+	return status;
 }
 
 /*
@@ -3598,30 +3580,18 @@ exit:
 
 void qla82xx_watchdog(scsi_qla_host_t *vha)
 {
-	uint32_t dev_state;
+	uint32_t dev_state, halt_status;
 	struct qla_hw_data *ha = vha->hw;
 
-	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
-
 	/* don't poll if reset is going on */
-	if (!(test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags) ||
-		test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags) ||
-		test_bit(ISP_ABORT_RETRY, &vha->dpc_flags))) {
-		if (dev_state == QLA82XX_DEV_NEED_RESET) {
+	if (!ha->flags.isp82xx_reset_hdlr_active) {
+		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		if (dev_state == QLA82XX_DEV_NEED_RESET &&
+		    !test_bit(ISP_ABORT_NEEDED, &vha->dpc_flags)) {
 			qla_printk(KERN_WARNING, ha,
-				"%s(): Adapter reset needed!\n", __func__);
+			    "%s(): Adapter reset needed!\n", __func__);
 			set_bit(ISP_ABORT_NEEDED, &vha->dpc_flags);
 			qla2xxx_wake_dpc(vha);
-			ha->flags.fw_hung = 1;
-			if (ha->flags.mbox_busy) {
-				ha->flags.mbox_int = 1;
-				DEBUG2(qla_printk(KERN_ERR, ha,
-					"Need reset, doing premature "
-					"completion of mbx command\n"));
-				if (test_bit(MBX_INTR_WAIT,
-					&ha->mbx_cmd_flags))
-					complete(&ha->mbx_intr_comp);
-			}
 		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
 			!test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags)) {
 			DEBUG(qla_printk(KERN_INFO, ha,
@@ -3631,6 +3601,31 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 			qla2xxx_wake_dpc(vha);
 		} else {
 			qla82xx_check_fw_alive(vha);
+			if (qla82xx_check_fw_alive(vha)) {
+				halt_status = qla82xx_rd_32(ha,
+				    QLA82XX_PEG_HALT_STATUS1);
+				if (halt_status & HALT_STATUS_UNRECOVERABLE) {
+					set_bit(ISP_UNRECOVERABLE,
+					    &vha->dpc_flags);
+				} else {
+					qla_printk(KERN_INFO, ha,
+					    "scsi(%ld): %s - detect abort needed\n",
+					    vha->host_no, __func__);
+					set_bit(ISP_ABORT_NEEDED,
+					    &vha->dpc_flags);
+				}
+				qla2xxx_wake_dpc(vha);
+				ha->flags.isp82xx_fw_hung = 1;
+				if (ha->flags.mbox_busy) {
+					ha->flags.mbox_int = 1;
+					DEBUG2(qla_printk(KERN_ERR, ha,
+					    "Due to fw hung, doing premature "
+					    "completion of mbx command\n"));
+					if (test_bit(MBX_INTR_WAIT,
+					    &ha->mbx_cmd_flags))
+						complete(&ha->mbx_intr_comp);
+				}
+			}
 		}
 	}
 }
@@ -3665,6 +3660,7 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 			"Exiting.\n", __func__, vha->host_no);
 		return QLA_SUCCESS;
 	}
+	ha->flags.isp82xx_reset_hdlr_active = 1;
 
 	qla82xx_idc_lock(ha);
 	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
@@ -3685,7 +3681,8 @@ qla82xx_abort_isp(scsi_qla_host_t *vha)
 	qla82xx_idc_unlock(ha);
 
 	if (rval == QLA_SUCCESS) {
-		ha->flags.fw_hung = 0;
+		ha->flags.isp82xx_fw_hung = 0;
+		ha->flags.isp82xx_reset_hdlr_active = 0;
 		qla82xx_restart_isp(vha);
 	}
 
@@ -3793,3 +3790,71 @@ int qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *vha)
 
 	return status;
 }
+
+void
+qla82xx_chip_reset_cleanup(scsi_qla_host_t *vha)
+{
+	int i;
+	unsigned long flags;
+	struct qla_hw_data *ha = vha->hw;
+
+	/* Check if 82XX firmware is alive or not
+	 * We may have arrived here from NEED_RESET
+	 * detection only
+	 */
+	if (!ha->flags.isp82xx_fw_hung) {
+		for (i = 0; i < 2; i++) {
+			msleep(1000);
+			if (qla82xx_check_fw_alive(vha)) {
+				ha->flags.isp82xx_fw_hung = 1;
+				if (ha->flags.mbox_busy) {
+					ha->flags.mbox_int = 1;
+					complete(&ha->mbx_intr_comp);
+				}
+				break;
+			}
+		}
+	}
+
+	/* Abort all commands gracefully if fw NOT hung */
+	if (!ha->flags.isp82xx_fw_hung) {
+		int cnt, que;
+		srb_t *sp;
+		struct req_que *req;
+
+		spin_lock_irqsave(&ha->hardware_lock, flags);
+		for (que = 0; que < ha->max_req_queues; que++) {
+			req = ha->req_q_map[que];
+			if (!req)
+				continue;
+			for (cnt = 1; cnt < MAX_OUTSTANDING_COMMANDS; cnt++) {
+				sp = req->outstanding_cmds[cnt];
+				if (sp) {
+					if (!sp->ctx ||
+					    (sp->flags & SRB_FCP_CMND_DMA_VALID)) {
+						spin_unlock_irqrestore(
+						    &ha->hardware_lock, flags);
+						if (ha->isp_ops->abort_command(sp)) {
+							qla_printk(KERN_INFO, ha,
+							    "scsi(%ld): mbx abort command failed in %s\n",
+							    vha->host_no, __func__);
+						} else {
+							qla_printk(KERN_INFO, ha,
+							    "scsi(%ld): mbx abort command success in %s\n",
+							    vha->host_no, __func__);
+						}
+						spin_lock_irqsave(&ha->hardware_lock, flags);
+					}
+				}
+			}
+		}
+		spin_unlock_irqrestore(&ha->hardware_lock, flags);
+
+		/* Wait for pending cmds (physical and virtual) to complete */
+		if (!qla2x00_eh_wait_for_pending_commands(vha, 0, 0,
+		    WAIT_HOST) == QLA_SUCCESS) {
+			DEBUG2(qla_printk(KERN_INFO, ha,
+			    "Done wait for pending commands\n"));
+		}
+	}
+}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0627453..7e576c5 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3795,7 +3795,7 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		ha->flags.eeh_busy = 1;
 		/* For ISP82XX complete any pending mailbox cmd */
 		if (IS_QLA82XX(ha)) {
-			ha->flags.fw_hung = 1;
+			ha->flags.isp82xx_fw_hung = 1;
 			if (ha->flags.mbox_busy) {
 				ha->flags.mbox_int = 1;
 				DEBUG2(qla_printk(KERN_ERR, ha,
@@ -3935,7 +3935,7 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
 			    QLA82XX_DEV_READY);
 			qla82xx_idc_unlock(ha);
-			ha->flags.fw_hung = 0;
+			ha->flags.isp82xx_fw_hung = 0;
 			rval = qla82xx_restart_isp(base_vha);
 			qla82xx_idc_lock(ha);
 			/* Clear driver state register */
@@ -3948,7 +3948,7 @@ uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
 		    "This devfn is not reset owner = 0x%x\n", ha->pdev->devfn));
 		if ((qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
 		    QLA82XX_DEV_READY)) {
-			ha->flags.fw_hung = 0;
+			ha->flags.isp82xx_fw_hung = 0;
 			rval = qla82xx_restart_isp(base_vha);
 			qla82xx_idc_lock(ha);
 			qla82xx_set_drv_active(base_vha);
-- 
1.6.0.2

