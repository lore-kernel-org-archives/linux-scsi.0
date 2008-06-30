From: christof.schmitt@de.ibm.com
Subject: [patch 09/11] zfcp: zfcp_fsf cleanup.
Date: Mon, 30 Jun 2008 12:52:45 +0200
Message-ID: <20080630110100.840395000@de.ibm.com>
References: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:56669 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607AbYF3LB5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:01:57 -0400
Content-Disposition: inline; filename=fsf-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Code cleanup for the zfcp_fsf.c file.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    4 
 drivers/s390/scsi/zfcp_dbf.c  |    2 
 drivers/s390/scsi/zfcp_def.h  |   31 
 drivers/s390/scsi/zfcp_ext.h  |   12 
 drivers/s390/scsi/zfcp_fc.c   |   11 
 drivers/s390/scsi/zfcp_fsf.c  | 4137 +++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_fsf.h  |   31 
 drivers/s390/scsi/zfcp_qdio.c |    6 
 drivers/s390/scsi/zfcp_scsi.c |    5 
 9 files changed, 1586 insertions(+), 2653 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:28:20.000000000 +0200
@@ -8,35 +8,6 @@
 
 #include "zfcp_ext.h"
 
-static int zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *);
-static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_open_port_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_close_port_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_open_unit_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_close_unit_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_send_fcp_command_task_management_handler(
-	struct zfcp_fsf_req *);
-static int zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_status_read_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *);
-static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *);
-static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *);
-static inline int zfcp_fsf_req_sbal_check(
-	unsigned long *, struct zfcp_qdio_queue *, int);
-static inline int zfcp_use_one_sbal(
-	struct scatterlist *, int, struct scatterlist *, int);
-static struct zfcp_fsf_req *zfcp_fsf_req_alloc(mempool_t *, int);
-static int zfcp_fsf_req_send(struct zfcp_fsf_req *);
-static int zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *);
-static int zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *);
-static int zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *);
-static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *, u8,
-	struct fsf_link_down_info *);
-static int zfcp_fsf_req_dispatch(struct zfcp_fsf_req *);
-
 /* association between FSF command and FSF QTCB type */
 static u32 fsf_qtcb_type[] = {
 	[FSF_QTCB_FCP_CMND] =             FSF_IO_COMMAND,
@@ -54,21 +25,19 @@ static u32 fsf_qtcb_type[] = {
 	[FSF_QTCB_UPLOAD_CONTROL_FILE] =  FSF_SUPPORT_COMMAND
 };
 
-static const char zfcp_act_subtable_type[5][8] = {
+static const char *zfcp_act_subtable_type[] = {
 	"unknown", "OS", "WWPN", "DID", "LUN"
 };
 
 static void zfcp_act_eval_err(struct zfcp_adapter *adapter, u32 table)
 {
-	u16 subtable = (table & 0xffff0000) >> 16;
+	u16 subtable = table >> 16;
 	u16 rule = table & 0xffff;
 
-	if (subtable > 0 &&
-	    subtable < ARRAY_SIZE(zfcp_act_subtable_type)) {
+	if (subtable && subtable < ARRAY_SIZE(zfcp_act_subtable_type))
 		dev_warn(&adapter->ccw_device->dev,
 			 "Access denied in subtable %s, rule %d.\n",
 			 zfcp_act_subtable_type[subtable], rule);
-	}
 }
 
 static void zfcp_fsf_access_denied_port(struct zfcp_fsf_req *req,
@@ -106,90 +75,27 @@ static void zfcp_fsf_class_not_supp(stru
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
-/****************************************************************/
-/*************** FSF related Functions  *************************/
-/****************************************************************/
-
-/*
- * function:	zfcp_fsf_req_alloc
- *
- * purpose:     Obtains an fsf_req and potentially a qtcb (for all but
- *              unsolicited requests) via helper functions
- *              Does some initial fsf request set-up.
- *
- * returns:	pointer to allocated fsf_req if successfull
- *              NULL otherwise
- *
- * locks:       none
- *
- */
-static struct zfcp_fsf_req *
-zfcp_fsf_req_alloc(mempool_t *pool, int req_flags)
-{
-	size_t size;
-	void *ptr;
-	struct zfcp_fsf_req *fsf_req = NULL;
-
-	if (req_flags & ZFCP_REQ_NO_QTCB)
-		size = sizeof(struct zfcp_fsf_req);
-	else
-		size = sizeof(struct zfcp_fsf_req_qtcb);
-
-	if (likely(pool))
-		ptr = mempool_alloc(pool, GFP_ATOMIC);
-	else {
-		if (req_flags & ZFCP_REQ_NO_QTCB)
-			ptr = kmalloc(size, GFP_ATOMIC);
-		else
-			ptr = kmem_cache_alloc(zfcp_data.fsf_req_qtcb_cache,
-					       GFP_ATOMIC);
-	}
-
-	if (unlikely(!ptr))
-		goto out;
-
-	memset(ptr, 0, size);
-
-	if (req_flags & ZFCP_REQ_NO_QTCB) {
-		fsf_req = (struct zfcp_fsf_req *) ptr;
-	} else {
-		fsf_req = &((struct zfcp_fsf_req_qtcb *) ptr)->fsf_req;
-		fsf_req->qtcb =	&((struct zfcp_fsf_req_qtcb *) ptr)->qtcb;
-	}
-
-	fsf_req->pool = pool;
-
- out:
-	return fsf_req;
-}
-
-/*
- * function:	zfcp_fsf_req_free
- *
- * purpose:     Frees the memory of an fsf_req (and potentially a qtcb) or
- *              returns it into the pool via helper functions.
- *
- * returns:     sod all
- *
- * locks:       none
+/**
+ * zfcp_fsf_req_free - free memory used by fsf request
+ * @fsf_req: pointer to struct zfcp_fsf_req
  */
-void
-zfcp_fsf_req_free(struct zfcp_fsf_req *fsf_req)
+void zfcp_fsf_req_free(struct zfcp_fsf_req *req)
 {
-	if (likely(fsf_req->pool)) {
-		mempool_free(fsf_req, fsf_req->pool);
+	if (likely(req->pool)) {
+		mempool_free(req, req->pool);
 		return;
 	}
 
-	if (fsf_req->qtcb) {
-		kmem_cache_free(zfcp_data.fsf_req_qtcb_cache, fsf_req);
+	if (req->qtcb) {
+		kmem_cache_free(zfcp_data.fsf_req_qtcb_cache, req);
 		return;
 	}
-
-	kfree(fsf_req);
 }
 
-/*
+/**
+ * zfcp_fsf_req_dismiss_all - dismiss all fsf requests
+ * @adapter: pointer to struct zfcp_adapter
+ *
  * Never ever call this without shutting down the adapter first.
  * Otherwise the adapter would continue using and corrupting s390 storage.
  * Included BUG_ON() call to ensure this is done.
@@ -197,1815 +103,1359 @@ zfcp_fsf_req_free(struct zfcp_fsf_req *f
  */
 void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *adapter)
 {
-	struct zfcp_fsf_req *fsf_req, *tmp;
+	struct zfcp_fsf_req *req, *tmp;
 	unsigned long flags;
 	LIST_HEAD(remove_queue);
 	unsigned int i;
 
-	BUG_ON(atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status));
+	BUG_ON(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP);
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	for (i = 0; i < REQUEST_LIST_SIZE; i++)
 		list_splice_init(&adapter->req_list[i], &remove_queue);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
 
-	list_for_each_entry_safe(fsf_req, tmp, &remove_queue, list) {
-		list_del(&fsf_req->list);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-		zfcp_fsf_req_complete(fsf_req);
-	}
-}
-
-/*
- * function:    zfcp_fsf_req_complete
- *
- * purpose:	Updates active counts and timers for openfcp-reqs
- *              May cleanup request after req_eval returns
- *
- * returns:	0 - success
- *		!0 - failure
- *
- * context:
- */
-int
-zfcp_fsf_req_complete(struct zfcp_fsf_req *fsf_req)
-{
-	int retval = 0;
-	int cleanup;
-
-	if (unlikely(fsf_req->fsf_command == FSF_QTCB_UNSOLICITED_STATUS)) {
-		/*
-		 * Note: all cleanup handling is done in the callchain of
-		 * the function call-chain below.
-		 */
-		zfcp_fsf_status_read_handler(fsf_req);
-		goto out;
-	} else {
-		del_timer(&fsf_req->timer);
-		zfcp_fsf_protstatus_eval(fsf_req);
-	}
-
-	/*
-	 * fsf_req may be deleted due to waking up functions, so
-	 * cleanup is saved here and used later
-	 */
-	if (likely(fsf_req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
-		cleanup = 1;
-	else
-		cleanup = 0;
-
-	fsf_req->status |= ZFCP_STATUS_FSFREQ_COMPLETED;
-
-	/* cleanup request if requested by initiator */
-	if (likely(cleanup)) {
-		/*
-		 * lock must not be held here since it will be
-		 * grabed by the called routine, too
-		 */
-		zfcp_fsf_req_free(fsf_req);
-	} else {
-		/* notify initiator waiting for the requests completion */
-		/*
-		 * FIXME: Race! We must not access fsf_req here as it might have been
-		 * cleaned up already due to the set ZFCP_STATUS_FSFREQ_COMPLETED
-		 * flag. It's an improbable case. But, we have the same paranoia for
-		 * the cleanup flag already.
-		 * Might better be handled using complete()?
-		 * (setting the flag and doing wakeup ought to be atomic
-		 *  with regard to checking the flag as long as waitqueue is
-		 *  part of the to be released structure)
-		 */
-		wake_up(&fsf_req->completion_wq);
-	}
-
- out:
-	return retval;
-}
-
-/*
- * function:    zfcp_fsf_protstatus_eval
- *
- * purpose:	evaluates the QTCB of the finished FSF request
- *		and initiates appropriate actions
- *		(usually calling FSF command specific handlers)
- *
- * returns:
- *
- * context:
- *
- * locks:
- */
-static int
-zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *fsf_req)
-{
-	int retval = 0;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_qtcb *qtcb = fsf_req->qtcb;
-	union fsf_prot_status_qual *prot_status_qual =
-		&qtcb->prefix.prot_status_qual;
-
-	zfcp_hba_dbf_event_fsf_response(fsf_req);
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY; /* only for SCSI cmnds. */
-		goto skip_protstatus;
-	}
-
-	/* evaluate FSF Protocol Status */
-	switch (qtcb->prefix.prot_status) {
-
-	case FSF_PROT_GOOD:
-	case FSF_PROT_FSF_STATUS_PRESENTED:
-		break;
-
-	case FSF_PROT_QTCB_VERSION_ERROR:
-		dev_err(&adapter->ccw_device->dev,
-			"The QTCB version requested by zfcp (0x%x) is not "
-			"supported by the FCP adapter (lowest supported 0x%x, "
-			"highest supported 0x%x).\n",
-			ZFCP_QTCB_VERSION, prot_status_qual->word[0],
-			prot_status_qual->word[1]);
-		zfcp_erp_adapter_shutdown(adapter, 0, 117, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_SEQ_NUMB_ERROR:
-		zfcp_erp_adapter_reopen(adapter, 0, 98, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_UNSUPP_QTCB_TYPE:
-		dev_err(&adapter->ccw_device->dev,
-			"Packet header type used by the device driver is "
-			"incompatible with that used on the adapter.\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 118, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-				&(adapter->status));
-		break;
-
-	case FSF_PROT_DUPLICATE_REQUEST_ID:
-		dev_err(&adapter->ccw_device->dev,
-			"The request identifier 0x%Lx is ambiguous.\n",
-			(unsigned long long)qtcb->bottom.support.req_handle);
-		zfcp_erp_adapter_shutdown(adapter, 0, 78, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_LINK_DOWN:
-		zfcp_fsf_link_down_info_eval(fsf_req, 37,
-					     &prot_status_qual->link_down_info);
-		/* FIXME: reopening adapter now? better wait for link up */
-		zfcp_erp_adapter_reopen(adapter, 0, 79, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_REEST_QUEUE:
-		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 28, NULL,
-					       ZFCP_STATUS_COMMON_RUNNING,
-					       ZFCP_SET);
-		zfcp_erp_adapter_reopen(adapter,
-					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
-					| ZFCP_STATUS_COMMON_ERP_FAILED,
-					99, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PROT_ERROR_STATE:
-		zfcp_erp_adapter_reopen(adapter, 0, 100, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	default:
-		dev_err(&adapter->ccw_device->dev,
-			"Transfer protocol status information"
-			"provided by the adapter (0x%x) "
-			"is not compatible with the device driver.\n",
-			qtcb->prefix.prot_status);
-		zfcp_erp_adapter_shutdown(adapter, 0, 119, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+	list_for_each_entry_safe(req, tmp, &remove_queue, list) {
+		list_del(&req->list);
+		req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+		zfcp_fsf_req_complete(req);
 	}
-
- skip_protstatus:
-	/*
-	 * always call specific handlers to give them a chance to do
-	 * something meaningful even in error cases
-	 */
-	zfcp_fsf_fsfstatus_eval(fsf_req);
-	return retval;
 }
 
-/*
- * function:	zfcp_fsf_fsfstatus_eval
- *
- * purpose:	evaluates FSF status of completed FSF request
- *		and acts accordingly
- *
- * returns:
- */
-static int
-zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
 {
-	int retval = 0;
-
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		goto skip_fsfstatus;
-	}
-
-	/* evaluate FSF Status */
-	switch (fsf_req->qtcb->header.fsf_status) {
-	case FSF_UNKNOWN_COMMAND:
-		dev_err(&fsf_req->adapter->ccw_device->dev,
-			"Command issued by the device driver (0x%x) is "
-			"not known by the adapter.\n",
-			fsf_req->qtcb->header.fsf_command);
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 120, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_ADAPTER_STATUS_AVAILABLE:
-		zfcp_fsf_fsfstatus_qual_eval(fsf_req);
-		break;
-	}
-
- skip_fsfstatus:
-	/*
-	 * always call specific handlers to give them a chance to do
-	 * something meaningful even in error cases
-	 */
-	zfcp_fsf_req_dispatch(fsf_req);
+	struct fsf_status_read_buffer *sr_buf = req->data;
+	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_port *port;
+	int d_id = sr_buf->d_id & ZFCP_DID_MASK;
+	unsigned long flags;
 
-	return retval;
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if (port->d_id == d_id) {
+			read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+			switch (sr_buf->status_subtype) {
+			case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
+				zfcp_erp_port_reopen(port, 0, 101, req);
+				break;
+			case FSF_STATUS_READ_SUB_ERROR_PORT:
+				zfcp_erp_port_shutdown(port, 0, 122, req);
+				break;
+			}
+			return;
+		}
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-/*
- * function:	zfcp_fsf_fsfstatus_qual_eval
- *
- * purpose:	evaluates FSF status-qualifier of completed FSF request
- *		and acts accordingly
- *
- * returns:
- */
-static int
-zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_bit_error_threshold(struct zfcp_fsf_req *req)
 {
-	int retval = 0;
-
-	switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
-	case FSF_SQ_FCP_RSP_AVAILABLE:
-		break;
-	case FSF_SQ_RETRY_IF_POSSIBLE:
-		/* The SCSI-stack may now issue retries or escalate */
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-	case FSF_SQ_COMMAND_ABORTED:
-		/* Carry the aborted state on to upper layer */
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTED;
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-	case FSF_SQ_NO_RECOM:
-		dev_err(&fsf_req->adapter->ccw_device->dev,
-			"No recommendation could be given for a "
-			"problem on the adapter.\n");
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 121, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-	case FSF_SQ_ULP_PROGRAMMING_ERROR:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-	case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-	case FSF_SQ_NO_RETRY_POSSIBLE:
-	case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-		/* dealt with in the respective functions */
-		break;
-	default:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-	}
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_status_read_buffer *sr_buf = req->data;
+	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
 
-	return retval;
+	dev_warn(&adapter->ccw_device->dev,
+		 "Warning: bit error threshold data "
+		 "received for the adapter: "
+		 "link failures = %i, loss of sync errors = %i, "
+		 "loss of signal errors = %i, "
+		 "primitive sequence errors = %i, "
+		 "invalid transmission word errors = %i, "
+		 "CRC errors = %i).\n",
+		 err->link_failure_error_count,
+		 err->loss_of_sync_error_count,
+		 err->loss_of_signal_error_count,
+		 err->primitive_sequence_error_count,
+		 err->invalid_transmission_word_error_count,
+		 err->crc_error_count);
+	dev_warn(&adapter->ccw_device->dev,
+		 "Additional bit error threshold data of the adapter: "
+		 "primitive sequence event time-outs = %i, "
+		 "elastic buffer overrun errors = %i, "
+		 "advertised receive buffer-to-buffer credit = %i, "
+		 "current receice buffer-to-buffer credit = %i, "
+		 "advertised transmit buffer-to-buffer credit = %i, "
+		 "current transmit buffer-to-buffer credit = %i).\n",
+		 err->primitive_sequence_event_timeout_count,
+		 err->elastic_buffer_overrun_error_count,
+		 err->advertised_receive_b2b_credit,
+		 err->current_receive_b2b_credit,
+		 err->advertised_transmit_b2b_credit,
+		 err->current_transmit_b2b_credit);
 }
 
-/**
- * zfcp_fsf_link_down_info_eval - evaluate link down information block
- */
-static void
-zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *fsf_req, u8 id,
-			     struct fsf_link_down_info *link_down)
+static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, u8 id,
+					 struct fsf_link_down_info *link_down)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct zfcp_adapter *adapter = req->adapter;
 
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-	                     &adapter->status))
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
 		return;
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
 
-	if (link_down == NULL)
+	if (!link_down)
 		goto out;
 
 	switch (link_down->error_code) {
 	case FSF_PSQ_LINK_NO_LIGHT:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "no light detected.\n");
+		dev_warn(&req->adapter->ccw_device->dev,
+			 "The local link is down: no light detected.\n");
 		break;
 	case FSF_PSQ_LINK_WRAP_PLUG:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
-			 "The local link is down: "
-			 "wrap plug detected.\n");
+		dev_warn(&req->adapter->ccw_device->dev,
+			 "The local link is down: wrap plug detected.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "adjacent node on link does not support FCP.\n");
 		break;
 	case FSF_PSQ_LINK_FIRMWARE_UPDATE:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "firmware update in progress.\n");
 		break;
 	case FSF_PSQ_LINK_INVALID_WWPN:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "duplicate or invalid WWPN detected.\n");
 		break;
 	case FSF_PSQ_LINK_NO_NPIV_SUPPORT:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "no support for NPIV by Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FCP_RESOURCES:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "out of resource in FCP daughtercard.\n");
 		break;
 	case FSF_PSQ_LINK_NO_FABRIC_RESOURCES:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "out of resource in Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_FABRIC_LOGIN_UNABLE:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link is down: "
 			 "unable to login to Fabric.\n");
 		break;
 	case FSF_PSQ_LINK_WWPN_ASSIGNMENT_CORRUPTED:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "WWPN assignment file corrupted on adapter.\n");
 		break;
 	case FSF_PSQ_LINK_MODE_TABLE_CURRUPTED:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "Mode table corrupted on adapter.\n");
 		break;
 	case FSF_PSQ_LINK_NO_WWPN_ASSIGNMENT:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "No WWPN for assignment table on adapter.\n");
 		break;
 	default:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The local link to adapter is down.\n");
 	}
-
- out:
-	zfcp_erp_adapter_failed(adapter, id, fsf_req);
+out:
+	zfcp_erp_adapter_failed(adapter, id, req);
 }
 
