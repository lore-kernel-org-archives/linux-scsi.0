From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] cciss: resubmit - fix spinlock use
Date: Fri, 18 Sep 2009 17:42:23 +0300
Message-ID: <4AB39C4F.6070001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbZIROmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 10:42:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andrew.patterson@hp.com, "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

fail_all_cmds is called (only) from do_cciss_intr with 
spinlock acquired.
So when in an error-handling situation,
fail_all_cmds() is called it attempts to *reacquire* the lock.
This has been found and analysed by Prarit Bhargava.

This patch removes the spinlock lock/unlock from fail_all_cmds and adds a
spin_unlock after the call to fail_all_cmds before return.  

Signed-off-by: Tomas Henzl <thenzl@redhat.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c7a527c..b45776e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3181,6 +3181,7 @@ static irqreturn_t do_cciss_intr(int irq, void *dev_id)
 					       "cciss: controller cciss%d failed, stopping.\n",
 					       h->ctlr);
 					fail_all_cmds(h->ctlr);
+					spin_unlock_irqrestore(CCISS_LOCK(h->ctlr), flags);
 					return IRQ_HANDLED;
 				}
 
@@ -4230,8 +4231,6 @@ static void fail_all_cmds(unsigned long ctlr)
 	printk(KERN_WARNING "cciss%d: controller not responding.\n", h->ctlr);
 	h->alive = 0;		/* the controller apparently died... */
 
-	spin_lock_irqsave(CCISS_LOCK(ctlr), flags);
-
 	pci_disable_device(h->pdev);	/* Make sure it is really dead. */
 
 	/* move everything off the request queue onto the completed queue */
@@ -4256,7 +4255,6 @@ static void fail_all_cmds(unsigned long ctlr)
 			complete_scsi_command(c, 0, 0);
 #endif
 	}
-	spin_unlock_irqrestore(CCISS_LOCK(ctlr), flags);
 	return;
 }
 

-- 1.6.0.6
