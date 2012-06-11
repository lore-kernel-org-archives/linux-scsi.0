From: Ben Collins <bcollins@ubuntu.com>
Subject: [PATCH 3/4] SCSI: AACRAID: Relax the tight timeout loop on fib
 commands
Date: Mon, 11 Jun 2012 14:44:44 -0400
Message-ID: <848be39d31a4dd651d567989ece5dd85fba790ad.1339453250.git.bcollins@ubuntu.com>
References: <cover.1339453250.git.bcollins@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59707 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2FKWko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jun 2012 18:40:44 -0400
Received: by mail-pz0-f46.google.com with SMTP id y13so6004726dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jun 2012 15:40:44 -0700 (PDT)
In-Reply-To: <cover.1339453250.git.bcollins@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>

The loop that waited for syncronous fib commands was causing a CPU stall
when a timeout actually occured.

1) Switch to using a more accurate timeout mechanism.
2) Do not pace the loop with udelay(). Use cpu_relax() to allow for
   scheduling to occur.

Signed-off-by: Ben Collins <bcollins@ubuntu.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aacraid/commsup.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 4b32ca4..906a501 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -564,10 +564,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 			 * functioning because an interrupt routing or other
 			 * hardware failure has occurred.
 			 */
-			unsigned long count = 36000000L; /* 3 minutes */
+			unsigned long timeout = jiffies + (180 * HZ); /* 3 minutes */
 			while (down_trylock(&fibptr->event_wait)) {
 				int blink;
-				if (--count == 0) {
+				if (time_is_before_eq_jiffies(timeout)) {
 					struct aac_queue * q = &dev->queues->queue[AdapNormCmdQueue];
 					spin_lock_irqsave(q->lock, qflags);
 					q->numpending--;
@@ -588,7 +588,10 @@ int aac_fib_send(u16 command, struct fib *fibptr, unsigned long size,
 					}
 					return -EFAULT;
 				}
-				udelay(5);
+				/* We used to udelay() here but that absorbed
+				 * a CPU when a timeout occured. Not very
+				 * useful. */
+				cpu_relax();
 			}
 		} else if (down_interruptible(&fibptr->event_wait)) {
 			/* Do nothing ... satisfy
-- 
1.7.9.5

