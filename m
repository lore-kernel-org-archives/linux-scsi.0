From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] [patch, 2.5] scsi_qla1280.c free on error path
Date: Mon, 06 Jan 2003 14:53:16 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030106041153.137002C2C9@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: jes@trained-monkey.org, linux-scsi@vger.kernel.org

[ Jes, is this OK? ]
From:  Marcus Alanen <maalanen@ra.abo.fi>

  Remove check_region in favour of request_region. Free resources 
  properly on error path. Horribly subtle ioremap/iounmap lurks here I 
  think, in qla1280_pci_config(), which the below patch should take care 
  of.
  
  I'm wondering if there couldn't / shouldn't be a better way to 
  allocate resources. Obviously lots of drivers have broken error paths.
  Is this even necessary?
  
  Marcus
  
  
  #
  # create_patch: qla1280_release_on_error_path-2002-12-08-A.patch
  # Date: Sun Dec  8 22:32:33 EET 2002
  #

--- trivial-2.5-bk/drivers/scsi/qla1280.c.orig	2003-01-06 14:10:52.000000000 +1100
+++ trivial-2.5-bk/drivers/scsi/qla1280.c	2003-01-06 14:10:52.000000000 +1100
@@ -866,19 +866,17 @@
 			"qla1280", ha)) {
 		printk("qla1280 : Failed to reserve interrupt %d already "
 		       "in use\n", host->irq);
-		goto error_mem_alloced;
+		goto error_unmap;
 	}
 #if !MEMORY_MAPPED_IO
 	/* Register the I/O space with Linux */
-	if (check_region(host->io_port, 0xff)) {
+	if (!request_region(host->io_port, 0xff, "qla1280")) {
 		printk("qla1280 : Failed to reserve i/o region 0x%04lx-0x%04lx"
 		       " already in use\n",
 		       host->io_port, host->io_port + 0xff);
-		free_irq(host->irq, ha);
-		goto error_mem_alloced;
+		goto error_irq;
 	}
 
-	request_region(host->io_port, 0xff, "qla1280");
 #endif
 
 	reg = ha->iobase;
@@ -886,7 +884,7 @@
 	/* load the F/W, read paramaters, and init the H/W */
 	if (qla1280_initialize_adapter(ha)) {
 		printk(KERN_INFO "qla1x160:Failed to initialize adapter\n");
-		goto error_mem_alloced;
+		goto error_region;
 	}
 
 	/* set our host ID  (need to do something about our two IDs) */
@@ -894,6 +892,21 @@
 
 	return host;
 
+ error_region:
+#if !MEMORY_MAPPED_IO
+	release_region(host->io_port, 0xff);
+#endif
+
+ error_irq:
+	free_irq(host->irq, ha);
+
+ error_unmap:
+#if MEMORY_MAPPED_IO
+	if (ha->mmpbase)
+		iounmap((void *)(((unsigned long) ha->mmpbase) & PAGE_MASK));
+#endif
+
+
  error_mem_alloced:
 	qla1280_mem_free(ha);
 
-- 
  Don't blame me: the Monkey is driving
  File: Marcus Alanen <maalanen@ra.abo.fi>: [patch, 2.5] scsi_qla1280.c free on error path
