From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: [PATCH 1/1] cciss: use timeout to ensure scan thread exits
Date: Tue, 16 Jun 2009 15:43:25 -0500
Message-ID: <20090616204325.GA29502@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:6080 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764188AbZFPUnA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 16:43:00 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, LKML <linux-kernel@vger.kernel.org>, LKML-SCSI <linux-scsi@vger.kernel.org>

Patch 1 of 1

This patch implements wait_for_completion_interruptible_timeout in the
scan_thread function to ensure it will exit cleanly during rmmod. Calling
complete in cciss_remove_one caused a race condition. Using the wait with a
timeout seems to work around that but it does fire the thread. The overhead
should be minimal.

Changelog:
Replace wait_for_completion_interruptible with
wait_for_completion_interruptible_timeout in scan_thread().
Use 5 second timeout value to avoid race.

Signed-off-by: Mike Miller

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4d4d5e0..76e7c10 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3043,7 +3043,7 @@ static int scan_thread(void *data)
 	h->rescan_wait = &wait;
 
 	for (;;) {
-		rc = wait_for_completion_interruptible(&wait);
+		rc = wait_for_completion_interruptible_timeout(&wait, 5);
 		if (kthread_should_stop())
 			break;
 		if (!rc)
