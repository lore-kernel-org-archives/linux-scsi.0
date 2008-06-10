From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/8] zfcp: Cleanup qdio code
Date: Tue, 10 Jun 2008 18:20:57 +0200
Message-ID: <20080610162515.689734000@de.ibm.com>
References: <20080610162053.144590000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:46862 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYFJQZb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 12:25:31 -0400
Content-Disposition: inline; filename=zfcp_qdio_cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Cleanup the interface code from zfcp to qdio. Also move code that
belongs to the qdio interface from the erp to the qdio file.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |   45 --
 drivers/s390/scsi/zfcp_dbf.c  |    3 
 drivers/s390/scsi/zfcp_def.h  |   26 -
 drivers/s390/scsi/zfcp_erp.c  |  114 -----
 drivers/s390/scsi/zfcp_ext.h  |   18 
 drivers/s390/scsi/zfcp_fsf.c  |  178 +++------
 drivers/s390/scsi/zfcp_qdio.c |  819 ++++++++++++++++--------------------------
 7 files changed, 414 insertions(+), 789 deletions(-)

--- a/drivers/s390/scsi/zfcp_qdio.c	2008-06-10 17:35:44.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-06-10 17:37:48.000000000 +0200
@@ -1,241 +1,92 @@
 /*
- * This file is part of the zfcp device driver for
- * FCP adapters for IBM System z9 and zSeries.
+ * zfcp device driver
  *
- * (C) Copyright IBM Corp. 2002, 2006
+ * Setup and helper functions to access QDIO.
  *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2, or (at your option)
- * any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ * Copyright IBM Corporation 2002, 2008
  */
 
 #include "zfcp_ext.h"
 
-static void zfcp_qdio_sbal_limit(struct zfcp_fsf_req *, int);
-static inline volatile struct qdio_buffer_element *zfcp_qdio_sbale_get
-	(struct zfcp_qdio_queue *, int, int);
-static inline volatile struct qdio_buffer_element *zfcp_qdio_sbale_resp
-	(struct zfcp_fsf_req *, int, int);
-static volatile struct qdio_buffer_element *zfcp_qdio_sbal_chain
-	(struct zfcp_fsf_req *, unsigned long);
-static volatile struct qdio_buffer_element *zfcp_qdio_sbale_next
-	(struct zfcp_fsf_req *, unsigned long);
-static int zfcp_qdio_sbals_zero(struct zfcp_qdio_queue *, int, int);
-static inline int zfcp_qdio_sbals_wipe(struct zfcp_fsf_req *);
-static void zfcp_qdio_sbale_fill
-	(struct zfcp_fsf_req *, unsigned long, void *, int);
-static int zfcp_qdio_sbals_from_segment
-	(struct zfcp_fsf_req *, unsigned long, void *, unsigned long);
-
-static qdio_handler_t zfcp_qdio_request_handler;
-static qdio_handler_t zfcp_qdio_response_handler;
-static int zfcp_qdio_handler_error_check(struct zfcp_adapter *,
-	unsigned int, unsigned int, unsigned int, int, int);
+/* FIXME(tune): free space should be one max. SBAL chain plus what? */
+#define ZFCP_QDIO_PCI_INTERVAL	(QDIO_MAX_BUFFERS_PER_Q \
+				- (ZFCP_MAX_SBALS_PER_REQ + 4))
 
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_QDIO
-
-/*
- * Frees BUFFER memory for each of the pointers of the struct qdio_buffer array
- * in the adapter struct sbuf is the pointer array.
- *
- * locks:       must only be called with zfcp_data.config_sema taken
- */
-static void
-zfcp_qdio_buffers_dequeue(struct qdio_buffer **sbuf)
-{
-	int pos;
-
-	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos += QBUFF_PER_PAGE)
-		free_page((unsigned long) sbuf[pos]);
-}
-
-/*
- * Allocates BUFFER memory to each of the pointers of the qdio_buffer_t
- * array in the adapter struct.
- * Cur_buf is the pointer array
- *
- * returns:	zero on success else -ENOMEM
- * locks:       must only be called with zfcp_data.config_sema taken
- */
-static int
-zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbuf)
+static int zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbal)
 {
 	int pos;
 
 	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos += QBUFF_PER_PAGE) {
-		sbuf[pos] = (struct qdio_buffer *) get_zeroed_page(GFP_KERNEL);
-		if (!sbuf[pos]) {
-			zfcp_qdio_buffers_dequeue(sbuf);
+		sbal[pos] = (struct qdio_buffer *) get_zeroed_page(GFP_KERNEL);
+		if (!sbal[pos])
 			return -ENOMEM;
-		}
 	}
 	for (pos = 0; pos < QDIO_MAX_BUFFERS_PER_Q; pos++)
 		if (pos % QBUFF_PER_PAGE)
-			sbuf[pos] = sbuf[pos - 1] + 1;
+			sbal[pos] = sbal[pos - 1] + 1;
 	return 0;
 }
 
-/* locks:       must only be called with zfcp_data.config_sema taken */
-int
-zfcp_qdio_allocate_queues(struct zfcp_adapter *adapter)
+static volatile struct qdio_buffer_element *
+zfcp_qdio_sbale(struct zfcp_qdio_queue *q, int sbal_idx, int sbale_idx)
 {
-	int ret;
-
-	ret = zfcp_qdio_buffers_enqueue(adapter->request_queue.buffer);
-	if (ret)
-		return ret;
-	return zfcp_qdio_buffers_enqueue(adapter->response_queue.buffer);
+	return &q->sbal[sbal_idx]->element[sbale_idx];
 }
 
-/* locks:       must only be called with zfcp_data.config_sema taken */
-void
-zfcp_qdio_free_queues(struct zfcp_adapter *adapter)
+/**
+ * zfcp_qdio_free - free memory used by request- and resposne queue
+ * @adapter: pointer to the zfcp_adapter structure
+ */
+void zfcp_qdio_free(struct zfcp_adapter *adapter)
 {
-	ZFCP_LOG_TRACE("freeing request_queue buffers\n");
-	zfcp_qdio_buffers_dequeue(adapter->request_queue.buffer);
+	struct qdio_buffer **sbal_req, **sbal_resp;
+	int p;
 
-	ZFCP_LOG_TRACE("freeing response_queue buffers\n");
-	zfcp_qdio_buffers_dequeue(adapter->response_queue.buffer);
-}
+	if (adapter->ccw_device)
+		qdio_free(adapter->ccw_device);
 
-int
-zfcp_qdio_allocate(struct zfcp_adapter *adapter)
-{
-	struct qdio_initialize *init_data;
+	sbal_req = adapter->req_q.sbal;
+	sbal_resp = adapter->resp_q.sbal;
 
-	init_data = &adapter->qdio_init_data;
+	for (p = 0; p < QDIO_MAX_BUFFERS_PER_Q; p += QBUFF_PER_PAGE) {
+		free_page((unsigned long) sbal_req[p]);
+		free_page((unsigned long) sbal_resp[p]);
+	}
+}
 
-	init_data->cdev = adapter->ccw_device;
-	init_data->q_format = QDIO_SCSI_QFMT;
-	memcpy(init_data->adapter_name, zfcp_get_busid_by_adapter(adapter), 8);
-	ASCEBC(init_data->adapter_name, 8);
-	init_data->qib_param_field_format = 0;
-	init_data->qib_param_field = NULL;
-	init_data->input_slib_elements = NULL;
-	init_data->output_slib_elements = NULL;
-	init_data->min_input_threshold = ZFCP_MIN_INPUT_THRESHOLD;
-	init_data->max_input_threshold = ZFCP_MAX_INPUT_THRESHOLD;
-	init_data->min_output_threshold = ZFCP_MIN_OUTPUT_THRESHOLD;
-	init_data->max_output_threshold = ZFCP_MAX_OUTPUT_THRESHOLD;
-	init_data->no_input_qs = 1;
-	init_data->no_output_qs = 1;
-	init_data->input_handler = zfcp_qdio_response_handler;
-	init_data->output_handler = zfcp_qdio_request_handler;
-	init_data->int_parm = (unsigned long) adapter;
-	init_data->flags = QDIO_INBOUND_0COPY_SBALS |
-	    QDIO_OUTBOUND_0COPY_SBALS | QDIO_USE_OUTBOUND_PCIS;
-	init_data->input_sbal_addr_array =
-	    (void **) (adapter->response_queue.buffer);
-	init_data->output_sbal_addr_array =
-	    (void **) (adapter->request_queue.buffer);
+static void zfcp_qdio_handler_error(struct zfcp_adapter *adapter, u8 id)
+{
+	dev_warn(&adapter->ccw_device->dev, "QDIO problem occurred.\n");
 
-	return qdio_allocate(init_data);
+	zfcp_erp_adapter_reopen(adapter,
+				ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+				ZFCP_STATUS_COMMON_ERP_FAILED, id, NULL);
 }
 
