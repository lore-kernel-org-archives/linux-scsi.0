From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 77/71] ncr5380: Fix wait for 53C80 registers registers after PDMA
Date: Fri,  4 Dec 2015 00:03:01 +0100
Message-ID: <1449183781-2163-2-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:55188 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbbLCXDP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Dec 2015 18:03:15 -0500
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The check for 53C80 registers accessibility was commented out because
it was broken (inverted). Fix and enable it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   35 +++++++----------------------------
 1 file changed, 7 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 04f6c29..c5cd490 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -599,14 +599,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
 
-#if 0
-	/*
-	 *	DON'T DO THIS - THEY NEVER ARRIVE!
-	 */
-	printk("53C400r: Waiting for 53C80 registers\n");
-	while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
+	/* wait for 53C80 registers to be available */
+	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
 		;
-#endif
+
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
 		printk(KERN_ERR "53C400r: no end dma signal\n");
 		
@@ -674,36 +670,19 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 		blocks--;
 	}
 
-#if 0
-	printk("53C400w: waiting for registers to be available\n");
-	THEY NEVER DO ! while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG);
-	printk("53C400w: Got em\n");
-#endif
-
-	/* Let's wait for this instead - could be ugly */
-	/* All documentation says to check for this. Maybe my hardware is too
-	 * fast. Waiting for it seems to work fine! KLL
-	 */
 	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
 		udelay(4); /* DTC436 chip hangs without this */
 		;	// FIXME - no timeout
 	}
 
-	/*
-	 * I know. i is certainly != 0 here but the loop is new. See previous
-	 * comment.
-	 */
-	if (i) {
-		if (!((i = NCR5380_read(BUS_AND_STATUS_REG)) & BASR_END_DMA_TRANSFER))
-			printk(KERN_ERR "53C400w: No END OF DMA bit - WHOOPS! BASR=%0x\n", i);
-	} else
-		printk(KERN_ERR "53C400w: no 53C80 gated irq after transfer (last block)\n");
+	/* wait for 53C80 registers to be available */
+	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
+		;
 
-#if 0
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
 		printk(KERN_ERR "53C400w: no end dma signal\n");
 	}
-#endif
+
 	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
 		; 	// TIMEOUT
 	return 0;
-- 
Ondrej Zary

