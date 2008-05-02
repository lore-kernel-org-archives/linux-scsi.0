From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH 2.6.25.1] Add scsi_execute_async_fifo()
Date: Fri, 2 May 2008 16:38:42 +0200
Message-ID: <200805021638.42972.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hosted.by.hostbasket.com ([85.255.197.33]:41557 "EHLO
	SMTPGate.qlayer.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754811AbYEBPKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 11:10:01 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net

The patch below implements the following:
* Defines a new internal function __scsi_execute_async(). The only difference
  with the existing function scsi_execute_async() is that this new function
  has an extra parameter, at_head, which allows to specify whether to insert
  the new request at the head or at the tail of the queue.
* Replaces the implementation of scsi_execute_async() by a call to the new
  function __scsi_execute_async(). The behavior of this function is not
  changed.
* Defines a new function scsi_execute_async_fifo() which inserts a request at
  the tail, in FIFO order.
* Adds #define SCSI_EXEC_REQ_FIFO_DEFINED such that out-of-tree kernel
  modules can easily find out whether or not the new function
  scsi_execute_async_fifo() is present.

Signed-off-by: bart.vanassche@gmail.com


diff -uprN -X linux-2.6.25.1/Documentation/dontdiff 
orig/linux-2.6.25.1/drivers/scsi/scsi_lib.c 
linux-2.6.25.1/drivers/scsi/scsi_lib.c
--- orig/linux-2.6.25.1/drivers/scsi/scsi_lib.c	2008-05-01 23:45:25.000000000 
+0200
+++ linux-2.6.25.1/drivers/scsi/scsi_lib.c	2008-05-02 15:26:46.000000000 +0200
@@ -363,7 +363,7 @@ free_bios:
 }
 
 /**
- * scsi_execute_async - insert request
+ * __scsi_execute_async - insert request
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @cmd_len:	length of scsi cdb
@@ -376,11 +376,14 @@ free_bios:
  * @privdata:	data passed to done()
  * @done:	callback function when done
  * @gfp:	memory allocation flags
+ * @at_head:	insert request at head or tail of queue
  */
-int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
+static inline int __scsi_execute_async(struct scsi_device *sdev,
+		       const unsigned char *cmd,
 		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
 		       int use_sg, int timeout, int retries, void *privdata,
-		       void (*done)(void *, char *, int, int), gfp_t gfp)
+		       void (*done)(void *, char *, int, int), gfp_t gfp,
+		       int at_head)
 {
 	struct request *req;
 	struct scsi_io_context *sioc;
@@ -417,7 +420,7 @@ int scsi_execute_async(struct scsi_devic
 	sioc->data = privdata;
 	sioc->done = done;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async);
+	blk_execute_rq_nowait(req->q, NULL, req, at_head, scsi_end_async);
 	return 0;
 
 free_req:
@@ -426,8 +429,57 @@ free_sense:
 	kmem_cache_free(scsi_io_context_cache, sioc);
 	return DRIVER_ERROR << 24;
 }
+
+/**
+ * scsi_execute_async - insert request
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @cmd_len:	length of scsi cdb
+ * @data_direction: data direction
+ * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
+ * @bufflen:	len of buffer
+ * @use_sg:	if buffer is a scatterlist this is the number of elements
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ * @flags:	or into request flags
+ **/
+int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
+		       int cmd_len, int data_direction, void *buffer,
+		       unsigned bufflen, int use_sg, int timeout, int retries,
+		       void *privdata, void (*done)(void *, char *, int, int),
+		       gfp_t gfp)
+{
+	return __scsi_execute_async(sdev, cmd, cmd_len, data_direction, buffer,
+				    bufflen, use_sg, timeout, retries, privdata,
+				    done, gfp, 1);
+}
 EXPORT_SYMBOL_GPL(scsi_execute_async);
 
+/**
+ * scsi_execute_async_fifo - insert request at tail, in FIFO order
+ * @sdev:	scsi device
+ * @cmd:	scsi command
+ * @cmd_len:	length of scsi cdb
+ * @data_direction: data direction
+ * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
+ * @bufflen:	len of buffer
+ * @use_sg:	if buffer is a scatterlist this is the number of elements
+ * @timeout:	request timeout in seconds
+ * @retries:	number of times to retry request
+ * @flags:	or into request flags
+ **/
+int scsi_execute_async_fifo(struct scsi_device *sdev, const unsigned char 
*cmd,
+			    int cmd_len, int data_direction, void *buffer,
+			    unsigned bufflen, int use_sg, int timeout,
+			    int retries, void *privdata,
+			    void (*done)(void *, char *, int, int), gfp_t gfp)
+{
+	return __scsi_execute_async(sdev, cmd, cmd_len, data_direction, buffer,
+				    bufflen, use_sg, timeout, retries, privdata,
+				    done, gfp, 0);
+}
+EXPORT_SYMBOL_GPL(scsi_execute_async_fifo);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
diff -uprN -X linux-2.6.25.1/Documentation/dontdiff 
orig/linux-2.6.25.1/include/scsi/scsi_device.h 
linux-2.6.25.1/include/scsi/scsi_device.h
--- orig/linux-2.6.25.1/include/scsi/scsi_device.h	2008-05-01 
23:45:25.000000000 +0200
+++ linux-2.6.25.1/include/scsi/scsi_device.h	2008-05-02 15:28:29.000000000 
+0200
@@ -332,6 +332,14 @@ extern int scsi_execute_async(struct scs
 			      int timeout, int retries, void *privdata,
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
+#define SCSI_EXEC_REQ_FIFO_DEFINED
+extern int scsi_execute_async_fifo(struct scsi_device *sdev,
+				   const unsigned char *cmd, int cmd_len,
+				   int data_direction, void *buffer,
+				   unsigned bufflen, int use_sg,
+				   int timeout, int retries, void *privdata,
+				   void (*done)(void *, char *, int, int),
+				   gfp_t gfp);
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {
