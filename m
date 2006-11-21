From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 2/3] aacraid: Abort management FIBs
Date: Tue, 21 Nov 2006 10:40:31 -0800
Message-ID: <1164134431.18765.38.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:22156 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1031293AbWKUSke (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 13:40:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn:

Add code to abort outstanding management ioctl fibs when the blinkLED recovery
is performed. This code is 'clunky' and does not have any real feedback in that
the reset could progress before the user application has gotten it's
notification of command completion. We put a schedule() call to delay just the
right amount for most cases, because we tried a spin and still managed to find
cases where we would spin forever waiting for the management application to
acknowledge the impending doom surrounding the cause of the BlinkLED. Will
cause an oops in the context of the management application if we proceed too
quickly. I view this as the lesser of many evils since currently if there are
outstanding management ioctls during a need to reset/recover the adapter, the
management application just locks up and waits forever. The best practices fix
for this problem not going to be simple or easy (at least the fixes I imagine
today); and we found a balance between the needs of the driver to proceed, and
the applications that locked or confused that would hold back the driver. I
just do not like the idea of a kernel oops in an application to deal with low
priority, sluggish or misbehaving applications.


Signed-off-by: Mark Haverkamp <markh@osdl.org>

---

Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-11-21 10:16:06.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-11-21 10:16:36.000000000 -0800
@@ -1102,6 +1102,20 @@
 		goto out;
 	}
 
+	/*
+	 *	Loop through the fibs, close the synchronous FIBS
+	 */
+	for (index = 0; index < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); index++) {
+		struct fib *fib = &aac->fibs[index];
+		if (!(fib->hw_fib->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
+		  (fib->hw_fib->header.XferState & cpu_to_le32(ResponseExpected))) {
+			unsigned long flagv;
+			spin_lock_irqsave(&fib->event_lock, flagv);
+			up(&fib->event_wait);
+			spin_unlock_irqrestore(&fib->event_lock, flagv);
+			schedule();
+		}
+	}
 	index = aac->cardtype;
 
 	/*

-- 
Mark Haverkamp <markh@osdl.org>

