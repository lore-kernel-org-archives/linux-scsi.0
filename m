From: Daniel Walker <dwalker@mvista.com>
Subject: aacraid down_interruptible check
Date: Tue, 16 Sep 2008 14:30:02 -0700
Message-ID: <1221600602.1343.20.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([63.81.120.158]:10035 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYIPVaG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Sep 2008 17:30:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


I was reviewing the patch below, and I'm a little confused about the
added up() call. This semaphore is used to signal an interrupt arriving,
where the code below is waiting for the interrupt. The added up()
effectively signals that the interrupt arrived even tho it hasn't..
Which means the next down() call won't sleep at all it just falls
through .. I don't think that is what's desired, but I though I would
ask..

The other question is that it's called conditional on a potentially
random signal getting delivered to this process. Which really make it
seem non-conforming..

Daniel

commit e6990c6448ca9359b6d4ad027c0a6efbf4379e64
Author: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Date:   Mon Apr 14 14:20:16 2008 -0400

    [SCSI] aacraid: Fix down_interruptible() to check the return value
    
    Instead of ignoring the return value in aac_fib_send() return 2 to
    indicate to the layers above that fib transmission was aborted due to
    timeout.
    
    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 5156e05..23a8e9f 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -515,10 +515,12 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
                                }
                                udelay(5);
                        }
-               } else
-                       (void)down_interruptible(&fibptr->event_wait);
+               } else if (down_interruptible(&fibptr->event_wait) == 0) {
+                       fibptr->done = 2;
+                       up(&fibptr->event_wait);
+               }
                spin_lock_irqsave(&fibptr->event_lock, flags);
-               if (fibptr->done == 0) {
+               if ((fibptr->done == 0) || (fibptr->done == 2)) {
                        fibptr->done = 2; /* Tell interrupt we aborted */
                        spin_unlock_irqrestore(&fibptr->event_lock, flags);
                        return -EINTR;


