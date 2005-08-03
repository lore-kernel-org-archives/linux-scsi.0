From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/7] aacraid: aif registration timeout fix
Date: Wed, 03 Aug 2005 15:39:25 -0700
Message-ID: <1123108765.24945.39.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:48610 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261532AbVHCWj2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:39:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec:

If the Adapter is quiet and does not produce an AIF event packets to be
picked up by the management applications for longer than the timeout
interval of two minutes, the cleanup code that deals with aging out
registrants could erroneously drop the registration. The timeout is
there to clean up should the management application die and fail to poll
for updated AIF event packets.

Moving the timer update from the ioctl code that delivers an AIF to the
polling registrant to the bottom of the ioctl means the timeout is reset
with any management application polling activity regardless if an AIF is
delivered or not removing the erroneous timeout cleanups.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/commctrl.c	2005-07-01 11:49:36.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c	2005-07-05 14:18:07.000000000 -0700
@@ -287,7 +287,6 @@
 		kfree(fib->hw_fib);
 		kfree(fib);
 		status = 0;
-		fibctx->jiffies = jiffies/HZ;
 	} else {
 		spin_unlock_irqrestore(&dev->fib_lock, flags);
 		if (f.wait) {
@@ -302,6 +301,7 @@
 			status = -EAGAIN;
 		}	
 	}
+	fibctx->jiffies = jiffies/HZ;
 	return status;
 }
 

-- 
Mark Haverkamp <markh@osdl.org>

