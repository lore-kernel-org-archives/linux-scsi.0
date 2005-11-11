From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/5]
Date: Fri, 11 Nov 2005 05:30:27 -0600
Message-ID: <1131708627.3066.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:28598 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750719AbVKKLan (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Nov 2005 06:30:43 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Add scsi helpers to create really-large-requests and convert
scsi-ml to scsi_execute_async().

Per Jens's previous comments, I placed this function in scsi_lib.c.
I made it follow all the queue's limits - I think I did at least :), so
I removed the warning on the function header.

I think the scsi_execute_* functions should envtually take a request_queue
and be placed some place where the dm-multipath hw_handler can use them
if that failover code is going to stay in the kernel. That conversion
patch will be sent in another mail though.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 18c5d25..53ea62d 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1315,23 +1315,6 @@ int scsi_decide_disposition(struct scsi_
 }
 
 /**
- * scsi_eh_lock_done - done function for eh door lock request
- * @scmd:	SCSI command block for the door lock request
- *
- * Notes:
- * 	We completed the asynchronous door lock request, and it has either
- * 	locked the door or failed.  We must free the command structures
- * 	associated with this request.
- **/
-static void scsi_eh_lock_done(struct scsi_cmnd *scmd)
-{
-	struct scsi_request *sreq = scmd->sc_request;
-
-	scsi_release_request(sreq);
-}
-
-
-/**
  * scsi_eh_lock_door - Prevent medium removal for the specified device
  * @sdev:	SCSI device to prevent medium removal
  *
@@ -1353,29 +1336,17 @@ static void scsi_eh_lock_done(struct scs
  **/
 static void scsi_eh_lock_door(struct scsi_device *sdev)
 {
-	struct scsi_request *sreq = scsi_allocate_request(sdev, GFP_KERNEL);
-
-	if (unlikely(!sreq)) {
-		printk(KERN_ERR "%s: request allocate failed,"
-		       "prevent media removal cmd not sent\n", __FUNCTION__);
-		return;
-	}
+	unsigned char cmnd[MAX_COMMAND_SIZE];
 
-	sreq->sr_cmnd[0] = ALLOW_MEDIUM_REMOVAL;
-	sreq->sr_cmnd[1] = 0;
-	sreq->sr_cmnd[2] = 0;
-	sreq->sr_cmnd[3] = 0;
-	sreq->sr_cmnd[4] = SCSI_REMOVAL_PREVENT;
-	sreq->sr_cmnd[5] = 0;
-	sreq->sr_data_direction = DMA_NONE;
-	sreq->sr_bufflen = 0;
-	sreq->sr_buffer = NULL;
-	sreq->sr_allowed = 5;
-	sreq->sr_done = scsi_eh_lock_done;
-	sreq->sr_timeout_per_command = 10 * HZ;
-	sreq->sr_cmd_len = COMMAND_SIZE(sreq->sr_cmnd[0]);
+	cmnd[0] = ALLOW_MEDIUM_REMOVAL;
+	cmnd[1] = 0;
+	cmnd[2] = 0;
+	cmnd[3] = 0;
+	cmnd[4] = SCSI_REMOVAL_PREVENT;
+	cmnd[5] = 0;
 
-	scsi_insert_special_req(sreq, 1);
+	scsi_execute_async(sdev, cmnd, DMA_NONE, NULL, 0, 0, 10 * HZ,
+			   5, NULL, NULL, GFP_KERNEL);
 }
 
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ce9d73a..1abfc38 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -63,39 +63,6 @@ static struct scsi_host_sg_pool scsi_sg_
 }; 	
 #undef SP
 
-
-/*
- * Function:    scsi_insert_special_req()
- *
- * Purpose:     Insert pre-formed request into request queue.
- *
- * Arguments:   sreq	- request that is ready to be queued.
- *              at_head	- boolean.  True if we should insert at head
- *                        of queue, false if we should insert at tail.
- *
- * Lock status: Assumed that lock is not held upon entry.
- *
- * Returns:     Nothing
- *
- * Notes:       This function is called from character device and from
- *              ioctl types of functions where the caller knows exactly
- *              what SCSI command needs to be issued.   The idea is that
- *              we merely inject the command into the queue (at the head
- *              for now), and then call the queue request function to actually
- *              process it.
- */
-int scsi_insert_special_req(struct scsi_request *sreq, int at_head)
-{
-	/*
-	 * Because users of this function are apt to reuse requests with no
-	 * modification, we have to sanitise the request flags here
-	 */
-	sreq->sr_request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
-		       	   at_head, sreq);
-	return 0;
-}
-
 static void scsi_run_queue(struct request_queue *q);
 
 /*
@@ -249,8 +216,13 @@ void scsi_do_req(struct scsi_request *sr
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
+	 *
+	 * Because users of this function are apt to reuse requests with no
+	 * modification, we have to sanitise the request flags here
 	 */
