From: janitor@sternwelten.at
Subject: [patch 01/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:45:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bzT-0006zR-Pk@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:33411 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267751AbUIAUqB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:46:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~remove-old-ifdefs-aic79xx drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/aic79xx.h~remove-old-ifdefs-aic79xx	2004-08-31 17:41:07.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/aic79xx.h	2004-08-31 17:41:07.000000000 +0200
@@ -549,7 +549,7 @@ struct ahd_dma64_seg {
 
 struct map_node {
 	bus_dmamap_t		 dmamap;
-	bus_addr_t		 physaddr;
+	dma_addr_t		 physaddr;
 	uint8_t			*vaddr;
 	SLIST_ENTRY(map_node)	 links;
 };
@@ -626,8 +626,8 @@ struct scb {
 	struct map_node	 	 *sense_map;
 	void			 *sg_list;
 	uint8_t			 *sense_data;
-	bus_addr_t		  sg_list_busaddr;
-	bus_addr_t		  sense_busaddr;
+	dma_addr_t		  sg_list_busaddr;
+	dma_addr_t		  sense_busaddr;
 	u_int			  sg_count;/* How full ahd_dma_seg is */
 #define	AHD_MAX_LQ_CRC_ERRORS 5
 	u_int			  crc_retry_count;
@@ -1198,7 +1198,7 @@ struct ahd_softc {
 	bus_dma_tag_t		  parent_dmat;
 	bus_dma_tag_t		  shared_data_dmat;
 	bus_dmamap_t		  shared_data_dmamap;
-	bus_addr_t		  shared_data_busaddr;
+	dma_addr_t		  shared_data_busaddr;
 
 	/* Information saved through suspend/resume cycles */
 	struct ahd_suspend_state  suspend_state;

_
