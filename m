From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/4] [SCSI] qlogicfas: don't call free_dma()
Date: Thu,  5 Jun 2014 23:29:48 +0200
Message-ID: <1402003789-1990031-4-git-send-email-arnd@arndb.de>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:63067 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaFEVaC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 17:30:02 -0400
In-Reply-To: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>

The qlogicfas scsi driver does not use DMA, and the call to free_dma()
in its exit function seems to have been copied incorrectly from
another driver but never caused trouble.

One case where it gets in the way is randconfig builds on ARM,
which depending on the configuration does not provide a free_dma()
function, causing this build error:

drivers/scsi/qlogicfas.c: In function 'qlogicfas_release':
drivers/scsi/qlogicfas.c:175:3: error: implicit declaration of function 'free_dma' [-Werror=implicit-function-declaration]
   free_dma(shost->dma_channel);
   ^

Removing the incorrect function calls should be the obvious
fix for this, with no downsides.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/qlogicfas.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 13d628b..a22bb1b 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -171,8 +171,6 @@ static int qlogicfas_release(struct Scsi_Host *shost)
 		qlogicfas408_disable_ints(priv);	
 		free_irq(shost->irq, shost);
 	}
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 	scsi_host_put(shost);
-- 
1.8.3.2

