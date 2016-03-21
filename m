From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v3 05/23] ncr5380: Disable the DMA errata workaround flag by default
Date: Mon, 21 Mar 2016 13:31:54 +1100
Message-ID: <20160321023150.983966620@telegraphics.com.au>
References: <20160321023149.604138431@telegraphics.com.au>
Return-path: <linux-m68k-owner@vger.kernel.org>
Content-Disposition: inline; filename=ncr5380-FLAG_DMA_FIXUP
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, linux-arm-kernel@lists.infradead.org
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>
List-Id: linux-scsi@vger.kernel.org

The only chip that needs the workarounds enabled is an early NMOS
device. That means that the common case is to disable them.

Unfortunately the sense of the flag is such that it has to be set
for the common case.

Rename the flag so that zero can be used to mean "no errata workarounds
needed". This simplifies the code.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Michael Schmitz <schmitzmic@gmail.com>

---
 drivers/scsi/NCR5380.c      |   14 +++++++-------
 drivers/scsi/NCR5380.h      |    2 +-
 drivers/scsi/arm/cumana_1.c |    2 +-
 drivers/scsi/arm/oak.c      |    2 +-
 drivers/scsi/dtc.c          |    2 +-
 drivers/scsi/g_NCR5380.c    |    8 +-------
 drivers/scsi/pas16.c        |    2 +-
 drivers/scsi/t128.c         |    2 +-
 8 files changed, 14 insertions(+), 20 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2016-03-21 13:31:10.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2016-03-21 13:31:14.000000000 +1100
@@ -457,7 +457,7 @@ static void prepare_info(struct Scsi_Hos
 	         instance->base, instance->irq,
 	         instance->can_queue, instance->cmd_per_lun,
 	         instance->sg_tablesize, instance->this_id,
-	         hostdata->flags & FLAG_NO_DMA_FIXUP  ? "NO_DMA_FIXUP "  : "",
+	         hostdata->flags & FLAG_DMA_FIXUP     ? "DMA_FIXUP "     : "",
 	         hostdata->flags & FLAG_NO_PSEUDO_DMA ? "NO_PSEUDO_DMA " : "",
 	         hostdata->flags & FLAG_TOSHIBA_DELAY ? "TOSHIBA_DELAY "  : "",
 #ifdef AUTOPROBE_IRQ
@@ -1480,11 +1480,11 @@ static int NCR5380_transfer_dma(struct S
 	 * before the setting of DMA mode to after transfer of the last byte.
 	 */
 
-	if (hostdata->flags & FLAG_NO_DMA_FIXUP)
+	if (hostdata->flags & FLAG_DMA_FIXUP)
+		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
+	else
 		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY |
 		                        MR_ENABLE_EOP_INTR);
-	else
-		NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_MONITOR_BSY);
 
 	dprintk(NDEBUG_DMA, "scsi%d : mode reg = 0x%X\n", instance->host_no, NCR5380_read(MODE_REG));
 
