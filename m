From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: do not check for duplicate pci ids
Date: Sat, 11 Jun 2005 00:15:31 +0200
Message-ID: <20050610221531.GC8706@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59059 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261281AbVFJWPj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Jun 2005 18:15:39 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

pci layer handles this just fine for us


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-03 16:52:59.000000000 +0200
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-06-03 17:03:42.000000000 +0200
@@ -164,22 +164,6 @@
 	char		*name;
 	int		 error;
 
-	/*
-	 * Some BIOSen report the same device multiple times.
-	 */
-	TAILQ_FOREACH(ahc, &ahc_tailq, links) {
-		struct pci_dev *probed_pdev;
-
-		probed_pdev = ahc->dev_softc;
-		if (probed_pdev->bus->number == pdev->bus->number
-		 && probed_pdev->devfn == pdev->devfn)
-			break;
-	}
-	if (ahc != NULL) {
-		/* Skip duplicate. */
-		return (-ENODEV);
-	}
-
 	pci = pdev;
 	entry = ahc_find_pci_device(pci);
 	if (entry == NULL)
