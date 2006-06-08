From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/3] aacraid: Fix return code interpretation
Date: Thu, 08 Jun 2006 09:50:54 -0700
Message-ID: <1149785454.22364.16.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:56547 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S964826AbWFHQu5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 12:50:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn

clear_user return is 0 for success, the code fragment is written to
assume that it is the count of the number of bytes zero'd.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/linit.c	2006-06-08 09:37:43.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/linit.c	2006-06-08 09:38:40.000000000 -0700
@@ -564,7 +564,7 @@
 		
 		f = compat_alloc_user_space(sizeof(*f));
 		ret = 0;
-		if (clear_user(f, sizeof(*f)) != sizeof(*f))
+		if (clear_user(f, sizeof(*f)))
 			ret = -EFAULT;
 		if (copy_in_user(f, (void __user *)arg, sizeof(struct fib_ioctl) - sizeof(u32)))
 			ret = -EFAULT;

-- 
Mark Haverkamp <markh@osdl.org>

