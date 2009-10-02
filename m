From: James Smart <James.Smart@Emulex.Com>
Subject: [Patch 4/6] lpfc 8.3.5: Add AER support
Date: Fri, 2 Oct 2009 15:16:56 -0400
Message-ID: <1254511016.32739.23.camel@ogier>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:64007 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbZJBT7E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Oct 2009 15:59:04 -0400
Received: from xcm.ad.emulex.com (xcm.emulex.com [138.239.112.69])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id n92Jx7Vg026964
	for <linux-scsi@vger.kernel.org>; Fri, 2 Oct 2009 12:59:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>


This patch adds AER support.


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc.h      |    2 
 lpfc_attr.c |  177 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 lpfc_init.c |   96 ++++++++++++++++++++++++--------
 lpfc_sli.c  |   27 +++++++++
 4 files changed, 278 insertions(+), 24 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
--- a/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_attr.c	2009-10-01 17:21:40.000000000 -0400
@@ -23,6 +23,7 @@
 #include <linux/delay.h>
 #include <linux/pci.h>
 #include <linux/interrupt.h>
+#include <linux/aer.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -2766,6 +2767,179 @@ static DEVICE_ATTR(lpfc_link_speed, S_IR
 		lpfc_link_speed_show, lpfc_link_speed_store);
 
 /*
+# lpfc_aer_support: Support PCIe device Advanced Error Reporting (AER)
+#       0  = aer disabled or not supported
+#       1  = aer supported and enabled (default)
+# Value range is [0,1]. Default value is 1.
+*/
+
+/**
+ * lpfc_aer_support_store - Set the adapter for aer support
+ *
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string "selective".
+ * @count: unused variable.
+ *
+ * Description:
+ * If the val is 1 and currently the device's AER capability was not
+ * enabled, invoke the kernel's enable AER helper routine, trying to
+ * enable the device's AER capability. If the helper routine enabling
+ * AER returns success, update the device's cfg_aer_support flag to
+ * indicate AER is supported by the device; otherwise, if the device
+ * AER capability is already enabled to support AER, then do nothing.
+ *
+ * If the val is 0 and currently the device's AER support was enabled,
+ * invoke the kernel's disable AER helper routine. After that, update
+ * the device's cfg_aer_support flag to indicate AER is not supported
+ * by the device; otherwise, if the device AER capability is already
+ * disabled from supporting AER, then do nothing.
+ *
+ * Returns:
+ * length of the buf on success if val is in range the intended mode
+ * is supported.
+ * -EINVAL if val out of range or intended mode is not supported.
+ **/
+static ssize_t
+lpfc_aer_support_store(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct Scsi_Host *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *)shost->hostdata;
+	struct lpfc_hba *phba = vport->phba;
+	int val = 0, rc = -EINVAL;
+
+	if (!isdigit(buf[0]))
+		return -EINVAL;
+	if (sscanf(buf, "%i", &val) != 1)
+		return -EINVAL;
+
+	switch (val) {
+	case 0:
+		if (phba->hba_flag & HBA_AER_ENABLED) {
+			rc = pci_disable_pcie_error_reporting(phba->pcidev);
+			if (!rc) {
+				spin_lock_irq(&phba->hbalock);
+				phba->hba_flag &= ~HBA_AER_ENABLED;
+				spin_unlock_irq(&phba->hbalock);
+				phba->cfg_aer_support = 0;
+				rc = strlen(buf);
+			} else
+				rc = -EINVAL;
+		} else
+			phba->cfg_aer_support = 0;
+		rc = strlen(buf);
+		break;
+	case 1:
+		if (!(phba->hba_flag & HBA_AER_ENABLED)) {
+			rc = pci_enable_pcie_error_reporting(phba->pcidev);
+			if (!rc) {
+				spin_lock_irq(&phba->hbalock);
+				phba->hba_flag |= HBA_AER_ENABLED;
+				spin_unlock_irq(&phba->hbalock);
+				phba->cfg_aer_support = 1;
+				rc = strlen(buf);
+			} else
+				 rc = -EINVAL;
+		} else
+			phba->cfg_aer_support = 1;
+		rc = strlen(buf);
+		break;
+	default:
+		rc = -EINVAL;
+		break;
+	}
+	return rc;
+}
+
+static int lpfc_aer_support = 1;
+module_param(lpfc_aer_support, int, 1);
+MODULE_PARM_DESC(lpfc_aer_support, "Enable PCIe device AER support");
+lpfc_param_show(aer_support)
+
+/**
+ * lpfc_aer_support_init - Set the initial adapters aer support flag
+ * @phba: lpfc_hba pointer.
+ * @val: link speed value.
+ *
+ * Description:
+ * If val is in a valid range [0,1], then set the adapter's initial
+ * cfg_aer_support field. It will be up to the driver's probe_one
+ * routine to determine whether the device's AER support can be set
+ * or not.
+ *
+ * Notes:
+ * If the value is not in range log a kernel error message, and
+ * choose the default value of setting AER support and return.
+ *
+ * Returns:
+ * zero if val saved.
+ * -EINVAL val out of range
+ **/
+static int
+lpfc_aer_support_init(struct lpfc_hba *phba, int val)
+{
+	if (val == 0 || val == 1) {
+		phba->cfg_aer_support = val;
+		return 0;
+	}
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2712 lpfc_aer_support attribute value %d out "
+			"of range, allowed values are 0|1, setting it "
+			"to default value of 1\n", val);
+	phba->cfg_aer_support = 1;
+	return -EINVAL;
+}
+
+static DEVICE_ATTR(lpfc_aer_support, S_IRUGO | S_IWUSR,
+		   lpfc_aer_support_show, lpfc_aer_support_store);
+
+/**
+ * lpfc_aer_cleanup_state - Clean up aer state to the aer enabled device
+ * @dev: class device that is converted into a Scsi_host.
+ * @attr: device attribute, not used.
+ * @buf: containing the string "selective".
+ * @count: unused variable.
+ *
+ * Description:
+ * If the @buf contains 1 and the device currently has the AER support
+ * enabled, then invokes the kernel AER helper routine
+ * pci_cleanup_aer_uncorrect_error_status to clean up the uncorrectable
+ * error status register.
+ *
+ * Notes:
+ *
+ * Returns:
+ * -EINVAL if the buf does not contain the 1 or the device is not currently
+ * enabled with the AER support.
+ **/
+static ssize_t
+lpfc_aer_cleanup_state(struct device *dev, struct device_attribute *attr,
+		       const char *buf, size_t count)
+{
+	struct Scsi_Host  *shost = class_to_shost(dev);
+	struct lpfc_vport *vport = (struct lpfc_vport *) shost->hostdata;
+	struct lpfc_hba   *phba = vport->phba;
+	int val, rc = -1;
+
+	if (!isdigit(buf[0]))
+		return -EINVAL;
+	if (sscanf(buf, "%i", &val) != 1)
+		return -EINVAL;
+
+	if (val == 1 && phba->hba_flag & HBA_AER_ENABLED)
+		rc = pci_cleanup_aer_uncorrect_error_status(phba->pcidev);
+
+	if (rc == 0)
+		return strlen(buf);
+	else
+		return -EINVAL;
+}
+
+static DEVICE_ATTR(lpfc_aer_state_cleanup, S_IWUSR, NULL,
+		   lpfc_aer_cleanup_state);
+
+/*
 # lpfc_fcp_class:  Determines FC class to use for the FCP protocol.
 # Value range is [2,3]. Default value is 3.
 */
