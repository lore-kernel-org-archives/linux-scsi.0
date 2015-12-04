From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 73/71] ncr5380: Use runtime register mapping
Date: Fri,  4 Dec 2015 22:00:55 +0100
Message-ID: <1449262855-4538-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.gsystem.sk ([62.176.172.50]:60648 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbbLDVBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Dec 2015 16:01:09 -0500
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Convert compile-time C400_ register mapping to runtime mapping.
This removes the weird negative register offsets and allows adding
additional mappings.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/NCR5380.h   |   13 +---------
 drivers/scsi/g_NCR5380.c |   61 ++++++++++++++++++++++++++--------------------
 drivers/scsi/g_NCR5380.h |   12 ++++++---
 3 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/drivers/scsi/NCR5380.h b/drivers/scsi/NCR5380.h
index 36779df..923db6c 100644
--- a/drivers/scsi/NCR5380.h
+++ b/drivers/scsi/NCR5380.h
@@ -163,8 +163,7 @@
 /* Write any value to this register to start an ini mode DMA receive */
 #define START_DMA_INITIATOR_RECEIVE_REG 7	/* wo */
 
-#define C400_CONTROL_STATUS_REG NCR53C400_register_offset-8	/* rw */
-
+/* NCR 53C400(A) Control Status Register bits: */
 #define CSR_RESET              0x80	/* wo  Resets 53c400 */
 #define CSR_53C80_REG          0x80	/* ro  5380 registers busy */
 #define CSR_TRANS_DIR          0x40	/* rw  Data transfer direction */
@@ -181,16 +180,6 @@
 #define CSR_BASE CSR_53C80_INTR
 #endif
 
-/* Number of 128-byte blocks to be transferred */
-#define C400_BLOCK_COUNTER_REG   NCR53C400_register_offset-7	/* rw */
-
-/* Resume transfer after disconnect */
-#define C400_RESUME_TRANSFER_REG NCR53C400_register_offset-6	/* wo */
-
-/* Access to host buffer stack */
-#define C400_HOST_BUFFER         NCR53C400_register_offset-4	/* rw */
-
-
 /* Note : PHASE_* macros are based on the values of the STATUS register */
 #define PHASE_MASK 	(SR_MSG | SR_CD | SR_IO)
 
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index a9a237f..ce444da 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -253,6 +253,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 	};
 	int flags;
 	struct Scsi_Host *instance;
+	struct NCR5380_hostdata *hostdata;
 #ifdef SCSI_G_NCR5380_MEM
 	unsigned long base;
 	void __iomem *iomem;
@@ -395,6 +396,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
 		if (instance == NULL)
 			goto out_release;
+		hostdata = shost_priv(instance);
 
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
@@ -404,18 +406,27 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
 		 * the base address.
 		 */
-		if (overrides[current_override].board == BOARD_NCR53C400)
+		if (overrides[current_override].board == BOARD_NCR53C400) {
 			instance->io_port += 8;
+			hostdata->c400_ctl_status = 0;
+			hostdata->c400_blk_cnt = 1;
+			hostdata->c400_host_buf = 4;
+		}
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
-		((struct NCR5380_hostdata *)instance->hostdata)->iomem = iomem;
+		hostdata->iomem = iomem;
+		if (overrides[current_override].board == BOARD_NCR53C400) {
+			hostdata->c400_ctl_status = 0x100;
+			hostdata->c400_blk_cnt = 0x101;
+			hostdata->c400_host_buf = 0x104;
+		}
 #endif
 
 		if (NCR5380_init(instance, flags))
 			goto out_unregister;
 
 		if (overrides[current_override].board == BOARD_NCR53C400)
-			NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
+			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 
 		NCR5380_maybe_reset_bus(instance);
 
