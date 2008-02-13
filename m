From: Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [PATCH] Adaptec AACRAID: convert fibctx->wait_sem to completion
Date: Wed, 13 Feb 2008 19:34:44 +0100
Message-ID: <20080213183444.GA27068@traven>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:36702 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYBMSek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 13:34:40 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aacraid@adaptec.com, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org

Adaptec AACRAID driver: The semaphore fibctx->wait_sem is used for
signalling an event. Convert it to a completion.

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

--  
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 3195d29..eef4939 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -717,7 +717,7 @@ struct aac_fib_context {
 	u32			unique;		// unique value representing this context
 	ulong			jiffies;	// used for cleanup - dmb changed to ulong
 	struct list_head	next;		// used to link context's into a linked list
-	struct semaphore	wait_sem;	// this is used to wait for the next fib to arrive.
+	struct completion	compl;		// this is used to wait for the next fib to arrive.
 	int			wait;		// Set to true when thread is in WaitForSingleObject
 	unsigned long		count;		// total number of FIBs on FibList
 	struct list_head	fib_list;	// this holds fibs and their attachd hw_fibs
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index abef051..98efda6 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -33,6 +33,7 @@
 #include <linux/types.h>
 #include <linux/pci.h>
 #include <linux/spinlock.h>
+#include <linux/completion.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
 #include <linux/dma-mapping.h>
@@ -177,9 +178,9 @@ static int open_getadapter_fib(struct aac_dev * dev, void __user *arg)
 		 */
 		fibctx->unique = (u32)((ulong)fibctx & 0xFFFFFFFF);
 		/*
-		 *	Initialize the mutex used to wait for the next AIF.
+		 *	Initialize the completion used to wait for the next AIF.
 		 */
-		init_MUTEX_LOCKED(&fibctx->wait_sem);
+		init_completion(&fibctx->compl);
 		fibctx->wait = 0;
 		/*
 		 *	Initialize the fibs and set the count of fibs on
@@ -310,7 +311,7 @@ return_fib:
 			ssleep(1);
 		}
 		if (f.wait) {
-			if(down_interruptible(&fibctx->wait_sem) < 0) {
+			if(wait_for_completion_interruptible(&fibctx->compl) < 0) {
 				status = -EINTR;
 			} else {
 				/* Lock again and retry */
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 81b3692..486bdb3 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1440,7 +1440,7 @@ int aac_check_health(struct aac_dev * aac)
 			 * Set the event to wake up the
 			 * thread that will waiting.
 			 */
-			up(&fibctx->wait_sem);
+			complete(&fibctx->compl);
 		} else {
 			printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
 			kfree(fib);
@@ -1671,7 +1671,7 @@ int aac_command_thread(void *data)
 						 * Set the event to wake up the
 						 * thread that is waiting.
 						 */
-						up(&fibctx->wait_sem);
+						complete(&fibctx->compl);
 					} else {
 						printk(KERN_WARNING "aifd: didn't allocate NewFib.\n");
 					}
-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

  Si deseas mantener tu libertad, debes estar preparado para defenderla
                          (Richard Stallman)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
