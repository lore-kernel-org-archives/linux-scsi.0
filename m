From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 1/3] remove scsi_req_map_sg
Date: Sun, 14 Dec 2008 01:23:45 +0900
Message-ID: <1229185427-4130-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:35185 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYLMQZJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Dec 2008 11:25:09 -0500
In-Reply-To: <1229185427-4130-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

No one uses scsi_execute_async with data transfer now. We can remove
scsi_req_map_sg.

Only scsi_eh_lock_door uses scsi_execute_async. scsi_eh_lock_door
doesn't handle sense and the callback. So we can remove
scsi_io_context too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/scsi_error.c  |   34 +++++--
 drivers/scsi/scsi_lib.c    |  203 +-------------------------------------------
 include/scsi/scsi_device.h |    6 --
 3 files changed, 25 insertions(+), 218 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 381838e..29fb11a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1453,6 +1453,11 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 	}
 }
 
+static void eh_lock_door_done(struct request *req, int uptodate)
+{
+	__blk_put_request(req->q, req);
+}
+
 /**
  * scsi_eh_lock_door - Prevent medium removal for the specified device
  * @sdev:	SCSI device to prevent medium removal
@@ -1475,19 +1480,28 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
  */
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	struct request *req;
 
-	cmnd[0] = ALLOW_MEDIUM_REMOVAL;
-	cmnd[1] = 0;
-	cmnd[2] = 0;
-	cmnd[3] = 0;
-	cmnd[4] = SCSI_REMOVAL_PREVENT;
-	cmnd[5] = 0;
+	req = blk_get_request(sdev->request_queue, READ, GFP_KERNEL);
+	if (!req)
+		return;
 
-	scsi_execute_async(sdev, cmnd, 6, DMA_NONE, NULL, 0, 0, 10 * HZ,
-			   5, NULL, NULL, GFP_KERNEL);
-}
+	req->cmd[0] = ALLOW_MEDIUM_REMOVAL;
+	req->cmd[1] = 0;
+	req->cmd[2] = 0;
+	req->cmd[3] = 0;
+	req->cmd[4] = SCSI_REMOVAL_PREVENT;
+	req->cmd[5] = 0;
 
