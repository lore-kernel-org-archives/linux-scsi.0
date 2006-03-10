From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Missing names from SPI3, SPI4 and SPI5
Date: Fri, 10 Mar 2006 07:18:22 -0700
Message-ID: <20060310141822.GB1653@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43491 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751250AbWCJOSY
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 09:18:24 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add several missing messages from SPI3, SPI4 and SPI5:
 - Terminate Process
 - Continue Task
 - Target Transfer Disable
 - Clear ACA
 - LUN Reset
 - ACA
 - QAS Request
Rename some older commands to their SPI5 names:
 - Command Complete -> Task Complete
 - Abort -> Abort Task Set
 - Bus device Reset -> Target Reset
 - Clear Queue -> Clear Task Set

Change spi_print_msg() to always consume one byte, even if we don't
recognise it.  That allows drivers to call it in a loop to print all
messages.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 0b29ee9..4855d16 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1089,17 +1089,19 @@ EXPORT_SYMBOL_GPL(spi_populate_ppr_msg);
 
 #ifdef CONFIG_SCSI_CONSTANTS
 static const char * const one_byte_msgs[] = {
-/* 0x00 */ "Command Complete", NULL, "Save Pointers",
+/* 0x00 */ "Task Complete", NULL /* Extended Message */, "Save Pointers",
 /* 0x03 */ "Restore Pointers", "Disconnect", "Initiator Error", 
-/* 0x06 */ "Abort", "Message Reject", "Nop", "Message Parity Error",
+/* 0x06 */ "Abort Task Set", "Message Reject", "Nop", "Message Parity Error",
 /* 0x0a */ "Linked Command Complete", "Linked Command Complete w/flag",
-/* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
-/* 0x0f */ "Initiate Recovery", "Release Recovery"
+/* 0x0c */ "Target Reset", "Abort Task", "Clear Task Set", 
+/* 0x0f */ "Initiate Recovery", "Release Recovery",
+/* 0x11 */ "Terminate Process", "Continue Task", "Target Transfer Disable",
+/* 0x14 */ NULL, NULL, "Clear ACA", "LUN Reset"
 };
 
 static const char * const two_byte_msgs[] = {
 /* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
-/* 0x23 */ "Ignore Wide Residue"
+/* 0x23 */ "Ignore Wide Residue", "ACA"
 };
 
 static const char * const extended_msgs[] = {
@@ -1131,7 +1133,7 @@ static void print_ptr(const unsigned cha
 
 int spi_print_msg(const unsigned char *msg)
 {
-	int len = 0, i;
+	int len = 1, i;
 	if (msg[0] == EXTENDED_MESSAGE) {
 		len = 2 + msg[1];
 		if (len == 2)
@@ -1168,14 +1170,14 @@ int spi_print_msg(const unsigned char *m
 			(msg[0] & 0x40) ? "" : "not ",
 			(msg[0] & 0x20) ? "target routine" : "lun",
 			msg[0] & 0x7);
-		len = 1;
 	/* Normal One byte */
 	} else if (msg[0] < 0x1f) {
-		if (msg[0] < ARRAY_SIZE(one_byte_msgs))
+		if (msg[0] < ARRAY_SIZE(one_byte_msgs) && one_byte_msgs[msg[0]])
 			printk("%s ", one_byte_msgs[msg[0]]);
 		else
 			printk("reserved (%02x) ", msg[0]);
-		len = 1;
+	} else if (msg[0] == 0x55) {
+		printk("QAS Request ");
 	/* Two byte */
 	} else if (msg[0] <= 0x2f) {
 		if ((msg[0] - 0x20) < ARRAY_SIZE(two_byte_msgs))
@@ -1195,7 +1197,7 @@ EXPORT_SYMBOL(spi_print_msg);
 
 int spi_print_msg(const unsigned char *msg)
 {
-	int len = 0, i;
+	int len = 1, i;
 
 	if (msg[0] == EXTENDED_MESSAGE) {
 		len = 2 + msg[1];
@@ -1206,11 +1208,9 @@ int spi_print_msg(const unsigned char *m
 	/* Identify */
 	} else if (msg[0] & 0x80) {
 		printk("%02x ", msg[0]);
-		len = 1;
 	/* Normal One byte */
-	} else if (msg[0] < 0x1f) {
+	} else if ((msg[0] < 0x1f) || (msg == 0x55)) {
 		printk("%02x ", msg[0]);
-		len = 1;
 	/* Two byte */
 	} else if (msg[0] <= 0x2f) {
 		printk("%02x %02x", msg[0], msg[1]);