-/*
- * function:   	zfcp_qdio_handler_error_check
- *
- * purpose:     called by the response handler to determine error condition
- *
- * returns:	error flag
- *
- */
-static int
-zfcp_qdio_handler_error_check(struct zfcp_adapter *adapter, unsigned int status,
-			      unsigned int qdio_error, unsigned int siga_error,
-			      int first_element, int elements_processed)
+static void zfcp_qdio_int_req(struct ccw_device *cdev, unsigned int status,
+			      unsigned int qdio_err, unsigned int siga_err,
+			      unsigned int queue_no, int first, int count,
+			      unsigned long parm)
 {
-	int retval = 0;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
+	struct zfcp_qdio_queue *queue = &adapter->req_q;
 
 	if (unlikely(status & QDIO_STATUS_LOOK_FOR_ERROR)) {
-		retval = -EIO;
-
-		ZFCP_LOG_INFO("QDIO problem occurred (status=0x%x, "
-			      "qdio_error=0x%x, siga_error=0x%x)\n",
-			      status, qdio_error, siga_error);
-
-		zfcp_hba_dbf_event_qdio(adapter, status, qdio_error, siga_error,
-				first_element, elements_processed);
-               /*
-               	* Restarting IO on the failed adapter from scratch.
-                * Since we have been using this adapter, it is save to assume
-                * that it is not failed but recoverable. The card seems to
-                * report link-up events by self-initiated queue shutdown.
-                * That is why we need to clear the link-down flag
-                * which is set again in case we have missed by a mile.
-                */
-		zfcp_erp_adapter_reopen(adapter,
-					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-					ZFCP_STATUS_COMMON_ERP_FAILED, 140,
-					NULL);
+		zfcp_hba_dbf_event_qdio(adapter, status, qdio_err, siga_err,
+					first, count);
+		zfcp_qdio_handler_error(adapter, 140);
+		return;
 	}
-	return retval;
-}
-
-/*
- * function:    zfcp_qdio_request_handler
- *
- * purpose:	is called by QDIO layer for completed SBALs in request queue
- *
- * returns:	(void)
- */
-static void
-zfcp_qdio_request_handler(struct ccw_device *ccw_device,
-			  unsigned int status,
-			  unsigned int qdio_error,
-			  unsigned int siga_error,
-			  unsigned int queue_number,
-			  int first_element,
-			  int elements_processed,
-			  unsigned long int_parm)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_qdio_queue *queue;
-
-	adapter = (struct zfcp_adapter *) int_parm;
-	queue = &adapter->request_queue;
-
-	ZFCP_LOG_DEBUG("adapter %s, first=%d, elements_processed=%d\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       first_element, elements_processed);
-
-	if (unlikely(zfcp_qdio_handler_error_check(adapter, status, qdio_error,
-						   siga_error, first_element,
-						   elements_processed)))
-		goto out;
-	/*
-	 * we stored address of struct zfcp_adapter  data structure
-	 * associated with irq in int_parm
-	 */
 
 	/* cleanup all SBALs being program-owned now */
-	zfcp_qdio_zero_sbals(queue->buffer, first_element, elements_processed);
+	zfcp_qdio_zero_sbals(queue->sbal, first, count);
 
-	/* increase free space in outbound queue */
-	atomic_add(elements_processed, &queue->free_count);
-	ZFCP_LOG_DEBUG("free_count=%d\n", atomic_read(&queue->free_count));
+	atomic_add(count, &queue->count);
 	wake_up(&adapter->request_wq);
-	ZFCP_LOG_DEBUG("elements_processed=%d, free count=%d\n",
-		       elements_processed, atomic_read(&queue->free_count));
- out:
-	return;
 }
 
-/**
- * zfcp_qdio_reqid_check - checks for valid reqids.
- */
 static void zfcp_qdio_reqid_check(struct zfcp_adapter *adapter,
-				  unsigned long req_id, int sbal)
+				  unsigned long req_id, int sbal_idx)
 {
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
@@ -248,204 +99,117 @@ static void zfcp_qdio_reqid_check(struct
 		 * Unknown request means that we have potentially memory
 		 * corruption and must stop the machine immediatly.
 		 */
-		panic("error: unknown request id (%ld) on adapter %s.\n",
+		panic("error: unknown request id (%lx) on adapter %s.\n",
 		      req_id, zfcp_get_busid_by_adapter(adapter));
 
 	zfcp_reqlist_remove(adapter, fsf_req);
-	atomic_dec(&adapter->reqs_active);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	fsf_req->sbal_response = sbal;
-	/* finish the FSF request */
+	fsf_req->sbal_response = sbal_idx;
 	zfcp_fsf_req_complete(fsf_req);
 }
 
-/*
- * function:   	zfcp_qdio_response_handler
- *
- * purpose:	is called by QDIO layer for completed SBALs in response queue
- *
- * returns:	(void)
- */
-static void
-zfcp_qdio_response_handler(struct ccw_device *ccw_device,
-			   unsigned int status,
-			   unsigned int qdio_error,
-			   unsigned int siga_error,
-			   unsigned int queue_number,
-			   int first_element,
-			   int elements_processed,
-			   unsigned long int_parm)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_qdio_queue *queue;
-	int buffer_index;
-	int i;
-	struct qdio_buffer *buffer;
-	int retval = 0;
-	u8 count;
-	u8 start;
-	volatile struct qdio_buffer_element *buffere = NULL;
-	int buffere_index;
-
-	adapter = (struct zfcp_adapter *) int_parm;
-	queue = &adapter->response_queue;
-
-	if (unlikely(zfcp_qdio_handler_error_check(adapter, status, qdio_error,
-						   siga_error, first_element,
-						   elements_processed)))
-		goto out;
+static void zfcp_qdio_resp_put_back(struct zfcp_adapter *adapter, int processed)
+{
+	struct zfcp_qdio_queue *queue = &adapter->resp_q;
+	struct ccw_device *cdev = adapter->ccw_device;
+	u8 count, start = queue->first;
+	unsigned int retval;
 
-	/*
-	 * we stored address of struct zfcp_adapter  data structure
-	 * associated with irq in int_parm
-	 */
+	count = atomic_read(&queue->count) + processed;
+
+	retval = do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT | QDIO_FLAG_UNDER_INTERRUPT,
+			 0, start, count, NULL);
+
+	if (unlikely(retval)) {
+		atomic_set(&queue->count, count);
+		/* FIXME: Recover this with an adapter reopen? */
+	} else {
+		queue->first += count;
+		queue->first %= QDIO_MAX_BUFFERS_PER_Q;
+		atomic_set(&queue->count, 0);
+	}
+}
+
+static void zfcp_qdio_int_resp(struct ccw_device *cdev, unsigned int status,
+			       unsigned int qdio_err, unsigned int siga_err,
+			       unsigned int queue_no, int first, int count,
+			       unsigned long parm)
+{
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) parm;
+	struct zfcp_qdio_queue *queue = &adapter->resp_q;
+	volatile struct qdio_buffer_element *sbale;
+	int sbal_idx, sbale_idx, sbal_no;
+
+	if (unlikely(status & QDIO_STATUS_LOOK_FOR_ERROR)) {
+		zfcp_hba_dbf_event_qdio(adapter, status, qdio_err, siga_err,
+					first, count);
+		zfcp_qdio_handler_error(adapter, 147);
+		return;
+	}
 
-	buffere = &(queue->buffer[first_element]->element[0]);
-	ZFCP_LOG_DEBUG("first BUFFERE flags=0x%x\n", buffere->flags);
 	/*
 	 * go through all SBALs from input queue currently
 	 * returned by QDIO layer
 	 */
-
-	for (i = 0; i < elements_processed; i++) {
-
-		buffer_index = first_element + i;
-		buffer_index %= QDIO_MAX_BUFFERS_PER_Q;
-		buffer = queue->buffer[buffer_index];
+	for (sbal_no = 0; sbal_no < count; sbal_no++) {
+		sbal_idx = (first + sbal_no) % QDIO_MAX_BUFFERS_PER_Q;
 
 		/* go through all SBALEs of SBAL */
-		for (buffere_index = 0;
-		     buffere_index < QDIO_MAX_ELEMENTS_PER_BUFFER;
-		     buffere_index++) {
-
-			/* look for QDIO request identifiers in SB */
-			buffere = &buffer->element[buffere_index];
+		for (sbale_idx = 0; sbale_idx < QDIO_MAX_ELEMENTS_PER_BUFFER;
+		     sbale_idx++) {
+			sbale = zfcp_qdio_sbale(queue, sbal_idx, sbale_idx);
 			zfcp_qdio_reqid_check(adapter,
-					      (unsigned long) buffere->addr, i);
-
-			/*
-			 * A single used SBALE per inbound SBALE has been
-			 * implemented by QDIO so far. Hope they will
-			 * do some optimisation. Will need to change to
-			 * unlikely() then.
-			 */
-			if (likely(buffere->flags & SBAL_FLAGS_LAST_ENTRY))
+					      (unsigned long) sbale->addr,
+					      sbal_idx);
+			if (likely(sbale->flags & SBAL_FLAGS_LAST_ENTRY))
 				break;
 		};
 
-		if (unlikely(!(buffere->flags & SBAL_FLAGS_LAST_ENTRY))) {
-			ZFCP_LOG_NORMAL("bug: End of inbound data "
-					"not marked!\n");
-		}
+		if (unlikely(!(sbale->flags & SBAL_FLAGS_LAST_ENTRY)))
+			dev_warn(&adapter->ccw_device->dev,
+				 "Protocol violation by adapter. "
+				 "Continuing operations.\n");
 	}
 
 	/*
 	 * put range of SBALs back to response queue
 	 * (including SBALs which have already been free before)
 	 */
-	count = atomic_read(&queue->free_count) + elements_processed;
-	start = queue->free_index;
-
-	ZFCP_LOG_TRACE("calling do_QDIO on adapter %s (flags=0x%x, "
-		       "queue_no=%i, index_in_queue=%i, count=%i, "
-		       "buffers=0x%lx\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       QDIO_FLAG_SYNC_INPUT | QDIO_FLAG_UNDER_INTERRUPT,
-		       0, start, count, (unsigned long) &queue->buffer[start]);
-
-	retval = do_QDIO(ccw_device,
-			 QDIO_FLAG_SYNC_INPUT | QDIO_FLAG_UNDER_INTERRUPT,
-			 0, start, count, NULL);
-
-	if (unlikely(retval)) {
-		atomic_set(&queue->free_count, count);
-		ZFCP_LOG_DEBUG("clearing of inbound data regions failed, "
-			       "queues may be down "
-			       "(count=%d, start=%d, retval=%d)\n",
-			       count, start, retval);
-	} else {
-		queue->free_index += count;
-		queue->free_index %= QDIO_MAX_BUFFERS_PER_Q;
-		atomic_set(&queue->free_count, 0);
-		ZFCP_LOG_TRACE("%i buffers enqueued to response "
-			       "queue at position %i\n", count, start);
-	}
- out:
-	return;
-}
-
-/**
- * zfcp_qdio_sbale_get - return pointer to SBALE of qdio_queue
- * @queue: queue from which SBALE should be returned
- * @sbal: specifies number of SBAL in queue
- * @sbale: specifes number of SBALE in SBAL
- */
-static inline volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_get(struct zfcp_qdio_queue *queue, int sbal, int sbale)
-{
-	return &queue->buffer[sbal]->element[sbale];
+	zfcp_qdio_resp_put_back(adapter, count);
 }
 
 /**
- * zfcp_qdio_sbale_req - return pointer to SBALE of request_queue for
- *	a struct zfcp_fsf_req
+ * zfcp_qdio_sbale_req - return ptr to SBALE of req_q for a struct zfcp_fsf_req
+ * @fsf_req: pointer to struct fsf_req
+ * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
 volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_req(struct zfcp_fsf_req *fsf_req, int sbal, int sbale)
-{
-	return zfcp_qdio_sbale_get(&fsf_req->adapter->request_queue,
-				   sbal, sbale);
-}
-
-/**
- * zfcp_qdio_sbale_resp - return pointer to SBALE of response_queue for
- *	a struct zfcp_fsf_req
- */
-static inline volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_resp(struct zfcp_fsf_req *fsf_req, int sbal, int sbale)
+zfcp_qdio_sbale_req(struct zfcp_fsf_req *req)
 {
-	return zfcp_qdio_sbale_get(&fsf_req->adapter->response_queue,
-				   sbal, sbale);
+	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last, 0);
 }
 
 /**
- * zfcp_qdio_sbale_curr - return current SBALE on request_queue for
- *	a struct zfcp_fsf_req
+ * zfcp_qdio_sbale_curr - return curr SBALE on req_q for a struct zfcp_fsf_req
+ * @fsf_req: pointer to struct fsf_req
+ * Returns: pointer to qdio_buffer_element (SBALE) structure
  */
 volatile struct qdio_buffer_element *
