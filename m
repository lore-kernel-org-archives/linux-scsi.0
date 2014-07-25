From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 02/14] block: Replace bi_integrity with bi_special
Date: Fri, 25 Jul 2014 16:34:17 -0400
Message-ID: <1406320469-29352-3-git-send-email-martin.petersen@oracle.com>
References: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38273 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbaGYUdd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Jul 2014 16:33:33 -0400
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id s6PKXVLe028108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:32 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXUn9014200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:31 GMT
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id s6PKXUfx003722
	for <linux-scsi@vger.kernel.org>; Fri, 25 Jul 2014 20:33:30 GMT
In-Reply-To: <1406320469-29352-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

For commands like REQ_COPY we need a way to pass extra information along
with each bio. Like integrity metadata this information must be
available at the bottom of the stack so bi_private does not suffice.

Rename the existing bi_integrity field to bi_special and make it a union
so we can have different bio extensions for each class of command.

We previously used bi_integrity != NULL as a way to identify whether a
bio had integrity metadata or not. Introduce a REQ_INTEGRITY to be the
indicator now that bi_special can contain different things.

In addition, bio_integrity(bio) will now return a pointer to the
integrity payload (when applicable).

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 Documentation/block/data-integrity.txt | 10 +++++-----
 block/bio-integrity.c                  | 19 ++++++++++---------
 drivers/scsi/sd_dif.c                  |  8 ++++----
 include/linux/bio.h                    | 11 +++++++++--
 include/linux/blk_types.h              |  8 ++++++--
 include/linux/blkdev.h                 |  7 ++-----
 6 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/Documentation/block/data-integrity.txt b/Documentation/block/data-integrity.txt
index b4eacf48053c..4d4de8b09530 100644
--- a/Documentation/block/data-integrity.txt
+++ b/Documentation/block/data-integrity.txt
@@ -129,11 +129,11 @@ interface for this is being worked on.
 4.1 BIO
 
 The data integrity patches add a new field to struct bio when
-CONFIG_BLK_DEV_INTEGRITY is enabled.  bio->bi_integrity is a pointer
-to a struct bip which contains the bio integrity payload.  Essentially
-a bip is a trimmed down struct bio which holds a bio_vec containing
-the integrity metadata and the required housekeeping information (bvec
-pool, vector count, etc.)
+CONFIG_BLK_DEV_INTEGRITY is enabled.  bio_integrity(bio) returns a
+pointer to a struct bip which contains the bio integrity payload.
+Essentially a bip is a trimmed down struct bio which holds a bio_vec
+containing the integrity metadata and the required housekeeping
+information (bvec pool, vector count, etc.)
 
 A kernel subsystem can enable data integrity protection on a bio by
 calling bio_integrity_alloc(bio).  This will allocate and attach the
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 6818c251e937..78d8312a6528 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -77,6 +77,7 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 	bip->bip_slab = idx;
 	bip->bip_bio = bio;
 	bio->bi_integrity = bip;
+	bio->bi_rw |= REQ_INTEGRITY;
 
 	return bip;
 err:
@@ -94,7 +95,7 @@ EXPORT_SYMBOL(bio_integrity_alloc);
  */
 void bio_integrity_free(struct bio *bio)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_set *bs = bio->bi_pool;
 
 	if (bip->bip_owns_buf)
