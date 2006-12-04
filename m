From: akpm@osdl.org
Subject: [patch 18/30] drivers/scsi/mca_53c9x.c : save_flags()/cli() removal
Date: Mon, 04 Dec 2006 15:18:36 -0800
Message-ID: <200612042319.kB4NJjjF008782@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:56755 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967770AbWLDXT5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 18:19:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com, alan@lxorguk.ukuu.org.uk

From: Amol Lad <amol@verismonetworks.com>

Replaced save_flags()/cli() with spin_lock alternatives

[akpm@osdl.org: no longer BROKEN_ON_SMP]
Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
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
