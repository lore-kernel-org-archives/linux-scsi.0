From: akpm@linux-foundation.org
Subject: [patch 18/25] drivers/message/i2o/device.c: remove redundant GFP_ATOMIC from kmalloc
Date: Wed, 23 May 2007 14:41:47 -0700
Message-ID: <200705232141.l4NLflq3001218@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756837AbXEWWDz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 18:03:55 -0400
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
 1 files changed, 1 insertion(+), 1 deletion(-)

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
