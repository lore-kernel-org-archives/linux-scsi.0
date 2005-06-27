From: Christoph Hellwig <hch@lst.de>
Subject: [Call for testers] aic7xxx multifunction probing cleanup
Date: Mon, 27 Jun 2005 22:48:00 +0200
Message-ID: <20050627204759.GA20133@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:21894 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261732AbVF0UsF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 16:48:05 -0400
Received: from verein.lst.de (localhost [127.0.0.1])
	by mail.lst.de (8.12.3/8.12.3/Debian-7.1) with ESMTP id j5RKm06t020189
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jun 2005 22:48:00 +0200
Received: (from hch@localhost)
	by verein.lst.de (8.12.3/8.12.3/Debian-6.6) id j5RKm08F020187
	for linux-scsi@vger.kernel.org; Mon, 27 Jun 2005 22:48:00 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For multifunction aic7xxx the the secondary pci functions have to
inherit some flags from the primary one.  Currently aic7xxx does this
by means of an internal list we'd like to get rid of.  This patch uses
standard PCI layer calls instead, similar to the tg3 driver.

Anyone with an aic7xxx multifunction card willing to test this patch?


Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-17 19:31:14.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-19 13:52:07.000000000 +0200
@@ -153,6 +153,27 @@
 	ahc_free(ahc);
 }
 
+static void
+ahc_linux_pci_inherit_flags(struct ahc_softc *ahc)
+{
+	struct pci_dev *pdev = ahc->dev_softc, *master_pdev;
+	unsigned int master_devfn = PCI_DEVFN(PCI_SLOT(pdev->devfn), 0);
+
+	master_pdev = pci_get_slot(pdev->bus, master_devfn);
+	if (master_pdev) {
+		struct ahc_softc *master = pci_get_drvdata(master_pdev);
+		if (master) {
+			ahc->flags &= ~AHC_BIOS_ENABLED; 
+			ahc->flags |= (master->flags & AHC_BIOS_ENABLED);
+
+			ahc->flags &= ~AHC_PRIMARY_CHANNEL; 
+			ahc->flags |= (master->flags & AHC_PRIMARY_CHANNEL);
+		} else
+			printk(KERN_ERR "aic7xxx: no multichannel peer found!\n");
+		pci_dev_put(master_pdev);
+	} 
+}
+
 static int
 ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
@@ -207,6 +228,14 @@
 		ahc_free(ahc);
 		return (-error);
 	}
+
+	/*
+	 * Second Function PCI devices need to inherit some
+	 * settings from function 0.
+	 */
+	if ((ahc->features & AHC_MULTI_FUNC) && PCI_FUNC(pdev->devfn) != 0)
+		ahc_linux_pci_inherit_flags(ahc);
+
 	pci_set_drvdata(pdev, ahc);
 	if (aic7xxx_detect_complete)
 		ahc_linux_register_host(ahc, &aic7xxx_driver_template);
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-12 12:19:49.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_core.c	2005-06-17 19:34:23.000000000 +0200
@@ -3883,43 +3883,6 @@
 {
 	struct ahc_softc *list_ahc;
 
-#if AHC_PCI_CONFIG > 0
-	/*
-	 * Second Function PCI devices need to inherit some
-	 * settings from function 0.
-	 */
-	if ((ahc->chip & AHC_BUS_MASK) == AHC_PCI
-	 && (ahc->features & AHC_MULTI_FUNC) != 0) {
-		TAILQ_FOREACH(list_ahc, &ahc_tailq, links) {
-			ahc_dev_softc_t list_pci;
-			ahc_dev_softc_t pci;
-
-			list_pci = list_ahc->dev_softc;
-			pci = ahc->dev_softc;
-			if (ahc_get_pci_slot(list_pci) == ahc_get_pci_slot(pci)
-			 && ahc_get_pci_bus(list_pci) == ahc_get_pci_bus(pci)) {
-				struct ahc_softc *master;
-				struct ahc_softc *slave;
-
-				if (ahc_get_pci_function(list_pci) == 0) {
-					master = list_ahc;
-					slave = ahc;
-				} else {
-					master = ahc;
-					slave = list_ahc;
-				}
-				slave->flags &= ~AHC_BIOS_ENABLED; 
-				slave->flags |=
-				    master->flags & AHC_BIOS_ENABLED;
-				slave->flags &= ~AHC_PRIMARY_CHANNEL; 
-				slave->flags |=
-				    master->flags & AHC_PRIMARY_CHANNEL;
-				break;
-			}
-		}
-	}
-#endif
-
 	/*
 	 * Insertion sort into our list of softcs.
 	 */
