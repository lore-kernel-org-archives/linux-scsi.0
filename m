From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [2.6 patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer dereference
Date: Mon, 21 Nov 2005 08:05:53 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01DDCDBB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:7080 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932301AbVKUNH7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 08:07:59 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@stusta.de>, markus.lidel@shadowconnect.com, James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org

Cool, good catch. The driver can make a call to this function at runtime
when performing error recovery, not just at driver unload. Applied to
Adaptec Branch of this driver.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Adrian Bunk
Sent: Sunday, November 20, 2005 6:01 PM
To: markus.lidel@shadowconnect.com; James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
stable@kernel.org
Subject: [2.6 patch] drivers/scsi/dpt_i2o.c: fix a NULL pointer
dereference


The Coverity checker spotted this obvious NULL pointer dereference.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/scsi/dpt_i2o.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c.old
2005-11-20 22:13:37.000000000 +0100
+++ linux-2.6.15-rc1-mm2-full/drivers/scsi/dpt_i2o.c	2005-11-20
22:16:57.000000000 +0100
@@ -816,7 +816,7 @@
 static void adpt_i2o_sys_shutdown(void)
 {
 	adpt_hba *pHba, *pNext;
-	struct adpt_i2o_post_wait_data *p1, *p2;
+	struct adpt_i2o_post_wait_data *p1, *old;
 
 	 printk(KERN_INFO"Shutting down Adaptec I2O controllers.\n");
 	 printk(KERN_INFO"   This could take a few minutes if there are
many devices attached\n");
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

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org More majordomo info
at  http://vger.kernel.org/majordomo-info.html