-/*
- * function:	zfcp_fsf_req_dispatch
- *
- * purpose:	calls the appropriate command specific handler
- *
- * returns:
- */
-static int
-zfcp_fsf_req_dispatch(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_status_read_link_down(struct zfcp_fsf_req *req)
 {
-	struct zfcp_erp_action *erp_action = fsf_req->erp_action;
-	int retval = 0;
-
-
-	switch (fsf_req->fsf_command) {
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_status_read_buffer *sr_buf = req->data;
+	struct fsf_link_down_info *ldi =
+		(struct fsf_link_down_info *) &sr_buf->payload;
 
-	case FSF_QTCB_FCP_CMND:
-		zfcp_fsf_send_fcp_command_handler(fsf_req);
+	switch (sr_buf->status_subtype) {
+	case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
+		dev_warn(&adapter->ccw_device->dev,
+			 "Physical link is down.\n");
+		zfcp_fsf_link_down_info_eval(req, 38, ldi);
 		break;
-
-	case FSF_QTCB_ABORT_FCP_CMND:
-		zfcp_fsf_abort_fcp_command_handler(fsf_req);
+	case FSF_STATUS_READ_SUB_FDISC_FAILED:
+		dev_warn(&adapter->ccw_device->dev,
+			 "Local link is down "
+			 "due to failed FDISC login.\n");
+		zfcp_fsf_link_down_info_eval(req, 39, ldi);
 		break;
+	case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
+		dev_warn(&adapter->ccw_device->dev,
+			 "Local link is down "
+			 "due to firmware update on adapter.\n");
+		zfcp_fsf_link_down_info_eval(req, 40, NULL);
+	};
+}
 
-	case FSF_QTCB_SEND_GENERIC:
-		zfcp_fsf_send_ct_handler(fsf_req);
-		break;
+static void zfcp_fsf_status_read_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_status_read_buffer *sr_buf = req->data;
 
-	case FSF_QTCB_OPEN_PORT_WITH_DID:
-		zfcp_fsf_open_port_handler(fsf_req);
-		break;
+	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
+		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, sr_buf);
+		mempool_free(sr_buf, adapter->pool.data_status_read);
+		zfcp_fsf_req_free(req);
+		return;
+	}
 
-	case FSF_QTCB_OPEN_LUN:
-		zfcp_fsf_open_unit_handler(fsf_req);
-		break;
+	zfcp_hba_dbf_event_fsf_unsol("read", adapter, sr_buf);
 
-	case FSF_QTCB_CLOSE_LUN:
-		zfcp_fsf_close_unit_handler(fsf_req);
+	switch (sr_buf->status_type) {
+	case FSF_STATUS_READ_PORT_CLOSED:
+		zfcp_fsf_status_read_port_closed(req);
 		break;
-
-	case FSF_QTCB_CLOSE_PORT:
-		zfcp_fsf_close_port_handler(fsf_req);
+	case FSF_STATUS_READ_INCOMING_ELS:
+		zfcp_fc_incoming_els(req);
 		break;
-
-	case FSF_QTCB_CLOSE_PHYSICAL_PORT:
-		zfcp_fsf_close_physical_port_handler(fsf_req);
+	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
 		break;
-
-	case FSF_QTCB_EXCHANGE_CONFIG_DATA:
-		zfcp_fsf_exchange_config_data_handler(fsf_req);
+	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
+		zfcp_fsf_bit_error_threshold(req);
 		break;
-
-	case FSF_QTCB_EXCHANGE_PORT_DATA:
-		zfcp_fsf_exchange_port_data_handler(fsf_req);
+	case FSF_STATUS_READ_LINK_DOWN:
+		zfcp_fsf_status_read_link_down(req);
 		break;
-
-	case FSF_QTCB_SEND_ELS:
-		zfcp_fsf_send_els_handler(fsf_req);
+	case FSF_STATUS_READ_LINK_UP:
+		dev_info(&adapter->ccw_device->dev,
+			 "Local link was replugged.\n");
+		/* All ports should be marked as ready to run again */
+		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
+					       ZFCP_STATUS_COMMON_RUNNING,
+					       ZFCP_SET);
+		zfcp_erp_adapter_reopen(adapter,
+					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+					ZFCP_STATUS_COMMON_ERP_FAILED,
+					102, req);
 		break;
-
-	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-		zfcp_fsf_control_file_handler(fsf_req);
+	case FSF_STATUS_READ_NOTIFICATION_LOST:
+		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)
+			zfcp_erp_adapter_access_changed(adapter, 135, req);
+		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
+			schedule_work(&adapter->scan_work);
 		break;
-
-	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		zfcp_fsf_control_file_handler(fsf_req);
+	case FSF_STATUS_READ_CFDC_UPDATED:
+		zfcp_erp_adapter_access_changed(adapter, 136, req);
+		break;
+	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
+		adapter->adapter_features = sr_buf->payload.word[0];
 		break;
 	}
 
-	if (!erp_action)
-		return retval;
+	mempool_free(sr_buf, adapter->pool.data_status_read);
+	zfcp_fsf_req_free(req);
 
-	zfcp_erp_async_handler(erp_action, 0);
+	atomic_inc(&adapter->stat_miss);
+	schedule_work(&adapter->stat_work);
+}
 
-	return retval;
+static void zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *req)
+{
+	switch (req->qtcb->header.fsf_status_qual.word[0]) {
+	case FSF_SQ_FCP_RSP_AVAILABLE:
+	case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
+	case FSF_SQ_NO_RETRY_POSSIBLE:
+	case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
+		return;
+	case FSF_SQ_COMMAND_ABORTED:
+		req->status |= ZFCP_STATUS_FSFREQ_ABORTED;
+		break;
+	case FSF_SQ_NO_RECOM:
+		dev_err(&req->adapter->ccw_device->dev,
+			"No recommendation could be given for a "
+			"problem on the adapter.\n");
+		zfcp_erp_adapter_shutdown(req->adapter, 0, 121, req);
+		break;
+	}
+	/* all non-return stats set FSFREQ_ERROR*/
+	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
-/*
- * function:    zfcp_fsf_status_read
- *
- * purpose:	initiates a Status Read command at the specified adapter
- *
- * returns:
- */
-int
-zfcp_fsf_status_read(struct zfcp_adapter *adapter, int req_flags)
+static void zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *req)
 {
-	struct zfcp_fsf_req *fsf_req;
-	struct fsf_status_read_buffer *status_buffer;
-	unsigned long lock_flags;
-	volatile struct qdio_buffer_element *sbale;
-	int retval;
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
+		return;
 
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
-				     req_flags | ZFCP_REQ_NO_QTCB,
-				     adapter->pool.fsf_req_status_read,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
-		goto failed_req_create;
-
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
-        sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
-        fsf_req->sbale_curr = 2;
-
-	retval = -ENOMEM;
-	status_buffer =
-		mempool_alloc(adapter->pool.data_status_read, GFP_ATOMIC);
-	if (!status_buffer)
-		goto failed_buf;
-	memset(status_buffer, 0, sizeof (struct fsf_status_read_buffer));
-	fsf_req->data = (unsigned long) status_buffer;
+	switch (req->qtcb->header.fsf_status) {
+	case FSF_UNKNOWN_COMMAND:
+		dev_err(&req->adapter->ccw_device->dev,
+			"Command issued by the device driver (0x%x) is "
+			"not known by the adapter.\n",
+			req->qtcb->header.fsf_command);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, 120, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		break;
+	case FSF_ADAPTER_STATUS_AVAILABLE:
+		zfcp_fsf_fsfstatus_qual_eval(req);
+		break;
+	}
+}
 
-	/* insert pointer to respective buffer */
-	sbale = zfcp_qdio_sbale_curr(fsf_req);
-	sbale->addr = (void *) status_buffer;
-	sbale->length = sizeof(struct fsf_status_read_buffer);
+static void zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_qtcb *qtcb = req->qtcb;
+	union fsf_prot_status_qual *psq = &qtcb->prefix.prot_status_qual;
 
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval)
-		goto failed_req_send;
+	zfcp_hba_dbf_event_fsf_response(req);
 
-	goto out;
+	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			ZFCP_STATUS_FSFREQ_RETRY; /* only for SCSI cmnds. */
+		return;
+	}
+
+	switch (qtcb->prefix.prot_status) {
+	case FSF_PROT_GOOD:
+	case FSF_PROT_FSF_STATUS_PRESENTED:
+		return;
+	case FSF_PROT_QTCB_VERSION_ERROR:
+		dev_err(&adapter->ccw_device->dev,
+			"The QTCB version requested by zfcp (0x%x) is not "
+			"supported by the FCP adapter (lowest supported "
+			"0x%x, highest supported 0x%x).\n",
+			FSF_QTCB_CURRENT_VERSION, psq->word[0],
+			psq->word[1]);
+		zfcp_erp_adapter_shutdown(adapter, 0, 117, req);
+		break;
+	case FSF_PROT_ERROR_STATE:
+	case FSF_PROT_SEQ_NUMB_ERROR:
+		zfcp_erp_adapter_reopen(adapter, 0, 98, req);
+		req->status |= ZFCP_STATUS_FSFREQ_RETRY;
+		break;
+	case FSF_PROT_UNSUPP_QTCB_TYPE:
+		dev_err(&adapter->ccw_device->dev,
+			"Packet header type used by the device driver is "
+			"incompatible with that used on the adapter.\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 118, req);
+		break;
+	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+				&adapter->status);
+		break;
+	case FSF_PROT_DUPLICATE_REQUEST_ID:
+		dev_err(&adapter->ccw_device->dev,
+			"The request identifier 0x%Lx is ambiguous.\n",
+			(unsigned long long)qtcb->bottom.support.req_handle);
+		zfcp_erp_adapter_shutdown(adapter, 0, 78, req);
+		break;
+	case FSF_PROT_LINK_DOWN:
+		zfcp_fsf_link_down_info_eval(req, 37, &psq->link_down_info);
+		/* FIXME: reopening adapter now? better wait for link up */
+		zfcp_erp_adapter_reopen(adapter, 0, 79, req);
+		break;
+	case FSF_PROT_REEST_QUEUE:
+		/* All ports should be marked as ready to run again */
+		zfcp_erp_modify_adapter_status(adapter, 28, NULL,
+					       ZFCP_STATUS_COMMON_RUNNING,
+					       ZFCP_SET);
+		zfcp_erp_adapter_reopen(adapter,
+					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+					ZFCP_STATUS_COMMON_ERP_FAILED, 99, req);
+		break;
+	default:
+		dev_err(&adapter->ccw_device->dev,
+			"Transfer protocol status information"
+			"provided by the adapter (0x%x) "
+			"is not compatible with the device driver.\n",
+			qtcb->prefix.prot_status);
+		zfcp_erp_adapter_shutdown(adapter, 0, 119, req);
+	}
+	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+}
 
- failed_req_send:
-	mempool_free(status_buffer, adapter->pool.data_status_read);
+/**
+ * zfcp_fsf_req_complete - process completion of a FSF request
+ * @fsf_req: The FSF request that has been completed.
+ *
+ * When a request has been completed either from the FCP adapter,
+ * or it has been dismissed due to a queue shutdown, this function
+ * is called to process the completion status and trigger further
+ * events related to the FSF request.
+ */
+void zfcp_fsf_req_complete(struct zfcp_fsf_req *req)
+{
+	if (unlikely(req->fsf_command == FSF_QTCB_UNSOLICITED_STATUS)) {
+		zfcp_fsf_status_read_handler(req);
+		return;
+	}
 
- failed_buf:
-	zfcp_fsf_req_free(fsf_req);
- failed_req_create:
-	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
- out:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return retval;
+	del_timer(&req->timer);
+	zfcp_fsf_protstatus_eval(req);
+	zfcp_fsf_fsfstatus_eval(req);
+	req->handler(req);
+
+	if (req->erp_action)
+		zfcp_erp_async_handler(req->erp_action, 0);
+	req->status |= ZFCP_STATUS_FSFREQ_COMPLETED;
+
+	if (likely(req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
+		zfcp_fsf_req_free(req);
+	else
+	/* notify initiator waiting for the requests completion */
+	/*
+	 * FIXME: Race! We must not access fsf_req here as it might have been
+	 * cleaned up already due to the set ZFCP_STATUS_FSFREQ_COMPLETED
+	 * flag. It's an improbable case. But, we have the same paranoia for
+	 * the cleanup flag already.
+	 * Might better be handled using complete()?
+	 * (setting the flag and doing wakeup ought to be atomic
+	 *  with regard to checking the flag as long as waitqueue is
+	 *  part of the to be released structure)
+	 */
+		wake_up(&req->completion_wq);
 }
 
-static int
-zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *fsf_req)
+static int zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *req)
 {
-	struct fsf_status_read_buffer *status_buffer;
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	unsigned long flags;
+	struct fsf_qtcb_bottom_config *bottom;
+	struct zfcp_adapter *adapter = req->adapter;
+	struct Scsi_Host *shost = adapter->scsi_host;
 
-	status_buffer = (struct fsf_status_read_buffer *) fsf_req->data;
-	adapter = fsf_req->adapter;
+	bottom = &req->qtcb->bottom.config;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list)
-	    if (port->d_id == (status_buffer->d_id & ZFCP_DID_MASK))
-		break;
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	if (req->data)
+		memcpy(req->data, bottom, sizeof(*bottom));
 
-	if (!port || (port->d_id != (status_buffer->d_id & ZFCP_DID_MASK)))
-		goto out;
+	fc_host_node_name(shost) = bottom->nport_serv_param.wwnn;
+	fc_host_port_name(shost) = bottom->nport_serv_param.wwpn;
+	fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
+	fc_host_speed(shost) = bottom->fc_link_speed;
+	fc_host_supported_classes(shost) = FC_COS_CLASS2 | FC_COS_CLASS3;
 
-	switch (status_buffer->status_subtype) {
+	adapter->hydra_version = bottom->adapter_type;
+	adapter->timer_ticks = bottom->timer_interval;
 
-	case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
-		zfcp_erp_port_reopen(port, 0, 101, fsf_req);
-		break;
+	if (fc_host_permanent_port_name(shost) == -1)
+		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
 
-	case FSF_STATUS_READ_SUB_ERROR_PORT:
-		zfcp_erp_port_shutdown(port, 0, 122, fsf_req);
+	switch (bottom->fc_topology) {
+	case FSF_TOPO_P2P:
+		adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
+		adapter->peer_wwpn = bottom->plogi_payload.wwpn;
+		adapter->peer_wwnn = bottom->plogi_payload.wwnn;
+		fc_host_port_type(shost) = FC_PORTTYPE_PTP;
+		if (req->erp_action)
+			dev_info(&adapter->ccw_device->dev,
+				 "Point-to-Point fibrechannel "
+				 "configuration detected.\n");
+		break;
+	case FSF_TOPO_FABRIC:
+		fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
+		if (req->erp_action)
+			dev_info(&adapter->ccw_device->dev,
+				 "Switched fabric fibrechannel "
+				 "network detected.\n");
 		break;
+	case FSF_TOPO_AL:
+		fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
+		dev_err(&adapter->ccw_device->dev,
+			"Unsupported arbitrated loop fibrechannel "
+			"topology detected, shutting down "
+			"adapter.\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 127, req);
+		return -EIO;
+	default:
+		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
+		dev_err(&adapter->ccw_device->dev,
+			"The fibrechannel topology reported by the"
+			" adapter is not known by the zfcp driver,"
+			" shutting down adapter.\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 128, req);
+		return -EIO;
 	}
- out:
+
 	return 0;
 }
 
-static void zfcp_fsf_bit_error_threshold(struct zfcp_fsf_req *req)
+static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct fsf_status_read_buffer *buf =
-		(struct fsf_status_read_buffer *) req->data;
-	struct fsf_bit_error_payload *err =
-		(struct fsf_bit_error_payload *) buf->payload;
-	dev_warn(&adapter->ccw_device->dev,
-		 "Warning: bit error threshold data "
-		 "received for the adapter: "
-		 "link failures = %i, loss of sync errors = %i, "
-		 "loss of signal errors = %i, "
-		 "primitive sequence errors = %i, "
-		 "invalid transmission word errors = %i, "
-		 "CRC errors = %i).\n",
-		 err->link_failure_error_count,
-		 err->loss_of_sync_error_count,
-		 err->loss_of_signal_error_count,
-		 err->primitive_sequence_error_count,
-		 err->invalid_transmission_word_error_count,
-		 err->crc_error_count);
-	dev_warn(&adapter->ccw_device->dev,
-		 "Additional bit error threshold data of the adapter: "
-		 "primitive sequence event time-outs = %i, "
-		 "elastic buffer overrun errors = %i, "
-		 "advertised receive buffer-to-buffer credit = %i, "
-		 "current receice buffer-to-buffer credit = %i, "
-		 "advertised transmit buffer-to-buffer credit = %i, "
-		 "current transmit buffer-to-buffer credit = %i).\n",
-		 err->primitive_sequence_event_timeout_count,
-		 err->elastic_buffer_overrun_error_count,
-		 err->advertised_receive_b2b_credit,
-		 err->current_receive_b2b_credit,
-		 err->advertised_transmit_b2b_credit,
-		 err->current_transmit_b2b_credit);
-}
-
-/*
- * function:    zfcp_fsf_status_read_handler
- *
- * purpose:	is called for finished Open Port command
- *
- * returns:
- */
-static int
-zfcp_fsf_status_read_handler(struct zfcp_fsf_req *fsf_req)
-{
-	int retval = 0;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_status_read_buffer *status_buffer =
-		(struct fsf_status_read_buffer *) fsf_req->data;
+	struct fsf_qtcb *qtcb = req->qtcb;
+	struct fsf_qtcb_bottom_config *bottom = &qtcb->bottom.config;
+	struct Scsi_Host *shost = adapter->scsi_host;
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
-		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, status_buffer);
-		mempool_free(status_buffer, adapter->pool.data_status_read);
-		zfcp_fsf_req_free(fsf_req);
-		goto out;
-	}
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
+		return;
 
-	zfcp_hba_dbf_event_fsf_unsol("read", adapter, status_buffer);
+	adapter->fsf_lic_version = bottom->lic_version;
+	adapter->adapter_features = bottom->adapter_features;
+	adapter->connection_features = bottom->connection_features;
+	adapter->peer_wwpn = 0;
+	adapter->peer_wwnn = 0;
+	adapter->peer_d_id = 0;
 
