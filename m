From: Matthew Wilcox <matthew@wil.cx>
Subject: From: Matthew Wilcox <matthew@wil.cx>
Date: Thu, 15 Dec 2005 16:07:32 -0500
Message-ID: <11346808522151-git-send-email-matthew@wil.cx>
References: <20051215205856.GA2361@parisc-linux.org>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2-old.magma.ca ([206.191.0.250]:6316 "EHLO mx2.magma.ca")
	by vger.kernel.org with ESMTP id S1750983AbVLOVHw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 16:07:52 -0500
In-Reply-To: <20051215205856.GA2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Subject:[PATCH 1/5]"@wil.cx, "[SCSI]"@wil.cx, Move@wil.cx, scsi_print_msg@wil.cx, to@wil.cx, SPI@wil.cx, class@wil.cx, Matthew Wilcox <matthew@wil.cx>

scsi_print_msg() is an SPI-specific concept.  This patch moves it from
constants.c to scsi_transport_spi.c and updates the Kconfig to link in
the SPI class for the drivers which use scsi_print_msg().

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/Kconfig              |   13 ++++
 drivers/scsi/arm/Kconfig          |    1 
 drivers/scsi/constants.c          |  108 -------------------------------------
 drivers/scsi/scsi_transport_spi.c |  109 +++++++++++++++++++++++++++++++++++++
 4 files changed, 123 insertions(+), 108 deletions(-)

4e52663676a39a4d8b1ef3dba470785a98f92e6b
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 20dd85a..4c42065 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -336,6 +336,7 @@ config SCSI_ACARD
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI && !64BIT
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the AHA-1510, AHA-1520, AHA-1522, and AHA-2825
 	  SCSI host adapters. It also works for the AVA-1505, but the IRQ etc.
@@ -623,6 +624,7 @@ config SCSI_OMIT_FLASHPOINT
 config SCSI_DMX3191D
 	tristate "DMX3191D SCSI support"
 	depends on PCI && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is support for Domex DMX3191D SCSI Host Adapters.
 
@@ -632,6 +634,7 @@ config SCSI_DMX3191D
 config SCSI_DTC3280
 	tristate "DTC3180/3280 SCSI support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	help
 	  This is support for DTC 3180/3280 SCSI Host Adapters.  Please read
 	  the SCSI-HOWTO, available from
@@ -752,6 +755,7 @@ config SCSI_GDTH
 config SCSI_GENERIC_NCR5380
 	tristate "Generic NCR5380/53c400 SCSI PIO support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
 	  on boards using PIO. Most boards such as the Trantor T130 fit this
@@ -771,6 +775,7 @@ config SCSI_GENERIC_NCR5380
 config SCSI_GENERIC_NCR5380_MMIO
 	tristate "Generic NCR5380/53c400 SCSI MMIO support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is a driver for the old NCR 53c80 series of SCSI controllers
 	  on boards using memory mapped I/O. 
@@ -1254,6 +1259,7 @@ config SCSI_MCA_53C9X
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.10 of the SCSI-HOWTO, available from
@@ -1423,6 +1429,7 @@ config SCSI_DC390T
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
 	  3.11 of the SCSI-HOWTO, available from
@@ -1681,6 +1688,7 @@ config OKTAGON_SCSI
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
 	depends on ATARI && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have
@@ -1722,6 +1730,7 @@ config TT_DMA_EMUL
 config MAC_SCSI
 	bool "Macintosh NCR5380 SCSI"
 	depends on MAC && SCSI=y
+	select SCSI_SPI_ATTRS
 	help
 	  This is the NCR 5380 SCSI controller included on most of the 68030
 	  based Macintoshes.  If you have one of these say Y and read the
@@ -1743,6 +1752,7 @@ config SCSI_MAC_ESP
 config MVME147_SCSI
 	bool "WD33C93 SCSI driver for MVME147"
 	depends on MVME147 && SCSI=y
+	select SCSI_SPI_ATTRS
 	help
 	  Support for the on-board SCSI controller on the Motorola MVME147
 	  single-board computer.
@@ -1750,6 +1760,7 @@ config MVME147_SCSI
 config MVME16x_SCSI
 	bool "NCR53C710 SCSI driver for MVME16x"
 	depends on MVME16x && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1758,6 +1769,7 @@ config MVME16x_SCSI
 config BVME6000_SCSI
 	bool "NCR53C710 SCSI driver for BVME6000"
 	depends on BVME6000 && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1774,6 +1786,7 @@ config SCSI_NCR53C7xx_FAST
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  This option will enable support for the OBIO (onboard io) NCR5380
 	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
