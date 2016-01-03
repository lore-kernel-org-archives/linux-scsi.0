From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v4 78/78] ncr5380: Add support for HP C2502
Date: Sun, 03 Jan 2016 16:06:19 +1100
Message-ID: <20160103050523.673601273@telegraphics.com.au>
References: <20160103050501.042035135@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=78-71
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

From: Ondrej Zary <linux@rainbow-software.org>

HP C2502 cards (based on 53C400A chips) use different magic numbers for
software-based I/O address configuration than other cards.
The configuration is also extended to allow setting the IRQ.

Move the configuration to a new function magic_configure() and move
magic the magic numbers into an array. Add new magic numbers for these
HP cards and hp_c2502 module parameter to use them, e.g.:
modprobe g_NCR5380 ncr_irq=7 ncr_addr=0x280 hp_c2502=1

Tested with HP C2502 and DTCT-436P.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---

Changes to Ondrej's versions:
- Omit a redundant comment.
- Throw an error if MMIO register locations are not known.
- Avoid 'if (...) { ... continue; } else { ... }'
- Fix "warning: 'port_idx' may be used uninitialized" and
  "warning: 'magic' may be used uninitialized" for port-mapped config.
- Rebased.

---
 drivers/scsi/g_NCR5380.c |   74 ++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/g_NCR5380.h |    1 
 2 files changed, 59 insertions(+), 16 deletions(-)

Index: linux/drivers/scsi/g_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:55.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.c	2016-01-03 16:04:56.000000000 +1100
@@ -80,6 +80,7 @@ static int ncr_5380;
 static int ncr_53c400;
 static int ncr_53c400a;
 static int dtc_3181e;
