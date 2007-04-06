From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Use PCI-E reset API for new ipr adapter
Date: Fri, 06 Apr 2007 16:47:20 -0500
Message-ID: <18704.9837354154$1175901358@news.gmane.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46632 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156AbXDFVrX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Apr 2007 17:47:23 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l36LlMNq008440
	for <linux-scsi@vger.kernel.org>; Fri, 6 Apr 2007 17:47:22 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l36LlMe0303116
	for <linux-scsi@vger.kernel.org>; Fri, 6 Apr 2007 17:47:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l36LlLUf015299
	for <linux-scsi@vger.kernel.org>; Fri, 6 Apr 2007 17:47:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


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

James,

Don't apply this yet as it requires a PCI layer change
that has not yet been merged. I'll resend it when Greg pushes
the PCI change.

Thanks,

Brian
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |   70 ++++++++++++++++++++++++++++++++---
 linux-2.6-bjking1/drivers/scsi/ipr.h |    7 +++
 2 files changed, 71 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/ipr.h~ipr_pci_reset6 drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_pci_reset6	2007-04-06 15:43:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2007-04-06 15:43:41.000000000 -0500
@@ -37,7 +37,7 @@
 /*
  * Literals
  */
-#define IPR_DRIVER_VERSION "2.3.2"
+#define IPR_DRIVER_VERSION "2.3.3"
 #define IPR_DRIVER_DATE "(March 23, 2007)"
 
 /*
@@ -111,6 +111,7 @@
 
 /* Driver data flags */
 #define IPR_USE_LONG_TRANSOP_TIMEOUT		0x00000001
+#define IPR_USE_PCI_WARM_RESET			0x00000002
 
 #define IPR_DEFAULT_MAX_ERROR_DUMP			984
 #define IPR_NUM_LOG_HCAMS				2
@@ -191,6 +192,7 @@
 #define IPR_WAIT_FOR_RESET_TIMEOUT		(2 * HZ)
 #define IPR_CHECK_FOR_RESET_TIMEOUT		(HZ / 10)
 #define IPR_WAIT_FOR_BIST_TIMEOUT		(2 * HZ)
+#define IPR_PCI_RESET_TIMEOUT			(HZ / 2)
 #define IPR_DUMP_TIMEOUT			(15 * HZ)
 
 /*
@@ -1068,7 +1070,9 @@ struct ipr_ioa_cfg {
 	u8 allow_cmds:1;
 	u8 allow_ml_add_del:1;
 	u8 needs_hard_reset:1;
+	u8 needs_warm_reset:1;
 
+	u8 revid;
 	enum ipr_cache_state cache_state;
 	u16 type; /* CCIN of the card */
 
@@ -1161,6 +1165,7 @@ struct ipr_ioa_cfg {
 	struct pci_pool *ipr_cmd_pool;
 
 	struct ipr_cmnd *reset_cmd;
+	int (*reset) (struct ipr_cmnd *);
 
 	struct ata_host ata_host;
 	char ipr_cmd_label[8];
diff -puN drivers/scsi/ipr.c~ipr_pci_reset6 drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_pci_reset6	2007-04-06 15:43:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2007-04-06 15:43:41.000000000 -0500
@@ -6424,6 +6424,48 @@ static int ipr_reset_start_bist(struct i
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
+	pci_set_pcie_reset_state(ipr_cmd->ioa_cfg->pdev, pcie_deassert_reset);
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
+	pci_set_pcie_reset_state(pdev, pcie_warm_reset);
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
@@ -6462,7 +6504,7 @@ static int ipr_reset_wait_to_start_bist(
 		ipr_cmd->u.time_left -= IPR_CHECK_FOR_RESET_TIMEOUT;
 		ipr_reset_start_timer(ipr_cmd, IPR_CHECK_FOR_RESET_TIMEOUT);
 	} else {
-		ipr_cmd->job_step = ipr_reset_start_bist;
+		ipr_cmd->job_step = ioa_cfg->reset;
 		rc = IPR_RC_JOB_CONTINUE;
 	}
 
@@ -6495,7 +6537,7 @@ static int ipr_reset_alert(struct ipr_cm
 		writel(IPR_UPROCI_RESET_ALERT, ioa_cfg->regs.set_uproc_interrupt_reg);
 		ipr_cmd->job_step = ipr_reset_wait_to_start_bist;
 	} else {
-		ipr_cmd->job_step = ipr_reset_start_bist;
+		ipr_cmd->job_step = ioa_cfg->reset;
 	}
 
 	ipr_cmd->u.time_left = IPR_WAIT_FOR_RESET_TIMEOUT;
@@ -6775,8 +6817,11 @@ static pci_ers_result_t ipr_pci_slot_res
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
@@ -7264,6 +7309,14 @@ static int __devinit ipr_probe_ioa(struc
 	else
 		ioa_cfg->transop_timeout = IPR_OPERATIONAL_TIMEOUT;
 
+	rc = pci_read_config_byte(pdev, PCI_REVISION_ID, &ioa_cfg->revid);
+
+	if (rc != PCIBIOS_SUCCESSFUL) {
+		dev_err(&pdev->dev, "Failed to read PCI revision ID\n");
+		rc = -EIO;
+		goto out_scsi_host_put;
+	}
+
 	ipr_regs_pci = pci_resource_start(pdev, 0);
 
 	rc = pci_request_regions(pdev, IPR_NAME);
@@ -7345,6 +7398,13 @@ static int __devinit ipr_probe_ioa(struc
 		goto cleanup_nolog;
 	}
 
+	if ((dev_id->driver_data & IPR_USE_PCI_WARM_RESET) ||
+	    (dev_id->device == PCI_DEVICE_ID_IBM_OBSIDIAN_E && !ioa_cfg->revid)) {
+		ioa_cfg->needs_warm_reset = 1;
+		ioa_cfg->reset = ipr_reset_slot_reset;
+	} else
+		ioa_cfg->reset = ipr_reset_start_bist;
+
 	spin_lock(&ipr_driver_lock);
 	list_add_tail(&ioa_cfg->queue, &ipr_ioa_head);
 	spin_unlock(&ipr_driver_lock);
@@ -7596,7 +7656,7 @@ static struct pci_device_id ipr_pci_tabl
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B3, 0, 0, 0 },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_OBSIDIAN_E,
 	      PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_57B7, 0, 0,
-	      IPR_USE_LONG_TRANSOP_TIMEOUT },
+	      IPR_USE_LONG_TRANSOP_TIMEOUT | IPR_USE_PCI_WARM_RESET },
 	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_SNIPE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_2780, 0, 0, 0 },
 	{ PCI_VENDOR_ID_ADAPTEC2, PCI_DEVICE_ID_ADAPTEC2_SCAMP,
_
