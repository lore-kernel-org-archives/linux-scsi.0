From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] further sim710 updates
Date: Mon, 10 Feb 2003 08:59:20 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030210085920.A11560@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

James, your sim710 changes look nice, but I think there's some more
stuff to do in this driver.  I've started with the following (all
untested due to lack of the hardware):

  - move to scsi_add_host/scsi_remove_host interface
  - remove a bunch of unneeded ifdefs
  - add missing statics
  - unregister driver templates on unload

and I think there's more that should be done, but this would change
user-visiable attributes:

  - remove the ugly single module option code and the command line
    parsing in favour of Rusty's new module_param stuff
  - split the driver into two drivers: 53c700_eisa and 53c700_mca.
    There's no logic shared between those two busses, just a little
    bit of helper in the setup/remove code

And after looking a this driver I have some rants about the new
mac/eisa code:

  - mca_register_driver/mca_unregister_driver should check for
    the precense of an MCA bus by themselves instead of leaving
    it to the caller
  - eisa_driver_register should really return 0 for sucess
  - mca_register_driver/mca_unregister_driver should be named
    mca_driver_register/mca_driver_unregister to be more similar
    to the other *driver_(un)registers.


--- 1.8/drivers/scsi/sim710.c	Sun Feb  9 11:07:34 2003
+++ edited/drivers/scsi/sim710.c	Mon Feb 10 08:03:50 2003
@@ -32,51 +32,18 @@
 #include <linux/blk.h>
 #include <linux/device.h>
 #include <linux/init.h>
-#ifdef CONFIG_MCA
 #include <linux/mca.h>
-#endif
-#ifdef CONFIG_EISA
 #include <linux/eisa.h>
-#endif
 
 #include "scsi.h"
 #include "hosts.h"
 #include "53c700.h"
 
+
 /* Must be enough for both EISA and MCA */
 #define MAX_SLOTS 8
 static __u8 __initdata id_array[MAX_SLOTS] = { [0 ... MAX_SLOTS-1] = 7 };
 
-/* info is used to communicate global data across the driver register
- * because the struct device_driver doesn't have any info fields.  Sigh */
-struct sim710_info {
-	Scsi_Host_Template *tpnt;
-	int found;
-};
-
-static __initdata struct sim710_info sim710_global_info;
-
-#if defined(CONFIG_MCA)
-
-/* CARD ID 01BB and 01BA use the same pos values */
-
-#define MCA_01BB_IO_PORTS { 0x0000, 0x0000, 0x0800, 0x0C00, 0x1000, 0x1400, \
-			    0x1800, 0x1C00, 0x2000, 0x2400, 0x2800, \
-			    0x2C00, 0x3000, 0x3400, 0x3800, 0x3C00, \
-			    0x4000, 0x4400, 0x4800, 0x4C00, 0x5000  }
-
-#define MCA_01BB_IRQS { 3, 5, 11, 14 }
-
-/* CARD ID 004f */
-
-#define MCA_004F_IO_PORTS { 0x0000, 0x0200, 0x0300, 0x0400, 0x0500,  0x0600 }
-
-#define MCA_004F_IRQS { 5, 9, 14 }
-
-#endif
-
-#ifdef MODULE
-
 char *sim710;		/* command line passed by insmod */
 
 MODULE_AUTHOR("Richard Hirst");
@@ -85,8 +52,6 @@
 
 MODULE_PARM(sim710, "s");
 
-#endif
-
 #ifdef MODULE
 #define ARG_SEP ' '
 #else
@@ -118,12 +83,15 @@
 	}
 	return 1;
 }
-
-#ifndef MODULE
 __setup("sim710=", param_setup);
-#endif
 
-__init int
+static Scsi_Host_Template sim710_driver_template = {
+	.name			= "LSI (Symbios) 710 MCA/EISA",
+	.proc_name		= "sim710",
+	.this_id		= 7,
+};
+
+static __devinit int
 sim710_probe_common(struct device *dev, unsigned long base_addr,
 		    int irq, int clock, int differential, int scsi_id)
 {
@@ -154,7 +122,7 @@
 	hostdata->chip710 = 1;
 
 	/* and register the chip */
-	if((host = NCR_700_detect(sim710_global_info.tpnt, hostdata)) == NULL) {
+	if((host = NCR_700_detect(&sim710_driver_template, hostdata)) == NULL) {
 		printk(KERN_ERR "sim710: No host detected; card configuration problem?\n");
 		goto out_release;
 	}
@@ -168,11 +136,9 @@
 		goto out_unregister;
 	}
 
-	scsi_set_device(host, dev);
+	scsi_add_host(host, dev);
 	hostdata->dev = dev;
 
-	sim710_global_info.found++;
-
 	return 0;
 
  out_unregister:
@@ -185,10 +151,37 @@
 	return -ENODEV;
 }
 
+static __devexit int
+sim710_device_remove(struct device *dev)
+{
+	struct Scsi_Host *host = to_scsi_host(dev);
+	struct NCR_700_Host_Parameters *hostdata =
+		(struct NCR_700_Host_Parameters *)host->hostdata[0];
+
+	scsi_remove_host(host);
+	NCR_700_release(host);
+	kfree(hostdata);
+	free_irq(host->irq, host);
+	return 0;
+}
+
 #ifdef CONFIG_MCA