-	switch (status_buffer->status_type) {
+	switch (qtcb->header.fsf_status) {
+	case FSF_GOOD:
+		if (zfcp_fsf_exchange_config_evaluate(req))
+			return;
 
-	case FSF_STATUS_READ_PORT_CLOSED:
-		zfcp_fsf_status_read_port_closed(fsf_req);
+		if (bottom->max_qtcb_size < sizeof(struct fsf_qtcb)) {
+			dev_err(&adapter->ccw_device->dev,
+				"Maximum QTCB size (%d bytes) allowed by "
+				"the adapter is lower than the minimum "
+				"required by the driver (%ld bytes).\n",
+				bottom->max_qtcb_size,
+				sizeof(struct fsf_qtcb));
+			zfcp_erp_adapter_shutdown(adapter, 0, 129, req);
+			return;
+		}
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 		break;
+	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		fc_host_node_name(shost) = 0;
+		fc_host_port_name(shost) = 0;
+		fc_host_port_id(shost) = 0;
+		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
+		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
+		adapter->hydra_version = 0;
 
-	case FSF_STATUS_READ_INCOMING_ELS:
-		zfcp_fc_incoming_els(fsf_req);
-		break;
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
+				&adapter->status);
 
-	case FSF_STATUS_READ_SENSE_DATA_AVAIL:
+		zfcp_fsf_link_down_info_eval(req, 42,
+			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
+	default:
+		zfcp_erp_adapter_shutdown(adapter, 0, 130, req);
+		return;
+	}
 
-	case FSF_STATUS_READ_BIT_ERROR_THRESHOLD:
-		zfcp_fsf_bit_error_threshold(fsf_req);
-		break;
+	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
+		adapter->hardware_version = bottom->hardware_version;
+		memcpy(fc_host_serial_number(shost), bottom->serial_number,
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
+		EBCASC(fc_host_serial_number(shost),
+		       min(FC_SERIAL_NUMBER_SIZE, 17));
+	}
 
-	case FSF_STATUS_READ_LINK_DOWN:
-		switch (status_buffer->status_subtype) {
-		case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-			dev_warn(&adapter->ccw_device->dev,
-				 "Physical link is down.\n");
-			zfcp_fsf_link_down_info_eval(fsf_req, 38,
-				(struct fsf_link_down_info *)
-				&status_buffer->payload);
-			break;
-		case FSF_STATUS_READ_SUB_FDISC_FAILED:
-			dev_warn(&adapter->ccw_device->dev,
-				 "Local link is down "
-				 "due to failed FDISC login.\n");
-			zfcp_fsf_link_down_info_eval(fsf_req, 39,
-				(struct fsf_link_down_info *)
-				&status_buffer->payload);
-			break;
-		case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
-			dev_warn(&adapter->ccw_device->dev,
-				 "Local link is down "
-				 "due to firmware update on adapter.\n");
-			zfcp_fsf_link_down_info_eval(fsf_req, 40, NULL);
-			break;
-		default:
-			dev_warn(&adapter->ccw_device->dev,
-				 "Local link is down.\n");
-			zfcp_fsf_link_down_info_eval(fsf_req, 41, NULL);
-		};
-		break;
+	if (FSF_QTCB_CURRENT_VERSION < bottom->low_qtcb_version) {
+		dev_err(&adapter->ccw_device->dev,
+			"The adapter only supports newer control block "
+			"versions, try updated device driver.\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 125, req);
+		return;
+	}
+	if (FSF_QTCB_CURRENT_VERSION > bottom->high_qtcb_version) {
+		dev_err(&adapter->ccw_device->dev,
+			"The adapter only supports older control block "
+			"versions, consider a microcode upgrade.\n");
+		zfcp_erp_adapter_shutdown(adapter, 0, 126, req);
+	}
+}
 
-	case FSF_STATUS_READ_LINK_UP:
-		dev_info(&adapter->ccw_device->dev,
-			 "Local link was replugged.\n");
-		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
-					       ZFCP_STATUS_COMMON_RUNNING,
-					       ZFCP_SET);
-		zfcp_erp_adapter_reopen(adapter,
-					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
-					| ZFCP_STATUS_COMMON_ERP_FAILED,
-					102, fsf_req);
-		break;
+static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_qtcb_bottom_port *bottom = &req->qtcb->bottom.port;
+	struct Scsi_Host *shost = adapter->scsi_host;
 
-	case FSF_STATUS_READ_NOTIFICATION_LOST:
-		if (status_buffer->status_subtype &
-		    FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_erp_adapter_access_changed(adapter, 135, fsf_req);
-		if (status_buffer->status_subtype &
-		    FSF_STATUS_READ_SUB_INCOMING_ELS)
-			schedule_work(&adapter->scan_work);
-		break;
+	if (req->data)
+		memcpy(req->data, bottom, sizeof(*bottom));
 
-	case FSF_STATUS_READ_CFDC_UPDATED:
-		zfcp_erp_adapter_access_changed(adapter, 136, fsf_req);
-		break;
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+		fc_host_permanent_port_name(shost) = bottom->wwpn;
+	else
+		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
+	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
+	fc_host_supported_speeds(shost) = bottom->supported_speed;
+}
 
-	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
-		adapter->adapter_features = *(u32*) status_buffer->payload;
+static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct fsf_qtcb *qtcb = req->qtcb;
+
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
+		return;
+
+	switch (qtcb->header.fsf_status) {
+	case FSF_GOOD:
+		zfcp_fsf_exchange_port_evaluate(req);
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
+		break;
+	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		zfcp_fsf_exchange_port_evaluate(req);
+		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
+		zfcp_fsf_link_down_info_eval(req, 43,
+			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	}
-	mempool_free(status_buffer, adapter->pool.data_status_read);
-	zfcp_fsf_req_free(fsf_req);
-	/*
-	 * recycle buffer and start new request repeat until outbound
-	 * queue is empty or adapter shutdown is requested
-	 */
-	/*
-	 * FIXME(qdio):
-	 * we may wait in the req_create for 5s during shutdown, so
-	 * qdio_cleanup will have to wait at least that long before returning
-	 * with failure to allow us a proper cleanup under all circumstances
-	 */
-	/*
-	 * FIXME:
-	 * allocation failure possible? (Is this code needed?)
-	 */
+}
 
-	atomic_inc(&adapter->stat_miss);
-	schedule_work(&adapter->stat_work);
- out:
-	return retval;
+static int zfcp_fsf_sbal_check(struct zfcp_qdio_queue *queue)
+{
+	spin_lock(&queue->lock);
+	if (atomic_read(&queue->count))
+		return 1;
+	spin_unlock(&queue->lock);
+	return 0;
 }
 
-/*
- * function:    zfcp_fsf_abort_fcp_command
- *
- * purpose:	tells FSF to abort a running SCSI command
- *
- * returns:	address of initiated FSF request
- *		NULL - request could not be initiated
- *
- * FIXME(design): should be watched by a timeout !!!
- * FIXME(design) shouldn't this be modified to return an int
- *               also...don't know how though
- */
-struct zfcp_fsf_req *
-zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
-			   struct zfcp_adapter *adapter,
-			   struct zfcp_unit *unit, int req_flags)
+static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
+{
+	long ret;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+
+	spin_unlock(&req_q->lock);
+	ret = wait_event_interruptible_timeout(adapter->request_wq,
+					zfcp_fsf_sbal_check(req_q), 5 * HZ);
+	if (ret > 0)
+		return 0;
+
+	spin_lock(&req_q->lock);
+	return -EIO;
+}
+
+static struct zfcp_fsf_req *zfcp_fsf_alloc_noqtcb(mempool_t *pool)
+{
+	struct zfcp_fsf_req *req;
+	req = mempool_alloc(pool, GFP_ATOMIC);
+	if (!req)
+		return NULL;
+	memset(req, 0, sizeof(*req));
+	return req;
+}
+
+static struct zfcp_fsf_req *zfcp_fsf_alloc_qtcb(mempool_t *pool)
+{
+	struct zfcp_fsf_req_qtcb *qtcb;
+
+	if (likely(pool))
+		qtcb = mempool_alloc(pool, GFP_ATOMIC);
+	else
+		qtcb = kmem_cache_alloc(zfcp_data.fsf_req_qtcb_cache,
+					GFP_ATOMIC);
+	if (unlikely(!qtcb))
+		return NULL;
+
+	memset(qtcb, 0, sizeof(*qtcb));
+	qtcb->fsf_req.qtcb = &qtcb->qtcb;
+	qtcb->fsf_req.pool = pool;
+
+	return &qtcb->fsf_req;
+}
+
+static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
+						u32 fsf_cmd, int req_flags,
+						mempool_t *pool)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req = NULL;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
-				     req_flags, adapter->pool.fsf_req_abort,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
-		goto out;
-
-	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-			&unit->status)))
-		goto unit_blocked;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-        sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	struct zfcp_fsf_req *req;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+
+	if (req_flags & ZFCP_REQ_NO_QTCB)
+		req = zfcp_fsf_alloc_noqtcb(pool);
+	else
+		req = zfcp_fsf_alloc_qtcb(pool);
 
-	fsf_req->data = (unsigned long) unit;
+	if (unlikely(!req))
+		return ERR_PTR(-EIO);
 
-	/* set handles of unit and its parent port in QTCB */
-	fsf_req->qtcb->header.lun_handle = unit->handle;
-	fsf_req->qtcb->header.port_handle = unit->port->handle;
+	if (adapter->req_no == 0)
+		adapter->req_no++;
 
-	/* set handle of request which should be aborted */
-	fsf_req->qtcb->bottom.support.req_handle = (u64) old_req_id;
+	INIT_LIST_HEAD(&req->list);
+	init_timer(&req->timer);
+	init_waitqueue_head(&req->completion_wq);
+
+	req->adapter = adapter;
+	req->fsf_command = fsf_cmd;
+	req->req_id = adapter->req_no++;
+	req->sbal_number = 1;
+	req->sbal_first = req_q->first;
+	req->sbal_last = req_q->first;
+	req->sbale_curr = 1;
 
-	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (!retval)
-		goto out;
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].addr = (void *) req->req_id;
+	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
- unit_blocked:
-		zfcp_fsf_req_free(fsf_req);
-		fsf_req = NULL;
+	if (likely(req->qtcb)) {
+		req->qtcb->prefix.req_seq_no = req->adapter->fsf_req_seq_no;
+		req->qtcb->prefix.req_id = req->req_id;
+		req->qtcb->prefix.ulp_info = 26;
+		req->qtcb->prefix.qtcb_type = fsf_qtcb_type[req->fsf_command];
+		req->qtcb->prefix.qtcb_version = FSF_QTCB_CURRENT_VERSION;
+		req->qtcb->header.req_handle = req->req_id;
+		req->qtcb->header.fsf_command = req->fsf_command;
+		req->seq_no = adapter->fsf_req_seq_no;
+		req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
+		sbale[1].addr = (void *) req->qtcb;
+		sbale[1].length = sizeof(struct fsf_qtcb);
+	}
+
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_QDIOUP)) {
+		zfcp_fsf_req_free(req);
+		return ERR_PTR(-EIO);
+	}
+
+	if (likely(req_flags & ZFCP_REQ_AUTO_CLEANUP))
+		req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
 
- out:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return fsf_req;
+	return req;
 }
 
-/*
- * function:    zfcp_fsf_abort_fcp_command_handler
- *
- * purpose:	is called for finished Abort FCP Command request
- *
- * returns:
+static int zfcp_fsf_req_send(struct zfcp_fsf_req *req)
+{
+	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+	int idx;
+
+	/* put allocated FSF request into hash table */
+	spin_lock(&adapter->req_list_lock);
+	idx = zfcp_reqlist_hash(req->req_id);
+	list_add_tail(&req->list, &adapter->req_list[idx]);
+	spin_unlock(&adapter->req_list_lock);
+
+	req->issued = get_clock();
+	if (zfcp_qdio_send(req)) {
+		/* Queues are down..... */
+		del_timer(&req->timer);
+		spin_lock(&adapter->req_list_lock);
+		zfcp_reqlist_remove(adapter, req);
+		spin_unlock(&adapter->req_list_lock);
+		/* undo changes in request queue made for this request */
+		atomic_add(req->sbal_number, &req_q->count);
+		req_q->first -= req->sbal_number;
+		req_q->first += QDIO_MAX_BUFFERS_PER_Q;
+		req_q->first %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
+		zfcp_erp_adapter_reopen(adapter, 0, 116, req);
+		return -EIO;
+	}
+
+	/* Don't increase for unsolicited status */
+	if (req->qtcb)
+		adapter->fsf_req_seq_no++;
+
+	return 0;
+}
+
+/**
+ * zfcp_fsf_status_read - send status read request
+ * @adapter: pointer to struct zfcp_adapter
+ * @req_flags: request flags
+ * Returns: 0 on success, ERROR otherwise
  */
-static int
-zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *new_fsf_req)
+int zfcp_fsf_status_read(struct zfcp_adapter *adapter)
 {
-	int retval = -EINVAL;
-	struct zfcp_unit *unit;
-	union fsf_status_qual *fsf_stat_qual =
-		&new_fsf_req->qtcb->header.fsf_status_qual;
+	struct zfcp_fsf_req *req;
+	struct fsf_status_read_buffer *sr_buf;
+	volatile struct qdio_buffer_element *sbale;
+	int retval = -EIO;
 
-	if (new_fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* do not set ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED */
-		goto skip_fsfstatus;
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
+				  ZFCP_REQ_NO_QTCB,
+				  adapter->pool.fsf_req_status_read);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
 	}
 
-	unit = (struct zfcp_unit *) new_fsf_req->data;
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_STATUS;
+	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
+	req->sbale_curr = 2;
 
-	/* evaluate FSF status in QTCB */
-	switch (new_fsf_req->qtcb->header.fsf_status) {
+	sr_buf = mempool_alloc(adapter->pool.data_status_read, GFP_ATOMIC);
+	if (!sr_buf) {
+		retval = -ENOMEM;
+		goto failed_buf;
+	}
+	memset(sr_buf, 0, sizeof(*sr_buf));
+	req->data = sr_buf;
+	sbale = zfcp_qdio_sbale_curr(req);
+	sbale->addr = (void *) sr_buf;
+	sbale->length = sizeof(*sr_buf);
 
+	retval = zfcp_fsf_req_send(req);
+	if (retval)
+		goto failed_req_send;
+
+	goto out;
+
+failed_req_send:
+	mempool_free(sr_buf, adapter->pool.data_status_read);
+failed_buf:
+	zfcp_fsf_req_free(req);
+	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return retval;
+}
+
+static void zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_unit *unit = req->data;
+	union fsf_status_qual *fsq = &req->qtcb->header.fsf_status_qual;
+
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
+		return;
+
+	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
-			/*
-			 * In this case a command that was sent prior to a port
-			 * reopen was aborted (handles are different). This is
-			 * fine.
-			 */
-		} else {
-			/* Let's hope this sorts out the mess */
+		if (fsq->word[0] == fsq->word[1]) {
 			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
-						new_fsf_req);
-			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+						req);
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
-
 	case FSF_LUN_HANDLE_NOT_VALID:
-		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
-			/*
-			 * In this case a command that was sent prior to a unit
-			 * reopen was aborted (handles are different).
-			 * This is fine.
-			 */
-		} else {
-			/* Let's hope this sorts out the mess */
-			zfcp_erp_port_reopen(unit->port, 0, 105, new_fsf_req);
-			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		if (fsq->word[0] == fsq->word[1]) {
+			zfcp_erp_port_reopen(unit->port, 0, 105, req);
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
-
 	case FSF_FCP_COMMAND_DOES_NOT_EXIST:
-		retval = 0;
-		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
+		req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
 		break;
-
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 47, new_fsf_req);
-		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
-		    | ZFCP_STATUS_FSFREQ_RETRY;
+		zfcp_erp_port_boxed(unit->port, 47, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
-
 	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, 48, new_fsf_req);
-                new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
-                        | ZFCP_STATUS_FSFREQ_RETRY;
+		zfcp_erp_unit_boxed(unit, 48, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
                 break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		switch (new_fsf_req->qtcb->header.fsf_status_qual.word[0]) {
+		switch (fsq->word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			zfcp_test_link(unit->port);
-			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* SCSI stack will escalate */
-			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
-
 	case FSF_GOOD:
-		retval = 0;
-		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED;
+		req->status |= ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED;
 		break;
 	}
- skip_fsfstatus:
-	return retval;
 }
 
 /**
- * zfcp_use_one_sbal - checks whether req buffer and resp bother each fit into
- *	one SBALE
- * Two scatter-gather lists are passed, one for the reqeust and one for the
- * response.
+ * zfcp_fsf_abort_fcp_command - abort running SCSI command
+ * @old_req_id: unsigned long
+ * @adapter: pointer to struct zfcp_adapter
+ * @unit: pointer to struct zfcp_unit
+ * @req_flags: integer specifying the request flags
+ * Returns: pointer to struct zfcp_fsf_req
+ *
+ * FIXME(design): should be watched by a timeout !!!
  */
-static inline int
-zfcp_use_one_sbal(struct scatterlist *req, int req_count,
-                  struct scatterlist *resp, int resp_count)
-{
-        return ((req_count == 1) &&
-		(resp_count == 1) &&
-                (((unsigned long) zfcp_sg_to_address(&req[0]) &
-		  PAGE_MASK) ==
-		 ((unsigned long) (zfcp_sg_to_address(&req[0]) +
-				   req[0].length - 1) & PAGE_MASK)) &&
-                (((unsigned long) zfcp_sg_to_address(&resp[0]) &
-		  PAGE_MASK) ==
-                 ((unsigned long) (zfcp_sg_to_address(&resp[0]) +
-				   resp[0].length - 1) & PAGE_MASK)));
-}
 
-/**
- * zfcp_fsf_send_ct - initiate a Generic Service request (FC-GS)
- * @ct: pointer to struct zfcp_send_ct which conatins all needed data for
- *	the request
- * @pool: pointer to memory pool, if non-null this pool is used to allocate
- *	a struct zfcp_fsf_req
- * @erp_action: pointer to erp_action, if non-null the Generic Service request
- *	is sent within error recovery
- */
-int
-zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool,
-		 struct zfcp_erp_action *erp_action)
+struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
+						struct zfcp_adapter *adapter,
+						struct zfcp_unit *unit,
+						int req_flags)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_port *port;
-	struct zfcp_adapter *adapter;
-        struct zfcp_fsf_req *fsf_req;
-        unsigned long lock_flags;
-        int bytes;
-	int ret = 0;
-
-	port = ct->port;
-	adapter = port->adapter;
-
-	ret = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
-				  ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				  pool, &lock_flags, &fsf_req);
-	if (ret < 0)
-		goto failed_req;
-
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        if (zfcp_use_one_sbal(ct->req, ct->req_count,
-                              ct->resp, ct->resp_count)){
-                /* both request buffer and response buffer
-                   fit into one sbale each */
-                sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
-                sbale[2].addr = zfcp_sg_to_address(&ct->req[0]);
-                sbale[2].length = ct->req[0].length;
-                sbale[3].addr = zfcp_sg_to_address(&ct->resp[0]);
-                sbale[3].length = ct->resp[0].length;
-                sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
-	} else if (adapter->adapter_features &
-                   FSF_FEATURE_ELS_CT_CHAINED_SBALS) {
-                /* try to use chained SBALs */
-                bytes = zfcp_qdio_sbals_from_sg(fsf_req,
-                                                SBAL_FLAGS0_TYPE_WRITE_READ,
-						ct->req,
-                                                ZFCP_MAX_SBALS_PER_CT_REQ);
-                if (bytes <= 0) {
-                        if (bytes == 0)
-                                ret = -ENOMEM;
-                        else
-                                ret = bytes;
-
-                        goto failed_send;
-                }
-                fsf_req->qtcb->bottom.support.req_buf_length = bytes;
-                fsf_req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
-                bytes = zfcp_qdio_sbals_from_sg(fsf_req,
-                                                SBAL_FLAGS0_TYPE_WRITE_READ,
-						ct->resp,
-                                                ZFCP_MAX_SBALS_PER_CT_REQ);
-                if (bytes <= 0) {
-                        if (bytes == 0)
-                                ret = -ENOMEM;
-                        else
-                                ret = bytes;
+	struct zfcp_fsf_req *req = NULL;
 
-                        goto failed_send;
-                }
-                fsf_req->qtcb->bottom.support.resp_buf_length = bytes;
-        } else {
-                /* reject send generic request */
-                ret = -EOPNOTSUPP;
-                goto failed_send;
-        }
-
-	/* settings in QTCB */
-	fsf_req->qtcb->header.port_handle = port->handle;
-	fsf_req->qtcb->bottom.support.service_class =
-		ZFCP_FC_SERVICE_CLASS_DEFAULT;
-	fsf_req->qtcb->bottom.support.timeout = ct->timeout;
-        fsf_req->data = (unsigned long) ct;
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
+				  req_flags, adapter->pool.fsf_req_abort);
+	if (unlikely(IS_ERR(req)))
+		goto out;
 
-	zfcp_san_dbf_event_ct_request(fsf_req);
+	if (unlikely(!(atomic_read(&unit->status) &
+		       ZFCP_STATUS_COMMON_UNBLOCKED)))
+		goto out_error_free;
 
-	if (erp_action) {
-		erp_action->fsf_req = fsf_req;
-		fsf_req->erp_action = erp_action;
-		zfcp_erp_start_timer(fsf_req);
-	} else
-		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
+	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	ret = zfcp_fsf_req_send(fsf_req);
-	if (ret)
-		goto failed_send;
+	req->data = unit;
+	req->handler = zfcp_fsf_abort_fcp_command_handler;
+	req->qtcb->header.lun_handle = unit->handle;
+	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->bottom.support.req_handle = (u64) old_req_id;
 
