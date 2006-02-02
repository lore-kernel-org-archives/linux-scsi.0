From: linas@austin.ibm.com (Linas Vepstas)
Subject: [PATCH] PCI Error Recovery: IPR SCSI device driver
Date: Thu, 2 Feb 2006 13:31:30 -0600
Message-ID: <20060202193130.GJ24916@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:63922 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S932199AbWBBTbc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Feb 2006 14:31:32 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k12JVV8d011830
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 14:31:31 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k12JTYXd271290
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 12:29:34 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k12JVVXf031494
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 12:31:31 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org


Brian,
Please forward this patch upstream.

--linas


Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the IPR SCSI device driver.
The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@linas.org>
Signed-off-by: Brian King <brking@us.ibm.com>

--
 ipr.c |   98 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 98 insertions(+)

Index: linux-2.6.16-rc1-git5/drivers/scsi/ipr.c
===================================================================
--- linux-2.6.16-rc1-git5.orig/drivers/scsi/ipr.c	2006-02-02 12:09:17.303632816 -0600
+++ linux-2.6.16-rc1-git5/drivers/scsi/ipr.c	2006-02-02 12:19:23.428395688 -0600
@@ -5868,6 +5868,98 @@
 				shutdown_type);
 }
 
+/** 
+ *  ipr_reset_freeze - hold off all i/o activity
+ *
+ *  Description: If the PCI slot is frozen, hold off all i/o
+ *  activity; then, as soon as the slot is available again,
+ *  initiate an adapter reset.
+ */
+static int ipr_reset_freeze(struct ipr_cmnd *ipr_cmd)
+{
+	/* Disallow new interrupts, avoid loop */
+	ipr_cmd->ioa_cfg->allow_interrupts = 0;
+	list_add_tail(&ipr_cmd->queue, &ipr_cmd->ioa_cfg->pending_q);
+	ipr_cmd->done = ipr_reset_ioa_job;
+	return IPR_RC_JOB_RETURN;
+}
+
+/** 
+ *  ipr_eeh_frozen - called when slot has experience PCI bus error.
+ *  
+ *  Description: This routine is called to tell us that the PCI bus 
+ *  is down. Can't do anything here, except put the device driver 
+ *  into a holding pattern, waiting for the PCI bus to come back.
+ */
+static void ipr_eeh_frozen (struct pci_dev *pdev)
+{
+	unsigned long flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_freeze, IPR_SHUTDOWN_NONE);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+}
+
+/** 
+ * ipr_eeh_slot_reset - called when pci slot has been reset.
+ * 
+ * Description: This routine is called by the pci error recovery 
+ * code after the PCI slot has been reset, just before we
+ * should resume normal operations.
+ */
+static pci_ers_result_t ipr_eeh_slot_reset(struct pci_dev *pdev)
+{
+	unsigned long flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_restore_cfg_space,
+	                                 IPR_SHUTDOWN_NONE);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/** 
+ *  ipr_eeh_perm_failure -- called when pci slot s dead for good.
+ *  
+ *  iDescription: This routine is called when the PCI bus has 
+ *  permanently failed.  This routine should purge all pending 
+ *  I/O and shut down the device driver (close and unload).
+ */
+static void ipr_eeh_perm_failure(struct pci_dev *pdev)
+{
+	unsigned long flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	if (ioa_cfg->sdt_state == WAIT_FOR_DUMP)
+		ioa_cfg->sdt_state = ABORT_DUMP;
+	ioa_cfg->reset_retries = IPR_NUM_RESET_RELOAD_RETRIES;
+	ioa_cfg->in_ioa_bringdown = 1;
+	ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+}
+
+static pci_ers_result_t ipr_eeh_error_detected(struct pci_dev *pdev,
+                                pci_channel_state_t state)
+{
+	switch (state) {
+		case pci_channel_io_frozen:
+			ipr_eeh_frozen (pdev);
+			return PCI_ERS_RESULT_NEED_RESET;
+
+		case pci_channel_io_perm_failure:
+			ipr_eeh_perm_failure (pdev);
+			return PCI_ERS_RESULT_DISCONNECT;
+			break;
+		default:
+			break;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
 /**
  * ipr_probe_ioa_part2 - Initializes IOAs found in ipr_probe_ioa(..)
  * @ioa_cfg:	ioa cfg struct
@@ -6640,12 +6732,18 @@
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
 
+static struct pci_error_handlers ipr_err_handler = {
+	.error_detected = ipr_eeh_error_detected,
+	.slot_reset = ipr_eeh_slot_reset,
+};
+
 static struct pci_driver ipr_driver = {
 	.name = IPR_NAME,
 	.id_table = ipr_pci_table,
 	.probe = ipr_probe,
 	.remove = ipr_remove,
 	.shutdown = ipr_shutdown,
+	.err_handler = &ipr_err_handler,
 };
 
 /**
