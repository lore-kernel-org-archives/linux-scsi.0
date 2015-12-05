From: Ondrej Zary <linux@rainbow-software.org>
Subject: [RFC PATCH 78/71] ncr5380: Add support for HP 53C400A-based cards (C2502)
Date: Sat,  5 Dec 2015 22:18:51 +0100
Message-ID: <1449350331-28874-1-git-send-email-linux@rainbow-software.org>
References: <20151118083455.331768508@telegraphics.com.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151118083455.331768508@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

HP C2502 cards (based on 53C400A chips) use different magic numbers for
software-based I/O address configuration than other cards.
The configuration is also extended to allow setting the IRQ.

Move the configuration to a new function magic_configure() and move
magic the magic numbers into an array. Add new magic numbers for these
HP cards and hp_53c400a module parameter to use them.

Tested with HP C2502 and DTCT-436P.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |   69 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/g_NCR5380.h |    1 +
 2 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 38579b0..52110e0 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -80,6 +80,7 @@ static int ncr_5380;
 static int ncr_53c400;
 static int ncr_53c400a;
 static int dtc_3181e;
+static int hp_53c400a;
 
 static struct override {
 	NCR5380_map_type NCR5380_map_name;
@@ -225,6 +226,26 @@ static int __init do_DTC3181E_setup(char *str)
 
 #endif
 
+#ifndef SCSI_G_NCR5380_MEM
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
+	/* allowed IRQs for HP 53C400A */
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
@@ -241,8 +262,9 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 	static int current_override;
 	int count;
 	unsigned int *ports;
+	u8 *magic;
 #ifndef SCSI_G_NCR5380_MEM
-	int i;
+	int i, port_idx;
 	unsigned long region_size = 16;
 #endif
 	static unsigned int __initdata ncr_53c400a_ports[] = {
@@ -251,6 +273,12 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 	static unsigned int __initdata dtc_3181e_ports[] = {
 		0x220, 0x240, 0x280, 0x2a0, 0x2c0, 0x300, 0x320, 0x340, 0
 	};
+	static u8 ncr_53c400a_magic[] __initdata = {
+		0x59, 0xb9, 0xc5, 0xae, 0xa6
+	};
+	static u8 hp_53c400a_magic[] __initdata = {
+		0x0f, 0x22, 0xf0, 0x20, 0x80
+	};
 	int flags;
 	struct Scsi_Host *instance;
 	struct NCR5380_hostdata *hostdata;
@@ -273,6 +301,8 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		overrides[0].board = BOARD_NCR53C400A;
 	else if (dtc_3181e)
 		overrides[0].board = BOARD_DTC3181E;
+	else if (hp_53c400a)
+		overrides[0].board = BOARD_HP53C400A;
 #ifndef SCSI_G_NCR5380_MEM
 	if (!current_override && isapnp_present()) {
 		struct pnp_dev *dev = NULL;
@@ -323,13 +353,21 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 			flags = FLAG_NO_PSEUDO_DMA;
 #endif
 			break;
+		case BOARD_HP53C400A:
+			flags = FLAG_NO_DMA_FIXUP;
+			ports = ncr_53c400a_ports;
+			magic = hp_53c400a_magic;
+			overrides[current_override].board = BOARD_NCR53C400A;
+			break;
 		case BOARD_NCR53C400A:
 			flags = FLAG_NO_DMA_FIXUP;
 			ports = ncr_53c400a_ports;
+			magic = ncr_53c400a_magic;
 			break;
 		case BOARD_DTC3181E:
 			flags = FLAG_NO_DMA_FIXUP;
 			ports = dtc_3181e_ports;
+			magic = ncr_53c400a_magic;
 			break;
 		}
 
@@ -338,12 +376,7 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
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
@@ -362,17 +395,14 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
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
-				if (inb(ports[i] + 9) != 0x80)
+				if (inb(ports[i] + 9) != 0x80) {
 					continue;
-				else
+				} else {
 					overrides[current_override].NCR5380_map_name = ports[i];
+					port_idx = i;
+				}
 			} else
 				continue;
 		}
@@ -464,12 +494,18 @@ static int __init generic_NCR5380_detect(struct scsi_host_template *tpnt)
 		if (instance->irq == 255)
 			instance->irq = NO_IRQ;
 
-		if (instance->irq != NO_IRQ)
+		if (instance->irq != NO_IRQ) {
+#ifndef SCSI_G_NCR5380_MEM
+			/* set IRQ for HP 53C400A */
+			if (magic == hp_53c400a_magic)
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
@@ -763,6 +799,7 @@ module_param(ncr_5380, int, 0);
 module_param(ncr_53c400, int, 0);
 module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
+module_param(hp_53c400a, int, 0);
 MODULE_LICENSE("GPL");
 
 #if !defined(SCSI_G_NCR5380_MEM) && defined(MODULE)
diff --git a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
index b3936aa..369ab9e 100644
--- a/drivers/scsi/g_NCR5380.h
+++ b/drivers/scsi/g_NCR5380.h
@@ -89,6 +89,7 @@
 #define BOARD_NCR53C400	1
 #define BOARD_NCR53C400A 2
 #define BOARD_DTC3181E	3
+#define BOARD_HP53C400A 4
 
 #endif /* GENERIC_NCR5380_H */
 
-- 
Ondrej Zary
