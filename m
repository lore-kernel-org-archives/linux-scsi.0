From: Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] [scsi] Remove __GFP_DMA
Date: Mon, 21 May 2007 17:15:26 +0200
Message-ID: <20070521151525.GA581@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns2.suse.de ([195.135.220.15]:54063 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757232AbXEUPPh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 May 2007 11:15:37 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

[PATCH] [scsi] Remove __GFP_DMA

After 821de3a27bf33f11ec878562577c586cd5f83c64, it's not necessary to alloate a
DMA buffer any more in sd.c.

Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 drivers/scsi/sd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1515,7 +1515,7 @@ static int sd_revalidate_disk(struct gen
 	if (!scsi_device_online(sdp))
 		goto out;
 
-	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL | __GFP_DMA);
+	buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
 	if (!buffer) {
 		sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "
 			  "allocation failure.\n");
