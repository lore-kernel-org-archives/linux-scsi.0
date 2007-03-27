From: akpm@linux-foundation.org
Subject: [patch 25/28] Use unchecked_isa_dma in sd_revalidate_disk()
Date: Mon, 26 Mar 2007 21:59:45 -0800
Message-ID: <200703270559.l2R5xjgO008709@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40920 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964806AbXC0F7x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2007 01:59:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bwalle@suse.de, jens.axboe@oracle.com

From: Bernhard Walle <bwalle@suse.de>

In sd_revalidate_disk(), the SCSI Disk driver needs a few bytes DMA memory,
allocated by kmalloc() and __GFP_DMA.  This patch uses __GFP_DMA only if
the corresponding host structure has unchecked_isa_dma set.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk drivers/scsi/sd.c
--- a/drivers/scsi/sd.c~use-unchecked_isa_dma-in-sd_revalidate_disk
+++ a/drivers/scsi/sd.c
@@ -1516,7 +1516,8 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL |
+			(sdp->host->unchecked_isa_dma ? __GFP_DMA : 0));
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
_
