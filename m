From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/7 v2] blk-mq: fix use of incorrect goto label in
 blk_mq_init_queue error path
Date: Thu, 12 Mar 2015 10:27:30 -0400
Message-ID: <20150312142730.GA3159@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
 <1426132602-34331-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbbCLO1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2015 10:27:37 -0400
Content-Disposition: inline
In-Reply-To: <1426132602-34331-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, Ming Lei <ming.lei@canonical.com>

If percpu_ref_init() fails the 'err_hctxs' label should be used instead
of 'err_map'.

Rather than reuse 'err_hw', which was introduced if the later
blk_mq_init_hw_queues() call fails, move percpu_ref_init() before
blk_alloc_queue_node().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4f4bea2..0a877d2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1928,17 +1928,17 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 		hctxs[i]->queue_num = i;
 	}
 
-	q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
-	if (!q)
-		goto err_hctxs;
-
 	/*
 	 * Init percpu_ref in atomic mode so that it's faster to shutdown.
 	 * See blk_register_queue() for details.
 	 */
 	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
 			    PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
-		goto err_map;
+		goto err_hctxs;
+
+	q = blk_alloc_queue_node(GFP_KERNEL, set->numa_node);
+	if (!q)
+		goto err_hctxs;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
 	blk_queue_rq_timeout(q, 30000);
-- 
1.9.5 (Apple Git-50.3)

