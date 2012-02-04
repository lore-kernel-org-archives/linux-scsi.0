From: Tullio Dovera <tdovera@gmail.com>
Subject: sending ioctl warnings for a partition
Date: Sat, 4 Feb 2012 17:05:01 +0100
Message-ID: <CANDSw5hvEwgCaXsk+OxBQ_xL+WiTLbTrVhB9H_W4NuU86bCNLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40122 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab2BDQFC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Feb 2012 11:05:02 -0500
Received: by iacb35 with SMTP id b35so6223723iac.19
        for <linux-scsi@vger.kernel.org>; Sat, 04 Feb 2012 08:05:01 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

My platform is based on linux v3.2.2 + Debian stable zfs-fuse-0.6.9-1
application

When I use a dedicated scsi partition for zfs-fuse I see the following
warnings at kernel level:

kernel: [   12.881949] zfs-fuse: sending ioctl 2285 to a partition!

The SG_IO is blocked inside scsi_verify_blk_ioctl() function. In order to permit
SG_IO for a partition I suggest to add it in the white list:

--- a/block/scsi_ioctl.c	2012-02-01 11:10:41.000000000 +0100
+++ b/block/scsi_ioctl.c	2012-02-01 11:31:09.000000000 +0100
@@ -710,6 +710,7 @@
 	case SG_GET_RESERVED_SIZE:
 	case SG_SET_RESERVED_SIZE:
 	case SG_EMULATED_HOST:
+	case SG_IO:
 		return 0;
 	case CDROM_GET_CAPABILITY:
 		/* Keep this until we remove the printk below.  udev sends it

Best regards,
   Tullio
