From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 5/5] g_NCR5380: Re-work PDMA loops
Date: Sat, 24 Jun 2017 02:37:37 -0400 (EDT)
Message-ID: <977ce89726cbf21f04dc853a2da18ce3d1066982.1498285948.git.fthain@telegraphics.com.au>
References: <cover.1498285948.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1498285948.git.fthain@telegraphics.com.au>
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

[Use poll_politely2() for register polling. Rely on polling for IRQ
rather than polling for bus status, like the algorithm in the datasheet.
Calculate residual from block count register instead of the loop count.
Factor-out common code as wait_for_53c80_access(). -- F.T.]

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 drivers/scsi/g_NCR5380.c | 149 ++++++++++++++++++++---------------------------
 1 file changed, 64 insertions(+), 85 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index d51a2ba07a24..2546e6076a90 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -481,6 +481,30 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 		release_mem_region(base, region_size);
 }
 
+/* wait_for_53c80_access - wait for 53C80 registers to become accessible
+ * @hostdata: scsi host private data
+ *
+ * The registers within the 53C80 logic block are inaccessible until
+ * bit 7 in the 53C400 control status register gets asserted.
+ */
+
+static int wait_for_53c80_access(struct NCR5380_hostdata *hostdata)
+{
+	int count = 10000;
+
+	do {
+		udelay(4); /* DTC436 chip hangs without this */
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
+			return 0;
+	} while (--count > 0);
+
+	scmd_printk(KERN_ERR, hostdata->connected,
+	            "53c80 registers not accessible, device will be reset\n");
+	NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
+	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+	return -1;
+}
+
 /**
  * generic_NCR5380_pread - pseudo DMA receive
  * @hostdata: scsi host private data
@@ -493,18 +517,19 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
-	int blocks = len / 128;
-	int start = 0;
+	int result;
+	int start;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
-	NCR5380_write(hostdata->c400_blk_cnt, blocks);
-	while (1) {
-		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
+	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
+
+	for (start = 0; start < len; start += 128) {
+		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+		                           CSR_HOST_BUF_NOT_RDY, 0,
+		                           hostdata->c400_ctl_status,
+		                           CSR_GATED_53C80_IRQ,
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
 			break;
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
-			goto out_wait;
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; /* FIXME - no timeout */
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			insw(hostdata->io_port + hostdata->c400_host_buf,
@@ -515,46 +540,20 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 		else
 			memcpy_fromio(dst + start,
 				hostdata->io + NCR53C400_host_buffer, 128);
-
-		start += 128;
-		blocks--;
-	}
-
-	if (blocks) {
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; /* FIXME - no timeout */
-
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
 	}
 
-	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
-		printk("53C400r: no 53C80 gated irq after transfer");
-
-out_wait:
-	hostdata->pdma_residual = len - start;
+	hostdata->pdma_residual = NCR5380_read(hostdata->c400_blk_cnt) * 128;
 
-	/* wait for 53C80 registers to be available */
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG))
-		;
+	result = wait_for_53c80_access(hostdata);
 
-	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+	if (hostdata->pdma_residual == 0 &&
+	    NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
 	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
 	                          HZ / 64) < 0)
 		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
 		            __func__, hostdata->pdma_residual);
 
-	return 0;
+	return result;
 }
 
 /**
@@ -569,36 +568,19 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
                                          unsigned char *src, int len)
 {
-	int blocks = len / 128;
-	int start = 0;
+	int result;
+	int start;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-	NCR5380_write(hostdata->c400_blk_cnt, blocks);
-	while (1) {
-		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)
-			goto out_wait;
-
-		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
+	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
+
+	for (start = 0; start < len; start += 128) {
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
-
-		start += 128;
-		blocks--;
-	}
-	if (blocks) {
-		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
-			; // FIXME - no timeout
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
@@ -609,30 +591,27 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 		else
 			memcpy_toio(hostdata->io + NCR53C400_host_buffer,
 			            src + start, 128);
-
-		start += 128;
-		blocks--;
 	}
 
-out_wait:
-	hostdata->pdma_residual = len - start;
+	hostdata->pdma_residual = NCR5380_read(hostdata->c400_blk_cnt) * 128;
 
-	/* wait for 53C80 registers to be available */
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
-		udelay(4); /* DTC436 chip hangs without this */
-		/* FIXME - no timeout */
-	}
+	result = wait_for_53c80_access(hostdata);
 
-	while (!(NCR5380_read(TARGET_COMMAND_REG) & TCR_LAST_BYTE_SENT))
-		; 	// TIMEOUT
+	if (hostdata->pdma_residual == 0) {
+		if (NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
+		                          TCR_LAST_BYTE_SENT, TCR_LAST_BYTE_SENT,
+		                          HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected,
+			            "%s: Last Byte Sent timeout\n", __func__);
 
-	if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
-	                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
-	                          HZ / 64) < 0)
-		scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
-		            __func__, hostdata->pdma_residual);
+		if (NCR5380_poll_politely(hostdata, BUS_AND_STATUS_REG,
+		                          BASR_END_DMA_TRANSFER, BASR_END_DMA_TRANSFER,
+		                          HZ / 64) < 0)
+			scmd_printk(KERN_ERR, hostdata->connected, "%s: End of DMA timeout (%d)\n",
+			            __func__, hostdata->pdma_residual);
+	}
 
-	return 0;
+	return result;
 }
 
 static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
-- 
2.13.0