diff --git a/drivers/scsi/arm/Kconfig b/drivers/scsi/arm/Kconfig
index 13f2304..06d7601 100644
--- a/drivers/scsi/arm/Kconfig
+++ b/drivers/scsi/arm/Kconfig
@@ -4,6 +4,7 @@
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
 	depends on ARCH_ACORN && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Acorn SCSI card (aka30). If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a972c1e..30a3353 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1278,114 +1278,6 @@ void scsi_print_req_sense(const char *de
 }
 EXPORT_SYMBOL(scsi_print_req_sense);
 
-#ifdef CONFIG_SCSI_CONSTANTS
-static const char * const one_byte_msgs[] = {
-/* 0x00 */ "Command Complete", NULL, "Save Pointers",
-/* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error", 
-/* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
-/* 0x0a */ "Linked Command Complete", "Linked Command Complete w/flag",
-/* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
-/* 0x0f */ "Initiate Recovery", "Release Recovery"
-};
-#define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
-
-static const char * const two_byte_msgs[] = {
-/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag"
-/* 0x23 */ "Ignore Wide Residue"
-};
-#define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
-
-static const char * const extended_msgs[] = {
-/* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
-/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
-};
-#define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
-
-
-int scsi_print_msg (const unsigned char *msg)
-{
-	int len = 0, i;
-	if (msg[0] == EXTENDED_MESSAGE) {
-		len = 3 + msg[1];
-		if (msg[2] < NO_EXTENDED_MSGS)
-			printk ("%s ", extended_msgs[msg[2]]); 
-		else 
-			printk ("Extended Message, reserved code (0x%02x) ",
-				(int) msg[2]);
-		switch (msg[2]) {
-		case EXTENDED_MODIFY_DATA_POINTER:
-			printk("pointer = %d", (int) (msg[3] << 24) |
-				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
-			break;
-		case EXTENDED_SDTR:
-			printk("period = %d ns, offset = %d",
-				(int) msg[3] * 4, (int) msg[4]);
-			break;
-		case EXTENDED_WDTR:
-			printk("width = 2^%d bytes", msg[3]);
-			break;
-		default:
-		for (i = 2; i < len; ++i) 
-			printk("%02x ", msg[i]);
-		}
-	/* Identify */
-	} else if (msg[0] & 0x80) {
-		printk("Identify disconnect %sallowed %s %d ",
-			(msg[0] & 0x40) ? "" : "not ",
-			(msg[0] & 0x20) ? "target routine" : "lun",
-			msg[0] & 0x7);
-		len = 1;
-	/* Normal One byte */
-	} else if (msg[0] < 0x1f) {
-		if (msg[0] < NO_ONE_BYTE_MSGS)
-			printk(one_byte_msgs[msg[0]]);
-		else
-			printk("reserved (%02x) ", msg[0]);
-		len = 1;
-	/* Two byte */
-	} else if (msg[0] <= 0x2f) {
-		if ((msg[0] - 0x20) < NO_TWO_BYTE_MSGS)
-			printk("%s %02x ", two_byte_msgs[msg[0] - 0x20], 
-				msg[1]);
-		else 
-			printk("reserved two byte (%02x %02x) ", 
-				msg[0], msg[1]);
-		len = 2;
-	} else 
-		printk("reserved");
-	return len;
-}
-EXPORT_SYMBOL(scsi_print_msg);
-
-#else  /* ifndef CONFIG_SCSI_CONSTANTS */
-
-int scsi_print_msg (const unsigned char *msg)
-{
-	int len = 0, i;
-
-	if (msg[0] == EXTENDED_MESSAGE) {
-		len = 3 + msg[1];
-		for (i = 0; i < len; ++i)
-			printk("%02x ", msg[i]);
-	/* Identify */
-	} else if (msg[0] & 0x80) {
-		printk("%02x ", msg[0]);
-		len = 1;
-	/* Normal One byte */
-	} else if (msg[0] < 0x1f) {
-		printk("%02x ", msg[0]);
-		len = 1;
-	/* Two byte */
-	} else if (msg[0] <= 0x2f) {
-		printk("%02x %02x", msg[0], msg[1]);
-		len = 2;
-	} else 
-		printk("%02x ", msg[0]);
-	return len;
-}
-EXPORT_SYMBOL(scsi_print_msg);
-#endif /* ! CONFIG_SCSI_CONSTANTS */
-
 void scsi_print_command(struct scsi_cmnd *cmd)
 {
 	/* Assume appended output (i.e. not at start of line) */
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 4002a98..00a73fc 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -18,6 +18,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/config.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -1047,6 +1048,114 @@ void spi_display_xfer_agreement(struct s
 }
 EXPORT_SYMBOL(spi_display_xfer_agreement);
 
+#ifdef CONFIG_SCSI_CONSTANTS
+static const char * const one_byte_msgs[] = {
+/* 0x00 */ "Command Complete", NULL, "Save Pointers",
+/* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error",
+/* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
+/* 0x0a */ "Linked Command Complete", "Linked Command Complete w/flag",
+/* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue",
+/* 0x0f */ "Initiate Recovery", "Release Recovery"
+};
+#define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
+
+static const char * const two_byte_msgs[] = {
+/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag"
+/* 0x23 */ "Ignore Wide Residue"
+};
+#define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
+
+static const char * const extended_msgs[] = {
+/* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
+/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
+};
+#define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
+
+
+int scsi_print_msg (const unsigned char *msg)
+{
+	int len = 0, i;
+	if (msg[0] == EXTENDED_MESSAGE) {
+		len = 3 + msg[1];
+		if (msg[2] < NO_EXTENDED_MSGS)
+			printk ("%s ", extended_msgs[msg[2]]);
+		else
+			printk ("Extended Message, reserved code (0x%02x) ",
+				(int) msg[2]);
+		switch (msg[2]) {
+		case EXTENDED_MODIFY_DATA_POINTER:
+			printk("pointer = %d", (int) (msg[3] << 24) |
+				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
+			break;
+		case EXTENDED_SDTR:
+			printk("period = %d ns, offset = %d",
+				(int) msg[3] * 4, (int) msg[4]);
+			break;
+		case EXTENDED_WDTR:
+			printk("width = 2^%d bytes", msg[3]);
+			break;
+		default:
+		for (i = 2; i < len; ++i)
+			printk("%02x ", msg[i]);
+		}
+	/* Identify */
+	} else if (msg[0] & 0x80) {
+		printk("Identify disconnect %sallowed %s %d ",
+			(msg[0] & 0x40) ? "" : "not ",
+			(msg[0] & 0x20) ? "target routine" : "lun",
+			msg[0] & 0x7);
+		len = 1;
+	/* Normal One byte */
+	} else if (msg[0] < 0x1f) {
+		if (msg[0] < NO_ONE_BYTE_MSGS)
+			printk(one_byte_msgs[msg[0]]);
+		else
+			printk("reserved (%02x) ", msg[0]);
+		len = 1;
+	/* Two byte */
+	} else if (msg[0] <= 0x2f) {
+		if ((msg[0] - 0x20) < NO_TWO_BYTE_MSGS)
+			printk("%s %02x ", two_byte_msgs[msg[0] - 0x20],
+				msg[1]);
+		else
+			printk("reserved two byte (%02x %02x) ",
+				msg[0], msg[1]);
+		len = 2;
+	} else
+		printk("reserved");
+	return len;
+}
+EXPORT_SYMBOL(scsi_print_msg);
+
+#else  /* ifndef CONFIG_SCSI_CONSTANTS */
+
+int scsi_print_msg (const unsigned char *msg)
+{
+	int len = 0, i;
+
+	if (msg[0] == EXTENDED_MESSAGE) {
+		len = 3 + msg[1];
+		for (i = 0; i < len; ++i)
+			printk("%02x ", msg[i]);
+	/* Identify */
+	} else if (msg[0] & 0x80) {
+		printk("%02x ", msg[0]);
+		len = 1;
+	/* Normal One byte */
+	} else if (msg[0] < 0x1f) {
+		printk("%02x ", msg[0]);
+		len = 1;
+	/* Two byte */
+	} else if (msg[0] <= 0x2f) {
+		printk("%02x %02x", msg[0], msg[1]);
+		len = 2;
+	} else
+		printk("%02x ", msg[0]);
+	return len;
+}
+EXPORT_SYMBOL(scsi_print_msg);
+#endif /* ! CONFIG_SCSI_CONSTANTS */
+
 #define SETUP_ATTRIBUTE(field)						\
 	i->private_attrs[count] = class_device_attr_##field;		\
 	if (!i->f->set_##field) {					\
-- 
0.99.9.GIT

