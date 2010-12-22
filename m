From: madhu.iyengar@qlogic.com
Subject: [PATCH 01/14] qla2xxx: Added support for quiescence mode for ISP82xx.
Date: Tue, 21 Dec 2010 16:00:14 -0800
Message-ID: <1292976027-12034-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36143 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1752914Ab0LVADX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:23 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Support is added for quiescence mode. This feature is for P3P adapters. Any of the functions can
put the firmware into quiescence state. All the others have to ack that request. During quiescence
mode current commands are processed and all the new incoming I/Os are blocked. Loop resync is
performed after firmware comes out of quiescence state.

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |    3 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    4 +
 drivers/scsi/qla2xxx/qla_init.c |   67 +++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_nx.c   |  132 ++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_os.c   |   24 ++++++-
 5 files changed, 224 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ce539d..6168628 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2425,6 +2425,8 @@ struct qla_hw_data {
 		uint32_t	disable_msix_handshake	:1;
 		uint32_t	fcp_prio_enabled	:1;
 		uint32_t	fw_hung	:1;
+		uint32_t        quiesce_owner:1;
+		/* 29 bits */
 	} flags;
 
 	/* This spinlock is used to protect "io transactions", you must
@@ -2863,6 +2865,7 @@ typedef struct scsi_qla_host {
 #define ISP_UNRECOVERABLE	17
 #define FCOE_CTX_RESET_NEEDED	18	/* Initiate FCoE context reset */
 #define MPI_RESET_NEEDED	19	/* Initiate MPI FW reset */
+#define ISP_QUIESCE_NEEDED	20	/* Driver need some quiescence */
 
 	uint32_t	device_flags;
 #define SWITCH_FOUND		BIT_0
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 9382a81..1370f05 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -36,6 +36,7 @@ extern int qla2x00_load_risc(struct scsi_qla_host *, uint32_t *);
 extern int qla24xx_load_risc(scsi_qla_host_t *, uint32_t *);
 extern int qla81xx_load_risc(scsi_qla_host_t *, uint32_t *);
 
+extern int qla2x00_perform_loop_resync(scsi_qla_host_t *);
 extern int qla2x00_loop_resync(scsi_qla_host_t *);
 
 extern int qla2x00_fabric_login(scsi_qla_host_t *, fc_port_t *, uint16_t *);
@@ -45,6 +46,7 @@ extern void qla2x00_update_fcports(scsi_qla_host_t *);
 
 extern int qla2x00_abort_isp(scsi_qla_host_t *);
 extern void qla2x00_abort_isp_cleanup(scsi_qla_host_t *);
+extern void qla82xx_quiescent_state_cleanup(scsi_qla_host_t *);
 
 extern void qla2x00_update_fcport(scsi_qla_host_t *, fc_port_t *);
 
@@ -549,9 +551,11 @@ extern void qla82xx_rom_unlock(struct qla_hw_data *);
 
 /* ISP 8021 IDC */
 extern void qla82xx_clear_drv_active(struct qla_hw_data *);
+extern uint32_t  qla82xx_wait_for_state_change(scsi_qla_host_t *, uint32_t);
 extern int qla82xx_idc_lock(struct qla_hw_data *);
 extern void qla82xx_idc_unlock(struct qla_hw_data *);
 extern int qla82xx_device_state_handler(scsi_qla_host_t *);
+extern void qla82xx_clear_qsnt_ready(scsi_qla_host_t *);
 
 extern void qla2x00_set_model_info(scsi_qla_host_t *, uint8_t *,
     size_t, char *);
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 259f511..6f7cf39 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -3844,6 +3844,37 @@ qla2x00_loop_resync(scsi_qla_host_t *vha)
 	return (rval);
 }
 
+/*
+* qla2x00_perform_loop_resync
+* Description: This function will set the appropriate flags and call
+*              qla2x00_loop_resync. If successful loop will be resynced
+* Arguments : scsi_qla_host_t pointer
+* returm    : Success or Failure
+*/
+
+int qla2x00_perform_loop_resync(scsi_qla_host_t *ha)
+{
+	int32_t rval = 0;
+
+	if (!test_and_set_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags)) {
+		/*Configure the flags so that resync happens properly*/
+		atomic_set(&ha->loop_down_timer, 0);
+		if (!(ha->device_flags & DFLG_NO_CABLE)) {
+			atomic_set(&ha->loop_state, LOOP_UP);
+			set_bit(LOCAL_LOOP_UPDATE, &ha->dpc_flags);
+			set_bit(REGISTER_FC4_NEEDED, &ha->dpc_flags);
+			set_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags);
+
+			rval = qla2x00_loop_resync(ha);
+		} else
+			atomic_set(&ha->loop_state, LOOP_DEAD);
+
+		clear_bit(LOOP_RESYNC_ACTIVE, &ha->dpc_flags);
+	}
+
+	return rval;
+}
+
 void
 qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 {
@@ -3871,11 +3902,43 @@ qla2x00_update_fcports(scsi_qla_host_t *base_vha)
 	spin_unlock_irqrestore(&ha->vport_slock, flags);
 }
 
