From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update dmx3191d to modern pci/scsi probing
Date: Sun, 29 Aug 2004 15:43:57 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040829134357.GA31541@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:48561 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267829AbUH2NoA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 09:44:00 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

thanks to  Mark Morschh\"auser for testing.


--- 1.17/drivers/scsi/dmx3191d.c	2004-08-25 01:42:28 +02:00
+++ edited/drivers/scsi/dmx3191d.c	2004-08-29 16:32:09 +02:00
@@ -1,7 +1,7 @@
-
 /*
-    dmx3191d.c - midlevel driver for the Domex DMX3191D SCSI card.
+    dmx3191d.c - driver for the Domex DMX3191D SCSI card.
     Copyright (C) 2000 by Massimo Piccioni <dafastidio@libero.it>
+    Portions Copyright (C) 2004 by Christoph Hellwig <hch@lst.de>
 
     Based on the generic NCR5380 driver by Drew Eckhardt et al.
 
@@ -20,118 +20,153 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <asm/io.h>
-#include <asm/system.h>
-#include <linux/blkdev.h>
 #include <linux/init.h>
 #include <linux/ioport.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/sched.h>
-#include <linux/signal.h>
-#include <linux/stat.h>
 #include <linux/interrupt.h>
-#include <linux/delay.h>
+#include <asm/io.h>
 
-#include "scsi.h"
 #include <scsi/scsi_host.h>
 
-#include "dmx3191d.h"
+/*
+ * Defintions for the generic 5380 driver.
+ */
+#define AUTOSENSE
+
+#define NCR5380_read(reg)		inb(port + reg)
+#define NCR5380_write(reg, value)	outb(value, port + reg)
+
+#define NCR5380_implementation_fields	unsigned int port
+#define NCR5380_local_declare()		NCR5380_implementation_fields
+#define NCR5380_setup(instance)		port = instance->io_port
 
-/* play with these values to tune up your system performances */
-/* default setting from g_NCR5380.c */
 /*
-#define USLEEP
-#define USLEEP_POLL		1
-#define USLEEP_SLEEP		20
-#define USLEEP_WAITLONG		500
-*/
+ * Includes needed for NCR5380.[ch] (XXX: Move them to NCR5380.h)
+ */
+#include <linux/delay.h>
+#include "scsi.h"
 
-#define AUTOSENSE
 #include "NCR5380.h"
 #include "NCR5380.c"
 
+#define DMX3191D_DRIVER_NAME	"dmx3191d"
+#define DMX3191D_REGION_LEN	8
+
 
