From: madhu.iyengar@qlogic.com
Subject: [PATCH 03/10] qla2xxx: Added AER support for ISP82xx.
Date: Fri,  3 Sep 2010 15:20:50 -0700
Message-ID: <1283552457-4497-4-git-send-email-madhu.iyengar@qlogic.com>
References: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39321 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753320Ab0ICW05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:57 -0400
In-Reply-To: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Lalit Chandivade <lalit.chandivade@qlogic.com>

From: Lalit Chandivade <lalit.chandivade@qlogic.com>


Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_gbl.h |    2 +
 drivers/scsi/qla2xxx/qla_nx.c  |    7 ++-
 drivers/scsi/qla2xxx/qla_os.c  |  134 +++++++++++++++++++++++++++++++++++++++-
 3 files changed, 138 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 1a1b281..4edfc73 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -511,6 +511,7 @@ extern void qla82xx_reset_chip(struct scsi_qla_host *);
 extern void qla82xx_config_rings(struct scsi_qla_host *);
 extern int qla82xx_pinit_from_rom(scsi_qla_host_t *);
 extern void qla82xx_watchdog(scsi_qla_host_t *);
+extern int qla82xx_start_firmware(scsi_qla_host_t *);
 
 /* Firmware and flash related functions */
 extern int qla82xx_load_risc(scsi_qla_host_t *, uint32_t *);
@@ -538,6 +539,7 @@ extern void qla82xx_poll(int, void *);
 extern void qla82xx_init_flags(struct qla_hw_data *);
 
 /* ISP 8021 hardware related */
+extern void qla82xx_set_drv_active(scsi_qla_host_t *);
 extern int qla82xx_crb_win_lock(struct qla_hw_data *);
 extern void qla82xx_crb_win_unlock(struct qla_hw_data *);
 extern int qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *, ulong *);
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 0a71cc7..66f0aee 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2257,7 +2257,7 @@ void qla82xx_init_flags(struct qla_hw_data *ha)
 	ha->nx_legacy_intr.pci_int_reg = nx_legacy_intr->pci_int_reg;
 }
 
-static inline void
+inline void
 qla82xx_set_drv_active(scsi_qla_host_t *vha)
 {
 	uint32_t drv_active;
@@ -2411,7 +2411,7 @@ fw_load_failed:
 	return QLA_FUNCTION_FAILED;
 }
 
