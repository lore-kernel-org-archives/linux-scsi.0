From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 2/5] g_NCR5380: End PDMA transfer correctly on target
 disconnection
Date: Wed, 28 Jun 2017 00:04:37 -0400 (EDT)
Message-ID: <f5a7de775fa7f813595975de9638007123d0c26b.1498622056.git.fthain@telegraphics.com.au>
References: <cover.1498622056.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498622056.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

When an IRQ arrives during PDMA transfer, pread() and pwrite() return
without waiting for the 53C80 registers to be ready and this ends up
messing up the chip state. This was observed with SONY CDU-55S which is
slow enough to disconnect during 4096-byte reads.

IRQ during PDMA is not an error so don't return -1. Instead, store the
remaining byte count for use by NCR5380_dma_residual().

[Poll for the BASR_END_DMA_TRANSFER condition rather than remove the
error message -- F.T.]

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 48 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 14ef4e8c4713..911a4300ea51 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -44,12 +44,13 @@
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
 	int c400_host_buf; \
-	int io_width
+	int io_width; \
+	int pdma_residual
 
 #define NCR5380_dma_xfer_len            generic_NCR5380_dma_xfer_len
 #define NCR5380_dma_recv_setup          generic_NCR5380_pread
 #define NCR5380_dma_send_setup          generic_NCR5380_pwrite
-#define NCR5380_dma_residual            NCR5380_dma_residual_none
+#define NCR5380_dma_residual            generic_NCR5380_dma_residual
 
 #define NCR5380_intr                    generic_NCR5380_intr
 #define NCR5380_queue_command           generic_NCR5380_queue_command
@@ -500,10 +501,8 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 	while (1) {
 		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
-			return -1;
-		}
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
+			goto out_wait;
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; /* FIXME - no timeout */
 
@@ -542,13 +541,19 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
 
+out_wait:
+	hostdata->pdma_residual = len - start;
+
 	/* wait for 53C80 registers to be available */
 	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
 		;
 
-	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
-		printk(KERN_ERR "53C400r: no end dma signal\n");
-		
+	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
+	                          HZ / 64) < 0)
+		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
+		            __func__, hostdata->pdma_residual);
+
 	return 0;
 }
 
@@ -571,10 +576,8 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
-			printk(KERN_ERR "53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
-			return -1;
-		}
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
+			goto out_wait;
 
 		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
@@ -612,18 +615,24 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 		blocks--;
 	}
 
+out_wait:
+	hostdata->pdma_residual = len - start;
+
 	/* wait for 53C80 registers to be available */
 	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
 		udelay(4); /* DTC436 chip hangs without this */
 		/* FIXME - no timeout */
 	}
 
-	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER)) {
-		printk(KERN_ERR "53C400w: no end dma signal\n");
-	}
-
 	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
 		; 	// TIMEOUT
+
+	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
+	                          HZ / 64) < 0)
+		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
+		            __func__, hostdata->pdma_residual);
+
 	return 0;
 }
 
@@ -642,6 +651,11 @@ static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
 	return min(transfersize, DMA_MAX_SIZE);
 }
 
+static int generic_NCR5380_dma_residual(struct NCR5380_hostdata *hostdata)
+{
+	return hostdata->pdma_residual;
+}
+
 /*
  *	Include the NCR5380 core code that we build our driver around	
  */
-- 
2.13.0