+	req->cmd_len = COMMAND_SIZE(req->cmd[0]);
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_flags |= REQ_QUIET;
+	req->timeout = 10 * HZ;
+	req->retries = 5;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
+}
 
 /**
  * scsi_restart_operations - restart io operations to the specified host.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 111f9e9..537e0c0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -260,196 +260,6 @@ int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(scsi_execute_req);
 
-struct scsi_io_context {
-	void *data;
-	void (*done)(void *data, char *sense, int result, int resid);
-	char sense[SCSI_SENSE_BUFFERSIZE];
-};
-
-static struct kmem_cache *scsi_io_context_cache;
-
-static void scsi_end_async(struct request *req, int uptodate)
-{
-	struct scsi_io_context *sioc = req->end_io_data;
-
-	if (sioc->done)
-		sioc->done(sioc->data, sioc->sense, req->errors, req->data_len);
-
-	kmem_cache_free(scsi_io_context_cache, sioc);
-	__blk_put_request(req->q, req);
-}
-
-static int scsi_merge_bio(struct request *rq, struct bio *bio)
-{
-	struct request_queue *q = rq->q;
-
-	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
-	if (rq_data_dir(rq) == WRITE)
-		bio->bi_rw |= (1 << BIO_RW);
-	blk_queue_bounce(q, &bio);
-
-	return blk_rq_append_bio(q, rq, bio);
-}
-
-static void scsi_bi_endio(struct bio *bio, int error)
-{
-	bio_put(bio);
-}
-
-/**
- * scsi_req_map_sg - map a scatterlist into a request
- * @rq:		request to fill
- * @sgl:	scatterlist
- * @nsegs:	number of elements
- * @bufflen:	len of buffer
- * @gfp:	memory allocation flags
- *
- * scsi_req_map_sg maps a scatterlist into a request so that the
- * request can be sent to the block layer. We do not trust the scatterlist
- * sent to use, as some ULDs use that struct to only organize the pages.
- */
-static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
-			   int nsegs, unsigned bufflen, gfp_t gfp)
-{
-	struct request_queue *q = rq->q;
-	int nr_pages = (bufflen + sgl[0].offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	unsigned int data_len = bufflen, len, bytes, off;
-	struct scatterlist *sg;
-	struct page *page;
-	struct bio *bio = NULL;
-	int i, err, nr_vecs = 0;
-
-	for_each_sg(sgl, sg, nsegs, i) {
-		page = sg_page(sg);
-		off = sg->offset;
-		len = sg->length;
-
-		while (len > 0 && data_len > 0) {
-			/*
-			 * sg sends a scatterlist that is larger than
-			 * the data_len it wants transferred for certain
-			 * IO sizes
-			 */
-			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
-			bytes = min(bytes, data_len);
-
-			if (!bio) {
-				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
-				nr_pages -= nr_vecs;
-
-				bio = bio_alloc(gfp, nr_vecs);
-				if (!bio) {
-					err = -ENOMEM;
-					goto free_bios;
-				}
-				bio->bi_end_io = scsi_bi_endio;
-			}
-
-			if (bio_add_pc_page(q, bio, page, bytes, off) !=
-			    bytes) {
-				bio_put(bio);
-				err = -EINVAL;
-				goto free_bios;
-			}
-
-			if (bio->bi_vcnt >= nr_vecs) {
-				err = scsi_merge_bio(rq, bio);
-				if (err) {
-					bio_endio(bio, 0);
-					goto free_bios;
-				}
-				bio = NULL;
-			}
-
-			page++;
-			len -= bytes;
-			data_len -=bytes;
-			off = 0;
-		}
-	}
-
-	rq->buffer = rq->data = NULL;
-	rq->data_len = bufflen;
-	return 0;
-
-free_bios:
-	while ((bio = rq->bio) != NULL) {
-		rq->bio = bio->bi_next;
-		/*
-		 * call endio instead of bio_put incase it was bounced
-		 */
-		bio_endio(bio, 0);
-	}
-
-	return err;
-}
-
-/**
- * scsi_execute_async - insert request
- * @sdev:	scsi device
- * @cmd:	scsi command
- * @cmd_len:	length of scsi cdb
- * @data_direction: DMA_TO_DEVICE, DMA_FROM_DEVICE, or DMA_NONE
- * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
- * @bufflen:	len of buffer
- * @use_sg:	if buffer is a scatterlist this is the number of elements
- * @timeout:	request timeout in seconds
- * @retries:	number of times to retry request
- * @privdata:	data passed to done()
- * @done:	callback function when done
- * @gfp:	memory allocation flags
- */
-int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
-		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
-		       int use_sg, int timeout, int retries, void *privdata,
-		       void (*done)(void *, char *, int, int), gfp_t gfp)
-{
-	struct request *req;
-	struct scsi_io_context *sioc;
-	int err = 0;
-	int write = (data_direction == DMA_TO_DEVICE);
-
-	sioc = kmem_cache_zalloc(scsi_io_context_cache, gfp);
-	if (!sioc)
-		return DRIVER_ERROR << 24;
-
-	req = blk_get_request(sdev->request_queue, write, gfp);
-	if (!req)
-		goto free_sense;
-	req->cmd_type = REQ_TYPE_BLOCK_PC;
-	req->cmd_flags |= REQ_QUIET;
-
-	if (use_sg)
-		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
-	else if (bufflen)
-		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
-
-	if (err)
-		goto free_req;
-
-	req->cmd_len = cmd_len;
-	memset(req->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
-	memcpy(req->cmd, cmd, req->cmd_len);
-	req->sense = sioc->sense;
-	req->sense_len = 0;
-	req->timeout = timeout;
-	req->retries = retries;
-	req->end_io_data = sioc;
-
-	sioc->data = privdata;
-	sioc->done = done;
-
-	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async);
-	return 0;
-
-free_req:
-	blk_put_request(req);
-free_sense:
-	kmem_cache_free(scsi_io_context_cache, sioc);
-	return DRIVER_ERROR << 24;
-}
-EXPORT_SYMBOL_GPL(scsi_execute_async);
-
 /*
  * Function:    scsi_init_cmd_errh()
  *
@@ -1882,20 +1692,12 @@ int __init scsi_init_queue(void)
 {
 	int i;
 
-	scsi_io_context_cache = kmem_cache_create("scsi_io_context",
-					sizeof(struct scsi_io_context),
-					0, 0, NULL);
-	if (!scsi_io_context_cache) {
-		printk(KERN_ERR "SCSI: can't init scsi io context cache\n");
-		return -ENOMEM;
-	}
-
 	scsi_sdb_cache = kmem_cache_create("scsi_data_buffer",
 					   sizeof(struct scsi_data_buffer),
 					   0, 0, NULL);
 	if (!scsi_sdb_cache) {
 		printk(KERN_ERR "SCSI: can't init scsi sdb cache\n");
-		goto cleanup_io_context;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
@@ -1930,8 +1732,6 @@ cleanup_sdb:
 			kmem_cache_destroy(sgp->slab);
 	}
 	kmem_cache_destroy(scsi_sdb_cache);
-cleanup_io_context:
-	kmem_cache_destroy(scsi_io_context_cache);
 
 	return -ENOMEM;
 }
@@ -1940,7 +1740,6 @@ void scsi_exit_queue(void)
 {
 	int i;
 
-	kmem_cache_destroy(scsi_io_context_cache);
 	kmem_cache_destroy(scsi_sdb_cache);
 
 	for (i = 0; i < SG_MEMPOOL_NR; i++) {
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 01a4c58..d9e5ef0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -370,12 +370,6 @@ extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries,
 			    int *resid);
-extern int scsi_execute_async(struct scsi_device *sdev,
-			      const unsigned char *cmd, int cmd_len, int data_direction,
-			      void *buffer, unsigned bufflen, int use_sg,
-			      int timeout, int retries, void *privdata,
-			      void (*done)(void *, char *, int, int),
-			      gfp_t gfp);
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
-- 
1.5.5.GIT

