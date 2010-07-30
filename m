From: Lalit Chandivade <lalit.chandivade@qlogic.com>
Subject: [PATCH 7/8] qla4xxx: Added AER support for ISP82xx
Date: Fri, 30 Jul 2010 14:28:29 +0530
Message-ID: <20100730085829.GA12334@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 115.113.65.67.static-pune-stdill.vsnl.net.in ([115.113.65.67]:16561
	"HELO sles11sp1b1.site" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S1755987Ab0G3JKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jul 2010 05:10:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: vikas.chaudhary@qlogic.com, ravi.anand@qlogic.com, michaelc@cs.wisc.edu, lalit.chandivade@qlogic.com

Added support for PCI error handling

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Signed-off-by: Poornima Vonti <poornima.vonti@qlogic.com>
Signed-off-by: Ravi Anand <ravi.anand@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_def.h  |   30 ++++-
 drivers/scsi/qla4xxx/ql4_glbl.h |    1 +
 drivers/scsi/qla4xxx/ql4_init.c |    5 +-
 drivers/scsi/qla4xxx/ql4_isr.c  |    3 +
 drivers/scsi/qla4xxx/ql4_mbx.c  |    8 +
 drivers/scsi/qla4xxx/ql4_nx.c   |    8 +-
 drivers/scsi/qla4xxx/ql4_os.c   |  301 +++++++++++++++++++++++++++++++++++++++
 7 files changed, 352 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index 6c92627..9dc0a66 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -36,6 +36,24 @@
 #include "ql4_dbg.h"
 #include "ql4_nx.h"
 
+#if defined(CONFIG_PCIEAER)
+#include <linux/aer.h>
+#else
+/* AER releated */
+static inline int pci_enable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_disable_pcie_error_reporting(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+static inline int pci_cleanup_aer_uncorrect_error_status(struct pci_dev *dev)
+{
+	return -EINVAL;
+}
+#endif
+
 #ifndef PCI_DEVICE_ID_QLOGIC_ISP4010
 #define PCI_DEVICE_ID_QLOGIC_ISP4010	0x4010
 #endif
@@ -381,7 +399,8 @@ struct scsi_qla_host {
 #define AF_MSIX_ENABLED			17 /* 0x00020000 */
 #define AF_MBOX_COMMAND_NOPOLL		18 /* 0x00040000 */
 #define AF_FW_RECOVERY			19 /* 0x00080000 */
-
+#define AF_EEH_BUSY			20 /* 0x00100000 */
+#define AF_PCI_CHANNEL_IO_PERM_FAILURE	21 /* 0x00200000 */
 
 	unsigned long dpc_flags;
 
@@ -617,6 +636,15 @@ static inline int is_qla8022(struct scsi_qla_host *ha)
 	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8022;
 }
 
+/* Note: Currently AER/EEH is now supported only for 8022 cards
+ * This function needs to be updated when AER/EEH is enabled
+ * for other cards.
+ */
+static inline int is_aer_supported(struct scsi_qla_host *ha)
+{
+	return ha->pdev->device == PCI_DEVICE_ID_QLOGIC_ISP8022;
+}
+
 static inline int adapter_up(struct scsi_qla_host *ha)
 {
 	return (test_bit(AF_ONLINE, &ha->flags) != 0) &&
diff --git a/drivers/scsi/qla4xxx/ql4_glbl.h b/drivers/scsi/qla4xxx/ql4_glbl.h
index ea3db23..f065204 100644
--- a/drivers/scsi/qla4xxx/ql4_glbl.h
+++ b/drivers/scsi/qla4xxx/ql4_glbl.h
@@ -132,6 +132,7 @@ void qla4_8xxx_idc_unlock(struct scsi_qla_host *ha);
 int qla4_8xxx_device_state_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_need_qsnt_handler(struct scsi_qla_host *ha);
 void qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha);
+inline void qla4_8xxx_set_drv_active(struct scsi_qla_host *ha);
 
 extern int ql4xextended_error_logging;
 extern int ql4xdiscoverywait;
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 8841941..0a51e16 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -308,7 +308,6 @@ static int qla4xxx_fw_ready(struct scsi_qla_host *ha)
 			DEBUG2(printk("scsi%ld: %s: unable to get firmware "
 				      "state\n", ha->host_no, __func__));
 			break;
-
 		}
 
 		if (ha->firmware_state & FW_STATE_ERROR) {
@@ -445,6 +444,10 @@ static int qla4xxx_init_firmware(struct scsi_qla_host *ha)
 {
 	int status = QLA_ERROR;
 
+	if (is_aer_supported(ha) &&
+	    test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))
+		return status;
+
 	/* For 82xx, stop firmware before initializing because if BIOS
 	 * has previously initialized firmware, then driver's initialize
 	 * firmware will fail. */
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index aa65697..2a1ab63 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -816,6 +816,9 @@ irqreturn_t qla4_8xxx_intr_handler(int irq, void *dev_id)
 	unsigned long flags = 0;
 	uint8_t reqs_count = 0;
 
+	if (unlikely(pci_channel_offline(ha->pdev)))
+		return IRQ_HANDLED;
+
 	ha->isr_count++;
 	status = qla4_8xxx_rd_32(ha, ISR_INT_VECTOR);
 	if (!(status & ha->nx_legacy_intr.int_vec_bit))
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index 1003e48..9002170 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -48,6 +48,13 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		return status;
 	}
 
+	if ((is_aer_supported(ha)) &&
+	    (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))) {
+		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Perm failure on EEH, "
+		    "timeout MBX Exiting.\n", ha->host_no, __func__));
+		return status;
+	}
+
 	/* Mailbox code active */
 	wait_count = MBOX_TOV * 100;
 
