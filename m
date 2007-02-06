From: akpm@linux-foundation.org
Subject: [patch 17/33] drivers/scsi/mca_53c9x.c : save_flags()/cli() removal
Date: Mon, 05 Feb 2007 16:38:52 -0800
Message-ID: <200702060039.l160dtU5004998@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41825 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965376AbXBFAkR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

From: Amol Lad <amol@verismonetworks.com>

Replaced save_flags()/cli() with spin_lock alternatives

[akpm@osdl.org: no longer BROKEN_ON_SMP]
Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mca_53c9x.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff -puN drivers/scsi/mca_53c9x.c~drivers-scsi-mca_53c9xc-save_flags-cli-removal drivers/scsi/mca_53c9x.c
--- a/drivers/scsi/mca_53c9x.c~drivers-scsi-mca_53c9xc-save_flags-cli-removal
+++ a/drivers/scsi/mca_53c9x.c
@@ -341,9 +341,7 @@ static void dma_init_read(struct NCR_ESP
 {
 	unsigned long flags;
 
-
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(esp->ehost->host_lock, flags);
 
 	mca_disable_dma(esp->dma);
 	mca_set_dma_mode(esp->dma, MCA_DMA_MODE_XFER | MCA_DMA_MODE_16 |
@@ -352,16 +350,14 @@ static void dma_init_read(struct NCR_ESP
 	mca_set_dma_count(esp->dma, length / 2); /* !!! */
 	mca_enable_dma(esp->dma);
 
-	restore_flags(flags);
+	spin_unlock_irqrestore(esp->ehost->host_lock, flags);
 }
 
 static void dma_init_write(struct NCR_ESP *esp, __u32 addr, int length)
 {
 	unsigned long flags;
 
-
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(esp->ehost->host_lock, flags);
 
 	mca_disable_dma(esp->dma);
 	mca_set_dma_mode(esp->dma, MCA_DMA_MODE_XFER | MCA_DMA_MODE_WRITE |
@@ -370,7 +366,7 @@ static void dma_init_write(struct NCR_ES
 	mca_set_dma_count(esp->dma, length / 2); /* !!! */
 	mca_enable_dma(esp->dma);
 
-	restore_flags(flags);
+	spin_unlock_irqrestore(esp->ehost->host_lock, flags);
 }
 
 static void dma_ints_off(struct NCR_ESP *esp)
_
