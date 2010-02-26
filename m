From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH][resubmit] cciss: fix spinlock use
Date: Fri, 26 Feb 2010 15:39:11 +0100
Message-ID: <4B87DD0F.1060506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884Ab0BZOj4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Feb 2010 09:39:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>, Mike.Miller@hp.com

This is a third attempt - it is already
acked by Mike Miller - http://article.gmane.org/gmane.linux.scsi/54492

fail_all_cmds is called from do_cciss_intr with spinlock acquired.
So when in an error-handling situation, fail_all_cmds() is called 
it attempts to *reacquire* the lock.

This removes the spinlock lock/unlock from fail_all_cmds and adds a
spin_unlock after the call to fail_all_cmds before return.  

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 873e594..0a3fce8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3298,6 +3298,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 					       "cciss: controller cciss%d failed, stopping.\n",
 					       h->ctlr);
 					fail_all_cmds(h->ctlr);
+					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 					return IRQ_HANDLED;
 				}
 
@@ -4553,8 +4554,6 @@ static void fail_all_cmds(unsigned long ctlr)
 	printk(KERN_WARNING "cciss%d: controller not responding.\n", h->ctlr);
 	h->alive = 0;		/* the controller apparently died... */
 
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-
 	pci_disable_device(h->pdev);	/* Make sure it is really dead. */
 
 	/* move everything off the request queue onto the completed queue */
@@ -4580,7 +4579,6 @@ static void fail_all_cmds(unsigned long ctlr)
 			complete_scsi_command(c, 0, 0);
 #endif
 	}
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	return;
 }
 


