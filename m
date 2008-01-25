From: Tony Battersby <tonyb@cybernetics.com>
Subject: [PATCH] [SCSI] make SPI DV data pattern "d" match T10
Date: Fri, 25 Jan 2008 16:13:18 -0500
Message-ID: <479A50EE.4020703@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:1413 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbYAYVNM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jan 2008 16:13:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

The T10 SCSI domain validation draft sdv-r08b.pdf section 5.4 describes
data pattern "d" like this:

d) shifting bit (0000h, FFFEh, 0000h, FFFDh, ... then FFFFh, 0001h,
FFFFh, 0002h, ...)

The current code in scsi_transport_spi.c produces the following data
pattern:

FF FF 00 00 | FE FF 01 00 | FC FF 03 00 | F8 FF 07 00
F0 FF 0F 00 | E0 FF 1F 00 | C0 FF 3F 00 | 80 FF 7F 00
(other patterns here)
00 FF FF 00 | 00 FE FF 01 | 00 FC FF 03 | 00 F8 FF 07
00 F0 FF 0F | 00 E0 FF 1F | 00 C0 FF 3F | 00 80 FF 7F
(other patterns here)
00 00 FF FF | 01 00 FE FF | 03 00 FC FF | 07 00 F8 FF
0F 00 F0 FF | 1F 00 E0 FF | 3F 00 C0 FF | 7F 00 80 FF
(other patterns here)
FF 00 00 FF | FF 01 00 FE | FF 03 00 FC | FF 07 00 F8
FF 0F 00 F0 | FF 1F 00 E0 | FF 3F 00 C0 | FF 7F 00 80

This patch changes the data pattern to match sdv-r08b.pdf, like this:

00 00 FF FE | 00 00 FF FD | 00 00 FF FB | 00 00 FF F7
00 00 FF EF | 00 00 FF DF | 00 00 FF BF | 00 00 FF 7F
00 00 FE FF | 00 00 FD FF | 00 00 FB FF | 00 00 F7 FF
00 00 EF FF | 00 00 DF FF | 00 00 BF FF | 00 00 7F FF
FF FF 00 01 | FF FF 00 02 | FF FF 00 04 | FF FF 00 08
FF FF 00 10 | FF FF 00 20 | FF FF 00 40 | FF FF 00 80
FF FF 01 00 | FF FF 02 00 | FF FF 04 00 | FF FF 08 00
FF FF 10 00 | FF FF 20 00 | FF FF 40 00 | FF FF 80 00

This data pattern tests simultaneously turning on or off all bits but
one.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
---
--- linux-2.6.24/drivers/scsi/scsi_transport_spi.c.orig	2008-01-25 15:16:15.000000000 -0500
+++ linux-2.6.24/drivers/scsi/scsi_transport_spi.c	2008-01-25 15:30:20.000000000 -0500
@@ -559,7 +559,6 @@ spi_dv_device_echo_buffer(struct scsi_de
 {
 	int len = ptr - buffer;
 	int j, k, r, result;
-	unsigned int pattern = 0x0000ffff;
 	struct scsi_sense_hdr sshdr;
 
 	const char spi_write_buffer[] = {
@@ -594,12 +593,18 @@ spi_dv_device_echo_buffer(struct scsi_de
 		}
 		k = j;
 		/* fill with shifting bits (test d) */
-		for ( ; j < min(len, k + 32); j += 4) {
-			u32 *word = (unsigned int *)&buffer[j];
-			u32 roll = (pattern & 0x80000000) ? 1 : 0;
-			
-			*word = pattern;
-			pattern = (pattern << 1) | roll;
+		for ( ; j < min(len, k + 64); j += 4) {
+			u32 *word = (u32 *)&buffer[j];
+			int bit = (j - k) >> 2;
+
+			*word = cpu_to_be32(0x0000ffff & ~(1 << bit));
+		}
+		k = j;
+		for ( ; j < min(len, k + 64); j += 4) {
+			u32 *word = (u32 *)&buffer[j];
+			int bit = (j - k) >> 2;
+
+			*word = cpu_to_be32(0xffff0000 | (1 << bit));
 		}
 		/* don't bother with random data (test e) */
 	}


