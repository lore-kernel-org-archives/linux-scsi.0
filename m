From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: 19 Aug 2004 12:19:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092932342.2378.430.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10478 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266619AbUHSQTE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 12:19:04 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id i7JGJ2X15871
	for <linux-scsi@vger.kernel.org>; Thu, 19 Aug 2004 12:19:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

The non unique SCSI ioctls:

SCSI_IOCTL_SEND_COMMAND
SCSI_IOCTL_TEST_UNIT_READY
SCSI_IOCTL_BENCHMARK_COMMAND
SCSI_IOCTL_SYNC
SCSI_IOCTL_START_UNIT
SCSI_IOCTL_STOP_UNIT

Have been deprecated for a while now.  We should make the kernel
complain when a program actually uses one of them, so users have had
adequate warning before they are removed.

James

===== drivers/scsi/scsi_ioctl.c 1.28 vs edited =====
--- 1.28/drivers/scsi/scsi_ioctl.c	2004-06-26 17:40:24 -05:00
+++ edited/drivers/scsi/scsi_ioctl.c	2004-08-19 09:45:22 -05:00
@@ -391,6 +391,21 @@
 	if (!scsi_block_when_processing_errors(sdev))
 		return -ENODEV;
 
+	/* Check for deprecated ioctls ... all the ioctls which don't
+	 * follow the new unique numbering scheme are deprecated */
+	switch (cmd) {
+	case SCSI_IOCTL_SEND_COMMAND:
+	case SCSI_IOCTL_TEST_UNIT_READY:
+	case SCSI_IOCTL_BENCHMARK_COMMAND:
+	case SCSI_IOCTL_SYNC:
+	case SCSI_IOCTL_START_UNIT:
+	case SCSI_IOCTL_STOP_UNIT:
+		printk(KERN_WARNING "program %s is using a deprecated SCSI ioctl, please convert it to SG_IO\n", current->comm);
+		break;
+	default:
+		break;
+	}
+
 	switch (cmd) {
 	case SCSI_IOCTL_GET_IDLUN:
 		if (verify_area(VERIFY_WRITE, arg, sizeof(struct scsi_idlun)))