+/*
+* qla82xx_quiescent_state_cleanup
+* Description: This function will block the new I/Os
+*              Its not aborting any I/Os as context
+*              is not destroyed during quiescence
+* Arguments: scsi_qla_host_t
+* return   : void
+*/
+void
+qla82xx_quiescent_state_cleanup(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	struct scsi_qla_host *vp;
+
+	qla_printk(KERN_INFO, ha,
+			"Performing ISP error recovery - ha= %p.\n", ha);
+
+	atomic_set(&ha->loop_down_timer, LOOP_DOWN_TIME);
+	if (atomic_read(&vha->loop_state) != LOOP_DOWN) {
+		atomic_set(&vha->loop_state, LOOP_DOWN);
+		qla2x00_mark_all_devices_lost(vha, 0);
+		list_for_each_entry(vp, &ha->vp_list, list)
+			qla2x00_mark_all_devices_lost(vha, 0);
+	} else {
+		if (!atomic_read(&vha->loop_down_timer))
+			atomic_set(&vha->loop_down_timer,
+					LOOP_DOWN_TIME);
+	}
+	/* Wait for pending cmds to complete */
+	qla2x00_eh_wait_for_pending_commands(vha, 0, 0, WAIT_HOST);
+}
+
 void
 qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 {
 	struct qla_hw_data *ha = vha->hw;
-	struct scsi_qla_host *vp, *base_vha = pci_get_drvdata(ha->pdev);
+	struct scsi_qla_host *vp;
 	unsigned long flags;
 
 	vha->flags.online = 0;
@@ -3896,7 +3959,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
 		qla2x00_mark_all_devices_lost(vha, 0);
 
 		spin_lock_irqsave(&ha->vport_slock, flags);
-		list_for_each_entry(vp, &base_vha->hw->vp_list, list) {
+		list_for_each_entry(vp, &ha->vp_list, list) {
 			atomic_inc(&vp->vref_count);
 			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index ae2acac..9175e84 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2343,6 +2343,17 @@ qla82xx_set_qsnt_ready(struct qla_hw_data *ha)
 	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, qsnt_state);
 }
 
+void
+qla82xx_clear_qsnt_ready(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t qsnt_state;
+
+	qsnt_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	qsnt_state &= ~(QLA82XX_DRVST_QSNT_RDY << (ha->portnum * 4));
+	qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, qsnt_state);
+}
+
 static int
 qla82xx_load_fw(scsi_qla_host_t *vha)
 {
@@ -3261,6 +3272,104 @@ dev_ready:
 	return QLA_SUCCESS;
 }
 
