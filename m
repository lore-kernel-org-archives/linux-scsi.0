From: James Bottomley <James.Bottomley@steeleye.com>
Subject: [PATCH] fix aic7xxx probing
Date: 24 Jun 2004 17:49:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088117341.2174.67.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:51347 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265811AbUFXWtB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 18:49:01 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i5OMmwi01522
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2004 18:48:58 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

It looks like there's still a problem with the probing:

ahc_linux_pci_init() returns the number of boards attached
ahc_linux_eisa_init() returns 0 on success or error

The only reason the current code actually works on PCI seems to be that
it's already attached the devices by the time it returns what the
ahc_linux_detect() assumes to be a failure code.

James

===== drivers/scsi/aic7xxx/aic7xxx_osm.c 1.54 vs edited =====
--- 1.54/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-04-26 02:09:37 -04:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.c	2004-06-24 18:39:54 -04:00
@@ -842,9 +842,7 @@
 static int
 ahc_linux_detect(Scsi_Host_Template *template)
 {
-	struct	ahc_softc *ahc;
 	int     found = 0;
-	int	eisa_err, pci_err;
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
@@ -892,13 +890,11 @@
 	 */
 	ahc_list_lockinit();
 
-	pci_err = ahc_linux_pci_init();
-	eisa_err = ahc_linux_eisa_init();
-
-	if(pci_err && eisa_err)
-		goto out;
-
-
+	found = ahc_linux_pci_init();
+	if (!ahc_linux_eisa_init())
+		found++;
+	
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * Register with the SCSI layer all
 	 * controllers we've found.
@@ -908,9 +904,7 @@
 		if (ahc_linux_register_host(ahc, template) == 0)
 			found++;
 	}
-out:
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic7xxx_detect_complete++;
===== drivers/scsi/aic7xxx/aic7xxx_osm.h 1.54 vs edited =====
--- 1.54/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-05-12 11:46:27 -04:00
+++ edited/drivers/scsi/aic7xxx/aic7xxx_osm.h	2004-06-24 18:41:49 -04:00
@@ -940,7 +940,7 @@
 }
 #else
 static inline int ahc_linux_pci_init(void) {
-	return -ENODEV;
+	return 0;
 }
 static inline void ahc_linux_pci_exit(void) {
 }

