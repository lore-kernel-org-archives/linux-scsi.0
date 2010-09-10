From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] block/scsi: Provide a limit on the number of integrity segments
Date: Fri, 10 Sep 2010 01:18:45 -0400
Message-ID: <1284095925-12841-3-git-send-email-martin.petersen@oracle.com>
References: <1284095925-12841-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:18203 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab0IJFUr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Sep 2010 01:20:47 -0400
In-Reply-To: <1284095925-12841-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, James.Bottomley@hansenpartnership.com, christof.schmitt@de.ibm.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

Some controllers have a hardware limit on the number of protection
information scatter-gather list segments they can handle.

Introduce a max_integrity_segments limit in the block layer and provide
a new scsi_host_template setting that allows HBA drivers to provide a
value suitable for the hardware.

Add support for honoring the integrity segment limit when merging both
bios and requests.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-integrity.c     |   93 ++++++++++++++++++++++++++++++++++----------
 block/blk-merge.c         |   23 +++++++----
 block/blk-settings.c      |    3 +
 block/blk-sysfs.c         |   11 +++++
 block/blk.h               |    8 ----
 drivers/scsi/hosts.c      |    1 +
 drivers/scsi/scsi_lib.c   |   26 +++++++++----
 drivers/scsi/scsi_sysfs.c |    2 +
 include/linux/bio.h       |    4 ++
 include/linux/blkdev.h    |   33 ++++++++++++++--
 include/scsi/scsi.h       |    6 +++
 include/scsi/scsi_host.h  |    7 +++
 12 files changed, 167 insertions(+), 50 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index edce1ef..885cbb5 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -32,24 +32,37 @@ static struct kmem_cache *integrity_cachep;
 
 /**
  * blk_rq_count_integrity_sg - Count number of integrity scatterlist elements
- * @rq:		request with integrity metadata attached
+ * @q:		request queue
+ * @bio:	bio with integrity metadata attached
  *
  * Description: Returns the number of elements required in a
- * scatterlist corresponding to the integrity metadata in a request.
+ * scatterlist corresponding to the integrity metadata in a bio.
  */
