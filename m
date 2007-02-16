From: akpm@linux-foundation.org
Subject: [patch 20/30] scsi: handle bad inquiry responses
Date: Fri, 16 Feb 2007 01:46:38 -0800
Message-ID: <200702160946.l1G9kcsU026679@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36913 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423519AbXBPJrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Feb 2007 04:47:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, stern@rowland.harvard.edu, mroos@linux.ee

From: Alan Stern <stern@rowland.harvard.edu>

>From Meelis's USB device: It contains the device's response to an INQUIRY
command.

> ffff8100795e84c0 1469131296 C Bi:006:02 0 36 = 00800001 00000000 47454e45 52494320 55534220 4449534b 20444556 49434520

The fifth byte of the response is 0, meaning that all bytes past the fifth are
invalid.  This is kind of an odd thing to do; it says the device hasn't really
sent any vendor or product information at all.  That's why you've been seeing
garbage.

The Vendor string starts at byte position 8, the Product string at
position 16, and the Revision string at position 32 (not captured by
usbmon).  Translating the bytes from hex to ASCII gives:

	Vendor:  GENERIC
	Product: USB DISK DEVICE

These certainly _seem_ valid, albeit not very specific.  Perhaps the device's
USB firmware was never customized for any OEM and the default state is marked
invalid.

There's a comment about this in the source code, asking what should be done if
the INQUIRY response is too short (as it is here).  Maybe the best approach
would be always to assume the first 36 bytes are valid, even when the device
says they aren't.  It ought to solve your problem, and it's no worse than what
we're doing now.

Cc: Meelis Roos <mroos@linux.ee>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_scan.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN drivers/scsi/scsi_scan.c~scsi-handle-bad-inquiry-responses drivers/scsi/scsi_scan.c
--- a/drivers/scsi/scsi_scan.c~scsi-handle-bad-inquiry-responses
+++ a/drivers/scsi/scsi_scan.c
@@ -654,6 +654,19 @@ static int scsi_probe_lun(struct scsi_de
 	 * short INQUIRY), an abort here prevents any further use of the
 	 * device, including spin up.
 	 *
+	 * On the whole, the best approach seems to be to assume the first
+	 * 36 bytes are valid no matter what the device says.  That's
+	 * better than copying < 36 bytes to the inquiry-result buffer
+	 * and displaying garbage for the Vendor, Product, or Revision
+	 * strings.
+	 */
+	if (sdev->inquiry_len < 36) {
+		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
+				" using 36\n", sdev->inquiry_len);
+		sdev->inquiry_len = 36;
+	}
+
+	/*
 	 * Related to the above issue:
 	 *
 	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,
_