-	goto out;
+	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
+	if (!zfcp_fsf_req_send(req))
+		goto out;
 
- failed_send:
-	zfcp_fsf_req_free(fsf_req);
-        if (erp_action != NULL) {
-                erp_action->fsf_req = NULL;
-        }
- failed_req:
- out:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return ret;
+out_error_free:
+	zfcp_fsf_req_free(req);
+	req = NULL;
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return req;
 }
 
-/**
- * zfcp_fsf_send_ct_handler - handler for Generic Service requests
- * @fsf_req: pointer to struct zfcp_fsf_req
- *
- * Data specific for the Generic Service request is passed using
- * fsf_req->data. There we find the pointer to struct zfcp_send_ct.
- * Usually a specific handler for the CT request is called which is
- * found in this structure.
- */
-static int
-zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_port *port;
-	struct zfcp_adapter *adapter;
-	struct zfcp_send_ct *send_ct;
-	struct fsf_qtcb_header *header;
-	struct fsf_qtcb_bottom_support *bottom;
-	int retval = -EINVAL;
+	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_send_ct *send_ct = req->data;
+	struct zfcp_port *port = send_ct->port;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
 
-	adapter = fsf_req->adapter;
-	send_ct = (struct zfcp_send_ct *) fsf_req->data;
-	port = send_ct->port;
-	header = &fsf_req->qtcb->header;
-	bottom = &fsf_req->qtcb->bottom.support;
+	send_ct->status = -EINVAL;
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
-	/* evaluate FSF status in QTCB */
 	switch (header->fsf_status) {
-
         case FSF_GOOD:
-		zfcp_san_dbf_event_ct_response(fsf_req);
-                retval = 0;
+		zfcp_san_dbf_event_ct_response(req);
+		send_ct->status = 0;
 		break;
-
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		zfcp_fsf_class_not_supp(fsf_req);
+		zfcp_fsf_class_not_supp(req);
 		break;
-
         case FSF_ADAPTER_STATUS_AVAILABLE:
                 switch (header->fsf_status_qual.word[0]){
                 case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* reopening link to port */
 			zfcp_test_link(port);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
                 case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
                 }
                 break;
-
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(fsf_req, port);
-		break;
-
-        case FSF_GENERIC_COMMAND_REJECTED:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_fsf_access_denied_port(req, port);
 		break;
-
-        case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(adapter, 0, 106, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
         case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, 49, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
-		    | ZFCP_STATUS_FSFREQ_RETRY;
+		zfcp_erp_port_boxed(port, 49, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
-
-	/* following states should never occure, all cases avoided
-	   in zfcp_fsf_send_ct - but who knows ... */
+	case FSF_PORT_HANDLE_NOT_VALID:
+		zfcp_erp_adapter_reopen(adapter, 0, 106, req);
+	case FSF_GENERIC_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
 	case FSF_REQUEST_SIZE_TOO_LARGE:
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
 	case FSF_SBAL_MISMATCH:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-       default:
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
 
 skip_fsfstatus:
-	send_ct->status = retval;
-
-	if (send_ct->handler != NULL)
+	if (send_ct->handler)
 		send_ct->handler(send_ct->handler_data);
+}
 
-	return retval;
+static int zfcp_fsf_setup_sbals(struct zfcp_fsf_req *req,
+				struct scatterlist *sg_req,
+				struct scatterlist *sg_resp, int max_sbals)
+{
+	int bytes;
+
+	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
+					sg_req, max_sbals);
+	if (bytes <= 0)
+		return -ENOMEM;
+	req->qtcb->bottom.support.req_buf_length = bytes;
+	req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
+
+	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
+					sg_resp, max_sbals);
+	if (bytes <= 0)
+		return -ENOMEM;
+	req->qtcb->bottom.support.resp_buf_length = bytes;
+
+	return 0;
 }
 
 /**
- * zfcp_fsf_send_els - initiate an ELS command (FC-FS)
- * @els: pointer to struct zfcp_send_els which contains all needed data for
- *	the command.
- */
-int
-zfcp_fsf_send_els(struct zfcp_send_els *els)
-{
-	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	u32 d_id;
-	struct zfcp_adapter *adapter;
-	unsigned long lock_flags;
-        int bytes;
-	int ret = 0;
+ * zfcp_fsf_send_ct - initiate a Generic Service request (FC-GS)
+ * @ct: pointer to struct zfcp_send_ct with data for request
+ * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
+ * @erp_action: if non-null the Generic Service request sent within ERP
+ */
+int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool,
+		     struct zfcp_erp_action *erp_action)
+{
+	struct zfcp_port *port = ct->port;
+	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_fsf_req *req;
+	int ret = -EIO;
 
-	d_id = els->d_id;
-	adapter = els->adapter;
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
 
-        ret = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
-				  ZFCP_REQ_AUTO_CLEANUP,
-				  NULL, &lock_flags, &fsf_req);
-	if (ret < 0)
-                goto failed_req;
-
-	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-			&els->port->status))) {
-		ret = -EBUSY;
-		goto port_blocked;
-	}
-
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        if (zfcp_use_one_sbal(els->req, els->req_count,
-                              els->resp, els->resp_count)){
-                /* both request buffer and response buffer
-                   fit into one sbale each */
-                sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
-                sbale[2].addr = zfcp_sg_to_address(&els->req[0]);
-                sbale[2].length = els->req[0].length;
-                sbale[3].addr = zfcp_sg_to_address(&els->resp[0]);
-                sbale[3].length = els->resp[0].length;
-                sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
-	} else if (adapter->adapter_features &
-                   FSF_FEATURE_ELS_CT_CHAINED_SBALS) {
-                /* try to use chained SBALs */
-                bytes = zfcp_qdio_sbals_from_sg(fsf_req,
-                                                SBAL_FLAGS0_TYPE_WRITE_READ,
-						els->req,
-                                                ZFCP_MAX_SBALS_PER_ELS_REQ);
-                if (bytes <= 0) {
-                        if (bytes == 0) {
-                                ret = -ENOMEM;
-                        } else {
-                                ret = bytes;
-                        }
-                        goto failed_send;
-                }
-                fsf_req->qtcb->bottom.support.req_buf_length = bytes;
-                fsf_req->sbale_curr = ZFCP_LAST_SBALE_PER_SBAL;
-                bytes = zfcp_qdio_sbals_from_sg(fsf_req,
-                                                SBAL_FLAGS0_TYPE_WRITE_READ,
-						els->resp,
-                                                ZFCP_MAX_SBALS_PER_ELS_REQ);
-                if (bytes <= 0) {
-                        if (bytes == 0) {
-                                ret = -ENOMEM;
-                        } else {
-                                ret = bytes;
-                        }
-                        goto failed_send;
-                }
-                fsf_req->qtcb->bottom.support.resp_buf_length = bytes;
-        } else {
-                /* reject request */
-                ret = -EOPNOTSUPP;
-                goto failed_send;
-        }
-
-	/* settings in QTCB */
-	fsf_req->qtcb->bottom.support.d_id = d_id;
-	fsf_req->qtcb->bottom.support.service_class =
-		ZFCP_FC_SERVICE_CLASS_DEFAULT;
-	fsf_req->qtcb->bottom.support.timeout = ZFCP_ELS_TIMEOUT;
-	fsf_req->data = (unsigned long) els;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_GENERIC,
+				  ZFCP_REQ_AUTO_CLEANUP, pool);
+	if (unlikely(IS_ERR(req))) {
+		ret = PTR_ERR(req);
+		goto out;
+	}
+
+	ret = zfcp_fsf_setup_sbals(req, ct->req, ct->resp,
+				   FSF_MAX_SBALS_PER_REQ);
+	if (ret)
+		goto failed_send;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	req->handler = zfcp_fsf_send_ct_handler;
+	req->qtcb->header.port_handle = port->handle;
+	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
+	req->qtcb->bottom.support.timeout = ct->timeout;
+	req->data = ct;
 
-	zfcp_san_dbf_event_els_request(fsf_req);
+	zfcp_san_dbf_event_ct_request(req);
+
+	if (erp_action) {
+		erp_action->fsf_req = req;
+		req->erp_action = erp_action;
+		zfcp_erp_start_timer(req);
+	} else
+		zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
-	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
-	ret = zfcp_fsf_req_send(fsf_req);
+	ret = zfcp_fsf_req_send(req);
 	if (ret)
 		goto failed_send;
 
 	goto out;
 
- port_blocked:
- failed_send:
-	zfcp_fsf_req_free(fsf_req);
-
- failed_req:
- out:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-
-        return ret;
+failed_send:
+	zfcp_fsf_req_free(req);
+	if (erp_action)
+		erp_action->fsf_req = NULL;
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return ret;
 }
 
-/**
- * zfcp_fsf_send_els_handler - handler for ELS commands
- * @fsf_req: pointer to struct zfcp_fsf_req
- *
- * Data specific for the ELS command is passed using
- * fsf_req->data. There we find the pointer to struct zfcp_send_els.
- * Usually a specific handler for the ELS command is called which is
- * found in this structure.
- */
-static int zfcp_fsf_send_els_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	u32 d_id;
-	struct fsf_qtcb_header *header;
-	struct fsf_qtcb_bottom_support *bottom;
-	struct zfcp_send_els *send_els;
-	int retval = -EINVAL;
+	struct zfcp_send_els *send_els = req->data;
+	struct zfcp_port *port = send_els->port;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
 
-	send_els = (struct zfcp_send_els *) fsf_req->data;
-	adapter = send_els->adapter;
-	port = send_els->port;
-	d_id = send_els->d_id;
-	header = &fsf_req->qtcb->header;
-	bottom = &fsf_req->qtcb->bottom.support;
+	send_els->status = -EINVAL;
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
 
 	switch (header->fsf_status) {
-
 	case FSF_GOOD:
-		zfcp_san_dbf_event_els_response(fsf_req);
-		retval = 0;
+		zfcp_san_dbf_event_els_response(req);
+		send_els->status = 0;
 		break;
-
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		zfcp_fsf_class_not_supp(fsf_req);
+		zfcp_fsf_class_not_supp(req);
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
 				zfcp_test_link(port);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
+			/*fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
 		case FSF_SQ_RETRY_IF_POSSIBLE:
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
-
 	case FSF_ELS_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
 	case FSF_REQUEST_SIZE_TOO_LARGE:
 	case FSF_RESPONSE_SIZE_TOO_LARGE:
 		break;
-
+	case FSF_ACCESS_DENIED:
+		zfcp_fsf_access_denied_port(req, port);
+		break;
 	case FSF_SBAL_MISMATCH:
 		/* should never occure, avoided in zfcp_fsf_send_els */
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		/* fall through */
+	default:
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
+	}
+skip_fsfstatus:
+	if (send_els->handler)
+		send_els->handler(send_els->handler_data);
+}
 
-	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(fsf_req, port);
-		break;
+/**
+ * zfcp_fsf_send_els - initiate an ELS command (FC-FS)
+ * @els: pointer to struct zfcp_send_els with data for the command
+ */
+int zfcp_fsf_send_els(struct zfcp_send_els *els)
+{
+	struct zfcp_fsf_req *req;
+	struct zfcp_adapter *adapter = els->adapter;
+	struct fsf_qtcb_bottom_support *bottom;
+	int ret = -EIO;
 
-	default:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
+	if (unlikely(!(atomic_read(&els->port->status) &
+		       ZFCP_STATUS_COMMON_UNBLOCKED)))
+		return -EBUSY;
+
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
+				  ZFCP_REQ_AUTO_CLEANUP, NULL);
+	if (unlikely(IS_ERR(req))) {
+		ret = PTR_ERR(req);
+		goto out;
 	}
 
-skip_fsfstatus:
-	send_els->status = retval;
+	ret = zfcp_fsf_setup_sbals(req, els->req, els->resp,
+				   FSF_MAX_SBALS_PER_ELS_REQ);
+	if (ret)
+		goto failed_send;
+
+	bottom = &req->qtcb->bottom.support;
+	req->handler = zfcp_fsf_send_els_handler;
+	bottom->d_id = els->d_id;
+	bottom->service_class = FSF_CLASS_3;
+	bottom->timeout = 2 * R_A_TOV;
+	req->data = els;
+
+	zfcp_san_dbf_event_els_request(req);
+
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	ret = zfcp_fsf_req_send(req);
+	if (ret)
+		goto failed_send;
 
-	if (send_els->handler)
-		send_els->handler(send_els->handler_data);
+	goto out;
 
-	return retval;
+failed_send:
+	zfcp_fsf_req_free(req);
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return ret;
 }
 
-int
-zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
+	struct zfcp_fsf_req *req;
 	struct zfcp_adapter *adapter = erp_action->adapter;
-	unsigned long lock_flags;
-	int retval;
+	int retval = -EIO;
 
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter,
-				     FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				     ZFCP_REQ_AUTO_CLEANUP,
-				     adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval) {
-		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-		return retval;
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter,
+				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	fsf_req->qtcb->bottom.config.feature_selection =
+	req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_CFDC |
 			FSF_FEATURE_LUN_SHARING |
 			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
+	req->erp_action = erp_action;
+	req->handler = zfcp_fsf_exchange_config_data_handler;
+	erp_action->fsf_req = req;
 
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
 	}
-
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-int
-zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
-				struct fsf_qtcb_bottom_config *data)
+int zfcp_fsf_exchange_config_data_sync(struct zfcp_adapter *adapter,
+				       struct fsf_qtcb_bottom_config *data)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				     ZFCP_WAIT_FOR_SBAL, NULL, &lock_flags,
-				     &fsf_req);
-	if (retval) {
-		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-		return retval;
+	struct zfcp_fsf_req *req = NULL;
+	int retval = -EIO;
+
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
+				  0, NULL);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	req->handler = zfcp_fsf_exchange_config_data_handler;
 
-	fsf_req->qtcb->bottom.config.feature_selection =
+	req->qtcb->bottom.config.feature_selection =
 			FSF_FEATURE_CFDC |
 			FSF_FEATURE_LUN_SHARING |
 			FSF_FEATURE_NOTIFICATION_LOST |
 			FSF_FEATURE_UPDATE_ALERT;
 
 	if (data)
-		fsf_req->data = (unsigned long) data;
+		req->data = data;
 