@@ -1540,8 +1540,8 @@ static int NCR5380_transfer_dma(struct S
 
 	if (p & SR_IO) {
 		foo = NCR5380_pread(instance, d,
-			hostdata->flags & FLAG_NO_DMA_FIXUP ? c : c - 1);
-		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
+			hostdata->flags & FLAG_DMA_FIXUP ? c - 1 : c);
+		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
 			 * The workaround was to transfer fewer bytes than we
 			 * intended to with the pseudo-DMA read function, wait for
@@ -1571,7 +1571,7 @@ static int NCR5380_transfer_dma(struct S
 		}
 	} else {
 		foo = NCR5380_pwrite(instance, d, c);
-		if (!foo && !(hostdata->flags & FLAG_NO_DMA_FIXUP)) {
+		if (!foo && (hostdata->flags & FLAG_DMA_FIXUP)) {
 			/*
 			 * Wait for the last byte to be sent.  If REQ is being asserted for
 			 * the byte we're interested, we'll ACK it and it will go false.
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2016-03-21 13:31:10.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2016-03-21 13:31:14.000000000 +1100
@@ -220,7 +220,7 @@
 #define NO_IRQ		0
 #endif
 
-#define FLAG_NO_DMA_FIXUP		1	/* No DMA errata workarounds */
+#define FLAG_DMA_FIXUP			1	/* Use DMA errata workarounds */
 #define FLAG_NO_PSEUDO_DMA		8	/* Inhibit DMA */
 #define FLAG_LATE_DMA_SETUP		32	/* Setup NCR before DMA H/W */
 #define FLAG_TAGGED_QUEUING		64	/* as X3T9.2 spelled it */
Index: linux/drivers/scsi/dtc.c
===================================================================
--- linux.orig/drivers/scsi/dtc.c	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/dtc.c	2016-03-21 13:31:14.000000000 +1100
@@ -229,7 +229,7 @@ found:
 		instance->base = addr;
 		((struct NCR5380_hostdata *)(instance)->hostdata)->base = base;
 
-		if (NCR5380_init(instance, FLAG_NO_DMA_FIXUP))
+		if (NCR5380_init(instance, 0))
 			goto out_unregister;
 
 		NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:09.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-03-21 13:31:14.000000000 +1100
@@ -348,23 +348,17 @@ static int __init generic_NCR5380_detect
 		flags = 0;
 		switch (overrides[current_override].board) {
 		case BOARD_NCR5380:
-			flags = FLAG_NO_PSEUDO_DMA;
-			break;
-		case BOARD_NCR53C400:
-			flags = FLAG_NO_DMA_FIXUP;
+			flags = FLAG_NO_PSEUDO_DMA | FLAG_DMA_FIXUP;
 			break;
 		case BOARD_NCR53C400A:
-			flags = FLAG_NO_DMA_FIXUP;
 			ports = ncr_53c400a_ports;
 			magic = ncr_53c400a_magic;
 			break;
 		case BOARD_HP_C2502:
-			flags = FLAG_NO_DMA_FIXUP;
 			ports = ncr_53c400a_ports;
 			magic = hp_c2502_magic;
 			break;
 		case BOARD_DTC3181E:
-			flags = FLAG_NO_DMA_FIXUP;
 			ports = dtc_3181e_ports;
 			magic = ncr_53c400a_magic;
 			break;
Index: linux/drivers/scsi/arm/cumana_1.c
===================================================================
--- linux.orig/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/arm/cumana_1.c	2016-03-21 13:31:14.000000000 +1100
@@ -239,7 +239,7 @@ static int cumanascsi1_probe(struct expa
 
 	host->irq = ec->irq;
 
-	ret = NCR5380_init(host, 0);
+	ret = NCR5380_init(host, FLAG_DMA_FIXUP);
 	if (ret)
 		goto out_unmap;
 
Index: linux/drivers/scsi/arm/oak.c
===================================================================
--- linux.orig/drivers/scsi/arm/oak.c	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/arm/oak.c	2016-03-21 13:31:14.000000000 +1100
@@ -143,7 +143,7 @@ static int oakscsi_probe(struct expansio
 	host->irq = NO_IRQ;
 	host->n_io_port = 255;
 
-	ret = NCR5380_init(host, 0);
+	ret = NCR5380_init(host, FLAG_DMA_FIXUP);
 	if (ret)
 		goto out_unmap;
 
Index: linux/drivers/scsi/pas16.c
===================================================================
--- linux.orig/drivers/scsi/pas16.c	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/pas16.c	2016-03-21 13:31:14.000000000 +1100
@@ -377,7 +377,7 @@ static int __init pas16_detect(struct sc
 		
 	instance->io_port = io_port;
 
-	if (NCR5380_init(instance, 0))
+	if (NCR5380_init(instance, FLAG_DMA_FIXUP))
 		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
Index: linux/drivers/scsi/t128.c
===================================================================
--- linux.orig/drivers/scsi/t128.c	2016-03-21 13:31:07.000000000 +1100
+++ linux/drivers/scsi/t128.c	2016-03-21 13:31:14.000000000 +1100
@@ -210,7 +210,7 @@ found:
 	instance->base = base;
 	((struct NCR5380_hostdata *)instance->hostdata)->base = p;
 
-	if (NCR5380_init(instance, 0))
+	if (NCR5380_init(instance, FLAG_DMA_FIXUP))
 		goto out_unregister;
 
 	NCR5380_maybe_reset_bus(instance);
