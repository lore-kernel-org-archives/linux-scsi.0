From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from
Date: Mon, 21 Jun 2004 20:03:12 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621180312.GL1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:59779 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266357AbUFUSDK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:03:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 7F9F75C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:03:09 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 22325-06 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:03:09 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id C27045C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:03:08 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcT8S-0004Hk-9n
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:03:12 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_core.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~remove-old-ifdefs-aic79xx_core drivers/scsi/aic7xxx/aic79xx_core.c
--- linux-2.6.7/drivers/scsi/aic7xxx/aic79xx_core.c~remove-old-ifdefs-aic79xx_core	2004-06-18 09:13:42.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_core.c	2004-06-18 09:13:42.000000000 +0200
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