-	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
-	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(req);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	if (!retval)
-		wait_event(fsf_req->completion_wq,
-			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		wait_event(req->completion_wq,
+			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	zfcp_fsf_req_free(fsf_req);
+	zfcp_fsf_req_free(req);
 
 	return retval;
 }
 
 /**
- * zfcp_fsf_exchange_config_evaluate
- * @fsf_req: fsf_req which belongs to xchg config data request
- * @xchg_ok: specifies if xchg config data was incomplete or complete (0/1)
- *
- * returns: -EIO on error, 0 otherwise
- */
-static int
-zfcp_fsf_exchange_config_evaluate(struct zfcp_fsf_req *fsf_req, int xchg_ok)
-{
-	struct fsf_qtcb_bottom_config *bottom;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct Scsi_Host *shost = adapter->scsi_host;
-
-	bottom = &fsf_req->qtcb->bottom.config;
-	adapter->fsf_lic_version = bottom->lic_version;
-	adapter->adapter_features = bottom->adapter_features;
-	adapter->connection_features = bottom->connection_features;
-	adapter->peer_wwpn = 0;
-	adapter->peer_wwnn = 0;
-	adapter->peer_d_id = 0;
-
-	if (xchg_ok) {
-
-		if (fsf_req->data)
-			memcpy((struct fsf_qtcb_bottom_config *) fsf_req->data,
-				bottom, sizeof (struct fsf_qtcb_bottom_config));
-
-		fc_host_node_name(shost) = bottom->nport_serv_param.wwnn;
-		fc_host_port_name(shost) = bottom->nport_serv_param.wwpn;
-		fc_host_port_id(shost) = bottom->s_id & ZFCP_DID_MASK;
-		fc_host_speed(shost) = bottom->fc_link_speed;
-		fc_host_supported_classes(shost) =
-				FC_COS_CLASS2 | FC_COS_CLASS3;
-		adapter->hydra_version = bottom->adapter_type;
-		adapter->timer_ticks = bottom->timer_interval;
-		if (fc_host_permanent_port_name(shost) == -1)
-			fc_host_permanent_port_name(shost) =
-				fc_host_port_name(shost);
-		if (bottom->fc_topology == FSF_TOPO_P2P) {
-			adapter->peer_d_id = bottom->peer_d_id & ZFCP_DID_MASK;
-			adapter->peer_wwpn = bottom->plogi_payload.wwpn;
-			adapter->peer_wwnn = bottom->plogi_payload.wwnn;
-			fc_host_port_type(shost) = FC_PORTTYPE_PTP;
-		} else if (bottom->fc_topology == FSF_TOPO_FABRIC)
-			fc_host_port_type(shost) = FC_PORTTYPE_NPORT;
-		else if (bottom->fc_topology == FSF_TOPO_AL)
-			fc_host_port_type(shost) = FC_PORTTYPE_NLPORT;
-		else
-			fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-	} else {
-		fc_host_node_name(shost) = 0;
-		fc_host_port_name(shost) = 0;
-		fc_host_port_id(shost) = 0;
-		fc_host_speed(shost) = FC_PORTSPEED_UNKNOWN;
-		fc_host_port_type(shost) = FC_PORTTYPE_UNKNOWN;
-		adapter->hydra_version = 0;
-	}
-
-	if (adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT) {
-		adapter->hardware_version = bottom->hardware_version;
-		memcpy(fc_host_serial_number(shost), bottom->serial_number,
-		       min(FC_SERIAL_NUMBER_SIZE, 17));
-		EBCASC(fc_host_serial_number(shost),
-		       min(FC_SERIAL_NUMBER_SIZE, 17));
-	}
-
-	if (ZFCP_QTCB_VERSION < bottom->low_qtcb_version) {
-		dev_err(&adapter->ccw_device->dev,
-			"The adapter only supports newer control block "
-			"versions, try updated device driver.\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 125, fsf_req);
-		return -EIO;
-	}
-	if (ZFCP_QTCB_VERSION > bottom->high_qtcb_version) {
-		dev_err(&adapter->ccw_device->dev,
-			"The adapter only supports older control block "
-			"versions, consider a microcode upgrade.\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 126, fsf_req);
-		return -EIO;
-	}
-	return 0;
-}
-
-/**
- * function:    zfcp_fsf_exchange_config_data_handler
- *
- * purpose:     is called for finished Exchange Configuration Data command
- *
- * returns:
- */
-static int
-zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *fsf_req)
-{
-	struct fsf_qtcb_bottom_config *bottom;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fsf_qtcb *qtcb = fsf_req->qtcb;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		return -EIO;
-
-	switch (qtcb->header.fsf_status) {
-
-	case FSF_GOOD:
-		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 1))
-			return -EIO;
-
-		switch (fc_host_port_type(adapter->scsi_host)) {
-		case FC_PORTTYPE_PTP:
-			if (fsf_req->erp_action)
-				dev_info(&adapter->ccw_device->dev,
-					 "Point-to-Point fibrechannel "
-					 "configuration detected.\n");
-			break;
-		case FC_PORTTYPE_NLPORT:
-			dev_err(&adapter->ccw_device->dev,
-				"Unsupported arbitrated loop fibrechannel "
-				"topology detected, shutting down adapter\n");
-			zfcp_erp_adapter_shutdown(adapter, 0, 127, fsf_req);
-			return -EIO;
-		case FC_PORTTYPE_NPORT:
-			if (fsf_req->erp_action)
-				dev_info(&adapter->ccw_device->dev,
-					 "Switched fabric fibrechannel "
-					 "network detected.\n");
-			break;
-		default:
-			dev_err(&adapter->ccw_device->dev,
-				"The fibrechannel topology reported by the "
-				"adapter is not known by the zfcp driver, "
-				"shutting down adapter.\n");
-			zfcp_erp_adapter_shutdown(adapter, 0, 128, fsf_req);
-			return -EIO;
-		}
-		bottom = &qtcb->bottom.config;
-		if (bottom->max_qtcb_size < sizeof(struct fsf_qtcb)) {
-			dev_err(&adapter->ccw_device->dev,
-				"Maximum QTCB size (%d bytes) allowed by "
-				"the adapter is lower than the minimum "
-				"required by the driver (%ld bytes).\n",
-				bottom->max_qtcb_size, sizeof(struct fsf_qtcb));
-			zfcp_erp_adapter_shutdown(adapter, 0, 129, fsf_req);
-			return -EIO;
-		}
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
-				&adapter->status);
-		break;
-	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
-		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 0))
-			return -EIO;
-
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
-				&adapter->status);
-
-		zfcp_fsf_link_down_info_eval(fsf_req, 42,
-			&qtcb->header.fsf_status_qual.link_down_info);
-		break;
-	default:
-		zfcp_erp_adapter_shutdown(adapter, 0, 130, fsf_req);
-		return -EIO;
-	}
-	return 0;
-}
-
-/**
  * zfcp_fsf_exchange_port_data - request information about local port
  * @erp_action: ERP action for the adapter for which port data is requested
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_exchange_port_data(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
+	struct zfcp_fsf_req *req;
 	struct zfcp_adapter *adapter = erp_action->adapter;
-	unsigned long lock_flags;
-	int retval;
+	int retval = -EIO;
 
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
-				     ZFCP_REQ_AUTO_CLEANUP,
-				     adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval) {
-		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-		return retval;
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
 	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	erp_action->fsf_req = fsf_req;
-	fsf_req->erp_action = erp_action;
-	zfcp_erp_start_timer(fsf_req);
-
-	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
+	req->handler = zfcp_fsf_exchange_port_data_handler;
+	req->erp_action = erp_action;
+	erp_action->fsf_req = req;
 
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
 	}
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-
 /**
  * zfcp_fsf_exchange_port_data_sync - request information about local port
- * and wait until information is ready
+ * @adapter: pointer to struct zfcp_adapter
+ * @data: pointer to struct fsf_qtcb_bottom_port
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
-				struct fsf_qtcb_bottom_port *data)
+int zfcp_fsf_exchange_port_data_sync(struct zfcp_adapter *adapter,
+				     struct fsf_qtcb_bottom_port *data)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval;
+	struct zfcp_fsf_req *req = NULL;
+	int retval = -EIO;
 
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
-				0, NULL, &lock_flags, &fsf_req);
-	if (retval) {
-		write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-		return retval;
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA, 0,
+				  NULL);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
 	}
 
 	if (data)
-		fsf_req->data = (unsigned long) data;
+		req->data = data;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
-	retval = zfcp_fsf_req_send(fsf_req);
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-
+	req->handler = zfcp_fsf_exchange_port_data_handler;
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(req);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	if (!retval)
-		wait_event(fsf_req->completion_wq,
-			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-
-	zfcp_fsf_req_free(fsf_req);
-
-	return retval;
-}
-
-/**
- * zfcp_fsf_exchange_port_evaluate
- * @fsf_req: fsf_req which belongs to xchg port data request
- * @xchg_ok: specifies if xchg port data was incomplete or complete (0/1)
- */
-static void
-zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *fsf_req, int xchg_ok)
-{
-	struct zfcp_adapter *adapter;
-	struct fsf_qtcb_bottom_port *bottom;
-	struct Scsi_Host *shost;
-
-	adapter = fsf_req->adapter;
-	bottom = &fsf_req->qtcb->bottom.port;
-	shost = adapter->scsi_host;
-
-	if (fsf_req->data)
-		memcpy((struct fsf_qtcb_bottom_port*) fsf_req->data, bottom,
-			sizeof(struct fsf_qtcb_bottom_port));
-
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
-		fc_host_permanent_port_name(shost) = bottom->wwpn;
-	else
-		fc_host_permanent_port_name(shost) = fc_host_port_name(shost);
-	fc_host_maxframe_size(shost) = bottom->maximum_frame_size;
-	fc_host_supported_speeds(shost) = bottom->supported_speed;
-}
-
-/**
- * zfcp_fsf_exchange_port_data_handler - handler for exchange_port_data request
- * @fsf_req: pointer to struct zfcp_fsf_req
- */
-static void
-zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *fsf_req)
-{
-	struct zfcp_adapter *adapter;
-	struct fsf_qtcb *qtcb;
-
-	adapter = fsf_req->adapter;
-	qtcb = fsf_req->qtcb;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		return;
-
-	switch (qtcb->header.fsf_status) {
-        case FSF_GOOD:
-		zfcp_fsf_exchange_port_evaluate(fsf_req, 1);
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-		break;
-	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
-		zfcp_fsf_exchange_port_evaluate(fsf_req, 0);
-		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-		zfcp_fsf_link_down_info_eval(fsf_req, 43,
-			&qtcb->header.fsf_status_qual.link_down_info);
-                break;
-	}
-}
-
-
-/*
- * function:    zfcp_fsf_open_port
- *
- * purpose:
- *
- * returns:	address of initiated FSF request
- *		NULL - request could not be initiated
- */
-int
-zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
-{
-	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(erp_action->adapter,
-				     FSF_QTCB_OPEN_PORT_WITH_DID,
-				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
-		goto out;
-
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-        sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
-
-	fsf_req->qtcb->bottom.support.d_id = erp_action->port->d_id;
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
-	fsf_req->data = (unsigned long) erp_action->port;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
-
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
-		erp_action->fsf_req = NULL;
-		goto out;
-	}
+		wait_event(req->completion_wq,
+			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+	zfcp_fsf_req_free(req);
 
- out:
-	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_open_port_handler
- *
- * purpose:	is called for finished Open Port command
- *
- * returns:
- */
-static int
-zfcp_fsf_open_port_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 {
-	int retval = -EINVAL;
-	struct zfcp_port *port;
+	struct zfcp_port *port = req->data;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct fsf_plogi *plogi;
-	struct fsf_qtcb_header *header;
-
-	port = (struct zfcp_port *) fsf_req->data;
-	header = &fsf_req->qtcb->header;
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* don't change port status in our bookkeeping */
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
-	}
 
-	/* evaluate FSF status in QTCB */
 	switch (header->fsf_status) {
-
 	case FSF_PORT_ALREADY_OPEN:
-		/*
-		 * This is a bug, however operation should continue normally
-		 * if it is simply ignored
-		 */
 		break;
-
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(fsf_req, port);
+		zfcp_fsf_access_denied_port(req, port);
 		break;
-
 	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&req->adapter->ccw_device->dev,
 			 "The adapter is out of resources. The remote port "
 			 "0x%016Lx could not be opened, disabling it.\n",
 			 port->wwpn);
-		zfcp_erp_port_failed(port, 31, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_port_failed(port, 31, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
-			dev_warn(&fsf_req->adapter->ccw_device->dev,
+			dev_warn(&req->adapter->ccw_device->dev,
 				 "The remote port 0x%016Lx could not be "
 				 "opened. Disabling it.\n", port->wwpn);
-			zfcp_erp_port_failed(port, 32, fsf_req);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
-		default:
+			zfcp_erp_port_failed(port, 32, req);
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
-
 	case FSF_GOOD:
-		/* save port handle assigned by FSF */
 		port->handle = header->port_handle;
-		/* mark port as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
 		                  &port->status);
-		retval = 0;
 		/* check whether D_ID has changed during open */
 		/*
 		 * FIXME: This check is not airtight, as the FCP channel does
@@ -2021,227 +1471,168 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		 * another GID_PN straight after a port has been opened.
 		 * Alternately, an ADISC/PDISC ELS should suffice, as well.
 		 */
-		plogi = (struct fsf_plogi *) fsf_req->qtcb->bottom.support.els;
-		if (!atomic_test_mask(ZFCP_STATUS_PORT_NO_WWPN, &port->status))
-		{
-			if (fsf_req->qtcb->bottom.support.els1_length <
-			    sizeof (struct fsf_plogi)) {
-				/* skip sanity check and assume wwpn is ok */
-			} else {
-				if (plogi->serv_param.wwpn != port->wwpn) {
-					atomic_clear_mask(
-						ZFCP_STATUS_PORT_DID_DID,
-						&port->status);
-				} else {
-					port->wwnn = plogi->serv_param.wwnn;
-					zfcp_fc_plogi_evaluate(port, plogi);
-				}
+		if (atomic_read(&port->status) & ZFCP_STATUS_PORT_NO_WWPN)
+			break;
+
+		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
+		if (req->qtcb->bottom.support.els1_length >= sizeof(*plogi)) {
+			if (plogi->serv_param.wwpn != port->wwpn)
+				atomic_clear_mask(ZFCP_STATUS_PORT_DID_DID,
+						  &port->status);
+			else {
+				port->wwnn = plogi->serv_param.wwnn;
+				zfcp_fc_plogi_evaluate(port, plogi);
 			}
 		}
 		break;
-
 	case FSF_UNKNOWN_OP_SUBTYPE:
-		/* should never occure, subtype not set in zfcp_fsf_open_port */
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	default:
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
 
- skip_fsfstatus:
+skip_fsfstatus:
 	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &port->status);
-	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_port
- *
- * purpose:     submit FSF command "close port"
- *
- * returns:     address of initiated FSF request
- *              NULL - request could not be initiated
+/**
+ * zfcp_fsf_open_port - create and send open port request
+ * @erp_action: pointer to struct zfcp_erp_action
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_open_port(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(erp_action->adapter,
-				     FSF_QTCB_CLOSE_PORT,
-				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter,
+				  FSF_QTCB_OPEN_PORT_WITH_DID,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
 		goto out;
+	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
-	fsf_req->data = (unsigned long) erp_action->port;
-	fsf_req->erp_action = erp_action;
-	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
+	req->handler = zfcp_fsf_open_port_handler;
+	req->qtcb->bottom.support.d_id = erp_action->port->d_id;
+	req->data = erp_action->port;
+	req->erp_action = erp_action;
+	erp_action->fsf_req = req;
+	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
 
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(fsf_req);
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
-		goto out;
 	}
-
- out:
-	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_port_handler
- *
- * purpose:     is called for finished Close Port FSF command
- *
- * returns:
- */
-static int
-zfcp_fsf_close_port_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_close_port_handler(struct zfcp_fsf_req *req)
 {
-	int retval = -EINVAL;
-	struct zfcp_port *port;
-
-	port = (struct zfcp_port *) fsf_req->data;
+	struct zfcp_port *port = req->data;
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* don't change port status in our bookkeeping */
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
-	}
-
-	/* evaluate FSF status in QTCB */
-	switch (fsf_req->qtcb->header.fsf_status) {
 
+	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, 107, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_adapter_reopen(port->adapter, 0, 107, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		/* Note: FSF has actually closed the port in this case.
-		 * The status code is just daft. Fingers crossed for a change
-		 */
-		retval = 0;
 		break;
-
 	case FSF_GOOD:
-		zfcp_erp_modify_port_status(port, 33, fsf_req,
+		zfcp_erp_modify_port_status(port, 33, req,
 					    ZFCP_STATUS_COMMON_OPEN,
 					    ZFCP_CLEAR);
-		retval = 0;
 		break;
 	}
 
- skip_fsfstatus:
+skip_fsfstatus:
 	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &port->status);
-	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_physical_port
- *
- * purpose:     submit FSF command "close physical port"
- *
- * returns:     address of initiated FSF request
- *              NULL - request could not be initiated
+/**
+ * zfcp_fsf_close_port - create and send close port request
+ * @erp_action: pointer to struct zfcp_erp_action
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_close_port(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(erp_action->adapter,
-				     FSF_QTCB_CLOSE_PHYSICAL_PORT,
-				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
 		goto out;
+	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
 	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	/* mark port as being closed */
-	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
-			&erp_action->port->status);
-	/* save a pointer to this port */
-	fsf_req->data = (unsigned long) erp_action->port;
-	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
+	req->handler = zfcp_fsf_close_port_handler;
+	req->data = erp_action->port;
+	req->erp_action = erp_action;
+	req->qtcb->header.port_handle = erp_action->port->handle;
+	erp_action->fsf_req = req;
+	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
 
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(fsf_req);
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
-		goto out;
 	}
-
- out:
-	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_physical_port_handler
- *
- * purpose:     is called for finished Close Physical Port FSF command
- *
- * returns:
- */
-static int
-zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *req)
 {
-	int retval = -EINVAL;
-	struct zfcp_port *port;
+	struct zfcp_port *port = req->data;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct zfcp_unit *unit;
-	struct fsf_qtcb_header *header;
 
-	port = (struct zfcp_port *) fsf_req->data;
-	header = &fsf_req->qtcb->header;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* don't change port status in our bookkeeping */
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
-	}
 
-	/* evaluate FSF status in QTCB */
 	switch (header->fsf_status) {
-
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, 108, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_adapter_reopen(port->adapter, 0, 108, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(fsf_req, port);
+		zfcp_fsf_access_denied_port(req, port);
 		break;
-
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, 50, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY;
-
+		zfcp_erp_port_boxed(port, 50, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
@@ -2249,120 +1640,88 @@ zfcp_fsf_close_physical_port_handler(str
 			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 					  &unit->status);
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* This will now be escalated by ERP */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
+			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
-
 	case FSF_GOOD:
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port
 		 */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		list_for_each_entry(unit, &port->unit_list_head, list)
-		    atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
-		retval = 0;
+			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+					  &unit->status);
 		break;
 	}
-
- skip_fsfstatus:
+skip_fsfstatus:
 	atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_CLOSING, &port->status);
-	return retval;
 }
 
-/*
- * function:    zfcp_fsf_open_unit
- *
- * purpose:
- *
- * returns:
- *
- * assumptions:	This routine does not check whether the associated
- *		remote port has already been opened. This should be
- *		done by calling routines. Otherwise some status
- *		may be presented by FSF
+/**
+ * zfcp_fsf_close_physical_port - close physical port
+ * @erp_action: pointer to struct zfcp_erp_action
+ * Returns: 0 on success
  */
-int
-zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_close_physical_port(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(erp_action->adapter,
-				     FSF_QTCB_OPEN_LUN,
-				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-        sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
-        sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
+	}
 
-	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
-	fsf_req->qtcb->bottom.support.fcp_lun =	erp_action->unit->fcp_lun;
-	if (!(erp_action->adapter->connection_features & FSF_FEATURE_NPIV_MODE))
-		fsf_req->qtcb->bottom.support.option =
-			FSF_OPEN_LUN_SUPPRESS_BOXING;
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
-	fsf_req->data = (unsigned long) erp_action->unit;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
+	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(erp_action->fsf_req);
+	req->data = erp_action->port;
+	req->qtcb->header.port_handle = erp_action->port->handle;
+	req->erp_action = erp_action;
+	req->handler = zfcp_fsf_close_physical_port_handler;
+	erp_action->fsf_req = req;
+	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
+			&erp_action->port->status);
+
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
-		goto out;
 	}
- out:
-	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_open_unit_handler
- *
- * purpose:	is called for finished Open LUN command
- *
- * returns:
- */
-static int
-zfcp_fsf_open_unit_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_open_unit_handler(struct zfcp_fsf_req *req)
 {
-	int retval = -EINVAL;
-	struct zfcp_adapter *adapter;
-	struct zfcp_unit *unit;
-	struct fsf_qtcb_header *header;
-	struct fsf_qtcb_bottom_support *bottom;
-	struct fsf_queue_designator *queue_designator;
+	struct zfcp_adapter *adapter = req->adapter;
+	struct zfcp_unit *unit = req->data;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
+	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
+	struct fsf_queue_designator *queue_designator =
+				&header->fsf_status_qual.fsf_queue_designator;
 	int exclusive, readwrite;
 
-	unit = (struct zfcp_unit *) fsf_req->data;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* don't change unit status in our bookkeeping */
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
-	}
-
-	adapter = fsf_req->adapter;
-	header = &fsf_req->qtcb->header;
-	bottom = &fsf_req->qtcb->bottom.support;
-	queue_designator = &header->fsf_status_qual.fsf_queue_designator;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
@@ -2370,32 +1729,25 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			  ZFCP_STATUS_UNIT_READONLY,
 			  &unit->status);
 
-	/* evaluate FSF status in QTCB */
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109, req);
+		/* fall through */
 	case FSF_LUN_ALREADY_OPEN:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_unit(fsf_req, unit);
