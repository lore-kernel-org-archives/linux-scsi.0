From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/3] ipr: Use PCI-E reset API for new ipr adapter
Date: Thu, 01 Feb 2007 11:30:36 -0600
Message-ID: <200702011730.l11HUcPY030247@d01av01.pok.ibm.com>
References: <11703510202911-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53236 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbXBARam (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Feb 2007 12:30:42 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l11HUeBE028475
	for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2007 12:30:40 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l11HUeon272038
	for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2007 12:30:40 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l11HUdsU030317
	for <linux-scsi@vger.kernel.org>; Thu, 1 Feb 2007 12:30:40 -0500
In-Reply-To: <11703510202911-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de
Cc: linux-pci@atrey.karlin.mff.cuni.cz, paulus@samba.org, linuxppc-dev@ozlabs.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, hch@lst.de, brking@linux.vnet.ibm.com


Use a newly added PCI API to issue a PCI Fundamental reset
(warm reset) to a new ipr PCI-E adapter. Typically, the
ipr adapter uses the start BIST bit in config space to reset
an adapter. Issuing start BIST on this particular adapter
results in the PCI-E logic on the card losing sync, which
causes PCI-E errors, making the card unusable. The only reset
mechanism that exists on this hardware that does not have this
problem is PCI Fundamental reset (warm reset).

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   61 ++++++++++++++++++++++++++++++++---
 linux-2.6-bjking1/drivers/scsi/ipr.h |    7 ++--
 2 files changed, 61 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_pci_reset6 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_pci_reset6	2007-02-01 10:31:27.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-02-01 10:31:27.000000000 -0600
@@ -37,8 +37,8 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.3.1"
-#define IPR_DRIVER_DATE "(January 23, 2007)"
+#define IPR_DRIVER_VERSION "2.3.2"
+#define IPR_DRIVER_DATE "(January 26, 2007)"
 
 /*
  * IPR_MAX_CMD_PER_LUN: This defines the maximum number of outstanding
@@ -182,6 +182,7 @@
 #define IPR_WAIT_FOR_RESET_TIMEOUT		(2 * HZ)
 #define IPR_CHECK_FOR_RESET_TIMEOUT		(HZ / 10)
 #define IPR_WAIT_FOR_BIST_TIMEOUT		(2 * HZ)
+#define IPR_PCI_RESET_TIMEOUT			(HZ / 2)
 #define IPR_DUMP_TIMEOUT			(15 * HZ)
 
 /*
@@ -1058,6 +1059,7 @@ struct ipr_ioa_cfg {
 	u8 allow_cmds:1;
 	u8 allow_ml_add_del:1;
 	u8 needs_hard_reset:1;
+	u8 needs_warm_reset:1;
 
 	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */
@@ -1150,6 +1152,7 @@ struct ipr_ioa_cfg {
 	struct pci_pool *ipr_cmd_pool;
 
 	struct ipr_cmnd *reset_cmd;
+	int (*reset) (struct ipr_cmnd *);
 
 	struct ata_host ata_host;
 	char ipr_cmd_label[8];
diff -puN drivers/scsi/ipr.c~ipr_pci_reset6 drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_pci_reset6	2007-02-01 10:31:27.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-02-01 10:31:27.000000000 -0600
@@ -6397,6 +6397,48 @@ static int ipr_reset_start_bist(struct i
 }
 
 /**
+ * ipr_reset_slot_reset_done - Clear PCI reset to the adapter
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This clears PCI reset to the adapter and delays two seconds.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_slot_reset_done(struct ipr_cmnd *ipr_cmd)
+{
+	ENTER;
+	pci_set_pcie_reset_state(ipr_cmd->ioa_cfg->pdev, pci_reset_normal);
+	ipr_cmd->job_step = ipr_reset_bist_done;
+	ipr_reset_start_timer(ipr_cmd, IPR_WAIT_FOR_BIST_TIMEOUT);
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
+ * ipr_reset_slot_reset - Reset the PCI slot of the adapter.
+ * @ipr_cmd:	ipr command struct
+ *
+ * Description: This asserts PCI reset to the adapter.
+ *
+ * Return value:
+ * 	IPR_RC_JOB_RETURN
+ **/
+static int ipr_reset_slot_reset(struct ipr_cmnd *ipr_cmd)
+{
+	struct ipr_ioa_cfg *ioa_cfg = ipr_cmd->ioa_cfg;
+	struct pci_dev *pdev = ioa_cfg->pdev;
+
+	ENTER;
+	pci_block_user_cfg_access(pdev);
+	pci_set_pcie_reset_state(pdev, pci_reset_pcie_warm_reset);
+	ipr_cmd->job_step = ipr_reset_slot_reset_done;
+	ipr_reset_start_timer(ipr_cmd, IPR_PCI_RESET_TIMEOUT);
+	LEAVE;
+	return IPR_RC_JOB_RETURN;
+}
+
+/**
  * ipr_reset_allowed - Query whether or not IOA can be reset
  * @ioa_cfg:	ioa config struct
  *
@@ -6435,7 +6477,7 @@ static int ipr_reset_wait_to_start_bist(
 		ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
 		ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
 	} else {
-		ipr_cmd->job_step = ipr_reset_start_bist;
+		ipr_cmd->job_step = ioa_cfg->reset;
 		rc = IPR_RC_JOB_CONTINUE;
 	}
 
@@ -6468,7 +6510,7 @@ static int ipr_reset_alert(struct ipr_cm
 		writel(IPR_UPROCI_RESET_ALERT, ioa_cfg->regs.set_uproc_interrupt_reg);
 		ipr_cmd->job_step = ipr_reset_wait_to_start_bist;
 	} else {
-		ipr_cmd->job_step = ipr_reset_start_bist;
+		ipr_cmd->job_step = ioa_cfg->reset;
 	}
 
 	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
@@ -6748,8 +6790,11 @@ static pci_ers_result_t ipr_pci_slot_res
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
 	spin_lock_irqsave(ioa_cfg->host->host_lock, flags);
-	_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_restore_cfg_space,
-	                                 IPR_SHUTDOWN_NONE);
+	if (ioa_cfg->needs_warm_reset)
+		ipr_initiate_ioa_reset(ioa_cfg, IPR_SHUTDOWN_NONE);
+	else
+		_ipr_initiate_ioa_reset(ioa_cfg, ipr_reset_restore_cfg_space,
+					IPR_SHUTDOWN_NONE);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, flags);
 	return PCI_ERS_RESULT_RECOVERED;
 }
@@ -7313,6 +7358,12 @@ static int __devinit ipr_probe_ioa(struc
 		goto cleanup_nolog;
 	}
 
+	if (dev_id->driver_data) {
+		ioa_cfg->needs_warm_reset = 1;
+		ioa_cfg->reset = ipr_reset_slot_reset;
+	} else
+		ioa_cfg->reset = ipr_reset_start_bist;
+
 	spin_lock(&ipr_driver_lock);
 	list_add_tail(&ioa_cfg->queue, &ipr_ioa_head);
 	spin_unlock(&ipr_driver_lock);
@@ -7555,7 +7606,7 @@ static struct pci_device_id ipr_pci_tabl
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B8, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
-	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0, 0 },
+	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0, 1 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
_
