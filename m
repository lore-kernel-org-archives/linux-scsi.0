From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic79xx_inline.h
Date: Mon, 21 Jun 2004 20:04:55 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621180455.GM1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:55945 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266359AbUFUSEx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:04:53 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id EC8935C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:04:52 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19600-08 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:04:52 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 278685C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:04:52 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTA7-0004Hs-Kf
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:04:55 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_inline.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_inline.h~remove-old-ifdefs-aic79xx_inline drivers/scsi/aic7xxx/aic79xx_inline.h
--- linux-2.6.7/drivers/scsi/aic7xxx/aic79xx_inline.h~remove-old-ifdefs-aic79xx_inline	2004-06-18 09:13:47.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx_inline.h	2004-06-18 09:13:47.000000000 +0200
@@ -231,7 +231,7 @@ ahd_unpause(struct ahd_softc *ahd)
 
 /*********************** Scatter Gather List Handling *************************/
 static __inline void	*ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
-				      void *sgptr, bus_addr_t addr,
+				      void *sgptr, dma_addr_t addr,
 				      bus_size_t len, int last);
 static __inline void	 ahd_setup_scb_common(struct ahd_softc *ahd,
 					      struct scb *scb);
@@ -242,10 +242,10 @@ static __inline void	 ahd_setup_noxfer_s
 
 static __inline void *
 ahd_sg_setup(struct ahd_softc *ahd, struct scb *scb,
-	     void *sgptr, bus_addr_t addr, bus_size_t len, int last)
+	     void *sgptr, dma_addr_t addr, bus_size_t len, int last)
 {
 	scb->sg_count++;
-	if (sizeof(bus_addr_t) > 4
+	if (sizeof(dma_addr_t) > 4
 	 && (ahd->flags & AHD_64BIT_ADDRESSING) != 0) {
 		struct ahd_dma64_seg *sg;
 
@@ -361,7 +361,7 @@ ahd_sg_size(struct ahd_softc *ahd)
 static __inline void *
 ahd_sg_bus_to_virt(struct ahd_softc *ahd, struct scb *scb, uint32_t sg_busaddr)
 {
-	bus_addr_t sg_offset;
+	dma_addr_t sg_offset;
 
 	/* sg_list_phys points to entry 1, not 0 */
 	sg_offset = sg_busaddr - (scb->sg_list_busaddr - ahd_sg_size(ahd));
@@ -371,7 +371,7 @@ ahd_sg_bus_to_virt(struct ahd_softc *ahd
 static __inline uint32_t
 ahd_sg_virt_to_bus(struct ahd_softc *ahd, struct scb *scb, void *sg)
 {
-	bus_addr_t sg_offset;
+	dma_addr_t sg_offset;
 
 	/* sg_list_phys points to entry 1, not 0 */
 	sg_offset = ((uint8_t *)sg - (uint8_t *)scb->sg_list)

_
