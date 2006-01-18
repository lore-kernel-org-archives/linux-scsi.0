From: linas@austin.ibm.com (linas)
Subject: [PATCH] PCI Error Recovery: IPR SCSI device driver]
Date: Wed, 18 Jan 2006 10:51:10 -0600
Message-ID: <20060118165110.GR26221@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:62619 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S932363AbWARQvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2006 11:51:14 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k0IGpC5w018938
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 11:51:12 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k0IGpCDe132054
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 11:51:12 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k0IGpBIU015938
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jan 2006 11:51:12 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: brking@us.ibm.com, gregkh@suse.de, linux-scsi@vger.kernel.org


Hi James,

Brian King <brking@us.ibm.com> wrote:
> It needs to go through linux-scsi. Send it to James.Bottomley@steeleye.com,
> and cc linux-scsi@vger.kernel.org, myself, and probably Greg as well.

Please review the patch below, and forward upstream.  I've been
bouncing it to various mailing lists for the last half-year,
it has been living in an -mm tree for a while, and was a part of
GregKH's patchset for a while. I'd like to get it propely upstream.

The general description of the principles at work here are given in
Documentation/pci-error-recovery.txt

Thanks, 

--linas

----- Forwarded message from Greg KH <gregkh@suse.de> -----

Subject: [PATCH] PCI Error Recovery: IPR SCSI device driver
In-Reply-To: <1136529514812@kroah.com>
X-Mailer: gregkh_patchbomb
Date: Thu, 5 Jan 2006 22:38:35 -0800
Message-Id: <11365295151096@kroah.com>
Reply-To: Greg K-H <greg@kroah.com>
To: linux-pci@atrey.karlin.mff.cuni.cz
From: Greg KH <gregkh@suse.de>
Sender: owner-linux-pci@atrey.karlin.mff.cuni.cz

[PATCH] PCI Error Recovery: IPR SCSI device driver

Various PCI bus errors can be signaled by newer PCI controllers.  This
patch adds the PCI error recovery callbacks to the IPR SCSI device driver.
The patch has been tested, and appears to work well.

Signed-off-by: Linas Vepstas <linas@linas.org>
Signed-off-by: Brian King <brking@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--

---
commit 5a02e3abf1e74c159deca91d6af01297379eede7
tree a2b6a187822c14fa26898eb5d028bc13e1db79e4
parent 3c0006afdd8ade574257c88df81c93b0bb71b544
author linas <linas@austin.ibm.com> Fri, 18 Nov 2005 16:22:38 -0600
committer Greg Kroah-Hartman <gregkh@suse.de> Thu, 05 Jan 2006 21:54:55 -0800

 drivers/scsi/ipr.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 27acf78..ca10b2e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -5868,6 +5868,92 @@ static void ipr_initiate_ioa_reset(struc
 				shutdown_type);
 }
 
+/* --------------- PCI Error Recovery infrastructure ----------- */
+/** If the PCI slot is frozen, hold off all i/o
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
+/** ipr_eeh_frozen -- called when slot has experience PCI bus error.
+ *  This routine is called to tell us that the PCI bus is down.
+ *  Can't do anything here, except put the device driver into a
+ *  holding pattern, waiting for the PCI bus to come back.
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
+/** ipr_eeh_slot_reset - called when pci slot has been reset.
+ *
+ * This routine is called by the pci error recovery recovery
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
+/** This routine is called when the PCI bus has permanently
+ *  failed.  This routine should purge all pending I/O and
+ *  shut down the device driver (close and unload).
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
+/* ------------- end of PCI Error Recovery suport ----------- */
+
 /**
  * ipr_probe_ioa_part2 - Initializes IOAs found in ipr_probe_ioa(..)
  * @ioa_cfg:	ioa cfg struct
@@ -6640,12 +6726,18 @@ static struct pci_device_id ipr_pci_tabl
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



----- End forwarded message -----



-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center


----- End forwarded message -----