+		zfcp_fsf_access_denied_unit(req, unit);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		break;
-
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 51, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY;
+		zfcp_erp_port_boxed(unit->port, 51, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
-
 	case FSF_LUN_SHARING_VIOLATION:
-		if (header->fsf_status_qual.word[0] != 0) {
+		if (header->fsf_status_qual.word[0])
 			dev_warn(&adapter->ccw_device->dev,
 				 "FCP-LUN 0x%Lx at the remote port "
 				 "with WWPN 0x%Lx "
@@ -2405,47 +1757,37 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 				 unit->port->wwpn,
 				 queue_designator->hla,
 				 queue_designator->cssid);
-		} else
+		else
 			zfcp_act_eval_err(adapter,
 					  header->fsf_status_qual.word[2]);
-		zfcp_erp_unit_access_denied(unit, 60, fsf_req);
+		zfcp_erp_unit_access_denied(unit, 60, req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
-		dev_warn(&fsf_req->adapter->ccw_device->dev,
+		dev_warn(&adapter->ccw_device->dev,
 			 "The adapter ran out of resources. There is no "
 			 "handle available for unit 0x%016Lx on port 0x%016Lx.",
 			 unit->fcp_lun, unit->port->wwpn);
-		zfcp_erp_unit_failed(unit, 34, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_unit_failed(unit, 34, req);
+		/* fall through */
+	case FSF_INVALID_COMMAND_OPTION:
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* Re-establish link to port */
 			zfcp_test_link(unit->port);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
+			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
 
-	case FSF_INVALID_COMMAND_OPTION:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		retval = -EINVAL;
-		break;
-
 	case FSF_GOOD:
-		/* save LUN handle assigned by FSF */
 		unit->handle = header->lun_handle;
-		/* mark unit as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
 
 		if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE) &&
@@ -2463,635 +1805,256 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			if (!readwrite) {
                 		atomic_set_mask(ZFCP_STATUS_UNIT_READONLY,
 						&unit->status);
-				dev_info(&fsf_req->adapter->ccw_device->dev,
+				dev_info(&adapter->ccw_device->dev,
 					 "Read-only access for unit 0x%016Lx "
 					 "on port 0x%016Lx.\n",
 					 unit->fcp_lun, unit->port->wwpn);
         		}
 
         		if (exclusive && !readwrite) {
-				dev_err(&fsf_req->adapter->ccw_device->dev,
+				dev_err(&adapter->ccw_device->dev,
 					"Exclusive access of read-only unit "
 					"0x%016Lx on port 0x%016Lx not "
 					"supported, disabling unit.\n",
 					unit->fcp_lun, unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, 35, fsf_req);
-				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 80, fsf_req);
+				zfcp_erp_unit_failed(unit, 35, req);
+				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+				zfcp_erp_unit_shutdown(unit, 0, 80, req);
         		} else if (!exclusive && readwrite) {
-				dev_err(&fsf_req->adapter->ccw_device->dev,
+				dev_err(&adapter->ccw_device->dev,
 					"Shared access of read-write unit "
 					"0x%016Lx on port 0x%016Lx not "
 					"supported, disabling unit.\n",
 					unit->fcp_lun, unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, 36, fsf_req);
-				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 81, fsf_req);
+				zfcp_erp_unit_failed(unit, 36, req);
+				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+				zfcp_erp_unit_shutdown(unit, 0, 81, req);
         		}
 		}
-
-		retval = 0;
 		break;
 	}
 
- skip_fsfstatus:
+skip_fsfstatus:
 	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &unit->status);
-	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_unit
- *
- * purpose:
- *
- * returns:	address of fsf_req - request successfully initiated
- *		NULL -
- *
- * assumptions: This routine does not check whether the associated
- *              remote port/lun has already been opened. This should be
- *              done by calling routines. Otherwise some status
- *              may be presented by FSF
+/**
+ * zfcp_fsf_open_unit - open unit
+ * @erp_action: pointer to struct zfcp_erp_action
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req;
-	unsigned long lock_flags;
-	int retval = 0;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(erp_action->adapter,
-				     FSF_QTCB_CLOSE_LUN,
-				     ZFCP_WAIT_FOR_SBAL | ZFCP_REQ_AUTO_CLEANUP,
-				     erp_action->adapter->pool.fsf_req_erp,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
 		goto out;
+	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	sbale = zfcp_qdio_sbale_req(req);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	fsf_req->qtcb->header.port_handle = erp_action->port->handle;
-	fsf_req->qtcb->header.lun_handle = erp_action->unit->handle;
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
-	fsf_req->data = (unsigned long) erp_action->unit;
-	fsf_req->erp_action = erp_action;
-	erp_action->fsf_req = fsf_req;
+	req->qtcb->header.port_handle = erp_action->port->handle;
+	req->qtcb->bottom.support.fcp_lun = erp_action->unit->fcp_lun;
+	req->handler = zfcp_fsf_open_unit_handler;
+	req->data = erp_action->unit;
+	req->erp_action = erp_action;
+	erp_action->fsf_req = req;
+
+	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE))
+		req->qtcb->bottom.support.option = FSF_OPEN_LUN_SUPPRESS_BOXING;
 
-	zfcp_erp_start_timer(fsf_req);
-	retval = zfcp_fsf_req_send(erp_action->fsf_req);
+	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
+
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
 	if (retval) {
-		zfcp_fsf_req_free(fsf_req);
+		zfcp_fsf_req_free(req);
 		erp_action->fsf_req = NULL;
-		goto out;
 	}
-
- out:
-	write_unlock_irqrestore(&erp_action->adapter->req_q.lock, lock_flags);
+out:
+	spin_unlock(&adapter->req_q.lock);
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_close_unit_handler
- *
- * purpose:     is called for finished Close LUN FSF command
- *
- * returns:
- */
-static int
-zfcp_fsf_close_unit_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_close_unit_handler(struct zfcp_fsf_req *req)
 {
-	int retval = -EINVAL;
-	struct zfcp_unit *unit;
+	struct zfcp_unit *unit = req->data;
 
-	unit = (struct zfcp_unit *) fsf_req->data;
-
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		/* don't change unit status in our bookkeeping */
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
-	}
-
-	/* evaluate FSF status in QTCB */
-	switch (fsf_req->qtcb->header.fsf_status) {
 
+	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, 111, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_port_reopen(unit->port, 0, 111, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 52, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY;
+		zfcp_erp_port_boxed(unit->port, 52, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
-
 	case FSF_ADAPTER_STATUS_AVAILABLE:
-		switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
+		switch (req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* re-establish link to port */
 			zfcp_test_link(unit->port);
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
+			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* ERP strategy will escalate */
-			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-			break;
-		default:
+			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		}
 		break;
-
 	case FSF_GOOD:
-		/* mark unit as closed */
 		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
-		retval = 0;
 		break;
 	}
-
- skip_fsfstatus:
+skip_fsfstatus:
 	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &unit->status);
-	return retval;
 }
 
 /**
- * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
- * @adapter: adapter where scsi command is issued
- * @unit: unit where command is sent to
- * @scsi_cmnd: scsi command to be sent
- * @timer: timer to be started when request is initiated
- * @req_flags: flags for fsf_request
+ * zfcp_fsf_close_unit - close zfcp unit
+ * @erp_action: pointer to struct zfcp_unit
+ * Returns: 0 on success, error otherwise
  */
-int
-zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *adapter,
-			       struct zfcp_unit *unit,
-			       struct scsi_cmnd * scsi_cmnd,
-			       int use_timer, int req_flags)
-{
-	struct zfcp_fsf_req *fsf_req = NULL;
-	struct fcp_cmnd_iu *fcp_cmnd_iu;
-	unsigned int sbtype;
-	unsigned long lock_flags;
-	int real_bytes = 0;
-	int retval = 0;
-	int mask;
-
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
-				     adapter->pool.fsf_req_scsi,
-				     &lock_flags, &fsf_req);
-	if (unlikely(retval < 0))
-		goto failed_req_create;
-
-	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-			&unit->status))) {
-		retval = -EBUSY;
-		goto unit_blocked;
-	}
-
-	zfcp_unit_get(unit);
-	fsf_req->unit = unit;
-
-	/* associate FSF request with SCSI request (for look up on abort) */
-	scsi_cmnd->host_scribble = (unsigned char *) fsf_req->req_id;
-
-	/* associate SCSI command with FSF request */
-	fsf_req->data = (unsigned long) scsi_cmnd;
-
-	/* set handles of unit and its parent port in QTCB */
-	fsf_req->qtcb->header.lun_handle = unit->handle;
-	fsf_req->qtcb->header.port_handle = unit->port->handle;
-
-	/* FSF does not define the structure of the FCP_CMND IU */
-	fcp_cmnd_iu = (struct fcp_cmnd_iu *)
-	    &(fsf_req->qtcb->bottom.io.fcp_cmnd);
-
-	/*
-	 * set depending on data direction:
-	 *      data direction bits in SBALE (SB Type)
-	 *      data direction bits in QTCB
-	 *      data direction bits in FCP_CMND IU
-	 */
-	switch (scsi_cmnd->sc_data_direction) {
-	case DMA_NONE:
-		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
-		/*
-		 * FIXME(qdio):
-		 * what is the correct type for commands
-		 * without 'real' data buffers?
-		 */
-		sbtype = SBAL_FLAGS0_TYPE_READ;
-		break;
-	case DMA_FROM_DEVICE:
-		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
-		sbtype = SBAL_FLAGS0_TYPE_READ;
-		fcp_cmnd_iu->rddata = 1;
-		break;
-	case DMA_TO_DEVICE:
-		fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
-		sbtype = SBAL_FLAGS0_TYPE_WRITE;
-		fcp_cmnd_iu->wddata = 1;
-		break;
-	case DMA_BIDIRECTIONAL:
-	default:
-		/*
-		 * dummy, catch this condition earlier
-		 * in zfcp_scsi_queuecommand
-		 */
-		goto failed_scsi_cmnd;
-	}
-
-	/* set FC service class in QTCB (3 per default) */
-	fsf_req->qtcb->bottom.io.service_class = ZFCP_FC_SERVICE_CLASS_DEFAULT;
-
-	/* set FCP_LUN in FCP_CMND IU in QTCB */
-	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
-
-	mask = ZFCP_STATUS_UNIT_READONLY | ZFCP_STATUS_UNIT_SHARED;
-
-	/* set task attributes in FCP_CMND IU in QTCB */
-	if (likely((scsi_cmnd->device->simple_tags) ||
-		   (atomic_test_mask(mask, &unit->status))))
-		fcp_cmnd_iu->task_attribute = SIMPLE_Q;
-	else
-		fcp_cmnd_iu->task_attribute = UNTAGGED;
-
-	/* set additional length of FCP_CDB in FCP_CMND IU in QTCB, if needed */
-	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH))
-		fcp_cmnd_iu->add_fcp_cdb_length
-		    = (scsi_cmnd->cmd_len - FCP_CDB_LENGTH) >> 2;
-	/*
-	 * copy SCSI CDB (including additional length, if any) to
-	 * FCP_CDB in FCP_CMND IU in QTCB
-	 */
-	memcpy(fcp_cmnd_iu->fcp_cdb, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
-
-	/* FCP CMND IU length in QTCB */
-	fsf_req->qtcb->bottom.io.fcp_cmnd_length =
-		sizeof (struct fcp_cmnd_iu) +
-		fcp_cmnd_iu->add_fcp_cdb_length + sizeof (fcp_dl_t);
-
-	/* generate SBALEs from data buffer */
-	real_bytes = zfcp_qdio_sbals_from_sg(fsf_req, sbtype,
-					     scsi_sglist(scsi_cmnd),
-					     ZFCP_MAX_SBALS_PER_REQ);
-	if (unlikely(real_bytes < 0)) {
-		if (fsf_req->sbal_number < ZFCP_MAX_SBALS_PER_REQ)
-			retval = -EIO;
-		else {
-			dev_err(&adapter->ccw_device->dev,
-				"SCSI request too large. "
-				"Shutting down unit 0x%016Lx on port "
-				"0x%016Lx.\n", unit->fcp_lun,
-				unit->port->wwpn);
-			zfcp_erp_unit_shutdown(unit, 0, 131, fsf_req);
-			retval = -EINVAL;
-		}
-		goto no_fit;
-	}
-
-	/* set length of FCP data length in FCP_CMND IU in QTCB */
-	zfcp_set_fcp_dl(fcp_cmnd_iu, real_bytes);
-
-	if (use_timer)
-		zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
-
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (unlikely(retval < 0))
-		goto send_failed;
-
-	goto success;
-
- send_failed:
- no_fit:
- failed_scsi_cmnd:
-	zfcp_unit_put(unit);
- unit_blocked:
-	zfcp_fsf_req_free(fsf_req);
-	fsf_req = NULL;
-	scsi_cmnd->host_scribble = NULL;
- success:
- failed_req_create:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return retval;
-}
-
-struct zfcp_fsf_req *
-zfcp_fsf_send_fcp_command_task_management(struct zfcp_adapter *adapter,
-					  struct zfcp_unit *unit,
-					  u8 tm_flags, int req_flags)
+int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_fsf_req *fsf_req = NULL;
-	int retval = 0;
-	struct fcp_cmnd_iu *fcp_cmnd_iu;
-	unsigned long lock_flags;
 	volatile struct qdio_buffer_element *sbale;
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
 
-	/* setup new FSF request */
-	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
-				     adapter->pool.fsf_req_scsi,
-				     &lock_flags, &fsf_req);
-	if (retval < 0)
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
+	}
 
-	if (unlikely(!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-			&unit->status)))
-		goto unit_blocked;
-
-	/*
-	 * Used to decide on proper handler in the return path,
-	 * could be either zfcp_fsf_send_fcp_command_task_handler or
-	 * zfcp_fsf_send_fcp_command_task_management_handler */
-
-	fsf_req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
-
-	/*
-	 * hold a pointer to the unit being target of this
-	 * task management request
-	 */
-	fsf_req->data = (unsigned long) unit;
-
-	/* set FSF related fields in QTCB */
-	fsf_req->qtcb->header.lun_handle = unit->handle;
-	fsf_req->qtcb->header.port_handle = unit->port->handle;
-	fsf_req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
-	fsf_req->qtcb->bottom.io.service_class = ZFCP_FC_SERVICE_CLASS_DEFAULT;
-	fsf_req->qtcb->bottom.io.fcp_cmnd_length =
-		sizeof (struct fcp_cmnd_iu) + sizeof (fcp_dl_t);
-
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
 	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	/* set FCP related fields in FCP_CMND IU in QTCB */
-	fcp_cmnd_iu = (struct fcp_cmnd_iu *)
-		&(fsf_req->qtcb->bottom.io.fcp_cmnd);
-	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
-	fcp_cmnd_iu->task_management_flags = tm_flags;
-
-	zfcp_fsf_start_timer(fsf_req, ZFCP_SCSI_ER_TIMEOUT);
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (!retval)
-		goto out;
+	req->qtcb->header.port_handle = erp_action->port->handle;
+	req->qtcb->header.lun_handle = erp_action->unit->handle;
+	req->handler = zfcp_fsf_close_unit_handler;
+	req->data = erp_action->unit;
+	req->erp_action = erp_action;
+	erp_action->fsf_req = req;
+	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
 
- unit_blocked:
-	zfcp_fsf_req_free(fsf_req);
-	fsf_req = NULL;
-
- out:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return fsf_req;
+	zfcp_erp_start_timer(req);
+	retval = zfcp_fsf_req_send(req);
+	if (retval) {
+		zfcp_fsf_req_free(req);
+		erp_action->fsf_req = NULL;
+	}
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return retval;
 }
 
 static void zfcp_fsf_update_lat(struct fsf_latency_record *lat_rec, u32 lat)
 {
 	lat_rec->sum += lat;
-	if (lat_rec->min > lat)
-		lat_rec->min = lat;
-	if (lat_rec->max < lat)
-		lat_rec->max = lat;
+	lat_rec->min = min(lat_rec->min, lat);
+	lat_rec->max = max(lat_rec->max, lat);
 }
 
-static void zfcp_fsf_req_latency(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_req_latency(struct zfcp_fsf_req *req)
 {
 	struct fsf_qual_latency_info *lat_inf;
 	struct latency_cont *lat;
-	struct zfcp_unit *unit;
+	struct zfcp_unit *unit = req->unit;
 	unsigned long flags;
 
-	lat_inf = &fsf_req->qtcb->prefix.prot_status_qual.latency_info;
-	unit = fsf_req->unit;
+	lat_inf = &req->qtcb->prefix.prot_status_qual.latency_info;
 
-	switch (fsf_req->qtcb->bottom.io.data_direction) {
+	switch (req->qtcb->bottom.io.data_direction) {
 	case FSF_DATADIR_READ:
 		lat = &unit->latencies.read;
 		break;
 	case FSF_DATADIR_WRITE:
 		lat = &unit->latencies.write;
 		break;
-	case FSF_DATADIR_CMND:
-		lat = &unit->latencies.cmd;
-		break;
-	default:
-		return;
-	}
-
-	spin_lock_irqsave(&unit->latencies.lock, flags);
-	zfcp_fsf_update_lat(&lat->channel, lat_inf->channel_lat);
-	zfcp_fsf_update_lat(&lat->fabric, lat_inf->fabric_lat);
-	lat->counter++;
-	spin_unlock_irqrestore(&unit->latencies.lock, flags);
-}
-
-/*
- * function:    zfcp_fsf_send_fcp_command_handler
- *
- * purpose:	is called for finished Send FCP Command
- *
- * returns:
- */
-static int
-zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *fsf_req)
-{
-	int retval = -EINVAL;
-	struct zfcp_unit *unit;
-	struct fsf_qtcb_header *header;
-
-	header = &fsf_req->qtcb->header;
-
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT))
-		unit = (struct zfcp_unit *) fsf_req->data;
-	else
-		unit = fsf_req->unit;
-
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
-		/* go directly to calls of special handlers */
-		goto skip_fsfstatus;
-	}
-
-	/* evaluate FSF status in QTCB */
-	switch (header->fsf_status) {
-
-	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, 113, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_HANDLE_MISMATCH:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
-		zfcp_fsf_class_not_supp(fsf_req);
-		break;
-
-	case FSF_FCPLUN_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, 115, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_unit(fsf_req, unit);
-		break;
-
-	case FSF_DIRECTION_INDICATOR_NOT_VALID:
-		dev_err(&fsf_req->adapter->ccw_device->dev,
-			"Invalid data direction (%d) given for unit 0x%016Lx "
-			"on port 0x%016Lx, shutting down adapter.\n",
-			fsf_req->qtcb->bottom.io.data_direction,
-			unit->fcp_lun, unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_CMND_LENGTH_NOT_VALID:
-		dev_err(&fsf_req->adapter->ccw_device->dev,
-			"An invalid control-data-block length field (%d) "
-			"was found in a command for unit 0x%016Lx on port "
-			"0x%016Lx. Shutting down adapter.\n",
-			fsf_req->qtcb->bottom.io.fcp_cmnd_length,
-			unit->fcp_lun, unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 53, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
-			ZFCP_STATUS_FSFREQ_RETRY;
-		break;
-
-	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, 54, fsf_req);
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
-			| ZFCP_STATUS_FSFREQ_RETRY;
-		break;
-
-	case FSF_ADAPTER_STATUS_AVAILABLE:
-		switch (header->fsf_status_qual.word[0]) {
-		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			/* re-establish link to port */
- 			zfcp_test_link(unit->port);
-			break;
-		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			/* FIXME(hw) need proper specs for proper action */
-			/* let scsi stack deal with retries and escalation */
-			break;
-		}
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		break;
-
-	case FSF_GOOD:
-		break;
-
-	case FSF_FCP_RSP_AVAILABLE:
+	case FSF_DATADIR_CMND:
+		lat = &unit->latencies.cmd;
 		break;
+	default:
+		return;
 	}
 
- skip_fsfstatus:
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT) {
-		retval =
-		    zfcp_fsf_send_fcp_command_task_management_handler(fsf_req);
-	} else {
-		retval = zfcp_fsf_send_fcp_command_task_handler(fsf_req);
-		fsf_req->unit = NULL;
-		zfcp_unit_put(unit);
-	}
-	return retval;
+	spin_lock_irqsave(&unit->latencies.lock, flags);
+	zfcp_fsf_update_lat(&lat->channel, lat_inf->channel_lat);
+	zfcp_fsf_update_lat(&lat->fabric, lat_inf->fabric_lat);
+	lat->counter++;
+	spin_unlock_irqrestore(&unit->latencies.lock, flags);
 }
 
-/*
- * function:    zfcp_fsf_send_fcp_command_task_handler
- *
- * purpose:	evaluates FCP_RSP IU
- *
- * returns:
- */
-static int
-zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_send_fcp_command_task_handler(struct zfcp_fsf_req *req)
 {
-	int retval = 0;
-	struct scsi_cmnd *scpnt;
+	struct scsi_cmnd *scpnt = req->data;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
-	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
+	    &(req->qtcb->bottom.io.fcp_rsp);
 	u32 sns_len;
 	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 	unsigned long flags;
 
-	read_lock_irqsave(&fsf_req->adapter->abort_lock, flags);
-	scpnt = (struct scsi_cmnd *) fsf_req->data;
 	if (unlikely(!scpnt))
-		goto out;
+		return;
 
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
-		/* FIXME: (design) mid-layer should handle DID_ABORT like
-		 *        DID_SOFT_ERROR by retrying the request for devices
-		 *        that allow retries.
-		 */
+	read_lock_irqsave(&req->adapter->abort_lock, flags);
+
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ABORTED)) {
 		set_host_byte(scpnt, DID_SOFT_ERROR);
 		set_driver_byte(scpnt, SUGGEST_RETRY);
 		goto skip_fsfstatus;
 	}
 
-	if (unlikely(fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR)) {
 		set_host_byte(scpnt, DID_ERROR);
 		goto skip_fsfstatus;
 	}
 
-	/* set message byte of result in SCSI command */
 	set_msg_byte(scpnt, COMMAND_COMPLETE);
 
-	/*
-	 * copy SCSI status code of FCP_STATUS of FCP_RSP IU to status byte
-	 * of result in SCSI command
-	 */
 	scpnt->result |= fcp_rsp_iu->scsi_status;
 
-	if (fsf_req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)
-		zfcp_fsf_req_latency(fsf_req);
+	if (req->adapter->adapter_features & FSF_FEATURE_MEASUREMENT_DATA)
+		zfcp_fsf_req_latency(req);
 
-	/* check FCP_RSP_INFO */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_rsp_len_valid)) {
-		switch (fcp_rsp_info[3]) {
-		case RSP_CODE_GOOD:
-			/* ok, continue */
+		if (fcp_rsp_info[3] == RSP_CODE_GOOD)
 			set_host_byte(scpnt, DID_OK);
-			break;
-		case RSP_CODE_LENGTH_MISMATCH:
-			/* hardware bug */
-			set_host_byte(scpnt, DID_ERROR);
-			goto skip_fsfstatus;
-		case RSP_CODE_FIELD_INVALID:
-			/* driver or hardware bug */
-			set_host_byte(scpnt, DID_ERROR);
-			goto skip_fsfstatus;
-		case RSP_CODE_RO_MISMATCH:
-			/* hardware bug */
-			set_host_byte(scpnt, DID_ERROR);
-			goto skip_fsfstatus;
-		default:
-			/* invalid FCP response code */
+		else {
 			set_host_byte(scpnt, DID_ERROR);
 			goto skip_fsfstatus;
 		}
 	}
 
-	/* check for sense data */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_sns_len_valid)) {
-		sns_len = FSF_FCP_RSP_SIZE -
-		    sizeof (struct fcp_rsp_iu) + fcp_rsp_iu->fcp_rsp_len;
+		sns_len = FSF_FCP_RSP_SIZE - sizeof(struct fcp_rsp_iu) +
+			  fcp_rsp_iu->fcp_rsp_len;
 		sns_len = min(sns_len, (u32) SCSI_SENSE_BUFFERSIZE);
 		sns_len = min(sns_len, fcp_rsp_iu->fcp_sns_len);
 
@@ -3099,382 +2062,372 @@ zfcp_fsf_send_fcp_command_task_handler(s
 		       zfcp_get_fcp_sns_info_ptr(fcp_rsp_iu), sns_len);
 	}
 
