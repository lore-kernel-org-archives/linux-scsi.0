From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v5 4/6] g_NCR5380: Limit PDMA send to 512 B to avoid data
 corruption on DTC3181E
Date: Thu, 29 Jun 2017 01:24:18 -0400 (EDT)
Message-ID: <67f209cf84a47d4d4a3719eee9cd565fef5664a0.1498713600.git.fthain@telegraphics.com.au>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:42416 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751591AbdF2FYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 01:24:20 -0400
In-Reply-To: <cover.1498713600.git.fthain@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>

From: Ondrej Zary <linux@rainbow-software.org>

The corruption is always the same: one byte missing at the beginning of
a 128 B block. It happens only with slow Quantum LPS 240 drive, not with
faster IBM DORS-32160. It's not clear what causes this. Documentation
for the DTC436 chip has not been made available. Hence this workaround.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index dedaed2d16e4..5fd227bb1830 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -45,7 +45,8 @@
 	int c400_blk_cnt; \
 	int c400_host_buf; \
 	int io_width; \
-	int pdma_residual
+	int pdma_residual; \
+	int board
 
 #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
 #define NCR5380_dma_recv_setup          generic_NCR5380_pread
@@ -316,6 +317,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	}
 	hostdata = shost_priv(instance);
 
+	hostdata->board = board;
 	hostdata->io = iomem;
 	hostdata->region_size = region_size;
 
@@ -644,7 +646,12 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 
 	/* 53C400 datasheet: non-modulo-128-byte transfers should use PIO */
 	if (transfersize % 128)
-		transfersize = 0;
+		return 0;
+
+	/* Limit PDMA send to 512 B to avoid random corruption on DTC3181E */
+	if (hostdata->board == BOARD_DTC3181E &&
+	    cmd->sc_data_direction == DMA_TO_DEVICE)
+		transfersize = min(cmd->SCp.this_residual, 512);
 
 	return min(transfersize, DMA_MAX_SIZE);
 }
-- 
2.13.0
