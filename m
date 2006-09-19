From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/5] aacraid:  misc cleanup
Date: Tue, 19 Sep 2006 08:59:23 -0700
Message-ID: <1158681564.2837.18.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:39842 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751512AbWISP71 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Sep 2006 11:59:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received from Mark Salyzyn:

Basically cleanup, nothing here will have an affect. Adjusting some
error codes, removing superfluous definitions and code fragments.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aachba.c	2006-09-12 09:48:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aachba.c	2006-09-12 09:49:31.000000000 -0700
@@ -1803,7 +1803,7 @@
 
 	fsa_dev_ptr = dev->fsa_dev;
 	if (!fsa_dev_ptr)
-		return -ENODEV;
+		return -EBUSY;
 	if (copy_from_user(&qd, arg, sizeof (struct aac_query_disk)))
 		return -EFAULT;
 	if (qd.cnum == -1)
@@ -1842,6 +1842,8 @@
 	struct fsa_dev_info *fsa_dev_ptr;
 
 	fsa_dev_ptr = dev->fsa_dev;
+	if (!fsa_dev_ptr)
+		return -EBUSY;
 
 	if (copy_from_user(&dd, arg, sizeof (struct aac_delete_disk)))
 		return -EFAULT;
@@ -1866,9 +1868,7 @@
 
 	fsa_dev_ptr = dev->fsa_dev;
 	if (!fsa_dev_ptr)
-		return -ENODEV;
-	if (!fsa_dev_ptr)
-		return -ENODEV;
+		return -EBUSY;
 
 	if (copy_from_user(&dd, arg, sizeof (struct aac_delete_disk)))
 		return -EFAULT;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-09-12 09:48:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-09-12 09:49:31.000000000 -0700
@@ -1525,7 +1525,6 @@
 	__le32		count;	/* sizeof(((struct aac_get_name_resp *)NULL)->data) */
 };
 
-#define CT_OK        218
 struct aac_get_name_resp {
 	__le32		dummy0;
 	__le32		dummy1;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-09-12 09:48:51.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-09-12 09:49:31.000000000 -0700
@@ -467,7 +467,7 @@
 	dprintk((KERN_DEBUG "  fib being sent=%p\n",fibptr));
 
 	if (!dev->queues)
-		return -ENODEV;
+		return -EBUSY;
 	q = &dev->queues->queue[AdapNormCmdQueue];
 
 	if(wait)

-- 
Mark Haverkamp <markh@osdl.org>

