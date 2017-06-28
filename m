From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 4/5] g_NCR5380: Limit PDMA send to 512 B to avoid random
 corruption on DTC3181E
Date: Wed, 28 Jun 2017 00:04:37 -0400 (EDT)
Message-ID: <10c24e9d9aee2b4cf004dcdf5eed92ef2c0bb994.1498622056.git.fthain@telegraphics.com.au>
References: <cover.1498622056.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498622056.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

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
index 9f18082415c4..b1e0a08e49c1 100644
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
