From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/7 v3] blk-mq: fix use of incorrect goto label in
 blk_mq_init_queue error path
Date: Thu, 12 Mar 2015 23:53:26 -0400
Message-ID: <20150313035326.GA8982@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
 <1426132602-34331-2-git-send-email-snitzer@redhat.com>
 <20150312142730.GA3159@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150312142730.GA3159@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: dm-devel@redhat.com, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If percpu_ref_init() fails the allocated q and hctxs must get cleaned
up; using 'err_map' doesn't allow that to happen.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4f4bea2..b7b8933 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1938,7 +1938,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	 */
 	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
 			    PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
-		goto err_map;
+		goto err_mq_usage;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
 	blk_queue_rq_timeout(q, 30000);
@@ -1981,7 +1981,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 
 	if (blk_mq_init_hw_queues(q, set))
-		goto err_hw;
+		goto err_mq_usage;
 
 	mutex_lock(&all_q_mutex);
 	list_add_tail(&q->all_q_node, &all_q_list);
@@ -1993,7 +1993,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 
 	return q;
 
-err_hw:
+err_mq_usage:
 	blk_cleanup_queue(q);
 err_hctxs:
 	kfree(map);
-- 
1.9.5 (Apple Git-50.3)
