From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: remove unnecessary alignments of struct
 members
Date: Sun, 4 Feb 2007 13:04:32 +0100 (CET)
Message-ID: <tkrat.e82713a8340840b3@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
 <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
 <tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49866 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbXBDMEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2007 07:04:40 -0500
In-Reply-To: <tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

The members "dma_addr_t command_orb_dma" and "dma_addr_t sge_dma" of
sbp2.h::sbp2_command_info do not have to be aligned themselves --- only
the memory which they point to has to be.

The member "struct sbp2_command_orb command_orb" has to be aligned on
4 bytes boundary which is guaranteed because it contains u32 members.

The member "struct sbp2_unrestricted_page_table scatter_gather_element",
i.e. the SBP-2 s/g table, has to be aligned on 8 bytes boundary
according to the SBP-2 spec.  This is not a requirement for FireWire
controllers but could be expected by SBP-2 targets.

I see no need to align the members command_orb and
scatter_gather_element on CPU cacheline boundaries.  It could have
performance benefits, but on the other hand sbp2 has a somewhat wasteful
allocation scheme which should be optimized first before further tweaks
like cacheline alignments.  (E.g. don't always allocate SG_ALL s/g table
elements.)

Note, before as well as after the patch, the code relies on the
assumption that memory alignment in the virtual address space is
preserved in the physical address space after DMA mapping.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.20-rc5/drivers/ieee1394/sbp2.h
===================================================================
--- linux-2.6.20-rc5.orig/drivers/ieee1394/sbp2.h
+++ linux-2.6.20-rc5/drivers/ieee1394/sbp2.h
@@ -250,15 +250,15 @@ enum sbp2_dma_types {
 /* Per SCSI command */
 struct sbp2_command_info {
 	struct list_head list;
-	struct sbp2_command_orb command_orb ____cacheline_aligned;
-	dma_addr_t command_orb_dma ____cacheline_aligned;
+	struct sbp2_command_orb command_orb;
+	dma_addr_t command_orb_dma;
 	struct scsi_cmnd *Current_SCpnt;
 	void (*Current_done)(struct scsi_cmnd *);
 
 	/* Also need s/g structure for each sbp2 command */
 	struct sbp2_unrestricted_page_table
-			scatter_gather_element[SG_ALL] ____cacheline_aligned;
-	dma_addr_t sge_dma ____cacheline_aligned;
+		scatter_gather_element[SG_ALL] __attribute__((aligned(8)));
+	dma_addr_t sge_dma;
 	void *sge_buffer;
 	dma_addr_t cmd_dma;
 	enum sbp2_dma_types dma_type;


-- 
Stefan Richter
-=====-=-=== --=- --=--
http://arcgraph.de/sr/

