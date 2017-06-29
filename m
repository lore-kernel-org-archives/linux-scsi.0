From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v5 5/6] g_NCR5380: Re-work PDMA loops
Date: Thu, 29 Jun 2017 01:24:18 -0400 (EDT)
Message-ID: <8edff9ea4a9a9a68d6b6694d53da240017e4d80c.1498713600.git.fthain@telegraphics.com.au>
References: <cover.1498713600.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498713600.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@rainbow-software.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

The polling loops in pread() and pwrite() can easily become infinite
loops and hang the machine.

On DTC chips, IRQ can arrive late and we miss it because we only check
once. Merge the IRQ check into host buffer wait and add polling limit.

Also place a limit on polling for 53C80 registers accessibility.

[Use NCR5380_poll_politely2() for register polling. Rely on polling for
gated IRQ rather than polling for phase error, like the algorithm in the
datasheet. Calculate residual from block count register instead of the
loop counter. Factor-out common code as wait_for_53c80_access(). -- F.T.]

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 168 +++++++++++++++++++++++++----------------------
 1 file changed, 88 insertions(+), 80 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 5fd227bb1830..f7e50d2bca07 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -482,6 +482,30 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 		release_mem_region(base, region_size);
 }
 
+/* wait_for_53c80_access - wait for 53C80 registers to become accessible
+ * @hostdata: scsi host private data
+ *
+ * The registers within the 53C80 logic block are inaccessible until
+ * bit 7 in the 53C400 control status register gets asserted.
+ */
+
+static void wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
+{
+	int count = 10000;
+
+	do {
+		if (hostdata->board == BOARD_DTC3181E)
+			udelay(4); /* DTC436 chip hangs without this */
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
+			return;
+	} while (--count > 0);
+
+	scmd_printk(KERN_ERR, hostdata->connected,
+	            "53c80 registers not accessible, device will be reset\n");
+	NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
+	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+}
+
 /**
  * generic_NCR5380_pread - pseudo DMA read
  * @hostdata: scsi host private data
@@ -494,18 +518,23 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
-	int blocks = len / 128;
+	int residual;
 	int start = 0;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
-	NCR5380_write(hostdata->c400_blk_cnt, blocks);
-	while (1) {
-		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
+	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
+
+	while (start < len) {
+		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+		                           CSR_HOST_BUF_NOT_RDY, 0,
+		                           hostdata->c400_ctl_status,
+		                           CSR_GATED_53C80_IRQ,
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
+			break;
+
+		if (NCR5380_read(hostdata->c400_ctl_status) &
+		    CSR_HOST_BUF_NOT_RDY)
 			break;
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
-			goto out_wait;
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; /* FIXME - no timeout */
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			insw(hostdata->io_port + hostdata->c400_host_buf,
@@ -516,44 +545,30 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 		else
 			memcpy_fromio(dst + start,
 				hostdata->io + NCR53C400_host_buffer, 128);
-
 		start += 128;
-		blocks--;
-	}
-
-	if (blocks) {
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; /* FIXME - no timeout */
 
-		if (hostdata->io_port && hostdata->io_width == 2)
-			insw(hostdata->io_port + hostdata->c400_host_buf,
-							dst + start, 64);
-		else if (hostdata->io_port)
-			insb(hostdata->io_port + hostdata->c400_host_buf,
-							dst + start, 128);
-		else
-			memcpy_fromio(dst + start,
-				hostdata->io + NCR53C400_host_buffer, 128);
-
-		start += 128;
-		blocks--;
+		if (NCR5380_read(hostdata->c400_ctl_status) &
+		    CSR_GATED_53C80_IRQ)
+			break;
 	}
 
-	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
-		printk("53C400r: no 53C80 gated irq after transfer");
-
-out_wait:
-	hostdata->pdma_residual = len - start;
+	residual = len - start;
 
-	/* wait for 53C80 registers to be available */
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
-		;
+	if (residual != 0) {
+		/* 53c80 interrupt or transfer timeout. Reset 53c400 logic. */
+		NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
+		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+	}
+	wait_for_53c80_access(hostdata);
 
-	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
-	                          HZ / 64) < 0)
+	if (residual == 0 && NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+	                                           BASR_END_DMA_TRANSFER,
+	                                           BASR_END_DMA_TRANSFER,
+	                                           HZ / 64) < 0)
 		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
-		            __func__, hostdata->pdma_residual);
+		            __func__, residual);
+
+	hostdata->pdma_residual = residual;
 
 	return 0;
 }
@@ -570,36 +585,23 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
                                          unsigned char *src, int len)
 {
-	int blocks = len / 128;
+	int residual;
 	int start = 0;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-	NCR5380_write(hostdata->c400_blk_cnt, blocks);
-	while (1) {
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
-			goto out_wait;
-
-		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
+	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
+
+	while (start < len) {
+		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+		                           CSR_HOST_BUF_NOT_RDY, 0,
+		                           hostdata->c400_ctl_status,
+		                           CSR_GATED_53C80_IRQ,
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
 			break;
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; // FIXME - timeout
-
-		if (hostdata->io_port && hostdata->io_width == 2)
-			outsw(hostdata->io_port + hostdata->c400_host_buf,
-							src + start, 64);
-		else if (hostdata->io_port)
-			outsb(hostdata->io_port + hostdata->c400_host_buf,
-							src + start, 128);
-		else
-			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
-			            src + start, 128);
 
-		start += 128;
-		blocks--;
-	}
-	if (blocks) {
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; // FIXME - no timeout
+		if (NCR5380_read(hostdata->c400_ctl_status) &
+		    CSR_GATED_53C80_IRQ)
+			break;
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
@@ -610,28 +612,34 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 		else
 			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
-
 		start += 128;
-		blocks--;
 	}
 
-out_wait:
-	hostdata->pdma_residual = len - start;
+	residual = max(len - start,
+	               (int)NCR5380_read(hostdata->c400_blk_cnt) * 128);
 
-	/* wait for 53C80 registers to be available */
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
-		udelay(4); /* DTC436 chip hangs without this */
-		/* FIXME - no timeout */
+	if (residual != 0) {
+		/* 53c80 interrupt or transfer timeout. Reset 53c400 logic. */
+		NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
+		NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+	}
+	wait_for_53c80_access(hostdata);
+
+	if (residual == 0) {
+		if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
+		                          TCR_LAST_BYTE_SENT, TCR_LAST_BYTE_SENT,
+		                          HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected,
+			            "%s: Last Byte Sent timeout\n", __func__);
+
+		if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+		                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
+		                          HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
+			            __func__, residual);
 	}
 
-	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
-		; 	// TIMEOUT
-
-	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
-	                          HZ / 64) < 0)
-		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
-		            __func__, hostdata->pdma_residual);
+	hostdata->pdma_residual = residual;
 
 	return 0;
 }
-- 
2.13.0
