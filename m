From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 12/12] scsi/ncr5380: Suppress unhelpful "interrupt without
 IRQ bit" message
Date: Thu,  6 Oct 2016 19:41:07 -0400 (EDT)
Message-ID: <5ce22e27c1b829efa50d22e1b72e9f9c87832d78.1475791899.git.fthain@telegraphics.com.au>
References: <cover.1475791899.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:46018 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756115AbcJFXlN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 19:41:13 -0400
In-Reply-To: <cover.1475791899.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, Ondrej Zary <linux@rainbow-software.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

If a NCR5380 host instance ends up on a shared interrupt line then
this printk will be a problem. It is already a problem on some Mac
models: when testing mac_scsi on a PowerBook 180 I found that PDMA
transfers (but not PIO transfers) cause the message to be logged.

These spurious interrupts don't appear to come from the DRQ signal from
the 5380. And they don't happen at all on the Mac LC III. A comment in
the NetBSD source code mentions this mystery. Testing seems to show
that we can safely ignore these interrupts.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/NCR5380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 72ac31cd..0c3c7e6 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -995,7 +995,7 @@ static irqreturn_t __maybe_unused NCR5380_intr(int irq, void *dev_id)
 		}
 		handled = 1;
 	} else {
-		shost_printk(KERN_NOTICE, instance, "interrupt without IRQ bit\n");
+		dsprintk(NDEBUG_INTR, instance, "interrupt without IRQ bit\n");
 #ifdef SUN3_SCSI_VME
 		dregs->csr |= CSR_DMA_ENABLE;
 #endif
-- 
2.7.3