-	scsi_insert_special_req(sreq, 1);
+	sreq->sr_request->flags &= ~REQ_DONTPREP;
+	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
+		       	   1, sreq);
 }
 EXPORT_SYMBOL(scsi_do_req);
 
@@ -327,6 +299,196 @@ int scsi_execute_req(struct scsi_device 
 }
 EXPORT_SYMBOL(scsi_execute_req);
 
+struct scsi_io_context {
+	void *data;
+	void (*done)(void *data, char *sense, int result, int resid);
+	char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+static void scsi_end_async(struct request *req)
+{
+	struct scsi_io_context *sioc = req->end_io_data;
+
+	if (sioc->done)
+		sioc->done(sioc->data, sioc->sense, req->errors, req->data_len);
+
+	kfree(sioc);
+	__blk_put_request(req->q, req);
+}
+
+static int scsi_merge_bio(struct request *rq, struct bio *bio)
+{
+	struct request_queue *q = rq->q;
+
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+	if (rq_data_dir(rq) == WRITE)
+		bio->bi_rw |= (1 << BIO_RW);
+	blk_queue_bounce(q, &bio);
+
+	if (!rq->bio)
+		blk_rq_bio_prep(q, rq, bio);
+	else if (!q->back_merge_fn(q, rq, bio))
+		return -EINVAL;
+	else {
+		rq->biotail->bi_next = bio;
+		rq->biotail = bio;
+		rq->hard_nr_sectors += bio_sectors(bio);
+		rq->nr_sectors = rq->hard_nr_sectors;
+	}
+
+	return 0;
+}
+
+static int scsi_bi_endio(struct bio *bio, unsigned int bytes_done, int error)
+{
+	if (bio->bi_size)
+		return 1;
+
+	bio_put(bio);
+	return 0;
+}
+
+/**
+ * scsi_req_map_sg - map a scatterlist into a request
+ * @rq:		request to fill
+ * @sg:		scatterlist
+ * @nsegs:	number of elements
+ * @bufflen:	len of buffer
+ * @gfp:	memory allocation flags
+ *
+ * scsi_req_map_sg maps a scatterlist into a request so that the
+ * request can be sent to the block layer. We do not trust the scatterlist
+ * sent to use, as some ULDs use that struct to only organize the pages.
+ */
+static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
+			   int nsegs, unsigned bufflen, gfp_t gfp)
+{
+	struct request_queue *q = rq->q;
+	int nr_pages = (bufflen + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	unsigned int data_len = 0, len, bytes, off;
+	struct page *page;
+	struct bio *bio = NULL;
+	int i, err, nr_vecs = 0;
+
+	for (i = 0; i < nsegs; i++) {
+		page = sgl[i].page;
+		off = sgl[i].offset;
+		len = sgl[i].length;
+		data_len += len;
+
+		while (len > 0) {
+			bytes = min_t(unsigned int, len, PAGE_SIZE - off);
+
+			if (!bio) {
+				nr_vecs = min_t(int, BIO_MAX_PAGES, nr_pages);
+				nr_pages -= nr_vecs;
+
+				bio = bio_alloc(gfp, nr_vecs);
+				if (!bio) {
+					err = -ENOMEM;
+					goto free_bios;
+				}
+				bio->bi_end_io = scsi_bi_endio;
+			}
+
+			if (bio_add_pc_page(q, bio, page, bytes, off) !=
+			    bytes) {
+				bio_put(bio);
+				err = -EINVAL;
+				goto free_bios;
+			}
+
+			if (bio->bi_vcnt >= nr_vecs) {
+				err = scsi_merge_bio(rq, bio);
+				if (err) {
+					bio_endio(bio, bio->bi_size, 0);
+					goto free_bios;
+				}
+				bio = NULL;
+			}
+
+			page++;
+			len -= bytes;
+			off = 0;
+		}
+	}
+
+	rq->buffer = rq->data = NULL;
+	rq->data_len = data_len;
+	return 0;
+
+free_bios:
+	while ((bio = rq->bio) != NULL) {
+		rq->bio = bio->bi_next;
+		/*
+		 * call endio instead of bio_put incase it was bounced
+		 */
+		bio_endio(bio, bio->bi_size, 0);
+	}
+
+	return err;
+}
+
+/**
+ * scsi_execute_async - insert request
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @data_direction: data direction
+ * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
+ * @bufflen:	len of buffer
+ * @use_sg:	if buffer is a scatterlist this is the number of elements
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ * @flags:	or into request flags
+ **/
+int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
+		       int data_direction, void *buffer, unsigned bufflen,
+		       int use_sg, int timeout, int retries, void *privdata,
+		       void (*done)(void *, char *, int, int), gfp_t gfp)
+{
+	struct request *req;
+	struct scsi_io_context *sioc;
+	int err = 0;
+	int write = (data_direction == DMA_TO_DEVICE);
+
+	sioc = kzalloc(sizeof(*sioc), gfp);
+	if (!sioc)
+		return DRIVER_ERROR << 24;
+
+	req = blk_get_request(sdev->request_queue, write, gfp);
+	if (!req)
+		goto free_sense;
+
+	if (use_sg)
+		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
+	else if (bufflen)
+		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
+
+	if (err)
+		goto free_req;
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = sioc->sense;
+	req->sense_len = 0;
+	req->timeout = timeout;
+	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
+	req->end_io_data = sioc;
+
+	sioc->data = privdata;
+	sioc->done = done;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async);
+	return 0;
+
+free_req:
+	blk_put_request(req);
+free_sense:
+	kfree(sioc);
+	return DRIVER_ERROR << 24;
+}
+EXPORT_SYMBOL_GPL(scsi_execute_async);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index d632d9e..647aa62 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -40,7 +40,6 @@ extern void scsi_exit_hosts(void);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern int scsi_insert_special_req(struct scsi_request *sreq, int);
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
 extern void __scsi_release_request(struct scsi_request *sreq);