@@ -3068,6 +3242,8 @@ struct device_attribute *lpfc_hba_attrs[
 	&dev_attr_lpfc_max_scsicmpl_time,
 	&dev_attr_lpfc_stat_data_ctrl,
 	&dev_attr_lpfc_prot_sg_seg_cnt,
+	&dev_attr_lpfc_aer_support,
+	&dev_attr_lpfc_aer_state_cleanup,
 	NULL,
 };
 
@@ -4244,6 +4420,7 @@ lpfc_get_cfgparam(struct lpfc_hba *phba)
 	lpfc_hba_queue_depth_init(phba, lpfc_hba_queue_depth);
 	lpfc_enable_fip_init(phba, lpfc_enable_fip);
 	lpfc_hba_log_verbose_init(phba, lpfc_log_verbose);
+	lpfc_aer_support_init(phba, lpfc_aer_support);
 
 	return;
 }
diff -upNr a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
--- a/drivers/scsi/lpfc/lpfc.h	2009-10-01 17:20:05.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc.h	2009-10-01 17:21:40.000000000 -0400
@@ -534,6 +534,7 @@ struct lpfc_hba {
 #define ASYNC_EVENT		0x80
 #define LINK_DISABLED		0x100 /* Link disabled by user */
 #define FCF_DISC_INPROGRESS	0x200 /* FCF discovery in progress */
+#define HBA_AER_ENABLED         0x800 /* AER enabled with HBA */
 	struct lpfc_dmabuf slim2p;
 
 	MAILBOX_t *mbox;
@@ -607,6 +608,7 @@ struct lpfc_hba {
 	uint32_t cfg_enable_bg;
 	uint32_t cfg_enable_fip;
 	uint32_t cfg_log_verbose;
+	uint32_t cfg_aer_support;
 
 	lpfc_vpd_t vpd;		/* vital product data */
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2009-10-01 17:21:40.000000000 -0400
@@ -28,6 +28,7 @@
 #include <linux/pci.h>
 #include <linux/spinlock.h>
 #include <linux/ctype.h>
+#include <linux/aer.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_device.h>
@@ -7098,6 +7099,7 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 	/* Restore device state from PCI config space */
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
+
 	if (pdev->is_busmaster)
 		pci_set_master(pdev);
 
@@ -7132,6 +7134,53 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
 }
 
 /**
+ * lpfc_sli_prep_dev_for_reset - Prepare SLI3 device for pci slot reset
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI3 device for PCI slot reset. It
+ * disables the device interrupt and pci device, and aborts the internal FCP
+ * pending I/Os.
+ **/
+static void
+lpfc_sli_prep_dev_for_reset(struct lpfc_hba *phba)
+{
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2710 PCI channel I/O frozen\n");
+	/* Disable interrupt and pci device */
+	lpfc_sli_disable_intr(phba);
+	pci_disable_device(phba->pcidev);
+	/*
+	 * There may be I/Os dropped by the firmware.
+	 * Error iocb (I/O) on txcmplq and let the SCSI layer
+	 * retry it after re-establishing link.
+	 */
+	pring = &psli->ring[psli->fcp_ring];
+	lpfc_sli_abort_iocb_ring(phba, pring);
+}
+
+/**
+ * lpfc_sli_prep_dev_for_perm_failure - Prepare SLI3 dev for pci slot disable
+ * @phba: pointer to lpfc hba data structure.
+ *
+ * This routine is called to prepare the SLI3 device for PCI slot permanently
+ * disabling. It blocks the SCSI transport layer traffic and flushes the FCP
+ * pending I/Os.
+ **/
+static void
+lpfc_prep_dev_for_perm_failure(struct lpfc_hba *phba)
+{
+	lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+			"2711 PCI channel I/O permanent failure\n");
+	/* Block all SCSI devices' I/Os on the host */
+	lpfc_scsi_dev_block(phba);
+	/* Clean up all driver's outstanding SCSI I/Os */
+	lpfc_sli_flush_fcp_rings(phba);
+}
+
+/**
  * lpfc_io_error_detected_s3 - Method for handling SLI-3 device PCI I/O error
  * @pdev: pointer to PCI device.
  * @state: the current PCI connection state.
@@ -7145,6 +7194,7 @@ lpfc_pci_resume_one_s3(struct pci_dev *p
  * as desired.
  *
  * Return codes
+ * 	PCI_ERS_RESULT_CAN_RECOVER - can be recovered with reset_link
  * 	PCI_ERS_RESULT_NEED_RESET - need to reset before recovery
  * 	PCI_ERS_RESULT_DISCONNECT - device could not be recovered
  **/
