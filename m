From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Mainline kernel OLTP performance update
Date: Tue, 20 Jan 2009 14:27:03 +0100
Message-ID: <20090120132703.GJ30821@kernel.dk>
References: <BC02C49EEB98354DBA7F5DD76F2A9E800317003CB0@azsmsx501.amr.corp.intel.com> <CAC4B8726E86A142B27A9E9A2F2F12479D3E945F@rrsmsx505.amr.corp.intel.com> <20090114163557.11e097f2.akpm@linux-foundation.org> <20090115012147.GW29283@parisc-linux.org> <20090114180431.f4a96543.akpm@linux-foundation.org> <874p01fg3a.fsf@basil.nowhere.org> <20090115024740.GX29283@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([93.163.65.50]:7065 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754919AbZATN2e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2009 08:28:34 -0500
Content-Disposition: inline
In-Reply-To: <20090115024740.GX29283@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <andi@firstfloor.org>, Andrew Morton <akpm@linux-foundation.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, chinang.ma@intel.com, linux-kernel@vger.kernel.org, sharad.c.tripathi@intel.com, arjan@linux.intel.com, suresh.b.siddha@intel.com, harita.chilukuri@intel.com, douglas.w.styner@intel.com, peter.xihong.wang@intel.com, hubert.nueckel@intel.com, chris.mason@oracle.com, srostedt@redhat.com, linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>, Anirban Chakraborty <anirban.chakraborty@qlogic.com>

On Wed, Jan 14 2009, Matthew Wilcox wrote:
> On Thu, Jan 15, 2009 at 03:39:05AM +0100, Andi Kleen wrote:
> > Andrew Morton <akpm@linux-foundation.org> writes:
> > >>    some of that back, but not as much as taking them out (even when
> > >>    the sysctl'd variable is in a __read_mostly section).  We tried a
> > >>    patch from Jens to speed up the search for a new partition, but it
> > >>    had no effect.
> > >
> > > I find this surprising.
> > 
> > The test system has thousands of disks/LUNs which it writes to
> > all the time, in addition to a workload which is a real cache pig. 
> > So any increase in the per LUN overhead directly leads to a lot
> > more cache misses in the kernel because it increases the working set
> > there sigificantly.
> 
> This particular system has 450 spindles, but they're amalgamated into
> 30 logical volumes by the hardware or firmware.  Linux sees 30 LUNs.
> Each one, though, has fifteen partitions on it, so that brings us back
> up to 450 partitions.
> 
> This system, btw, is a scale model of the full system that would be used
> to get published results.  If I remember correctly, a 1% performance
> regression on this system is likely to translate to a 2% regression on
> the full-scale system.

Matthew, lets see if we can get this a little closer to disappearing. I
don't see lookup problems in the current kernel with the one-hit cache,
but perhaps it's either not getting enough hits in this bigger test case
or perhaps it's simply the rcu locking and preempt disables that build
up enough to cause a slowdown.

First things first, can you get a run of 2.6.29-rc2 with this patch?
It'll enable you to turn off per-partition stats in sysfs. I'd suggest
doing a run with a 2.6.29-rc2 booted with this patch, and then another
run with part_stats set to 0 for every exposed spindle. Then post those
profiles!

diff --git a/block/blk-core.c b/block/blk-core.c
index a824e49..6f693ae 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -600,7 +600,8 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
 	q->queue_flags		= (1 << QUEUE_FLAG_CLUSTER |
-				   1 << QUEUE_FLAG_STACKABLE);
+				   1 << QUEUE_FLAG_STACKABLE |
+				   1 << QUEUE_FLAG_PART_STAT);
 	q->queue_lock		= lock;
 
 	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index a29cb78..a6ec2e3 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -158,6 +158,29 @@ static ssize_t queue_rq_affinity_show(struct request_queue *q, char *page)
 	return queue_var_show(set != 0, page);
 }
 
+static ssize_t queue_part_stat_store(struct request_queue *q, const char *page,
+				     size_t count)
+{
+	unsigned long nm;
+	ssize_t ret = queue_var_store(&nm, page, count);
+
+	spin_lock_irq(q->queue_lock);
+	if (nm)
+		queue_flag_set(QUEUE_FLAG_PART_STAT, q);
+	else
+		queue_flag_clear(QUEUE_FLAG_PART_STAT, q);
+
+	spin_unlock_irq(q->queue_lock);
+	return ret;
+}
+
+static ssize_t queue_part_stat_show(struct request_queue *q, char *page)
+{
+	unsigned int set = test_bit(QUEUE_FLAG_PART_STAT, &q->queue_flags);
+
+	return queue_var_show(set != 0, page);
+}
+
 static ssize_t
 queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -222,6 +245,12 @@ static struct queue_sysfs_entry queue_rq_affinity_entry = {
 	.store = queue_rq_affinity_store,
 };
 
+static struct queue_sysfs_entry queue_part_stat_entry = {
+	.attr = {.name = "part_stats", .mode = S_IRUGO | S_IWUSR },
+	.show = queue_part_stat_show,
+	.store = queue_part_stat_store,
+};
+
 static struct attribute *default_attrs[] = {
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
@@ -231,6 +260,7 @@ static struct attribute *default_attrs[] = {
 	&queue_hw_sector_size_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
+	&queue_part_stat_entry.attr,
 	NULL,
 };
 
diff --git a/block/genhd.c b/block/genhd.c
index 397960c..09cbac2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -208,6 +208,9 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 	struct hd_struct *part;
 	int i;
 
+	if (!blk_queue_part_stat(disk->queue))
+		goto part0;
+
 	ptbl = rcu_dereference(disk->part_tbl);
 
 	part = rcu_dereference(ptbl->last_lookup);
@@ -222,6 +225,7 @@ struct hd_struct *disk_map_sector_rcu(struct gendisk *disk, sector_t sector)
 			return part;
 		}
 	}
+part0:
 	return &disk->part0;
 }
 EXPORT_SYMBOL_GPL(disk_map_sector_rcu);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 044467e..4d45842 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -449,6 +449,7 @@ struct request_queue
 #define QUEUE_FLAG_STACKABLE   13	/* supports request stacking */
 #define QUEUE_FLAG_NONROT      14	/* non-rotational device (SSD) */
 #define QUEUE_FLAG_VIRT        QUEUE_FLAG_NONROT /* paravirt device */
+#define QUEUE_FLAG_PART_STAT   15	/* per-partition stats enabled */
 
 static inline int queue_is_locked(struct request_queue *q)
 {
@@ -568,6 +569,8 @@ enum {
 #define blk_queue_flushing(q)	((q)->ordseq)
 #define blk_queue_stackable(q)	\
 	test_bit(QUEUE_FLAG_STACKABLE, &(q)->queue_flags)
+#define blk_queue_part_stat(q)	\
+	test_bit(QUEUE_FLAG_PART_STAT, &(q)->queue_flags)
 
 #define blk_fs_request(rq)	((rq)->cmd_type == REQ_TYPE_FS)
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)

-- 
Jens Axboe