-static int
+int
 qla82xx_start_firmware(scsi_qla_host_t *vha)
 {
 	int           pcie_cap;
@@ -3304,6 +3304,9 @@ qla82xx_check_fw_alive(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 
 	fw_heartbeat_counter = qla82xx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+	/* all 0xff, assume AER/EEH in progress, ignore */
+	if (fw_heartbeat_counter == 0xffffffff)
+		return;
 	if (vha->fw_heartbeat_counter == fw_heartbeat_counter) {
 		vha->seconds_since_last_heartbeat++;
 		/* FW not alive after 2 seconds */
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1e4bff6..6864eb1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3553,6 +3553,11 @@ qla2x00_timer(scsi_qla_host_t *vha)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req;
 
+	if (ha->flags.eeh_busy) {
+		qla2x00_restart_timer(vha, WATCH_INTERVAL);
+		return;
+	}
+
 	if (IS_QLA82XX(ha))
 		qla82xx_watchdog(vha);
 
@@ -3782,6 +3787,17 @@ qla2xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
 		return PCI_ERS_RESULT_CAN_RECOVER;
 	case pci_channel_io_frozen:
 		ha->flags.eeh_busy = 1;
+		/* For ISP82XX complete any pending mailbox cmd */
+		if (IS_QLA82XX(ha)) {
+			ha->flags.fw_hung = 1;
+			if (ha->flags.mbox_busy) {
+				ha->flags.mbox_int = 1;
+				DEBUG2(qla_printk(KERN_ERR, ha,
+					"Due to pci channel io frozen, doing premature "
+					"completion of mbx command\n"));
+				complete(&ha->mbx_intr_comp);
+			}
+		}
 		qla2x00_free_irqs(vha);
 		pci_disable_device(pdev);
 		return PCI_ERS_RESULT_NEED_RESET;
@@ -3830,6 +3846,109 @@ qla2xxx_pci_mmio_enabled(struct pci_dev *pdev)
 		return PCI_ERS_RESULT_RECOVERED;
 }
 
+uint32_t qla82xx_error_recovery(scsi_qla_host_t *base_vha)
+{
+	uint32_t rval = QLA_FUNCTION_FAILED;
+	uint32_t drv_active = 0;
+	struct qla_hw_data *ha = base_vha->hw;
+	int fn;
+	struct pci_dev *other_pdev = NULL;
+
+	DEBUG17(qla_printk(KERN_INFO, ha,
+	    "scsi(%ld): In qla82xx_error_recovery\n", base_vha->host_no));
+
+	set_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+
+	if (base_vha->flags.online) {
+		/* Abort all outstanding commands,
+		 * so as to be requeued later */
+		qla2x00_abort_isp_cleanup(base_vha);
+	}
+
+
+	fn = PCI_FUNC(ha->pdev->devfn);
+	while (fn > 0) {
+		fn--;
+		DEBUG17(qla_printk(KERN_INFO, ha,
+		    "Finding pci device at function = 0x%x\n", fn));
+		other_pdev =
+		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
+		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
+		    fn));
+
+		if (!other_pdev)
+			continue;
+		if (atomic_read(&other_pdev->enable_cnt)) {
+			DEBUG17(qla_printk(KERN_INFO, ha,
+			    "Found PCI func availabe and enabled at 0x%x\n",
+			    fn));
+			pci_dev_put(other_pdev);
+			break;
+		}
+		pci_dev_put(other_pdev);
+	}
+
+	if (!fn) {
+		/* Reset owner */
+		DEBUG17(qla_printk(KERN_INFO, ha,
+		    "This devfn is reset owner = 0x%x\n", ha->pdev->devfn));
+		qla82xx_idc_lock(ha);
+
+		qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+		    QLA82XX_DEV_INITIALIZING);
+
+		qla82xx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION,
+		    QLA82XX_IDC_VERSION);
+
+		drv_active = qla82xx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
+		DEBUG17(qla_printk(KERN_INFO, ha,
+		    "drv_active = 0x%x\n", drv_active));
+
+		qla82xx_idc_unlock(ha);
+		/* Reset if device is not already reset
+		 * drv_active would be 0 if a reset has already been done
+		 */
+		if (drv_active)
+			rval = qla82xx_start_firmware(base_vha);
+		else
+			rval = QLA_SUCCESS;
+		qla82xx_idc_lock(ha);
+
+		if (rval != QLA_SUCCESS) {
+			qla_printk(KERN_INFO, ha, "HW State: FAILED\n");
+			qla82xx_clear_drv_active(ha);
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			    QLA82XX_DEV_FAILED);
+		} else {
+			qla_printk(KERN_INFO, ha, "HW State: READY\n");
+			qla82xx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			    QLA82XX_DEV_READY);
+			qla82xx_idc_unlock(ha);
+			ha->flags.fw_hung = 0;
+			rval = qla82xx_restart_isp(base_vha);
+			qla82xx_idc_lock(ha);
+			/* Clear driver state register */
+			qla82xx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
+			qla82xx_set_drv_active(base_vha);
+		}
+		qla82xx_idc_unlock(ha);
+	} else {
+		DEBUG17(qla_printk(KERN_INFO, ha,
+		    "This devfn is not reset owner = 0x%x\n", ha->pdev->devfn));
+		if ((qla82xx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
+		    QLA82XX_DEV_READY)) {
+			ha->flags.fw_hung = 0;
+			rval = qla82xx_restart_isp(base_vha);
+			qla82xx_idc_lock(ha);
+			qla82xx_set_drv_active(base_vha);
+			qla82xx_idc_unlock(ha);
+		}
+	}
+	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
+
+	return rval;
+}
+
 static pci_ers_result_t
 qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 {
@@ -3862,15 +3981,23 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	if (rc) {
 		qla_printk(KERN_WARNING, ha,
 		    "Can't re-enable PCI device after reset.\n");
-		return ret;
+		goto exit_slot_reset;
 	}
 
 	rsp = ha->rsp_q_map[0];
 	if (qla2x00_request_irqs(ha, rsp))
-		return ret;
+		goto exit_slot_reset;
 
 	if (ha->isp_ops->pci_config(base_vha))
-		return ret;
+		goto exit_slot_reset;
+
+	if (IS_QLA82XX(ha)) {
+		if (qla82xx_error_recovery(base_vha) == QLA_SUCCESS) {
+			ret = PCI_ERS_RESULT_RECOVERED;
+			goto exit_slot_reset;
+		} else
+			goto exit_slot_reset;
+	}
 
 	while (ha->flags.mbox_busy && retries--)
 		msleep(1000);
@@ -3881,6 +4008,7 @@ qla2xxx_pci_slot_reset(struct pci_dev *pdev)
 	clear_bit(ABORT_ISP_ACTIVE, &base_vha->dpc_flags);
 
 
+exit_slot_reset:
 	DEBUG17(qla_printk(KERN_WARNING, ha,
 	    "slot_reset-return:ret=%x\n", ret));
 
-- 
1.6.0.2

