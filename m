From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] aic79xx: use dma_get_required_mask()
Date: Wed, 07 Feb 2007 09:47:44 +0100
Message-ID: <45C99230.5020309@suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080400010606030705040409"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.suse.de ([195.135.220.2]:51661 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030205AbXBGIrt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 03:47:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>

This is a multi-part message in MIME format.
--------------080400010606030705040409
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Hi James,

this patch corrects the issue originally noted by Frederic Temporelli:
aic79xx uses the wrong logic to determine the addressing mode.
I've converted the original patch to use the dma_get_required_mask()
macros as you requested.

Please apply.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstraße 5				+49 911 74053 688
90409 Nürnberg				http://www.suse.de

--------------080400010606030705040409
Content-Type: text/plain;
 name="aic79xx-use-dma-required-mask"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="aic79xx-use-dma-required-mask"

aic79xx: Use dma_get_required_mask()

As originally noted by Frederic Temporelli, the aic79xx supports 64
bit addressing, but the initialization code of the driver is wrong: it
tests the available memory size instead of testing the maximum
available memory address.

This patch uses the correct dma_get_required_mask() macros to
determine the correct addressing method.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Cc: Xavier Bru <xavier.bru@bull.net>
CC: Frederic Temporelli <frederic.temporelli@bull.net>


diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 9bfcca5..c7fe478 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
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
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 3a67fc5..147c83c 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -496,8 +496,6 @@ ahd_insb(struct ahd_softc * ahd, long po
 int		ahd_linux_register_host(struct ahd_softc *,
 					struct scsi_host_template *);
 
-uint64_t	ahd_linux_get_memsize(void);
-
 /*************************** Pretty Printing **********************************/
 struct info_str {
 	char *buffer;
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 1a3ab6a..22250e6 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -127,11 +127,13 @@ static int
 ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	char		 buf[80];
+	const uint64_t	 mask_39bit = 0x7FFFFFFFFFULL;
 	struct		 ahd_softc *ahd;
 	ahd_dev_softc_t	 pci;
 	struct		 ahd_pci_identity *entry;
 	char		*name;
 	int		 error;
+	struct device	*dev = &pdev->dev;
 
 	pci = pdev;
 	entry = ahd_find_pci_device(pci);
@@ -161,20 +163,17 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 	pci_set_master(pdev);
 
 	if (sizeof(dma_addr_t) > 4) {
-		uint64_t   memsize;
-		const uint64_t mask_39bit = 0x7FFFFFFFFFULL;
-
-		memsize = ahd_linux_get_memsize();
-
-		if (memsize >= 0x8000000000ULL
-	 	 && pci_set_dma_mask(pdev, DMA_64BIT_MASK) == 0) {
+		if (dma_set_mask(dev, DMA_64BIT_MASK)
+		    && dma_get_required_mask(dev) > mask_39bit)
 			ahd->flags |= AHD_64BIT_ADDRESSING;
-		} else if (memsize > 0x80000000
-			&& pci_set_dma_mask(pdev, mask_39bit) == 0) {
+		else if (dma_set_mask(dev, mask_39bit) == 0
+			 && dma_get_required_mask(dev) > DMA_32BIT_MASK)
 			ahd->flags |= AHD_39BIT_ADDRESSING;
-		}
+		else
+			dma_set_mask(dev, DMA_32BIT_MASK);
+			
 	} else {
-		pci_set_dma_mask(pdev, DMA_32BIT_MASK);
+		dma_set_mask(dev, DMA_32BIT_MASK);
 	}
 	ahd->dev_softc = pci;
 	error = ahd_pci_config(ahd, entry);

--------------080400010606030705040409--
