From: akpm@osdl.org
Subject: [patch 23/36] ioremap balanced with iounmap for drivers/scsi/amiga7xx.c
Date: Tue, 10 Oct 2006 14:41:40 -0700
Message-ID: <200610102141.k9ALfefs025429@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29854 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965110AbWJJVmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:42:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, amol@verismonetworks.com

From: Amol Lad <amol@verismonetworks.com>

ioremap must be balanced by an iounmap and failing to do so can result in a
memory leak.

Signed-off-by: Amol Lad <amol@verismonetworks.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/amiga7xx.c |    2 ++
 1 files changed, 2 insertions(+)

diff -puN drivers/scsi/amiga7xx.c~ioremap-balanced-with-iounmap-drivers-scsi-amiga7xxc drivers/scsi/amiga7xx.c
--- a/drivers/scsi/amiga7xx.c~ioremap-balanced-with-iounmap-drivers-scsi-amiga7xxc
+++ a/drivers/scsi/amiga7xx.c
@@ -115,6 +115,8 @@ static int amiga7xx_release(struct Scsi_
 		free_irq(shost->irq, NULL);
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
+	if (shost->base)
+		z_iounmap((void *)shost->base);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_unregister(shost);
_