@@ -7153,33 +7203,26 @@ lpfc_io_error_detected_s3(struct pci_dev
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
-	struct lpfc_sli *psli = &phba->sli;
-	struct lpfc_sli_ring  *pring;
 
-	if (state == pci_channel_io_perm_failure) {
-		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-				"0472 PCI channel I/O permanent failure\n");
-		/* Block all SCSI devices' I/Os on the host */
-		lpfc_scsi_dev_block(phba);
-		/* Clean up all driver's outstanding SCSI I/Os */
-		lpfc_sli_flush_fcp_rings(phba);
+	switch (state) {
+	case pci_channel_io_normal:
+		/* Non-fatal error, do nothing */
+		return PCI_ERS_RESULT_CAN_RECOVER;
+	case pci_channel_io_frozen:
+		/* Fatal error, prepare for slot reset */
+		lpfc_sli_prep_dev_for_reset(phba);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		/* Permanent failure, prepare for device down */
+		lpfc_prep_dev_for_perm_failure(phba);
 		return PCI_ERS_RESULT_DISCONNECT;
+	default:
+		/* Unknown state, prepare and request slot reset */
+  		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0472 Unknown PCI error state: x%x\n", state);
+		lpfc_sli_prep_dev_for_reset(phba);
+		return PCI_ERS_RESULT_NEED_RESET;
 	}
-
-	pci_disable_device(pdev);
-	/*
-	 * There may be I/Os dropped by the firmware.
-	 * Error iocb (I/O) on txcmplq and let the SCSI layer
-	 * retry it after re-establishing link.
-	 */
-	pring = &psli->ring[psli->fcp_ring];
-	lpfc_sli_abort_iocb_ring(phba, pring);
-
-	/* Disable interrupt */
-	lpfc_sli_disable_intr(phba);
-
-	/* Request a slot reset. */
-	return PCI_ERS_RESULT_NEED_RESET;
 }
 
 /**
@@ -7259,7 +7302,12 @@ lpfc_io_resume_s3(struct pci_dev *pdev)
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct lpfc_hba *phba = ((struct lpfc_vport *)shost->hostdata)->phba;
 
+	/* Bring the device online */
 	lpfc_online(phba);
