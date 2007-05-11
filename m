From: akpm@linux-foundation.org
Subject: [patch 22/28] drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
Date: Thu, 10 May 2007 23:01:06 -0700
Message-ID: <200705110601.l4B616Un008181@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35337 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759247AbXEKGJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, ssatyam@cse.iitk.ac.in

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

drivers/message/i2o/device.c:i2o_parm_field_get() unnecessarily passes
GFP_ATOMIC (along with GFP_KERNEL) to kmalloc() from a context that is not
atomic. Remove the pointless GFP_ATOMIC.

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/i2o/device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc drivers/message/i2o/device.c
--- a/drivers/message/i2o/device.c~drivers-message-i2o-devicec-remove-redundant-gfp_atomic-from-kmalloc
+++ a/drivers/message/i2o/device.c
@@ -485,7 +485,7 @@ int i2o_parm_field_get(struct i2o_device
 	u8 *resblk;		/* 8 bytes for header */
 	int rc;
 
-	resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);
+	resblk = kmalloc(buflen + 8, GFP_KERNEL);
 	if (!resblk)
 		return -ENOMEM;
 
_
