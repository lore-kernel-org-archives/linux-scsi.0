From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 2/2] dm: Avoid running the md queue after the last dm_put()
Date: Wed, 27 Feb 2013 15:48:07 +0100
Message-ID: <512E1CA7.1030404@acm.org>
References: <512E1C06.2000903@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:56313 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3B0OsI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Feb 2013 09:48:08 -0500
In-Reply-To: <512E1C06.2000903@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>, Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

At least in theory the mapped device can disappear after
rq_completed() has invoked dm_put() and before the queue of
the mapped device has been run. Avoid this by running the
queue synchronously instead of asynchronously. Note: the
previous patch makes invoking blk_run_queue() from inside
dm_request_fn() safe.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 314a0e2..28b7ad4 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -728,14 +728,8 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 	if (!md_in_flight(md))
 		wake_up(&md->wait);
 
-	/*
-	 * Run this off this callpath, as drivers could invoke end_io while
-	 * inside their request_fn (and holding the queue lock). Calling
-	 * back into ->request_fn() could deadlock attempting to grab the
-	 * queue lock again.
-	 */
 	if (run_queue)
-		blk_run_queue_async(md->queue);
+		blk_run_queue(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.7.10.4

