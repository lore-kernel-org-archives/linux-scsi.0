From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic7xxx_core.c
Date: Mon, 21 Jun 2004 20:15:09 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181509.GS1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:40623 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266375AbUFUSPI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:15:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 853835C077
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:15:07 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30589-02 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:15:06 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 8AEA35C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:15:06 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTK1-0004Is-S3
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:15:09 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_core.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~remove-old-ifdefs-aic7xxx_core drivers/scsi/aic7xxx/aic7xxx_core.c
--- linux-2.6.7/drivers/scsi/aic7xxx/aic7xxx_core.c~remove-old-ifdefs-aic7xxx_core	2004-06-18 09:14:21.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx_core.c	2004-06-18 09:14:21.000000000 +0200
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
