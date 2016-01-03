From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 76/78] ncr5380: Enable PDMA for DTC chips
Date: Sun, 03 Jan 2016 16:06:17 +1100
Message-ID: <20160103050523.091781825@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=76-71
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

Add I/O register mapping for DTC chips and enable PDMA mode.

These chips have 16-bit wide HOST BUFFER register and it must be read
by 16-bit accesses (we lose data otherwise).

Large PIO transfers crash at least the DTCT-436P chip (all reads result
in 0xFF) so this patch actually makes it work.

The chip also crashes when we bang on the C400 host status register too
heavily after PDMA write - a small udelay is needed.

Tested on DTCT-436P and verified that it does not break 53C400A.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
Changes to Ondrej's version:
- Rebased.

---
 drivers/scsi/g_NCR5380.c |   38 +++++++++++++++++++++++++++++++-------
 drivers/scsi/g_NCR5380.h |    3 ++-
 2 files changed, 33 insertions(+), 8 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:53.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:54.000000000 +1100
@@ -327,7 +327,7 @@ static int __init generic_NCR5380_detect
 			ports = ncr_53c400a_ports;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_PSEUDO_DMA;
+			flags = FLAG_NO_DMA_FIXUP;
 			ports = dtc_3181e_ports;
 			break;
 		}
@@ -400,6 +400,7 @@ static int __init generic_NCR5380_detect
 #ifndef SCSI_G_NCR5380_MEM
 		instance->io_port = overrides[current_override].NCR5380_map_name;
 		instance->n_io_port = region_size;
+		hostdata->io_width = 1; /* 8-bit PDMA by default */
 
 		/*
 		 * On NCR53C400 boards, NCR5380 registers are mapped 8 past
@@ -412,6 +413,9 @@ static int __init generic_NCR5380_detect
 			hostdata->c400_blk_cnt = 1;
 			hostdata->c400_host_buf = 4;
 			break;
+		case BOARD_DTC3181E:
+			hostdata->io_width = 2;	/* 16-bit PDMA */
+			/* fall through */
 		case BOARD_NCR53C400A:
 			hostdata->c400_ctl_status = 9;
 			hostdata->c400_blk_cnt = 10;
@@ -427,6 +431,7 @@ static int __init generic_NCR5380_detect
 			hostdata->c400_blk_cnt = 0x101;
 			hostdata->c400_host_buf = 0x104;
 			break;
+		case BOARD_DTC3181E:
 		case BOARD_NCR53C400A:
 			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
 			goto out_unregister;
@@ -438,6 +443,7 @@ static int __init generic_NCR5380_detect
 
 		switch (overrides[current_override].board) {
 		case BOARD_NCR53C400:
+		case BOARD_DTC3181E:
 		case BOARD_NCR53C400A:
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 		}
@@ -565,7 +571,11 @@ static inline int NCR5380_pread(struct S
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
@@ -581,7 +591,11 @@ static inline int NCR5380_pread(struct S
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
@@ -639,7 +653,11 @@ static inline int NCR5380_pwrite(struct
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
@@ -654,7 +672,11 @@ static inline int NCR5380_pwrite(struct
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
@@ -675,8 +697,10 @@ static inline int NCR5380_pwrite(struct
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
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:51.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:54.000000000 +1100
@@ -44,7 +44,8 @@
 #define NCR5380_implementation_fields \
 	int c400_ctl_status; \
 	int c400_blk_cnt; \
-	int c400_host_buf;
+	int c400_host_buf; \
+	int io_width;
 
 #else 
 /* therefore SCSI_G_NCR5380_MEM */
