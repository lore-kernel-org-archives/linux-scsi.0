From: Matt Domsch <Matt_Domsch@dell.com>
Subject: [PATCH 2.4.30-pre3] scsi_mod: add max_dma_memory and use_zone_normal params
Date: Fri, 18 Mar 2005 13:18:33 -0600
Message-ID: <20050318191833.GA22530@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:26659 "EHLO
	ausc60ps301.us.dell.com") by vger.kernel.org with ESMTP
	id S261922AbVCRTSe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2005 14:18:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

For review and comment.
Patch adds two new module parameters to scsi_mod:

max_dma_memory=, maximum DMA pool size, in MB (default=32 -> 32MB)
makes the hard-coded limit for the DMA pool size be adjustable.  This

Signed-off-by: Matt Domsch <Matt_Domsch@dell.com>
is necessary for systems with large numbers of disks seen (i.e. ~112
LUNs on a SAN as seen by a FC controller), where the size of the
scsi_malloc() pool would consume all of ZONE_DMA, leaving none for
other users.  This lets a system admin set a limit on how much memory
to use for the scsi_malloc() pool.  If set too low, fewer outstanding
commands can be issued at once, so it's only a performance issue.

use_zone_normal=, 1 if scsi_malloc() can safely use ZONE_NORMAL
instead of ZONE_DMA By default, scsi_malloc() uses ZONE_DMA memory.
On x86 and x86_64, ZONE_DMA is only 16MB, though if you've got a lot
of disks, it could try to consume all of that.  This lets
scsi_malloc() use ZONE_NORMAL instead of ZONE_DMA, which of course is
only safe if all your SCSI controllers are 64-bit-address-capable
(most high-end cards today are).  This flag lets you have lots more
memory available to scsi_malloc() than would be available if it were
forced to use only ZONE_DMA, and frees up the space it would otherwise
have consumed from ZONE_DMA for other users.

Tested lightly on x86_64 on EM64T systems with 8GB RAM and up to 112
LUNs visible (14x8 paths, 28x4 paths, ...)

Thanks,
Matt


-- 
Matt Domsch
Software Architect
Dell Linux Solutions linux.dell.com & www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com

===== drivers/scsi/scsi_dma.c 1.2 vs edited =====
--- 1.2/drivers/scsi/scsi_dma.c	2002-02-05 08:10:27 -06:00
+++ edited/drivers/scsi/scsi_dma.c	2005-03-18 11:31:11 -06:00
@@ -46,6 +46,29 @@ unsigned int scsi_dma_free_sectors = 0;
 unsigned int scsi_need_isa_buffer = 0;
 static unsigned char **dma_malloc_pages = NULL;
 
+static unsigned int max_dma_memory = 32; /* 32MB */
+MODULE_PARM(max_dma_memory, "l");
+MODULE_PARM_DESC(max_dma_memory, "maximum DMA pool size, in MB (default=32 -> 32MB)");
+
+
+/* This flag is unsafe under these conditions:
+ * - you've got a <64-bit addressable SCSI controller, >4GB RAM, and an architecture where ZONE_NORMAL
+ *   extends above 4GB (any 64-bit architecture)
+ * or
+ * - you've got an old ISA card with host->unchecked_isa_dma=1
+ *
+ * This implies that it is really safe only with 64-bit addressable SCSI controllers
+ */
+static unsigned int use_zone_normal;
+MODULE_PARM(use_zone_normal, "i");
+MODULE_PARM_DESC(use_zone_normal, "1 if scsi_malloc() can safely use ZONE_NORMAL instead of ZONE_DMA");
+
+static inline unsigned int dma_gfp_flags()
+{
+	return use_zone_normal ? GFP_ATOMIC : GFP_ATOMIC | GFP_DMA;
+}
+
+
 /*
  * Function:    scsi_malloc
  *
@@ -287,7 +310,7 @@ void scsi_resize_dma_pool(void)
 #endif
 
 	/* limit DMA memory to 32MB: */
-	new_dma_sectors = (new_dma_sectors + 15) & 0xfff0;
+ 	new_dma_sectors = min(new_dma_sectors + 15, (max_dma_memory * 1024 * 2)) & 0xfffffff0;
 
 	/*
 	 * We never shrink the buffers - this leads to
@@ -330,7 +353,7 @@ void scsi_resize_dma_pool(void)
 			for (i = dma_sectors / SECTORS_PER_PAGE;
 			   i < new_dma_sectors / SECTORS_PER_PAGE; i++) {
 				new_dma_malloc_pages[i] = (unsigned char *)
-				    __get_free_pages(GFP_ATOMIC | GFP_DMA, 0);
+				    __get_free_pages(dma_gfp_flags(), 0);
 				if (!new_dma_malloc_pages[i])
 					break;
 			}
@@ -430,7 +453,7 @@ int scsi_init_minimal_dma_pool(void)
 		if (dma_malloc_pages) {
                         memset(dma_malloc_pages, 0, size);
 			dma_malloc_pages[0] = (unsigned char *)
-			    __get_free_pages(GFP_ATOMIC | GFP_DMA, 0);
+			    __get_free_pages(dma_gfp_flags(), 0);
 			if (dma_malloc_pages[0])
 				has_space = 1;
 		}
