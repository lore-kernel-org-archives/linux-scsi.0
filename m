From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v5 1/6] g_NCR5380: Fix PDMA transfer size
Date: Thu, 29 Jun 2017 01:24:18 -0400 (EDT)
Message-ID: <e6f1d6a2f8a14518c593a0990e03e96ac4de8291.1498713600.git.fthain@telegraphics.com.au>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42398 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751567AbdF2FYT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 01:24:19 -0400
In-Reply-To: <cover.1498713600.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

From: Ondrej Zary <linux@rainbow-software.org>

generic_NCR5380_dma_xfer_len() incorrectly uses cmd->transfersize
which causes rescan-scsi-bus and CD-ROM access to hang the system.
Use cmd->SCp.this_residual instead, like other NCR5380 drivers.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 67c8dac321ad..14ef4e8c4713 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -76,6 +76,7 @@
 #define IRQ_AUTO 254
 
 #define MAX_CARDS 8
+#define DMA_MAX_SIZE 32768
 
 /* old-style parameters for compatibility */
 static int ncr_irq = -1;
@@ -629,23 +630,16 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
                                         struct scsi_cmnd *cmd)
 {
-	int transfersize = cmd->transfersize;
+	int transfersize = cmd->SCp.this_residual;
 
 	if (hostdata->flags & FLAG_NO_PSEUDO_DMA)
 		return 0;
 
-	/* Limit transfers to 32K, for xx400 & xx406
-	 * pseudoDMA that transfers in 128 bytes blocks.
-	 */
-	if (transfersize > 32 * 1024 && cmd->SCp.this_residual &&
-	    !(cmd->SCp.this_residual % transfersize))
-		transfersize = 32 * 1024;
-
 	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
 	if (transfersize % 128)
 		transfersize = 0;
 
-	return transfersize;
+	return min(transfersize, DMA_MAX_SIZE);
 }
 
 /*
-- 
2.13.0
