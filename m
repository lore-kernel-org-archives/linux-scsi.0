From: Adrian Bunk <bunk@stusta.de>
Subject: [patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer dereference
Date: Wed, 23 Nov 2005 23:34:52 +0100
Message-ID: <20051123223452.GB3963@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030433AbVKWWfh@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Cc: markus.lidel@shadowconnect.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Mark Salyzyn <mark_salyzyn@adaptec.com>
List-Id: linux-scsi@vger.kernel.org

The Coverity checker spotted this obvious NULL pointer dereference.


Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Mark Salyzyn <mark_salyzyn@adaptec.com>

---

This patch was already sent on:
- 21 Nov 2005

 drivers/scsi/dpt_i2o.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c.old	2005-11-20 22:13:37.000000000 +0100
+++ linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c	2005-11-20 22:16:57.000000000 +0100
@@ -816,7 +816,7 @@
 static void adpt_i2o_sys_shutdown(void)
 {
 	adpt_hba *pHba, *pNext;
-	struct adpt_i2o_post_wait_data *p1, *p2;
+	struct adpt_i2o_post_wait_data *p1, *old;
 
 	 printk(KERN_INFO"Shutting down Adaptec I2O controllers.\n");
 	 printk(KERN_INFO"   This could take a few minutes if there are many devices attached\n");
@@ -830,13 +830,14 @@
 	}
 
 	/* Remove any timedout entries from the wait queue.  */
-	p2 = NULL;
 //	spin_lock_irqsave(&adpt_post_wait_lock, flags);
 	/* Nothing should be outstanding at this point so just
 	 * free them 
 	 */
-	for(p1 = adpt_post_wait_queue; p1; p2 = p1, p1 = p2->next) {
-		kfree(p1);
+	for(p1 = adpt_post_wait_queue; p1;) {
+		old = p1;
+		p1 = p1->next;
+		kfree(old);
 	}
 //	spin_unlock_irqrestore(&adpt_post_wait_lock, flags);
 	adpt_post_wait_queue = NULL;
