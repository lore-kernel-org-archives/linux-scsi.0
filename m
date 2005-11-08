From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2/10] seperate max sectors and max hw sectors
Date: Tue, 08 Nov 2005 12:33:14 -0600
Message-ID: <1131474795.5114.4.camel@max>
References: <1131444395.23111.62.camel@max> <20051108174723.GK3699@suse.de>
	 <4370E5ED.60901@cs.wisc.edu>  <20051108175707.GL3699@suse.de>
	 <1131473878.3920.4.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36001 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S965246AbVKHSdT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 13:33:19 -0500
In-Reply-To: <1131473878.3920.4.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

On Tue, 2005-11-08 at 12:17 -0600, Mike Christie wrote:
> On Tue, 2005-11-08 at 18:57 +0100, Jens Axboe wrote:
> > On Tue, Nov 08 2005, Mike Christie wrote:
> > > Jens Axboe wrote:
> > > >On Tue, Nov 08 2005, Mike Christie wrote:
> > > >
> > > >>Seperate max_hw_sectors and max_sectors.
> > > >>
> > > >>LLDs call blk_queue_max_hw_sectors() to set max_hw_sectors.
> > > >>blk_queue_max_sectors will also set max_sectors to a safe
> > > >>default value.
> > > >>
> > > >>blk_init_queue still calls blk_queue_max_sectors so if there
> > > >>are any LLDs that do not call blk_queue_max_hw_sectors() and
> > > >>were expecting both the max_sectors and max_hw_sectors to be
> > > >>255 they do not have to do anything.
> > > >>
> > > >>I was not able to test every driver I touched, but I think the
> > > >>only place I may have messed up is MD so some testing is needed.
> > > >
> > > >
> > > >->max_sectors will become less of a driver property and more of a
> > > >block/vm propery, so I think the best way to do this is just to have
> > > >blk_queue_max_sectors() set ->max_hw_sectors directly and lower
> > > >->max_sectors appropriately if it is lower. That also comes with the
> > > >bonus of not having to modify drivers.
> > > >
> > > 
> > > Ugggh. I did this in reverse to make the naming nicer. So I added a 
> > > blk_queue_max_hw_sectors() which sets ->max_sectors to some Block layer 
> > > default and ->max_hw_sectors to the hw limit (for SCSI this is the scsi 
> > > host template ->max_sectors). Is this ok? It is more clear for driver 
> > > writers that they are setting max_hw_sectors when calling 
> > > blk_queue_max_hw_sectors(). I also converted all the 
> > > blk_queue_max_sectors() to blk_queue_max_hw_sectors().
> > 
> > Driver writers need not know. They call blk_queue_max_sectors() to set
> > the maximum value of a request they can handle, they could not care less
> > what internal field in the queue is actually used for that. From their
> > perspective, blk_queue_max_sectors() defines their hard limit. We may
> > (and will) adjust the soft limit behind their back - which is ok, as
> > long as we honor the value they defined by calling
> > blk_queue_max_sectors().
> > 
> 
> all right, is this patch ok?  I changed MAX_SECTORS to SAFE_MAX_SECTORS
> incase someone was relying on it being 255, and it adds the block layer
> default to be BLK_DEF_MAX_SECTORS (1024). It also makes block layer
> SG_IO use max_hw_sectors instead of max_sectors. But what is
> sg_set_reserved_size used for?
> 
> This was made against the first patch in the patchset, but can apply
> with offsets without it.

Messed up combining the two patches. This one actually works.

diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
index f9b83d2..88caa44 100644
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -241,7 +241,7 @@ void blk_queue_make_request(request_queu
 	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
-	blk_queue_max_sectors(q, MAX_SECTORS);
+	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
@@ -557,7 +557,12 @@ void blk_queue_max_sectors(request_queue
 		printk("%s: set to minimum %d\n", __FUNCTION__, max_sectors);
 	}
 
-	q->max_sectors = q->max_hw_sectors = max_sectors;
+	if (BLK_DEF_MAX_SECTORS > max_sectors)
+		q->max_hw_sectors = q->max_sectors = max_sectors;
+ 	else {
+		q->max_sectors = BLK_DEF_MAX_SECTORS;
+		q->max_hw_sectors = max_sectors;
+	}
 }
 
 EXPORT_SYMBOL(blk_queue_max_sectors);
