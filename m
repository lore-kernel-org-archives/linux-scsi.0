From: Eric Kerin <eric@bootseg.com>
Subject: [PATCH] 2.6.0 aic7xxx and aic79xx stale pci_device list entry
Date: Fri, 02 Jan 2004 15:50:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073076654.2048.19.camel@opiate>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxsf03.cluster1.charter.net ([209.225.28.203]:39949 "EHLO
	mxsf03.cluster1.charter.net") by vger.kernel.org with ESMTP
	id S265677AbUABUz3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Jan 2004 15:55:29 -0500
Received: from [10.254.1.30] (24.231.168.37.bay.mi.chartermi.net [24.231.168.37] (may be forged))
	by mxsf03.cluster1.charter.net (8.12.10/8.12.8) with ESMTP id i02KrGiN030763
	for <linux-scsi@vger.kernel.org>; Fri, 2 Jan 2004 15:53:16 -0500 (EST)
	(envelope-from eric@bootseg.com)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Loading the aic7xxx or aic79xx modules, on a machine that did not
contain the card, left a stale entry in the pci_device list.  This
caused an oops upon loading the next module that registered a
pci_device. 

The patches below will unregister the pci_device if it successfully
registers the device, but does not find any cards. 

Comments are appreciated.


Also, I created a bug in bugzilla.kernel.org for this (before I got in
the mood to fix it myself). What should I do about closing it out?
Attach the patch, or put "posted fix to linux-scsi mailing list"?


Eric Kerin



diff -puN aic7xxx_osm.c aic7xxx_osm.c.oopsfix
--- aic7xxx_osm.c	2004-01-02 03:56:32.606291000 -0500
+++ aic7xxx_osm.c.oopsfix	2004-01-02 03:53:15.236291000 -0500
@@ -844,7 +844,8 @@ ahc_linux_detect(Scsi_Host_Template *tem
 {
 	struct	ahc_softc *ahc;
 	int     found;
-
+	int	pci_reg_stat;
+	
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * It is a bug that the upper layer takes
@@ -891,8 +892,9 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	 */
 	ahc_list_lockinit();
 
+	pci_reg_stat = -1;
 #ifdef CONFIG_PCI
-	ahc_linux_pci_init();
+	pci_reg_stat = ahc_linux_pci_init();
 #endif
 
 #ifdef CONFIG_EISA
@@ -913,7 +915,24 @@ ahc_linux_detect(Scsi_Host_Template *tem
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic7xxx_detect_complete++;
-	return (found);
+	if(found){
+		return (found);
+	}
+
+	/*
+	 * Cleanup everything we registered, 
+	 * because we didn't find any cards.
+	 */
+	
+#ifdef CONFIG_PCI
+	if(pci_reg_stat == 0){
+		ahc_linux_pci_exit();
+	}
+#endif
+#ifdef CONFIG_EISA
+	ahc_linux_eisa_exit();
+#endif
+	return 0;
 }
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)

 



 
diff -puN aic79xx_osm.c aic79xx_osm.c.oopsfix
--- aic79xx_osm.c	2004-01-02 02:46:43.000000000 -0500
+++ aic79xx_osm.c.oopsfix	2004-01-02 03:54:43.846291000 -0500
@@ -856,7 +856,8 @@ ahd_linux_detect(Scsi_Host_Template *tem
 {
 	struct	ahd_softc *ahd;
 	int     found;
-
+	int	pci_reg_stat;
+	
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
 	/*
 	 * It is a bug that the upper layer takes
@@ -906,8 +907,9 @@ ahd_linux_detect(Scsi_Host_Template *tem
 	 */
 	ahd_list_lockinit();
 
+	pci_reg_stat = -1;
 #ifdef CONFIG_PCI
-	ahd_linux_pci_init();
+	pci_reg_stat = ahd_linux_pci_init();
 #endif
 
 	/*
@@ -924,7 +926,20 @@ ahd_linux_detect(Scsi_Host_Template *tem
 	spin_lock_irq(&io_request_lock);
 #endif
 	aic79xx_detect_complete++;
-	return (found);
+	if(found){
+		return (found);
+	}
+
+	/*
+	 * Cleanup everything we registered, 
+	 * because we didn't find any cards.
+	 */
+#ifdef CONFIG_PCI	
+	if(pci_reg_stat == 0){
+		ahd_linux_pci_exit();
+	}
+#endif	
+	return 0;
 }
 
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)


