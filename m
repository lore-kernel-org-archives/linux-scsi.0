From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] qlogicfas: Close narrow race in release
Date: Wed, 15 Aug 2007 12:56:59 -0600
Message-ID: <1187204221728-git-send-email-matthew@wil.cx>
References: <11872042213451-git-send-email-matthew@wil.cx>
 <11872042213665-git-send-email-matthew@wil.cx>
 <11872042211224-git-send-email-matthew@wil.cx>
 <11872042212630-git-send-email-matthew@wil.cx>
 <1187204221432-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:33283 "EHLO
	mail-08.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765699AbXHOS45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Aug 2007 14:56:57 -0400
In-Reply-To: <1187204221432-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

We were releasing the IRQ before removing the host, so commands could
still be coming in which would never be seen by the interrupt handler.
Just remove the host before releasing the IRQ to close this race.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/qlogicfas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 94baca8..1e874f1 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -166,6 +166,7 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 {
 	struct qlogicfas408_priv *priv = get_priv_by_host(shost);
 
+	scsi_remove_host(shost);
 	if (shost->irq) {
 		qlogicfas408_disable_ints(priv);	
 		free_irq(shost->irq, shost);
@@ -174,7 +175,6 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
-	scsi_remove_host(shost);
 	scsi_host_put(shost);
 
 	return 0;
-- 
1.5.2.4