-static int __init dmx3191d_detect(Scsi_Host_Template *tmpl) {
-	int boards = 0;
-	struct Scsi_Host *instance = NULL;
-	struct pci_dev *pdev = NULL;
-
-	tmpl->proc_name = DMX3191D_DRIVER_NAME;
-
-	while ((pdev = pci_find_device(PCI_VENDOR_ID_DOMEX,
-			PCI_DEVICE_ID_DOMEX_DMX3191D, pdev))) {
-
-		unsigned long port;
-		if (pci_enable_device(pdev))
-			continue;
-
-		port = pci_resource_start (pdev, 0);
-		
-		if (!request_region(port, DMX3191D_REGION, DMX3191D_DRIVER_NAME)) {
-			printk(KERN_ERR "dmx3191: region 0x%lx-0x%lx already reserved\n",
-				port, port + DMX3191D_REGION);
-			continue;
-		}
-
-		instance = scsi_register(tmpl, sizeof(struct NCR5380_hostdata));
-		if(instance == NULL)
-		{
-			release_region(port, DMX3191D_REGION);
-			continue;
-		}
-		scsi_set_device(instance, &pdev->dev);
-		instance->io_port = port;
-		instance->irq = pdev->irq;
-		NCR5380_init(instance, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
-
-		if (request_irq(pdev->irq, dmx3191d_intr, SA_SHIRQ,
-				DMX3191D_DRIVER_NAME, instance)) {
-			printk(KERN_WARNING "dmx3191: IRQ %d not available - switching to polled mode.\n", pdev->irq);
-			/* Steam powered scsi controllers run without an IRQ
-			   anyway */
-			instance->irq = SCSI_IRQ_NONE;
-		}
+static struct scsi_host_template dmx3191d_driver_template = {
+	.proc_name		= DMX3191D_DRIVER_NAME,
+	.name			= "Domex DMX3191D",
+	.queuecommand		= NCR5380_queue_command,
+	.eh_abort_handler	= NCR5380_abort,
+	.eh_bus_reset_handler	= NCR5380_bus_reset,
+	.eh_device_reset_handler= NCR5380_device_reset,
+	.eh_host_reset_handler	= NCR5380_host_reset,
+	.can_queue		= 32,
+	.this_id		= 7,
+	.sg_tablesize		= SG_ALL,
+	.cmd_per_lun		= 2,
+	.use_clustering		= DISABLE_CLUSTERING,
+};
 
-		boards++;
+static int __devinit dmx3191d_probe_one(struct pci_dev *pdev,
+		const struct pci_device_id *id)
+{
+	struct Scsi_Host *shost;
+	unsigned long io;
+	int error = -ENODEV;
+
+	if (pci_enable_device(pdev))
+		goto out;
+
+	io = pci_resource_start(pdev, 0);
+	if (!request_region(io, DMX3191D_REGION_LEN, DMX3191D_DRIVER_NAME)) {
+		printk(KERN_ERR "dmx3191: region 0x%lx-0x%lx already reserved\n",
+				io, io + DMX3191D_REGION_LEN);
+		goto out_disable_device;
 	}
-	return boards;
-}
 
-static const char * dmx3191d_info(struct Scsi_Host *host) {
-	static const char *info ="Domex DMX3191D";
+	shost = scsi_host_alloc(&dmx3191d_driver_template,
+			sizeof(struct NCR5380_hostdata));
+	if (!shost)
+		goto out_release_region;       
+	shost->io_port = io;
+	shost->irq = pdev->irq;
+
+	NCR5380_init(shost, FLAG_NO_PSEUDO_DMA | FLAG_DTC3181E);
+
+	if (request_irq(pdev->irq, NCR5380_intr, SA_SHIRQ,
+				DMX3191D_DRIVER_NAME, shost)) {
+		/*
+		 * Steam powered scsi controllers run without an IRQ anyway
+		 */
+		printk(KERN_WARNING "dmx3191: IRQ %d not available - "
+				    "switching to polled mode.\n", pdev->irq);
+		shost->irq = SCSI_IRQ_NONE;
+	}
+
+	pci_set_drvdata(pdev, shost);
+
+	error = scsi_add_host(shost, &pdev->dev);
+	if (error)
+		goto out_free_irq;
+
+	scsi_scan_host(shost);
+	return 0;
 
-	return info;
+ out_free_irq:
+	free_irq(shost->irq, shost);
+ out_release_region:
+	release_region(shost->io_port, DMX3191D_REGION_LEN);
+ out_disable_device:
+	pci_disable_device(pdev);
+ out:
+	return error;
 }
 
-static int dmx3191d_release_resources(struct Scsi_Host *instance)
+static void __devexit dmx3191d_remove_one(struct pci_dev *pdev)
 {
-	if(instance->irq!=SCSI_IRQ_NONE)
-		free_irq(instance->irq, instance);
-	NCR5380_exit(instance);
-	release_region(instance->io_port, DMX3191D_REGION);
+	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
-	return 0;
+	scsi_remove_host(shost);
+
+	NCR5380_exit(shost);
+
+	if (shost->irq != SCSI_IRQ_NONE)
+		free_irq(shost->irq, shost);
+	release_region(shost->io_port, DMX3191D_REGION_LEN);
+	pci_disable_device(pdev);
+
+	scsi_host_put(shost);
 }
 
-MODULE_LICENSE("GPL");
+static struct pci_device_id dmx3191d_pci_tbl[] = {
+	{PCI_VENDOR_ID_DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
+	{ }
+};
 
-static Scsi_Host_Template driver_template = {
-	.proc_info		= dmx3191d_proc_info,
-	.name			= "Domex DMX3191D",
-	.detect			= dmx3191d_detect,
-	.release		= dmx3191d_release_resources,
-	.info			= dmx3191d_info,
-	.queuecommand		= dmx3191d_queue_command,
-	.eh_abort_handler	= dmx3191d_abort,
-	.eh_bus_reset_handler	= dmx3191d_bus_reset,
-	.eh_device_reset_handler = dmx3191d_device_reset,
-	.eh_host_reset_handler	= dmx3191d_host_reset,
-	.can_queue		= 32,
-        .this_id		= 7,
-        .sg_tablesize		= SG_ALL,
-	.cmd_per_lun		= 2,
-        .use_clustering		= DISABLE_CLUSTERING,
+static struct pci_driver dmx3191d_pci_driver = {
+	.name		= DMX3191D_DRIVER_NAME,
+	.id_table	= dmx3191d_pci_tbl,
+	.probe		= dmx3191d_probe_one,
+	.remove		= __devexit_p(dmx3191d_remove_one),
 };
-#include "scsi_module.c"
 
+static int __init dmx3191d_init(void)
+{
+	return pci_module_init(&dmx3191d_pci_driver);
+}
+
+static void __exit dmx3191d_exit(void)
+{
+	pci_unregister_driver(&dmx3191d_pci_driver);
+}
+
+module_init(dmx3191d_init);
+module_exit(dmx3191d_exit);
+
+MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
+MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
+MODULE_LICENSE("GPL");
--- 1.7/drivers/scsi/dmx3191d.h	2003-05-12 17:01:09 +02:00
+++ edited/drivers/scsi/dmx3191d.h	2004-08-29 16:31:41 +02:00
@@ -1,48 +0,0 @@
-/*
-    dmx3191d.h - defines for the Domex DMX3191D SCSI card.
-    Copyright (C) 2000 by Massimo Piccioni <dafastidio@libero.it>
-
-    This program is free software; you can redistribute it and/or modify
-    it under the terms of the GNU General Public License as published by
-    the Free Software Foundation; either version 2 of the License, or
-    (at your option) any later version.
-*/
-
-#ifndef __DMX3191D_H
-#define __DMX3191D_H
-
-#define DMX3191D_DRIVER_NAME	"dmx3191d"
-#define DMX3191D_REGION		8
-
-#ifndef PCI_VENDOR_ID_DOMEX
-#define PCI_VENDOR_ID_DOMEX		0x134a
-#define PCI_DEVICE_ID_DOMEX_DMX3191D	0x0001
-#endif
-
-static int dmx3191d_abort(Scsi_Cmnd *);
-static int dmx3191d_detect(Scsi_Host_Template *);
-static const char* dmx3191d_info(struct Scsi_Host *);
-static int dmx3191d_queue_command(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
-static int dmx3191d_release_resources(struct Scsi_Host *);
-static int dmx3191d_bus_reset(Scsi_Cmnd *);
-static int dmx3191d_host_reset(Scsi_Cmnd *);
-static int dmx3191d_device_reset(Scsi_Cmnd *);
-
-#define NCR5380_read(reg)			inb(port + reg)
-#define NCR5380_write(reg, value)		outb(value, port + reg)
-
-#define NCR5380_implementation_fields		unsigned int port
-#define NCR5380_local_declare()			NCR5380_implementation_fields
-#define NCR5380_setup(instance)			port = instance->io_port
-
-#define NCR5380_abort				dmx3191d_abort
-#define do_NCR5380_intr				dmx3191d_do_intr
-#define NCR5380_intr				dmx3191d_intr
-#define NCR5380_proc_info			dmx3191d_proc_info
-#define NCR5380_queue_command			dmx3191d_queue_command
-#define NCR5380_host_reset			dmx3191d_host_reset
-#define NCR5380_bus_reset			dmx3191d_bus_reset
-#define NCR5380_device_reset			dmx3191d_device_reset
-
-#endif	/* __DMX3191D_H */
-