+
+/* CARD ID 01BB and 01BA use the same pos values */
+#define MCA_01BB_IO_PORTS { 0x0000, 0x0000, 0x0800, 0x0C00, 0x1000, 0x1400, \
+			    0x1800, 0x1C00, 0x2000, 0x2400, 0x2800, \
+			    0x2C00, 0x3000, 0x3400, 0x3800, 0x3C00, \
+			    0x4000, 0x4400, 0x4800, 0x4C00, 0x5000  }
+
+#define MCA_01BB_IRQS { 3, 5, 11, 14 }
+
+/* CARD ID 004f */
+#define MCA_004F_IO_PORTS { 0x0000, 0x0200, 0x0300, 0x0400, 0x0500,  0x0600 }
+#define MCA_004F_IRQS { 5, 9, 14 }
+
 static short sim710_mca_id_table[] = { 0x01bb, 0x01ba, 0x004f, 0};
 
-__init int
+static __init int
 sim710_mca_probe(struct device *dev)
 {
 	struct mca_device *mca_dev = to_mca_device(dev);
@@ -268,26 +261,27 @@
 				   0, id_array[slot]);
 }
 
-struct mca_driver sim710_mca_driver = {
-	.id_table = sim710_mca_id_table,
+static struct mca_driver sim710_mca_driver = {
+	.id_table		= sim710_mca_id_table,
 	.driver = {
-		.name = "sim710",
-		.bus = &mca_bus_type,
-		.probe = sim710_mca_probe,
+		.name		= "sim710",
+		.bus		= &mca_bus_type,
+		.probe		= sim710_mca_probe,
+		.remove		= __devexit_p(sim710_device_remove),
 	},
 };
 
 #endif /* CONFIG_MCA */
 
 #ifdef CONFIG_EISA
-struct eisa_device_id sim710_eisa_ids[] = {
+static struct eisa_device_id sim710_eisa_ids[] = {
 	{ "CPQ4410" },
 	{ "CPQ4411" },
 	{ "HWP0C80" },
 	{ "" }
 };
 
-__init int
+static __init int
 sim710_eisa_probe(struct device *dev)
 {
 	struct eisa_device *edev = to_eisa_device(dev);
@@ -322,36 +316,18 @@
 }
 
 struct eisa_driver sim710_eisa_driver = {
-	.id_table = sim710_eisa_ids,
+	.id_table		= sim710_eisa_ids,
 	.driver = {
-		.name =		"sim710",
-		.probe =	sim710_eisa_probe,
-		.remove =	__devexit_p(sim710_device_remove),
+		.name		= "sim710",
+		.probe		= sim710_eisa_probe,
+		.remove		= __devexit_p(sim710_device_remove),
 	},
 };
-
 #endif /* CONFIG_EISA */
 
-
-int
-sim710_release(struct Scsi_Host *host)
+static int __init sim710_init(void)
 {
-	struct D700_Host_Parameters *hostdata = 
-		(struct D700_Host_Parameters *)host->hostdata[0];
-
-	NCR_700_release(host);
-	kfree(hostdata);
-	free_irq(host->irq, host);
-	/* should do a refcount here and unregister the drivers when
-	 * it reaches zero */
-	return 1;
-}
-
-int __init
-sim710_detect(Scsi_Host_Template *tpnt)
-{
-	sim710_global_info.tpnt = tpnt;
-	sim710_global_info.found = 0;
+	int err = -ENODEV, err2;
 
 #ifdef MODULE
 	if (sim710)
@@ -359,22 +335,37 @@
 #endif
 
 #ifdef CONFIG_MCA
-	if(MCA_bus)
-		mca_register_driver(&sim710_mca_driver);
+	if (MCA_bus)
+		err = mca_register_driver(&sim710_mca_driver);
 #endif
 
 #ifdef CONFIG_EISA
-	eisa_driver_register(&sim710_eisa_driver);
+	err2 = eisa_driver_register(&sim710_eisa_driver);
+
+	/*
+	 * The eise_driver_register return values are strange.  I have
+	 * no idea why we don't just use river_register directly anyway..
+	 */
+	if (err2 == 1)
+		err2 = 0;	
 #endif
-	return sim710_global_info.found;
+
+	if (err < 0 || err2 < 0)
+		return (err < 0) ? err : err2;
+	return 0;
 }
 
-static Scsi_Host_Template driver_template = {
-	.name =			"LSI (Symbios) 710 MCA/EISA",
-	.proc_name =		"sim710",
-	.detect =		sim710_detect,
-	.release =		sim710_release,
-	.this_id =		7,
-};
+static void __exit sim710_exit(void)
+{
+#ifdef CONFIG_MCA
+	if (MCA_bus)
+		mca_unregister_driver(&sim710_mca_driver);
+#endif
+
+#ifdef CONFIG_EISA
+	eisa_driver_unregister(&sim710_eisa_driver);
+#endif
+}
 
-#include "scsi_module.c"
+module_init(sim710_init);
+module_exit(sim710_exit);
