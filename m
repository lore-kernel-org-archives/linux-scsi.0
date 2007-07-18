From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 3/3] zfcp: code cleanup
Date: Wed, 18 Jul 2007 10:55:13 +0200
Message-ID: <200707181055.13242.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:19907 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbXGRIzX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 04:55:23 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate7.de.ibm.com (8.13.8/8.13.8) with ESMTP id l6I8tMRA302936
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 08:55:22 GMT
Received: from d12av01.megacenter.de.ibm.com (d12av01.megacenter.de.ibm.com [9.149.165.212])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l6I8tMgq2019400
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 10:55:22 +0200
Received: from d12av01.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av01.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6I8tDk1018346
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 10:55:13 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

Subject: [PATCH] zfcp: code cleanup

From: Swen Schillig <swen@vnet.ibm.com>

improve code for buffer enqueue. easy readability and maintainability.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_def.h  |    1 
 drivers/s390/scsi/zfcp_qdio.c |  113 +++++++++++-------------------------------
 2 files changed, 33 insertions(+), 81 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2007-07-18 10:28:26.000000000 +0200
@@ -126,6 +126,7 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_MIN_OUTPUT_THRESHOLD 	1	/* ignored by QDIO layer */
 
 #define QDIO_SCSI_QFMT			1	/* 1 for FSF */
+#define QBUFF_PER_PAGE			(PAGE_SIZE / sizeof(struct qdio_buffer))
 
 /********************* FSF SPECIFIC DEFINES *********************************/
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_qdio.c linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c
--- linux-2.6/drivers/s390/scsi/zfcp_qdio.c	2007-07-09 01:32:17.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_qdio.c	2007-07-18 10:28:26.000000000 +0200
@@ -47,103 +47,56 @@ static int zfcp_qdio_handler_error_check
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_QDIO
 
 /*
- * Allocates BUFFER memory to each of the pointers of the qdio_buffer_t 
- * array in the adapter struct.
- * Cur_buf is the pointer array and count can be any number of required 
- * buffers, the page-fitting arithmetic is done entirely within this funciton.
+ * Frees BUFFER memory for each of the pointers of the struct qdio_buffer array
+ * in the adapter struct sbuf is the pointer array.
  *
- * returns:	number of buffers allocated
  * locks:       must only be called with zfcp_data.config_sema taken
  */
-static int
-zfcp_qdio_buffers_enqueue(struct qdio_buffer **cur_buf, int count)
+static void
+zfcp_qdio_buffers_dequeue(struct qdio_buffer **sbuf)
 {
-	int buf_pos;
-	int qdio_buffers_per_page;
-	int page_pos = 0;
-	struct qdio_buffer *first_in_page = NULL;
-
-	qdio_buffers_per_page = PAGE_SIZE / sizeof (struct qdio_buffer);
-	ZFCP_LOG_TRACE("buffers_per_page=%d\n", qdio_buffers_per_page);
-
-	for (buf_pos = 0; buf_pos < count; buf_pos++) {
-		if (page_pos == 0) {
-			cur_buf[buf_pos] = (struct qdio_buffer *)
-			    get_zeroed_page(GFP_KERNEL);
-			if (cur_buf[buf_pos] == NULL) {
-				ZFCP_LOG_INFO("error: allocation of "
-					      "QDIO buffer failed \n");
-				goto out;
-			}
-			first_in_page = cur_buf[buf_pos];
-		} else {
-			cur_buf[buf_pos] = first_in_page + page_pos;
+	int pos;
 
-		}
-		/* was initialised to zero */
-		page_pos++;
-		page_pos %= qdio_buffers_per_page;
-	}
- out:
-	return buf_pos;
+	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos += QBUFF_PER_PAGE)
+		free_page((unsigned long) sbuf[pos]);
 }
 
 /*
- * Frees BUFFER memory for each of the pointers of the struct qdio_buffer array
- * in the adapter struct cur_buf is the pointer array and count can be any
- * number of buffers in the array that should be freed starting from buffer 0
+ * Allocates BUFFER memory to each of the pointers of the qdio_buffer_t
+ * array in the adapter struct.
+ * Cur_buf is the pointer array
  *
+ * returns:	zero on success else -ENOMEM
  * locks:       must only be called with zfcp_data.config_sema taken
  */
