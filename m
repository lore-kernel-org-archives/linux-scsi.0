From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/30] btrfs: replace barriers with explicit
	flush / FUA usage
Date: Wed, 25 Aug 2010 17:47:37 +0200
Message-ID: <1282751267-3530-21-git-send-email-tj@kernel.org>
References: <1282751267-3530-1-git-send-email-tj@kernel.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1282751267-3530-1-git-send-email-tj@kernel.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@l
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

Switch to the WRITE_FLUSH_FUA flag for log writes, remove the EOPNOTSUPP
detection for barriers and stop setting the barrier flag for discards.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/btrfs/disk-io.c     |   19 ++++---------------
 fs/btrfs/extent-tree.c |    2 +-
 fs/btrfs/volumes.c     |    4 ----
 fs/btrfs/volumes.h     |    1 -
 4 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 64f1008..5e789f4 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2063,7 +2063,7 @@ static void btrfs_end_buffer_write_sync(struct buffer_head *bh, int uptodate)
 	if (uptodate) {
 		set_buffer_uptodate(bh);
 	} else {
-		if (!buffer_eopnotsupp(bh) && printk_ratelimit()) {
+		if (printk_ratelimit()) {
 			printk(KERN_WARNING "lost page write due to "
 					"I/O error on %s\n",
 				       bdevname(bh->b_bdev, b));
@@ -2200,21 +2200,10 @@ static int write_dev_supers(struct btrfs_device *device,
 			bh->b_end_io = btrfs_end_buffer_write_sync;
 		}
 
-		if (i == last_barrier && do_barriers && device->barriers) {
-			ret = submit_bh(WRITE_BARRIER, bh);
-			if (ret == -EOPNOTSUPP) {
-				printk("btrfs: disabling barriers on dev %s\n",
-				       device->name);
-				set_buffer_uptodate(bh);
-				device->barriers = 0;
-				/* one reference for submit_bh */
-				get_bh(bh);
-				lock_buffer(bh);
-				ret = submit_bh(WRITE_SYNC, bh);
-			}
-		} else {
+		if (i == last_barrier && do_barriers)
+			ret = submit_bh(WRITE_FLUSH_FUA, bh);
+		else
 			ret = submit_bh(WRITE_SYNC, bh);
-		}
 
 		if (ret)
 			errors++;
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 32d0940..43dc9ea 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1696,7 +1696,7 @@ static void btrfs_issue_discard(struct block_device *bdev,
 				u64 start, u64 len)
 {
 	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL,
-			BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+			BLKDEV_IFL_WAIT);
 }
 
 static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index dd318ff..e25e46a 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -398,7 +398,6 @@ static noinline int device_list_add(const char *path,
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, disk_super->dev_item.uuid,
 		       BTRFS_UUID_SIZE);
-		device->barriers = 1;
 		spin_lock_init(&device->io_lock);
 		device->name = kstrdup(path, GFP_NOFS);
 		if (!device->name) {
@@ -462,7 +461,6 @@ static struct btrfs_fs_devices *clone_fs_devices(struct btrfs_fs_devices *orig)
 		device->devid = orig_dev->devid;
 		device->work.func = pending_bios_fn;
 		memcpy(device->uuid, orig_dev->uuid, sizeof(device->uuid));
-		device->barriers = 1;
 		spin_lock_init(&device->io_lock);
 		INIT_LIST_HEAD(&device->dev_list);
 		INIT_LIST_HEAD(&device->dev_alloc_list);
@@ -1489,7 +1487,6 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
 	trans = btrfs_start_transaction(root, 0);
 	lock_chunks(root);
 
-	device->barriers = 1;
 	device->writeable = 1;
 	device->work.func = pending_bios_fn;
 	generate_random_uuid(device->uuid);
@@ -3084,7 +3081,6 @@ static struct btrfs_device *add_missing_dev(struct btrfs_root *root,
 		return NULL;
 	list_add(&device->dev_list,
 		 &fs_devices->devices);
-	device->barriers = 1;
 	device->dev_root = root->fs_info->dev_root;
 	device->devid = devid;
 	device->work.func = pending_bios_fn;
diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
index 31b0fab..2b638b6 100644
--- a/fs/btrfs/volumes.h
+++ b/fs/btrfs/volumes.h
@@ -42,7 +42,6 @@ struct btrfs_device {
 	int running_pending;
 	u64 generation;
 
-	int barriers;
 	int writeable;
 	int in_fs_metadata;
 
-- 
1.7.1
