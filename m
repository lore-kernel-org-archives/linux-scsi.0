From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] (7/27) *really* dumb typo in aacraid (cast to pointer to structure that doesn't exist ;-)
Date: Wed, 2 Feb 2005 16:32:14 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BBD6089@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:14827 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262623AbVBBVcS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2005 16:32:18 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, Mark Haverkamp <markh@osdl.org>

Cool! A good catch that could only be caught with many eyes looking at
the code.

Wasn't in my branch though, but it looks like a common typo ;-/. But the
sad part of this is that I use casts around voids to improve type
checking (and enforce/document intentions) and it now appears to be a
waste. I assume you did not see a warning message from your compile
environment, right?

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Al Viro
Sent: Wednesday, February 02, 2005 2:14 PM
To: Linus Torvalds
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] (7/27) *really* dumb typo in aacraid (cast to pointer
to structure that doesn't exist ;-)

	spot the typo...  It's harmless, in a sense that code compiles
right,
but...
Signed-off-by: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
----
diff -urN RC11-rc2-bk10-rme9652/drivers/scsi/aacraid/aachba.c
RC11-rc2-bk10-aacraid/drivers/scsi/aacraid/aachba.c
--- RC11-rc2-bk10-rme9652/drivers/scsi/aacraid/aachba.c	Tue Feb  1
21:44:42 2005
+++ RC11-rc2-bk10-aacraid/drivers/scsi/aacraid/aachba.c	Wed Feb  2
08:12:13 2005
@@ -1047,7 +1047,7 @@
 			COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
 	else {
 		struct scsi_device *sdev = cmd->device;
-		struct aac_dev *dev = (struct aav_dev
*)sdev->host->hostdata;
+		struct aac_dev *dev = (struct aac_dev
*)sdev->host->hostdata;
 		u32 cid = ID_LUN_TO_CONTAINER(sdev->id, sdev->lun);
 		printk(KERN_WARNING 
 		     "synchronize_callback: synchronize failed, status =
%d\n",
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