-static void
-zfcp_qdio_buffers_dequeue(struct qdio_buffer **cur_buf, int count)
+static int
+zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbuf)
 {
-	int buf_pos;
-	int qdio_buffers_per_page;
-
-	qdio_buffers_per_page = PAGE_SIZE / sizeof (struct qdio_buffer);
-	ZFCP_LOG_TRACE("buffers_per_page=%d\n", qdio_buffers_per_page);
+	int pos;
 
-	for (buf_pos = 0; buf_pos < count; buf_pos += qdio_buffers_per_page)
-		free_page((unsigned long) cur_buf[buf_pos]);
-	return;
+	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos += QBUFF_PER_PAGE) {
+		sbuf[pos] = (struct qdio_buffer *) get_zeroed_page(GFP_KERNEL);
+		if (!sbuf[pos]) {
+			zfcp_qdio_buffers_dequeue(sbuf);
+			return -ENOMEM;
+		}
+	}
+	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos++)
+		if (pos % QBUFF_PER_PAGE)
+			sbuf[pos] = sbuf[pos - 1] + 1;
+	return 0;
 }
 
 /* locks:       must only be called with zfcp_data.config_sema taken */
 int
 zfcp_qdio_allocate_queues(struct zfcp_adapter *adapter)
 {
-	int buffer_count;
-	int retval = 0;
+	int ret;
 
-	buffer_count =
-	    zfcp_qdio_buffers_enqueue(&(adapter->request_queue.buffer[0]),
-				      QDIO_MAX_BUFFERS_PER_Q);
-	if (buffer_count < QDIO_MAX_BUFFERS_PER_Q) {
-		ZFCP_LOG_DEBUG("only %d QDIO buffers allocated for request "
-			       "queue\n", buffer_count);
-		zfcp_qdio_buffers_dequeue(&(adapter->request_queue.buffer[0]),
-					  buffer_count);
-		retval = -ENOMEM;
-		goto out;
-	}
-
-	buffer_count =
-	    zfcp_qdio_buffers_enqueue(&(adapter->response_queue.buffer[0]),
-				      QDIO_MAX_BUFFERS_PER_Q);
-	if (buffer_count < QDIO_MAX_BUFFERS_PER_Q) {
-		ZFCP_LOG_DEBUG("only %d QDIO buffers allocated for response "
-			       "queue", buffer_count);
-		zfcp_qdio_buffers_dequeue(&(adapter->response_queue.buffer[0]),
-					  buffer_count);
-		ZFCP_LOG_TRACE("freeing request_queue buffers\n");
-		zfcp_qdio_buffers_dequeue(&(adapter->request_queue.buffer[0]),
-					  QDIO_MAX_BUFFERS_PER_Q);
-		retval = -ENOMEM;
-		goto out;
-	}
- out:
-	return retval;
+	ret = zfcp_qdio_buffers_enqueue(adapter->request_queue.buffer);
+	if (ret)
+		return ret;
+	return zfcp_qdio_buffers_enqueue(adapter->response_queue.buffer);
 }
 
 /* locks:       must only be called with zfcp_data.config_sema taken */
@@ -151,12 +104,10 @@ void
 zfcp_qdio_free_queues(struct zfcp_adapter *adapter)
 {
 	ZFCP_LOG_TRACE("freeing request_queue buffers\n");
-	zfcp_qdio_buffers_dequeue(&(adapter->request_queue.buffer[0]),
-				  QDIO_MAX_BUFFERS_PER_Q);
+	zfcp_qdio_buffers_dequeue(adapter->request_queue.buffer);
 
 	ZFCP_LOG_TRACE("freeing response_queue buffers\n");
-	zfcp_qdio_buffers_dequeue(&(adapter->response_queue.buffer[0]),
-				  QDIO_MAX_BUFFERS_PER_Q);
+	zfcp_qdio_buffers_dequeue(adapter->response_queue.buffer);
 }
 
 int