@@ -159,6 +166,7 @@ int qla4xxx_mailbox_command(struct scsi_qla_host *ha, uint8_t inCount,
 		while (test_bit(AF_MBOX_COMMAND_DONE, &ha->flags) == 0) {
 			if (time_after_eq(jiffies, wait_count))
 				break;
+
 			/*
 			 * Service the interrupt.
 			 * The ISR will save the mailbox status registers
diff --git a/drivers/scsi/qla4xxx/ql4_nx.c b/drivers/scsi/qla4xxx/ql4_nx.c
index 0830ea9..1b85235 100644
--- a/drivers/scsi/qla4xxx/ql4_nx.c
+++ b/drivers/scsi/qla4xxx/ql4_nx.c
@@ -1418,7 +1418,7 @@ static int qla4_8xxx_rcvpeg_ready(struct scsi_qla_host *ha)
 	return QLA_SUCCESS;
 }
 
-static inline void
+inline void
 qla4_8xxx_set_drv_active(struct scsi_qla_host *ha)
 {
 	uint32_t drv_active;
@@ -1441,11 +1441,15 @@ qla4_8xxx_clear_drv_active(struct scsi_qla_host *ha)
 static inline int
 qla4_8xxx_need_reset(struct scsi_qla_host *ha)
 {
-	uint32_t drv_state;
+	uint32_t drv_state, drv_active;
 	int rval;
 
+	drv_active = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DRV_ACTIVE);
 	drv_state = qla4_8xxx_rd_32(ha, QLA82XX_CRB_DRV_STATE);
 	rval = drv_state & (1 << (ha->func_num * 4));
+	if ((test_bit(AF_EEH_BUSY, &ha->flags)) && drv_active)
+		rval = 1;
+
 	return rval;
 }
 
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 2bb362c..370d40f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -475,6 +475,14 @@ static int qla4xxx_queuecommand(struct scsi_cmnd *cmd,
 	struct srb *srb;
 	int rval;
 
+	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
+		if (test_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags))
+			cmd->result = DID_NO_CONNECT << 16;
+		else
+			cmd->result = DID_REQUEUE << 16;
+		goto qc_fail_command;
+	}
+
 	if (!sess) {
 		cmd->result = DID_IMM_RETRY << 16;
 		goto qc_fail_command;
@@ -655,6 +663,13 @@ static void qla4_8xxx_check_fw_alive(struct scsi_qla_host *ha)
 	uint32_t fw_heartbeat_counter, halt_status;
 
 	fw_heartbeat_counter = qla4_8xxx_rd_32(ha, QLA82XX_PEG_ALIVE_COUNTER);
+	/* If PEG_ALIVE_COUNTER is 0xffffffff, AER/EEH is in progress, ignore */
+	if (fw_heartbeat_counter == 0xffffffff) {
+		DEBUG2(printk(KERN_WARNING "scsi%ld: %s: Device in frozen "
+		    "state, QLA82XX_PEG_ALIVE_COUNTER is 0xffffffff\n",
+		    ha->host_no, __func__));
+		return;
+	}
 
 	if (ha->fw_heartbeat_counter == fw_heartbeat_counter) {
 		ha->seconds_since_last_heartbeat++;
@@ -723,6 +738,19 @@ static void qla4xxx_timer(struct scsi_qla_host *ha)
 {
 	struct ddb_entry *ddb_entry, *dtemp;
 	int start_dpc = 0;
+	uint16_t w;
+
+	/* If we are in the middle of AER/EEH processing
+	 * skip any processing and reschedule the timer
+	 */
+	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
+		mod_timer(&ha->timer, jiffies + HZ);
+		return;
+	}
+
+	/* Hardware read to trigger an EEH error during mailbox waits. */
+	if (!pci_channel_offline(ha->pdev))
+		pci_read_config_word(ha->pdev, PCI_VENDOR_ID, &w);
 
 	if (test_bit(AF_HBA_GOING_AWAY, &ha->flags)) {
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s exited. HBA GOING AWAY\n",
@@ -1213,6 +1241,12 @@ static void qla4xxx_do_dpc(struct work_struct *work)
 	if (!test_bit(AF_INIT_DONE, &ha->flags))
 		goto do_dpc_exit;
 
+	if (test_bit(AF_EEH_BUSY, &ha->flags)) {
+		DEBUG2(printk(KERN_INFO "scsi%ld: %s: flags = %lx\n",
+		    ha->host_no, __func__, ha->flags));
+		goto do_dpc_exit;
+	}
+
 	/* HBA is in the process of being permanently disabled.
 	 * Don't process anything */
 	if (test_bit(AF_HBA_GOING_AWAY, &ha->flags))
@@ -1618,6 +1652,8 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 	ha->host = host;
 	ha->host_no = host->host_no;
 
+	pci_enable_pcie_error_reporting(pdev);
+
 	/* Setup Runtime configurable options */
 	if (is_qla8022(ha)) {
 		ha->isp_ops = &qla4_8xxx_isp_ops;
@@ -1636,6 +1672,10 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		ha->isp_ops = &qla4xxx_isp_ops;
 	}
 
+	/* Set EEH reset type to fundamental if required by hba */
+	if (is_qla8022(ha))
+		pdev->needs_freset = 1;
+
 	/* Configure PCI I/O space. */
 	ret = ha->isp_ops->iospace_config(ha);
 	if (ret)
@@ -1732,6 +1772,7 @@ static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
 		}
 	}
 
+	pci_save_state(ha->pdev);
 	ha->isp_ops->enable_intrs(ha);
 
 	/* Start timer thread. */
@@ -1758,6 +1799,7 @@ probe_failed:
 	qla4xxx_free_adapter(ha);
 
 probe_failed_ioconfig:
+	pci_disable_pcie_error_reporting(pdev);
 	scsi_host_put(ha->host);
 
 probe_disable_device:
@@ -1787,6 +1829,7 @@ static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
 
 	scsi_host_put(ha->host);
 
+	pci_disable_pcie_error_reporting(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 }
@@ -1883,6 +1926,17 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
 	int done = 0;
 	struct srb *rp;
 	uint32_t max_wait_time = EH_WAIT_CMD_TOV;
+	int ret = SUCCESS;
+
+	/* Dont wait on command if PCI error is being handled
+	 * by PCI AER driver
+	 */
+	if (unlikely(pci_channel_offline(ha->pdev)) ||
+	    (test_bit(AF_EEH_BUSY, &ha->flags))) {
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: Return from %s\n",
+		    ha->host_no, __func__);
+		return ret;
+	}
 
 	do {
 		/* Checking to see if its returned to OS */
@@ -2178,6 +2232,252 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
 	return return_status;
 }
 
+/* PCI AER driver recovers from all correctable errors w/o
+ * driver intervention. For uncorrectable errors PCI AER
+ * driver calls the following device driver's callbacks
+ *
+ * - Fatal Errors - link_reset
+ * - Non-Fatal Errors - driver's pci_error_detected() which
+ * returns CAN_RECOVER, NEED_RESET or DISCONNECT.
+ *
+ * PCI AER driver calls
+ * CAN_RECOVER - driver's pci_mmio_enabled(), mmio_enabled
+ *               returns RECOVERED or NEED_RESET if fw_hung
+ * NEED_RESET - driver's slot_reset()
+ * DISCONNECT - device is dead & cannot recover
+ * RECOVERED - driver's pci_resume()
+ */
+static pci_ers_result_t
+qla4xxx_pci_error_detected(struct pci_dev *pdev, pci_channel_state_t state)
+{
+	struct scsi_qla_host *ha = pci_get_drvdata(pdev);
+
+	ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: error detected:state %x\n",
+	    ha->host_no, __func__, state);
+
+	if (!is_aer_supported(ha))
+		return PCI_ERS_RESULT_NONE;
+
+	switch (state) {
+	case pci_channel_io_normal:
+		clear_bit(AF_EEH_BUSY, &ha->flags);
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		set_bit(AF_EEH_BUSY, &ha->flags);
+		qla4xxx_mailbox_premature_completion(ha);
+		qla4xxx_free_irqs(ha);
+		pci_disable_device(pdev);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		set_bit(AF_EEH_BUSY, &ha->flags);
+		set_bit(AF_PCI_CHANNEL_IO_PERM_FAILURE, &ha->flags);
+		qla4xxx_abort_active_cmds(ha, DID_NO_CONNECT << 16);
+		return PCI_ERS_RESULT_DISCONNECT;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
+ * qla4xxx_pci_mmio_enabled() gets called if
+ * qla4xxx_pci_error_detected() returns PCI_ERS_RESULT_CAN_RECOVER
+ * and read/write to the device still works.
+ **/
+static pci_ers_result_t
+qla4xxx_pci_mmio_enabled(struct pci_dev *pdev)
+{
+	struct scsi_qla_host *ha = pci_get_drvdata(pdev);
+
+	if (!is_aer_supported(ha))
+		return PCI_ERS_RESULT_NONE;
+
+	if (test_bit(AF_FW_RECOVERY, &ha->flags)) {
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: firmware hang  -- "
+		    "mmio_enabled\n", ha->host_no, __func__);
+		return PCI_ERS_RESULT_NEED_RESET;
+	} else
+		return PCI_ERS_RESULT_RECOVERED;
+}
+
+uint32_t qla4_8xxx_error_recovery(struct scsi_qla_host *ha)
+{
+	uint32_t rval = QLA_ERROR;
+	int fn;
+	struct pci_dev *other_pdev = NULL;
+
+	ql4_printk(KERN_WARNING, ha, "scsi%ld: In %s\n", ha->host_no, __func__);
+
+	set_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
+
+	if (test_bit(AF_ONLINE, &ha->flags)) {
+		clear_bit(AF_ONLINE, &ha->flags);
+		qla4xxx_mark_all_devices_missing(ha);
+		qla4xxx_process_aen(ha, FLUSH_DDB_CHANGED_AENS);
+		qla4xxx_abort_active_cmds(ha, DID_RESET << 16);
+	}
+
+	fn = PCI_FUNC(ha->pdev->devfn);
+	while (fn > 0) {
+		fn--;
+		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Finding PCI device at "
+		    "func %x\n", ha->host_no, __func__, fn);
+		/* Get the pci device given the domain, bus,
+		 * slot/function number */
+		other_pdev =
+		    pci_get_domain_bus_and_slot(pci_domain_nr(ha->pdev->bus),
+		    ha->pdev->bus->number, PCI_DEVFN(PCI_SLOT(ha->pdev->devfn),
+		    fn));
+
+		if (!other_pdev)
+			continue;
+
+		if (atomic_read(&other_pdev->enable_cnt)) {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: Found PCI "
+			    "func in enabled state%x\n", ha->host_no,
+			    __func__, fn);
+			pci_dev_put(other_pdev);
+			break;
+		}
+		pci_dev_put(other_pdev);
+	}
+
+	/* The first function on the card, the reset owner will
+	 * start & initialize the firmware. The other functions
+	 * on the card will reset the firmware context
+	 */
+	if (!fn) {
+		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: devfn being reset "
+		    "0x%x is the owner\n", ha->host_no, __func__,
+		    ha->pdev->devfn);
+
+		qla4_8xxx_idc_lock(ha);
+		qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+		    QLA82XX_DEV_COLD);
+
+		qla4_8xxx_wr_32(ha, QLA82XX_CRB_DRV_IDC_VERSION,
+		    QLA82XX_IDC_VERSION);
+
+		qla4_8xxx_idc_unlock(ha);
+		clear_bit(AF_FW_RECOVERY, &ha->flags);
+		rval = qla4xxx_initialize_adapter(ha, PRESERVE_DDB_LIST);
+		qla4_8xxx_idc_lock(ha);
+
+		if (rval != QLA_SUCCESS) {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: "
+			    "FAILED\n", ha->host_no, __func__);
+			qla4_8xxx_clear_drv_active(ha);
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			    QLA82XX_DEV_FAILED);
+		} else {
+			ql4_printk(KERN_INFO, ha, "scsi%ld: %s: HW State: "
+			    "READY\n", ha->host_no, __func__);
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DEV_STATE,
+			    QLA82XX_DEV_READY);
+			/* Clear driver state register */
+			qla4_8xxx_wr_32(ha, QLA82XX_CRB_DRV_STATE, 0);
+			qla4_8xxx_set_drv_active(ha);
+			ha->isp_ops->enable_intrs(ha);
+		}
+		qla4_8xxx_idc_unlock(ha);
+	} else {
+		ql4_printk(KERN_INFO, ha, "scsi%ld: %s: devfn 0x%x is not "
+		    "the reset owner\n", ha->host_no, __func__,
+		    ha->pdev->devfn);
+		if ((qla4_8xxx_rd_32(ha, QLA82XX_CRB_DEV_STATE) ==
+		    QLA82XX_DEV_READY)) {
+			clear_bit(AF_FW_RECOVERY, &ha->flags);
+			rval = qla4xxx_initialize_adapter(ha,
+			    PRESERVE_DDB_LIST);
+			if (rval == QLA_SUCCESS)
+				ha->isp_ops->enable_intrs(ha);
+			qla4_8xxx_idc_lock(ha);
+			qla4_8xxx_set_drv_active(ha);
+			qla4_8xxx_idc_unlock(ha);
+		}
+	}
+	clear_bit(DPC_RESET_ACTIVE, &ha->dpc_flags);
+	return rval;
+}
+
+static pci_ers_result_t
+qla4xxx_pci_slot_reset(struct pci_dev *pdev)
+{
+	pci_ers_result_t ret = PCI_ERS_RESULT_DISCONNECT;
+	struct scsi_qla_host *ha = pci_get_drvdata(pdev);
+	int rc;
+
+	ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: slot_reset\n",
+	    ha->host_no, __func__);
+
+	if (!is_aer_supported(ha))
+		return PCI_ERS_RESULT_NONE;
+
+	/* Restore the saved state of PCIe device -
+	 * BAR registers, PCI Config space, PCIX, MSI,
+	 * IOV states
+	 */
+	pci_restore_state(pdev);
+
+	/* pci_restore_state() clears the saved_state flag of the device
+	 * save restored state which resets saved_state flag
+	 */
+	pci_save_state(pdev);
+
+	/* Initialize device or resume if in suspended state */
+	rc = pci_enable_device(pdev);
+	if (rc) {
+		ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: Cant re-enable "
+		    "device after reset\n", ha->host_no, __func__);
+		goto exit_slot_reset;
+	}
+
+	ret = qla4xxx_request_irqs(ha);
+	if (ret) {
+		ql4_printk(KERN_WARNING, ha, "Failed to reserve interrupt %d"
+		    " already in use.\n", pdev->irq);
+		goto exit_slot_reset;
+	}
+
+	if (is_qla8022(ha)) {
+		if (qla4_8xxx_error_recovery(ha) == QLA_SUCCESS) {
+			ret = PCI_ERS_RESULT_RECOVERED;
+			goto exit_slot_reset;
+		} else
+			goto exit_slot_reset;
+	}
+
+exit_slot_reset:
+	ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: Return=%x\n"
+	    "device after reset\n", ha->host_no, __func__, ret);
+	return ret;
+}
+
+static void
+qla4xxx_pci_resume(struct pci_dev *pdev)
+{
+	struct scsi_qla_host *ha = pci_get_drvdata(pdev);
+	int ret;
+
+	ql4_printk(KERN_WARNING, ha, "scsi%ld: %s: pci_resume\n",
+	    ha->host_no, __func__);
+
+	ret = qla4xxx_wait_for_hba_online(ha);
+	if (ret != QLA_SUCCESS) {
+		ql4_printk(KERN_ERR, ha, "scsi%ld: %s: the device failed to "
+		    "resume I/O from slot/link_reset\n", ha->host_no,
+		     __func__);
+	}
+
+	pci_cleanup_aer_uncorrect_error_status(pdev);
+	clear_bit(AF_EEH_BUSY, &ha->flags);
+}
+
+static struct pci_error_handlers qla4xxx_err_handler = {
+	.error_detected = qla4xxx_pci_error_detected,
+	.mmio_enabled = qla4xxx_pci_mmio_enabled,
+	.slot_reset = qla4xxx_pci_slot_reset,
+	.resume = qla4xxx_pci_resume,
+};
+
 static struct pci_device_id qla4xxx_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_QLOGIC,
@@ -2212,6 +2512,7 @@ static struct pci_driver qla4xxx_pci_driver = {
 	.id_table	= qla4xxx_pci_tbl,
 	.probe		= qla4xxx_probe_adapter,
 	.remove		= qla4xxx_remove_adapter,
+	.err_handler = &qla4xxx_err_handler,
 };
 
 static int __init qla4xxx_module_init(void)
-- 
1.6.6

