From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic7xxx.h
Date: Mon, 21 Jun 2004 20:13:52 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181352.GR1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:43680 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266372AbUFUSNv
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:13:51 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 01B4C5C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:13:51 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 30589-01 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:13:49 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 26F5C5C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:13:49 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTIm-0004Il-Ml
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:13:52 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx.h~remove-old-ifdefs-aic7xxx drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6.7/drivers/scsi/aic7xxx/aic7xxx.h~remove-old-ifdefs-aic7xxx	2004-06-18 09:14:09.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic7xxx.h	2004-06-18 09:14:09.000000000 +0200
@@ -521,7 +521,7 @@ struct ahc_dma_seg {
 
 struct sg_map_node {
 	bus_dmamap_t		 sg_dmamap;
-	bus_addr_t		 sg_physaddr;
+	dma_addr_t		 sg_physaddr;
 	struct ahc_dma_seg*	 sg_vaddr;
 	SLIST_ENTRY(sg_map_node) links;
 };
@@ -584,7 +584,7 @@ struct scb {
 	struct scb_platform_data *platform_data;
 	struct sg_map_node	 *sg_map;
 	struct ahc_dma_seg 	 *sg_list;
-	bus_addr_t		  sg_list_phys;
+	dma_addr_t		  sg_list_phys;
 	u_int			  sg_count;/* How full ahc_dma_seg is */
 };
 
@@ -611,10 +611,10 @@ struct scb_data {
 	 */
 	bus_dma_tag_t	 hscb_dmat;	/* dmat for our hardware SCB array */
 	bus_dmamap_t	 hscb_dmamap;
-	bus_addr_t	 hscb_busaddr;
+	dma_addr_t	 hscb_busaddr;
 	bus_dma_tag_t	 sense_dmat;
 	bus_dmamap_t	 sense_dmamap;
-	bus_addr_t	 sense_busaddr;
+	dma_addr_t	 sense_busaddr;
 	bus_dma_tag_t	 sg_dmat;	/* dmat for our sg segments */
 	SLIST_HEAD(, sg_map_node) sg_maps;
 	uint8_t	numscbs;
@@ -1069,14 +1069,14 @@ struct ahc_softc {
 	bus_dma_tag_t		  parent_dmat;
 	bus_dma_tag_t		  shared_data_dmat;
 	bus_dmamap_t		  shared_data_dmamap;
-	bus_addr_t		  shared_data_busaddr;
+	dma_addr_t		  shared_data_busaddr;
 
 	/*
 	 * Bus address of the one byte buffer used to
 	 * work-around a DMA bug for chips <= aic7880
 	 * in target mode.
 	 */
-	bus_addr_t		  dma_bug_buf;
+	dma_addr_t		  dma_bug_buf;
 
 	/* Number of enabled target mode device on this card */
 	u_int			  enabled_luns;

_