-int blk_rq_count_integrity_sg(struct request *rq)
+int blk_rq_count_integrity_sg(struct request_queue *q, struct bio *bio)
 {
-	struct bio_vec *iv, *ivprv;
-	struct req_iterator iter;
-	unsigned int segments;
+	struct bio_vec *iv, *ivprv = NULL;
+	unsigned int segments = 0;
+	unsigned int seg_size = 0;
+	unsigned int i = 0;
 
-	ivprv = NULL;
-	segments = 0;
+	bio_for_each_integrity_vec(iv, bio, i) {
 
-	rq_for_each_integrity_segment(iv, rq, iter) {
+		if (ivprv) {
+			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+				goto new_segment;
+
+			if (!BIOVEC_SEG_BOUNDARY(q, ivprv, iv))
+				goto new_segment;
+
+			if (seg_size + iv->bv_len > queue_max_segment_size(q))
+				goto new_segment;
 
-		if (!ivprv || !BIOVEC_PHYS_MERGEABLE(ivprv, iv))
+			seg_size += iv->bv_len;
+		} else {
+new_segment:
 			segments++;
+			seg_size = iv->bv_len;
+		}
 
 		ivprv = iv;
 	}
@@ -60,30 +73,34 @@ EXPORT_SYMBOL(blk_rq_count_integrity_sg);
 
 /**
  * blk_rq_map_integrity_sg - Map integrity metadata into a scatterlist
- * @rq:		request with integrity metadata attached
+ * @q:		request queue
+ * @bio:	bio with integrity metadata attached
  * @sglist:	target scatterlist
  *
  * Description: Map the integrity vectors in request into a
  * scatterlist.  The scatterlist must be big enough to hold all
  * elements.  I.e. sized using blk_rq_count_integrity_sg().
  */
-int blk_rq_map_integrity_sg(struct request *rq, struct scatterlist *sglist)
+int blk_rq_map_integrity_sg(struct request_queue *q, struct bio *bio,
+			    struct scatterlist *sglist)
 {
-	struct bio_vec *iv, *ivprv;
-	struct req_iterator iter;
-	struct scatterlist *sg;
-	unsigned int segments;
+	struct bio_vec *iv, *ivprv = NULL;
+	struct scatterlist *sg = NULL;
+	unsigned int segments = 0;
+	unsigned int i = 0;
 
-	ivprv = NULL;
-	sg = NULL;
-	segments = 0;
-
-	rq_for_each_integrity_segment(iv, rq, iter) {
+	bio_for_each_integrity_vec(iv, bio, i) {
 
 		if (ivprv) {
 			if (!BIOVEC_PHYS_MERGEABLE(ivprv, iv))
 				goto new_segment;
 
+			if (!BIOVEC_SEG_BOUNDARY(q, ivprv, iv))
+				goto new_segment;
+
+			if (sg->length + iv->bv_len > queue_max_segment_size(q))
+				goto new_segment;
+
 			sg->length += iv->bv_len;
 		} else {
 new_segment:
@@ -162,6 +179,40 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 }
 EXPORT_SYMBOL(blk_integrity_compare);
 
+int blk_integrity_merge_rq(struct request_queue *q, struct request *req,
+			   struct request *next)
+{
+	if (blk_integrity_rq(req) != blk_integrity_rq(next))
+		return -1;
+
+	if (req->nr_integrity_segments + next->nr_integrity_segments >
+	    q->limits.max_integrity_segments)
+		return -1;
+
+	return 0;
+}
+EXPORT_SYMBOL(blk_integrity_merge_rq);
+
+int blk_integrity_merge_bio(struct request_queue *q, struct request *req,
+			    struct bio *bio)
+{
+	int nr_integrity_segs;
+	struct bio *next = bio->bi_next;
+
+	bio->bi_next = NULL;
+	nr_integrity_segs = blk_rq_count_integrity_sg(q, bio);
+	bio->bi_next = next;
+
+	if (req->nr_integrity_segments + nr_integrity_segs >
+	    q->limits.max_integrity_segments)
+		return -1;
+
+	req->nr_integrity_segments += nr_integrity_segs;
+
+	return 0;
+}
+EXPORT_SYMBOL(blk_integrity_merge_bio);
+
 struct integrity_sysfs_entry {
 	struct attribute attr;
 	ssize_t (*show)(struct blk_integrity *, char *);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3b0cd42..6a72546 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -205,12 +205,11 @@ static inline int ll_new_hw_segment(struct request_queue *q,
 {
 	int nr_phys_segs = bio_phys_segments(q, bio);
 
-	if (req->nr_phys_segments + nr_phys_segs > queue_max_segments(q)) {
-		req->cmd_flags |= REQ_NOMERGE;
-		if (req == q->last_merge)
-			q->last_merge = NULL;
-		return 0;
-	}
+	if (req->nr_phys_segments + nr_phys_segs > queue_max_segments(q))
+		goto no_merge;
+
+	if (bio_integrity(bio) && blk_integrity_merge_bio(q, req, bio))
+		goto no_merge;
 
 	/*
 	 * This will form the start of a new hw segment.  Bump both
@@ -218,6 +217,12 @@ static inline int ll_new_hw_segment(struct request_queue *q,
 	 */
 	req->nr_phys_segments += nr_phys_segs;
 	return 1;
+
+no_merge:
+	req->cmd_flags |= REQ_NOMERGE;
+	if (req == q->last_merge)
+		q->last_merge = NULL;
+	return 0;
 }
 
 int ll_back_merge_fn(struct request_queue *q, struct request *req,
@@ -301,6 +306,9 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	if (total_phys_segments > queue_max_segments(q))
 		return 0;
 
+	if (blk_integrity_rq(req) && blk_integrity_merge_rq(q, req, next))
+		return 0;
+
 	/* Merge is OK... */
 	req->nr_phys_segments = total_phys_segments;
 	return 1;
@@ -372,9 +380,6 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	    || next->special)
 		return 0;
 
-	if (blk_integrity_rq(req) != blk_integrity_rq(next))
-		return 0;
-
 	/*
 	 * If we are allowed to merge, then append bio list
 	 * from next to rq and release next. merge_requests_fn
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8d592b5..f8f2ddf 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -111,6 +111,7 @@ EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 void blk_set_default_limits(struct queue_limits *lim)
 {
 	lim->max_segments = BLK_MAX_SEGMENTS;
+	lim->max_integrity_segments = 0;
 	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
 	lim->max_segment_size = BLK_MAX_SEGMENT_SIZE;
 	lim->max_sectors = BLK_DEF_MAX_SECTORS;
@@ -509,6 +510,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 					    b->seg_boundary_mask);
 
 	t->max_segments = min_not_zero(t->max_segments, b->max_segments);
+	t->max_integrity_segments = min_not_zero(t->max_integrity_segments,
+						 b->max_integrity_segments);
 
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 001ab18..b014f77 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -112,6 +112,11 @@ static ssize_t queue_max_segments_show(struct request_queue *q, char *page)
 	return queue_var_show(queue_max_segments(q), (page));
 }
 
+static ssize_t queue_max_integrity_segments_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.max_integrity_segments, (page));
+}
+
 static ssize_t queue_max_segment_size_show(struct request_queue *q, char *page)
 {
 	if (test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags))
@@ -288,6 +293,11 @@ static struct queue_sysfs_entry queue_max_segments_entry = {
 	.show = queue_max_segments_show,
 };
 
+static struct queue_sysfs_entry queue_max_integrity_segments_entry = {
+	.attr = {.name = "max_integrity_segments", .mode = S_IRUGO },
+	.show = queue_max_integrity_segments_show,
+};
+
 static struct queue_sysfs_entry queue_max_segment_size_entry = {
 	.attr = {.name = "max_segment_size", .mode = S_IRUGO },
 	.show = queue_max_segment_size_show,
@@ -375,6 +385,7 @@ static struct attribute *default_attrs[] = {
 	&queue_max_hw_sectors_entry.attr,
 	&queue_max_sectors_entry.attr,
 	&queue_max_segments_entry.attr,
+	&queue_max_integrity_segments_entry.attr,
 	&queue_max_segment_size_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
diff --git a/block/blk.h b/block/blk.h
index 6e7dc87..6738831 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -132,14 +132,6 @@ static inline int queue_congestion_off_threshold(struct request_queue *q)
 	return q->nr_congestion_off;
 }
 
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-
-#define rq_for_each_integrity_segment(bvl, _rq, _iter)		\
-	__rq_for_each_bio(_iter.bio, _rq)			\
-		bip_for_each_vec(bvl, _iter.bio->bi_integrity, _iter.i)
-
-#endif /* BLK_DEV_INTEGRITY */
-
 static inline int blk_cpu_to_group(int cpu)
 {
 #ifdef CONFIG_SCHED_MC
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 6660fa9..e925492 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -371,6 +371,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
+	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
 	shost->cmd_per_lun = sht->cmd_per_lun;
 	shost->unchecked_isa_dma = sht->unchecked_isa_dma;
 	shost->use_clustering = sht->use_clustering;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b8de389..124d903 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -968,11 +968,13 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
-	int error = scsi_init_sgtable(cmd->request, &cmd->sdb, gfp_mask);
+	struct request *rq = cmd->request;
+
+	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
 	if (error)
 		goto err_exit;
 
-	if (blk_bidi_rq(cmd->request)) {
+	if (blk_bidi_rq(rq)) {
 		struct scsi_data_buffer *bidi_sdb = kmem_cache_zalloc(
 			scsi_sdb_cache, GFP_ATOMIC);
 		if (!bidi_sdb) {
@@ -980,28 +982,28 @@ int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 			goto err_exit;
 		}
 
-		cmd->request->next_rq->special = bidi_sdb;
-		error = scsi_init_sgtable(cmd->request->next_rq, bidi_sdb,
-								    GFP_ATOMIC);
+		rq->next_rq->special = bidi_sdb;
+		error = scsi_init_sgtable(rq->next_rq, bidi_sdb, GFP_ATOMIC);
 		if (error)
 			goto err_exit;
 	}
 
-	if (blk_integrity_rq(cmd->request)) {
+	if (blk_integrity_rq(rq)) {
 		struct scsi_data_buffer *prot_sdb = cmd->prot_sdb;
 		int ivecs, count;
 
 		BUG_ON(prot_sdb == NULL);
-		ivecs = blk_rq_count_integrity_sg(cmd->request);
+		ivecs = blk_rq_count_integrity_sg(rq->q, rq->bio);
 
 		if (scsi_alloc_sgtable(prot_sdb, ivecs, gfp_mask)) {
 			error = BLKPREP_DEFER;
 			goto err_exit;
 		}
 
-		count = blk_rq_map_integrity_sg(cmd->request,
+		count = blk_rq_map_integrity_sg(rq->q, rq->bio,
 						prot_sdb->table.sgl);
 		BUG_ON(unlikely(count > ivecs));
+		BUG_ON(unlikely(count > queue_max_integrity_segments(rq->q)));
 
 		cmd->prot_sdb = prot_sdb;
 		cmd->prot_sdb->table.nents = count;
@@ -1631,6 +1633,14 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_max_segments(q, min_t(unsigned short, shost->sg_tablesize,
 					SCSI_MAX_SG_CHAIN_SEGMENTS));
 
+	if (scsi_host_prot_dma(shost)) {
+		shost->sg_prot_tablesize =
+			min_not_zero(shost->sg_prot_tablesize,
+				     (unsigned short)SCSI_MAX_PROT_SG_SEGMENTS);
+		BUG_ON(shost->sg_prot_tablesize < shost->sg_tablesize);
+		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
+	}
+
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index c23ab97..30dae37 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -250,6 +250,7 @@ shost_rd_attr(host_busy, "%hu\n");
 shost_rd_attr(cmd_per_lun, "%hd\n");
 shost_rd_attr(can_queue, "%hd\n");
 shost_rd_attr(sg_tablesize, "%hu\n");
+shost_rd_attr(sg_prot_tablesize, "%hu\n");
 shost_rd_attr(unchecked_isa_dma, "%d\n");
 shost_rd_attr(prot_capabilities, "%u\n");
 shost_rd_attr(prot_guard_type, "%hd\n");
@@ -261,6 +262,7 @@ static struct attribute *scsi_sysfs_shost_attrs[] = {
 	&dev_attr_cmd_per_lun.attr,
 	&dev_attr_can_queue.attr,
 	&dev_attr_sg_tablesize.attr,
+	&dev_attr_sg_prot_tablesize.attr,
 	&dev_attr_unchecked_isa_dma.attr,
 	&dev_attr_proc_name.attr,
 	&dev_attr_scan.attr,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5274103..2c3fd74 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -496,6 +496,10 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 #define bip_for_each_vec(bvl, bip, i)					\
 	__bip_for_each_vec(bvl, bip, i, (bip)->bip_idx)
 
+#define bio_for_each_integrity_vec(_bvl, _bio, _iter)			\
+	for_each_bio(_bio)						\
+		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
+
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
 extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 89c855c..13d6e9c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -124,6 +124,9 @@ struct request {
 	 * physical address coalescing is performed.
 	 */
 	unsigned short nr_phys_segments;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	unsigned short nr_integrity_segments;
+#endif
 
 	unsigned short ioprio;
 
@@ -243,6 +246,7 @@ struct queue_limits {
 
 	unsigned short		logical_block_size;
 	unsigned short		max_segments;
+	unsigned short		max_integrity_segments;
 
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
@@ -1208,8 +1212,13 @@ struct blk_integrity {
 extern int blk_integrity_register(struct gendisk *, struct blk_integrity *);
 extern void blk_integrity_unregister(struct gendisk *);
 extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
-extern int blk_rq_map_integrity_sg(struct request *, struct scatterlist *);
-extern int blk_rq_count_integrity_sg(struct request *);
+extern int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
+				   struct scatterlist *);
+extern int blk_rq_count_integrity_sg(struct request_queue *, struct bio *);
+extern int blk_integrity_merge_rq(struct request_queue *, struct request *,
+				  struct request *);
+extern int blk_integrity_merge_bio(struct request_queue *, struct request *,
+				   struct bio *);
 
 static inline
 struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
@@ -1230,16 +1239,32 @@ static inline int blk_integrity_rq(struct request *rq)
 	return bio_integrity(rq->bio);
 }
 
+static inline void blk_queue_max_integrity_segments(struct request_queue *q,
+						    unsigned int segs)
+{
+	q->limits.max_integrity_segments = segs;
+}
+
+static inline unsigned short
+queue_max_integrity_segments(struct request_queue *q)
+{
+	return q->limits.max_integrity_segments;
+}
+
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
 #define blk_integrity_rq(rq)			(0)
-#define blk_rq_count_integrity_sg(a)		(0)
-#define blk_rq_map_integrity_sg(a, b)		(0)
+#define blk_rq_count_integrity_sg(a, b)		(0)
+#define blk_rq_map_integrity_sg(a, b, c)	(0)
 #define bdev_get_integrity(a)			(0)
 #define blk_get_integrity(a)			(0)
 #define blk_integrity_compare(a, b)		(0)
 #define blk_integrity_register(a, b)		(0)
 #define blk_integrity_unregister(a)		do { } while (0);
+#define blk_queue_max_integrity_segments(a, b)	do { } while (0);
+#define queue_max_integrity_segments(a)		(0)
+#define blk_integrity_merge_rq(a, b, c)		(0)
+#define blk_integrity_merge_bio(a, b, c)	(0)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 9ae5c61..227a0d6 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -32,6 +32,12 @@ struct scsi_cmnd;
 #endif
 
 /*
+ * DIX-capable adapters effectively support infinite chaining for the
+ * protection information scatterlist
+ */
+#define SCSI_MAX_PROT_SG_SEGMENTS	0xFFFF
+
+/*
  * Special value for scanning to specify scanning or rescanning of all
  * possible channels, (target) ids, or luns on a given shost.
  */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index b7bdecb..d0a6a84 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -388,6 +388,7 @@ struct scsi_host_template {
 	 * of scatter-gather.
 	 */
 	unsigned short sg_tablesize;
+	unsigned short sg_prot_tablesize;
 
 	/*
 	 * Set this if the host adapter has limitations beside segment count.
@@ -599,6 +600,7 @@ struct Scsi_Host {
 	int can_queue;
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
+	short unsigned int sg_prot_tablesize;
 	short unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
@@ -823,6 +825,11 @@ static inline unsigned int scsi_host_get_prot(struct Scsi_Host *shost)
 	return shost->prot_capabilities;
 }
 
+static inline int scsi_host_prot_dma(struct Scsi_Host *shost)
+{
+	return shost->prot_capabilities >= SHOST_DIX_TYPE0_PROTECTION;
+}
+
 static inline unsigned int scsi_host_dif_capable(struct Scsi_Host *shost, unsigned int target_type)
 {
 	static unsigned char cap[] = { 0,
-- 
1.7.2.2

