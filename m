From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 4/5] scsi: delete the MCA specific drivers and driver code
Date: Thu, 17 May 2012 12:40:40 -0400
Message-ID: <1337272841-25931-5-git-send-email-paul.gortmaker@windriver.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40220 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab2EQQlv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 12:41:51 -0400
In-Reply-To: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: JBottomley@parallels.com, Paul Gortmaker <paul.gortmaker@windriver.com>, linux-scsi@vger.kernel.org

The support for CONFIG_MCA is being removed, since the 20
year old hardware simply isn't capable of meeting today's
software demands on CPU and memory resources.

This commit removes the MCA specific SCSI drivers, and the
MCA specific portions of code in dual role ISA/MCA drivers.
Also, the MCA specific SCSI documentation is removed.

Cc: James Bottomley <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 Documentation/scsi/00-INDEX             |    2 -
 Documentation/scsi/ibmmca.txt           | 1402 ------------------
 Documentation/scsi/scsi-parameters.txt  |    6 -
 Documentation/scsi/scsi_mid_low_api.txt |    2 +-
 drivers/scsi/Kconfig                    |   83 --
 drivers/scsi/Makefile                   |    2 -
 drivers/scsi/aha1542.c                  |   66 +-
 drivers/scsi/fd_mcs.c                   | 1354 ------------------
 drivers/scsi/ibmmca.c                   | 2379 -------------------------------
 drivers/scsi/sim710.c                   |  124 +--
 10 files changed, 6 insertions(+), 5414 deletions(-)
 delete mode 100644 Documentation/scsi/ibmmca.txt
 delete mode 100644 drivers/scsi/fd_mcs.c
 delete mode 100644 drivers/scsi/ibmmca.c

diff --git a/Documentation/scsi/00-INDEX b/Documentation/scsi/00-INDEX
index b7dd650..9b0787f 100644
--- a/Documentation/scsi/00-INDEX
+++ b/Documentation/scsi/00-INDEX
@@ -56,8 +56,6 @@ g_NCR5380.txt
 	- info on driver for NCR5380 and NCR53c400 based adapters
 hptiop.txt
 	- HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
-ibmmca.txt
-	- info on driver for IBM adapters with MCA bus
 in2000.txt
 	- info on in2000 driver
 libsas.txt
diff --git a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
deleted file mode 100644
index ac41a9f..0000000
diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index 21e5798..2bfd6f6 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -37,9 +37,6 @@ parameters may be changed at runtime by the command
 
 	eata=		[HW,SCSI]
 
-	fd_mcs=		[HW,SCSI]
-			See header of drivers/scsi/fd_mcs.c.
-
 	fdomain=	[HW,SCSI]
 			See header of drivers/scsi/fdomain.c.
 
@@ -48,9 +45,6 @@ parameters may be changed at runtime by the command
 
 	gvp11=		[HW,SCSI]
 
-	ibmmcascsi=	[HW,MCA,SCSI] IBM MicroChannel SCSI adapter
-			See Documentation/mca.txt.
-
 	in2000=		[HW,SCSI]
 			See header of drivers/scsi/in2000.c.
 
diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index a340b18..2b06aba 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -30,7 +30,7 @@ the motherboard (or both). Some aic7xxx based HBAs are dual controllers
 and thus represent two hosts. Like most modern HBAs, each aic7xxx host
 has its own PCI device address. [The one-to-one correspondence between
 a SCSI host and a PCI device is common but not required (e.g. with
-ISA or MCA adapters).]
+ISA adapters).]
 
 The SCSI mid level isolates an LLD from other layers such as the SCSI
 upper layer drivers and the block layer.
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 29684c8..7a66d0e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -807,19 +807,6 @@ config SCSI_FUTURE_DOMAIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called fdomain.
 
