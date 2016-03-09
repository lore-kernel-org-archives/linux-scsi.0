From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] dm-thin: enable low water mark disk event
Date: Wed,  9 Mar 2016 14:16:31 +0100
Message-ID: <1457529392-53970-4-git-send-email-hare@suse.de>
References: <1457529392-53970-1-git-send-email-hare@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1457529392-53970-1-git-send-email-hare@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jeff Mahoney <jeffm@suse.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Enable sending of a 'low water mark' disk event and add
supporting infrastructure to the DM core.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/md/dm-thin.c |  2 ++
 drivers/md/dm.c      | 27 +++++++++++++++++++++++++++
 drivers/md/dm.h      |  3 ++-
 3 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 72d91f4..c191839 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -1345,6 +1345,7 @@ static void check_low_water_mark(struct pool *pool, dm_block_t free_blocks)
 		spin_lock_irqsave(&pool->lock, flags);
 		pool->low_water_triggered = true;
 		spin_unlock_irqrestore(&pool->lock, flags);
+		dm_set_disk_event(pool->pool_md, DISK_EVENT_LOWAT);
 		dm_table_event(pool->ti->table);
 	}
 }
@@ -4058,6 +4059,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 	atomic_set(&tc->refcount, 1);
+	dm_enable_disk_event(pool_md, DISK_EVENT_LOWAT);
 	init_completion(&tc->can_destroy);
 	list_add_tail_rcu(&tc->list, &tc->pool->active_thins);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 5df4048..8d22c40 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -198,6 +198,7 @@ struct mapped_device {
 	wait_queue_head_t eventq;
 	atomic_t uevent_seq;
 	struct list_head uevent_list;
+	unsigned int disk_events;
 	spinlock_t uevent_lock; /* Protect access to uevent_list */
 
 	/*
@@ -556,6 +557,16 @@ static int dm_blk_getgeo(struct block_device *bdev, struct hd_geometry *geo)
 	return dm_get_geometry(md, geo);
 }
 
+static unsigned int dm_check_events(struct gendisk *disk, unsigned int mask)
+{
+	struct mapped_device *md = disk->private_data;
+	unsigned int pending = md->disk_events & mask;
+
+	md->disk_events &= ~mask;
+
+	return pending;
+}
+
 static int dm_get_live_table_for_ioctl(struct mapped_device *md,
 		struct dm_target **tgt, struct block_device **bdev,
 		fmode_t *mode, int *srcu_idx)
@@ -2457,6 +2468,8 @@ static void event_callback(void *context)
 
 	dm_send_uevents(&uevents, &disk_to_dev(md->disk)->kobj);
 
+	disk_clear_events(md->disk, md->disk_events);
+
 	atomic_inc(&md->event_nr);
 	wake_up(&md->eventq);
 }
@@ -3423,6 +3436,19 @@ void dm_uevent_add(struct mapped_device *md, struct list_head *elist)
 	spin_unlock_irqrestore(&md->uevent_lock, flags);
 }
 
+void dm_set_disk_event(struct mapped_device *md, unsigned int evt)
+{
+	md->disk_events |= evt;
+}
+EXPORT_SYMBOL_GPL(dm_set_disk_event);
+
+void dm_enable_disk_event(struct mapped_device *md, unsigned int evt)
+{
+	md->disk->events |= evt;
+	md->disk->async_events |= evt;
+}
+EXPORT_SYMBOL_GPL(dm_enable_disk_event);
+
 /*
  * The gendisk is only valid as long as you have a reference
  * count on 'md'.
@@ -3678,6 +3704,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.ioctl = dm_blk_ioctl,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.check_events = dm_check_events,
 	.owner = THIS_MODULE
 };
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7edcf97..fa3dc10 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -83,7 +83,8 @@ void dm_unlock_md_type(struct mapped_device *md);
 void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
-
+void dm_set_disk_event(struct mapped_device *md, unsigned int evt);
+void dm_enable_disk_event(struct mapped_device *md, unsigned int evt);
 int dm_setup_md_queue(struct mapped_device *md);
 
 /*
-- 
1.8.5.6

