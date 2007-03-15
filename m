From: Mark Haverkamp <markh@linux-foundation.org>
Subject: [PATCH 4/7] aacraid: Fix ioctl handling when adapter resets
Date: Thu, 15 Mar 2007 10:27:21 -0700
Message-ID: <1173979641.30374.25.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60834 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbXCOR1X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Mar 2007 13:27:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn,

Outstanding ioctl calls still have some problems with aborting cleanly
in the face of a reset iop recovery action should the adapter ever enter
into a Firmware Assert (BlinkLED) condition. The enclosed patch resolves
some uncovered flawed handling.

Signed-off-by: Mark Haverkamp <markh@linux-foundation.org>
---

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:30:12.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commctrl.c	2007-03-15 08:30:16.000000000 -0700
@@ -64,6 +64,9 @@ static int ioctl_send_fib(struct aac_dev
 	unsigned size;
 	int retval;
 
+	if (dev->in_reset) {
+		return -EBUSY;
+	}
 	fibptr = aac_fib_alloc(dev);
 	if(fibptr == NULL) {
 		return -ENOMEM;
@@ -469,6 +472,10 @@ static int aac_send_raw_srb(struct aac_d
 	int i;
 
 
+	if (dev->in_reset) {
+		dprintk((KERN_DEBUG"aacraid: send raw srb -EBUSY\n"));
+		return -EBUSY;
+	}
 	if (!capable(CAP_SYS_ADMIN)){
 		dprintk((KERN_DEBUG"aacraid: No permission to send raw srb\n")); 
 		return -EPERM;
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:12.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2007-03-15 08:30:16.000000000 -0700
@@ -513,15 +513,15 @@ int aac_fib_send(u16 command, struct fib
 				}
 				udelay(5);
 			}
-		} else if (down_interruptible(&fibptr->event_wait)) {
-			spin_lock_irqsave(&fibptr->event_lock, flags);
-			if (fibptr->done == 0) {
-				fibptr->done = 2; /* Tell interrupt we aborted */
-				spin_unlock_irqrestore(&fibptr->event_lock, flags);
-				return -EINTR;
-			}
+		} else
+			(void)down_interruptible(&fibptr->event_wait);
+		spin_lock_irqsave(&fibptr->event_lock, flags);
+		if (fibptr->done == 0) {
+			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
+			return -EINTR;
 		}
+		spin_unlock_irqrestore(&fibptr->event_lock, flags);
 		BUG_ON(fibptr->done == 0);
 			
 		if((fibptr->flags & FIB_CONTEXT_FLAG_TIMED_OUT)){
@@ -1062,7 +1062,7 @@ static int _aac_reset_adapter(struct aac
 	/*
 	 *	Loop through the fibs, close the synchronous FIBS
 	 */
-	for (index = 0; index < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); index++) {
+	for (retval = 1, index = 0; index < (aac->scsi_host_ptr->can_queue + AAC_NUM_MGT_FIB); index++) {
 		struct fib *fib = &aac->fibs[index];
 		if (!(fib->hw_fib_va->header.XferState & cpu_to_le32(NoResponseExpected | Async)) &&
 		  (fib->hw_fib_va->header.XferState & cpu_to_le32(ResponseExpected))) {
@@ -1071,8 +1071,12 @@ static int _aac_reset_adapter(struct aac
 			up(&fib->event_wait);
 			spin_unlock_irqrestore(&fib->event_lock, flagv);
 			schedule();
+			retval = 0;
 		}
 	}
+	/* Give some extra time for ioctls to complete. */
+	if (retval == 0)
+		ssleep(2);
 	index = aac->cardtype;
 
 	/*

-- 
Mark Haverkamp <markh@linux-foundation.org>

