From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: enforce 32bit DMA mapping
Date: Sun, 4 Feb 2007 13:05:40 +0100 (CET)
Message-ID: <tkrat.61995f33104845d9@s5r6.in-berlin.de>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
 <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
 <tkrat.581ea0f6f3fe6292@s5r6.in-berlin.de>
 <tkrat.e82713a8340840b3@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:49930 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbXBDMFq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2007 07:05:46 -0500
In-Reply-To: <tkrat.e82713a8340840b3@s5r6.in-berlin.de>
Content-Disposition: INLINE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org

In order to use OHCI physical DMA, all s/g elements, s/g tables, ORBs,
and response buffers have to reside within the first 4 GB of the
FireWire controller's physical address space.  Set the correct mask for
DMA mappings.

Also ensure that the memory allocated for command ORBs and s/g tables is
suitable for DMA.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Should I use GFP_DMA32 instead of GFP_DMA?


 drivers/ieee1394/sbp2.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
===================================================================
--- linux-2.6.20-rc5.orig/drivers/ieee1394/sbp2.c
+++ linux-2.6.20-rc5/drivers/ieee1394/sbp2.c
@@ -477,7 +477,7 @@ static int sbp2util_create_command_orb_p
 
 	spin_lock_irqsave(&lu->cmd_orb_lock, flags);
 	for (i = 0; i < orbs; i++) {
-		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC);
+		cmd = kzalloc(sizeof(*cmd), GFP_ATOMIC | GFP_DMA);
 		if (!cmd) {
 			spin_unlock_irqrestore(&lu->cmd_orb_lock, flags);
 			return -ENOMEM;
@@ -757,6 +757,11 @@ static struct sbp2_lu *sbp2_alloc_device
 			SBP2_ERR("failed to register lower 4GB address range");
 			goto failed_alloc;
 		}
+#else
+		if (dma_set_mask(hi->host->device.parent, DMA_32BIT_MASK)) {
+			SBP2_ERR("failed to set 4GB DMA mask");
+			goto failed_alloc;
+		}
 #endif
 	}
 


-- 
Stefan Richter
-=====-=-=== --=- --=--
http://arcgraph.de/sr/

