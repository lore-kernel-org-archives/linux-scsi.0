From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from aic79xx.h
Date: Mon, 21 Jun 2004 20:01:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621180141.GK1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:61391 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266359AbUFUSBj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:01:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 0B1B85C0A4
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:01:39 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 19600-05 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:01:38 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 43F615C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:01:38 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcT6z-0004AN-QE
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:01:41 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org



 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 remove unused #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~remove-old-ifdefs-aic79xx drivers/scsi/aic7xxx/aic79xx.h
--- linux-2.6.7/drivers/scsi/aic7xxx/aic79xx.h~remove-old-ifdefs-aic79xx	2004-06-18 09:13:35.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/aic79xx.h	2004-06-18 09:13:35.000000000 +0200
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
