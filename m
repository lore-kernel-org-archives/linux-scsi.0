From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/09] block: misc updates
Date: Mon, 25 Aug 2008 19:47:17 +0900
Message-ID: <1219661245-16055-2-git-send-email-tj@kernel.org>
References: <1219661245-16055-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1219661245-16055-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: James.Bottomley@HansenPartnership.com, bzolnier@gmail.com, bharrosh@panasas.com, greg.freemyer@gmail.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, liml@rtr.ca, viro@ftp.linux.org.uk, linux-ide@vger.kernel.org, neilb@suse.de, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

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
index d785466..430b206 100644
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
@@ -1555,7 +1555,8 @@ static int __end_that_request_first(struct request *req, int error,
 	}
 
 	if (blk_fs_request(req) && req->rq_disk) {
-		struct hd_struct *part = get_part(req->rq_disk, req->sector);
+		struct hd_struct *part =
+			disk_map_sector(req->rq_disk, req->sector);
 		const int rw = rq_data_dir(req);
 
 		all_stat_add(req->rq_disk, part, sectors[rw],
@@ -1743,7 +1744,7 @@ static void end_that_request_last(struct request *req, int error)
 	if (disk && blk_fs_request(req) && req != &req->q->bar_rq) {
 		unsigned long duration = jiffies - req->start_time;
 		const int rw = rq_data_dir(req);
-		struct hd_struct *part = get_part(disk, req->sector);
+		struct hd_struct *part = disk_map_sector(disk, req->sector);
 
 		__all_stat_inc(disk, part, ios[rw], req->sector);
 		__all_stat_add(disk, part, ticks[rw], duration, req->sector);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index d81d914..9b17da6 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -387,8 +387,8 @@ static int attempt_merge(struct request_queue *q, struct request *req,
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
index e9d60fd..fe147bb 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -565,7 +565,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 {
 	struct gendisk *gp = v;
 	char buf[BDEVNAME_SIZE];
-	int n = 0;
+	int n;
 
 	/*
 	if (&gp->dev.kobj.entry == block_class.devices.next)
@@ -579,7 +579,7 @@ static int diskstats_show(struct seq_file *s, void *v)
 	disk_round_stats(gp);
 	preempt_enable();
 	seq_printf(s, "%4d %4d %s %lu %lu %llu %u %lu %lu %llu %u %u %u %u\n",
-		gp->major, n + gp->first_minor, disk_name(gp, n, buf),
+		gp->major, gp->first_minor, disk_name(gp, 0, buf),
 		disk_stat_read(gp, ios[0]), disk_stat_read(gp, merges[0]),
 		(unsigned long long)disk_stat_read(gp, sectors[0]),
 		jiffies_to_msecs(disk_stat_read(gp, ticks[0])),
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 2f17462..885d140 100644
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
index 118216f..f802961 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -125,7 +125,7 @@ struct gendisk {
 	int minors;                     /* maximum number of minors, =1 for
                                          * disks that can't be partitioned. */
 	char disk_name[32];		/* name of major driver */
-	struct hd_struct **part;	/* [indexed by minor] */
+	struct hd_struct **part;	/* [indexed by minor - 1] */
 	struct block_device_operations *fops;
 	struct request_queue *queue;
 	struct blk_scsi_cmd_filter cmd_filter;
@@ -155,14 +155,21 @@ struct gendisk {
 #endif
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

