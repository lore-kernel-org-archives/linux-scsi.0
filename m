From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] block: Make del_gendisk() safer for disks without queues
Date: Wed,  8 Mar 2017 17:48:33 +0100
Message-ID: <20170308164834.14302-4-jack@suse.cz>
References: <20170308164834.14302-1-jack@suse.cz>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170308164834.14302-1-jack@suse.cz>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-scsi@vger.kernel.org

Commit 165a5e22fafb "block: Move bdi_unregister() to del_gendisk()"
added disk->queue dereference to del_gendisk(). Although del_gendisk()
is not supposed to be called without disk->queue valid and
blk_unregister_queue() warns in that case, this change will make it oops
instead. Return to the old more robust behavior of just warning when
del_gendisk() gets called for gendisk with disk->queue being NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 block/genhd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index b26a5ea115d0..94f323842b52 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -681,12 +681,16 @@ void del_gendisk(struct gendisk *disk)
 	disk->flags &= ~GENHD_FL_UP;
 
 	sysfs_remove_link(&disk_to_dev(disk)->kobj, "bdi");
-	/*
-	 * Unregister bdi before releasing device numbers (as they can get
-	 * reused and we'd get clashes in sysfs).
-	 */
-	bdi_unregister(disk->queue->backing_dev_info);
-	blk_unregister_queue(disk);
+	if (disk->queue) {
+		/*
+		 * Unregister bdi before releasing device numbers (as they can
+		 * get reused and we'd get clashes in sysfs).
+		 */
+		bdi_unregister(disk->queue->backing_dev_info);
+		blk_unregister_queue(disk);
+	} else {
+		WARN_ON(1);
+	}
 	blk_unregister_region(disk_devt(disk), disk->minors);
 
 	part_stat_set_all(&disk->part0, 0);
-- 
2.10.2