+static int hp_c2502;
 
 static struct override {
 	NCR5380_map_type NCR5380_map_name;
@@ -225,6 +226,30 @@ static int __init do_DTC3181E_setup(char
 
 #endif
 
+#ifndef SCSI_G_NCR5380_MEM
+/*
+ * Configure I/O address of 53C400A or DTC436 by writing magic numbers
+ * to ports 0x779 and 0x379.
+ */
+static void magic_configure(int idx, u8 irq, u8 magic[])
+{
+	u8 cfg = 0;
+
+	outb(magic[0], 0x779);
+	outb(magic[1], 0x379);
+	outb(magic[2], 0x379);
+	outb(magic[3], 0x379);
+	outb(magic[4], 0x379);
+
+	/* allowed IRQs for HP C2502 */
+	if (irq != 2 && irq != 3 && irq != 4 && irq != 5 && irq != 7)
+		irq = 0;
+	if (idx >= 0 && idx <= 7)
+		cfg = 0x80 | idx | (irq << 4);
+	outb(cfg, 0x379);
+}
+#endif
+
 /**
  * 	generic_NCR5380_detect	-	look for NCR5380 controllers
  *	@tpnt: the scsi template
@@ -241,8 +266,10 @@ static int __init generic_NCR5380_detect
 	static int current_override;
 	int count;
 	unsigned int *ports;
+	u8 *magic = NULL;
 #ifndef SCSI_G_NCR5380_MEM
 	int i;
+	int port_idx = -1;
 	unsigned long region_size = 16;
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
@@ -251,6 +278,12 @@ static int __init generic_NCR5380_detect
 	static unsigned int __initdata dtc_3181e_ports[] = {
 		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
 	};
+	static u8 ncr_53c400a_magic[] __initdata = {	/* 53C400A & DTC436 */
+		0x59, 0xb9, 0xc5, 0xae, 0xa6
+	};
+	static u8 hp_c2502_magic[] __initdata = {	/* HP C2502 */
+		0x0f, 0x22, 0xf0, 0x20, 0x80
+	};
 	int flags;
 	struct Scsi_Host *instance;
 	struct NCR5380_hostdata *hostdata;
@@ -273,6 +306,8 @@ static int __init generic_NCR5380_detect
 		overrides[0].board = BOARD_NCR53C400A;
 	else if (dtc_3181e)
 		overrides[0].board = BOARD_DTC3181E;
+	else if (hp_c2502)
+		overrides[0].board = BOARD_HP_C2502;
 #ifndef SCSI_G_NCR5380_MEM
 	if (!current_override && isapnp_present()) {
 		struct pnp_dev *dev = NULL;
@@ -325,24 +360,26 @@ static int __init generic_NCR5380_detect
 		case BOARD_NCR53C400A:
 			flags = FLAG_NO_DMA_FIXUP;
 			ports = ncr_53c400a_ports;
+			magic = ncr_53c400a_magic;
+			break;
+		case BOARD_HP_C2502:
+			flags = FLAG_NO_DMA_FIXUP;
+			ports = ncr_53c400a_ports;
+			magic = hp_c2502_magic;
 			break;
 		case BOARD_DTC3181E:
 			flags = FLAG_NO_DMA_FIXUP;
 			ports = dtc_3181e_ports;
+			magic = ncr_53c400a_magic;
 			break;
 		}
 
 #ifndef SCSI_G_NCR5380_MEM
-		if (ports) {
+		if (ports && magic) {
 			/* wakeup sequence for the NCR53C400A and DTC3181E */
 
 			/* Disable the adapter and look for a free io port */
-			outb(0x59, 0x779);
-			outb(0xb9, 0x379);
-			outb(0xc5, 0x379);
-			outb(0xae, 0x379);
-			outb(0xa6, 0x379);
-			outb(0x00, 0x379);
+			magic_configure(-1, 0, magic);
 
 			if (overrides[current_override].NCR5380_map_name != PORT_AUTO)
 				for (i = 0; ports[i]; i++) {
@@ -361,17 +398,12 @@ static int __init generic_NCR5380_detect
 				}
 			if (ports[i]) {
 				/* At this point we have our region reserved */
-				outb(0x59, 0x779);
-				outb(0xb9, 0x379);
-				outb(0xc5, 0x379);
-				outb(0xae, 0x379);
-				outb(0xa6, 0x379);
-				outb(0x80 | i, 0x379);	/* set io port to be used */
+				magic_configure(i, 0, magic); /* no IRQ yet */
 				outb(0xc0, ports[i] + 9);
 				if (inb(ports[i] + 9) != 0x80)
 					continue;
-				else
-					overrides[current_override].NCR5380_map_name = ports[i];
+				overrides[current_override].NCR5380_map_name = ports[i];
+				port_idx = i;
 			} else
 				continue;
 		}
@@ -417,6 +449,7 @@ static int __init generic_NCR5380_detect
 			hostdata->io_width = 2;	/* 16-bit PDMA */
 			/* fall through */
 		case BOARD_NCR53C400A:
+		case BOARD_HP_C2502:
 			hostdata->c400_ctl_status = 9;
 			hostdata->c400_blk_cnt = 10;
 			hostdata->c400_host_buf = 8;
@@ -433,6 +466,7 @@ static int __init generic_NCR5380_detect
 			break;
 		case BOARD_DTC3181E:
 		case BOARD_NCR53C400A:
+		case BOARD_HP_C2502:
 			pr_err(DRV_MODULE_NAME ": unknown register offsets\n");
 			goto out_unregister;
 		}
@@ -445,6 +479,7 @@ static int __init generic_NCR5380_detect
 		case BOARD_NCR53C400:
 		case BOARD_DTC3181E:
 		case BOARD_NCR53C400A:
+		case BOARD_HP_C2502:
 			NCR5380_write(hostdata->c400_ctl_status, CSR_BASE);
 		}
 
@@ -459,12 +494,18 @@ static int __init generic_NCR5380_detect
 		if (instance->irq == 255)
 			instance->irq = NO_IRQ;
 
-		if (instance->irq != NO_IRQ)
+		if (instance->irq != NO_IRQ) {
+#ifndef SCSI_G_NCR5380_MEM
+			/* set IRQ for HP C2502 */
+			if (overrides[current_override].board == BOARD_HP_C2502)
+				magic_configure(port_idx, instance->irq, magic);
+#endif
 			if (request_irq(instance->irq, generic_NCR5380_intr,
 					0, "NCR5380", instance)) {
 				printk(KERN_WARNING "scsi%d : IRQ%d not free, interrupts disabled\n", instance->host_no, instance->irq);
 				instance->irq = NO_IRQ;
 			}
+		}
 
 		if (instance->irq == NO_IRQ) {
 			printk(KERN_INFO "scsi%d : interrupts not enabled. for better interactive performance,\n", instance->host_no);
@@ -751,6 +792,7 @@ module_param(ncr_5380, int, 0);
 module_param(ncr_53c400, int, 0);
 module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
+module_param(hp_c2502, int, 0);
 MODULE_LICENSE("GPL");
 
 #if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
Index: linux/drivers/scsi/g_NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:54.000000000 +1100
+++ linux/drivers/scsi/g_NCR5380.h	2016-01-03 16:04:56.000000000 +1100
@@ -88,6 +88,7 @@
 #define BOARD_NCR53C400	1
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
+#define BOARD_HP_C2502	4
 
 #endif /* GENERIC_NCR5380_H */
 