-zfcp_qdio_sbale_curr(struct zfcp_fsf_req *fsf_req)
+zfcp_qdio_sbale_curr(struct zfcp_fsf_req *req)
 {
-	return zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last,
-				   fsf_req->sbale_curr);
+	return zfcp_qdio_sbale(&req->adapter->req_q, req->sbal_last,
+			       req->sbale_curr);
 }
 
-/**
- * zfcp_qdio_sbal_limit - determine maximum number of SBALs that can be used
- *	on the request_queue for a struct zfcp_fsf_req
- * @fsf_req: the number of the last SBAL that can be used is stored herein
- * @max_sbals: used to pass an upper limit for the number of SBALs
- *
- * Note: We can assume at least one free SBAL in the request_queue when called.
- */
-static void
-zfcp_qdio_sbal_limit(struct zfcp_fsf_req *fsf_req, int max_sbals)
+static void zfcp_qdio_sbal_limit(struct zfcp_fsf_req *fsf_req, int max_sbals)
 {
-	int count = atomic_read(&fsf_req->adapter->request_queue.free_count);
+	int count = atomic_read(&fsf_req->adapter->req_q.count);
 	count = min(count, max_sbals);
-	fsf_req->sbal_limit  = fsf_req->sbal_first;
-	fsf_req->sbal_limit += (count - 1);
-	fsf_req->sbal_limit %= QDIO_MAX_BUFFERS_PER_Q;
+	fsf_req->sbal_limit = (fsf_req->sbal_first + count - 1)
+					% QDIO_MAX_BUFFERS_PER_Q;
 }
 
