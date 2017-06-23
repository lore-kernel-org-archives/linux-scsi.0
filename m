From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/4] g_NCR5380: PDMA fixes and cleanup
Date: Fri, 23 Jun 2017 11:06:59 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1706231101230.2417@nippy.intranet>
References: <cover.1497528687.git.fthain@telegraphics.com.au> <201706222311.38121.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201706222311.38121.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>
List-Id: linux-scsi@vger.kernel.org


On Thu, 22 Jun 2017, Ondrej Zary wrote:

> Works only with HDD on non-DTC chips. CD-ROM hangs. DTC hangs even with 
> HDD. The PDMA code really needs to be fixed.
> 

Does this patch help? It should be applied on top of this series of 4.

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 4c31cb316a38..95ae8edbecbc 100644
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
@@ -493,33 +517,19 @@ static void generic_NCR5380_release_resources(struct Scsi_Host *instance)
 static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
                                         unsigned char *dst, int len)
 {
-	int start, retries;
-	u8 csr, basr;
+	int result;
+	int start;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
 	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
 
 	for (start = 0; start < len; start += 128) {
-		retries = 10000;
-		while (1) {	/* monitor IRQ while waiting for host buffer */
-			csr = NCR5380_read(hostdata->c400_ctl_status);
-			if (!(csr & CSR_HOST_BUF_NOT_RDY))
-				break;
-			if (csr & CSR_GATED_53C80_IRQ) {
-				basr = NCR5380_read(BUS_AND_STATUS_REG);
-				if (!(basr & BASR_PHASE_MATCH) ||
-				    (basr & BASR_BUSY_ERROR)) {
-					printk("basr=0x%02x csr=0x%02x at start=%d\n", basr, csr, start);
-					goto out_wait;
-				}
-			}
-			if (retries-- < 1) {
-				shost_printk(KERN_ERR, hostdata->host, "53C400r: host buffer not ready in time\n");
-				NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
-				NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-				goto out_wait;
-			}
-		}
+		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+		                           CSR_HOST_BUF_NOT_RDY, 0,
+		                           hostdata->c400_ctl_status,
+		                           CSR_GATED_53C80_IRQ,
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
+			break;
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			insw(hostdata->io_port + hostdata->c400_host_buf,
@@ -532,24 +542,14 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 				hostdata->io + NCR53C400_host_buffer, 128);
 	}
 
-out_wait:
-	/* wait for 53C80 registers to be available */
-	retries = 10000;
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
-		if (retries-- < 1) {
-			shost_printk(KERN_ERR, hostdata->host, "53C400r: 53C80 registers not ready in time\n");
-			NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
-			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-			break;
-		}
-	}
+	result = wait_for_53c80_access(hostdata);
 
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
 		pr_err("%s: No end dma signal (%d/%d)\n", __func__, start, len);
 
-	hostdata->pdma_residual = len - start;
+	hostdata->pdma_residual = NCR5380_read(hostdata->c400_blk_cnt) * 128;
 
-	return 0;
+	return result;
 }
 
 /**
@@ -564,41 +564,19 @@ static inline int generic_NCR5380_pread(struct NCR5380_hostdata *hostdata,
 static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
                                          unsigned char *src, int len)
 {
-	int start, retries;
-	u8 csr, basr;
+	int result;
+	int start;
 
 	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 	NCR5380_write(hostdata->c400_blk_cnt, len / 128);
 
 	for (start = 0; start < len; start += 128) {
-		retries = 10000;
-		while (1) {	/* monitor IRQ while waiting for host buffer */
-			csr = NCR5380_read(hostdata->c400_ctl_status);
-			if (!(csr & CSR_HOST_BUF_NOT_RDY))
-				break;
-			if (csr & CSR_GATED_53C80_IRQ) {
-				basr = NCR5380_read(BUS_AND_STATUS_REG);
-				if (!(basr & BASR_PHASE_MATCH) ||
-				    (basr & BASR_BUSY_ERROR)) {
-					printk("w basr=0x%02x csr=0x%02x at start=%d\n", basr, csr, start);
-					/* the previous block was not written properly */
-					start -= 2 * 128;
-					if (start < 0)
-						start = 0;
-					goto out_wait;
-				}
-			}
-			if (retries-- < 1) {
-				shost_printk(KERN_ERR, hostdata->host, "53C400w: host buffer not ready in time\n");
-				NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
-				NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-				/* the previous block was not written properly */
-				start -= 2 * 128;
-				if (start < 0)
-					start = 0;
-				goto out_wait;
-			}
-		}
+		if (NCR5380_poll_politely2(hostdata, hostdata->c400_ctl_status,
+		                           CSR_HOST_BUF_NOT_RDY, 0,
+		                           hostdata->c400_ctl_status,
+		                           CSR_GATED_53C80_IRQ,
+		                           CSR_GATED_53C80_IRQ, HZ / 64) < 0)
+			break;
 
 		if (hostdata->io_port && hostdata->io_width == 2)
 			outsw(hostdata->io_port + hostdata->c400_host_buf,
@@ -611,24 +589,12 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 			            src + start, 128);
 	}
 
-out_wait:
-	/* wait for 53C80 registers to be available */
-	udelay(4); /* DTC436 chip hangs without this */
-	retries = 10000;
-	while (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)) {
-		udelay(4); /* DTC436 chip hangs without this */
-		if (retries-- < 1) {
-			shost_printk(KERN_ERR, hostdata->host, "53C400w: 53C80 registers not ready in time, start=%d, len=%d\n", start, len);
-			NCR5380_write(hostdata->c400_ctl_status, CSR_RESET);
-			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
-			break;
-		}
-	}
+	result = wait_for_53c80_access(hostdata);
 
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
 		pr_err("%s: No end dma signal (%d/%d)\n", __func__, start, len);
 
-	hostdata->pdma_residual = len - start;
+	hostdata->pdma_residual = NCR5380_read(hostdata->c400_blk_cnt) * 128;
 
 	if (hostdata->pdma_residual == 0 &&
 	    NCR5380_poll_politely(hostdata, TARGET_COMMAND_REG,
@@ -637,7 +603,7 @@ static inline int generic_NCR5380_pwrite(struct NCR5380_hostdata *hostdata,
 		scmd_printk(KERN_ERR, hostdata->connected,
 		            "%s: Last Byte Sent timeout\n", __func__);
 
-	return 0;
+	return result;
 }
 
 static int generic_NCR5380_dma_xfer_len(struct NCR5380_hostdata *hostdata,
