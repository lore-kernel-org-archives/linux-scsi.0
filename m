From: janitor@sternwelten.at
Subject: [patch 07/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:46:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2c01-00073h-0G@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:38096 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267825AbUIAUqk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:46:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx.h~remove-old-ifdefs-aic7xxx drivers/scsi/aic7xxx/aic7xxx.h
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic7xxx.h~remove-old-ifdefs-aic7xxx	2004-08-31 17:41:34.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic7xxx.h	2004-08-31 17:41:34.000000000 +0200
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