+/*
+* qla82xx_need_qsnt_handler
+*    Code to start quiescence sequence
+*
+* Note:
+*      IDC lock must be held upon entry
+*
+* Return: void
+*/
+
+static void
+qla82xx_need_qsnt_handler(scsi_qla_host_t *vha)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t dev_state, drv_state, drv_active;
+	unsigned long reset_timeout;
+
+	if (vha->flags.online) {
+		/*Block any further I/O and wait for pending cmnds to complete*/
+		qla82xx_quiescent_state_cleanup(vha);
+	}
+
+	/* Set the quiescence ready bit */
+	qla82xx_set_qsnt_ready(ha);
+
+	/*wait for 30 secs for other functions to ack */
+	reset_timeout = jiffies + (30 * HZ);
+
+	drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+	drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+	/* Its 2 that is written when qsnt is acked, moving one bit */
+	drv_active = drv_active << 0x01;
+
+	while (drv_state != drv_active) {
+
+		if (time_after_eq(jiffies, reset_timeout)) {
+			/* quiescence timeout, other functions didn't ack
+			 * changing the state to DEV_READY
+			 */
+			qla_printk(KERN_INFO, ha,
+			    "%s: QUIESCENT TIMEOUT\n", QLA2XXX_DRIVER_NAME);
+			qla_printk(KERN_INFO, ha,
+			    "DRV_ACTIVE:%d DRV_STATE:%d\n", drv_active,
+			    drv_state);
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+						QLA82XX_DEV_READY);
+			qla_printk(KERN_INFO, ha,
+			    "HW State: DEV_READY\n");
+			qla82xx_idc_unlock(ha);
+			qla2x00_perform_loop_resync(vha);
+			qla82xx_idc_lock(ha);
+
+			qla82xx_clear_qsnt_ready(vha);
+			return;
+		}
+
+		qla82xx_idc_unlock(ha);
+		msleep(1000);
+		qla82xx_idc_lock(ha);
+
+		drv_state = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+		drv_active = drv_active << 0x01;
+	}
+	dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+	/* everyone acked so set the state to DEV_QUIESCENCE */
+	if (dev_state == QLA82XX_DEV_NEED_QUIESCENT) {
+		qla_printk(KERN_INFO, ha, "HW State: DEV_QUIESCENT\n");
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE, QLA82XX_DEV_QUIESCENT);
+	}
+}
+
+/*
+* qla82xx_wait_for_state_change
+*    Wait for device state to change from given current state
+*
+* Note:
+*     IDC lock must not be held upon entry
+*
+* Return:
+*    Changed device state.
+*/
+uint32_t
+qla82xx_wait_for_state_change(scsi_qla_host_t *vha, uint32_t curr_state)
+{
+	struct qla_hw_data *ha = vha->hw;
+	uint32_t dev_state;
+
+	do {
+		msleep(1000);
+		qla82xx_idc_lock(ha);
+		dev_state = qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE);
+		qla82xx_idc_unlock(ha);
+	} while (dev_state == curr_state);
+
+	return dev_state;
+}
+
 static void
 qla82xx_dev_failed_handler(scsi_qla_host_t *vha)
 {
@@ -3443,11 +3552,25 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 				qla82xx_need_reset_handler(vha);
 			break;
 		case QLA82XX_DEV_NEED_QUIESCENT:
-			qla82xx_set_qsnt_ready(ha);
+			qla82xx_need_qsnt_handler(vha);
+			/* Reset timeout value after quiescence handler */
+			dev_init_timeout = jiffies + (ha->nx_dev_init_timeout\
+							 * HZ);
+			break;
 		case QLA82XX_DEV_QUIESCENT:
+			/* Owner will exit and other will wait for the state
+			 * to get changed
+			 */
+			if (ha->flags.quiesce_owner)
+				goto exit;
+
 			qla82xx_idc_unlock(ha);
 			msleep(1000);
 			qla82xx_idc_lock(ha);
+
+			/* Reset timeout value after quiescence handler */
+			dev_init_timeout = jiffies + (ha->nx_dev_init_timeout\
+							 * HZ);
 			break;
 		case QLA82XX_DEV_FAILED:
 			qla82xx_dev_failed_handler(vha);
@@ -3490,6 +3613,13 @@ void qla82xx_watchdog(scsi_qla_host_t *vha)
 					&ha->mbx_cmd_flags))
 					complete(&ha->mbx_intr_comp);
 			}
+		} else if (dev_state == QLA82XX_DEV_NEED_QUIESCENT &&
+			!test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags)) {
+			DEBUG(qla_printk(KERN_INFO, ha,
+				"scsi(%ld) %s - detected quiescence needed\n",
+				vha->host_no, __func__));
+			set_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags);
+			qla2xxx_wake_dpc(vha);
 		} else {
 			qla82xx_check_fw_alive(vha);
 		}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 2c0876c..df2c1e7 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3386,6 +3386,21 @@ qla2x00_do_dpc(void *data)
 			clear_bit(FCPORT_UPDATE_NEEDED, &base_vha->dpc_flags);
 		}
 
+		if (test_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags)) {
+			DEBUG(printk(KERN_INFO "scsi(%ld): dpc: sched "
+			    "qla2x00_quiesce_needed ha = %p\n",
+			    base_vha->host_no, ha));
+			qla82xx_device_state_handler(base_vha);
+			clear_bit(ISP_QUIESCE_NEEDED, &base_vha->dpc_flags);
+			if (!ha->flags.quiesce_owner) {
+				qla2x00_perform_loop_resync(base_vha);
+
+				qla82xx_idc_lock(ha);
+				qla82xx_clear_qsnt_ready(base_vha);
+				qla82xx_idc_unlock(ha);
+			}
+		}
+
 		if (test_and_clear_bit(RESET_MARKER_NEEDED,
 							&base_vha->dpc_flags) &&
 		    (!(test_and_set_bit(RESET_ACTIVE, &base_vha->dpc_flags)))) {
@@ -3589,13 +3604,16 @@ qla2x00_timer(scsi_qla_host_t *vha)
 		return;
 	}
 
-	if (IS_QLA82XX(ha))
-		qla82xx_watchdog(vha);
-
 	/* Hardware read to raise pending EEH errors during mailbox waits. */
 	if (!pci_channel_offline(ha->pdev))
 		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 
+	if (IS_QLA82XX(ha)) {
+		if (test_bit(ISP_QUIESCE_NEEDED, &vha->dpc_flags))
+			start_dpc++;
+		qla82xx_watchdog(vha);
+	}
+
 	/* Loop down handler. */
 	if (atomic_read(&vha->loop_down_timer) > 0 &&
 	    !(test_bit(ABORT_ISP_ACTIVE, &vha->dpc_flags))
-- 
1.6.0.2

