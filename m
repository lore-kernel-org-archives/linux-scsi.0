From: Robert Elliott <elliott@hp.com>
Subject: [PATCH 2/3] blk-mq: pass along blk_mq_alloc_tag_set return values
Date: Thu, 17 Jul 2014 14:39:21 -0500
Message-ID: <20140717193915.1924.24620.stgit@beardog.cce.hp.com>
References: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140717193707.1924.87867.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, abhijit.mahajan@avagotech.com, kmo@datarainc.com, nagalakshmi.nandigama@avagotech.com, asamymuthupa@micron.com, snitzer@redhat.com, JBottomley@parallels.com, relliott@beardog.cce.hp.com, sreekanth.reddy@avagotech.com, praveen.krishnamoorthy@avagotech.com, agordeev@redhat.com, scameron@beardog.cce.hp.com, tom.leiming@gmail.com, elliott@hp.com, sbradshaw@micron.com, hch@lst.de, m@bjorling.me
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Two of the blk-mq based drivers do not pass back the return value
from blk_mq_alloc_tag_set, instead just returning -ENOMEM.

blk_mq_alloc_tag_set returns -EINVAL if the number of queues or
queue depth is bad.  -ENOMEM implies that retrying after freeing some
memory might be more successful, but that won't ever change
in the -EINVAL cases.

Change the null_blk and mtip32xx drivers to pass along
the return value.

Signed-off-by: Robert Elliott <elliott@hp.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    1 -
 drivers/block/null_blk.c          |   29 +++++++++++++++++++++--------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 295f3af..af72232 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -3918,7 +3918,6 @@ skip_create_disk:
 	if (rv) {
 		dev_err(&dd->pdev->dev,
 			"Unable to allocate request queue\n");
-		rv = -ENOMEM;
 		goto block_queue_alloc_init_error;
 	}
 
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index a3b042c..00d469c 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -462,17 +462,21 @@ static int null_add_dev(void)
 	struct gendisk *disk;
 	struct nullb *nullb;
 	sector_t size;
+	int rv;
 
 	nullb = kzalloc_node(sizeof(*nullb), GFP_KERNEL, home_node);
-	if (!nullb)
+	if (!nullb) {
+		rv = -ENOMEM;
 		goto out;
+	}
 
 	spin_lock_init(&nullb->lock);
 
 	if (queue_mode == NULL_Q_MQ && use_per_node_hctx)
 		submit_queues = nr_online_nodes;
 
-	if (setup_queues(nullb))
+	rv = setup_queues(nullb);
+	if (rv)
 		goto out_free_nullb;
 
 	if (queue_mode == NULL_Q_MQ) {
@@ -484,22 +488,29 @@ static int null_add_dev(void)
 		nullb->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
 		nullb->tag_set.driver_data = nullb;
 
-		if (blk_mq_alloc_tag_set(&nullb->tag_set))
+		rv = blk_mq_alloc_tag_set(&nullb->tag_set);
+		if (rv)
 			goto out_cleanup_queues;
 
 		nullb->q = blk_mq_init_queue(&nullb->tag_set);
-		if (!nullb->q)
+		if (!nullb->q) {
+			rv = -ENOMEM;
 			goto out_cleanup_tags;
+		}
 	} else if (queue_mode == NULL_Q_BIO) {
 		nullb->q = blk_alloc_queue_node(GFP_KERNEL, home_node);
-		if (!nullb->q)
+		if (!nullb->q) {
+			rv = -ENOMEM;
 			goto out_cleanup_queues;
+		}
 		blk_queue_make_request(nullb->q, null_queue_bio);
 		init_driver_queues(nullb);
 	} else {
 		nullb->q = blk_init_queue_node(null_request_fn, &nullb->lock, home_node);
-		if (!nullb->q)
+		if (!nullb->q) {
+			rv = -ENOMEM;
 			goto out_cleanup_queues;
+		}
 		blk_queue_prep_rq(nullb->q, null_rq_prep_fn);
 		blk_queue_softirq_done(nullb->q, null_softirq_done_fn);
 		init_driver_queues(nullb);
@@ -509,8 +520,10 @@ static int null_add_dev(void)
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, nullb->q);
 
 	disk = nullb->disk = alloc_disk_node(1, home_node);
-	if (!disk)
+	if (!disk) {
+		rv = -ENOMEM;
 		goto out_cleanup_blk_queue;
+	}
 
 	mutex_lock(&lock);
 	list_add_tail(&nullb->list, &nullb_list);
@@ -544,7 +557,7 @@ out_cleanup_queues:
 out_free_nullb:
 	kfree(nullb);
 out:
-	return -ENOMEM;
+	return rv;
 }
 
 static int __init null_init(void)
