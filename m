From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH v2 76/71] ncr5380: Enable PDMA for DTC chips
Date: Sun,  6 Dec 2015 23:55:11 +0100
Message-ID: <1449442511-15092-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Add I/O register mapping for DTC chips and enable PDMA mode.

These chips have 16-bit wide HOST BUFFER register and it must be read
by 16-bit accesses (we lose data otherwise).

Large PIO transfers crash at least the DTCT-436P chip (all reads result
in 0xFF) so this patch actually makes it work.

The chip also crashes when we bang the C400 host status register too
heavily after PDMA write - a small udelay is needed.

Tested on DTCT-436P and verified that it does not break 53C400A.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   40 ++++++++++++++++++++++++++++++++--------
 drivers/scsi/g_NCR5380.h |    4 +++-
 2 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 578d4fa..038dddf 100644
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
@@ -401,6 +401,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
 		instance->n_io_port = region_size;
+		hostdata->io_width = 1; /* 8-bit PDMA by default */
 
 		/*
 		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
@@ -413,10 +414,14 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
 			break;
+		case BOARD_DTC3181E:
+			hostdata->io_width = 2;	/* 16-bit PDMA */
+			/* fall through */
 		case BOARD_NCR53C400A:
 			hostdata->c400_ctl_status = 9;
 			hostdata->c400_blk_cnt = 10;
 			hostdata->c400_host_buf = 8;
+			hostdata->c400_host_idx = 13;
 			break;
 		}
 #else
@@ -433,7 +438,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			goto out_unregister;
 
 		if (overrides[current_override].board == BOARD_NCR53C400 ||
-		    overrides[current_override].board == BOARD_NCR53C400A)
+		    overrides[current_override].board == BOARD_NCR53C400A ||
+		    overrides[current_override].board == BOARD_DTC3181E)
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 
 		NCR5380_maybe_reset_bus(instance);
@@ -559,7 +565,11 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 			; /* FIXME - no timeout */
 
 #ifndef SCSI_G_NCR5380_MEM
-		insb(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_width == 2)
+			insw(instance->io_port + hostdata->c400_host_buf,
+							dst + start, 64);
+		else
+			insb(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -575,7 +585,11 @@ static inline int NCR5380_pread(struct Scsi_Host *instance, unsigned char *dst,
 			; /* FIXME - no timeout */
 
 #ifndef SCSI_G_NCR5380_MEM
-		insb(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_width == 2)
+			insw(instance->io_port + hostdata->c400_host_buf,
+							dst + start, 64);
+		else
+			insb(instance->io_port + hostdata->c400_host_buf,
 							dst + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -633,7 +647,11 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 		while (NCR5380_read(hostdata->c400_ctl_status) & CSR_HOST_BUF_NOT_RDY)
 			; // FIXME - timeout
 #ifndef SCSI_G_NCR5380_MEM
-		outsb(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_width == 2)
+			outsw(instance->io_port + hostdata->c400_host_buf,
+							src + start, 64);
+		else
+			outsb(instance->io_port + hostdata->c400_host_buf,
 							src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -648,7 +666,11 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 			; // FIXME - no timeout
 
 #ifndef SCSI_G_NCR5380_MEM
-		outsb(instance->io_port + hostdata->c400_host_buf,
+		if (hostdata->io_width == 2)
+			outsw(instance->io_port + hostdata->c400_host_buf,
+							src + start, 64);
+		else
+			outsb(instance->io_port + hostdata->c400_host_buf,
 							src + start, 128);
 #else
 		/* implies SCSI_G_NCR5380_MEM */
@@ -669,8 +691,10 @@ static inline int NCR5380_pwrite(struct Scsi_Host *instance, unsigned char *src,
 	/* All documentation says to check for this. Maybe my hardware is too
 	 * fast. Waiting for it seems to work fine! KLL
 	 */
-	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ))
-		;	// FIXME - no timeout
+	while (!(i = NCR5380_read(hostdata->c400_ctl_status) & CSR_GATED_53C80_IRQ)) {
+		udelay(4); /* DTC436 chip hangs without this */
+		/* FIXME - no timeout */
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
