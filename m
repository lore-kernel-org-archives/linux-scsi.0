From: janitor@sternwelten.at
Subject: [patch 09/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:46:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2c0B-000757-VG@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:8652 "EHLO baikonur.stro.at")
	by vger.kernel.org with ESMTP id S267839AbUIAUqs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2004 16:46:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~remove-old-ifdefs-aic7xxx_core drivers/scsi/aic7xxx/aic7xxx_core.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic7xxx_core.c~remove-old-ifdefs-aic7xxx_core	2004-08-31 17:41:40.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-08-31 17:41:40.000000000 +0200
@@ -4199,9 +4199,9 @@ ahc_probe_scbs(struct ahc_softc *ahc) {
 static void
 ahc_dmamap_cb(void *arg, bus_dma_segment_t *segs, int nseg, int error) 
 {
-	bus_addr_t *baddr;
+	dma_addr_t *baddr;
 
-	baddr = (bus_addr_t *)arg;
+	baddr = (dma_addr_t *)arg;
 	*baddr = segs->ds_addr;
 }
 
@@ -4456,7 +4456,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)
 	struct scb_data *scb_data;
 	struct scb *next_scb;
 	struct sg_map_node *sg_map;
-	bus_addr_t physaddr;
+	dma_addr_t physaddr;
 	struct ahc_dma_seg *segs;
 	int newcount;
 	int i;
@@ -4820,7 +4820,7 @@ ahc_init(struct ahc_softc *ahc)
 	if (ahc_dma_tag_create(ahc, ahc->parent_dmat, /*alignment*/1,
 			       /*boundary*/BUS_SPACE_MAXADDR_32BIT + 1,
 			       /*lowaddr*/ahc->flags & AHC_39BIT_ADDRESSING
-					? (bus_addr_t)0x7FFFFFFFFFULL
+					? (dma_addr_t)0x7FFFFFFFFFULL
 					: BUS_SPACE_MAXADDR_32BIT,
 			       /*highaddr*/BUS_SPACE_MAXADDR,
 			       /*filter*/NULL, /*filterarg*/NULL,

_
