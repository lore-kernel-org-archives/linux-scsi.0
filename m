From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Use unchecked_isa_dma in sd_revalidate_disk()
Date: Thu, 22 Mar 2007 18:17:03 +0100
Message-ID: <20070322171703.GA22470@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:45448 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934141AbXCVRRF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Mar 2007 13:17:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

In sd_revalidate_disk(), the SCSI Disk driver needs a few bytes DMA memory,
allocated by kmalloc() and __GFP_DMA. This patch uses __GFP_DMA only if
the corresponding host structure has unchecked_isa_dma set.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.21-rc4/drivers/scsi/sd.c
===================================================================
--- linux-2.6.21-rc4.orig/drivers/scsi/sd.c
+++ linux-2.6.21-rc4/drivers/scsi/sd.c
@@ -1553,7 +1553,8 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | 
+			(sdp->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!buffer) {
 		printk(KERN_WARNING "(sd_revalidate_disk:) Memory allocation "
 		       "failure.\n");
