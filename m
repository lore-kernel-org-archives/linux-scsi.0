From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill remaining direct uses of scsi_register_host
Date: Wed, 28 May 2003 12:43:11 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030528104311.GA25986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:21188 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264659AbTE1K36 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 May 2003 06:29:58 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Together with a patch for the usb imaging drivers I just sent to
Greg this will allow us to get rid of scsi_register_host as exported
API, leaving it only for use of scsi_module.c.


diff -Nru a/drivers/scsi/arm/ecoscsi.c b/drivers/scsi/arm/ecoscsi.c
--- a/drivers/scsi/arm/ecoscsi.c	Tue May 27 14:52:55 2003
+++ b/drivers/scsi/arm/ecoscsi.c	Tue May 27 14:52:55 2003
@@ -21,26 +21,6 @@
  * 1+ (800) 334-5454
  */
 
-/*
- * Options :
- *
- * PARITY - enable parity checking.  Not supported.
- *
- * SCSI2 - enable support for SCSI-II tagged queueing.  Untested.
- *
- * USLEEP - enable support for devices that don't disconnect.  Untested.
- */
-
-/*
- * $Log: ecoscsi.c,v $
- * Revision 1.2  1998/03/08 05:49:47  davem
- * Merge to 2.1.89
- *
- * Revision 1.1  1998/02/23 02:45:24  davem
- * Merge to 2.1.88
- *
- */
-
 #include <linux/module.h>
 #include <linux/signal.h>
 #include <linux/sched.h>
@@ -94,71 +74,8 @@
  *
  */
 
-void ecoscsi_setup(char *str, int *ints) {
-}
-
-/*
- * Function : int ecoscsi_detect(Scsi_Host_Template * tpnt)
- *
- * Purpose : initializes ecoscsi NCR5380 driver based on the
- *	command line / compile time port and irq definitions.
- *
- * Inputs : tpnt - template for this SCSI adapter.
- *
- * Returns : 1 if a host adapter was found, 0 if not.
- *
- */
-
-int ecoscsi_detect(Scsi_Host_Template * tpnt)
-{
-	struct Scsi_Host *host;
-
-	tpnt->proc_name = "ecoscsi";
-
-	host = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
-	if (!host)
-		return 0;
-
-	host->io_port = 0x80ce8000;
-	host->n_io_port = 144;
-	host->irq = IRQ_NONE;
-
-	if ( !(request_region(host->io_port, host->n_io_port, "ecoscsi")) )
-		goto unregister_scsi;
-
-	ecoscsi_write (host, MODE_REG, 0x20);		/* Is it really SCSI? */
-	if (ecoscsi_read (host, MODE_REG) != 0x20) /* Write to a reg.    */
-		goto release_reg;
-
-	ecoscsi_write( host, MODE_REG, 0x00 );		/* it back.	      */
-	if (ecoscsi_read (host, MODE_REG) != 0x00)
-		goto release_reg;
-
-	NCR5380_init(host, 0);
-
-	printk("scsi%d: at port 0x%08lx irqs disabled", host->host_no, host->io_port);
-	printk(" options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
-		host->can_queue, host->cmd_per_lun, ECOSCSI_PUBLIC_RELEASE);
-	printk("\nscsi%d:", host->host_no);
-	NCR5380_print_options(host);
-	printk("\n");
-
-	return 1;
-
-release_reg:
-	release_region(host->io_port, host->n_io_port);
-unregister_scsi:
-	scsi_unregister(host);
-	return 0;
-}
-
-int ecoscsi_release (struct Scsi_Host *shpnt)
+void ecoscsi_setup(char *str, int *ints)
 {
-	if (shpnt->irq != IRQ_NONE)
-		free_irq (shpnt->irq, NULL);
-	if (shpnt->io_port)
-		release_region (shpnt->io_port, shpnt->n_io_port);
-	return 0;
 }
 
 const char * ecoscsi_info (struct Scsi_Host *spnt)
@@ -241,8 +158,7 @@
 static Scsi_Host_Template ecoscsi_template =  {
 	.module		= THIS_MODULE,
 	.name		= "Serial Port EcoSCSI NCR5380",
-	.detect		= ecoscsi_detect,
-	.release	= ecoscsi_release,
+	.proc_name	= "ecoscsi",
 	.info		= ecoscsi_info,
 	.queuecommand	= ecoscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
@@ -256,19 +172,60 @@
 	.use_clustering	= DISABLE_CLUSTERING
 };
 
