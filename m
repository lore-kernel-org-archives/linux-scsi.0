From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/2] cciss: map out more memory for config table
Date: Tue, 12 Dec 2006 13:51:31 -0600
Message-ID: <20061212195131.GA2471@beardog.cca.cpqcorp.net>
Reply-To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel13.hp.com ([156.153.255.238]:56302 "EHLO palrel13.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbWLLTve (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Dec 2006 14:51:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

PATCH 1/2

This patch maps out more memory for our config table. It's required to reach offset 0x214 to disable DMA on the P600. I'm not sure how I lost this hunk. 
Please consider this for inclusion.

Thanks,
mikem

Signed-off-by: Mike Miller <mike.miller@hp.com>

 drivers/block/cciss.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)
--------------------------------------------------------------------------------
diff -puN drivers/block/cciss.c~cciss_fix_for_p600_dma drivers/block/cciss.c
--- linux-2.6-work/drivers/block/cciss.c~cciss_fix_for_p600_dma	2006-12-11 15:20:07.000000000 -0600
+++ linux-2.6-work-mikem/drivers/block/cciss.c	2006-12-11 15:21:33.000000000 -0600
@@ -2865,7 +2865,7 @@ static int cciss_pci_init(ctlr_info_t *c
 #ifdef CCISS_DEBUG
 	printk("address 0 = %x\n", c->paddr);
 #endif				/* CCISS_DEBUG */
-	c->vaddr = remap_pci_mem(c->paddr, 200);
+	c->vaddr = remap_pci_mem(c->paddr, 0x250);
 
 	/* Wait for the board to become ready.  (PCI hotplug needs this.)
 	 * We poll for up to 120 secs, once per 100ms. */
