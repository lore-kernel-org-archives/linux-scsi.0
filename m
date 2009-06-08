From: scameron@beardog.cca.cpqcorp.net
Subject: [patch 1/8] cciss: Use schedule_timeout_uninterruptible in SCSI error handling code
Date: Mon, 8 Jun 2009 15:59:38 -0500
Message-ID: <20090608205938.GG23523@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:20078 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232AbZFHU7O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 16:59:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk, akpm@linux-foundation.org
Cc: scameron@beardog.cca.cpqcorp.net, mikem@beardog.cca.cpqcorp.net



Use schedule_timeout_uninterruptible instead of schedule_timeout in the
scsi error handling code when waiting between TUR polls since we are not
interested in nor want to be interrupted by signals.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cca.cpqcorp.net>

---

---


diff -puN drivers/block/cciss_scsi.c~use_uninterruptible_timeout drivers/block/cciss_scsi.c
--- linux-next/drivers/block/cciss_scsi.c~use_uninterruptible_timeout	2009-06-08 12:56:39.000000000 -0500
+++ linux-next-scameron/drivers/block/cciss_scsi.c	2009-06-08 12:57:17.000000000 -0500
@@ -1608,7 +1608,7 @@ static int wait_for_device_to_become_rea
 		/* Wait for a bit.  do this first, because if we send
 		 * the TUR right away, the reset will just abort it.
 		 */
-		schedule_timeout_interruptible(waittime);
+		schedule_timeout_uninterruptible(waittime);
 		count++;
 
 		/* Increase wait time with each try, up to a point. */
_
