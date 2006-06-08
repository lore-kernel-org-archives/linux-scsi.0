From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 3/3] aacraid: small misc. cleanups (update)
Date: Thu, 08 Jun 2006 13:55:57 -0700
Message-ID: <1149800157.22364.38.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10446 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965007AbWFHU4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 16:56:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn

Spelling correction, orphaned comment removal & update branch name.

Signed-off-by: Mark Haverkamp <markh@osdl.org>
---
Applies to the scsi-misc-2.6 git tree.


--- scsi-misc-aac.orig/drivers/scsi/aacraid/aacraid.h	2006-06-08 13:32:20.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/aacraid.h	2006-06-08 13:36:40.000000000 -0700
@@ -12,7 +12,7 @@
 
 #ifndef AAC_DRIVER_BUILD
 # define AAC_DRIVER_BUILD 2409
-# define AAC_DRIVER_BRANCH "-mh1"
+# define AAC_DRIVER_BRANCH "-mh2"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
 
@@ -822,10 +822,6 @@
 	void 			*callback_data;
 	u32			flags; // u32 dmb was ulong
 	/*
-	 *	The following is used to put this fib context onto the 
-	 *	Outstanding I/O queue.
-	 */
-	/*
 	 *	And for the internal issue/reply queues (we may be able
 	 *	to merge these two)
 	 */
--- scsi-misc-aac.orig/drivers/scsi/aacraid/comminit.c	2006-06-08 13:32:20.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/comminit.c	2006-06-08 13:36:40.000000000 -0700
@@ -103,7 +103,7 @@
 	 * This assumes the memory is mapped zero->n, which isnt
 	 * always true on real computers. It also has some slight problems
 	 * with the GART on x86-64. I've btw never tried DMA from PCI space
-	 * on this platform but don't be suprised if its problematic.
+	 * on this platform but don't be surprised if its problematic.
 	 */
 #ifndef CONFIG_GART_IOMMU
 	if ((num_physpages << (PAGE_SHIFT - 12)) <= AAC_MAX_HOSTPHYSMEMPAGES) {
--- scsi-misc-aac.orig/drivers/scsi/aacraid/dpcsup.c	2006-06-08 13:32:20.000000000 -0700
+++ scsi-misc-aac/drivers/scsi/aacraid/dpcsup.c	2006-06-08 13:36:40.000000000 -0700
@@ -85,9 +85,9 @@
 		 *	continue. The caller has already been notified that
 		 *	the fib timed out.
 		 */
-		if (!(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT)) {
+		if (!(fib->flags & FIB_CONTEXT_FLAG_TIMED_OUT))
 			dev->queues->queue[AdapNormCmdQueue].numpending--;
-		} else {
+		else {
 			printk(KERN_WARNING "aacraid: FIB timeout (%x).\n", fib->flags);
 			printk(KERN_DEBUG"aacraid: hwfib=%p fib index=%i fib=%p\n",hwfib, hwfib->header.SenderData,fib);
 			continue;

-- 
Mark Haverkamp <markh@osdl.org>

