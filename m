From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [4/6] - cleanup adapter uninit
Date: Thu, 21 Aug 2003 20:16:58 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101658.GE7570@twibble.org>
References: <20030821101348.GA7570@twibble.org> <20030821101434.GB7570@twibble.org> <20030821101525.GC7570@twibble.org> <20030821101619.GD7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:36242 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262568AbTHUKRC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:17:02 -0400
Content-Disposition: inline
In-Reply-To: <20030821101619.GD7570@twibble.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Clean up the initialization sequence for the adapter. Makes it easier
to follow.


diff -du -r a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c	2003-08-20 21:52:19.656479536 +1000
+++ b/drivers/scsi/dc395x.c	2003-08-20 21:51:14.171434776 +1000
@@ -5554,6 +5554,61 @@
 }
 
 
+/**
+ * adapter_uninit_chip - cleanly shut down the scsi controller chip,
+ * stopping all operations and disabling interrupt generation on the
+ * card.
+ *
+ * @acb: The adapter which we are to shutdown.
+ **/
+static
+void adapter_uninit_chip(struct AdapterCtlBlk *acb)
+{
+	/* disable interrupts */
+	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0);
+	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0);
+
+	/* reset the scsi bus */
+	if (acb->config & HCC_SCSI_RESET)
+		reset_scsi_bus(acb);
+
+	/* clear any pending interupt state */
+	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
+}
+
+
+
+/**
+ * adapter_uninit - Shut down the chip and release any resources that
+ * we had allocated. Once this returns the adapter should not be used
+ * anymore.
+ *
+ * @acb: The adapter which we are to un-initialize.
+ **/
+static
+void adapter_uninit(struct AdapterCtlBlk *acb)
+{
+	unsigned long flags;
+	DC395x_LOCK_IO(acb->scsi_host, flags);
+
+	/* remove timers */
+	if (timer_pending(&acb->waiting_timer))
+		del_timer(&acb->waiting_timer);
+	if (timer_pending(&acb->selto_timer))
+		del_timer(&acb->selto_timer);
+
+	adapter_uninit_chip(acb);
+	adapter_remove_and_free_all_devices(acb);
+	DC395x_UNLOCK_IO(acb->scsi_host, flags);
+
+	if (acb->irq_level)
+		free_irq(acb->irq_level, acb);
+	if (acb->io_port_base)
+		release_region(acb->io_port_base, acb->io_port_len);
+
+	adapter_sg_tables_free(acb);
+	free_tracebufs(acb);
+}
 
 
 /*
@@ -5714,65 +5769,6 @@
 }
 
 
-/**
- * chip_shutdown - cleanly shut down the scsi controller chip,
- * stopping all operations and disablig interrupt generation on the
- * card.
- *
- * @acb: The scsi adapter control block of the adapter to shut down.
- **/
-static
-void chip_shutdown(struct AdapterCtlBlk *acb)
-{
-	/* disable interrupt */
-	DC395x_write8(acb, TRM_S1040_DMA_INTEN, 0);
-	DC395x_write8(acb, TRM_S1040_SCSI_INTEN, 0);
-
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		del_timer(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		del_timer(&acb->selto_timer);
-
-	/* reset the scsi bus */
-	if (acb->config & HCC_SCSI_RESET)
-		reset_scsi_bus(acb);
-
-	/* clear any pending interupt state */
-	DC395x_read8(acb, TRM_S1040_SCSI_INTSTATUS);
-
-	/* release chip resources */
-#if debug_enabled(DBG_TRACE|DBG_TRACEALL)
-	free_tracebufs(acb);
-#endif
-	adapter_sg_tables_free(acb);
-}
-
-
-
-/**
- * host_release - shutdown device and release resources that were
- * allocate for it. Called once for each card as it is shutdown.
- *
- * @host: The adapter instance to shutdown.
- **/
-static
-void host_release(struct Scsi_Host *host)
-{
-	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)(host->hostdata);
-	unsigned long flags;
-
-	dprintkl(KERN_DEBUG, "DC395x release\n");
-
-	DC395x_LOCK_IO(acb->scsi_host, flags);
-	chip_shutdown(acb);
-	adapter_remove_and_free_all_devices(acb);
-
-	free_irq(host->irq, acb);
-	release_region(host->io_port, host->n_io_port);
-
-	DC395x_UNLOCK_IO(acb->scsi_host, flags);
-}
 
 
 /*
@@ -5868,15 +5864,15 @@
 	}
 
 	pci_set_master(dev);
-	pci_set_drvdata(dev, scsi_host);
 
 	/* get the scsi mid level to scan for new devices on the bus */
 	if (scsi_add_host(scsi_host, &dev->dev)) {
 		dprintkl(KERN_ERR, "scsi_add_host failed\n");
-                host_release(scsi_host);
+		adapter_uninit(acb);
                 scsi_host_put(scsi_host);
 		return -ENODEV;
 	}
+	pci_set_drvdata(dev, scsi_host);
 	scsi_scan_host(scsi_host);
         	
 	return 0;
@@ -5891,16 +5887,14 @@
  **/
 static void __devexit dc395x_remove_one(struct pci_dev *dev)
 {
-	struct Scsi_Host *host = pci_get_drvdata(dev);
+	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
+	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)(scsi_host->hostdata);
 
 	dprintkdbg(DBG_0, "Removing instance\n");
-	if (!host) {
-		dprintkl(KERN_ERR, "no host allocated\n");
-		return;
-	}
-	scsi_remove_host(host);
-	host_release(host);
-	scsi_host_put(host);
+
+	scsi_remove_host(scsi_host);
+	adapter_uninit(acb);
+	scsi_host_put(scsi_host);
 	pci_set_drvdata(dev, NULL);
 }
 

-- 
 Jamie Lenehan <lenehan@twibble.org>
