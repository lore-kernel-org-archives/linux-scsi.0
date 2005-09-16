From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/5] add scsi helpers to send async requests and map pages
Date: Thu, 15 Sep 2005 23:39:46 -0500
Message-ID: <1126845586.9276.42.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37322 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751231AbVIPEjr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Sep 2005 00:39:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

Add scsi helper scsi_execute_async and convert some functions to user it.
This is similar to scsi_execute in that it returns the sense instead
of a normalized scsi sense header. I can extract the internals
and implement a scsi_execute_async_req that returns a sense header.

Fixed from the review comments:
- Renamed __scsi_request to scsi_io_context.

- Went page based. I used a scatterlist since the bio_vec is only supposed
to point to a single page and a scatterlist gives us the structure we
are looking for but it does seem odd to go from a scatterlist to
a request to a scsi_cmd with a scatterlist again (the difference between
the scatterlists is that the one from SG/ST does not always obey queue
limits though). We could add some flag on the request and some checks in
blk_rq_map_sg() and come up with the same result as we had before, but that
would move this odd case back to the block layer. And with this patch at least
sg and st cannot go beyond and segment queue limits and use HighMem.

- moved the request mapping function to scsi becuase it has some
modificiations that are only useful for SG and ST's large request
handling and we may want to modify them further to handle their non sector
based commands.

There seems to be a log of arguments to our scsi execute functions.
Does this seem strange to anyone else or is it ok?

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1366,23 +1366,6 @@ int scsi_decide_disposition(struct scsi_
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
@@ -1404,29 +1387,17 @@ static void scsi_eh_lock_done(struct scs
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
 static void scsi_release_buffers(struct scsi_cmnd *cmd);
 
@@ -251,8 +218,13 @@ void scsi_do_req(struct scsi_request *sr
 
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
 
@@ -378,6 +350,149 @@ int scsi_execute_req(struct scsi_device 
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
+/**
+ * scsi_req_map_sg - map a scatterlist into a request
+ * @q:		request queue where request should be inserted
+ * @rq:		request to fill
+ * @sg:		scatterlist
+ * @nsegs:	number of elements
+ * @gfp_mask:  memory allocation flags
+ *
+ * scsi_req_map_sg maps a scatterlist into a request so that the
+ * request can be sent to the block layer. This is the evil opposite
+ * of blk_rq_map_sg().
+ *
+ * **Note**: This function may be allowed to violate some of the
+ * queue restrictions becuase it is used by SCSI drivers for special
+ * cases.
+ */
+static int scsi_req_map_sg(request_queue_t *q, struct request *rq,
+			   struct scatterlist *sg, int nsegs, unsigned int gfp)
+{
+	struct bio *bio;
+	int i, err = 0;
+	unsigned int len = 0;
+
+	for (i = 0; i < nsegs; i++) {
+		bio = bio_map_pages(q, sg[i].page, sg[i].length, sg[i].offset,
+				    gfp);
+		if (IS_ERR(bio)) {
+			err = PTR_ERR(bio);
+			goto free_bios;
+		}
+		len += sg[i].length;
+
+		bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+		if (rq_data_dir(rq) == WRITE)
+			bio->bi_rw |= (1 << BIO_RW);
+		blk_queue_bounce(q, &bio);
+
+		if (i == 0)
+			blk_rq_bio_prep(q, rq, bio);
+		else if (!q->back_merge_fn(q, rq, bio)) {
+			bio_endio(bio, bio->bi_size, 0);
+			goto free_bios;
+		} else {
+			rq->biotail->bi_next = bio;
+			rq->biotail = bio;
+			rq->hard_nr_sectors += bio_sectors(bio);
+			rq->nr_sectors = rq->hard_nr_sectors;
+		}
+	}
+
+	rq->buffer = rq->data = NULL;
+	rq->data_len = len;
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
+		       void (*done)(void *, char *, int, int), unsigned int gfp)
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
+		err = scsi_req_map_sg(req->q, req, buffer, use_sg, gfp);
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
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -41,7 +41,6 @@ extern void scsi_exit_hosts(void);
 extern int scsi_dispatch_cmd(struct scsi_cmnd *cmd);
 extern int scsi_setup_command_freelist(struct Scsi_Host *shost);
 extern void scsi_destroy_command_freelist(struct Scsi_Host *shost);
-extern int scsi_insert_special_req(struct scsi_request *sreq, int);
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
 extern void __scsi_release_request(struct scsi_request *sreq);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -264,6 +264,12 @@ extern int scsi_execute(struct scsi_devi
 extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
+extern int scsi_execute_async(struct scsi_device *sdev,
+			      const unsigned char *cmd, int data_direction,
+			      void *buffer, unsigned bufflen, int use_sg,
+			      int timeout, int retries, void *privdata,
+			      void (*done)(void *, char *, int, int),
+			      unsigned int gfp);
 
 static inline int scsi_device_online(struct scsi_device *sdev)
 {


