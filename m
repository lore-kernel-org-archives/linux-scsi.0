From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: [PATCH 1/1] pmcraid: Changed driver prints to scmd/sdev_printk
Date: Wed, 9 Sep 2009 15:54:57 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0909091526560.933@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:40818 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbZIIXuH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2009 19:50:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: gregkh@suse.de, anil_ravindranath@pmc-sierra.com


1.Changed driver prints to use scmd_printk, sdev_printk
2.Changed dev_err calls to scmd_printk for scsi related print messages

Signed-off-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

 pmcraid.c |   58 
+++++++++++++++++++++++++++++++---------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.c	2009-09-09 10:14:45.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.c	2009-09-09 12:32:01.000000000 -0700
@@ -46,6 +46,7 @@
 #include <linux/mutex.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_cmnd.h>
@@ -684,7 +685,7 @@ static void pmcraid_timeout_handler(stru
 	struct pmcraid_instance *pinstance = cmd->drv_inst;
 	unsigned long lock_flags;
 
-	dev_err(&pinstance->pdev->dev,
+	dev_info(&pinstance->pdev->dev,
 		"Adapter being reset due to command timeout.\n");
 
 	/* Command timeouts result in hard reset sequence. The command that got
@@ -815,8 +816,9 @@ static void pmcraid_erp_done(struct pmcr
 
 	if (PMCRAID_IOASC_SENSE_KEY(ioasc) > 0) {
 		scsi_cmd->result |= (DID_ERROR << 16);
-		pmcraid_err("command CDB[0] = %x failed with IOASC: 0x%08X\n",
-			     cmd->ioa_cb->ioarcb.cdb[0], ioasc);
+		scmd_printk(KERN_INFO, scsi_cmd,
+			    "command CDB[0] = %x failed with IOASC: 0x%08X\n",
+			    cmd->ioa_cb->ioarcb.cdb[0], ioasc);
 	}
 
 	/* if we had allocated sense buffers for request sense, copy the sense
@@ -1541,13 +1543,13 @@ static void pmcraid_handle_error_log(str
 
 	if (pinstance->ldn.hcam->notification_lost ==
 	    HOSTRCB_NOTIFICATIONS_LOST)
-		dev_err(&pinstance->pdev->dev, "Error notifications lost\n");
+		dev_info(&pinstance->pdev->dev, "Error notifications lost\n");
 
 	ioasc = le32_to_cpu(hcam_ldn->error_log.fd_ioasc);
 
 	if (ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET ||
 		ioasc == PMCRAID_IOASC_UA_BUS_WAS_RESET_BY_OTHER) {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"UnitAttention due to IOA Bus Reset\n");
 		scsi_report_bus_reset(
 			pinstance->host,
@@ -1584,7 +1586,7 @@ static void pmcraid_process_ccn(struct p
 	    atomic_read(&pinstance->ccn.ignore) == 1) {
 		return;
 	} else if (ioasc) {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"Host RCB (CCN) failed with IOASC: 0x%08X\n", ioasc);
 		spin_lock_irqsave(pinstance->host->host_lock, lock_flags);
 		pmcraid_send_hcam(pinstance, PMCRAID_HCAM_CODE_CONFIG_CHANGE);
@@ -1634,7 +1636,7 @@ static void pmcraid_process_ldn(struct p
 			return;
 		}
 	} else {
-		dev_err(&pinstance->pdev->dev,
+		dev_info(&pinstance->pdev->dev,
 			"Host RCB(LDN) failed with IOASC: 0x%08X\n", ioasc);
 	}
 	/* send netlink message for HCAM notification if enabled */
@@ -1822,7 +1824,6 @@ static void pmcraid_fail_outstanding_cmd
 			scsi_dma_unmap(scsi_cmd);
 			pmcraid_return_cmd(cmd);
 
-
 			pmcraid_info("failing(%d) CDB[0] = %x result: %x\n",
 				     le32_to_cpu(resp) >> 2,
 				     cmd->ioa_cb->ioarcb.cdb[0],
@@ -2514,7 +2515,8 @@ static int pmcraid_reset_device(
 	res = scsi_cmd->device->hostdata;
 
 	if (!res) {
-		pmcraid_err("reset_device: NULL resource pointer\n");
+		sdev_printk(KERN_ERR, scsi_cmd->device,
+			    "reset_device: NULL resource pointer\n");
 		return FAILED;
 	}
 
@@ -2752,8 +2754,8 @@ static int pmcraid_eh_abort_handler(stru
 	pinstance =
 		(struct pmcraid_instance *)scsi_cmd->device->host->hostdata;
 
-	dev_err(&pinstance->pdev->dev,
-		"I/O command timed out, aborting it.\n");
+	scmd_printk(KERN_INFO, scsi_cmd,
+		    "I/O command timed out, aborting it.\n");
 
 	res = scsi_cmd->device->hostdata;
 
@@ -2824,7 +2826,8 @@ static int pmcraid_eh_abort_handler(stru
  */
 static int pmcraid_eh_device_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing device reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "resetting device due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_LUN);
@@ -2832,7 +2835,8 @@ static int pmcraid_eh_device_reset_handl
 
 static int pmcraid_eh_bus_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing bus reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "Doing bus reset due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_RESET_BUS_TIMEOUT,
 				    RESET_DEVICE_BUS);
@@ -2840,7 +2844,8 @@ static int pmcraid_eh_bus_reset_handler(
 
 static int pmcraid_eh_target_reset_handler(struct scsi_cmnd *scmd)
 {
-	pmcraid_err("Doing target reset due to an I/O command timeout.\n");
+	scmd_printk(KERN_INFO, scmd,
+		    "Doing target reset due to an I/O command timeout.\n");
 	return pmcraid_reset_device(scmd,
 				    PMCRAID_INTERNAL_TIMEOUT,
 				    RESET_DEVICE_TARGET);
@@ -2988,11 +2993,11 @@ static int pmcraid_build_ioadl(
 	nseg = scsi_dma_map(scsi_cmd);
 
 	if (nseg < 0) {
-		dev_err(&pinstance->pdev->dev, "scsi_map_dma failed!\n");
+		scmd_printk(KERN_ERR, scsi_cmd, "scsi_map_dma failed!\n");
 		return -1;
 	} else if (nseg > PMCRAID_MAX_IOADLS) {
 		scsi_dma_unmap(scsi_cmd);
-		dev_err(&pinstance->pdev->dev,
+		scmd_printk(KERN_ERR, scsi_cmd,
 			"sg count is (%d) more than allowed!\n", nseg);
 		return -1;
 	}
@@ -5040,7 +5045,7 @@ static int pmcraid_resume(struct pci_dev
 	rc = pci_enable_device(pdev);
 
 	if (rc) {
-		pmcraid_err("pmcraid: Enable device failed\n");
+		dev_err(&pdev->dev, "resume: Enable device failed\n");
 		return rc;
 	}
 
@@ -5054,7 +5059,7 @@ static int pmcraid_resume(struct pci_dev
 		rc = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 
 	if (rc != 0) {
-		dev_err(&pdev->dev, "Failed to set PCI DMA mask\n");
+		dev_err(&pdev->dev, "resume: Failed to set PCI DMA mask\n");
 		goto disable_device;
 	}
 
@@ -5063,7 +5068,8 @@ static int pmcraid_resume(struct pci_dev
 	rc = pmcraid_register_interrupt_handler(pinstance);
 
 	if (rc) {
-		pmcraid_err("resume: couldn't register interrupt handlers\n");
+		dev_err(&pdev->dev,
+			"resume: couldn't register interrupt handlers\n");
 		rc = -ENODEV;
 		goto release_host;
 	}
@@ -5080,7 +5086,7 @@ static int pmcraid_resume(struct pci_dev
 	 * state.
 	 */
 	if (pmcraid_reset_bringup(pinstance)) {
-		pmcraid_err("couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA \n");
 		rc = -ENODEV;
 		goto release_tasklets;
 	}
@@ -5187,7 +5193,7 @@ static void pmcraid_init_res_table(struc
 	LIST_HEAD(old_res);
 
 	if (pinstance->cfg_table->flags & MICROCODE_UPDATE_REQUIRED)
-		dev_err(&pinstance->pdev->dev, "Require microcode download\n");
+		pmcraid_err("IOA requires microcode download\n");
 
 	/* resource list is protected by pinstance->resource_lock.
 	 * init_res_table can be called from probe (user-thread) or runtime
@@ -5224,8 +5230,7 @@ static void pmcraid_init_res_table(struc
 		if (!found) {
 
 			if (list_empty(&pinstance->free_res_q)) {
-				dev_err(&pinstance->pdev->dev,
-					"Too many devices attached\n");
+				pmcraid_err("Too many devices attached\n");
 				break;
 			}
 
@@ -5442,7 +5447,7 @@ static int __devinit pmcraid_probe(
 	rc = pmcraid_register_interrupt_handler(pinstance);
 
 	if (rc) {
-		pmcraid_err("couldn't register interrupt handler\n");
+		dev_err(&pdev->dev, "couldn't register interrupt handler\n");
 		goto out_scsi_host_put;
 	}
 
@@ -5466,7 +5471,7 @@ static int __devinit pmcraid_probe(
 	 */
 	pmcraid_info("starting IOA initialization sequence\n");
 	if (pmcraid_reset_bringup(pinstance)) {
-		pmcraid_err("couldn't initialize IOA \n");
+		dev_err(&pdev->dev, "couldn't initialize IOA \n");
 		rc = 1;
 		goto out_release_bufs;
 	}
@@ -5534,7 +5539,6 @@ static struct pci_driver pmcraid_driver
 	.shutdown = pmcraid_shutdown
 };
 
-
 /**
  * pmcraid_init - module load entry point
  */
@@ -5566,7 +5570,6 @@ static int __init pmcraid_init(void)
 		goto out_unreg_chrdev;
 	}
 
-
 	error = pmcraid_netlink_init();
 
 	if (error)
@@ -5584,6 +5587,7 @@ static int __init pmcraid_init(void)
 
 out_unreg_chrdev:
 	unregister_chrdev_region(MKDEV(pmcraid_major, 0), PMCRAID_MAX_ADAPTERS);
+
 out_init:
 	return error;
 }

