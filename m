From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Move scsi_print_msg to SPI code
Date: Tue, 13 Dec 2005 09:53:42 -0700
Message-ID: <20051213165342.GM9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44177 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1030182AbVLMQxn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 11:53:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


scsi_print_msg got the transfer period translation to nanoseconds wrong.
We have the right code to do this in scsi_transport_spi.c, but we can't
guarantee that'll be linked in.  scsi_print_msg is a bit of a misnomer
anyway, since these messages are actually SPI messages, not SAM.

So I've moved scsi_print_msg to scsi_transport_spi.c and renamed it to
spi_print_msg.  All drivers that use scsi_print_msg() got converted,
and the Kconfig was adjusted to link in the SPI transport code for
those drivers.  Note that those drivers haven't been converted to use
the SPI transport code ... but surely it's just a matter of time.

This patch doesn't actually apply to anything except the current
parisc-linux CVS tree.  I'm expecting feedback, and I'll submit something
that applies after adjusting for feedback.

Index: drivers/scsi/53c700.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/53c700.c,v
retrieving revision 1.20
diff -u -p -r1.20 53c700.c
--- drivers/scsi/53c700.c	12 Nov 2005 04:08:09 -0000	1.20
+++ drivers/scsi/53c700.c	13 Dec 2005 15:46:09 -0000
@@ -858,7 +858,7 @@ process_extended_message(struct Scsi_Hos
 		printk(KERN_INFO "scsi%d (%d:%d): Unexpected message %s: ",
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
-		scsi_print_msg(hostdata->msgin);
+		spi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
@@ -888,7 +888,7 @@ process_message(struct Scsi_Host *host,	
 #ifdef NCR_700_DEBUG
 	printk("scsi%d (%d:%d): message %s: ", host->host_no, pun, lun,
 	       NCR_700_phase[(dsps & 0xf00) >> 8]);
-	scsi_print_msg(hostdata->msgin);
+	spi_print_msg(hostdata->msgin);
 	printk("\n");
 #endif
 
@@ -940,7 +940,7 @@ process_message(struct Scsi_Host *host,	
 		       host->host_no, pun, lun,
 		       NCR_700_phase[(dsps & 0xf00) >> 8]);
 
-		scsi_print_msg(hostdata->msgin);
+		spi_print_msg(hostdata->msgin);
 		printk("\n");
 		/* just reject it */
 		hostdata->msgout[0] = A_REJECT_MSG;
Index: drivers/scsi/53c7xx.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/53c7xx.c,v
retrieving revision 1.8
diff -u -p -r1.8 53c7xx.c
--- drivers/scsi/53c7xx.c	12 Nov 2005 04:08:09 -0000	1.8
+++ drivers/scsi/53c7xx.c	13 Dec 2005 16:32:18 -0000
@@ -282,6 +282,7 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "53c7xx.h"
 #include <linux/stat.h>
 #include <linux/stddef.h>
@@ -1724,7 +1725,7 @@ NCR53c7xx_run_tests (struct Scsi_Host *h
 		printk ("scsi%d : status ", host->host_no);
 		scsi_print_status (status);
 		printk ("\nscsi%d : message ", host->host_no);
-		scsi_print_msg (&msg);
+		spi_print_msg (&msg);
 		printk ("\n");
 	    } else if (hostdata->test_completed == 3) {
 		printk("scsi%d : test 2 no connection with target %d\n",
@@ -2313,7 +2314,7 @@ NCR53c7x0_dstat_sir_intr (struct Scsi_Ho
 	    printk ("scsi%d : received message", host->host_no);
 	    if (c) 
 	    	printk (" from target %d lun %d ", c->device->id, c->device->lun);
-	    scsi_print_msg ((unsigned char *) hostdata->msg_buf);
+	    spi_print_msg ((unsigned char *) hostdata->msg_buf);
 	    printk("\n");
 	}
 	
@@ -5540,7 +5541,7 @@ print_dsa (struct Scsi_Host *host, u32 *
 	    i > 0 && !check_address ((unsigned long) ptr, 1);
 	    ptr += len, i -= len) {
 	    printk("               ");
-	    len = scsi_print_msg (ptr);
+	    len = spi_print_msg (ptr);
 	    printk("\n");
 	    if (!len)
 		break;
Index: drivers/scsi/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/Kconfig,v
retrieving revision 1.45
diff -u -p -r1.45 Kconfig
--- drivers/scsi/Kconfig	12 Dec 2005 16:35:31 -0000	1.45
+++ drivers/scsi/Kconfig	13 Dec 2005 15:43:59 -0000
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
@@ -1255,6 +1260,7 @@ config SCSI_MCA_53C9X
 config SCSI_PAS16
 	tristate "PAS16 SCSI support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter.  It is explained in section
 	  3.10 of the SCSI-HOWTO, available from
@@ -1424,6 +1430,7 @@ config SCSI_DC390T
 config SCSI_T128
 	tristate "Trantor T128/T128F/T228 SCSI support"
 	depends on ISA && SCSI
+	select SCSI_SPI_ATTRS
 	---help---
 	  This is support for a SCSI host adapter. It is explained in section
 	  3.11 of the SCSI-HOWTO, available from
@@ -1682,6 +1689,7 @@ config OKTAGON_SCSI
 config ATARI_SCSI
 	tristate "Atari native SCSI support"
 	depends on ATARI && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	---help---
 	  If you have an Atari with built-in NCR5380 SCSI controller (TT,
 	  Falcon, ...) say Y to get it supported. Of course also, if you have
@@ -1723,6 +1731,7 @@ config TT_DMA_EMUL
 config MAC_SCSI
 	bool "Macintosh NCR5380 SCSI"
 	depends on MAC && SCSI=y
+	select SCSI_SPI_ATTRS
 	help
 	  This is the NCR 5380 SCSI controller included on most of the 68030
 	  based Macintoshes.  If you have one of these say Y and read the
@@ -1744,6 +1753,7 @@ config SCSI_MAC_ESP
 config MVME147_SCSI
 	bool "WD33C93 SCSI driver for MVME147"
 	depends on MVME147 && SCSI=y
+	select SCSI_SPI_ATTRS
 	help
 	  Support for the on-board SCSI controller on the Motorola MVME147
 	  single-board computer.
@@ -1751,6 +1761,7 @@ config MVME147_SCSI
 config MVME16x_SCSI
 	bool "NCR53C710 SCSI driver for MVME16x"
 	depends on MVME16x && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  The Motorola MVME162, 166, 167, 172 and 177 boards use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1759,6 +1770,7 @@ config MVME16x_SCSI
 config BVME6000_SCSI
 	bool "NCR53C710 SCSI driver for BVME6000"
 	depends on BVME6000 && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  The BVME4000 and BVME6000 boards from BVM Ltd use the NCR53C710
 	  SCSI controller chip.  Almost everyone using one of these boards
@@ -1775,6 +1787,7 @@ config SCSI_NCR53C7xx_FAST
 config SUN3_SCSI
 	tristate "Sun3 NCR5380 SCSI"
 	depends on SUN3 && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  This option will enable support for the OBIO (onboard io) NCR5380
 	  SCSI controller found in the Sun 3/50 and 3/60, as well as for
Index: drivers/scsi/NCR5380.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/NCR5380.c,v
retrieving revision 1.14
diff -u -p -r1.14 NCR5380.c
--- drivers/scsi/NCR5380.c	12 Nov 2005 04:08:09 -0000	1.14
+++ drivers/scsi/NCR5380.c	13 Dec 2005 16:32:29 -0000
@@ -87,6 +87,7 @@
  *      the high level code.
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 #ifndef NDEBUG
 #define NDEBUG 0
@@ -2377,7 +2378,7 @@ static void NCR5380_information_transfer
  * 3..length+1  arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 					extended_msg[0] = EXTENDED_MESSAGE;
 					/* Accept first byte by clearing ACK */
@@ -2424,7 +2425,7 @@ static void NCR5380_information_transfer
 				default:
 					if (!tmp) {
 						printk("scsi%d: rejecting message ", instance->host_no);
-						scsi_print_msg(extended_msg);
+						spi_print_msg(extended_msg);
 						printk("\n");
 					} else if (tmp != EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
@@ -2560,7 +2561,7 @@ static void NCR5380_reselect(struct Scsi
 
 	if (!(msg[0] & 0x80)) {
 		printk(KERN_ERR "scsi%d : expecting IDENTIFY message, got ", instance->host_no);
-		scsi_print_msg(msg);
+		spi_print_msg(msg);
 		abort = 1;
 	} else {
 		/* Accept message by clearing ACK */
Index: drivers/scsi/aha152x.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/aha152x.c,v
retrieving revision 1.17
diff -u -p -r1.17 aha152x.c
--- drivers/scsi/aha152x.c	12 Nov 2005 04:08:09 -0000	1.17
+++ drivers/scsi/aha152x.c	13 Dec 2005 16:32:33 -0000
@@ -259,6 +259,7 @@
 #include "scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "aha152x.h"
 
 
@@ -1845,7 +1846,7 @@ static void msgi_run(struct Scsi_Host *s
 #if defined(AHA152X_DEBUG)
 		if (HOSTDATA(shpnt)->debug & debug_msgi) {
 			printk(INFO_LEAD "inbound message %02x ", CMDINFO(CURRENT_SC), MSGI(0));
-			scsi_print_msg(&MSGI(0));
+			spi_print_msg(&MSGI(0));
 			printk("\n");
 		}
 #endif
@@ -1933,7 +1934,7 @@ static void msgi_run(struct Scsi_Host *s
 						break;
 
 					printk(INFO_LEAD, CMDINFO(CURRENT_SC));
-					scsi_print_msg(&MSGI(0));
+					spi_print_msg(&MSGI(0));
 					printk("\n");
 
 					ticks = (MSGI(3) * 4 + 49) / 50;
@@ -2031,7 +2032,7 @@ static void msgo_init(struct Scsi_Host *
 		int i;
 
 		printk(DEBUG_LEAD "messages( ", CMDINFO(CURRENT_SC));
-		for (i=0; i<MSGOLEN; i+=scsi_print_msg(&MSGO(i)), printk(" "))
+		for (i=0; i<MSGOLEN; i+=spi_print_msg(&MSGO(i)), printk(" "))
 			;
 		printk(")\n");
 	}
Index: drivers/scsi/atari_NCR5380.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/atari_NCR5380.c,v
retrieving revision 1.5
diff -u -p -r1.5 atari_NCR5380.c
--- drivers/scsi/atari_NCR5380.c	12 Nov 2005 04:08:09 -0000	1.5
+++ drivers/scsi/atari_NCR5380.c	13 Dec 2005 16:32:38 -0000
@@ -74,6 +74,7 @@
  *     the high level code.
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 #if (NDEBUG & NDEBUG_LISTS)
 #define LIST(x,y) \
@@ -2355,7 +2356,7 @@ static void NCR5380_information_transfer
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2408,7 +2409,7 @@ static void NCR5380_information_transfer
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			scsi_print_msg (extended_msg);
+			spi_print_msg (extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2541,7 +2542,7 @@ static void NCR5380_reselect (struct Scs
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
Index: drivers/scsi/constants.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/constants.c,v
retrieving revision 1.13
diff -u -p -r1.13 constants.c
--- drivers/scsi/constants.c	13 Dec 2005 00:01:16 -0000	1.13
+++ drivers/scsi/constants.c	13 Dec 2005 15:49:47 -0000
@@ -1271,119 +1271,6 @@ void scsi_print_req_sense(const char *de
 }
 EXPORT_SYMBOL(scsi_print_req_sense);
 
-#ifdef CONFIG_SCSI_CONSTANTS
-static const char *one_byte_msgs[] = {
-/* 0x00 */ "Command Complete", NULL, "Save Pointers",
-/* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error", 
-/* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
-/* 0x0a */ "Linked Command Complete", "Linked Command Complete w/flag",
-/* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
-/* 0x0f */ "Initiate Recovery", "Release Recovery"
-};
-#define NO_ONE_BYTE_MSGS ARRAY_SIZE(one_byte_msgs)
-
-static const char *two_byte_msgs[] = {
-/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
-/* 0x23 */ "Ignore Wide Residue"
-};
-#define NO_TWO_BYTE_MSGS ARRAY_SIZE(two_byte_msgs)
-
-static const char *extended_msgs[] = {
-/* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
-/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request",
-/* 0x04 */ "Parallel Protocol Request"
-};
-#define NO_EXTENDED_MSGS ARRAY_SIZE(extended_msgs)
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
-		case EXTENDED_PPR:
-			printk("period = %d ns, offset = %d, width = %d",
-				(int) msg[3] * 4, (int) msg[5], 1 << msg[6]);
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
Index: drivers/scsi/ncr53c8xx.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/ncr53c8xx.c,v
retrieving revision 1.37
diff -u -p -r1.37 ncr53c8xx.c
--- drivers/scsi/ncr53c8xx.c	12 Dec 2005 19:01:54 -0000	1.37
+++ drivers/scsi/ncr53c8xx.c	13 Dec 2005 15:46:40 -0000
@@ -3701,7 +3701,7 @@ static void ncr_print_msg(struct ccb *cp
 {
 	PRINT_ADDR(cp->cmd, "%s: ", label);
 
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	printk("\n");
 }
 
Index: drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.23
diff -u -p -r1.23 scsi_transport_spi.c
--- drivers/scsi/scsi_transport_spi.c	4 Dec 2005 07:25:10 -0000	1.23
+++ drivers/scsi/scsi_transport_spi.c	13 Dec 2005 16:11:45 -0000
@@ -18,6 +18,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
  */
+#include <linux/config.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/module.h>
@@ -378,9 +379,7 @@ static CLASS_DEVICE_ATTR(revalidate, S_I
 
 /* Translate the period into ns according to the current spec
  * for SDTR/PPR messages */
-static ssize_t
-show_spi_transport_period_helper(struct class_device *cdev, char *buf,
-				 int period)
+static int period_to_str(char *buf, int period)
 {
 	int len, picosec;
 
@@ -398,6 +397,13 @@ show_spi_transport_period_helper(struct 
 		len = sprint_frac(buf, picosec, 1000);
 	}
 
+	return len;
+}
+
+static ssize_t
+show_spi_transport_period_helper(char *buf, int period)
+{
+	int len = period_to_str(buf, period);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -452,7 +458,7 @@ show_spi_transport_period(struct class_d
 	if (i->f->get_period)
 		i->f->get_period(starget);
 
-	return show_spi_transport_period_helper(cdev, buf, tp->period);
+	return show_spi_transport_period_helper(buf, tp->period);
 }
 
 static ssize_t
@@ -487,7 +493,7 @@ show_spi_transport_min_period(struct cla
 	struct spi_transport_attrs *tp =
 		(struct spi_transport_attrs *)&starget->starget_data;
 
-	return show_spi_transport_period_helper(cdev, buf, tp->min_period);
+	return show_spi_transport_period_helper(buf, tp->min_period);
 }
 
 static ssize_t
@@ -1046,6 +1052,133 @@ void spi_display_xfer_agreement(struct s
 	}
 }
 EXPORT_SYMBOL(spi_display_xfer_agreement);
+
+#ifdef CONFIG_SCSI_CONSTANTS
+static const char *one_byte_msgs[] = {
+/* 0x00 */ "Command Complete", NULL, "Save Pointers",
+/* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error", 
+/* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
+/* 0x0a */ "Linked Command Complete", "Linked Command Complete w/flag",
+/* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
+/* 0x0f */ "Initiate Recovery", "Release Recovery"
+};
+
+static const char *two_byte_msgs[] = {
+/* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
+/* 0x23 */ "Ignore Wide Residue"
+};
+
+static const char *extended_msgs[] = {
+/* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
+/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request",
+/* 0x04 */ "Parallel Protocol Request"
+};
+
+static void print_period(unsigned char per)
+{
+	char buf[20];
+	period_to_str(buf, per);
+	printk("period %s ", buf);
+}
+
+static void print_offset(unsigned char off)
+{
+	printk("offset %d ", off);
+}
+
+static void print_width(unsigned char width)
+{
+	printk("width = %d ", 8 << width);
+}
+
+int spi_print_msg(const unsigned char *msg)
+{
+	int len = 0, i;
+	if (msg[0] == EXTENDED_MESSAGE) {
+		len = 3 + msg[1];
+		if (msg[2] < ARRAY_SIZE(extended_msgs))
+			printk ("%s ", extended_msgs[msg[2]]); 
+		else 
+			printk ("Extended Message, reserved code (0x%02x) ",
+				(int) msg[2]);
+		switch (msg[2]) {
+		case EXTENDED_MODIFY_DATA_POINTER:
+			printk("pointer = %d ", (msg[3] << 24) |
+				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
+			break;
+		case EXTENDED_SDTR:
+			print_period(msg[3]);
+			print_offset(msg[4]);
+			break;
+		case EXTENDED_WDTR:
+			print_width(msg[3]);
+			break;
+		case EXTENDED_PPR:
+			print_period(msg[3]);
+			print_offset(msg[5]);
+			print_width(msg[6]);
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
+		if (msg[0] < ARRAY_SIZE(one_byte_msgs))
+			printk("%s ", one_byte_msgs[msg[0]]);
+		else
+			printk("reserved (%02x) ", msg[0]);
+		len = 1;
+	/* Two byte */
+	} else if (msg[0] <= 0x2f) {
+		if ((msg[0] - 0x20) < ARRAY_SIZE(two_byte_msgs))
+			printk("%s %02x ", two_byte_msgs[msg[0] - 0x20], 
+				msg[1]);
+		else 
+			printk("reserved two byte (%02x %02x) ", 
+				msg[0], msg[1]);
+		len = 2;
+	} else 
+		printk("reserved ");
+	return len;
+}
+EXPORT_SYMBOL(spi_print_msg);
+
+#else  /* ifndef CONFIG_SCSI_CONSTANTS */
+
+int spi_print_msg (const unsigned char *msg)
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
+EXPORT_SYMBOL(spi_print_msg);
+#endif /* ! CONFIG_SCSI_CONSTANTS */
 
 #define SETUP_ATTRIBUTE(field)						\
 	i->private_attrs[count] = class_device_attr_##field;		\
Index: drivers/scsi/sun3_NCR5380.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sun3_NCR5380.c,v
retrieving revision 1.5
diff -u -p -r1.5 sun3_NCR5380.c
--- drivers/scsi/sun3_NCR5380.c	12 Nov 2005 04:08:11 -0000	1.5
+++ drivers/scsi/sun3_NCR5380.c	13 Dec 2005 16:32:48 -0000
@@ -70,6 +70,7 @@
  *
  */
 #include <scsi/scsi_dbg.h>
+#include <scsi/scsi_transport_spi.h>
 
 /*
  * Further development / testing that should be done : 
@@ -2378,7 +2379,7 @@ static void NCR5380_information_transfer
  * 3..length+1	arguments
  *
  * Start the extended message buffer with the EXTENDED_MESSAGE
- * byte, since scsi_print_msg() wants the whole thing.  
+ * byte, since spi_print_msg() wants the whole thing.  
  */
 		    extended_msg[0] = EXTENDED_MESSAGE;
 		    /* Accept first byte by clearing ACK */
@@ -2431,7 +2432,7 @@ static void NCR5380_information_transfer
 		default:
 		    if (!tmp) {
 			printk(KERN_DEBUG "scsi%d: rejecting message ", HOSTNO);
-			scsi_print_msg (extended_msg);
+			spi_print_msg (extended_msg);
 			printk("\n");
 		    } else if (tmp != EXTENDED_MESSAGE)
 			printk(KERN_DEBUG "scsi%d: rejecting unknown "
@@ -2566,7 +2567,7 @@ static void NCR5380_reselect (struct Scs
 
     if (!(msg[0] & 0x80)) {
 	printk(KERN_DEBUG "scsi%d: expecting IDENTIFY message, got ", HOSTNO);
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	do_abort(instance);
 	return;
     }
Index: drivers/scsi/arm/Kconfig
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/arm/Kconfig,v
retrieving revision 1.2
diff -u -p -r1.2 Kconfig
--- drivers/scsi/arm/Kconfig	29 Aug 2005 02:41:12 -0000	1.2
+++ drivers/scsi/arm/Kconfig	13 Dec 2005 15:49:01 -0000
@@ -4,6 +4,7 @@
 config SCSI_ACORNSCSI_3
 	tristate "Acorn SCSI card (aka30) support"
 	depends on ARCH_ACORN && SCSI && BROKEN
+	select SCSI_SPI_ATTRS
 	help
 	  This enables support for the Acorn SCSI card (aka30). If you have an
 	  Acorn system with one of these, say Y. If unsure, say N.
Index: drivers/scsi/arm/acornscsi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/arm/acornscsi.c,v
retrieving revision 1.9
diff -u -p -r1.9 acornscsi.c
--- drivers/scsi/arm/acornscsi.c	12 Nov 2005 04:08:14 -0000	1.9
+++ drivers/scsi/arm/acornscsi.c	13 Dec 2005 16:32:54 -0000
@@ -152,6 +152,7 @@
 #include "../scsi.h"
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_host.h>
+#include <scsi/scsi_transport_spi.h>
 #include "acornscsi.h"
 #include "msgqueue.h"
 #include "scsi.h"
@@ -1370,7 +1371,7 @@ void acornscsi_sendmessage(AS_Host *host
 
 	host->scsi.last_message = msg->msg[0];
 #if (DEBUG & DEBUG_MESSAGES)
-	scsi_print_msg(msg->msg);
+	spi_print_msg(msg->msg);
 #endif
 	break;
 
@@ -1392,7 +1393,7 @@ void acornscsi_sendmessage(AS_Host *host
 	while ((msg = msgqueue_getmsg(&host->scsi.msgs, msgnr++)) != NULL) {
 	    unsigned int i;
 #if (DEBUG & DEBUG_MESSAGES)
-	    scsi_print_msg(msg);
+	    spi_print_msg(msg);
 #endif
 	    i = 0;
 	    if (acornscsi_write_pio(host, msg->msg, &i, msg->length, 1000000))
@@ -1488,7 +1489,7 @@ void acornscsi_message(AS_Host *host)
 #if (DEBUG & DEBUG_MESSAGES)
     printk("scsi%d.%c: message in: ",
 	    host->host->host_no, acornscsi_target(host));
-    scsi_print_msg(message);
+    spi_print_msg(message);
     printk("\n");
 #endif
 
Index: drivers/scsi/sym53c8xx_2/sym_hipd.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/sym53c8xx_2/sym_hipd.c,v
retrieving revision 1.75
diff -u -p -r1.75 sym_hipd.c
--- drivers/scsi/sym53c8xx_2/sym_hipd.c	12 Dec 2005 16:35:33 -0000	1.75
+++ drivers/scsi/sym53c8xx_2/sym_hipd.c	13 Dec 2005 16:38:25 -0000
@@ -40,7 +40,6 @@
 
 #include <linux/slab.h>
 #include <asm/param.h>		/* for timeouts in units of HZ */
-#include <scsi/scsi_dbg.h>
 
 #include "sym_glue.h"
 #include "sym_nvram.h"
@@ -75,7 +74,7 @@ static void sym_print_msg(struct sym_ccb
 {
 	sym_print_addr(cp->cmd, "%s: ", label);
 
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	printf("\n");
 }
 
@@ -84,7 +83,7 @@ static void sym_print_nego_msg(struct sy
 	struct sym_tcb *tp = &np->target[target];
 	dev_info(&tp->starget->dev, "%s: ", label);
 
-	scsi_print_msg(msg);
+	spi_print_msg(msg);
 	printf("\n");
 }
 
Index: include/scsi/scsi_dbg.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_dbg.h,v
retrieving revision 1.4
diff -u -p -r1.4 scsi_dbg.h
--- include/scsi/scsi_dbg.h	14 Sep 2005 12:57:56 -0000	1.4
+++ include/scsi/scsi_dbg.h	13 Dec 2005 16:30:20 -0000
@@ -16,7 +16,6 @@ extern void __scsi_print_sense(const cha
 extern void scsi_print_driverbyte(int);
 extern void scsi_print_hostbyte(int);
 extern void scsi_print_status(unsigned char);
-extern int scsi_print_msg(const unsigned char *);
 extern const char *scsi_sense_key_string(unsigned char);
 extern const char *scsi_extd_sense_format(unsigned char, unsigned char);
 
Index: include/scsi/scsi_transport_spi.h
===================================================================
RCS file: /var/cvs/linux-2.6/include/scsi/scsi_transport_spi.h,v
retrieving revision 1.8
diff -u -p -r1.8 scsi_transport_spi.h
--- include/scsi/scsi_transport_spi.h	14 Sep 2005 12:57:56 -0000	1.8
+++ include/scsi/scsi_transport_spi.h	13 Dec 2005 16:30:45 -0000
@@ -143,5 +143,6 @@ void spi_release_transport(struct scsi_t
 void spi_schedule_dv_device(struct scsi_device *);
 void spi_dv_device(struct scsi_device *);
 void spi_display_xfer_agreement(struct scsi_target *);
+int spi_print_msg(const unsigned char *);
 
 #endif /* SCSI_TRANSPORT_SPI_H */
