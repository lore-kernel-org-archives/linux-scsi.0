From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 76/71] ncr5380: Enable PDMA for DTC chips
Date: Fri,  4 Dec 2015 22:17:34 +0100
Message-ID: <1449263854-14436-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add I/O register mapping for DTC chips and enable PDMA mode.

These chips have 16-bit wide HOST BUFFER register (counter register at
offset 0x0d increments by 2 on each HOST BUFFER read). Detect it
automatically.

Large PIO transfers crash at least the DTCT-436P chip (all reads result
in 0xFF) so this patch actually makes it work.

The chip also crashes when we bang the C400 host status register too
heavily after PDMA write - a small udelay is needed.

Tested on DTCT-436P and verified that it does not break 53C400A.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   59 ++++++++++++++++++++++++++++------------------
 drivers/scsi/g_NCR5380.h |    4 +++-
 2 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 85da3c2..9816b81 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -328,7 +328,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA;
+			flags = FLAG_NO_DMA_FIXUP;
 			ports = dtc_3181e_ports;
 			break;
 		}
@@ -412,10 +412,12 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
 		}
-		if (overrides[current_override].board == BOARD_NCR53C400A) {
+		if (overrides[current_override].board == BOARD_NCR53C400A ||
+		    overrides[current_override].board == BOARD_DTC3181E) {
 			hostdata->c400_ctl_status = 9;
 			hostdata->c400_blk_cnt = 10;
 			hostdata->c400_host_buf = 8;
+			hostdata->c400_host_idx = 13;
 		}
 #else
 		instance->base = overrides[current_override].NCR5380_map_name;
@@ -430,8 +432,20 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		if (NCR5380_init(instance, flags))
 			goto out_unregister;
 
+#ifndef SCSI_G_NCR5380_MEM
+		/* read initial value of index register */
+		i = NCR5380_read(hostdata->c400_host_idx);
+		/* read something from host buffer */
+		NCR5380_read(hostdata->c400_host_buf);
+		/* I/O width = index register increment */
+		hostdata->io_width = NCR5380_read(hostdata->c400_host_idx) - i;
+		if (hostdata->io_width < 0)
+			hostdata->io_width += 128;
+#endif
+
 		if (overrides[current_override].board == BOARD_NCR53C400 ||
-		    overrides[current_override].board == BOARD_NCR53C400A)
+		    overrides[current_override].board == BOARD_NCR53C400A ||
+		    overrides[current_override].board == BOARD_DTC3181E)
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 
 		NCR5380_maybe_reset_bus(instance);
@@ -558,11 +572,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY);
 
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			int i;
-			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
-		}
+		if (hostdata->io_width == 2)
+			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
+		else
+			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start,
@@ -579,11 +592,10 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 		}
 
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			int i;	
-			for (i = 0; i < 128; i++)
-				dst[start + i] = NCR5380_read(hostdata->c400_host_buf);
-		}
+		if (hostdata->io_width == 2)
+			insw(instance->io_port + hostdata->c400_host_buf, dst + start, 64);
+		else
+			insb(instance->io_port + hostdata->c400_host_buf, dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_fromio(dst + start,
@@ -642,10 +654,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			for (i = 0; i < 128; i++)
-				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
-		}
+		if (hostdata->io_width == 2)
+			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
+		else
+			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
@@ -657,12 +669,11 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 	if (blocks) {
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - no timeout
-
 #ifndef SCSI_G_NCR5380_MEM
-		{
-			for (i = 0; i < 128; i++)
-				NCR5380_write(hostdata->c400_host_buf, src[start + i]);
-		}
+		if (hostdata->io_width == 2)
+			outsw(instance->io_port + hostdata->c400_host_buf, src + start, 64);
+		else
+			outsb(instance->io_port + hostdata->c400_host_buf, src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
 		memcpy_toio(hostdata->iomem + NCR53C400_host_buffer,
@@ -682,8 +693,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 	/* All documentation says to check for this. Maybe my hardware is too
 	 * fast. Waiting for it seems to work fine! KLL
 	 */
-	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
+	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
+		udelay(4); /* DTC436 chip hangs without this */
 		;	// FIXME - no timeout
+	}
 
 	/*
 	 * I know. i is certainly != 0 here but the loop is new. See previous
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index c5e57b7..b3936aa 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -44,7 +44,9 @@
 #define NCR5380_implementation_fields \
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
-	int c400_host_buf;
+	int c400_host_buf; \
+	int c400_host_idx; \
+	int io_width;
 
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
-- 
Ondrej Zary
