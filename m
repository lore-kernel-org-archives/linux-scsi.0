From: Nate Dailey <nhdailey@verizon.net>
Subject: [PATCH] drivers/scsi/sr_ioctl.c: check for failed allocation
Date: Thu, 21 Apr 2005 09:45:22 -0500 (CDT)
Message-ID: <5385768.1114094722652.JavaMail.root@vms064.mailsrvcs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vms040pub.verizon.net ([206.46.252.40]:10405 "EHLO
	vms040pub.verizon.net") by vger.kernel.org with ESMTP
	id S261400AbVDUOpX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 10:45:23 -0400
Received: from vms064.mailsrvcs.net ([192.168.1.1])
 by vms040.mailsrvcs.net (Sun Java System Messaging Server 6.2 HotFix 0.04
 (built Dec 24 2004)) with ESMTPA id <0IFA001I0WZM5MP1@vms040.mailsrvcs.net> for
 linux-scsi@vger.kernel.org; Thu, 21 Apr 2005 09:45:22 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de
Cc: linux-scsi@vger.kernel.org

Hi,

I noticed a case in sr_ioctl.c's sr_get_mcn where a buffer is allocated, but the pointer isn't checked for null.

This patch against 2.6.12-rc2 adds a check.

Nate Dailey
Stratus Technologies


Signed-off-by: Nate Dailey <nate.dailey@stratus.com>


--- linux-2.6.12-rc2/drivers/scsi/sr_ioctl.c.orig	2005-04-20 11:31:27.000000000 -0400
+++ linux-2.6.12-rc2/drivers/scsi/sr_ioctl.c	2005-04-20 11:33:58.000000000 -0400
@@ -281,6 +281,9 @@ int sr_get_mcn(struct cdrom_device_info 
 	char *buffer = kmalloc(32, GFP_KERNEL | SR_GFP_DMA(cd));
 	int result;
 
+	if (!buffer)
+		return -ENOMEM;
+
 	memset(&cgc, 0, sizeof(struct packet_command));
 	cgc.cmd[0] = GPCMD_READ_SUBCHANNEL;
 	cgc.cmd[2] = 0x40;	/* I do want the subchannel info */


