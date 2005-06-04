From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC 2/4] convert dm-emc to usr blk_rq_map_kern
Date: Fri, 03 Jun 2005 18:30:20 -0700
Message-ID: <1117848620.23706.5.camel@mina>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, axboe@suse.de
List-Id: linux-scsi@vger.kernel.org

convert blk_rq_map_kern so it does not have to allocate a page
and use GFP_KERNEL.

TODO: fixup mempool problems.

This patch was made against 2.6.12-rc5 and works with scsi-misc.
Sorry I did not do dm unstable. The patch is only compile tested.




--- linux-2.6.12-rc5.orig/drivers/md/dm-emc.c	2005-06-03 03:23:46.000000000 -0700
+++ linux-2.6.12-rc5/drivers/md/dm-emc.c	2005-06-03 15:38:09.000000000 -0700
@@ -28,95 +28,80 @@ struct emc_handler {
 #define TRESPASS_PAGE 0x22
 #define EMC_FAILOVER_TIMEOUT (60 * HZ)
 
-/* Code borrowed from dm-lsi-rdac by Mike Christie */
+static unsigned char emc_long_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
 
-static inline void free_bio(struct bio *bio)
-{
-	__free_page(bio->bi_io_vec[0].bv_page);
-	bio_put(bio);
-}
+static unsigned char emc_long_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x09,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff, 0xff,           /* Trespass target */
+	0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
+};
 
-static int emc_endio(struct bio *bio, unsigned int bytes_done, int error)
-{
-	struct path *path = bio->bi_private;
+static unsigned char emc_short_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x81,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
 
-	if (bio->bi_size)
-		return 1;
+static unsigned char emc_short_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,        /* Page code */
+	0x02,                 /* Page length - 2 */
+	0x01,		      /* Trespass code + Honor reservation bit */
+	0xff,                 /* Trespass target */
+};
+
+/* Code borrowed from dm-lsi-rdac by Mike Christie */
+
+static void emc_endio(struct request *rq)
+{
+	struct path *path = rq->end_io_data;
 
 	/* We also need to look at the sense keys here whether or not to
 	 * switch to the next PG etc.
 	 *
 	 * For now simple logic: either it works or it doesn't.
 	 */
-	if (error)
+	if (rq->errors)
 		dm_pg_init_complete(path, MP_FAIL_PATH);
 	else
 		dm_pg_init_complete(path, 0);
 
-	/* request is freed in block layer */
-	free_bio(bio);
-
-	return 0;
-}
-
-static struct bio *get_failover_bio(struct path *path, unsigned data_size)
-{
-	struct bio *bio;
-	struct page *page;
-
-	bio = bio_alloc(GFP_ATOMIC, 1);
-	if (!bio) {
-		DMERR("dm-emc: get_failover_bio: bio_alloc() failed.");
-		return NULL;
-	}
-
-	bio->bi_rw |= (1 << BIO_RW);
-	bio->bi_bdev = path->dev->bdev;
-	bio->bi_sector = 0;
-	bio->bi_private = path;
-	bio->bi_end_io = emc_endio;
-
-	page = alloc_page(GFP_ATOMIC);
-	if (!page) {
-		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
-		bio_put(bio);
-		return NULL;
-	}
-
-	if (bio_add_page(bio, page, data_size, 0) != data_size) {
-		DMERR("dm-emc: get_failover_bio: alloc_page() failed.");
-		__free_page(page);
-		bio_put(bio);
-		return NULL;
-	}
-
-	return bio;
+	blk_put_request(rq);
 }
 
 static struct request *get_failover_req(struct emc_handler *h,
-					struct bio *bio, struct path *path)
+					struct path *path, unsigned char *data,
+					unsigned data_size)
 {
 	struct request *rq;
-	struct block_device *bdev = bio->bi_bdev;
+	struct block_device *bdev = path->dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	/* FIXME: Figure out why it fails with GFP_ATOMIC. */
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-	if (!rq) {
+	rq = blk_rq_map_kern(q, WRITE, data, data_size, __GFP_WAIT);
+	if (IS_ERR(rq)) {
 		DMERR("dm-emc: get_failover_req: blk_get_request failed");
 		return NULL;
 	}
 
-	rq->bio = rq->biotail = bio;
-	blk_rq_bio_prep(q, rq, bio);
-
+	/*
+	 * do we need to bounce or will data be within the limits magically?
+	 */
+	rq->end_io = emc_endio;
+	rq->end_io_data = path;
 	rq->rq_disk = bdev->bd_contains->bd_disk;
-
-	/* bio backed don't set data */
-	rq->buffer = rq->data = NULL;
-	/* rq data_len used for pc cmd's request_bufflen */
-	rq->data_len = bio->bi_size;
-
 	rq->sense = h->sense;
 	memset(rq->sense, 0, SCSI_SENSE_BUFFERSIZE);
 	rq->sense_len = 0;
@@ -132,49 +117,22 @@ static struct request *get_failover_req(
 static struct request *emc_trespass_get(struct emc_handler *h,
 					struct path *path)
 {
-	struct bio *bio;
 	struct request *rq;
 	unsigned char *page22;
-	unsigned char long_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x09,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff, 0xff,           /* Trespass target */
-		0, 0, 0, 0, 0, 0      /* Reserved bytes / unknown */
-		};
-	unsigned char short_trespass_pg[] = {
-		0, 0, 0, 0,
-		TRESPASS_PAGE,        /* Page code */
-		0x02,                 /* Page length - 2 */
-		h->hr ? 0x01 : 0x81,  /* Trespass code + Honor reservation bit */
-		0xff,                 /* Trespass target */
-		};
-	unsigned data_size = h->short_trespass ? sizeof(short_trespass_pg) :
-				sizeof(long_trespass_pg);
-
-	/* get bio backing */
-	if (data_size > PAGE_SIZE)
-		/* this should never happen */
-		return NULL;
+	unsigned data_size;
 
-	bio = get_failover_bio(path, data_size);
-	if (!bio) {
-		DMERR("dm-emc: emc_trespass_get: no bio");
-		return NULL;
+	if (h->short_trespass) {
+		page22 = h->hr ? emc_short_trespass_hr : emc_short_trespass;
+		data_size = sizeof(emc_short_trespass);
+	} else {
+		page22 = h->hr ? emc_long_trespass_hr : emc_long_trespass;
+		data_size = sizeof(emc_long_trespass);
 	}
 
-	page22 = (unsigned char *)bio_data(bio);
-	memset(page22, 0, data_size);
-
-	memcpy(page22, h->short_trespass ?
-		short_trespass_pg : long_trespass_pg, data_size);
-
 	/* get request for block layer packet command */
-	rq = get_failover_req(h, bio, path);
+	rq = get_failover_req(h, path, page22, data_size);
 	if (!rq) {
 		DMERR("dm-emc: emc_trespass_get: no rq");
-		free_bio(bio);
 		return NULL;
 	}
 
