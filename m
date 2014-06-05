From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/4] [SCSI] NCR53c406a: don't call free_dma() by default
Date: Thu,  5 Jun 2014 23:29:49 +0200
Message-ID: <1402003789-1990031-5-git-send-email-arnd@arndb.de>
References: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:51351 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaFEV35 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2014 17:29:57 -0400
In-Reply-To: <1402003789-1990031-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>

The NCR53c406a scsi driver normally does not use DMA, unless
the USE_PIO macro is disabled by modifying the source code.

The call to free_dma() for some reason uses #ifdef USE_DMA,
which does not do the right thing, since USE_DMA is defined
as a boolean that is either 0 or 1, but always present.

One case where it gets in the way is randconfig builds on ARM,
which depending on the configuration does not provide a free_dma()
function, causing this build error:

drivers/scsi/NCR53c406a.c: In function 'NCR53c406a_release':
drivers/scsi/NCR53c406a.c:600:3: error: implicit declaration of function 'free_dma' [-Werror=implicit-function-declaration]
   free_dma(shost->dma_channel);
   ^

This changes the code to use #if USE_DMA, to match the
rest of the file, which seems to be what the author intended.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/NCR53c406a.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index c91888a..2c78785 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -595,7 +595,7 @@ static int NCR53c406a_release(struct Scsi_Host *shost)
 {
 	if (shost->irq)
 		free_irq(shost->irq, NULL);
-#ifdef USE_DMA
+#if USE_DMA
 	if (shost->dma_channel != 0xff)
 		free_dma(shost->dma_channel);
 #endif
-- 
1.8.3.2

