From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v6 6/6] g_NCR5380: Various DTC436 workarounds
Date: Fri, 30 Jun 2017 22:40:53 -0400 (EDT)
Message-ID: <99155dced1af1e6512feb30df48db17b0f926e97.1498876618.git.fthain@telegraphics.com.au>
References: <cover.1498876618.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498876618.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Limit PDMA send to 512 B to avoid data corruption on DTC3181E. The
corruption is always the same: one byte missing at the beginning of
a 128 B block. It happens only with slow Quantum LPS 240 drive, not with
faster IBM DORS-32160. It's not clear what causes this. Documentation
for the DTC436 chip has not been made available.

On DTC chips, Gated IRQ (for End of DMA) arrives early, and needs
special handling.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 137ec58c43ac..49312bf98068 100644
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
 #define NCR5380_dma_recv_setup          generic_NCR5380_precv
@@ -316,6 +317,7 @@ static int generic_NCR5380_init_one(struct scsi_host_template *tpnt,
 	}
 	hostdata = shost_priv(instance);
 
+	hostdata->board = board;
 	hostdata->io = iomem;
 	hostdata->region_size = region_size;
 
@@ -492,6 +494,8 @@ static void wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
 	int count = 10000;
 
 	do {
+		if (hostdata->board == BOARD_DTC3181E)
+			udelay(4); /* DTC436 chip hangs without this */
 		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
 			return;
 	} while (--count > 0);
@@ -521,16 +525,22 @@ static inline int generic_NCR5380_precv(struct NCR5380_hostdata *hostdata,
 	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
 
 	do {
-		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
-		                           CSR_HOST_BUF_NOT_RDY, 0,
-		                           hostdata->c400_ctl_status,
-		                           CSR_GATED_53C80_IRQ,
-		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
-			break;
-
-		if (NCR5380_read(hostdata->c400_ctl_status) &
-		    CSR_HOST_BUF_NOT_RDY)
-			break;
+		if (hostdata->board == BOARD_DTC3181E && start == len - 128) {
+			/* Ignore early CSR_GATED_53C80_IRQ */
+			if (NCR5380_poll_politely(hostdata, hostdata->c400_ctl_status,
+			                          CSR_HOST_BUF_NOT_RDY, 0, HZ / 64) < 0)
+				break;
+		} else {
+			if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+			                           CSR_HOST_BUF_NOT_RDY, 0,
+			                           hostdata->c400_ctl_status,
+			                           CSR_GATED_53C80_IRQ,
+			                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
+				break;
+			if (NCR5380_read(hostdata->c400_ctl_status) &
+			    CSR_HOST_BUF_NOT_RDY)
+				break;
+		}
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			insw(hostdata->io_port + hostdata->c400_host_buf,
@@ -655,7 +665,12 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 
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
