From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 6/7] aacraid: unlock around kfree
Date: Wed, 03 Aug 2005 15:39:36 -0700
Message-ID: <1123108776.24945.40.camel@markh1.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:51170 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S261591AbVHCWjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2005 18:39:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn from Adaptec:

kfree has the possibility of sleeping. It is generally considered poor
manners to hold on to a lock with the possibility of a system call
induced sleep.

Applies to scsi-misc-2.6 git tree

Signed-off-by: Mark Haverkamp <markh@osdl.org>

Index: scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c
===================================================================
--- scsi-misc-aac-1.orig/drivers/scsi/aacraid/commctrl.c	2005-07-05 14:18:07.000000000 -0700
+++ scsi-misc-aac-1/drivers/scsi/aacraid/commctrl.c	2005-07-05 14:59:24.000000000 -0700
@@ -324,8 +324,10 @@
 		/*
 		 *	Free the space occupied by this copy of the fib.
 		 */
+		spin_unlock_irq(&dev->fib_lock);
 		kfree(fib->hw_fib);
 		kfree(fib);
+		spin_lock_irq(&dev->fib_lock);
 	}
 	/*
 	 *	Remove the Context from the AdapterFibContext List
@@ -338,7 +340,9 @@
 	/*
 	 *	Free the space occupied by the Context
 	 */
+	spin_unlock_irq(&dev->fib_lock);
 	kfree(fibctx);
+	spin_lock_irq(&dev->fib_lock);
 	return 0;
 }
 

-- 
Mark Haverkamp <markh@osdl.org>

