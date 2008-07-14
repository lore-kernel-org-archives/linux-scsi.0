From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] block: misc updates
Date: Mon, 14 Jul 2008 16:12:05 +0900
Message-ID: <1216019534-29977-2-git-send-email-tj@kernel.org>
References: <1216019534-29977-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:47850 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757032AbYGNHQE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 03:16:04 -0400
In-Reply-To: <1216019534-29977-1-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@f
Cc: Tejun Heo <tj@kernel.org>

This patch makes the following misc updates in preparation for
disk->part dereference fix and extended block devt support.

* implment part_to_disk()

* fix comment about gendisk->part indexing

* rename get_part() to disk_map_sector()

* don't use n which is always zero while printing disk information in
  diskstats_show()

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-core.c           |    7 ++++---
 block/blk-merge.c          |    4 ++--
 block/genhd.c              |    4 ++--
 drivers/block/aoe/aoecmd.c |    2 +-
 include/linux/genhd.h      |   13 ++++++++++---
 5 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1905aab..bc832aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -60,7 +60,7 @@ static void drive_stat_acct(struct request *rq, int new_io)
 	if (!blk_fs_request(rq) || !rq->rq_disk)
 		return;
 
-	part = get_part(rq->rq_disk, rq->sector);
+	part = disk_map_sector(rq->rq_disk, rq->sector);
 	if (!new_io)
 		__all_stat_inc(rq->rq_disk, part, merges[rw], rq->sector);
 	else {
@@ -1535,7 +1535,8 @@ static int __end_that_request_first(struct request *req, int error,
 	}
 
 	if (blk_fs_request(req) && req->rq_disk) {
-		struct hd_struct *part = get_part(req->rq_disk, req->sector);
+		struct hd_struct *part =
+			disk_map_sector(req->rq_disk, req->sector);
 		const int rw = rq_data_dir(req);
 
 		all_stat_add(req->rq_disk, part, sectors[rw],
@@ -1723,7 +1724,7 @@ static void end_that_request_last(struct request *req, int error)
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
-		struct hd_struct *part = get_part(disk, req->sector);
+		struct hd_struct *part = disk_map_sector(disk, req->sector);
 
 		__all_stat_inc(disk, part, ios[rw], req->sector);
 		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 651136a..e96d87d 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -467,8 +467,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	elv_merge_requests(q, req, next);
 
 	if (req->rq_disk) {
-		struct hd_struct *part
-			= get_part(req->rq_disk, req->sector);
+		struct hd_struct *part =
+			disk_map_sector(req->rq_disk, req->sector);
 		disk_round_stats(req->rq_disk);
 		req->rq_disk->in_flight--;
 		if (part) {
diff --git a/block/genhd.c b/block/genhd.c
index b646e7e..432c358 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -567,7 +567,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 {
 	struct gendisk *gp = v;
 	char buf[BDEVNAME_SIZE];
-	int n = 0;
+	int n;
 
 	/*
 	if (&gp->dev.kobj.entry == block_class.devices.next)
@@ -581,7 +581,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	disk_round_stats(gp);
 	preempt_enable();
 	seq_printf(s, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
-		gp->major, n + gp->first_minor, disk_name(gp, n, buf),
+		gp->major, gp->first_minor, disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
 		jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 41f818b..ba40473 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -757,7 +757,7 @@ diskstats(struct gendisk *disk, struct bio *bio, ulong duration, sector_t sector
 	const int rw = bio_data_dir(bio);
 	struct hd_struct *part;
 
-	part = get_part(disk, sector);
+	part = disk_map_sector(disk, sector);
 	all_stat_inc(disk, part, ios[rw], sector);
 	all_stat_add(disk, part, ticks[rw], duration, sector);
 	all_stat_add(disk, part, sectors[rw], n_sect, sector);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index e485cf0..68d50a2 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -117,7 +117,7 @@ struct gendisk {
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
 	char disk_name[32];		/* name of major driver */
-	struct hd_struct **part;	/* [indexed by minor] */
+	struct hd_struct **part;	/* [indexed by minor - 1] */
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	void *private_data;
@@ -143,14 +143,21 @@ struct gendisk {
 	struct work_struct async_notify;
 };
 
+static inline struct gendisk *part_to_disk(struct hd_struct *part)
+{
+	if (likely(part))
+		return dev_to_disk((part)->dev.parent);
+	return NULL;
+}
+
 /* 
  * Macros to operate on percpu disk statistics:
  *
  * The __ variants should only be called in critical sections. The full
  * variants disable/enable preemption.
  */
-static inline struct hd_struct *get_part(struct gendisk *gendiskp,
-					 sector_t sector)
+static inline struct hd_struct *disk_map_sector(struct gendisk *gendiskp,
+						sector_t sector)
 {
 	struct hd_struct *part;
 	int i;
-- 
1.5.4.5

