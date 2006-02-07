From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Make spi_print_msg more consistent
Date: Tue, 7 Feb 2006 08:05:26 -0700
Message-ID: <20060207150526.GC1601@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:57283 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S965122AbWBGPF1
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 10:05:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Almost all the output from spi_print_msg() has a trailing space.
This patch fixes up the three cases that don't.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

Index: ./drivers/scsi/scsi_transport_spi.c
===================================================================
RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_transport_spi.c,v
retrieving revision 1.24
diff -u -p -r1.24 scsi_transport_spi.c
--- ./drivers/scsi/scsi_transport_spi.c	17 Jan 2006 14:51:49 -0000	1.24
+++ ./drivers/scsi/scsi_transport_spi.c	7 Feb 2006 13:11:26 -0000
@@ -1101,7 +1133,7 @@ int spi_print_msg(const unsigned char *m
 				(int) msg[2]);
 		switch (msg[2]) {
 		case EXTENDED_MODIFY_DATA_POINTER:
-			printk("pointer = %d", (int) (msg[3] << 24) |
+			printk("pointer = %d ", (msg[3] << 24) |
 				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
 			break;
 		case EXTENDED_SDTR:
@@ -1127,7 +1159,7 @@ int spi_print_msg(const unsigned char *m
 	/* Normal One byte */
 	} else if (msg[0] < 0x1f) {
 		if (msg[0] < ARRAY_SIZE(one_byte_msgs))
-			printk(one_byte_msgs[msg[0]]);
+			printk("%s ", one_byte_msgs[msg[0]]);
 		else
 			printk("reserved (%02x) ", msg[0]);
 		len = 1;
@@ -1141,7 +1173,7 @@ int spi_print_msg(const unsigned char *m
 				msg[0], msg[1]);
 		len = 2;
 	} else 
-		printk("reserved");
+		printk("reserved ");
 	return len;
 }
 EXPORT_SYMBOL(spi_print_msg);