+static struct Scsi_Host *host;
+
 static int __init ecoscsi_init(void)
 {
-	scsi_register_host(&ecoscsi_template);
-	if (ecoscsi_template.present)
+
+	host = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
+	if (!host)
 		return 0;
 
-	scsi_unregister_host(&ecoscsi_template);
+	host->io_port = 0x80ce8000;
+	host->n_io_port = 144;
+	host->irq = IRQ_NONE;
+
+	if (!(request_region(host->io_port, host->n_io_port, "ecoscsi")) )
+		goto unregister_scsi;
+
+	ecoscsi_write(host, MODE_REG, 0x20);		/* Is it really SCSI? */
+	if (ecoscsi_read(host, MODE_REG) != 0x20) /* Write to a reg.    */
+		goto release_reg;
+
+	ecoscsi_write(host, MODE_REG, 0x00 );		/* it back.	      */
+	if (ecoscsi_read(host, MODE_REG) != 0x00)
+		goto release_reg;
+
+	NCR5380_init(host, 0);
+
+	printk("scsi%d: at port 0x%08lx irqs disabled", host->host_no, host->io_port);
+	printk(" options CAN_QUEUE=%d CMD_PER_LUN=%d release=%d",
+		host->can_queue, host->cmd_per_lun, ECOSCSI_PUBLIC_RELEASE);
+	printk("\nscsi%d:", host->host_no);
+	NCR5380_print_options(host);
+	printk("\n");
+
+	scsi_add_host(host, NULL);
+	return 0;
+
+release_reg:
+	release_region(host->io_port, host->n_io_port);
+unregister_scsi:
+	scsi_unregister(host);
 	return -ENODEV;
 }
 
 static void __exit ecoscsi_exit(void)
 {
-	scsi_unregister_host(&ecoscsi_template);
+	scsi_remove_host(host);
+
+	if (shpnt->irq != IRQ_NONE)
+		free_irq(shpnt->irq, NULL);
+	if (shpnt->io_port)
+		release_region(shpnt->io_port, shpnt->n_io_port);
+
+	scsi_unregister(host);
+	return 0;
 }
 
 module_init(ecoscsi_init);
diff -Nru a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
--- a/drivers/scsi/nsp32.c	Tue May 27 14:52:55 2003
+++ b/drivers/scsi/nsp32.c	Tue May 27 14:52:55 2003
@@ -278,14 +278,12 @@
 /*
  * function declaration
  */
-static int nsp32_detect(Scsi_Host_Template *);
 static int nsp32_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
 static const char *nsp32_info(struct Scsi_Host *);
 static int nsp32_eh_abort(Scsi_Cmnd *);
 static int nsp32_eh_bus_reset(Scsi_Cmnd *);
 static int nsp32_eh_host_reset(Scsi_Cmnd *);
 static int nsp32_reset(Scsi_Cmnd *, unsigned int);
-static int nsp32_release(struct Scsi_Host *);
 static int nsp32_proc_info(struct Scsi_Host *, char *, char **, off_t, int, int);
 static int __devinit nsp32_probe(struct pci_dev *, const struct pci_device_id *);
 static void __devexit nsp32_remove(struct pci_dev *);
@@ -335,11 +333,10 @@
 /*
  * max_sectors is currently limited up to 128.
  */
-static Scsi_Host_Template driver_template = {
-	.proc_name =			"nsp32",
+static Scsi_Host_Template nsp32_template = {
 	.name =				"Workbit NinjaSCSI-32Bi/UDE",
+	.proc_name =			"nsp32",
 	.proc_info =			nsp32_proc_info,
-	.detect =			nsp32_detect,
 	.info =				nsp32_info,
 	.queuecommand =			nsp32_queuecommand,
 	.can_queue =			1,
@@ -352,12 +349,6 @@
 	.eh_device_reset_handler =	NULL,
 	.eh_bus_reset_handler =		nsp32_eh_bus_reset,
 	.eh_host_reset_handler =	nsp32_eh_host_reset,
-	.release =			nsp32_release,
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,2))
-	.use_new_eh_code =        	1,
-#else
-	/* .highmem_io =		1,	*/
-#endif
 };
 
 #include "nsp32_io.h"
@@ -1618,7 +1609,7 @@
  *	0x900-0xbff: (map same 0x800-0x8ff I/O port image repeatedly)
  *	0xc00-0xfff: CardBus status registers
  */