+
+	/* Clean up Advanced Error Reporting (AER) if needed */
+	if (phba->hba_flag & HBA_AER_ENABLED)
+		pci_cleanup_aer_uncorrect_error_status(pdev);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:21:21.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2009-10-01 17:21:40.000000000 -0400
@@ -30,6 +30,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/fc/fc_fs.h>
+#include <linux/aer.h>
 
 #include "lpfc_hw4.h"
 #include "lpfc_hw.h"
@@ -3551,9 +3552,13 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *
 	struct lpfc_sli *psli;
 	volatile uint32_t word0;
 	void __iomem *to_slim;
+	uint32_t hba_aer_enabled;
 
 	spin_lock_irq(&phba->hbalock);
 
+	/* Take PCIe device Advanced Error Reporting (AER) state */
+	hba_aer_enabled = phba->hba_flag & HBA_AER_ENABLED;
+
 	psli = &phba->sli;
 
 	/* Restart HBA */
@@ -3593,6 +3598,10 @@ lpfc_sli_brdrestart_s3(struct lpfc_hba *
 	/* Give the INITFF and Post time to settle. */
 	mdelay(100);
 
+	/* Reset HBA AER if it was enabled, note hba_flag was reset above */
+	if (hba_aer_enabled)
+		pci_disable_pcie_error_reporting(phba->pcidev);
+
 	lpfc_hba_down_post(phba);
 
 	return 0;
@@ -4062,6 +4071,24 @@ lpfc_sli_hba_setup(struct lpfc_hba *phba
 	if (rc)
 		goto lpfc_sli_hba_setup_error;
 
+	/* Enable PCIe device Advanced Error Reporting (AER) if configured */
+	if (phba->cfg_aer_support == 1 && !(phba->hba_flag & HBA_AER_ENABLED)) {
+		rc = pci_enable_pcie_error_reporting(phba->pcidev);
+		if (!rc) {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2709 This device supports "
+					"Advanced Error Reporting (AER)\n");
+			spin_lock_irq(&phba->hbalock);
+			phba->hba_flag |= HBA_AER_ENABLED;
+			spin_unlock_irq(&phba->hbalock);
+		} else {
+			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
+					"2708 This device does not support "
+					"Advanced Error Reporting (AER)\n");
+			phba->cfg_aer_support = 0;
+		}
+	}
+
 	if (phba->sli_rev == 3) {
 		phba->iocb_cmd_size = SLI3_IOCB_CMD_SIZE;
 		phba->iocb_rsp_size = SLI3_IOCB_RSP_SIZE;


