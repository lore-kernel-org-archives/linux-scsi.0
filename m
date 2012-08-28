From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: Provide I/O alignment statistics
Date: Tue, 28 Aug 2012 14:13:34 -0400
Message-ID: <yq13936sx4h.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50269 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab2H1SNl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Aug 2012 14:13:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>


As an aid to users with 512e drives and disk arrays we now keep track of
whether submitted I/O requests are aligned to the block sizes contained
in the queue limits. We record whether each request is a properly
aligned multiple of the optimal, minumum, physical and logical block
sizes respectively. There are separate metrics for reads and writes and
the reported device alignment is taken into account. The statistics are
available in block/alignment_stat and block/<part>/alignment_stat. The
output format is documented in Documentation/ABI/testing/sysfs-block.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

Example run unpacking a kernel tarball using XFS on a 512e device.
Partition sdb1 is aligned, sdb2 is misaligned. Output has been
pretty-printed for readability:

RD    TOTAL      LBS      PBS      MIN      OPT   
sdb1:   564      136        0      428        0   
sdb2:   501      501        0        0        0   

WR    TOTAL      LBS      PBS      MIN      OPT
sdb1: 24440       42        0    24225      613
sdb2: 25248    25687        0        1        0

As expected, we were pretty good at issuing big I/O requests on the
aligned partition. The logical block size-aligned requests are from
mkfs.xfs and mount.


diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 0ad8442..747c95b 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -229,3 +229,31 @@ Description:
 		when a discarded area is read the discard_zeroes_data
 		parameter will be set to one. Otherwise it will be 0 and
 		the result of reading a discarded area is undefined.
+
+What:		/sys/block/<disk>/alignment_stat
+Date:		August 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		The block layer keeps track of whether I/O requests are
+		properly aligned multiples of the block sizes found in
+		the queue limits (optimal, minimum, physical and
+		logical). alignment_stat provides a dump of these
+		statistics for a disk. The file contains 10 fields:
+		 1 - reads: total number of completed requests
+		 2 - reads: properly aligned multiples of logical block size
+		 3 - reads: properly aligned multiples of physical block size
+		 4 - reads: properly aligned multiples of minimum I/O size
+		 5 - reads: properly aligned multiples of optimal I/O size
+		 6 - writes: total number of completed requests
+		 7 - writes: properly aligned multiples of logical block size
+		 8 - writes: properly aligned multiples of physical block size
+		 9 - writes: properly aligned multiples of minimum I/O size
+		10 - writes: properly aligned multiples of optimal I/O size
+
+What:		/sys/block/<disk>/<part>/alignment_stat
+Date:		August 2012
+Contact:	Martin K. Petersen <martin.petersen@oracle.com>
+Description:
+		The /sys/block/<disk>/<part>/stat file displays the I/O
+		alignment statistics for partition <part>. The format is
+		the same as /sys/block/<disk>/alignment_stat.
diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..fd890d0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1979,13 +1979,30 @@ EXPORT_SYMBOL_GPL(blk_rq_err_bytes);
 static void blk_account_io_completion(struct request *req, unsigned int bytes)
 {
 	if (blk_do_io_stat(req)) {
+		struct queue_limits *lim = &req->q->limits;
 		const int rw = rq_data_dir(req);
 		struct hd_struct *part;
-		int cpu;
+		int cpu, alignment;
+		sector_t offset;
 
 		cpu = part_stat_lock();
 		part = req->part;
+		alignment = queue_alignment_offset(req->q);
+		offset = blk_rq_pos(req) << 9;
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
+
+		if (lim->io_opt && offset % lim->io_opt == alignment &&
+		    bytes % lim->io_opt == 0)
+			part_stat_inc(cpu, part, opt_aligned_ios[rw]);
+		else if (offset % lim->io_min == alignment &&
+			 bytes % lim->io_min == 0)
+			part_stat_inc(cpu, part, min_aligned_ios[rw]);
+		else if (offset % lim->physical_block_size == alignment &&
+			   bytes % lim->physical_block_size == 0)
+			part_stat_inc(cpu, part, pbs_aligned_ios[rw]);
+		else
+			part_stat_inc(cpu, part, lbs_aligned_ios[rw]);
+
 		part_stat_unlock();
 	}
 }
diff --git a/block/genhd.c b/block/genhd.c
index d839723..7d5819a 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -988,6 +988,7 @@ static DEVICE_ATTR(discard_alignment, S_IRUGO, disk_discard_alignment_show,
 		   NULL);
 static DEVICE_ATTR(capability, S_IRUGO, disk_capability_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static DEVICE_ATTR(alignment_stat, S_IRUGO, part_alignment_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -1009,6 +1010,7 @@ static struct attribute *disk_attrs[] = {
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_capability.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_alignment_stat.attr,
 	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
diff --git a/block/partition-generic.c b/block/partition-generic.c
index f1d1451..35c54af 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -135,6 +135,25 @@ ssize_t part_stat_show(struct device *dev,
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
 
+ssize_t part_alignment_stat_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf,
+		       "%8lu %8lu %8lu %8lu %8lu %8lu %8lu %8lu %8lu %8lu\n",
+		       part_stat_read(p, ios[READ]),
+		       part_stat_read(p, lbs_aligned_ios[READ]),
+		       part_stat_read(p, pbs_aligned_ios[READ]),
+		       part_stat_read(p, min_aligned_ios[READ]),
+		       part_stat_read(p, opt_aligned_ios[READ]),
+		       part_stat_read(p, ios[WRITE]),
+		       part_stat_read(p, lbs_aligned_ios[WRITE]),
+		       part_stat_read(p, pbs_aligned_ios[WRITE]),
+		       part_stat_read(p, min_aligned_ios[WRITE]),
+		       part_stat_read(p, opt_aligned_ios[WRITE]));
+}
+
 ssize_t part_inflight_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -175,6 +194,7 @@ static DEVICE_ATTR(alignment_offset, S_IRUGO, part_alignment_offset_show, NULL);
 static DEVICE_ATTR(discard_alignment, S_IRUGO, part_discard_alignment_show,
 		   NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static DEVICE_ATTR(alignment_stat, S_IRUGO, part_alignment_stat_show, NULL);
 static DEVICE_ATTR(inflight, S_IRUGO, part_inflight_show, NULL);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
@@ -189,6 +209,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_alignment_offset.attr,
 	&dev_attr_discard_alignment.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_alignment_stat.attr,
 	&dev_attr_inflight.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 4f440b3..9f158be 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -85,6 +85,10 @@ struct disk_stats {
 	unsigned long ticks[2];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+	unsigned long lbs_aligned_ios[2];
+	unsigned long pbs_aligned_ios[2];
+	unsigned long min_aligned_ios[2];
+	unsigned long opt_aligned_ios[2];
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -620,6 +624,8 @@ extern ssize_t part_size_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
 extern ssize_t part_stat_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
+extern ssize_t part_alignment_stat_show(struct device *dev,
+			      struct device_attribute *attr, char *buf);
 extern ssize_t part_inflight_show(struct device *dev,
 			      struct device_attribute *attr, char *buf);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