diff --git a/fs/bio.c b/fs/bio.c
index 460554b..4d21ee3 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -386,6 +386,25 @@ static int __bio_add_page(request_queue_
 }
 
 /**
+ *	bio_add_pc_page	-	attempt to add page to bio
+ *	@bio: destination bio
+ *	@page: page to add
+ *	@len: vec entry length
+ *	@offset: vec entry offset
+ *
+ *	Attempt to add a page to the bio_vec maplist. This can fail for a
+ *	number of reasons, such as the bio being full or target block
+ *	device limitations. The target block device must allow bio's
+ *      smaller than PAGE_SIZE, so it is always possible to add a single
+ *      page to an empty bio. This should only be used by REQ_PC bios.
+ */
+int bio_add_pc_page(request_queue_t *q, struct bio *bio, struct page *page,
+		    unsigned int len, unsigned int offset)
+{
+	return __bio_add_page(q, bio, page, len, offset);
+}
+
+/**
  *	bio_add_page	-	attempt to add page to bio
  *	@bio: destination bio
  *	@page: page to add
@@ -1228,6 +1247,7 @@ EXPORT_SYMBOL(bio_clone);
 EXPORT_SYMBOL(bio_phys_segments);
 EXPORT_SYMBOL(bio_hw_segments);
 EXPORT_SYMBOL(bio_add_page);
+EXPORT_SYMBOL(bio_add_pc_page);
 EXPORT_SYMBOL(bio_get_nr_vecs);
 EXPORT_SYMBOL(bio_map_user);
 EXPORT_SYMBOL(bio_unmap_user);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 685fd37..b60ffe3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -292,6 +292,8 @@ extern struct bio *bio_clone(struct bio 
 extern void bio_init(struct bio *);
 
 extern int bio_add_page(struct bio *, struct page *, unsigned int,unsigned int);
+extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
+			   unsigned int, unsigned int);
 extern int bio_get_nr_vecs(struct block_device *);
 extern struct bio *bio_map_user(struct request_queue *, struct block_device *,
 				unsigned long, unsigned int, int);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 85cfd88..ce35cf0 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -274,6 +274,12 @@ extern int scsi_execute(struct scsi_devi
 extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
+extern int scsi_execute_async(struct scsi_device *sdev,
+			      const unsigned char *cmd, int data_direction,
+			      void *buffer, unsigned bufflen, int use_sg,
+			      int timeout, int retries, void *privdata,
+			      void (*done)(void *, char *, int, int),
+			      gfp_t gfp);
 
 static inline unsigned int sdev_channel(struct scsi_device *sdev)
 {