-static int nsp32_detect(Scsi_Host_Template *sht)
+static int nsp32_detect(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host;	/* registered host structure */
 	int ret;
@@ -1630,7 +1621,7 @@
 	/*
 	 * register this HBA as SCSI device
 	 */
-	host = scsi_register(sht, sizeof(nsp32_hw_data));
+	host = scsi_register(&nsp32_template, sizeof(nsp32_hw_data));
 	if (host == NULL) {
 		nsp32_msg (KERN_ERR, "failed to scsi register");
 		goto err;
@@ -1793,8 +1784,6 @@
 		 "NinjaSCSI-32Bi/UDE: irq %d, io 0x%lx+0x%x",
 		 host->irq, host->io_port, host->n_io_port);
 
-	sht->name = data->info_str;
-
 	/*
 	 * SCSI bus reset
 	 *
@@ -1832,7 +1821,9 @@
 		goto free_irq;
         }
 
-	return 1;
+	scsi_add_host(host, &pdev->dev);
+	pci_set_drvdata(pdev, host);
+	return 0;
 
  free_irq:
 	free_irq(host->irq, data);
@@ -1852,43 +1843,7 @@
 	scsi_unregister(host);
 
  err:
-	return 0;
-}
-
-static int nsp32_release(struct Scsi_Host *shpnt)
-{
-	nsp32_hw_data *data = (nsp32_hw_data *)shpnt->hostdata;
-
-	if (data->lunt_list) {
-		kfree(data->lunt_list);
-	}
-
-	if (data->autoparam) {
-		pci_free_consistent(data->Pci, AUTOPARAM_SIZE,
-					data->autoparam, data->apaddr);
-	}
-
-	if (data->sg_list) {
-		pci_free_consistent(data->Pci, 
-			(sizeof(struct nsp32_sgtable) * NSP_SG_SIZE * MAX_TARGET * MAX_LUN),
-			data->sg_list, data->sgaddr);
-	}
-
-	DEBUG(0, "free irq\n");
-	if (shpnt->irq) {
-		free_irq(shpnt->irq, data);
-	}
-
-	DEBUG(0, "free io\n");
-	if (shpnt->io_port && shpnt->n_io_port) {
-		release_region(shpnt->io_port, shpnt->n_io_port);
-	}
-
-	if (data->MmioAddress != 0) {
-		iounmap((void *)(data->MmioAddress));
-	}
-
-	return 0;
+	return 1;
 }
 
 static const char *nsp32_info(struct Scsi_Host *shpnt)
@@ -2031,11 +1986,7 @@
 
 	pci_set_master(pdev);
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
-	scsi_register_host(&driver_template);
-#else
-	scsi_register_module(MODULE_SCSI_HA, &driver_template);
-#endif
+	ret = nsp32_detect(pdev);
 
 	nsp32_msg(KERN_INFO, "nsp32 irq: %i mmio: 0x%lx slot: %s model: %s",
 		  pdev->irq, data->MmioAddress, pdev->slot_name,
@@ -2043,18 +1994,23 @@
 
 	nsp32_dbg(NSP32_DEBUG_REGISTER, "exit");
 
-	return 0;
+	return ret;
 }
 
 static void __devexit nsp32_remove(struct pci_dev *pdev)
 {
-	nsp32_dbg(NSP32_DEBUG_REGISTER, "enter");
-	
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,2))
-	scsi_unregister_host(&driver_template);
-#else
-	scsi_unregister_module(MODULE_SCSI_HA, &driver_template);
-#endif
+	struct Scsi_Host *shpnt = pci_get_drvdata(pdev);
+	nsp32_hw_data *data = (nsp32_hw_data *)shpnt->hostdata;
+
+	kfree(data->lunt_list);
+	pci_free_consistent(data->Pci, AUTOPARAM_SIZE,
+			data->autoparam, data->apaddr);
+	pci_free_consistent(data->Pci, 
+		(sizeof(struct nsp32_sgtable) * NSP_SG_SIZE*MAX_TARGET*MAX_LUN),
+		data->sg_list, data->sgaddr);
+	free_irq(shpnt->irq, data);
+	release_region(shpnt->io_port, shpnt->n_io_port);
+	iounmap((void *)(data->MmioAddress));
 }
 
 static struct pci_device_id nsp32_pci_table[] __devinitdata = {
