From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_execute_async should take a struct scatterlist *
Date: Sat, 4 Nov 2006 20:14:40 +0100
Message-ID: <20061104191440.GD23477@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:2500 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1753647AbWKDTOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Nov 2006 14:14:42 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Crrently scsi_execute_async takes a void *buffer argument that can
be either interpreted as a kernel buffer or scatterlist pointer
depending on what the use_sg argument is set to.  There is no user
of the use_sg == 0 kernel buffer case and we should remove it in
favour of type safety.

And yes, long-term we should get rid of the current scsi_execute_async
interface entirely, struct scatterlist * doesn't make sense as a data
structure above the block layer.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/scsi_lib.c	2006-11-02 15:31:51.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/scsi_lib.c	2006-11-02 17:05:34.000000000 +0100
@@ -368,21 +368,24 @@
 }
 
 /**
- * scsi_execute_async - insert request
- * @sdev:	scsi device
- * @cmd:	scsi command
- * @cmd_len:	length of scsi cdb
- * @data_direction: data direction
- * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
- * @bufflen:	len of buffer
- * @use_sg:	if buffer is a scatterlist this is the number of elements
- * @timeout:	request timeout in seconds
- * @retries:	number of times to retry request
- * @flags:	or into request flags
+ * scsi_execute_async - execute SCSI command asynchronously
+ * @sdev:		scsi device
+ * @cmd:		scsi command block
+ * @cmd_len:		length of scsi command block
+ * @data_direction:	data direction
+ * @sg:			data buffer in form of a scatterlist
+ * @data_length:	total data length
+ * @use_sg:		number of elements in the scatterlist
+ * @timeout:		request timeout in seconds
+ * @retries:		number of times to retry request
+ * @privdata:		private data passed back to the done callback
+ * @done:		I/O completion callback
+ * @gfp:		memory allocation flags
  **/
 int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
-		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
-		       int use_sg, int timeout, int retries, void *privdata,
+		       int cmd_len, int data_direction, struct scatterlist *sg,
+		       unsigned data_length, int use_sg, int timeout,
+		       int retries, void *privdata,
 		       void (*done)(void *, char *, int, int), gfp_t gfp)
 {
 	struct request *req;
@@ -390,6 +393,8 @@
 	int err = 0;
 	int write = (data_direction == DMA_TO_DEVICE);
 
+	BUG_ON(data_length && !use_sg);
+
 	sioc = kmem_cache_alloc(scsi_io_context_cache, gfp);
 	if (!sioc)
 		return DRIVER_ERROR << 24;
@@ -401,13 +406,11 @@
 	req->cmd_type = REQ_TYPE_BLOCK_PC;
 	req->cmd_flags |= REQ_QUIET;
 
-	if (use_sg)
-		err = scsi_req_map_sg(req, buffer, use_sg, bufflen, gfp);
-	else if (bufflen)
-		err = blk_rq_map_kern(req->q, req, buffer, bufflen, gfp);
-
-	if (err)
-		goto free_req;
+	if (use_sg) {
+		err = scsi_req_map_sg(req, sg, use_sg, data_length, gfp);
+		if (err)
+			goto free_req;
+	}
 
 	req->cmd_len = cmd_len;
 	memcpy(req->cmd, cmd, req->cmd_len);
Index: scsi-misc-2.6/include/scsi/scsi_device.h
===================================================================
--- scsi-misc-2.6.orig/include/scsi/scsi_device.h	2006-10-30 17:00:35.000000000 +0100
+++ scsi-misc-2.6/include/scsi/scsi_device.h	2006-11-02 17:05:49.000000000 +0100
@@ -293,7 +293,7 @@
 			    struct scsi_sense_hdr *, int timeout, int retries);
 extern int scsi_execute_async(struct scsi_device *sdev,
 			      const unsigned char *cmd, int cmd_len, int data_direction,
-			      void *buffer, unsigned bufflen, int use_sg,
+			      struct scatterlist *sg, unsigned data_length, int use_sg,
 			      int timeout, int retries, void *privdata,
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