-/**
- * zfcp_qdio_sbal_chain - chain SBALs if more than one SBAL is needed for a
- *	request
- * @fsf_req: zfcp_fsf_req to be processed
- * @sbtype: SBAL flags which have to be set in first SBALE of new SBAL
- *
- * This function changes sbal_last, sbale_curr, sbal_number of fsf_req.
- */
 static volatile struct qdio_buffer_element *
 zfcp_qdio_sbal_chain(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
 {
@@ -460,7 +224,7 @@ zfcp_qdio_sbal_chain(struct zfcp_fsf_req
 		return NULL;
 
 	/* set chaining flag in first SBALE of current SBAL */
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale->flags |= SBAL_FLAGS0_MORE_SBALS;
 
 	/* calculate index of next SBAL */
@@ -480,214 +244,271 @@ zfcp_qdio_sbal_chain(struct zfcp_fsf_req
 	return sbale;
 }
 
-/**
- * zfcp_qdio_sbale_next - switch to next SBALE, chain SBALs if needed
- */
 static volatile struct qdio_buffer_element *
 zfcp_qdio_sbale_next(struct zfcp_fsf_req *fsf_req, unsigned long sbtype)
 {
 	if (fsf_req->sbale_curr == ZFCP_LAST_SBALE_PER_SBAL)
 		return zfcp_qdio_sbal_chain(fsf_req, sbtype);
-
 	fsf_req->sbale_curr++;
-
 	return zfcp_qdio_sbale_curr(fsf_req);
 }
 
-/**
- * zfcp_qdio_sbals_zero - initialize SBALs between first and last in queue
- *	with zero from
- */
-static int
-zfcp_qdio_sbals_zero(struct zfcp_qdio_queue *queue, int first, int last)
+static void zfcp_qdio_undo_sbals(struct zfcp_fsf_req *fsf_req)
 {
-	struct qdio_buffer **buf = queue->buffer;
-	int curr = first;
-	int count = 0;
-
-	for(;;) {
-		curr %= QDIO_MAX_BUFFERS_PER_Q;
-		count++;
-		memset(buf[curr], 0, sizeof(struct qdio_buffer));
-		if (curr == last)
-			break;
-		curr++;
-	}
-	return count;
+	struct qdio_buffer **sbal = fsf_req->adapter->req_q.sbal;
+	int first = fsf_req->sbal_first;
+	int last = fsf_req->sbal_last;
+	int count = (last - first + QDIO_MAX_BUFFERS_PER_Q) %
+		QDIO_MAX_BUFFERS_PER_Q + 1;
+	zfcp_qdio_zero_sbals(sbal, first, count);
 }
 
-
-/**
- * zfcp_qdio_sbals_wipe - reset all changes in SBALs for an fsf_req
- */
-static inline int
-zfcp_qdio_sbals_wipe(struct zfcp_fsf_req *fsf_req)
-{
-	return zfcp_qdio_sbals_zero(&fsf_req->adapter->request_queue,
-				    fsf_req->sbal_first, fsf_req->sbal_last);
-}
-
-
-/**
- * zfcp_qdio_sbale_fill - set address and length in current SBALE
- *	on request_queue
- */
-static void
-zfcp_qdio_sbale_fill(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
-		     void *addr, int length)
+static int zfcp_qdio_fill_sbals(struct zfcp_fsf_req *fsf_req,
+				unsigned int sbtype, void *start_addr,
+				unsigned int total_length)
 {
 	volatile struct qdio_buffer_element *sbale;
-
-	sbale = zfcp_qdio_sbale_curr(fsf_req);
-	sbale->addr = addr;
-	sbale->length = length;
-}
-
-/**
- * zfcp_qdio_sbals_from_segment - map memory segment to SBALE(s)
- * @fsf_req: request to be processed
- * @sbtype: SBALE flags
- * @start_addr: address of memory segment
- * @total_length: length of memory segment
- *
- * Alignment and length of the segment determine how many SBALEs are needed
- * for the memory segment.
- */
-static int
-zfcp_qdio_sbals_from_segment(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
-			     void *start_addr, unsigned long total_length)
-{
 	unsigned long remaining, length;
 	void *addr;
 
-	/* split segment up heeding page boundaries */
+	/* split segment up */
 	for (addr = start_addr, remaining = total_length; remaining > 0;
 	     addr += length, remaining -= length) {
-		/* get next free SBALE for new piece */
-		if (NULL == zfcp_qdio_sbale_next(fsf_req, sbtype)) {
-			/* no SBALE left, clean up and leave */
-			zfcp_qdio_sbals_wipe(fsf_req);
+		sbale = zfcp_qdio_sbale_next(fsf_req, sbtype);
+		if (!sbale) {
+			zfcp_qdio_undo_sbals(fsf_req);
 			return -EINVAL;
 		}
-		/* calculate length of new piece */
+
+		/* new piece must not exceed next page boundary */
 		length = min(remaining,
-			     (PAGE_SIZE - ((unsigned long) addr &
+			     (PAGE_SIZE - ((unsigned long)addr &
 					   (PAGE_SIZE - 1))));
-		/* fill current SBALE with calculated piece */
-		zfcp_qdio_sbale_fill(fsf_req, sbtype, addr, length);
+		sbale->addr = addr;
+		sbale->length = length;
 	}
-	return total_length;
+	return 0;
 }
 
-
 /**
  * zfcp_qdio_sbals_from_sg - fill SBALs from scatter-gather list
  * @fsf_req: request to be processed
  * @sbtype: SBALE flags
  * @sg: scatter-gather list
- * @sg_count: number of elements in scatter-gather list
  * @max_sbals: upper bound for number of SBALs to be used
+ * Returns: number of bytes, or error (negativ)
  */
-int
-zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
-                        struct scatterlist *sgl, int sg_count, int max_sbals)
-{
-	int sg_index;
-	struct scatterlist *sg_segment;
-	int retval;
+int zfcp_qdio_sbals_from_sg(struct zfcp_fsf_req *fsf_req, unsigned long sbtype,
+			    struct scatterlist *sg, int max_sbals)
+{
 	volatile struct qdio_buffer_element *sbale;
-	int bytes = 0;
+	int retval, bytes = 0;
 
 	/* figure out last allowed SBAL */
 	zfcp_qdio_sbal_limit(fsf_req, max_sbals);
 
-	/* set storage-block type for current SBAL */
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	/* set storage-block type for this request */
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale->flags |= sbtype;
 
-	/* process all segements of scatter-gather list */
-	for_each_sg(sgl, sg_segment, sg_count, sg_index) {
-		retval = zfcp_qdio_sbals_from_segment(
-				fsf_req,
-				sbtype,
-				zfcp_sg_to_address(sg_segment),
-				sg_segment->length);
-		if (retval < 0) {
-			bytes = retval;
-			goto out;
-		} else
-                        bytes += retval;
+	for (; sg; sg = sg_next(sg)) {
+		retval = zfcp_qdio_fill_sbals(fsf_req, sbtype, sg_virt(sg),
+					      sg->length);
+		if (retval < 0)
+			return retval;
+		bytes += sg->length;
 	}
+
 	/* assume that no other SBALEs are to follow in the same SBAL */
 	sbale = zfcp_qdio_sbale_curr(fsf_req);
 	sbale->flags |= SBAL_FLAGS_LAST_ENTRY;
-out:
+
 	return bytes;
 }
 
+/**
+ * zfcp_qdio_send - set PCI flag in first SBALE and send req to QDIO
+ * @fsf_req: pointer to struct zfcp_fsf_req
+ * Returns: 0 on success, error otherwise
+ */
+int zfcp_qdio_send(struct zfcp_fsf_req *fsf_req)
+{
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	int first = fsf_req->sbal_first;
+	int count = fsf_req->sbal_number;
+	int retval, pci, pci_batch;
+	volatile struct qdio_buffer_element *sbale;
+
+	/* acknowledgements for transferred buffers */
+	pci_batch = req_q->pci_batch + count;
+	if (unlikely(pci_batch >= ZFCP_QDIO_PCI_INTERVAL)) {
+		pci_batch %= ZFCP_QDIO_PCI_INTERVAL;
+		pci = first + count - (pci_batch + 1);
+		pci %= QDIO_MAX_BUFFERS_PER_Q;
+		sbale = zfcp_qdio_sbale(req_q, pci, 0);
+		sbale->flags |= SBAL_FLAGS0_PCI;
+	}
+
+	retval = do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_OUTPUT, 0, first,
+			 count, NULL);
+	if (unlikely(retval)) {
+		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
+		return retval;
+	}
+
+	/* account for transferred buffers */
+	atomic_sub(count, &req_q->count);
+	req_q->first += count;
+	req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
+	req_q->pci_batch = pci_batch;
+	return 0;
+}
 
 /**
- * zfcp_qdio_sbals_from_scsicmnd - fill SBALs from scsi command
- * @fsf_req: request to be processed
- * @sbtype: SBALE flags
- * @scsi_cmnd: either scatter-gather list or buffer contained herein is used
- *	to fill SBALs
- */
-int
-zfcp_qdio_sbals_from_scsicmnd(struct zfcp_fsf_req *fsf_req,
-			      unsigned long sbtype, struct scsi_cmnd *scsi_cmnd)
-{
-	return zfcp_qdio_sbals_from_sg(fsf_req,	sbtype, scsi_sglist(scsi_cmnd),
-				       scsi_sg_count(scsi_cmnd),
-				       ZFCP_MAX_SBALS_PER_REQ);
+ * zfcp_qdio_zero_sbals - zero all sbals of the specified area and queue
+ * @buf: pointer to array of SBALS
+ * @first: integer specifying the SBAL number to start
+ * @count: integer specifying the number of SBALS to process
+ */
+void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int count)
+{
+	int i, sbal_idx;
+
+	for (i = first; i < first + count; i++) {
+		sbal_idx = i % QDIO_MAX_BUFFERS_PER_Q;
+		memset(sbal[sbal_idx], 0, sizeof(struct qdio_buffer));
+	}
 }
 
 /**
- * zfcp_qdio_determine_pci - set PCI flag in first SBALE on qdio queue if needed
+ * zfcp_qdio_allocate - allocate queue memory and initialize QDIO data
+ * @adapter: pointer to struct zfcp_adapter
+ * Returns: -ENOMEM on memory allocation error or return value from
+ *          qdio_allocate
  */
-int
-zfcp_qdio_determine_pci(struct zfcp_qdio_queue *req_queue,
-			struct zfcp_fsf_req *fsf_req)
+int zfcp_qdio_allocate(struct zfcp_adapter *adapter)
 {
-	int new_distance_from_int;
-	int pci_pos;
-	volatile struct qdio_buffer_element *sbale;
+	struct qdio_initialize *init_data;
 
-	new_distance_from_int = req_queue->distance_from_int +
-                fsf_req->sbal_number;
+	if (zfcp_qdio_buffers_enqueue(adapter->req_q.sbal) ||
+		   zfcp_qdio_buffers_enqueue(adapter->resp_q.sbal))
+		return -ENOMEM;
 
-	if (unlikely(new_distance_from_int >= ZFCP_QDIO_PCI_INTERVAL)) {
-		new_distance_from_int %= ZFCP_QDIO_PCI_INTERVAL;
-                pci_pos  = fsf_req->sbal_first;
-		pci_pos += fsf_req->sbal_number;
-		pci_pos -= new_distance_from_int;
-		pci_pos -= 1;
-		pci_pos %= QDIO_MAX_BUFFERS_PER_Q;
-		sbale = zfcp_qdio_sbale_req(fsf_req, pci_pos, 0);
-		sbale->flags |= SBAL_FLAGS0_PCI;
-	}
-	return new_distance_from_int;
+	init_data = &adapter->qdio_init_data;
+
+	init_data->cdev = adapter->ccw_device;
+	init_data->q_format = QDIO_ZFCP_QFMT;
+	memcpy(init_data->adapter_name, zfcp_get_busid_by_adapter(adapter), 8);
+	ASCEBC(init_data->adapter_name, 8);
+	init_data->qib_param_field_format = 0;
+	init_data->qib_param_field = NULL;
+	init_data->input_slib_elements = NULL;
+	init_data->output_slib_elements = NULL;
+	init_data->min_input_threshold = 1;
+	init_data->max_input_threshold = 5000;
+	init_data->min_output_threshold = 1;
+	init_data->max_output_threshold = 1000;
+	init_data->no_input_qs = 1;
+	init_data->no_output_qs = 1;
+	init_data->input_handler = zfcp_qdio_int_resp;
+	init_data->output_handler = zfcp_qdio_int_req;
+	init_data->int_parm = (unsigned long) adapter;
+	init_data->flags = QDIO_INBOUND_0COPY_SBALS |
+			QDIO_OUTBOUND_0COPY_SBALS | QDIO_USE_OUTBOUND_PCIS;
+	init_data->input_sbal_addr_array =
+			(void **) (adapter->resp_q.sbal);
+	init_data->output_sbal_addr_array =
+			(void **) (adapter->req_q.sbal);
+
+	return qdio_allocate(init_data);
 }
 
-/*
- * function:	zfcp_zero_sbals
- *
- * purpose:	zeros specified range of SBALs
- *
- * returns:
+/**
+ * zfcp_close_qdio - close qdio queues for an adapter
  */
-void
-zfcp_qdio_zero_sbals(struct qdio_buffer *buf[], int first, int clean_count)
+void zfcp_qdio_close(struct zfcp_adapter *adapter)
 {
-	int cur_pos;
-	int index;
+	struct zfcp_qdio_queue *req_q;
+	int first, count;
 
-	for (cur_pos = first; cur_pos < (first + clean_count); cur_pos++) {
-		index = cur_pos % QDIO_MAX_BUFFERS_PER_Q;
-		memset(buf[index], 0, sizeof (struct qdio_buffer));
-		ZFCP_LOG_TRACE("zeroing BUFFER %d at address %p\n",
-			       index, buf[index]);
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
+		return;
+
+	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
+	req_q = &adapter->req_q;
+	write_lock_irq(&req_q->lock);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
+	write_unlock_irq(&req_q->lock);
+
+	while (qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR)
+			== -EINPROGRESS)
+		ssleep(1);
+
+	/* cleanup used outbound sbals */
+	count = atomic_read(&req_q->count);
+	if (count < QDIO_MAX_BUFFERS_PER_Q) {
+		first = (req_q->first + count) % QDIO_MAX_BUFFERS_PER_Q;
+		count = QDIO_MAX_BUFFERS_PER_Q - count;
+		zfcp_qdio_zero_sbals(req_q->sbal, first, count);
 	}
+	req_q->first = 0;
+	atomic_set(&req_q->count, 0);
+	req_q->pci_batch = 0;
+	adapter->resp_q.first = 0;
+	atomic_set(&adapter->resp_q.count, 0);
 }
 
-#undef ZFCP_LOG_AREA
+/**
+ * zfcp_qdio_open - prepare and initialize response queue
+ * @adapter: pointer to struct zfcp_adapter
+ * Returns: 0 on success, otherwise -EIO
+ */
+int zfcp_qdio_open(struct zfcp_adapter *adapter)
+{
+	volatile struct qdio_buffer_element *sbale;
+	int cc;
+
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
+		return -EIO;
+
+	if (qdio_establish(&adapter->qdio_init_data)) {
+		dev_err(&adapter->ccw_device->dev,
+			 "Establish of QDIO queues failed.\n");
+		return -EIO;
+	}
+
+	if (qdio_activate(adapter->ccw_device, 0)) {
+		dev_err(&adapter->ccw_device->dev,
+			 "Activate of QDIO queues failed.\n");
+		goto failed_qdio;
+	}
+
+	for (cc = 0; cc < QDIO_MAX_BUFFERS_PER_Q; cc++) {
+		sbale = &(adapter->resp_q.sbal[cc]->element[0]);
+		sbale->length = 0;
+		sbale->flags = SBAL_FLAGS_LAST_ENTRY;
+		sbale->addr = NULL;
+	}
+
+	if (do_QDIO(adapter->ccw_device, QDIO_FLAG_SYNC_INPUT, 0, 0,
+		     QDIO_MAX_BUFFERS_PER_Q, NULL)) {
+		dev_err(&adapter->ccw_device->dev,
+			 "Init of QDIO response queue failed.\n");
+		goto failed_qdio;
+	}
+
+	/* set index of first avalable SBALS / number of available SBALS */
+	adapter->req_q.first = 0;
+	atomic_set(&adapter->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
+	adapter->req_q.pci_batch = 0;
+
+	return 0;
+
+failed_qdio:
+	while (qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR)
+			== -EINPROGRESS)
+		ssleep(1);
+
+	return -EIO;
+}
--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-10 17:37:48.000000000 +0200
@@ -606,7 +606,6 @@ static void _zfcp_status_read_scheduler(
 struct zfcp_adapter *
 zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 {
-	int retval = 0;
 	struct zfcp_adapter *adapter;
 
 	/*
@@ -627,19 +626,11 @@ zfcp_adapter_enqueue(struct ccw_device *
 	/* save ccw_device pointer */
 	adapter->ccw_device = ccw_device;
 
-	retval = zfcp_qdio_allocate_queues(adapter);
-	if (retval)
-		goto queues_alloc_failed;
-
-	retval = zfcp_qdio_allocate(adapter);
-	if (retval)
+	if (zfcp_qdio_allocate(adapter))
 		goto qdio_allocate_failed;
 
-	retval = zfcp_allocate_low_mem_buffers(adapter);
-	if (retval) {
-		ZFCP_LOG_INFO("error: pool allocation failed\n");
+	if (zfcp_allocate_low_mem_buffers(adapter))
 		goto failed_low_mem_buffers;
-	}
 
 	/* initialise reference count stuff */
 	atomic_set(&adapter->refcount, 0);
@@ -653,11 +644,8 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	/* initialize list of fsf requests */
 	spin_lock_init(&adapter->req_list_lock);
-	retval = zfcp_reqlist_alloc(adapter);
-	if (retval) {
-		ZFCP_LOG_INFO("request list initialization failed\n");
+	if (zfcp_reqlist_alloc(adapter))
 		goto failed_low_mem_buffers;
-	}
 
 	/* initialize debug locks */
 
@@ -666,8 +654,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	spin_lock_init(&adapter->scsi_dbf_lock);
 	spin_lock_init(&adapter->rec_dbf_lock);
 
-	retval = zfcp_adapter_debug_register(adapter);
-	if (retval)
+	if (zfcp_adapter_debug_register(adapter))
 		goto debug_register_failed;
 
 	/* initialize error recovery stuff */
@@ -685,7 +672,7 @@ zfcp_adapter_enqueue(struct ccw_device *
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
 	/* initialize lock of associated request queue */
-	rwlock_init(&adapter->request_queue.queue_lock);
+	rwlock_init(&adapter->req_q.lock);
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 
 	/* mark adapter unusable as long as sysfs registration is not complete */
@@ -723,12 +710,8 @@ zfcp_adapter_enqueue(struct ccw_device *
 	zfcp_reqlist_free(adapter);
  failed_low_mem_buffers:
 	zfcp_free_low_mem_buffers(adapter);
-	if (qdio_free(ccw_device) != 0)
-		ZFCP_LOG_NORMAL("bug: qdio_free for adapter %s failed\n",
-				zfcp_get_busid_by_adapter(adapter));
  qdio_allocate_failed:
-	zfcp_qdio_free_queues(adapter);
- queues_alloc_failed:
+	zfcp_qdio_free(adapter);
 	kfree(adapter);
 	adapter = NULL;
  out:
@@ -757,10 +740,6 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	retval = zfcp_reqlist_isempty(adapter);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 	if (!retval) {
-		ZFCP_LOG_NORMAL("bug: adapter %s (%p) still in use, "
-				"%i requests outstanding\n",
-				zfcp_get_busid_by_adapter(adapter), adapter,
-				atomic_read(&adapter->reqs_active));
 		retval = -EBUSY;
 		goto out;
 	}
@@ -775,19 +754,9 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	/* decrease number of adapters in list */
 	zfcp_data.adapters--;
 
-	ZFCP_LOG_TRACE("adapter %s (%p) removed from list, "
-		       "%i adapters still in list\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       adapter, zfcp_data.adapters);
-
-	retval = qdio_free(adapter->ccw_device);
-	if (retval)
-		ZFCP_LOG_NORMAL("bug: qdio_free for adapter %s failed\n",
-				zfcp_get_busid_by_adapter(adapter));
+	zfcp_qdio_free(adapter);
 
 	zfcp_free_low_mem_buffers(adapter);
-	/* free memory of adapter data structure and queues */
-	zfcp_qdio_free_queues(adapter);
 	zfcp_reqlist_free(adapter);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-10 17:37:48.000000000 +0200
@@ -57,21 +57,17 @@ extern int  zfcp_ccw_register(void);
 
 extern void zfcp_qdio_zero_sbals(struct qdio_buffer **, int, int);
 extern int  zfcp_qdio_allocate(struct zfcp_adapter *);
-extern int  zfcp_qdio_allocate_queues(struct zfcp_adapter *);
-extern void zfcp_qdio_free_queues(struct zfcp_adapter *);
-extern int  zfcp_qdio_determine_pci(struct zfcp_qdio_queue *,
-				    struct zfcp_fsf_req *);
+extern void zfcp_qdio_free(struct zfcp_adapter *);
+extern int  zfcp_qdio_send(struct zfcp_fsf_req *fsf_req);
 
 extern volatile struct qdio_buffer_element *zfcp_qdio_sbale_req
-	(struct zfcp_fsf_req *, int, int);
+	(struct zfcp_fsf_req *);
 extern volatile struct qdio_buffer_element *zfcp_qdio_sbale_curr
 	(struct zfcp_fsf_req *);
 extern int zfcp_qdio_sbals_from_sg
-	(struct zfcp_fsf_req *, unsigned long, struct scatterlist *, int, int);
-extern int zfcp_qdio_sbals_from_scsicmnd
-	(struct zfcp_fsf_req *, unsigned long, struct scsi_cmnd *);
-
-
+	(struct zfcp_fsf_req *, unsigned long, struct scatterlist *, int);
+extern int zfcp_qdio_open(struct zfcp_adapter *adapter);
+extern void zfcp_qdio_close(struct zfcp_adapter *adapter);
 /******************************** FSF ****************************************/
 extern int  zfcp_fsf_open_port(struct zfcp_erp_action *);
 extern int  zfcp_fsf_close_port(struct zfcp_erp_action *);
@@ -95,7 +91,7 @@ extern int  zfcp_fsf_status_read(struct 
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
 extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
 			       unsigned long *, struct zfcp_fsf_req **)
-	__acquires(adapter->request_queue.queue_lock);
+	__acquires(adapter->req_q.lock);
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-10 17:39:27.000000000 +0200
@@ -112,21 +112,10 @@ zfcp_address_to_sg(void *address, struct
         /* max. number of (data buffer) SBALEs in largest SBAL chain
            multiplied with number of sectors per 4k block */
 
-/* FIXME(tune): free space should be one max. SBAL chain plus what? */
-#define ZFCP_QDIO_PCI_INTERVAL		(QDIO_MAX_BUFFERS_PER_Q \
-                                         - (ZFCP_MAX_SBALS_PER_REQ + 4))
-
 #define ZFCP_SBAL_TIMEOUT               (5*HZ)
 
 #define ZFCP_TYPE2_RECOVERY_TIME        8	/* seconds */
 
-/* queue polling (values in microseconds) */
-#define ZFCP_MAX_INPUT_THRESHOLD 	5000	/* FIXME: tune */
-#define ZFCP_MAX_OUTPUT_THRESHOLD 	1000	/* FIXME: tune */
-#define ZFCP_MIN_INPUT_THRESHOLD 	1	/* ignored by QDIO layer */
-#define ZFCP_MIN_OUTPUT_THRESHOLD 	1	/* ignored by QDIO layer */
-
-#define QDIO_SCSI_QFMT			1	/* 1 for FSF */
 #define QBUFF_PER_PAGE			(PAGE_SIZE / sizeof(struct qdio_buffer))
 
 /********************* FSF SPECIFIC DEFINES *********************************/
@@ -649,13 +638,13 @@ struct zfcp_send_els {
 };
 
 struct zfcp_qdio_queue {
-	struct qdio_buffer *buffer[QDIO_MAX_BUFFERS_PER_Q]; /* SBALs */
-	u8		   free_index;	      /* index of next free bfr
+	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q]; /* SBALs */
+	u8		   first;	      /* index of next free bfr
 						 in queue (free_count>0) */
-	atomic_t           free_count;	      /* number of free buffers
+	atomic_t           count;	      /* number of free buffers
 						 in queue */
-	rwlock_t	   queue_lock;	      /* lock for operations on queue */
-        int                distance_from_int; /* SBALs used since PCI indication
+	rwlock_t	   lock;	      /* lock for operations on queue */
+	int                pci_batch;	      /* SBALs since PCI indication
 						 was last set */
 };
 
@@ -711,15 +700,14 @@ struct zfcp_adapter {
 	struct list_head        port_remove_lh;    /* head of ports to be
 						      removed */
 	u32			ports;	           /* number of remote ports */
-	atomic_t		reqs_active;	   /* # active FSF reqs */
 	unsigned long		req_no;		   /* unique FSF req number */
 	struct list_head	*req_list;	   /* list of pending reqs */
 	spinlock_t		req_list_lock;	   /* request list lock */
-	struct zfcp_qdio_queue	request_queue;	   /* request queue */
+	struct zfcp_qdio_queue	req_q;		   /* request queue */
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	wait_queue_head_t	request_wq;	   /* can be used to wait for
 						      more avaliable SBALs */
-	struct zfcp_qdio_queue	response_queue;	   /* response queue */
+	struct zfcp_qdio_queue	resp_q;	   /* response queue */
 	rwlock_t		abort_lock;        /* Protects against SCSI
 						      stack abort/command
 						      completion races */
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:36:57.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-10 17:41:01.000000000 +0200
@@ -171,7 +171,6 @@ void zfcp_fsf_req_dismiss_all(struct zfc
 
 	BUG_ON(atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status));
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
-	atomic_set(&adapter->reqs_active, 0);
 	for (i = 0; i < REQUEST_LIST_SIZE; i++)
 		list_splice_init(&adapter->req_list[i], &remove_queue);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
@@ -726,7 +725,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
 		goto failed_req_create;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
         sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
         fsf_req->sbale_curr = 2;
@@ -763,7 +762,7 @@ zfcp_fsf_status_read(struct zfcp_adapter
  failed_req_create:
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
  out:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -1075,7 +1074,7 @@ zfcp_fsf_abort_fcp_command(unsigned long
 			&unit->status)))
 		goto unit_blocked;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1098,7 +1097,7 @@ zfcp_fsf_abort_fcp_command(unsigned long
 		fsf_req = NULL;
 
  out:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return fsf_req;
 }
 
@@ -1295,7 +1294,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
 		goto failed_req;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         if (zfcp_use_one_sbal(ct->req, ct->req_count,
                               ct->resp, ct->resp_count)){
                 /* both request buffer and response buffer
@@ -1311,7 +1310,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
                 /* try to use chained SBALs */
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
                                                 SBAL_FLAGS0_TYPE_WRITE_READ,
-                                                ct->req, ct->req_count,
+						ct->req,
                                                 ZFCP_MAX_SBALS_PER_CT_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of CT request failed "
@@ -1328,7 +1327,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
                 fsf_req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
                                                 SBAL_FLAGS0_TYPE_WRITE_READ,
-                                                ct->resp, ct->resp_count,
+						ct->resp,
                                                 ZFCP_MAX_SBALS_PER_CT_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of CT request failed "
@@ -1387,8 +1386,7 @@ zfcp_fsf_send_ct(struct zfcp_send_ct *ct
         }
  failed_req:
  out:
-        write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return ret;
 }
 
@@ -1593,7 +1591,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 		goto port_blocked;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         if (zfcp_use_one_sbal(els->req, els->req_count,
                               els->resp, els->resp_count)){
                 /* both request buffer and response buffer
@@ -1609,7 +1607,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
                 /* try to use chained SBALs */
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
                                                 SBAL_FLAGS0_TYPE_WRITE_READ,
-                                                els->req, els->req_count,
+						els->req,
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of ELS request failed "
@@ -1626,7 +1624,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
                 fsf_req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
                 bytes = zfcp_qdio_sbals_from_sg(fsf_req,
                                                 SBAL_FLAGS0_TYPE_WRITE_READ,
-                                                els->resp, els->resp_count,
+						els->resp,
                                                 ZFCP_MAX_SBALS_PER_ELS_REQ);
                 if (bytes <= 0) {
                         ZFCP_LOG_INFO("error: creation of ELS request failed "
@@ -1657,7 +1655,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
 	fsf_req->data = (unsigned long) els;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 
 	zfcp_san_dbf_event_els_request(fsf_req);
 
@@ -1680,8 +1678,7 @@ zfcp_fsf_send_els(struct zfcp_send_els *
 
  failed_req:
  out:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
         return ret;
 }
@@ -1863,12 +1860,11 @@ zfcp_fsf_exchange_config_data(struct zfc
 		ZFCP_LOG_INFO("error: Could not create exchange configuration "
 			      "data request for adapter %s.\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-					lock_flags);
+		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1882,8 +1878,7 @@ zfcp_fsf_exchange_config_data(struct zfc
 
 	zfcp_erp_start_timer(fsf_req);
 	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send exchange configuration "
 			      "data command on the adapter %s\n",
@@ -1916,12 +1911,11 @@ zfcp_fsf_exchange_config_data_sync(struc
 		ZFCP_LOG_INFO("error: Could not create exchange configuration "
 			      "data request for adapter %s.\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-					lock_flags);
+		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -1936,8 +1930,7 @@ zfcp_fsf_exchange_config_data_sync(struc
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	if (retval)
 		ZFCP_LOG_INFO("error: Could not send exchange configuration "
 			      "data command on the adapter %s\n",
@@ -2178,12 +2171,11 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 			      "exchange port data request for "
 			      "the adapter %s.\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-					lock_flags);
+		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2192,7 +2184,7 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 	zfcp_erp_start_timer(fsf_req);
 
 	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not send an exchange port data "
@@ -2237,21 +2229,20 @@ zfcp_fsf_exchange_port_data_sync(struct 
 			      "exchange port data request for "
 			      "the adapter %s.\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-					lock_flags);
+		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 		return retval;
 	}
 
 	if (data)
 		fsf_req->data = (unsigned long) data;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
 	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
 	if (retval)
 		ZFCP_LOG_INFO("error: Could not send an exchange port data "
@@ -2355,7 +2346,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2382,8 +2373,7 @@ zfcp_fsf_open_port(struct zfcp_erp_actio
 		       zfcp_get_busid_by_adapter(erp_action->adapter),
 		       erp_action->port->wwpn);
  out:
-	write_unlock_irqrestore(&erp_action->adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -2587,7 +2577,7 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2615,8 +2605,7 @@ zfcp_fsf_close_port(struct zfcp_erp_acti
 		       zfcp_get_busid_by_adapter(erp_action->adapter),
 		       erp_action->port->wwpn);
  out:
-	write_unlock_irqrestore(&erp_action->adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -2716,7 +2705,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2746,8 +2735,7 @@ zfcp_fsf_close_physical_port(struct zfcp
 		       zfcp_get_busid_by_adapter(erp_action->adapter),
 		       erp_action->port->wwpn);
  out:
-	write_unlock_irqrestore(&erp_action->adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -2911,7 +2899,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -2944,8 +2932,7 @@ zfcp_fsf_open_unit(struct zfcp_erp_actio
 		       zfcp_get_busid_by_adapter(erp_action->adapter),
 		       erp_action->port->wwpn, erp_action->unit->fcp_lun);
  out:
-	write_unlock_irqrestore(&erp_action->adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -3226,7 +3213,7 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -3255,8 +3242,7 @@ zfcp_fsf_close_unit(struct zfcp_erp_acti
 		       zfcp_get_busid_by_adapter(erp_action->adapter),
 		       erp_action->port->wwpn, erp_action->unit->fcp_lun);
  out:
-	write_unlock_irqrestore(&erp_action->adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -3498,7 +3484,9 @@ zfcp_fsf_send_fcp_command_task(struct zf
 		fcp_cmnd_iu->add_fcp_cdb_length + sizeof (fcp_dl_t);
 
 	/* generate SBALEs from data buffer */
-	real_bytes = zfcp_qdio_sbals_from_scsicmnd(fsf_req, sbtype, scsi_cmnd);
+	real_bytes = zfcp_qdio_sbals_from_sg(fsf_req, sbtype,
+					     scsi_sglist(scsi_cmnd),
+					     ZFCP_MAX_SBALS_PER_REQ);
 	if (unlikely(real_bytes < 0)) {
 		if (fsf_req->sbal_number < ZFCP_MAX_SBALS_PER_REQ) {
 			ZFCP_LOG_DEBUG(
@@ -3556,7 +3544,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
 	scsi_cmnd->host_scribble = NULL;
  success:
  failed_req_create:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
@@ -3609,7 +3597,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	fsf_req->qtcb->bottom.io.fcp_cmnd_length =
 		sizeof (struct fcp_cmnd_iu) + sizeof (fcp_dl_t);
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
@@ -3629,7 +3617,7 @@ zfcp_fsf_send_fcp_command_task_managemen
 	fsf_req = NULL;
 
  out:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return fsf_req;
 }
 
@@ -4216,7 +4204,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		goto unlock_queue_lock;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	sbale[0].flags |= direction;
 
 	bottom = &fsf_req->qtcb->bottom.support;
@@ -4224,7 +4212,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	bottom->option = fsf_cfdc->option;
 
 	bytes = zfcp_qdio_sbals_from_sg(fsf_req, direction,
-					fsf_cfdc->sg, ZFCP_CFDC_PAGES,
+					fsf_cfdc->sg,
 					ZFCP_MAX_SBALS_PER_REQ);
 	if (bytes != ZFCP_CFDC_MAX_SIZE) {
 		retval = -ENOMEM;
@@ -4237,7 +4225,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		retval = -EPERM;
 		goto free_fsf_req;
 	}
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 
 	wait_event(fsf_req->completion_wq,
 	           fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -4247,7 +4235,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
  free_fsf_req:
 	zfcp_fsf_req_free(fsf_req);
  unlock_queue_lock:
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
+	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
 	return ERR_PTR(retval);
 }
 
@@ -4261,10 +4249,10 @@ static inline int
 zfcp_fsf_req_sbal_check(unsigned long *flags,
 			struct zfcp_qdio_queue *queue, int needed)
 {
-	write_lock_irqsave(&queue->queue_lock, *flags);
-	if (likely(atomic_read(&queue->free_count) >= needed))
+	write_lock_irqsave(&queue->lock, *flags);
+	if (likely(atomic_read(&queue->count) >= needed))
 		return 1;
-	write_unlock_irqrestore(&queue->queue_lock, *flags);
+	write_unlock_irqrestore(&queue->lock, *flags);
 	return 0;
 }
 
@@ -4293,24 +4281,24 @@ zfcp_fsf_req_qtcb_init(struct zfcp_fsf_r
  * @req_flags: flags indicating whether to wait for needed SBAL or not
  * @lock_flags: lock_flags if queue_lock is taken
  * Return: 0 on success, otherwise -EIO, or -ERESTARTSYS
- * Locks: lock adapter->request_queue->queue_lock on success
+ * Locks: lock adapter->req_q->lock on success
  */
 static int
 zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter, int req_flags,
 		      unsigned long *lock_flags)
 {
         long ret;
-        struct zfcp_qdio_queue *req_queue = &adapter->request_queue;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 
         if (unlikely(req_flags & ZFCP_WAIT_FOR_SBAL)) {
                 ret = wait_event_interruptible_timeout(adapter->request_wq,
-			zfcp_fsf_req_sbal_check(lock_flags, req_queue, 1),
+			zfcp_fsf_req_sbal_check(lock_flags, req_q, 1),
 						       ZFCP_SBAL_TIMEOUT);
 		if (ret < 0)
 			return ret;
 		if (!ret)
 			return -EIO;
-        } else if (!zfcp_fsf_req_sbal_check(lock_flags, req_queue, 1))
+	} else if (!zfcp_fsf_req_sbal_check(lock_flags, req_q, 1))
                 return -EIO;
 
         return 0;
@@ -4340,7 +4328,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	volatile struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int ret = 0;
-	struct zfcp_qdio_queue *req_queue = &adapter->request_queue;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 
 	/* allocate new FSF request */
 	fsf_req = zfcp_fsf_req_alloc(pool, req_flags);
@@ -4377,7 +4365,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	 */
 
 	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status)) {
-		write_unlock_irqrestore(&req_queue->queue_lock, *lock_flags);
+		write_unlock_irqrestore(&req_q->lock, *lock_flags);
 		ret = -EIO;
 		goto failed_sbals;
 	}
@@ -4387,15 +4375,15 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 		fsf_req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
 	}
 	fsf_req->sbal_number = 1;
-	fsf_req->sbal_first = req_queue->free_index;
-	fsf_req->sbal_last = req_queue->free_index;
+	fsf_req->sbal_first = req_q->first;
+	fsf_req->sbal_last = req_q->first;
         fsf_req->sbale_curr = 1;
 
 	if (likely(req_flags & ZFCP_REQ_AUTO_CLEANUP)) {
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_last, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 
 	/* setup common SBALE fields */
 	sbale[0].addr = (void *) fsf_req->req_id;
@@ -4416,7 +4404,7 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 	fsf_req = NULL;
 
  failed_fsf_req:
-	write_lock_irqsave(&req_queue->queue_lock, *lock_flags);
+	write_lock_irqsave(&req_q->lock, *lock_flags);
  success:
 	*fsf_req_p = fsf_req;
 	return ret;
@@ -4433,18 +4421,17 @@ zfcp_fsf_req_create(struct zfcp_adapter 
 static int zfcp_fsf_req_send(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter;
-	struct zfcp_qdio_queue *req_queue;
+	struct zfcp_qdio_queue *req_q;
 	volatile struct qdio_buffer_element *sbale;
 	int inc_seq_no;
-	int new_distance_from_int;
 	int retval = 0;
 
 	adapter = fsf_req->adapter;
-	req_queue = &adapter->request_queue,
+	req_q = &adapter->req_q;
 
 
 	/* FIXME(debug): remove it later */
-	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_first, 0);
+	sbale = zfcp_qdio_sbale_req(fsf_req);
 	ZFCP_LOG_DEBUG("SBALE0 flags=0x%x\n", sbale[0].flags);
 	ZFCP_LOG_TRACE("HEX DUMP OF SBALE1 PAYLOAD:\n");
 	ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_TRACE, (char *) sbale[1].addr,
@@ -4457,52 +4444,24 @@ static int zfcp_fsf_req_send(struct zfcp
 
 	inc_seq_no = (fsf_req->qtcb != NULL);
 
-	ZFCP_LOG_TRACE("request queue of adapter %s: "
-		       "next free SBAL is %i, %i free SBALs\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       req_queue->free_index,
-		       atomic_read(&req_queue->free_count));
-
-	ZFCP_LOG_DEBUG("calling do_QDIO adapter %s, flags=0x%x, queue_no=%i, "
-		       "index_in_queue=%i, count=%i, buffers=%p\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       QDIO_FLAG_SYNC_OUTPUT,
-		       0, fsf_req->sbal_first, fsf_req->sbal_number,
-		       &req_queue->buffer[fsf_req->sbal_first]);
-
-	/*
-	 * adjust the number of free SBALs in request queue as well as
-	 * position of first one
-	 */
-	atomic_sub(fsf_req->sbal_number, &req_queue->free_count);
-	ZFCP_LOG_TRACE("free_count=%d\n", atomic_read(&req_queue->free_count));
-	req_queue->free_index += fsf_req->sbal_number;	  /* increase */
-	req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q;  /* wrap if needed */
-	new_distance_from_int = zfcp_qdio_determine_pci(req_queue, fsf_req);
-
 	fsf_req->issued = get_clock();
 
-	retval = do_QDIO(adapter->ccw_device,
-			 QDIO_FLAG_SYNC_OUTPUT,
-			 0, fsf_req->sbal_first, fsf_req->sbal_number, NULL);
+	retval = zfcp_qdio_send(fsf_req);
 
 	if (unlikely(retval)) {
 		/* Queues are down..... */
-		retval = -EIO;
 		del_timer(&fsf_req->timer);
 		spin_lock(&adapter->req_list_lock);
 		zfcp_reqlist_remove(adapter, fsf_req);
 		spin_unlock(&adapter->req_list_lock);
 		/* undo changes in request queue made for this request */
-		zfcp_qdio_zero_sbals(req_queue->buffer,
-				     fsf_req->sbal_first, fsf_req->sbal_number);
-		atomic_add(fsf_req->sbal_number, &req_queue->free_count);
-		req_queue->free_index -= fsf_req->sbal_number;
-		req_queue->free_index += QDIO_MAX_BUFFERS_PER_Q;
-		req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
+		atomic_add(fsf_req->sbal_number, &req_q->count);
+		req_q->first -= fsf_req->sbal_number;
+		req_q->first += QDIO_MAX_BUFFERS_PER_Q;
+		req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
 		zfcp_erp_adapter_reopen(adapter, 0, 116, fsf_req);
+		retval = -EIO;
 	} else {
-		req_queue->distance_from_int = new_distance_from_int;
 		/*
 		 * increase FSF sequence counter -
 		 * this must only be done for request successfully enqueued to
@@ -4514,9 +4473,6 @@ static int zfcp_fsf_req_send(struct zfcp
 		/* Don't increase for unsolicited status */
 		if (inc_seq_no)
 			adapter->fsf_req_seq_no++;
-
-		/* count FSF requests pending */
-		atomic_inc(&adapter->reqs_active);
 	}
 	return retval;
 }
--- a/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:35:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-06-10 17:37:48.000000000 +0200
@@ -114,41 +114,6 @@ static void zfcp_erp_action_to_running(s
 static void zfcp_erp_memwait_handler(unsigned long);
 
 /**
- * zfcp_close_qdio - close qdio queues for an adapter
- */
-static void zfcp_close_qdio(struct zfcp_adapter *adapter)
-{
-	struct zfcp_qdio_queue *req_queue;
-	int first, count;
-
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status))
-		return;
-
-	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
-	req_queue = &adapter->request_queue;
-	write_lock_irq(&req_queue->queue_lock);
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	write_unlock_irq(&req_queue->queue_lock);
-
-	while (qdio_shutdown(adapter->ccw_device,
-			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
-		ssleep(1);
-
-	/* cleanup used outbound sbals */
-	count = atomic_read(&req_queue->free_count);
-	if (count < QDIO_MAX_BUFFERS_PER_Q) {
-		first = (req_queue->free_index+count) % QDIO_MAX_BUFFERS_PER_Q;
-		count = QDIO_MAX_BUFFERS_PER_Q - count;
-		zfcp_qdio_zero_sbals(req_queue->buffer, first, count);
-	}
-	req_queue->free_index = 0;
-	atomic_set(&req_queue->free_count, 0);
-	req_queue->distance_from_int = 0;
-	adapter->response_queue.free_index = 0;
-	atomic_set(&adapter->response_queue.free_count, 0);
-}
-
-/**
  * zfcp_close_fsf - stop FSF operations for an adapter
  *
  * Dismiss and cleanup all pending fsf_reqs (this wakes up all initiators of
@@ -158,7 +123,7 @@ static void zfcp_close_qdio(struct zfcp_
 static void zfcp_close_fsf(struct zfcp_adapter *adapter)
 {
 	/* close queues to ensure that buffers are not accessed by adapter */
-	zfcp_close_qdio(adapter);
+	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	/* reset FSF request sequence number */
 	adapter->fsf_req_seq_no = 0;
@@ -1735,88 +1700,17 @@ zfcp_erp_adapter_strategy_generic(struct
 static int
 zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *erp_action)
 {
-	int retval;
-	int i;
-	volatile struct qdio_buffer_element *sbale;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status)) {
-		ZFCP_LOG_NORMAL("bug: second attempt to set up QDIO on "
-				"adapter %s\n",
-				zfcp_get_busid_by_adapter(adapter));
-		goto failed_sanity;
-	}
-
-	if (qdio_establish(&adapter->qdio_init_data) != 0) {
-		ZFCP_LOG_INFO("error: establishment of QDIO queues failed "
-			      "on adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		goto failed_qdio_establish;
-	}
-
-	if (qdio_activate(adapter->ccw_device, 0) != 0) {
-		ZFCP_LOG_INFO("error: activation of QDIO queues failed "
-			      "on adapter %s\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		goto failed_qdio_activate;
-	}
-
-	/*
-	 * put buffers into response queue,
-	 */
-	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
-		sbale = &(adapter->response_queue.buffer[i]->element[0]);
-		sbale->length = 0;
-		sbale->flags = SBAL_FLAGS_LAST_ENTRY;
-		sbale->addr = NULL;
-	}
-
-	ZFCP_LOG_TRACE("calling do_QDIO on adapter %s (flags=0x%x, "
-		       "queue_no=%i, index_in_queue=%i, count=%i)\n",
-		       zfcp_get_busid_by_adapter(adapter),
-		       QDIO_FLAG_SYNC_INPUT, 0, 0, QDIO_MAX_BUFFERS_PER_Q);
-
-	retval = do_QDIO(adapter->ccw_device,
-			 QDIO_FLAG_SYNC_INPUT,
-			 0, 0, QDIO_MAX_BUFFERS_PER_Q, NULL);
-
-	if (retval) {
-		ZFCP_LOG_NORMAL("bug: setup of QDIO failed (retval=%d)\n",
-				retval);
-		goto failed_do_qdio;
-	} else {
-		adapter->response_queue.free_index = 0;
-		atomic_set(&adapter->response_queue.free_count, 0);
-		ZFCP_LOG_DEBUG("%i buffers successfully enqueued to "
-			       "response queue\n", QDIO_MAX_BUFFERS_PER_Q);
-	}
-	/* set index of first avalable SBALS / number of available SBALS */
-	adapter->request_queue.free_index = 0;
-	atomic_set(&adapter->request_queue.free_count, QDIO_MAX_BUFFERS_PER_Q);
-	adapter->request_queue.distance_from_int = 0;
+	if (zfcp_qdio_open(adapter))
+		return ZFCP_ERP_FAILED;
 
 	/* initialize waitqueue used to wait for free SBALs in requests queue */
 	init_waitqueue_head(&adapter->request_wq);
 
 	/* ok, we did it - skip all cleanups for different failures */
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	retval = ZFCP_ERP_SUCCEEDED;
-	goto out;
-
- failed_do_qdio:
-	/* NOP */
-
- failed_qdio_activate:
-	while (qdio_shutdown(adapter->ccw_device,
-			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
-		ssleep(1);
-
- failed_qdio_establish:
- failed_sanity:
-	retval = ZFCP_ERP_FAILED;
-
- out:
-	return retval;
+	return ZFCP_ERP_SUCCEEDED;
 }
 
 
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:35:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-10 17:37:48.000000000 +0200
@@ -603,13 +603,14 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[137]	= "hbaapi port open",
 	[138]	= "hbaapi unit open",
 	[139]	= "hbaapi unit shutdown",
-	[140]	= "qdio error",
+	[140]	= "qdio error outbound",
 	[141]	= "scsi host reset",
 	[142]	= "dismissing fsf request for recovery action",
 	[143]	= "recovery action timed out",
 	[144]	= "recovery action gone",
 	[145]	= "recovery action being processed",
 	[146]	= "recovery action ready for next step",
+	[147]	= "qdio error inbound",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,

-- 
