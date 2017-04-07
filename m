From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 1/6] blk-mq: Make it safe to use RCU to iterate over blk_mq_tag_set.tag_list
Date: Fri, 7 Apr 2017 11:16:49 -0700
Message-ID: <20170407181654.27836-2-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Since the next patch in this series will use RCU to iterate over
tag_list, make this safe. Add lockdep_assert_held() statements
in functions that iterate over tag_list to make clear that using
list_for_each_entry() instead of list_for_each_entry_rcu() is
fine in these functions.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index f7cd3208bcdf..c26464f9649a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2076,6 +2076,8 @@ static void blk_mq_update_tag_set_depth(struct blk_mq_tag_set *set, bool shared)
 {
 	struct request_queue *q;
 
+	lockdep_assert_held(&set->tag_list_lock);
+
 	list_for_each_entry(q, &set->tag_list, tag_set_list) {
 		blk_mq_freeze_queue(q);
 		queue_set_hctx_shared(q, shared);
@@ -2088,7 +2090,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 	struct blk_mq_tag_set *set = q->tag_set;
 
 	mutex_lock(&set->tag_list_lock);
-	list_del_init(&q->tag_set_list);
+	list_del_rcu(&q->tag_set_list);
+	INIT_LIST_HEAD(&q->tag_set_list);
 	if (list_is_singular(&set->tag_list)) {
 		/* just transitioned to unshared */
 		set->flags &= ~BLK_MQ_F_TAG_SHARED;
@@ -2096,6 +2099,8 @@ static void blk_mq_del_queue_tag_set(struct request_queue *q)
 		blk_mq_update_tag_set_depth(set, false);
 	}
 	mutex_unlock(&set->tag_list_lock);
+
+	synchronize_rcu();
 }
 
 static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
@@ -2113,7 +2118,7 @@ static void blk_mq_add_queue_tag_set(struct blk_mq_tag_set *set,
 	}
 	if (set->flags & BLK_MQ_F_TAG_SHARED)
 		queue_set_hctx_shared(q, true);
-	list_add_tail(&q->tag_set_list, &set->tag_list);
+	list_add_tail_rcu(&q->tag_set_list, &set->tag_list);
 
 	mutex_unlock(&set->tag_list_lock);
 }
@@ -2601,6 +2606,8 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag_set *set, int nr_hw_queues)
 {
 	struct request_queue *q;
 
+	lockdep_assert_held(&set->tag_list_lock);
+
 	if (nr_hw_queues > nr_cpu_ids)
 		nr_hw_queues = nr_cpu_ids;
 	if (nr_hw_queues < 1 || nr_hw_queues == set->nr_hw_queues)
-- 
2.12.0
