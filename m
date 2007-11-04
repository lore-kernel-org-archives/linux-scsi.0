From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 3/3] ieee1394: sbp2: s/g list access cosmetics
Date: Sun, 4 Nov 2007 14:59:24 +0100 (CET)
Message-ID: <tkrat.29809d64b9426d9a@s5r6.in-berlin.de>
References: <64bb37e0711021503x4844b905yba1e9a681c4e788a@mail.gmail.com>
 <472BA567.8040301@s5r6.in-berlin.de>
 <64bb37e0711030614q4be3a2b6j5d3c55b26cb07030@mail.gmail.com>
 <472C88E9.60103@s5r6.in-berlin.de> <20071103160404.GH28340@kernel.dk>
 <20071104084456.GJ28340@kernel.dk>
 <64bb37e0711040251w4d08ac83n1e090a8fab19d3d8@mail.gmail.com>
 <20071104130315.GL28340@kernel.dk> <472DC6DE.6050402@s5r6.in-berlin.de>
 <20071104132621.GM28340@kernel.dk>
 <tkrat.4947ae1f5baa964f@s5r6.in-berlin.de>
 <tkrat.2a470664250af864@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45642 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356AbXKDN7j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 08:59:39 -0500
In-Reply-To: <tkrat.2a470664250af864@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>

Replace sg->length by sg_dma_len(sg).  Rename a variable for shorter
line lengths and eliminate some superfluous local variables.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -1451,7 +1451,7 @@ static void sbp2_prep_command_orb_sg(str
 				     struct sbp2_fwhost_info *hi,
 				     struct sbp2_command_info *cmd,
 				     unsigned int scsi_use_sg,
-				     struct scatterlist *sgpnt,
+				     struct scatterlist *sg,
 				     u32 orb_direction,
 				     enum dma_data_direction dma_dir)
 {
@@ -1461,12 +1461,12 @@ static void sbp2_prep_command_orb_sg(str
 
 	/* special case if only one element (and less than 64KB in size) */
 	if ((scsi_use_sg == 1) &&
-	    (sgpnt[0].length <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
+	    (sg_dma_len(sg) <= SBP2_MAX_SG_ELEMENT_LENGTH)) {
 
-		cmd->dma_size = sgpnt[0].length;
+		cmd->dma_size = sg_dma_len(sg);
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
-					    sg_page(&sgpnt[0]), sgpnt[0].offset,
+					    sg_page(sg), sg->offset,
 					    cmd->dma_size, cmd->dma_dir);
 
 		orb->data_descriptor_lo = cmd->cmd_dma;
@@ -1477,11 +1477,11 @@ static void sbp2_prep_command_orb_sg(str
 						&cmd->scatter_gather_element[0];
 		u32 sg_count, sg_len;
 		dma_addr_t sg_addr;
-		int i, count = dma_map_sg(hi->host->device.parent, sgpnt,
+		int i, count = dma_map_sg(hi->host->device.parent, sg,
 					  scsi_use_sg, dma_dir);
 
 		cmd->dma_size = scsi_use_sg;
-		cmd->sge_buffer = sgpnt;
+		cmd->sge_buffer = sg;
 
 		/* use page tables (s/g) */
 		orb->misc |= ORB_SET_PAGE_TABLE_PRESENT(0x1);
@@ -1489,9 +1489,9 @@ static void sbp2_prep_command_orb_sg(str
 
 		/* loop through and fill out our SBP-2 page tables
 		 * (and split up anything too large) */
-		for (i = 0, sg_count = 0; i < count; i++, sgpnt = sg_next(sgpnt)) {
-			sg_len = sg_dma_len(sgpnt);
-			sg_addr = sg_dma_address(sgpnt);
+		for (i = 0, sg_count = 0; i < count; i++, sg = sg_next(sg)) {
+			sg_len = sg_dma_len(sg);
+			sg_addr = sg_dma_address(sg);
 			while (sg_len) {
 				sg_element[sg_count].segment_base_lo = sg_addr;
 				if (sg_len > SBP2_MAX_SG_ELEMENT_LENGTH) {
@@ -1521,11 +1521,10 @@ static void sbp2_create_command_orb(stru
 				    unchar *scsi_cmd,
 				    unsigned int scsi_use_sg,
 				    unsigned int scsi_request_bufflen,
-				    void *scsi_request_buffer,
+				    struct scatterlist *sg,
 				    enum dma_data_direction dma_dir)
 {
 	struct sbp2_fwhost_info *hi = lu->hi;
-	struct scatterlist *sgpnt = (struct scatterlist *)scsi_request_buffer;
 	struct sbp2_command_orb *orb = &cmd->command_orb;
 	u32 orb_direction;
 
@@ -1560,7 +1559,7 @@ static void sbp2_create_command_orb(stru
 		orb->data_descriptor_lo = 0x0;
 		orb->misc |= ORB_SET_DIRECTION(1);
 	} else
-		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sgpnt,
+		sbp2_prep_command_orb_sg(orb, hi, cmd, scsi_use_sg, sg,
 					 orb_direction, dma_dir);
 
 	sbp2util_cpu_to_be32_buffer(orb, sizeof(*orb));
@@ -1650,7 +1649,6 @@ static int sbp2_send_command(struct sbp2
 			     void (*done)(struct scsi_cmnd *))
 {
 	unchar *scsi_cmd = (unchar *)SCpnt->cmnd;
-	unsigned int request_bufflen = scsi_bufflen(SCpnt);
 	struct sbp2_command_info *cmd;
 
 	cmd = sbp2util_allocate_command_orb(lu, SCpnt, done);
@@ -1658,7 +1656,7 @@ static int sbp2_send_command(struct sbp2
 		return -EIO;
 
 	sbp2_create_command_orb(lu, cmd, scsi_cmd, scsi_sg_count(SCpnt),
-				request_bufflen, scsi_sglist(SCpnt),
+				scsi_bufflen(SCpnt), scsi_sglist(SCpnt),
 				SCpnt->sc_data_direction);
 	sbp2_link_orb_command(lu, cmd);
 

-- 
Stefan Richter
-=====-=-=== =-== --=--
http://arcgraph.de/sr/

