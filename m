From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 5/5] [SCSI] Add PPR support to spi_print_msg
Date: Thu, 15 Dec 2005 16:22:01 -0500
Message-ID: <11346817212734-git-send-email-matthew@wil.cx>
References: <20051215205856.GA2361@parisc-linux.org>
Reply-To: Matthew Wilcox <matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.magmacom.com ([206.191.0.217]:58806 "EHLO mx1.magmacom.com")
	by vger.kernel.org with ESMTP id S1751100AbVLOVWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2005 16:22:04 -0500
In-Reply-To: <20051215205856.GA2361@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

Introduce a new helper, print_nego() to handle SDTR/WDTR/PPR.
Split out the guts of show_spi_transport_period_helper() into period_to_str()
and use it in print_nego to get the period factor conversion right.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

---

 drivers/scsi/scsi_transport_spi.c |   36 +++++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

550d3fc8c8d8c8d4f660d95fd480c2ab028138a8
diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 380e167..46da6fe 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -379,9 +379,7 @@ static CLASS_DEVICE_ATTR(revalidate, S_I
 
 /* Translate the period into ns according to the current spec
  * for SDTR/PPR messages */
-static ssize_t
-show_spi_transport_period_helper(struct class_device *cdev, char *buf,
-				 int period)
+static int period_to_str(char *buf, int period)
 {
 	int len, picosec;
 
@@ -399,6 +397,14 @@ show_spi_transport_period_helper(struct 
 		len = sprint_frac(buf, picosec, 1000);
 	}
 
+	return len;
+}
+
+static ssize_t
+show_spi_transport_period_helper(struct class_device *cdev, char *buf,
+				 int period)
+{
+	int len = period_to_str(buf, period);
 	buf[len++] = '\n';
 	buf[len] = '\0';
 	return len;
@@ -1065,9 +1071,23 @@ static const char * const two_byte_msgs[
 
 static const char * const extended_msgs[] = {
 /* 0x00 */ "Modify Data Pointer", "Synchronous Data Transfer Request",
-/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request"
+/* 0x02 */ "SCSI-I Extended Identify", "Wide Data Transfer Request",
+/* 0x04 */ "Parallel Protocol Request"
 };
 
+void print_nego(const unsigned char *msg, int per, int off, int width)
+{
+	if (per) {
+		char buf[20];
+		period_to_str(buf, msg[per]);
+		printk("period = %s ns ", buf);
+	}
+
+	if (off)
+		printk("offset = %d ", msg[off]);
+	if (width)
+		printk("width = %d ", 8 << msg[width]);
+}
 
 int spi_print_msg(const unsigned char *msg)
 {
@@ -1085,11 +1105,13 @@ int spi_print_msg(const unsigned char *m
 				(msg[4] << 16) | (msg[5] << 8) | msg[6]);
 			break;
 		case EXTENDED_SDTR:
-			printk("period = %d ns, offset = %d",
-				(int) msg[3] * 4, (int) msg[4]);
+			print_nego(msg, 3, 4, 0);
 			break;
 		case EXTENDED_WDTR:
-			printk("width = 2^%d bytes", msg[3]);
+			print_nego(msg, 0, 0, 3);
+			break;
+		case EXTENDED_PPR:
+			print_nego(msg, 3, 5, 6);
 			break;
 		default:
 		for (i = 2; i < len; ++i) 
-- 
0.99.9.GIT


