From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC/RFT 2/4] add scsi helpers
Date: Wed, 14 Sep 2005 17:19:48 -0500
Message-ID: <1126736388.16778.25.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:1220 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1030218AbVINWUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 18:20:05 -0400
Received: from max (c-24-118-218-223.hsd1.mn.comcast.net [24.118.218.223])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.1/8.13.1) with ESMTP id j8EMK4ec021626
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2005 17:20:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

add scsi helper scsi_execute_async_iov_req() and
convert some functions to user it. 

Also add a __scsi_request struct that is only used internally
in scsi_lib.c for our request's end_io_data. Hopefully this will
be all that is left of scsi_request.

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
+	scsi_execute_async_iov_req(sdev, cmnd, DMA_NONE, NULL, 0, 10 * HZ,
+				   5, NULL, NULL);
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
 
@@ -254,8 +221,13 @@ void scsi_do_req(struct scsi_request *sr
 
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
 
@@ -381,6 +353,68 @@ int scsi_execute_req(struct scsi_device 
 }
 EXPORT_SYMBOL(scsi_execute_req);
 
+struct __scsi_request {
+	void *data;
+	void (*done)(void *data, char *sense, int result, int resid);
+	char sense[SCSI_SENSE_BUFFERSIZE];
+};
+
+static void scsi_end_async_req(struct request *req)
+{
+	struct __scsi_request *sreq = req->end_io_data;
+
+	if (sreq->done)
+		sreq->done(sreq->data, sreq->sense, req->errors, req->data_len);
+
+	kfree(sreq);
+	__blk_put_request(req->q, req);
+}
+
+int scsi_execute_async_iov_req(struct scsi_device *sdev,
+			       const unsigned char *cmd, int data_direction,
+			       struct kvec *vec, int vec_count, int timeout,
+			       int retries, void *privdata,
+			       void (*done)(void *, char *, int, int))
+{
+	struct request *req;
+	struct __scsi_request *sreq;
+	int write = (data_direction == DMA_TO_DEVICE);
+
+	sreq = kzalloc(sizeof(*sreq), GFP_ATOMIC);
+	if (!sreq) {
+		return DRIVER_ERROR << 24;
+	}
+
+	req = blk_get_request(sdev->request_queue, write, GFP_ATOMIC);
+	if (!req)
+		goto free_sense;
+
+	if (vec && vec_count &&
+	    blk_rq_map_kern_iov(req->q, req, vec, vec_count, GFP_ATOMIC))
+		goto free_req;
+
+	req->cmd_len = COMMAND_SIZE(cmd[0]);
+	memcpy(req->cmd, cmd, req->cmd_len);
+	req->sense = sreq->sense;
+	req->sense_len = 0;
+	req->timeout = timeout;
+	req->flags |= REQ_BLOCK_PC | REQ_QUIET;
+	req->end_io_data = sreq;
+
+	sreq->data = privdata;
+	sreq->done = done;
+
+	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async_req);
+	return 0;
+
+free_req:
+	blk_put_request(req);
+free_sense:
+	kfree(sreq);
+	return DRIVER_ERROR << 24;
+}
+EXPORT_SYMBOL_GPL(scsi_execute_async_iov_req);
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
@@ -264,6 +264,11 @@ extern int scsi_execute(struct scsi_devi
 extern int scsi_execute_req(struct scsi_device *sdev, const unsigned char *cmd,
 			    int data_direction, void *buffer, unsigned bufflen,
 			    struct scsi_sense_hdr *, int timeout, int retries);
+extern int scsi_execute_async_iov_req(struct scsi_device *sdev,
+				  const unsigned char *cmd, int data_direction,
+				  struct kvec *vec, int vec_count,
+				  int timeout, int retries, void *data,
+				  void (*done)(void *, char *, int, int));
 
 static inline int scsi_device_online(struct scsi_device *sdev)
 {


