From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] get the kernel to warn about deprecated SCSI ioctls
Date: 19 Aug 2004 17:06:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1092949566.1728.1314.camel@mulgrave>
References: <1092932342.2378.430.camel@mulgrave>
	<20040819172109.A10853@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:2714 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267407AbUHSVGL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Aug 2004 17:06:11 -0400
In-Reply-To: <20040819172109.A10853@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-08-19 at 12:21, Christoph Hellwig wrote:
> drivers/block/scsi_ioctl.c also implements SCSI_IOCTL_SEND_COMMAND, so
> you'll have to warn there aswell.

Done.

No other places I've missed?

James

===== drivers/block/scsi_ioctl.c 1.53 vs edited =====
--- 1.53/drivers/block/scsi_ioctl.c	2004-08-14 05:24:49 -05:00
+++ edited/drivers/block/scsi_ioctl.c	2004-08-19 15:51:44 -05:00
@@ -510,6 +510,7 @@
 		 * old junk scsi send command ioctl
 		 */
 		case SCSI_IOCTL_SEND_COMMAND:
+			printk(KERN_WARNING "program %s is using a deprecated SCSI ioctl, please convert it to SG_IO\n", current->comm);
 			err = -EINVAL;
 			if (!arg)
 				break;
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

