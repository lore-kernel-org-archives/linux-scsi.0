From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 12/23]: Patch to add necessary support for SCST pass-through
Date: Wed, 10 Dec 2008 21:47:43 +0300
Message-ID: <49400ECF.90505@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:56368 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbYLJSro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:47:44 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch adds to the kernel new function scsi_execute_async_fifo(). 
This function is the same as scsi_execute_async(), but it queues 
requests in FIFO order, not LIFO as scsi_execute_async() does.

Function scsi_execute_async_fifo() is needed for SCST to queue commands 
from remote initiators to SCST devices in pass-through mode. There is no 
simple alternative to this function, because SCST has to deal with SG 
vectors and can't deal with bio's. Hardware target drivers require that.

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scsi/scsi_lib.c    |   58 +++++++++++++++++++++++++++++++++++++++++----
  include/scsi/scsi_device.h |    8 ++++++
  2 files changed, 62 insertions(+), 4 deletions(-)

diff -upr linux-2.6.26/drivers/scsi/scsi_lib.c linux-2.6.26/drivers/scsi/scsi_lib.c
--- linux-2.6.26/drivers/scsi/scsi_lib.c	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/drivers/scsi/scsi_lib.c	2008-07-31 21:20:00.000000000 +0400
@@ -372,7 +372,7 @@ free_bios:
 }
 
 /**
- * scsi_execute_async - insert request
+ * __scsi_execute_async - insert request
  * @sdev:	scsi device
  * @cmd:	scsi command
  * @cmd_len:	length of scsi cdb
@@ -385,11 +385,14 @@ free_bios:
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
@@ -426,7 +429,7 @@ int scsi_execute_async(struct scsi_devic
 	sioc->data = privdata;
 	sioc->done = done;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, scsi_end_async);
+	blk_execute_rq_nowait(req->q, NULL, req, at_head, scsi_end_async);
 	return 0;
 
 free_req:
@@ -435,8 +438,55 @@ free_sense:
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
+		       unsigned bufflen, int use_sg, int timeout,
+		       int retries, void *privdata,
+		       void (*done)(void *, char *, int, int), gfp_t gfp)
+{
+	return __scsi_execute_async(sdev, cmd, cmd_len, data_direction, buffer,
+		bufflen, use_sg, timeout, retries, privdata, done, gfp, 1);
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
+int scsi_execute_async_fifo(struct scsi_device *sdev, const unsigned char *cmd,
+		       int cmd_len, int data_direction, void *buffer,
+		       unsigned bufflen, int use_sg, int timeout, int retries,
+		       void *privdata,
+		       void (*done)(void *, char *, int, int), gfp_t gfp)
+{
+	return __scsi_execute_async(sdev, cmd, cmd_len, data_direction, buffer,
+		bufflen, use_sg, timeout, retries, privdata, done, gfp, 0);
+}
+EXPORT_SYMBOL_GPL(scsi_execute_async_fifo);
+
 /*
  * Function:    scsi_init_cmd_errh()
  *
diff -upr linux-2.6.26/include/scsi/scsi_device.h linux-2.6.26/include/scsi/scsi_device.h
--- linux-2.6.26/include/scsi/scsi_device.h	2008-07-14 01:51:29.000000000 +0400
+++ linux-2.6.26/include/scsi/scsi_device.h	2008-07-31 21:20:39.000000000 +0400
@@ -365,6 +365,14 @@ extern int scsi_execute_async(struct scs
 			      int timeout, int retries, void *privdata,
 			      void (*done)(void *, char *, int, int),
 			      gfp_t gfp);
+#define SCSI_EXEC_REQ_FIFO_DEFINED
+extern int scsi_execute_async_fifo(struct scsi_device *sdev,
+			      const unsigned char *cmd, int cmd_len,
+			      int data_direction, void *buffer,
+			      unsigned bufflen, int use_sg,
+			      int timeout, int retries, void *privdata,
+			      void (*done)(void *, char *, int, int),
+			      gfp_t gfp);
 
 static inline int __must_check scsi_device_reprobe(struct scsi_device *sdev)
 {