-config SCSI_FD_MCS
-	tristate "Future Domain MCS-600/700 SCSI support"
-	depends on MCA_LEGACY && SCSI
-	---help---
-	  This is support for Future Domain MCS 600/700 MCA SCSI adapters.
-	  Some PS/2 computers are equipped with IBM Fast SCSI Adapter/A which
-	  is identical to the MCS 700 and hence also supported by this driver.
-	  This driver also supports the Reply SB16/SCSI card (the SCSI part).
-	  It supports multiple adapters in the same system.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called fd_mcs.
-
 config SCSI_GDTH
 	tristate "Intel/ICP (former GDT SCSI Disk Array) RAID Controller support"
 	depends on (ISA || EISA || PCI) && SCSI && ISA_DMA_API
@@ -889,76 +876,6 @@ config SCSI_GENERIC_NCR53C400
 	  not detect your card.  See the file
 	  <file:Documentation/scsi/g_NCR5380.txt> for details.
 
-config SCSI_IBMMCA
-	tristate "IBMMCA SCSI support"
-	depends on MCA && SCSI
-	---help---
-	  This is support for the IBM SCSI adapter found in many of the PS/2
-	  series computers.  These machines have an MCA bus, so you need to
-	  answer Y to "MCA support" as well and read
-	  <file:Documentation/mca.txt>.
-
-	  If the adapter isn't found during boot (a common problem for models
-	  56, 57, 76, and 77) you'll need to use the 'ibmmcascsi=<pun>' kernel
-	  option, where <pun> is the id of the SCSI subsystem (usually 7, but
-	  if that doesn't work check your reference diskette).  Owners of
-	  model 95 with a LED-matrix-display can in addition activate some
-	  activity info like under OS/2, but more informative, by setting
-	  'ibmmcascsi=display' as an additional kernel parameter.  Try "man
-	  bootparam" or see the documentation of your boot loader about how to
-	  pass options to the kernel.
-
-	  To compile this driver as a module, choose M here: the
-	  module will be called ibmmca.
-
-config IBMMCA_SCSI_ORDER_STANDARD
-	bool "Standard SCSI-order"
-	depends on SCSI_IBMMCA
-	---help---
-	  In the PC-world and in most modern SCSI-BIOS-setups, SCSI-hard disks
-	  are assigned to the drive letters, starting with the lowest SCSI-id
-	  (physical number -- pun) to be drive C:, as seen from DOS and
-	  similar operating systems. When looking into papers describing the
-	  ANSI-SCSI-standard, this assignment of drives appears to be wrong.
-	  The SCSI-standard follows a hardware-hierarchy which says that id 7
-	  has the highest priority and id 0 the lowest. Therefore, the host
-	  adapters are still today everywhere placed as SCSI-id 7 by default.
-	  In the SCSI-standard, the drive letters express the priority of the
-	  disk. C: should be the hard disk, or a partition on it, with the
-	  highest priority. This must therefore be the disk with the highest
-	  SCSI-id (e.g. 6) and not the one with the lowest! IBM-BIOS kept the
-	  original definition of the SCSI-standard as also industrial- and
-	  process-control-machines, like VME-CPUs running under realtime-OSes
-	  (e.g. LynxOS, OS9) do.
-
-	  If you like to run Linux on your MCA-machine with the same
-	  assignment of hard disks as seen from e.g. DOS or OS/2 on your
-	  machine, which is in addition conformant to the SCSI-standard, you
-	  must say Y here. This is also necessary for MCA-Linux users who want
-	  to keep downward compatibility to older releases of the
-	  IBM-MCA-SCSI-driver (older than driver-release 2.00 and older than
-	  June 1997).
-
-	  If you like to have the lowest SCSI-id assigned as drive C:, as
-	  modern SCSI-BIOSes do, which does not conform to the standard, but
-	  is widespread and common in the PC-world of today, you must say N
-	  here. If unsure, say Y.
-
-config IBMMCA_SCSI_DEV_RESET
-	bool "Reset SCSI-devices at boottime"
-	depends on SCSI_IBMMCA
-	---help---
-	  By default, SCSI-devices are reset when the machine is powered on.
-	  However, some devices exist, like special-control-devices,
-	  SCSI-CNC-machines, SCSI-printer or scanners of older type, that do
-	  not reset when switched on. If you say Y here, each device connected
-	  to your SCSI-bus will be issued a reset-command after it has been
-	  probed, while the kernel is booting. This may cause problems with
-	  more modern devices, like hard disks, which do not appreciate these
-	  reset commands, and can cause your system to hang. So say Y only if
-	  you know that one of your older devices needs it; N is the safe
-	  answer.
-
 config SCSI_IPS
 	tristate "IBM ServeRAID support"
 	depends on PCI && SCSI
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 8deedea..1a3368b 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -75,7 +75,6 @@ obj-$(CONFIG_SCSI_AIC94XX)	+= aic94xx/
 obj-$(CONFIG_SCSI_PM8001)	+= pm8001/
 obj-$(CONFIG_SCSI_ISCI)		+= isci/
 obj-$(CONFIG_SCSI_IPS)		+= ips.o
-obj-$(CONFIG_SCSI_FD_MCS)	+= fd_mcs.o
 obj-$(CONFIG_SCSI_FUTURE_DOMAIN)+= fdomain.o
 obj-$(CONFIG_SCSI_IN2000)	+= in2000.o
 obj-$(CONFIG_SCSI_GENERIC_NCR5380) += g_NCR5380.o
@@ -100,7 +99,6 @@ obj-$(CONFIG_SCSI_SYM53C8XX_2)	+= sym53c8xx_2/
 obj-$(CONFIG_SCSI_ZALON)	+= zalon7xx.o
 obj-$(CONFIG_SCSI_EATA_PIO)	+= eata_pio.o
 obj-$(CONFIG_SCSI_7000FASST)	+= wd7000.o
-obj-$(CONFIG_SCSI_IBMMCA)	+= ibmmca.o
 obj-$(CONFIG_SCSI_EATA)		+= eata.o
 obj-$(CONFIG_SCSI_DC395x)	+= dc395x.o
 obj-$(CONFIG_SCSI_DC390T)	+= tmscsim.o
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index ede91f3..f79c8f9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -22,7 +22,7 @@
  *        Added module command-line options
  *        19-Jul-99
  *  Modified by Adam Fritzler
- *        Added proper detection of the AHA-1640 (MCA version of AHA-1540)
+ *        Added proper detection of the AHA-1640 (MCA, now deleted)
  */
 
 #include <linux/module.h>
@@ -37,8 +37,6 @@
 #include <linux/spinlock.h>
 #include <linux/isapnp.h>
 #include <linux/blkdev.h>
-#include <linux/mca.h>
-#include <linux/mca-legacy.h>
 #include <linux/slab.h>
 
 #include <asm/dma.h>
@@ -71,7 +69,7 @@
 #define MAXBOARDS 4		/* Increase this and the sizes of the
 				   arrays below, if you need more.. */
 
-/* Boards 3,4 slots are reserved for ISAPnP/MCA scans */
+/* Boards 3,4 slots are reserved for ISAPnP scans */
 
 static unsigned int bases[MAXBOARDS] __initdata = {0x330, 0x334, 0, 0};
 
@@ -1009,66 +1007,6 @@ static int __init aha1542_detect(struct scsi_host_template * tpnt)
 #endif
 
 	/*
-	 *	Find MicroChannel cards (AHA1640)
-	 */
-#ifdef CONFIG_MCA_LEGACY
-	if(MCA_bus) {
-		int slot = 0;
-		int pos = 0;
-
-		for (indx = 0; (slot != MCA_NOTFOUND) && (indx < ARRAY_SIZE(bases)); indx++) {
-
-			if (bases[indx])
-				continue;
-
-			/* Detect only AHA-1640 cards -- MCA ID 0F1F */
-			slot = mca_find_unused_adapter(0x0f1f, slot);
-			if (slot == MCA_NOTFOUND)
-				break;
-
-			/* Found one */
-			pos = mca_read_stored_pos(slot, 3);
-
-			/* Decode address */
-			if (pos & 0x80) {
-				if (pos & 0x02) {
-					if (pos & 0x01)
-						bases[indx] = 0x334;
-					else
-						bases[indx] = 0x234;
-				} else {
-					if (pos & 0x01)
-						bases[indx] = 0x134;
-				}
-			} else {
-				if (pos & 0x02) {
-					if (pos & 0x01)
-						bases[indx] = 0x330;
-					else
-						bases[indx] = 0x230;
-				} else {
-					if (pos & 0x01)
-						bases[indx] = 0x130;
-				}
-			}
-
-			/* No need to decode IRQ and Arb level -- those are
-			 * read off the card later.
-			 */
-			printk(KERN_INFO "Found an AHA-1640 in MCA slot %d, I/O 0x%04x\n", slot, bases[indx]);
-
-			mca_set_adapter_name(slot, "Adapter AHA-1640");
-			mca_set_adapter_procfn(slot, NULL, NULL);
-			mca_mark_as_used(slot);
-
-			/* Go on */
-			slot++;
-		}
-
-	}
-#endif
-
-	/*
 	 *	Hunt for ISA Plug'n'Pray Adaptecs (AHA1535)
 	 */
 
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
deleted file mode 100644
index 53bfcaa..0000000
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
deleted file mode 100644
index cd09132..0000000
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index 8ac6ce7..a318264 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -17,7 +17,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  *----------------------------------------------------------------------------
  *
- * MCA card detection code by Trent McNair.
+ * MCA card detection code by Trent McNair. (now deleted)
  * Fixes to not explicitly nul bss data from Xavier Bestel.
  * Some multiboard fixes from Rolf Eike Beer.
  * Auto probing of EISA config space from Trevor Hemsley.
@@ -32,7 +32,6 @@
 #include <linux/blkdev.h>
 #include <linux/device.h>
 #include <linux/init.h>
-#include <linux/mca.h>
 #include <linux/eisa.h>
 #include <linux/interrupt.h>
 #include <scsi/scsi_host.h>
@@ -43,7 +42,7 @@
 #include "53c700.h"
 
 
-/* Must be enough for both EISA and MCA */
+/* Must be enough for EISA */
 #define MAX_SLOTS 8
 static __u8 __initdata id_array[MAX_SLOTS] = { [0 ... MAX_SLOTS-1] = 7 };
 
@@ -89,7 +88,7 @@ param_setup(char *str)
 __setup("sim710=", param_setup);
 
 static struct scsi_host_template sim710_driver_template = {
-	.name			= "LSI (Symbios) 710 MCA/EISA",
+	.name			= "LSI (Symbios) 710 EISA",
 	.proc_name		= "sim710",
 	.this_id		= 7,
 	.module			= THIS_MODULE,
@@ -169,114 +168,6 @@ sim710_device_remove(struct device *dev)
 	return 0;
 }
 
-#ifdef CONFIG_MCA
-
-/* CARD ID 01BB and 01BA use the same pos values */
-#define MCA_01BB_IO_PORTS { 0x0000, 0x0000, 0x0800, 0x0C00, 0x1000, 0x1400, \
-			    0x1800, 0x1C00, 0x2000, 0x2400, 0x2800, \
-			    0x2C00, 0x3000, 0x3400, 0x3800, 0x3C00, \
-			    0x4000, 0x4400, 0x4800, 0x4C00, 0x5000  }
-
-#define MCA_01BB_IRQS { 3, 5, 11, 14 }
-
-/* CARD ID 004f */
-#define MCA_004F_IO_PORTS { 0x0000, 0x0200, 0x0300, 0x0400, 0x0500,  0x0600 }
-#define MCA_004F_IRQS { 5, 9, 14 }
-
-static short sim710_mca_id_table[] = { 0x01bb, 0x01ba, 0x004f, 0};
-
-static __init int
-sim710_mca_probe(struct device *dev)
-{
-	struct mca_device *mca_dev = to_mca_device(dev);
-	int slot = mca_dev->slot;
-	int pos[3];
-	unsigned int base;
-	int irq_vector;
-	short id = sim710_mca_id_table[mca_dev->index];
-	static int io_004f_by_pos[] = MCA_004F_IO_PORTS;
-	static int irq_004f_by_pos[] = MCA_004F_IRQS;
-	static int io_01bb_by_pos[] = MCA_01BB_IO_PORTS;
-	static int irq_01bb_by_pos[] = MCA_01BB_IRQS;
-	char *name;
-	int clock;
-
-	pos[0] = mca_device_read_stored_pos(mca_dev, 2);
-	pos[1] = mca_device_read_stored_pos(mca_dev, 3);
-	pos[2] = mca_device_read_stored_pos(mca_dev, 4);
-
-	/*
-	 * 01BB & 01BA port base by bits 7,6,5,4,3,2 in pos[2]
-	 *
-	 *    000000  <disabled>   001010  0x2800
-	 *    000001  <invalid>    001011  0x2C00
-	 *    000010  0x0800       001100  0x3000
-	 *    000011  0x0C00       001101  0x3400
-	 *    000100  0x1000       001110  0x3800
-	 *    000101  0x1400       001111  0x3C00
-	 *    000110  0x1800       010000  0x4000
-	 *    000111  0x1C00       010001  0x4400
-	 *    001000  0x2000       010010  0x4800
-	 *    001001  0x2400       010011  0x4C00
-	 *                         010100  0x5000
-	 *
-	 * 00F4 port base by bits 3,2,1 in pos[0]
-	 *
-	 *    000  <disabled>      001    0x200
-	 *    010  0x300           011    0x400
-	 *    100  0x500           101    0x600
-	 *
-	 * 01BB & 01BA IRQ is specified in pos[0] bits 7 and 6:
-	 *
-	 *    00   3               10   11
-	 *    01   5               11   14
-	 *
-	 * 00F4 IRQ specified by bits 6,5,4 in pos[0]
-	 *
-	 *    100   5              101    9
-	 *    110   14
-	 */
-
-	if (id == 0x01bb || id == 0x01ba) {
-		base = io_01bb_by_pos[(pos[2] & 0xFC) >> 2];
-		irq_vector =
-			irq_01bb_by_pos[((pos[0] & 0xC0) >> 6)];
-
-		clock = 50;
-		if (id == 0x01bb)
-			name = "NCR 3360/3430 SCSI SubSystem";
-		else
-			name = "NCR Dual SIOP SCSI Host Adapter Board";
-	} else if ( id == 0x004f ) {
-		base = io_004f_by_pos[((pos[0] & 0x0E) >> 1)];
-		irq_vector =
-			irq_004f_by_pos[((pos[0] & 0x70) >> 4) - 4];
-		clock = 50;
-		name = "NCR 53c710 SCSI Host Adapter Board";
-	} else {
-		return -ENODEV;
-	}
-	mca_device_set_name(mca_dev, name);
-	mca_device_set_claim(mca_dev, 1);
-	base = mca_device_transform_ioport(mca_dev, base);
-	irq_vector = mca_device_transform_irq(mca_dev, irq_vector);
-
-	return sim710_probe_common(dev, base, irq_vector, clock,
-				   0, id_array[slot]);
-}
-
-static struct mca_driver sim710_mca_driver = {
-	.id_table		= sim710_mca_id_table,
-	.driver = {
-		.name		= "sim710",
-		.bus		= &mca_bus_type,
-		.probe		= sim710_mca_probe,
-		.remove		= __devexit_p(sim710_device_remove),
-	},
-};
-
-#endif /* CONFIG_MCA */
-
 #ifdef CONFIG_EISA
 static struct eisa_device_id sim710_eisa_ids[] = {
 	{ "CPQ4410" },
@@ -344,10 +235,6 @@ static int __init sim710_init(void)
 		param_setup(sim710);
 #endif
 
-#ifdef CONFIG_MCA
-	err = mca_register_driver(&sim710_mca_driver);
-#endif
-
 #ifdef CONFIG_EISA
 	err = eisa_driver_register(&sim710_eisa_driver);
 #endif
@@ -361,11 +248,6 @@ static int __init sim710_init(void)
 
 static void __exit sim710_exit(void)
 {
-#ifdef CONFIG_MCA
-	if (MCA_bus)
-		mca_unregister_driver(&sim710_mca_driver);
-#endif
-
 #ifdef CONFIG_EISA
 	eisa_driver_unregister(&sim710_eisa_driver);
 #endif
-- 
1.7.9.1