@@ -523,30 +534,28 @@ generic_NCR5380_biosparam(struct scsi_device *sdev, struct block_device *bdev,
  
 static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
 {
-#ifdef SCSI_G_NCR5380_MEM
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-#endif
 	int blocks = len / 128;
 	int start = 0;
 	int bl;
 
-	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE | CSR_TRANS_DIR);
-	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
+	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
+	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
-		if ((bl = NCR5380_read(C400_BLOCK_COUNTER_REG)) == 0) {
+		if ((bl = NCR5380_read(hostdata->c400_blk_cnt)) == 0) {
 			break;
 		}
-		if (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ) {
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
 			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
 			return -1;
 		}
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY);
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY);
 
 #ifndef SCSI_G_NCR5380_MEM
 		{
 			int i;
 			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
+				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -558,7 +567,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 	}
 
 	if (blocks) {
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 		{
 			// FIXME - no timeout
 		}
@@ -567,7 +576,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 		{
 			int i;	
 			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
+				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -578,7 +587,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 		blocks--;
 	}
 
-	if (!(NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ))
+	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
 
 #if 0
@@ -586,7 +595,7 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 	 *	DON'T DO THIS - THEY NEVER ARRIVE!
 	 */
 	printk("53C400r: Waiting for 53C80 registers\n");
-	while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG)
+	while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
 		;
 #endif
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
@@ -607,31 +616,29 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 
 static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
 {
-#ifdef SCSI_G_NCR5380_MEM
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-#endif
 	int blocks = len / 128;
 	int start = 0;
 	int bl;
 	int i;
 
-	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE);
-	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
+	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
+	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
-		if (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ) {
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
 			printk(KERN_ERR "53C400w: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
 			return -1;
 		}
 
-		if ((bl = NCR5380_read(C400_BLOCK_COUNTER_REG)) == 0) {
+		if ((bl = NCR5380_read(hostdata->c400_blk_cnt)) == 0) {
 			break;
 		}
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
 #ifndef SCSI_G_NCR5380_MEM
 		{
 			for (i = 0; i < 128; i++)
-				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
+				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -642,13 +649,13 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 		blocks--;
 	}
 	if (blocks) {
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
 
 #ifndef SCSI_G_NCR5380_MEM
 		{
 			for (i = 0; i < 128; i++)
-				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
+				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
 		}
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -661,7 +668,7 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 
 #if 0
 	printk("53C400w: waiting for registers to be available\n");
-	THEY NEVER DO ! while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG);
+	THEY NEVER DO ! while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG);
 	printk("53C400w: Got em\n");
 #endif
 
@@ -669,7 +676,7 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 	/* All documentation says to check for this. Maybe my hardware is too
 	 * fast. Waiting for it seems to work fine! KLL
 	 */
-	while (!(i = NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ))
+	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		;	// FIXME - no timeout
 
 	/*
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index fd201e9..c5e57b7 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -29,7 +29,6 @@
 
 #define NCR5380_map_type int
 #define NCR5380_map_name port
-#define NCR53C400_register_offset 0
 
 #ifdef CONFIG_SCSI_GENERIC_NCR53C400
 #define NCR5380_region_size 16
@@ -42,7 +41,10 @@
 #define NCR5380_write(reg, value) \
 	outb(value, instance->io_port + (reg))
 
-#define NCR5380_implementation_fields /* none */
+#define NCR5380_implementation_fields \
+	int c400_ctl_status; \
+	int c400_blk_cnt; \
+	int c400_host_buf;
 
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
@@ -50,7 +52,6 @@
 
 #define NCR5380_map_type unsigned long
 #define NCR5380_map_name base
-#define NCR53C400_register_offset 0x108
 #define NCR53C400_mem_base 0x3880
 #define NCR53C400_host_buffer 0x3900
 #define NCR5380_region_size 0x3a00
@@ -63,7 +64,10 @@
 	       NCR53C400_mem_base + (reg))
 
 #define NCR5380_implementation_fields \
-    void __iomem *iomem;
+	void __iomem *iomem; \
+	int c400_ctl_status; \
+	int c400_blk_cnt; \
+	int c400_host_buf;
 
 #endif
 
-- 
Ondrej Zary

