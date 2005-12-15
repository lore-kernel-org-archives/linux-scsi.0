From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 4/5] [SCSI] Use ARRAY_SIZE in spi_print_msg
Date: Thu, 15 Dec 2005 16:22:01 -0500
Message-ID: <11346817213846-git-send-email-matthew@wil.cx>
References: <20051215205856.GA2361@parisc-linux.org>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:58550 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751099AbVLOVWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 16:22:04 -0500
In-Reply-To: <20051215205856.GA2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Replace the custom NO_*_MSGS definitions with uses of ARRAY_SIZE.
This fixes a bug in the definition of NO_EXTENDED_MSGS.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/scsi_transport_spi.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

a7469c6472f85b42be4953e6b64a5dcb2dd96d6f
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 8cc5dff..380e167 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1057,19 +1057,16 @@ static const char * const one_byte_msgs[
 /* 0x0c */ "Bus device reset", "Abort Tag", "Clear Queue", 
 /* 0x0f */ "Initiate Recovery", "Release Recovery"
 };
-#define NO_ONE_BYTE_MSGS (sizeof(one_byte_msgs)  / sizeof (const char *))
 
 static const char * const two_byte_msgs[] = {
 /* 0x20 */ "Simple Queue Tag", "Head of Queue Tag", "Ordered Queue Tag",
 /* 0x23 */ "Ignore Wide Residue"
 };
-#define NO_TWO_BYTE_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
 
 static const char * const extended_msgs[] = {
 /* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
 /* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
 };
-#define NO_EXTENDED_MSGS (sizeof(two_byte_msgs)  / sizeof (const char *))
 
 
 int spi_print_msg(const unsigned char *msg)
@@ -1077,7 +1074,7 @@ int spi_print_msg(const unsigned char *m
 	int len = 0, i;
 	if (msg[0] == EXTENDED_MESSAGE) {
 		len = 3 + msg[1];
-		if (msg[2] < NO_EXTENDED_MSGS)
+		if (msg[2] < ARRAY_SIZE(extended_msgs))
 			printk ("%s ", extended_msgs[msg[2]]); 
 		else 
 			printk ("Extended Message, reserved code (0x%02x) ",
@@ -1107,14 +1104,14 @@ int spi_print_msg(const unsigned char *m
 		len = 1;
 	/* Normal One byte */
 	} else if (msg[0] < 0x1f) {
-		if (msg[0] < NO_ONE_BYTE_MSGS)
+		if (msg[0] < ARRAY_SIZE(one_byte_msgs))
 			printk(one_byte_msgs[msg[0]]);
 		else
 			printk("reserved (%02x) ", msg[0]);
 		len = 1;
 	/* Two byte */
 	} else if (msg[0] <= 0x2f) {
-		if ((msg[0] - 0x20) < NO_TWO_BYTE_MSGS)
+		if ((msg[0] - 0x20) < ARRAY_SIZE(two_byte_msgs))
 			printk("%s %02x ", two_byte_msgs[msg[0] - 0x20], 
 				msg[1]);
 		else 
-- 
0.99.9.GIT


