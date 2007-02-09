From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic79xx: use dma_get_required_mask()
Date: Fri, 09 Feb 2007 10:55:39 -0500
Message-ID: <1171036539.3627.15.camel@mulgrave.il.steeleye.com>
References: <45C99230.5020309@suse.de> <20070208194024.GB2354@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33210 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946552AbXBIPzz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 10:55:55 -0500
In-Reply-To: <20070208194024.GB2354@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

On Thu, 2007-02-08 at 19:40 +0000, Christoph Hellwig wrote:
> The logic here seems odd to me.  Shouldn't we first check
> dma_get_required_mask and the do dma_set_mask?

Yes ... I picked up the mask problem, but not that.  And actually
there's a missing zero check on one of the dma_set_mask()s.

Does this look like the right patch then?

James

>From 095ec6c45d80171b31ee04da62618dcad31b8aef Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Wed, 7 Feb 2007 09:47:44 +0100
Subject: [SCSI] aic79xx: use dma_get_required_mask()

As originally noted by Frederic Temporelli, the aic79xx supports 64
bit addressing, but the initialization code of the driver is wrong: it
tests the available memory size instead of testing the maximum
available memory address.

This patch uses the correct dma_get_required_mask() macros to
determine the correct addressing method.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Xavier Bru <xavier.bru@bull.net>
CC: Frederic Temporelli <frederic.temporelli@bull.net>

cosmetic fixes
Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c     |    9 ---------
 drivers/scsi/aic7xxx/aic79xx_osm.h     |    2 --
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |   20 +++++++++-----------
 3 files changed, 9 insertions(+), 22 deletions(-)

Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-02-09 09:12:55.000000000 -0500
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.c	2007-02-09 09:17:36.000000000 -0500
@@ -1126,15 +1126,6 @@ ahd_linux_register_host(struct ahd_softc
 	return 0;
 }
 
-uint64_t
-ahd_linux_get_memsize(void)
-{
-	struct sysinfo si;
-
-	si_meminfo(&si);
-	return ((uint64_t)si.totalram << PAGE_SHIFT);
-}
-
 /*
  * Place the SCSI bus into a known state by either resetting it,
  * or forcing transfer negotiations on the next command to any
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm.h	2007-02-09 09:12:55.000000000 -0500
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm.h	2007-02-09 09:17:36.000000000 -0500
@@ -496,8 +496,6 @@ ahd_insb(struct ahd_softc * ahd, long po
 int		ahd_linux_register_host(struct ahd_softc *,
 					struct scsi_host_template *);
 
-uint64_t	ahd_linux_get_memsize(void);
-
 /*************************** Pretty Printing **********************************/
 struct info_str {
 	char *buffer;
Index: scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-02-09 09:12:55.000000000 -0500
+++ scsi-misc-2.6/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2007-02-09 09:21:32.000000000 -0500
@@ -132,6 +132,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	struct		 ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
+	struct device	*dev = &pdev->dev;
 
 	pci = pdev;
 	entry = ahd_find_pci_device(pci);
@@ -161,20 +162,16 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > 4) {
-		uint64_t   memsize;
-		const uint64_t mask_39bit = 0x7FFFFFFFFFULL;
-
-		memsize = ahd_linux_get_memsize();
-
-		if (memsize >= 0x8000000000ULL
-	 	 && pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
+		if (dma_get_required_mask(dev) > DMA_39BIT_MASK
+		    && dma_set_mask(dev, DMA_64BIT_MASK) == 0)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-		} else if (memsize > 0x80000000
-			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
+		else if (dma_get_required_mask(dev) > DMA_32BIT_MASK
+			 && dma_set_mask(dev, DMA_39BIT_MASK) == 0)
 			ahd->flags |= AHD_39BIT_ADDRESSING;
-		}
+		else
+			dma_set_mask(dev, DMA_32BIT_MASK);
 	} else {
-		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		dma_set_mask(dev, DMA_32BIT_MASK);
 	}
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);


