From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/7] blk-mq: fix use of incorrect goto label in blk_mq_init_queue error path
Date: Wed, 11 Mar 2015 23:56:36 -0400
Message-ID: <1426132602-34331-2-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

If percpu_ref_init() fails the 'err_hctxs' label should be used instead
of 'err_map'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4f4bea2..459840c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1938,7 +1938,7 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_tag_set *set)
 	 */
 	if (percpu_ref_init(&q->mq_usage_counter, blk_mq_usage_counter_release,
 			    PERCPU_REF_INIT_ATOMIC, GFP_KERNEL))
-		goto err_map;
+		goto err_hctxs;
 
 	setup_timer(&q->timeout, blk_mq_rq_timer, (unsigned long) q);
 	blk_queue_rq_timeout(q, 30000);
-- 
1.9.5 (Apple Git-50.3)
