From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] PCI Error Recovery: IPR SCSI device driver
Date: Fri, 03 Feb 2006 16:52:42 -0600
Message-ID: <43E3DEBA.5070806@us.ibm.com>
References: <20060202193130.GJ24916@austin.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050903010603010402040503"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:9909 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750873AbWBCWwt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2006 17:52:49 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k13Mqj2W029470
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 17:52:45 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k13MqjrK212682
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 17:52:45 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k13Mqi9E012801
	for <linux-scsi@vger.kernel.org>; Fri, 3 Feb 2006 17:52:45 -0500
In-Reply-To: <20060202193130.GJ24916@austin.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linas Vepstas <linas@austin.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------050903010603010402040503
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linas Vepstas wrote:
> Brian,
> Please forward this patch upstream.
> 
> --linas
> 
> 
> Various PCI bus errors can be signaled by newer PCI controllers.  This
> patch adds the PCI error recovery callbacks to the IPR SCSI device driver.
> The patch has been tested, and appears to work well.

Made a few minor cosmetic changes.

James, please apply.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center

--------------050903010603010402040503
Content-Type: text/x-patch;
 name="ipr_eeh_recovery.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipr_eeh_recovery.patch"


From: linas@austin.ibm.com (Linas Vepstas)

Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the IPR SCSI device driver.
The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@linas.org>
Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |  109 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 109 insertions(+)

diff -puN drivers/scsi/ipr.c~ipr_eeh_recovery drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_eeh_recovery	2006-02-03 14:18:35.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-02-03 15:14:11.000000000 -0600
@@ -5869,6 +5869,109 @@ static void ipr_initiate_ioa_reset(struc
 }
 
 /**
+ * ipr_reset_freeze - Hold off all I/O activity
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: If the PCI slot is frozen, hold off all I/O
+ * activity; then, as soon as the slot is available again,
+ * initiate an adapter reset.
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
+ * ipr_pci_frozen - Called when slot has experienced a PCI bus error.
+ * @pdev:	PCI device struct
+ *
+ * Description: This routine is called to tell us that the PCI bus
+ * is down. Can't do anything here, except put the device driver
+ * into a holding pattern, waiting for the PCI bus to come back.
+ */
+static void ipr_pci_frozen(struct pci_dev *pdev)
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
+ * ipr_pci_slot_reset - Called when PCI slot has been reset.
+ * @pdev:	PCI device struct
+ *
+ * Description: This routine is called by the pci error recovery
+ * code after the PCI slot has been reset, just before we
+ * should resume normal operations.
+ */
+static pci_ers_result_t ipr_pci_slot_reset(struct pci_dev *pdev)
+{
+	unsigned long flags = 0;
+	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
+
+	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
+	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_restore_cfg_space,
+	                                 IPR_SHUTDOWN_NONE);
+	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
+	return PCI_ERS_RESULT_RECOVERED;
+}
+
+/**
+ * ipr_pci_perm_failure - Called when PCI slot is dead for good.
+ * @pdev:	PCI device struct
+ *
+ * Description: This routine is called when the PCI bus has
+ * permanently failed.
+ */
+static void ipr_pci_perm_failure(struct pci_dev *pdev)
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
+/**
+ * ipr_pci_error_detected - Called when a PCI error is detected.
+ * @pdev:	PCI device struct
+ * @state:	PCI channel state
+ *
+ * Description: Called when a PCI error is detected.
+ *
+ * Return value:
+ * 	PCI_ERS_RESULT_NEED_RESET or PCI_ERS_RESULT_DISCONNECT
+ */
+static pci_ers_result_t ipr_pci_error_detected(struct pci_dev *pdev,
+					       pci_channel_state_t state)
+{
+	switch (state) {
+	case pci_channel_io_frozen:
+		ipr_pci_frozen(pdev);
+		return PCI_ERS_RESULT_NEED_RESET;
+	case pci_channel_io_perm_failure:
+		ipr_pci_perm_failure(pdev);
+		return PCI_ERS_RESULT_DISCONNECT;
+		break;
+	default:
+		break;
+	}
+	return PCI_ERS_RESULT_NEED_RESET;
+}
+
+/**
  * ipr_probe_ioa_part2 - Initializes IOAs found in ipr_probe_ioa(..)
  * @ioa_cfg:	ioa cfg struct
  *
@@ -6640,12 +6743,18 @@ static struct pci_device_id ipr_pci_tabl
 };
 MODULE_DEVICE_TABLE(pci, ipr_pci_table);
 
+static struct pci_error_handlers ipr_err_handler = {
+	.error_detected = ipr_pci_error_detected,
+	.slot_reset = ipr_pci_slot_reset,
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
_

--------------050903010603010402040503--
