From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/2] dm: Avoid use-after-free of a mapped device
Date: Fri, 22 Feb 2013 11:47:31 +0100
Message-ID: <51274CC3.9070204@acm.org>
References: <51274C2F.6070500@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:38688 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab3BVKrc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Feb 2013 05:47:32 -0500
In-Reply-To: <51274C2F.6070500@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@redhat.com>, Tejun Heo <tj@kernel.org>, James Bottomley <JBottomley@parallels.com>

As the comment above rq_completed() explains, md members must
not be touched after the dm_put() at the end of that function
has been invoked. Avoid that the md->queue can be run
asynchronously after the last md reference has been dropped by
running that queue synchronously. This patch fixes the
following kernel oops:

general protection fault: 0000 [#1] SMP
RIP: 0010:[<ffffffff810fe754>]  [<ffffffff810fe754>] mempool_free+0x24/0xb0
Call Trace:
  <IRQ>
  [<ffffffff81187417>] bio_put+0x97/0xc0
  [<ffffffffa02247a5>] end_clone_bio+0x35/0x90 [dm_mod]
  [<ffffffff81185efd>] bio_endio+0x1d/0x30
  [<ffffffff811f03a3>] req_bio_endio.isra.51+0xa3/0xe0
  [<ffffffff811f2f68>] blk_update_request+0x118/0x520
  [<ffffffff811f3397>] blk_update_bidi_request+0x27/0xa0
  [<ffffffff811f343c>] blk_end_bidi_request+0x2c/0x80
  [<ffffffff811f34d0>] blk_end_request+0x10/0x20
  [<ffffffffa000b32b>] scsi_io_completion+0xfb/0x6c0 [scsi_mod]
  [<ffffffffa000107d>] scsi_finish_command+0xbd/0x120 [scsi_mod]
  [<ffffffffa000b12f>] scsi_softirq_done+0x13f/0x160 [scsi_mod]
  [<ffffffff811f9fd0>] blk_done_softirq+0x80/0xa0
  [<ffffffff81044551>] __do_softirq+0xf1/0x250
  [<ffffffff8142ee8c>] call_softirq+0x1c/0x30
  [<ffffffff8100420d>] do_softirq+0x8d/0xc0
  [<ffffffff81044885>] irq_exit+0xd5/0xe0
  [<ffffffff8142f3e3>] do_IRQ+0x63/0xe0
  [<ffffffff814257af>] common_interrupt+0x6f/0x6f
  <EOI>
  [<ffffffffa021737c>] srp_queuecommand+0x8c/0xcb0 [ib_srp]
  [<ffffffffa0002f18>] scsi_dispatch_cmd+0x148/0x310 [scsi_mod]
  [<ffffffffa000a38e>] scsi_request_fn+0x31e/0x520 [scsi_mod]
  [<ffffffff811f1e57>] __blk_run_queue+0x37/0x50
  [<ffffffff811f1f69>] blk_delay_work+0x29/0x40
  [<ffffffff81059003>] process_one_work+0x1c3/0x5c0
  [<ffffffff8105b22e>] worker_thread+0x15e/0x440
  [<ffffffff8106164b>] kthread+0xdb/0xe0
  [<ffffffff8142db9c>] ret_from_fork+0x7c/0xb0

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: James Bottomley <JBottomley@parallels.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 314a0e2..0218fc3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -729,13 +729,13 @@ static void rq_completed(struct mapped_device *md, int rw, int run_queue)
 		wake_up(&md->wait);
 
 	/*
-	 * Run this off this callpath, as drivers could invoke end_io while
-	 * inside their request_fn (and holding the queue lock). Calling
-	 * back into ->request_fn() could deadlock attempting to grab the
-	 * queue lock again.
+	 * Although this function may be invoked indirectly from inside
+	 * blk_run_queue(), invoking blk_run_queue() here is safe because that
+	 * function returns immediately when it detects that it has been
+	 * called recursively.
 	 */
 	if (run_queue)
-		blk_run_queue_async(md->queue);
+		blk_run_queue(md->queue);
 
 	/*
 	 * dm_put() must be at the end of this function. See the comment above
-- 
1.7.10.4