@@ -134,7 +135,7 @@ static inline unsigned int bip_integrity_vecs(struct bio_integrity_payload *bip)
 int bio_integrity_add_page(struct bio *bio, struct page *page,
 			   unsigned int len, unsigned int offset)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_vec *iv;
 
 	if (bip->bip_vcnt >= bip_integrity_vecs(bip)) {
@@ -235,7 +236,7 @@ EXPORT_SYMBOL(bio_integrity_tag_size);
 static int bio_integrity_tag(struct bio *bio, void *tag_buf, unsigned int len,
 			     int set)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	unsigned int nr_sectors;
 
@@ -310,12 +311,12 @@ static int bio_integrity_generate_verify(struct bio *bio, int operate)
 	struct bio_vec *bv;
 	sector_t sector;
 	unsigned int sectors, ret = 0, i;
-	void *prot_buf = bio->bi_integrity->bip_buf;
+	void *prot_buf = bio_integrity(bio)->bip_buf;
 
 	if (operate)
 		sector = bio->bi_iter.bi_sector;
 	else
-		sector = bio->bi_integrity->bip_iter.bi_sector;
+		sector = bio_integrity(bio)->bip_iter.bi_sector;
 
 	bix.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	bix.sector_size = bi->sector_size;
@@ -511,7 +512,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  */
 void bio_integrity_endio(struct bio *bio, int error)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 
 	BUG_ON(bip->bip_bio != bio);
 
@@ -542,7 +543,7 @@ EXPORT_SYMBOL(bio_integrity_endio);
  */
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 	unsigned bytes = bio_integrity_bytes(bi, bytes_done >> 9);
 
@@ -564,7 +565,7 @@ EXPORT_SYMBOL(bio_integrity_advance);
 void bio_integrity_trim(struct bio *bio, unsigned int offset,
 			unsigned int sectors)
 {
-	struct bio_integrity_payload *bip = bio->bi_integrity;
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 
 	bio_integrity_advance(bio, offset << 9);
@@ -583,7 +584,7 @@ EXPORT_SYMBOL(bio_integrity_trim);
 int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 			gfp_t gfp_mask)
 {
-	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
+	struct bio_integrity_payload *bip_src = bio_integrity(bio_src);
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index a7a691d0af7d..29f0477a8708 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -383,9 +383,9 @@ void sd_dif_prepare(struct request *rq, sector_t hw_sector,
 		if (bio_flagged(bio, BIO_MAPPED_INTEGRITY))
 			break;
 
-		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
+		virt = bio_integrity(bio)->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+		bip_for_each_vec(iv, bio_integrity(bio), iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
@@ -434,9 +434,9 @@ void sd_dif_complete(struct scsi_cmnd *scmd, unsigned int good_bytes)
 		struct bio_vec iv;
 		struct bvec_iter iter;
 
-		virt = bio->bi_integrity->bip_iter.bi_sector & 0xffffffff;
+		virt = bio_integrity(bio)->bip_iter.bi_sector & 0xffffffff;
 
-		bip_for_each_vec(iv, bio->bi_integrity, iter) {
+		bip_for_each_vec(iv, bio_integrity(bio), iter) {
 			sdt = kmap_atomic(iv.bv_page)
 				+ iv.bv_offset;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index f11dd9efd3d9..1c608a0cbd8e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -293,6 +293,15 @@ static inline unsigned bio_segments(struct bio *bio)
 #define bio_get(bio)	atomic_inc(&(bio)->bi_cnt)
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
+
+static inline struct bio_integrity_payload *bio_integrity(struct bio *bio)
+{
+	if (bio->bi_rw & REQ_INTEGRITY)
+		return bio->bi_integrity;
+
+	return NULL;
+}
+
 /*
  * bio integrity payload
  */
@@ -660,8 +669,6 @@ struct biovec_slab {
 	for_each_bio(_bio)						\
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
-#define bio_integrity(bio) (bio->bi_integrity != NULL)
-
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
 extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 66c2167f04a9..0b7084f7c136 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -78,9 +78,11 @@ struct bio {
 	struct io_context	*bi_ioc;
 	struct cgroup_subsys_state *bi_css;
 #endif
+	union {
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-	struct bio_integrity_payload *bi_integrity;  /* data integrity */
+		struct bio_integrity_payload *bi_integrity; /* data integrity */
 #endif
+	};
 
 	unsigned short		bi_vcnt;	/* how many bio_vec's */
 
@@ -162,6 +164,7 @@ enum rq_flag_bits {
 	__REQ_WRITE_SAME,	/* write same block many times */
 
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
+	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
 	__REQ_FUA,		/* forced unit access */
 	__REQ_FLUSH,		/* request for cache flush */
 
@@ -204,13 +207,14 @@ enum rq_flag_bits {
 #define REQ_DISCARD		(1ULL << __REQ_DISCARD)
 #define REQ_WRITE_SAME		(1ULL << __REQ_WRITE_SAME)
 #define REQ_NOIDLE		(1ULL << __REQ_NOIDLE)
+#define REQ_INTEGRITY		(1ULL << __REQ_INTEGRITY)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_WRITE | REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | \
 	 REQ_DISCARD | REQ_WRITE_SAME | REQ_NOIDLE | REQ_FLUSH | REQ_FUA | \
-	 REQ_SECURE)
+	 REQ_SECURE | REQ_INTEGRITY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 #define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8699bcf5f099..c462b5b0d67f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1518,12 +1518,9 @@ static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 	return disk->integrity;
 }
 
-static inline int blk_integrity_rq(struct request *rq)
+static inline bool blk_integrity_rq(struct request *rq)
 {
-	if (rq->bio == NULL)
-		return 0;
-
-	return bio_integrity(rq->bio);
+	return rq->cmd_flags & REQ_INTEGRITY;
 }
 
 static inline void blk_queue_max_integrity_segments(struct request_queue *q,
-- 
1.9.3