-	/* check for underrun */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_under)) {
 		scsi_set_resid(scpnt, fcp_rsp_iu->fcp_resid);
 		if (scsi_bufflen(scpnt) - scsi_get_resid(scpnt) <
 		    scpnt->underflow)
 			set_host_byte(scpnt, DID_ERROR);
 	}
-
- skip_fsfstatus:
+skip_fsfstatus:
 	if (scpnt->result != 0)
-		zfcp_scsi_dbf_event_result("erro", 3, fsf_req->adapter, scpnt, fsf_req);
+		zfcp_scsi_dbf_event_result("erro", 3, req->adapter, scpnt, req);
 	else if (scpnt->retries > 0)
-		zfcp_scsi_dbf_event_result("retr", 4, fsf_req->adapter, scpnt, fsf_req);
+		zfcp_scsi_dbf_event_result("retr", 4, req->adapter, scpnt, req);
 	else
-		zfcp_scsi_dbf_event_result("norm", 6, fsf_req->adapter, scpnt, fsf_req);
+		zfcp_scsi_dbf_event_result("norm", 6, req->adapter, scpnt, req);
 
-	/* cleanup pointer (need this especially for abort) */
 	scpnt->host_scribble = NULL;
-
-	/* always call back */
 	(scpnt->scsi_done) (scpnt);
-
 	/*
 	 * We must hold this lock until scsi_done has been called.
 	 * Otherwise we may call scsi_done after abort regarding this
 	 * command has completed.
 	 * Note: scsi_done must not block!
 	 */
- out:
-	read_unlock_irqrestore(&fsf_req->adapter->abort_lock, flags);
-	return retval;
+	read_unlock_irqrestore(&req->adapter->abort_lock, flags);
 }
 
-/*
- * function:    zfcp_fsf_send_fcp_command_task_management_handler
- *
- * purpose:	evaluates FCP_RSP IU
- *
- * returns:
- */
-static int
-zfcp_fsf_send_fcp_command_task_management_handler(struct zfcp_fsf_req *fsf_req)
+static void zfcp_fsf_send_fcp_ctm_handler(struct zfcp_fsf_req *req)
 {
-	int retval = 0;
 	struct fcp_rsp_iu *fcp_rsp_iu = (struct fcp_rsp_iu *)
-	    &(fsf_req->qtcb->bottom.io.fcp_rsp);
+	    &(req->qtcb->bottom.io.fcp_rsp);
 	char *fcp_rsp_info = (unsigned char *) &fcp_rsp_iu[1];
 
-	if (fsf_req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
+	if ((fcp_rsp_info[3] != RSP_CODE_GOOD) ||
+	     (req->status & ZFCP_STATUS_FSFREQ_ERROR))
+		req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
+}
+
+
+static void zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_unit *unit;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
+
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT))
+		unit = req->data;
+	else
+		unit = req->unit;
+
+	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		goto skip_fsfstatus;
-	}
 
-	/* check FCP_RSP_INFO */
-	switch (fcp_rsp_info[3]) {
-	case RSP_CODE_GOOD:
-		/* ok, continue */
+	switch (header->fsf_status) {
+	case FSF_HANDLE_MISMATCH:
+	case FSF_PORT_HANDLE_NOT_VALID:
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		break;
+	case FSF_FCPLUN_NOT_VALID:
+	case FSF_LUN_HANDLE_NOT_VALID:
+		zfcp_erp_port_reopen(unit->port, 0, 113, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-	case RSP_CODE_TASKMAN_UNSUPP:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCNOTSUPP;
+	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
+		zfcp_fsf_class_not_supp(req);
 		break;
-	case RSP_CODE_TASKMAN_FAILED:
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
+	case FSF_ACCESS_DENIED:
+		zfcp_fsf_access_denied_unit(req, unit);
+		break;
+	case FSF_DIRECTION_INDICATOR_NOT_VALID:
+		dev_err(&req->adapter->ccw_device->dev,
+			"Invalid data direction (%d) given for unit "
+			"0x%016Lx on port 0x%016Lx, shutting down "
+			"adapter.\n",
+			req->qtcb->bottom.io.data_direction,
+			unit->fcp_lun, unit->port->wwpn);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		break;
+	case FSF_CMND_LENGTH_NOT_VALID:
+		dev_err(&req->adapter->ccw_device->dev,
+			"An invalid control-data-block length field (%d) "
+			"was found in a command for unit 0x%016Lx on port "
+			"0x%016Lx. Shutting down adapter.\n",
+			req->qtcb->bottom.io.fcp_cmnd_length,
+			unit->fcp_lun, unit->port->wwpn);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		break;
+	case FSF_PORT_BOXED:
+		zfcp_erp_port_boxed(unit->port, 53, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
+		break;
+	case FSF_LUN_BOXED:
+		zfcp_erp_unit_boxed(unit, 54, req);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
+			       ZFCP_STATUS_FSFREQ_RETRY;
+		break;
+	case FSF_ADAPTER_STATUS_AVAILABLE:
+		if (header->fsf_status_qual.word[0] ==
+		    FSF_SQ_INVOKE_LINK_TEST_PROCEDURE)
+			zfcp_test_link(unit->port);
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
-	default:
-		/* invalid FCP response code */
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_TMFUNCFAILED;
 	}
-
-      skip_fsfstatus:
-	return retval;
+skip_fsfstatus:
+	if (req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT)
+		zfcp_fsf_send_fcp_ctm_handler(req);
+	else {
+		zfcp_fsf_send_fcp_command_task_handler(req);
+		req->unit = NULL;
+		zfcp_unit_put(unit);
+	}
 }
 
-
-/*
- * function:    zfcp_fsf_control_file
- *
- * purpose:     Initiator of the control file upload/download FSF requests
- *
- * returns:     0           - FSF request is successfuly created and queued
- *              -EOPNOTSUPP - The FCP adapter does not have Control File support
- *              -EINVAL     - Invalid direction specified
- *              -ENOMEM     - Insufficient memory
- *              -EPERM      - Cannot create FSF request or place it in QDIO queue
+/**
+ * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
+ * @adapter: adapter where scsi command is issued
+ * @unit: unit where command is sent to
+ * @scsi_cmnd: scsi command to be sent
+ * @timer: timer to be started when request is initiated
+ * @req_flags: flags for fsf_request
  */
-struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
-					   struct zfcp_fsf_cfdc *fsf_cfdc)
+int zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *adapter,
+				   struct zfcp_unit *unit,
+				   struct scsi_cmnd *scsi_cmnd,
+				   int use_timer, int req_flags)
 {
-	struct zfcp_fsf_req *fsf_req;
-	struct fsf_qtcb_bottom_support *bottom;
-	volatile struct qdio_buffer_element *sbale;
-	unsigned long lock_flags;
-	int direction;
-	int retval;
-	int bytes;
+	struct zfcp_fsf_req *req;
+	struct fcp_cmnd_iu *fcp_cmnd_iu;
+	unsigned int sbtype;
+	int real_bytes, retval = -EIO;
 
-	if (!(adapter->adapter_features & FSF_FEATURE_CFDC))
-		return ERR_PTR(-EOPNOTSUPP);
+	if (unlikely(!(atomic_read(&unit->status) &
+		       ZFCP_STATUS_COMMON_UNBLOCKED)))
+		return -EBUSY;
 
-	switch (fsf_cfdc->command) {
-	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
-		direction = SBAL_FLAGS0_TYPE_WRITE;
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
+				  adapter->pool.fsf_req_scsi);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
+	}
+
+	zfcp_unit_get(unit);
+	req->unit = unit;
+	req->data = scsi_cmnd;
+	req->handler = zfcp_fsf_send_fcp_command_handler;
+	req->qtcb->header.lun_handle = unit->handle;
+	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
+
+	scsi_cmnd->host_scribble = (unsigned char *) req->req_id;
+
+	fcp_cmnd_iu = (struct fcp_cmnd_iu *) &(req->qtcb->bottom.io.fcp_cmnd);
+	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
+	/*
+	 * set depending on data direction:
+	 *      data direction bits in SBALE (SB Type)
+	 *      data direction bits in QTCB
+	 *      data direction bits in FCP_CMND IU
+	 */
+	switch (scsi_cmnd->sc_data_direction) {
+	case DMA_NONE:
+		req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
+		sbtype = SBAL_FLAGS0_TYPE_READ;
 		break;
-	case FSF_QTCB_UPLOAD_CONTROL_FILE:
-		direction = SBAL_FLAGS0_TYPE_READ;
+	case DMA_FROM_DEVICE:
+		req->qtcb->bottom.io.data_direction = FSF_DATADIR_READ;
+		sbtype = SBAL_FLAGS0_TYPE_READ;
+		fcp_cmnd_iu->rddata = 1;
+		break;
+	case DMA_TO_DEVICE:
+		req->qtcb->bottom.io.data_direction = FSF_DATADIR_WRITE;
+		sbtype = SBAL_FLAGS0_TYPE_WRITE;
+		fcp_cmnd_iu->wddata = 1;
 		break;
+	case DMA_BIDIRECTIONAL:
 	default:
-		return ERR_PTR(-EINVAL);
+		retval = -EIO;
+		goto failed_scsi_cmnd;
 	}
 
-	retval = zfcp_fsf_req_create(adapter, fsf_cfdc->command,
-				     ZFCP_WAIT_FOR_SBAL,
-				     NULL, &lock_flags, &fsf_req);
-	if (retval < 0) {
-		retval = -EPERM;
-		goto unlock_queue_lock;
-	}
+	if (likely((scsi_cmnd->device->simple_tags) ||
+		   ((atomic_read(&unit->status) & ZFCP_STATUS_UNIT_READONLY) &&
+		    (atomic_read(&unit->status) & ZFCP_STATUS_UNIT_SHARED))))
+		fcp_cmnd_iu->task_attribute = SIMPLE_Q;
+	else
+		fcp_cmnd_iu->task_attribute = UNTAGGED;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
-	sbale[0].flags |= direction;
+	if (unlikely(scsi_cmnd->cmd_len > FCP_CDB_LENGTH))
+		fcp_cmnd_iu->add_fcp_cdb_length =
+			(scsi_cmnd->cmd_len - FCP_CDB_LENGTH) >> 2;
 
-	bottom = &fsf_req->qtcb->bottom.support;
-	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
-	bottom->option = fsf_cfdc->option;
+	memcpy(fcp_cmnd_iu->fcp_cdb, scsi_cmnd->cmnd, scsi_cmnd->cmd_len);
 
-	bytes = zfcp_qdio_sbals_from_sg(fsf_req, direction,
-					fsf_cfdc->sg,
-					ZFCP_MAX_SBALS_PER_REQ);
-	if (bytes != ZFCP_CFDC_MAX_SIZE) {
-		retval = -ENOMEM;
-		goto free_fsf_req;
-	}
+	req->qtcb->bottom.io.fcp_cmnd_length = sizeof(struct fcp_cmnd_iu) +
+		fcp_cmnd_iu->add_fcp_cdb_length + sizeof(fcp_dl_t);
 
-	zfcp_fsf_start_timer(fsf_req, ZFCP_FSF_REQUEST_TIMEOUT);
-	retval = zfcp_fsf_req_send(fsf_req);
-	if (retval < 0) {
-		retval = -EPERM;
-		goto free_fsf_req;
+	real_bytes = zfcp_qdio_sbals_from_sg(req, sbtype,
+					     scsi_sglist(scsi_cmnd),
+					     FSF_MAX_SBALS_PER_REQ);
+	if (unlikely(real_bytes < 0)) {
+		if (req->sbal_number < FSF_MAX_SBALS_PER_REQ)
+			retval = -EIO;
+		else {
+			dev_err(&adapter->ccw_device->dev,
+				"SCSI request too large. "
+				"Shutting down unit 0x%016Lx on port "
+				"0x%016Lx.\n", unit->fcp_lun,
+				unit->port->wwpn);
+			zfcp_erp_unit_shutdown(unit, 0, 131, req);
+			retval = -EINVAL;
+		}
+		goto failed_scsi_cmnd;
 	}
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-
-	wait_event(fsf_req->completion_wq,
-	           fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
 
-	return fsf_req;
+	zfcp_set_fcp_dl(fcp_cmnd_iu, real_bytes);
 
- free_fsf_req:
-	zfcp_fsf_req_free(fsf_req);
- unlock_queue_lock:
-	write_unlock_irqrestore(&adapter->req_q.lock, lock_flags);
-	return ERR_PTR(retval);
-}
+	if (use_timer)
+		zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
-static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *fsf_req)
-{
-	if (fsf_req->qtcb->header.fsf_status != FSF_GOOD)
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-}
+	retval = zfcp_fsf_req_send(req);
+	if (unlikely(retval))
+		goto failed_scsi_cmnd;
 
-static inline int
-zfcp_fsf_req_sbal_check(unsigned long *flags,
-			struct zfcp_qdio_queue *queue, int needed)
-{
-	write_lock_irqsave(&queue->lock, *flags);
-	if (likely(atomic_read(&queue->count) >= needed))
-		return 1;
-	write_unlock_irqrestore(&queue->lock, *flags);
-	return 0;
-}
+	goto out;
 
-/*
- * set qtcb pointer in fsf_req and initialize QTCB
- */
-static void
-zfcp_fsf_req_qtcb_init(struct zfcp_fsf_req *fsf_req)
-{
-	if (likely(fsf_req->qtcb != NULL)) {
-		fsf_req->qtcb->prefix.req_seq_no =
-			fsf_req->adapter->fsf_req_seq_no;
-		fsf_req->qtcb->prefix.req_id = fsf_req->req_id;
-		fsf_req->qtcb->prefix.ulp_info = ZFCP_ULP_INFO_VERSION;
-		fsf_req->qtcb->prefix.qtcb_type =
-			fsf_qtcb_type[fsf_req->fsf_command];
-		fsf_req->qtcb->prefix.qtcb_version = ZFCP_QTCB_VERSION;
-		fsf_req->qtcb->header.req_handle = fsf_req->req_id;
-		fsf_req->qtcb->header.fsf_command = fsf_req->fsf_command;
-	}
+failed_scsi_cmnd:
+	zfcp_unit_put(unit);
+	zfcp_fsf_req_free(req);
+	scsi_cmnd->host_scribble = NULL;
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return retval;
 }
 
 /**
- * zfcp_fsf_req_sbal_get - try to get one SBAL in the request queue
- * @adapter: adapter for which request queue is examined
- * @req_flags: flags indicating whether to wait for needed SBAL or not
- * @lock_flags: lock_flags if queue_lock is taken
- * Return: 0 on success, otherwise -EIO, or -ERESTARTSYS
- * Locks: lock adapter->req_q->lock on success
- */
-static int
-zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter, int req_flags,
-		      unsigned long *lock_flags)
-{
-        long ret;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-
-        if (unlikely(req_flags & ZFCP_WAIT_FOR_SBAL)) {
-                ret = wait_event_interruptible_timeout(adapter->request_wq,
-			zfcp_fsf_req_sbal_check(lock_flags, req_q, 1),
-						       ZFCP_SBAL_TIMEOUT);
-		if (ret < 0)
-			return ret;
-		if (!ret)
-			return -EIO;
-	} else if (!zfcp_fsf_req_sbal_check(lock_flags, req_q, 1))
-                return -EIO;
-
-        return 0;
-}
-
-/*
- * function:    zfcp_fsf_req_create
- *
- * purpose:	create an FSF request at the specified adapter and
- *		setup common fields
- *
- * returns:	-ENOMEM if there was insufficient memory for a request
- *              -EIO if no qdio buffers could be allocate to the request
- *              -EINVAL/-EPERM on bug conditions in req_dequeue
- *              0 in success
- *
- * note:        The created request is returned by reference.
- *
- * locks:	lock of concerned request queue must not be held,
- *		but is held on completion (write, irqsave)
- */
-int
-zfcp_fsf_req_create(struct zfcp_adapter *adapter, u32 fsf_cmd, int req_flags,
-		    mempool_t *pool, unsigned long *lock_flags,
-		    struct zfcp_fsf_req **fsf_req_p)
+ * zfcp_fsf_send_fcp_ctm - send SCSI task management command
+ * @adapter: pointer to struct zfcp-adapter
+ * @unit: pointer to struct zfcp_unit
+ * @tm_flags: unsigned byte for task management flags
+ * @req_flags: int request flags
+ * Returns: on success pointer to struct fsf_req, NULL otherwise
+ */
+struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *adapter,
+					   struct zfcp_unit *unit,
+					   u8 tm_flags, int req_flags)
 {
 	volatile struct qdio_buffer_element *sbale;
-	struct zfcp_fsf_req *fsf_req = NULL;
-	int ret = 0;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-
-	/* allocate new FSF request */
-	fsf_req = zfcp_fsf_req_alloc(pool, req_flags);
-	if (unlikely(!fsf_req)) {
-		ret = -ENOMEM;
-		goto failed_fsf_req;
-	}
-
-	fsf_req->adapter = adapter;
-	fsf_req->fsf_command = fsf_cmd;
-	INIT_LIST_HEAD(&fsf_req->list);
-	init_timer(&fsf_req->timer);
-
-	/* initialize waitqueue which may be used to wait on
-	   this request completion */
-	init_waitqueue_head(&fsf_req->completion_wq);
-
-        ret = zfcp_fsf_req_sbal_get(adapter, req_flags, lock_flags);
-        if (ret < 0)
-                goto failed_sbals;
-
-	/* this is serialized (we are holding req_queue-lock of adapter) */
-	if (adapter->req_no == 0)
-		adapter->req_no++;
-	fsf_req->req_id = adapter->req_no++;
-
-	zfcp_fsf_req_qtcb_init(fsf_req);
+	struct zfcp_fsf_req *req = NULL;
+	struct fcp_cmnd_iu *fcp_cmnd_iu;
 
-	/*
-	 * We hold queue_lock here. Check if QDIOUP is set and let request fail
-	 * if it is not set (see also *_open_qdio and *_close_qdio).
-	 */
+	if (unlikely(!(atomic_read(&unit->status) &
+		       ZFCP_STATUS_COMMON_UNBLOCKED)))
+		return NULL;
 
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status)) {
-		write_unlock_irqrestore(&req_q->lock, *lock_flags);
-		ret = -EIO;
-		goto failed_sbals;
-	}
+	spin_lock(&adapter->req_q.lock);
+	if (!atomic_read(&adapter->req_q.count))
+		goto out;
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
+				  adapter->pool.fsf_req_scsi);
+	if (unlikely(IS_ERR(req)))
+		goto out;
 
-	if (fsf_req->qtcb) {
-		fsf_req->seq_no = adapter->fsf_req_seq_no;
-		fsf_req->qtcb->prefix.req_seq_no = adapter->fsf_req_seq_no;
-	}
-	fsf_req->sbal_number = 1;
-	fsf_req->sbal_first = req_q->first;
-	fsf_req->sbal_last = req_q->first;
-        fsf_req->sbale_curr = 1;
+	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
+	req->data = unit;
+	req->handler = zfcp_fsf_send_fcp_command_handler;
+	req->qtcb->header.lun_handle = unit->handle;
+	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
+	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
+	req->qtcb->bottom.io.fcp_cmnd_length = 	sizeof(struct fcp_cmnd_iu) +
+						sizeof(fcp_dl_t);
 
