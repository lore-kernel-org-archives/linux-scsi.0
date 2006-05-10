From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 5/5] aacraid: remove unneeded list
Date: Wed, 10 May 2006 09:13:37 -0700
Message-ID: <1147277617.29108.37.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35460 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965007AbWEJQNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 12:13:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>

Received From Mark Salyzyn

The queue tracking is just not being used, not even for debugging. Information
about outstanding commands can be acquired from the scsi structures.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-05-09 14:49:33.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-05-09 14:50:00.000000000 -0700
@@ -563,7 +563,6 @@
 	spinlock_t		lockdata;	/* Actual lock (used only on one side of the lock) */
 	struct list_head 	cmdq;	   	/* A queue of FIBs which need to be prcessed by the FS thread. This is */
                                 		/* only valid for command queues which receive entries from the adapter. */
-	struct list_head	pendingq;	/* A queue of outstanding fib's to the adapter. */
 	u32			numpending;	/* Number of entries on outstanding queue. */
 	struct aac_dev *	dev;		/* Back pointer to adapter structure */
 };
@@ -826,7 +825,6 @@
 	 *	The following is used to put this fib context onto the 
 	 *	Outstanding I/O queue.
 	 */
-	struct list_head	queue;
 	/*
 	 *	And for the internal issue/reply queues (we may be able
 	 *	to merge these two)
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2006-05-09 14:46:37.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2006-05-09 14:50:00.000000000 -0700
@@ -159,7 +159,6 @@
 {
 	q->numpending = 0;
 	q->dev = dev;
-	INIT_LIST_HEAD(&q->pendingq);
 	init_waitqueue_head(&q->cmdready);
 	INIT_LIST_HEAD(&q->cmdq);
 	init_waitqueue_head(&q->qfull);
--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-05-09 14:48:14.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-05-09 14:50:00.000000000 -0700
@@ -472,7 +472,6 @@
 	spin_lock_irqsave(q->lock, qflags);
 	if (dev->new_comm_interface) {
 		unsigned long count = 10000000L; /* 50 seconds */
-		list_add_tail(&fibptr->queue, &q->pendingq);
 		q->numpending++;
 		spin_unlock_irqrestore(q->lock, qflags);
 		while (aac_adapter_send(fibptr) != 0) {
@@ -481,7 +480,6 @@
 					spin_unlock_irqrestore(&fibptr->event_lock, flags);
 				spin_lock_irqsave(q->lock, qflags);
 				q->numpending--;
-				list_del(&fibptr->queue);
 				spin_unlock_irqrestore(q->lock, qflags);
 				return -ETIMEDOUT;
 			}
@@ -492,7 +490,6 @@
 		unsigned long nointr = 0;
 		aac_queue_get( dev, &index, AdapNormCmdQueue, hw_fib, 1, fibptr, &nointr);
 
-		list_add_tail(&fibptr->queue, &q->pendingq);
 		q->numpending++;
 		*(q->headers.producer) = cpu_to_le32(index + 1);
 		spin_unlock_irqrestore(q->lock, qflags);
@@ -520,7 +517,6 @@
 				if (--count == 0) {
 					spin_lock_irqsave(q->lock, qflags);
 					q->numpending--;
-					list_del(&fibptr->queue);
 					spin_unlock_irqrestore(q->lock, qflags);
 					if (wait == -1) {
 	        				printk(KERN_ERR "aacraid: aac_fib_send: first asynchronous command timed out.\n"
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2006-05-09 14:46:37.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2006-05-09 14:50:00.000000000 -0700
@@ -86,7 +86,6 @@
 		 *	the fib timed out.
 		 */
 		if (!(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
-			list_del(&fib->queue);
 			dev->queues->queue[AdapNormCmdQueue].numpending--;
 		} else {
 			printk(KERN_WARNING "aacraid: FIB timeout (%x).\n", fib->flags);
@@ -284,7 +283,6 @@
 			return 0;
 		}
 
-		list_del(&fib->queue);
 		dev->queues->queue[AdapNormCmdQueue].numpending--;
 
 		if (fast) {

-- 
Mark Haverkamp <markh@osdl.org>

