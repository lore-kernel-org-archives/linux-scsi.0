From: janitor@sternwelten.at
Subject: [patch 02/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:46:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bzZ-000709-KC@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:50154 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267764AbUIAUqG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:46:06 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx_core.c |   14 ++++++------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~remove-old-ifdefs-aic79xx_core drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic79xx_core.c~remove-old-ifdefs-aic79xx_core	2004-08-31 17:41:16.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx_core.c	2004-08-31 17:41:16.000000000 +0200
@@ -5493,9 +5493,9 @@ ahd_probe_scbs(struct ahd_softc *ahd) {
 static void
 ahd_dmamap_cb(void *arg, bus_dma_segment_t *segs, int nseg, int error) 
 {
-	bus_addr_t *baddr;
+	dma_addr_t *baddr;
 
-	baddr = (bus_addr_t *)arg;
+	baddr = (dma_addr_t *)arg;
 	*baddr = segs->ds_addr;
 }
 
@@ -5926,9 +5926,9 @@ ahd_alloc_scbs(struct ahd_softc *ahd)
 	struct map_node *sense_map;
 	uint8_t		*segs;
 	uint8_t		*sense_data;
-	bus_addr_t	 hscb_busaddr;
-	bus_addr_t	 sg_busaddr;
-	bus_addr_t	 sense_busaddr;
+	dma_addr_t	 hscb_busaddr;
+	dma_addr_t	 sg_busaddr;
+	dma_addr_t	 sense_busaddr;
 	int		 newcount;
 	int		 i;
 
@@ -6161,7 +6161,7 @@ ahd_init(struct ahd_softc *ahd)
 {
 	uint8_t		*base_vaddr;
 	uint8_t		*next_vaddr;
-	bus_addr_t	 next_baddr;
+	dma_addr_t	 next_baddr;
 	size_t		 driver_data_size;
 	int		 i;
 	int		 error;
@@ -6205,7 +6205,7 @@ ahd_init(struct ahd_softc *ahd)
 	if (ahd_dma_tag_create(ahd, ahd->parent_dmat, /*alignment*/1,
 			       /*boundary*/BUS_SPACE_MAXADDR_32BIT + 1,
 			       /*lowaddr*/ahd->flags & AHD_39BIT_ADDRESSING
-					? (bus_addr_t)0x7FFFFFFFFFULL
+					? (dma_addr_t)0x7FFFFFFFFFULL
 					: BUS_SPACE_MAXADDR_32BIT,
 			       /*highaddr*/BUS_SPACE_MAXADDR,
 			       /*filter*/NULL, /*filterarg*/NULL,

_
