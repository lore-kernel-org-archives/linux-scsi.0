From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: sane pci probing
Date: Tue, 28 Jun 2005 16:49:44 +0200
Message-ID: <20050628144944.GA5130@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:37530 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S262004AbVF1Ots (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jun 2005 10:49:48 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

always probe in bus order, avoid any reordering


Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-17 19:31:14.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7770_osm.c	2005-06-28 14:29:20.000000000 +0200
@@ -102,8 +102,7 @@
 
  	dev_set_drvdata(dev, ahc);
 
-	if (aic7xxx_detect_complete)
-		error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
+	error = ahc_linux_register_host(ahc, &aic7xxx_driver_template);
 	return (error);
 }
 
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-28 14:15:21.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.c	2005-06-28 14:31:59.000000000 +0200
@@ -338,13 +338,6 @@
 uint32_t aic7xxx_allow_memio = ~0;
 
 /*
- * aic7xxx_detect() has been run, so register all device arrivals
- * immediately with the system rather than deferring to the sorted
- * attachment performed by aic7xxx_detect().
- */
-int aic7xxx_detect_complete;
-
-/*
  * So that we can set how long each device is given as a selection timeout.
  * The table of values goes like this:
  *   0 - 256ms
@@ -476,48 +469,6 @@
 }
 
 /*
- * Try to detect an Adaptec 7XXX controller.
- */
-static int
-ahc_linux_detect(struct scsi_host_template *template)
-{
-	struct	ahc_softc *ahc;
-	int     found = 0;
-
-	/*
-	 * If we've been passed any parameters, process them now.
-	 */
-	if (aic7xxx)
-		aic7xxx_setup(aic7xxx);
-
-	template->proc_name = "aic7xxx";
-
-	/*
-	 * Initialize our softc list lock prior to
-	 * probing for any adapters.
-	 */
-	ahc_list_lockinit();
-
-	found = ahc_linux_pci_init();
-	if (!ahc_linux_eisa_init())
-		found++;
-	
-	/*
-	 * Register with the SCSI layer all
-	 * controllers we've found.
-	 */
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-
-		if (ahc_linux_register_host(ahc, template) == 0)
-			found++;
-	}
-
-	aic7xxx_detect_complete++;
-
-	return (found);
-}
-
-/*
  * Return a string describing the driver.
  */
 static const char *
@@ -848,6 +799,7 @@
 struct scsi_host_template aic7xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic7xxx",
+	.proc_name		= "aic7xxx",
 	.proc_info		= ahc_linux_proc_info,
 	.info			= ahc_linux_info,
 	.queuecommand		= ahc_linux_queue,
@@ -2709,18 +2661,31 @@
 static int __init
 ahc_linux_init(void)
 {
-	ahc_linux_transport_template = spi_attach_transport(&ahc_linux_transport_functions);
+	/*
+	 * If we've been passed any parameters, process them now.
+	 */
+	if (aic7xxx)
+		aic7xxx_setup(aic7xxx);
+
+	ahc_linux_transport_template =
+		spi_attach_transport(&ahc_linux_transport_functions);
 	if (!ahc_linux_transport_template)
 		return -ENODEV;
+
 	scsi_transport_reserve_target(ahc_linux_transport_template,
 				      sizeof(struct ahc_linux_target));
 	scsi_transport_reserve_device(ahc_linux_transport_template,
 				      sizeof(struct ahc_linux_device));
-	if (ahc_linux_detect(&aic7xxx_driver_template))
-		return 0;
-	spi_release_transport(ahc_linux_transport_template);
-	ahc_linux_exit();
-	return -ENODEV;
+
+	/*
+	 * Initialize our softc list lock prior to
+	 * probing for any adapters.
+	 */
+	ahc_list_lockinit();
+
+	ahc_linux_pci_init();
+	ahc_linux_eisa_init();
+	return 0;
 }
 
 static void
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-17 19:31:14.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-06-28 14:29:42.000000000 +0200
@@ -132,7 +132,6 @@
 /************************* Configuration Data *********************************/
 extern u_int aic7xxx_no_probe;
 extern u_int aic7xxx_allow_memio;
-extern int aic7xxx_detect_complete;
 extern struct scsi_host_template aic7xxx_driver_template;
 
 /***************************** Bus Space/DMA **********************************/
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-28 14:28:01.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-28 14:29:29.000000000 +0200
@@ -237,8 +237,7 @@
 		ahc_linux_pci_inherit_flags(ahc);
 
 	pci_set_drvdata(pdev, ahc);
-	if (aic7xxx_detect_complete)
-		ahc_linux_register_host(ahc, &aic7xxx_driver_template);
+	ahc_linux_register_host(ahc, &aic7xxx_driver_template);
 	return (0);
 }
 
