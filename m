From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 74/78] ncr5380: Use runtime register mapping
Date: Sun, 03 Jan 2016 16:06:15 +1100
Message-ID: <20160103050522.561796482@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=73-71
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Convert compile-time C400_ register mapping to runtime mapping.
This removes the weird negative register offsets and allows adding
additional mappings.

While at it, convert read/write loops into insb/outsb.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.h   |   13 ------
 drivers/scsi/g_NCR5380.c |   88 +++++++++++++++++++++--------------------------
 drivers/scsi/g_NCR5380.h |   12 ++++--
 3 files changed, 49 insertions(+), 64 deletions(-)

Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-01-03 16:04:30.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-01-03 16:04:51.000000000 +1100
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
 
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:50.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:51.000000000 +1100
@@ -253,6 +253,7 @@ static int __init generic_NCR5380_detect
 	};
 	int flags;
 	struct Scsi_Host *instance;
+	struct NCR5380_hostdata *hostdata;
 #ifdef SCSI_G_NCR5380_MEM
 	unsigned long base;
 	void __iomem *iomem;
@@ -394,6 +395,7 @@ static int __init generic_NCR5380_detect
 		instance = scsi_register(tpnt, sizeof(struct NCR5380_hostdata));
 		if (instance == NULL)
 			goto out_release;
+		hostdata = shost_priv(instance);
 
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
@@ -403,18 +405,27 @@ static int __init generic_NCR5380_detect
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
 
@@ -522,31 +533,25 @@ generic_NCR5380_biosparam(struct scsi_de
  
 static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst, int len)
 {
-#ifdef SCSI_G_NCR5380_MEM
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-#endif
 	int blocks = len / 128;
 	int start = 0;
-	int bl;
 
-	NCR5380_write(C400_CONTROL_STATUS_REG, CSR_BASE | CSR_TRANS_DIR);
-	NCR5380_write(C400_BLOCK_COUNTER_REG, blocks);
+	NCR5380_write(hostdata->c400_ctl_status, CSR_BASE | CSR_TRANS_DIR);
+	NCR5380_write(hostdata->c400_blk_cnt, blocks);
 	while (1) {
-		if ((bl = NCR5380_read(C400_BLOCK_COUNTER_REG)) == 0) {
+		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
-		}
-		if (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ) {
+		if (NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ) {
 			printk(KERN_ERR "53C400r: Got 53C80_IRQ start=%d, blocks=%d\n", start, blocks);
 			return -1;
 		}
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY);
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
+			; /* FIXME - no timeout */
 
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			int i;
-			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
-		}
+		insb(instance->io_port + hostdata->c400_host_buf,
+							dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start,
@@ -557,17 +562,12 @@ static inline int NCR5380_pread(struct S
 	}
 
 	if (blocks) {
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
-		{
-			// FIXME - no timeout
-		}
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
+			; /* FIXME - no timeout */
 
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			int i;	
-			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(C400_HOST_BUFFER);
-		}
+		insb(instance->io_port + hostdata->c400_host_buf,
+							dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start,
@@ -577,7 +577,7 @@ static inline int NCR5380_pread(struct S
 		blocks--;
 	}
 
-	if (!(NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ))
+	if (!(NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		printk("53C400r: no 53C80 gated irq after transfer");
 
 #if 0
@@ -585,7 +585,7 @@ static inline int NCR5380_pread(struct S
 	 *	DON'T DO THIS - THEY NEVER ARRIVE!
 	 */
 	printk("53C400r: Waiting for 53C80 registers\n");
-	while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG)
+	while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG)
 		;
 #endif
 	if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_END_DMA_TRANSFER))
@@ -606,32 +606,26 @@ static inline int NCR5380_pread(struct S
 
 static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src, int len)
 {
-#ifdef SCSI_G_NCR5380_MEM
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
-#endif
 	int blocks = len / 128;
 	int start = 0;
-	int bl;
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
+		if (NCR5380_read(hostdata->c400_blk_cnt) == 0)
 			break;
-		}
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			for (i = 0; i < 128; i++)
-				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
-		}
+		outsb(instance->io_port + hostdata->c400_host_buf,
+							src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
@@ -641,14 +635,12 @@ static inline int NCR5380_pwrite(struct
 		blocks--;
 	}
 	if (blocks) {
-		while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_HOST_BUF_NOT_RDY)
+		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
 
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			for (i = 0; i < 128; i++)
-				NCR5380_write(C400_HOST_BUFFER, src[start + i]);
-		}
+		outsb(instance->io_port + hostdata->c400_host_buf,
+							src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
@@ -660,7 +652,7 @@ static inline int NCR5380_pwrite(struct
 
 #if 0
 	printk("53C400w: waiting for registers to be available\n");
-	THEY NEVER DO ! while (NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_53C80_REG);
+	THEY NEVER DO ! while (NCR5380_read(hostdata->c400_ctl_status) & CSR_53C80_REG);
 	printk("53C400w: Got em\n");
 #endif
 
@@ -668,7 +660,7 @@ static inline int NCR5380_pwrite(struct
 	/* All documentation says to check for this. Maybe my hardware is too
 	 * fast. Waiting for it seems to work fine! KLL
 	 */
-	while (!(i = NCR5380_read(C400_CONTROL_STATUS_REG) & CSR_GATED_53C80_IRQ))
+	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
 		;	// FIXME - no timeout
 
 	/*
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:03.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:51.000000000 +1100
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
 
