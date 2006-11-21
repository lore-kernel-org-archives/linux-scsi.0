From: Mark Haverkamp <markh@osdl.org>
Subject: [PATCH 1/3] aacraid: Detect Blinkled at startup
Date: Tue, 21 Nov 2006 10:40:08 -0800
Message-ID: <1164134408.18765.37.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:14220 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1031290AbWKUSkL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 13:40:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Mark Salyzyn <mark_salyzyn@adaptec.com>

Received from Mark Salyzyn:

Blinkled at startup is useful for catching Adapters in a lot of pain, in a
BlinkLED assert, quickly; rather than waiting several minutes for commands to
timeout.

Signed-off-by: Mark Haverkamp <markh@osdl.org>

---
Applies to the scsi-misc-2.6 tree.

--- scsi-misc-aac.orig/drivers/scsi/aacraid/commsup.c	2006-11-16 14:55:35.000000000 -0800
+++ scsi-misc-aac/drivers/scsi/aacraid/commsup.c	2006-11-21 10:16:06.000000000 -0800
@@ -518,6 +518,7 @@
 			 */
 			unsigned long count = 36000000L; /* 3 minutes */
 			while (down_trylock(&fibptr->event_wait)) {
+				int blink;
 				if (--count == 0) {
 					spin_lock_irqsave(q->lock, qflags);
 					q->numpending--;
@@ -530,6 +531,14 @@
 					}
 					return -ETIMEDOUT;
 				}
+				if ((blink = aac_adapter_check_health(dev)) > 0) {
+					if (wait == -1) {
+	        				printk(KERN_ERR "aacraid: aac_fib_send: adapter blinkLED 0x%x.\n"
+						  "Usually a result of a serious unrecoverable hardware problem\n",
+						  blink);
+					}
+					return -EFAULT;
+				}
 				udelay(5);
 			}
 		} else if (down_interruptible(&fibptr->event_wait)) {

-- 
Mark Haverkamp <markh@osdl.org>

