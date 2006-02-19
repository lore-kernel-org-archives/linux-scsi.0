From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Improve message printing code
Date: Sat, 18 Feb 2006 20:52:31 -0700
Message-ID: <20060219035231.GW12822@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41866 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750756AbWBSDwe
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Feb 2006 22:52:34 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix a bug where we would consume one byte too many in the message
printing code.
Add support for 256-byte long messages.
Add support for the Modify Bidirectional Data Pointer message.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.24
diff -u -p -r1.24 scsi_transport_spi.c
--- a/drivers/scsi/scsi_transport_spi.c	17 Jan 2006 14:51:49 -0000	1.24
+++ b/drivers/scsi/scsi_transport_spi.c	19 Feb 2006 03:42:18 -0000
@@ -1072,7 +1072,7 @@ static const char * const two_byte_msgs[
 static const char * const extended_msgs[] = {
 /* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
 /* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request",
-/* 0x04 */ "Parallel Protocol Request"
+/* 0x04 */ "Parallel Protocol Request", "Modify Bidirectional Data Pointer"
 };
 
 static void print_nego(const unsigned char *msg, int per, int off, int width)
@@ -1089,11 +1089,20 @@ static void print_nego(const unsigned ch
 		printk("width = %d ", 8 << msg[width]);
 }
 
+static void print_ptr(const unsigned char *msg, int msb, const char *desc)
+{
+	int ptr = (msg[msb] << 24) | (msg[msb+1] << 16) | (msg[msb+2] << 8) |
+			msg[msb+3];
+	printk("%s = %d ", desc, ptr);
+}
+
 int spi_print_msg(const unsigned char *msg)
 {
 	int len = 0, i;
 	if (msg[0] == EXTENDED_MESSAGE) {
-		len = 3 + msg[1];
+		len = 2 + msg[1];
+		if (len == 2)
+			len += 256;
 		if (msg[2] < ARRAY_SIZE(extended_msgs))
 			printk ("%s ", extended_msgs[msg[2]]); 
 		else 
@@ -1101,8 +1110,7 @@ int spi_print_msg(const unsigned char *m
 				(int) msg[2]);
 		switch (msg[2]) {
 		case EXTENDED_MODIFY_DATA_POINTER:
-			printk("pointer = %d", (int) (msg[3] << 24) |
-				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
+			print_ptr(msg, 3, "pointer");
 			break;
 		case EXTENDED_SDTR:
 			print_nego(msg, 3, 4, 0);
@@ -1113,6 +1121,10 @@ int spi_print_msg(const unsigned char *m
 		case EXTENDED_PPR:
 			print_nego(msg, 3, 5, 6);
 			break;
+		case EXTENDED_MODIFY_BIDI_DATA_PTR:
+			print_ptr(msg, 3, "out");
+			print_ptr(msg, 7, "in");
+			break;
 		default:
 		for (i = 2; i < len; ++i) 
 			printk("%02x ", msg[i]);
@@ -1153,7 +1165,9 @@ int spi_print_msg(const unsigned char *m
 	int len = 0, i;
 
 	if (msg[0] == EXTENDED_MESSAGE) {
-		len = 3 + msg[1];
+		len = 2 + msg[1];
+		if (len == 2)
+			len += 256;
 		for (i = 0; i < len; ++i)
 			printk("%02x ", msg[i]);
 	/* Identify */
