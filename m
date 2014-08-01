From: Jan Kara <jack@suse.cz>
Subject: Interrupt strangeness in scsi_request_fn()
Date: Fri, 1 Aug 2014 22:48:48 +0200
Message-ID: <20140801204848.GE7525@quack.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697AbaHAUsu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Aug 2014 16:48:50 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 968DBACD5
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2014 20:48:49 +0000 (UTC)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hello,

  when debugging one bug, I've noticed one strangeness in
scsi_request_fn(). We enter it with interrupts disabled and queue_lock
held. In the function we do stuff like:
                spin_unlock_irq(shost->host_lock);
                /*
                 * Finally, initialize any error handling parameters, and
                 * set up
                 * the timers for timeouts.
                 */
                scsi_init_cmd_errh(cmd);

                /*
                 * Dispatch the command to the low-level driver.
                 */
                rtn = scsi_dispatch_cmd(cmd);
                spin_lock_irq(q->queue_lock);

Why do we enable interrupts there? The thing is that scsi_request_fn() can
be called from IO completion (thus softirq context) and if we enable
interrupts there, another HW interrupt can interrupt softirq processing
which seems wrong to me.

Now to admit my motivation I have reports from one customer (SLES kernel so
too old to be really interesting upstream but still of some value I
believe) where he's seeing softlockup reports when fully loading his SAN
and from the crash dumps it seems the machine simply spends too long in IO
completion because HW interrupts keep interrupting it plus there's
contention on shost->host_lock. If I change scsi_request_fn() to never
enable interrupts problems go away.

So what would people say to something like the attached patch?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--7JfCtLOvnd9MIVvH
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-scsi-Keep-interrupts-disabled-while-submitting-reque.patch"

>From a7c74ea9375cf0b04a11ac3f00bcd835a8499422 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 1 Aug 2014 22:45:32 +0200
Subject: [PATCH] scsi: Keep interrupts disabled while submitting requests

scsi_request_fn() can be called from softirq context during IO
completion. If it enables interrupts there, HW interrupts can interrupt
softirq processing and queue more IO completion work which can
eventually lead to softlockup reports because IO completion softirq runs
for too long. Keep interrupts disabled in scsi_request_fn().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/scsi/scsi_lib.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f7e316368c99..44b867e9adc9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1481,7 +1481,8 @@ static void scsi_softirq_done(struct request *rq)
  *
  * Returns:     Nothing
  *
- * Lock status: IO request lock assumed to be held when called.
+ * Lock status: IO request lock assumed to be held when called, interrupts
+ * must be disabled.
  */
 static void scsi_request_fn(struct request_queue *q)
 	__releases(q->queue_lock)
@@ -1563,7 +1564,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
 		 *		take the lock again.
 		 */
-		spin_unlock_irq(shost->host_lock);
+		spin_unlock(shost->host_lock);
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1575,7 +1576,7 @@ static void scsi_request_fn(struct request_queue *q)
 		 * Dispatch the command to the low-level driver.
 		 */
 		rtn = scsi_dispatch_cmd(cmd);
-		spin_lock_irq(q->queue_lock);
+		spin_lock(q->queue_lock);
 		if (rtn)
 			goto out_delay;
 	}
@@ -1583,7 +1584,7 @@ static void scsi_request_fn(struct request_queue *q)
 	return;
 
  not_ready:
-	spin_unlock_irq(shost->host_lock);
+	spin_unlock(shost->host_lock);
 
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
@@ -1593,7 +1594,7 @@ static void scsi_request_fn(struct request_queue *q)
 	 * cases (host limits or settings) should run the queue at some
 	 * later time.
 	 */
-	spin_lock_irq(q->queue_lock);
+	spin_lock(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;
 out_delay:
-- 
1.8.1.4


--7JfCtLOvnd9MIVvH--
