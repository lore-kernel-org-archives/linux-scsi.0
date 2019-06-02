From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 6/7] scsi: mac_scsi: Enable PDMA on Mac IIfx
Date: Sun, 02 Jun 2019 11:24:12 +1000
Message-ID: <a69c9e248f46f02a2cdef95e2ff3d3b08531c6fa.1559438652.git.fthain@telegraphics.com.au>
References: <cover.1559438652.git.fthain@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1559438652.git.fthain@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Joshua Thompson <funaho@jurai.org>, Geert Uytterhoeven <geert@linux-m68k.org>, linux-m68k@lists.linux-m68k.org
List-Id: linux-scsi@vger.kernel.org

Add support for Apple's custom "SCSI DMA" chip. This patch doesn't make
use of its DMA capability. Just the PDMA capability is sufficient to
improve sequential read throughput by a factor of 5.

Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Joshua Thompson <funaho@jurai.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: Stan Johnson <userm57@yahoo.com>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 arch/m68k/mac/config.c  | 10 +++++++--
 drivers/scsi/mac_scsi.c | 47 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 47 insertions(+), 10 deletions(-)

diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index 39835ca5a474..611f73bfc87c 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -911,6 +911,10 @@ static const struct resource mac_scsi_iifx_rsrc[] __initconst = {
 		.flags = IORESOURCE_MEM,
 		.start = 0x50008000,
 		.end   = 0x50009FFF,
+	}, {
+		.flags = IORESOURCE_MEM,
+		.start = 0x50008000,
+		.end   = 0x50009FFF,
 	},
 };
 
@@ -1012,10 +1016,12 @@ int __init mac_platform_init(void)
 	case MAC_SCSI_IIFX:
 		/* Addresses from The Guide to Mac Family Hardware.
 		 * $5000 8000 - $5000 9FFF: SCSI DMA
+		 * $5000 A000 - $5000 BFFF: Alternate SCSI
 		 * $5000 C000 - $5000 DFFF: Alternate SCSI (DMA)
 		 * $5000 E000 - $5000 FFFF: Alternate SCSI (Hsk)
-		 * The SCSI DMA custom IC embeds the 53C80 core. mac_scsi does
-		 * not make use of its DMA or hardware handshaking logic.
+		 * The A/UX header file sys/uconfig.h says $50F0 8000.
+		 * The "SCSI DMA" custom IC embeds the 53C80 core and
+		 * supports Programmed IO, DMA and PDMA (hardware handshake).
 		 */
 		platform_device_register_simple("mac_scsi", 0,
 			mac_scsi_iifx_rsrc, ARRAY_SIZE(mac_scsi_iifx_rsrc));
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index e83b47a7e4b5..2e503f06ac99 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -22,6 +22,7 @@
 #include <asm/hwtest.h>
 #include <asm/io.h>
 #include <asm/mac_pdma.h>
+#include <asm/macintosh.h>
 #include <asm/macints.h>
 #include <asm/setup.h>
 
@@ -90,11 +91,22 @@ static int __init mac_scsi_setup(char *str)
 __setup("mac5380=", mac_scsi_setup);
 #endif /* !MODULE */
 
+/* The "SCSI DMA" chip on the IIfx implements this register. */
+#define CTRL_REG                0x8
+#define CTRL_INTERRUPTS_ENABLE  BIT(1)
+#define CTRL_HANDSHAKE_MODE     BIT(3)
+
+static inline void write_ctrl_reg(struct NCR5380_hostdata *hostdata, u32 value)
+{
+	out_be32(hostdata->io + (CTRL_REG << 4), value);
+}
+
 static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
                                 unsigned char *dst, int len)
 {
 	u8 __iomem *s = hostdata->pdma_io + (INPUT_DATA_REG << 4);
 	unsigned char *d = dst;
+	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -103,6 +115,10 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
 		int bytes;
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
+			                         CTRL_INTERRUPTS_ENABLE);
+
 		bytes = mac_pdma_recv(s, d, min(hostdata->pdma_residual, 512));
 
 		if (bytes > 0) {
@@ -111,7 +127,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 		}
 
 		if (hostdata->pdma_residual == 0)
-			return 0;
+			goto out;
 
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
 		                           BUS_AND_STATUS_REG, BASR_ACK,
@@ -119,7 +135,7 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			return 0;
+			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
@@ -130,13 +146,18 @@ static inline int macscsi_pread(struct NCR5380_hostdata *hostdata,
 		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
 		         "%s: bus error (%d/%d)\n", __func__, d - dst, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-		return -1;
+		result = -1;
+		goto out;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
 	            "%s: phase mismatch or !DRQ\n", __func__);
 	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	return -1;
+	result = -1;
+out:
+	if (macintosh_config->ident == MAC_MODEL_IIFX)
+		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+	return result;
 }
 
 static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
@@ -144,6 +165,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 {
 	unsigned char *s = src;
 	u8 __iomem *d = hostdata->pdma_io + (OUTPUT_DATA_REG << 4);
+	int result = 0;
 
 	hostdata->pdma_residual = len;
 
@@ -152,6 +174,10 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 	                              BASR_DRQ | BASR_PHASE_MATCH, HZ / 64)) {
 		int bytes;
 
+		if (macintosh_config->ident == MAC_MODEL_IIFX)
+			write_ctrl_reg(hostdata, CTRL_HANDSHAKE_MODE |
+			                         CTRL_INTERRUPTS_ENABLE);
+
 		bytes = mac_pdma_send(s, d, min(hostdata->pdma_residual, 512));
 
 		if (bytes > 0) {
@@ -165,7 +191,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			                          TCR_LAST_BYTE_SENT, HZ / 64) < 0)
 				scmd_printk(KERN_ERR, hostdata->connected,
 				            "%s: Last Byte Sent timeout\n", __func__);
-			return 0;
+			goto out;
 		}
 
 		if (NCR5380_poll_politely2(hostdata, STATUS_REG, SR_REQ, SR_REQ,
@@ -174,7 +200,7 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 			scmd_printk(KERN_DEBUG, hostdata->connected,
 			            "%s: !REQ and !ACK\n", __func__);
 		if (!(NCR5380_read(BUS_AND_STATUS_REG) & BASR_PHASE_MATCH))
-			return 0;
+			goto out;
 
 		if (bytes == 0)
 			udelay(MAC_PDMA_DELAY);
@@ -185,13 +211,18 @@ static inline int macscsi_pwrite(struct NCR5380_hostdata *hostdata,
 		dsprintk(NDEBUG_PSEUDO_DMA, hostdata->host,
 		         "%s: bus error (%d/%d)\n", __func__, s - src, len);
 		NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-		return -1;
+		result = -1;
+		goto out;
 	}
 
 	scmd_printk(KERN_ERR, hostdata->connected,
 	            "%s: phase mismatch or !DRQ\n", __func__);
 	NCR5380_dprint(NDEBUG_PSEUDO_DMA, hostdata->host);
-	return -1;
+	result = -1;
+out:
+	if (macintosh_config->ident == MAC_MODEL_IIFX)
+		write_ctrl_reg(hostdata, CTRL_INTERRUPTS_ENABLE);
+	return result;
 }
 
 static int macscsi_dma_xfer_len(struct NCR5380_hostdata *hostdata,
-- 
2.21.0