-	if (likely(req_flags & ZFCP_REQ_AUTO_CLEANUP)) {
-		fsf_req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	}
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE;
+	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	fcp_cmnd_iu = (struct fcp_cmnd_iu *) &req->qtcb->bottom.io.fcp_cmnd;
+	fcp_cmnd_iu->fcp_lun = unit->fcp_lun;
+	fcp_cmnd_iu->task_management_flags = tm_flags;
 
-	/* setup common SBALE fields */
-	sbale[0].addr = (void *) fsf_req->req_id;
-	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
-	if (likely(fsf_req->qtcb != NULL)) {
-		sbale[1].addr = (void *) fsf_req->qtcb;
-		sbale[1].length = sizeof(struct fsf_qtcb);
-	}
+	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
+	if (!zfcp_fsf_req_send(req))
+		goto out;
 
-	goto success;
+	zfcp_fsf_req_free(req);
+	req = NULL;
+out:
+	spin_unlock(&adapter->req_q.lock);
+	return req;
+}
 
- failed_sbals:
-/* dequeue new FSF request previously enqueued */
-	zfcp_fsf_req_free(fsf_req);
-	fsf_req = NULL;
-
- failed_fsf_req:
-	write_lock_irqsave(&req_q->lock, *lock_flags);
- success:
-	*fsf_req_p = fsf_req;
-	return ret;
+static void zfcp_fsf_control_file_handler(struct zfcp_fsf_req *req)
+{
+	if (req->qtcb->header.fsf_status != FSF_GOOD)
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
-/*
- * function:    zfcp_fsf_req_send
- *
- * purpose:	start transfer of FSF request via QDIO
- *
- * returns:	0 - request transfer succesfully started
- *		!0 - start of request transfer failed
+/**
+ * zfcp_fsf_control_file - control file upload/download
+ * @adapter: pointer to struct zfcp_adapter
+ * @fsf_cfdc: pointer to struct zfcp_fsf_cfdc
+ * Returns: on success pointer to struct zfcp_fsf_req, NULL otherwise
  */
-static int zfcp_fsf_req_send(struct zfcp_fsf_req *fsf_req)
+struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
+					   struct zfcp_fsf_cfdc *fsf_cfdc)
 {
-	struct zfcp_adapter *adapter;
-	struct zfcp_qdio_queue *req_q;
 	volatile struct qdio_buffer_element *sbale;
-	int inc_seq_no;
-	int retval = 0;
+	struct zfcp_fsf_req *req = NULL;
+	struct fsf_qtcb_bottom_support *bottom;
+	int direction, retval = -EIO, bytes;
+
+	if (!(adapter->adapter_features & FSF_FEATURE_CFDC))
+		return ERR_PTR(-EOPNOTSUPP);
 
-	adapter = fsf_req->adapter;
-	req_q = &adapter->req_q;
+	switch (fsf_cfdc->command) {
+	case FSF_QTCB_DOWNLOAD_CONTROL_FILE:
+		direction = SBAL_FLAGS0_TYPE_WRITE;
+		break;
+	case FSF_QTCB_UPLOAD_CONTROL_FILE:
+		direction = SBAL_FLAGS0_TYPE_READ;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
 
-	sbale = zfcp_qdio_sbale_req(fsf_req);
+	spin_lock(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
 
-	/* put allocated FSF request into hash table */
-	spin_lock(&adapter->req_list_lock);
-	zfcp_reqlist_add(adapter, fsf_req);
-	spin_unlock(&adapter->req_list_lock);
+	req = zfcp_fsf_req_create(adapter, fsf_cfdc->command, 0, NULL);
+	if (unlikely(IS_ERR(req))) {
+		retval = -EPERM;
+		goto out;
+	}
 
-	inc_seq_no = (fsf_req->qtcb != NULL);
+	req->handler = zfcp_fsf_control_file_handler;
 
-	fsf_req->issued = get_clock();
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= direction;
 
-	retval = zfcp_qdio_send(fsf_req);
+	bottom = &req->qtcb->bottom.support;
+	bottom->operation_subtype = FSF_CFDC_OPERATION_SUBTYPE;
+	bottom->option = fsf_cfdc->option;
 
-	if (unlikely(retval)) {
-		/* Queues are down..... */
-		del_timer(&fsf_req->timer);
-		spin_lock(&adapter->req_list_lock);
-		zfcp_reqlist_remove(adapter, fsf_req);
-		spin_unlock(&adapter->req_list_lock);
-		/* undo changes in request queue made for this request */
-		atomic_add(fsf_req->sbal_number, &req_q->count);
-		req_q->first -= fsf_req->sbal_number;
-		req_q->first += QDIO_MAX_BUFFERS_PER_Q;
-		req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
-		zfcp_erp_adapter_reopen(adapter, 0, 116, fsf_req);
-		retval = -EIO;
-	} else {
-		/*
-		 * increase FSF sequence counter -
-		 * this must only be done for request successfully enqueued to
-		 * QDIO this rejected requests may be cleaned up by calling
-		 * routines  resulting in missing sequence counter values
-		 * otherwise,
-		 */
+	bytes = zfcp_qdio_sbals_from_sg(req, direction, fsf_cfdc->sg,
+					FSF_MAX_SBALS_PER_REQ);
+	if (bytes != ZFCP_CFDC_MAX_SIZE) {
+		retval = -ENOMEM;
+		zfcp_fsf_req_free(req);
+		goto out;
+	}
 
-		/* Don't increase for unsolicited status */
-		if (inc_seq_no)
-			adapter->fsf_req_seq_no++;
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(req);
+out:
+	spin_unlock(&adapter->req_q.lock);
+
+	if (!retval) {
+		wait_event(req->completion_wq,
+			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		return req;
 	}
-	return retval;
+	return ERR_PTR(retval);
 }
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:27:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:28:20.000000000 +0200
@@ -76,11 +76,6 @@ zfcp_address_to_sg(void *address, struct
 #define ZFCP_DEVICE_MODEL       0x03
 #define ZFCP_DEVICE_MODEL_PRIV	0x04
 
-/* allow as many chained SBALs as are supported by hardware */
-#define ZFCP_MAX_SBALS_PER_REQ		FSF_MAX_SBALS_PER_REQ
-#define ZFCP_MAX_SBALS_PER_CT_REQ	FSF_MAX_SBALS_PER_REQ
-#define ZFCP_MAX_SBALS_PER_ELS_REQ	FSF_MAX_SBALS_PER_ELS_REQ
-
 /* DMQ bug workaround: don't use last SBALE */
 #define ZFCP_MAX_SBALES_PER_SBAL	(QDIO_MAX_ELEMENTS_PER_BUFFER - 1)
 
@@ -89,21 +84,17 @@ zfcp_address_to_sg(void *address, struct
 
 /* max. number of (data buffer) SBALEs in largest SBAL chain */
 #define ZFCP_MAX_SBALES_PER_REQ		\
-	(ZFCP_MAX_SBALS_PER_REQ * ZFCP_MAX_SBALES_PER_SBAL - 2)
+	(FSF_MAX_SBALS_PER_REQ * ZFCP_MAX_SBALES_PER_SBAL - 2)
         /* request ID + QTCB in SBALE 0 + 1 of first SBAL in chain */
 
 #define ZFCP_MAX_SECTORS (ZFCP_MAX_SBALES_PER_REQ * 8)
         /* max. number of (data buffer) SBALEs in largest SBAL chain
            multiplied with number of sectors per 4k block */
 
-#define ZFCP_SBAL_TIMEOUT               (5*HZ)
-
 #define ZFCP_TYPE2_RECOVERY_TIME        8	/* seconds */
 
 /********************* FSF SPECIFIC DEFINES *********************************/
 
-#define ZFCP_ULP_INFO_VERSION                   26
-#define ZFCP_QTCB_VERSION	FSF_QTCB_CURRENT_VERSION
 /* ATTENTION: value must not be used by hardware */
 #define FSF_QTCB_UNSOLICITED_STATUS		0x6305
 
@@ -121,8 +112,6 @@ typedef unsigned long long fcp_lun_t;
 /* data length field may be at variable position in FCP-2 FCP_CMND IU */
 typedef unsigned int       fcp_dl_t;
 
-#define ZFCP_FC_SERVICE_CLASS_DEFAULT	FSF_CLASS_3
-
 /* timeout for name-server lookup (in seconds) */
 #define ZFCP_NS_GID_PN_TIMEOUT		10
 
@@ -228,7 +217,6 @@ struct fcp_logo {
  * FC-FS stuff
  */
 #define R_A_TOV				10 /* seconds */
-#define ZFCP_ELS_TIMEOUT		(2 * R_A_TOV)
 
 #define ZFCP_LS_RLS			0x0f
 #define ZFCP_LS_ADISC			0x52
@@ -521,7 +509,7 @@ struct zfcp_qdio_queue {
 						 in queue (free_count>0) */
 	atomic_t           count;	      /* number of free buffers
 						 in queue */
-	rwlock_t	   lock;	      /* lock for operations on queue */
+	spinlock_t	   lock;	      /* lock for operations on queue */
 	int                pci_batch;	      /* SBALs since PCI indication
 						 was last set */
 };
@@ -686,7 +674,7 @@ struct zfcp_fsf_req {
 	u32		       fsf_command;    /* FSF Command copy */
 	struct fsf_qtcb	       *qtcb;	       /* address of associated QTCB */
 	u32		       seq_no;         /* Sequence number of request */
-	unsigned long	       data;           /* private data of request */
+	void			*data;           /* private data of request */
 	struct timer_list     timer;	       /* used for erp or scsi er */
 	struct zfcp_erp_action *erp_action;    /* used if this request is
 						  issued on behalf of erp */
@@ -694,10 +682,9 @@ struct zfcp_fsf_req {
 						  from emergency pool */
 	unsigned long long     issued;         /* request sent time (STCK) */
 	struct zfcp_unit       *unit;
+	void			(*handler)(struct zfcp_fsf_req *);
 };
 
-typedef void zfcp_fsf_req_handler_t(struct zfcp_fsf_req*);
-
 /* driver data */
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
@@ -730,7 +717,6 @@ struct zfcp_fsf_req_qtcb {
 /********************** ZFCP SPECIFIC DEFINES ********************************/
 
 #define ZFCP_REQ_AUTO_CLEANUP	0x00000002
-#define ZFCP_WAIT_FOR_SBAL	0x00000004
 #define ZFCP_REQ_NO_QTCB	0x00000008
 
 #define ZFCP_SET                0x00000100
@@ -753,15 +739,6 @@ static inline int zfcp_reqlist_hash(unsi
 	return req_id % REQUEST_LIST_SIZE;
 }
 
-static inline void zfcp_reqlist_add(struct zfcp_adapter *adapter,
-				    struct zfcp_fsf_req *fsf_req)
-{
-	unsigned int idx;
-
-	idx = zfcp_reqlist_hash(fsf_req->req_id);
-	list_add_tail(&fsf_req->list, &adapter->req_list[idx]);
-}
-
 static inline void zfcp_reqlist_remove(struct zfcp_adapter *adapter,
 				       struct zfcp_fsf_req *fsf_req)
 {
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:27:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:28:20.000000000 +0200
@@ -70,21 +70,19 @@ extern struct zfcp_fsf_req *zfcp_fsf_con
 extern void zfcp_fsf_start_timer(struct zfcp_fsf_req *, unsigned long);
 extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
-extern int  zfcp_fsf_status_read(struct zfcp_adapter *, int);
+extern int  zfcp_fsf_status_read(struct zfcp_adapter *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
-extern int zfcp_fsf_req_create(struct zfcp_adapter *, u32, int, mempool_t *,
-			       unsigned long *, struct zfcp_fsf_req **)
-	__acquires(adapter->req_q.lock);
 extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *,
 			    struct zfcp_erp_action *);
 extern int zfcp_fsf_send_els(struct zfcp_send_els *);
 extern int  zfcp_fsf_send_fcp_command_task(struct zfcp_adapter *,
 					   struct zfcp_unit *,
 					   struct scsi_cmnd *, int, int);
-extern int  zfcp_fsf_req_complete(struct zfcp_fsf_req *);
+extern void zfcp_fsf_req_complete(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
-extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_command_task_management(
-	struct zfcp_adapter *, struct zfcp_unit *, u8, int);
+extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_adapter *,
+						     struct zfcp_unit *, u8,
+						     int);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(
 	unsigned long, struct zfcp_adapter *, struct zfcp_unit *, int);
 
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-06-30 11:27:23.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-06-30 11:28:20.000000000 +0200
@@ -961,7 +961,7 @@ void zfcp_san_dbf_event_incoming_els(str
 
 	zfcp_san_dbf_event_els("iels", 1, fsf_req, buf->d_id,
 			       fc_host_port_id(adapter->scsi_host),
-			       *(u8 *)buf->payload, (void *)buf->payload,
+			       buf->payload.data[0], (void *)buf->payload.data,
 			       length);
 }
 
--- a/drivers/s390/scsi/zfcp_fc.c	2008-06-30 11:27:42.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-30 11:28:20.000000000 +0200
@@ -83,8 +83,8 @@ static void zfcp_fc_incoming_rscn(struct
 	u16 no_entries;
 	u32 range_mask;
 
-	fcp_rscn_head = (struct fcp_rscn_head *) status_buffer->payload;
-	fcp_rscn_element = (struct fcp_rscn_element *) status_buffer->payload;
+	fcp_rscn_head = (struct fcp_rscn_head *) status_buffer->payload.data;
+	fcp_rscn_element = (struct fcp_rscn_element *) fcp_rscn_head;
 
 	/* see FC-FS */
 	no_entries = fcp_rscn_head->payload_len /
@@ -135,7 +135,7 @@ static void zfcp_fc_incoming_plogi(struc
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *)req->data;
 	struct fsf_plogi *els_plogi =
-		(struct fsf_plogi *) status_buffer->payload;
+		(struct fsf_plogi *) status_buffer->payload.data;
 
 	zfcp_fc_incoming_wwpn(req, els_plogi->serv_param.wwpn);
 }
@@ -144,7 +144,8 @@ static void zfcp_fc_incoming_logo(struct
 {
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *)req->data;
-	struct fcp_logo *els_logo = (struct fcp_logo *) status_buffer->payload;
+	struct fcp_logo *els_logo =
+		(struct fcp_logo *) status_buffer->payload.data;
 
 	zfcp_fc_incoming_wwpn(req, els_logo->nport_wwpn);
 }
@@ -157,7 +158,7 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 {
 	struct fsf_status_read_buffer *status_buffer =
 		(struct fsf_status_read_buffer *) fsf_req->data;
-	unsigned int els_type = status_buffer->payload[0];
+	unsigned int els_type = status_buffer->payload.data[0];
 
 	zfcp_san_dbf_event_incoming_els(fsf_req);
 	if (els_type == LS_PLOGI)
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-06-30 11:24:30.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-06-30 11:28:20.000000000 +0200
@@ -287,6 +287,18 @@ struct fsf_bit_error_payload {
 	u32 current_transmit_b2b_credit;
 } __attribute__ ((packed));
 
+struct fsf_link_down_info {
+	u32 error_code;
+	u32 res1;
+	u8 res2[2];
+	u8 primary_status;
+	u8 ioerr_code;
+	u8 action_code;
+	u8 reason_code;
+	u8 explanation_code;
+	u8 vendor_specific_code;
+} __attribute__ ((packed));
+
 struct fsf_status_read_buffer {
 	u32 status_type;
 	u32 status_subtype;
@@ -297,7 +309,12 @@ struct fsf_status_read_buffer {
 	u32 class;
 	u64 fcp_lun;
 	u8  res3[24];
-	u8  payload[FSF_STATUS_READ_PAYLOAD_SIZE];
+	union {
+		u8  data[FSF_STATUS_READ_PAYLOAD_SIZE];
+		u32 word[FSF_STATUS_READ_PAYLOAD_SIZE/sizeof(u32)];
+		struct fsf_link_down_info link_down_info;
+		struct fsf_bit_error_payload bit_error;
+	} payload;
 } __attribute__ ((packed));
 
 struct fsf_qual_version_error {
@@ -310,18 +327,6 @@ struct fsf_qual_sequence_error {
 	u32 res1[3];
 } __attribute__ ((packed));
 
-struct fsf_link_down_info {
-	u32 error_code;
-	u32 res1;
-	u8 res2[2];
-	u8 primary_status;
-	u8 ioerr_code;
-	u8 action_code;
-	u8 reason_code;
-	u8 explanation_code;
-	u8 vendor_specific_code;
-} __attribute__ ((packed));
-
 struct fsf_qual_latency_info {
 	u32 channel_lat;
 	u32 fabric_lat;
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-06-30 11:27:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-06-30 11:28:20.000000000 +0200
@@ -182,7 +182,7 @@ static int zfcp_scsi_eh_abort_handler(st
 		zfcp_scsi_dbf_event_abort("lte1", adapter, scpnt, NULL, 0);
 		return retval;
 	}
-	fsf_req->data = 0;
+	fsf_req->data = NULL;
 	fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTING;
 
 	/* don't access old fsf_req after releasing the abort_lock */
@@ -220,8 +220,7 @@ static int zfcp_task_mgmt_function(struc
 	int retval = SUCCESS;
 
 	/* issue task management function */
-	fsf_req = zfcp_fsf_send_fcp_command_task_management
-		(adapter, unit, tm_flags, 0);
+	fsf_req = zfcp_fsf_send_fcp_ctm(adapter, unit, tm_flags, 0);
 	if (!fsf_req) {
 		zfcp_scsi_dbf_event_devreset("nres", tm_flags, unit, scpnt);
 		return FAILED;
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-06-30 11:25:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-06-30 11:28:20.000000000 +0200
@@ -10,7 +10,7 @@
 
 /* FIXME(tune): free space should be one max. SBAL chain plus what? */
 #define ZFCP_QDIO_PCI_INTERVAL	(QDIO_MAX_BUFFERS_PER_Q \
-				- (ZFCP_MAX_SBALS_PER_REQ + 4))
+				- (FSF_MAX_SBALS_PER_REQ + 4))
 #define QBUFF_PER_PAGE		(PAGE_SIZE / sizeof(struct qdio_buffer))
 
 static int zfcp_qdio_buffers_enqueue(struct qdio_buffer **sbal)
@@ -432,9 +432,9 @@ void zfcp_qdio_close(struct zfcp_adapter
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
 	req_q = &adapter->req_q;
-	write_lock_irq(&req_q->lock);
+	spin_lock(&req_q->lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	write_unlock_irq(&req_q->lock);
+	spin_unlock(&req_q->lock);
 
 	while (qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR)
 			== -EINPROGRESS)
--- a/drivers/s390/scsi/zfcp_aux.c	2008-06-30 11:27:59.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-06-30 11:28:20.000000000 +0200
@@ -424,7 +424,7 @@ static void zfcp_dummy_release(struct de
 int zfcp_status_read_refill(struct zfcp_adapter *adapter)
 {
 	while (atomic_read(&adapter->stat_miss) > 0)
-		if (zfcp_fsf_status_read(adapter, ZFCP_WAIT_FOR_SBAL)) {
+		if (zfcp_fsf_status_read(adapter)) {
 			if (atomic_read(&adapter->stat_miss) >= 16) {
 				zfcp_erp_adapter_reopen(adapter, 0, 103, NULL);
 				return 1;
@@ -509,10 +509,10 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	spin_lock_init(&adapter->san_dbf_lock);
 	spin_lock_init(&adapter->scsi_dbf_lock);
 	spin_lock_init(&adapter->rec_dbf_lock);
+	spin_lock_init(&adapter->req_q.lock);
 
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
-	rwlock_init(&adapter->req_q.lock);
 
 	sema_init(&adapter->erp_ready_sem, 0);
 

-- 
