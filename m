From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 10/11] aacraid: Fix parenthesis placement error
Date: Mon, 27 Mar 2006 09:44:33 -0800
Message-ID: <1143481473.21975.45.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:46783 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751111AbWC0Rof (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 12:44:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn

On 64 bit machines, when a 32 bit application tries to acquire the AIF,
they will always get and EFAULT error response from the driver.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-03-22 12:48:10.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-03-22 12:48:14.000000000 -0800
@@ -570,12 +570,12 @@
 		
 		f = compat_alloc_user_space(sizeof(*f));
 		ret = 0;
-		if (clear_user(f, sizeof(*f) != sizeof(*f)))
+		if (clear_user(f, sizeof(*f)) != sizeof(*f))
 			ret = -EFAULT;
 		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
 			ret = -EFAULT;
 		if (!ret)
-			ret = aac_do_ioctl(dev, cmd, (void __user *)arg);
+			ret = aac_do_ioctl(dev, cmd, f);
 		break;
 	}
 

-- 
Mark Haverkamp <markh@osdl.org>