@@ -659,8 +664,8 @@ EXPORT_SYMBOL(blk_queue_hardsect_size);
 void blk_queue_stack_limits(request_queue_t *t, request_queue_t *b)
 {
 	/* zero is "infinity" */
-	t->max_sectors = t->max_hw_sectors =
-		min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_sectors = min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_hw_sectors = min_not_zero(t->max_hw_sectors,b->max_hw_sectors);
 
 	t->max_phys_segments = min(t->max_phys_segments,b->max_phys_segments);
 	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
@@ -2147,7 +2152,7 @@ int blk_rq_map_user(request_queue_t *q, 
 	struct bio *bio;
 	int reading;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !ubuf)
 		return -EINVAL;
@@ -2262,7 +2267,7 @@ int blk_rq_map_kern(request_queue_t *q, 
 {
 	struct bio *bio;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
 		return -EINVAL;
diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
index 382dea7..4e390df 100644
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -233,7 +233,7 @@ static int sg_io(struct file *file, requ
 	if (verify_command(file, cmd))
 		return -EPERM;
 
-	if (hdr->dxfer_len > (q->max_sectors << 9))
+	if (hdr->dxfer_len > (q->max_hw_sectors << 9))
 		return -EIO;
 
 	if (hdr->dxfer_len)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a6d3baa..a6f2dc6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -638,7 +638,7 @@ int dm_split_args(int *argc, char ***arg
 static void check_for_valid_limits(struct io_restrictions *rs)
 {
 	if (!rs->max_sectors)
-		rs->max_sectors = MAX_SECTORS;
+		rs->max_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
diff --git a/fs/bio.c b/fs/bio.c
index 460554b..d7ed8af 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -313,7 +313,8 @@ int bio_get_nr_vecs(struct block_device 
 }
 
 static int __bio_add_page(request_queue_t *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset)
+			  *page, unsigned int len, unsigned int offset,
+			  unsigned short max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -327,7 +328,7 @@ static int __bio_add_page(request_queue_
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	if (((bio->bi_size + len) >> 9) > q->max_sectors)
+	if (((bio->bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	/*
@@ -401,8 +402,8 @@ static int __bio_add_page(request_queue_
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
 {
-	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
-			      len, offset);
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
 struct bio_map_data {
@@ -514,7 +515,8 @@ struct bio *bio_copy_user(request_queue_
 			break;
 		}
 
-		if (__bio_add_page(q, bio, page, bytes, 0) < bytes) {
+		if (__bio_add_page(q, bio, page, bytes, 0, q->max_hw_sectors) <
+				   bytes) {
 			ret = -EINVAL;
 			break;
 		}
@@ -628,7 +630,8 @@ static struct bio *__bio_map_user_iov(re
 			/*
 			 * sorry...
 			 */
-			if (__bio_add_page(q, bio, pages[j], bytes, offset) < bytes)
+			if (__bio_add_page(q, bio, pages[j], bytes, offset,
+					   q->max_hw_sectors) < bytes)
 				break;
 
 			len -= bytes;
@@ -802,7 +805,7 @@ static struct bio *__bio_map_kern(reques
 			bytes = len;
 
 		if (__bio_add_page(q, bio, virt_to_page(data), bytes,
-				   offset) < bytes)
+				   offset, q->max_hw_sectors) < bytes)
 			break;
 
 		data += bytes;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 46e927b..37ac77b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -699,7 +699,8 @@ extern int blkdev_issue_flush(struct blo
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
-#define MAX_SECTORS 255
+#define SAFE_MAX_SECTORS 255
+#define BLK_DEF_MAX_SECTORS 1024
 
 #define MAX_SEGMENT_SIZE	65536
 


