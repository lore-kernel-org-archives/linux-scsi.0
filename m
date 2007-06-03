From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Atari SCSI driver update_timeout removal
Date: Sun, 3 Jun 2007 12:55:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706031250190.9351@anakin>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:38671 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbXFCKzb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 06:55:31 -0400
Received: from adicia.telenet-ops.be (adicia.telenet-ops.be [195.130.132.56])
	by hoefnix.telenet-ops.be (Postfix) with ESMTP id E78029D1D0
	for <linux-scsi@vger.kernel.org>; Sun,  3 Jun 2007 12:55:28 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>

From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>

Atari SCSI driver fixes: remove update_timeout kludge

Signed-off-by: Michael Schmitz <schmitz@debian.org>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Christoph Hellwig <hch@lst.de>
---
This removes the timeout kludge in commit
fb810d121bceb945c5e576356bccba11cbfad7e3 that was NAK'ed by Christoph.

 drivers/scsi/atari_NCR5380.c |   44 +------------------------------------------
 1 file changed, 2 insertions(+), 42 deletions(-)

--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -894,45 +894,6 @@ static int NCR5380_init(struct Scsi_Host
 }
 
 /*
- * our own old-style timeout update
- */
-/*
- * The strategy is to cause the timer code to call scsi_times_out()
- * when the soonest timeout is pending.
- * The arguments are used when we are queueing a new command, because
- * we do not want to subtract the time used from this time, but when we
- * set the timer, we want to take this value into account.
- */
-
-int atari_scsi_update_timeout(Scsi_Cmnd * SCset, int timeout)
-{
-	int rtn;
-
-	/*
-	 * We are using the new error handling code to actually register/deregister
-	 * timers for timeout.
-	 */
-
-	if (!timer_pending(&SCset->eh_timeout))
-		rtn = 0;
-	else
-		rtn = SCset->eh_timeout.expires - jiffies;
-
-	if (timeout == 0) {
-		del_timer(&SCset->eh_timeout);
-		SCset->eh_timeout.data = (unsigned long)NULL;
-		SCset->eh_timeout.expires = 0;
-	} else {
-		if (SCset->eh_timeout.data != (unsigned long)NULL)
-			del_timer(&SCset->eh_timeout);
-		SCset->eh_timeout.data = (unsigned long)SCset;
-		SCset->eh_timeout.expires = jiffies + timeout;
-		add_timer(&SCset->eh_timeout);
-	}
-	return rtn;
-}
-
-/*
  * Function : int NCR5380_queue_command (Scsi_Cmnd *cmd,
  *	void (*done)(Scsi_Cmnd *))
  *
@@ -956,7 +917,6 @@ static int NCR5380_queue_command(Scsi_Cm
 	Scsi_Cmnd *tmp;
 	int oldto;
 	unsigned long flags;
-	// extern int update_timeout(Scsi_Cmnd * SCset, int timeout);
 
 #if (NDEBUG & NDEBUG_NO_WRITE)
 	switch (cmd->cmnd[0]) {
@@ -1029,9 +989,9 @@ static int NCR5380_queue_command(Scsi_Cm
 	 * alter queues and touch the lock.
 	 */
 	if (!IS_A_TT()) {
-		oldto = atari_scsi_update_timeout(cmd, 0);
+		/* perhaps stop command timer here */
 		falcon_get_lock();
-		atari_scsi_update_timeout(cmd, oldto);
+		/* perhaps restart command timer here */
 	}
 	if (!(hostdata->issue_queue) || (cmd->cmnd[0] == REQUEST_SENSE)) {
 		LIST(cmd, hostdata->issue_queue);

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
