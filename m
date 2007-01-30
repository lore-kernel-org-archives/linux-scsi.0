From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] sym53c500_cs: remove bogus call fo free_dma()
Date: Tue, 30 Jan 2007 13:23:35 +0000
Message-ID: <E1HBsxT-0002Mv-Uf@ZenIV.linux.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965364AbXA3NXg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jan 2007 08:23:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


What DMA for 16bit pcmcia card, anyway?  We never do request_dma()
there and ->dma_channel never changes since initialization to -1.
IOW, that call is dead code.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/pcmcia/sym53c500_cs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 9fb0ea5..5b458d2 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -545,8 +545,6 @@ SYM53C500_release(struct pcmcia_device *link)
 	*/
 	if (shost->irq)
 		free_irq(shost->irq, shost);
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 
-- 
1.5.0-rc2.GIT


