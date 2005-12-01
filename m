From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [patch 2/4] zfcp: fix adapter initialization
Date: Thu, 1 Dec 2005 02:50:36 +0100
Message-ID: <20051201015036.GA13095@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:7823 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751619AbVLABvu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 20:51:50 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id jB11pwBN186740
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 01:51:58 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB11pm9Z204232
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:51:48 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id jB11pmiI009912
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:51:48 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

From: Andreas Herrmann <aherrman@de.ibm.com>

[patch 2/4] zfcp: fix adapter initialization

Fixed various problems in opening sequence of adapters which was previously
changed with NPIV support:
o corrected handling when exchange port data function is not supported,
  otherwise adapters on z900 cannot be opened anymore
o corrected setup of timer for exchange port data if called from error
  recovery
o corrected check of return code of exchange config data

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>


 zfcp_erp.c |   89 +++++++++++++++++++++----------------------------------------
 zfcp_fsf.c |   60 +++++++++++++++++++++--------------------
 2 files changed, 64 insertions(+), 85 deletions(-)

diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_erp.c linux-2.6.x/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_erp.c	2005-12-01 01:15:58.000000000 +0100
+++ linux-2.6.x/drivers/s390/scsi/zfcp_erp.c	2005-12-01 01:16:29.000000000 +0100
@@ -2243,29 +2243,26 @@ zfcp_erp_adapter_strategy_close_qdio(str
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_init
- *
- * purpose:	initializes FSF operation for the specified adapter
- *
- * returns:	0 - succesful initialization of FSF operation
- *		!0 - failed to initialize FSF operation
- */
 static int
 zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *erp_action)
 {
-	int xconfig, xport;
+	int retval;
 
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-			     &erp_action->adapter->status)) {
+	if ((atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
+			      &erp_action->adapter->status)) &&
+	    (erp_action->adapter->adapter_features &
+	     FSF_FEATURE_HBAAPI_MANAGEMENT)) {
 		zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
 		atomic_set(&erp_action->adapter->erp_counter, 0);
 		return ZFCP_ERP_FAILED;
 	}
 
-	xconfig = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
-	xport   = zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
-	if ((xconfig == ZFCP_ERP_FAILED) || (xport == ZFCP_ERP_FAILED))
+	retval = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
+	if (retval == ZFCP_ERP_FAILED)
+		return ZFCP_ERP_FAILED;
+
+	retval = zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
+	if (retval == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
 	return zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
@@ -2354,41 +2351,29 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 static int
 zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *erp_action)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
+	int ret;
 	int retries;
 	int sleep;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 
-	for (retries = 0; ; retries++) {
-		ZFCP_LOG_DEBUG("Doing exchange port data\n");
+	retries = 0;
+	do {
+		write_lock(&adapter->erp_lock);
 		zfcp_erp_action_to_running(erp_action);
+		write_unlock(&adapter->erp_lock);
 		zfcp_erp_timeout_init(erp_action);
-		if (zfcp_fsf_exchange_port_data(erp_action, adapter, NULL)) {
-			retval = ZFCP_ERP_FAILED;
-			debug_text_event(adapter->erp_dbf, 5, "a_fstx_xf");
-			ZFCP_LOG_INFO("error: initiation of exchange of "
-				      "port data failed for adapter %s\n",
-				      zfcp_get_busid_by_adapter(adapter));
-			break;
+		ret = zfcp_fsf_exchange_port_data(erp_action, adapter, NULL);
+		if (ret == -EOPNOTSUPP) {
+			debug_text_event(adapter->erp_dbf, 3, "a_xport_notsupp");
+			return ZFCP_ERP_SUCCEEDED;
+		} else if (ret) {
+			debug_text_event(adapter->erp_dbf, 3, "a_xport_failed");
+			return ZFCP_ERP_FAILED;
 		}
-		debug_text_event(adapter->erp_dbf, 6, "a_fstx_xok");
-		ZFCP_LOG_DEBUG("Xchange underway\n");
+		debug_text_event(adapter->erp_dbf, 6, "a_xport_ok");
 
-		/*
-		 * Why this works:
-		 * Both the normal completion handler as well as the timeout
-		 * handler will do an 'up' when the 'exchange port data'
-		 * request completes or times out. Thus, the signal to go on
-		 * won't be lost utilizing this semaphore.
-		 * Furthermore, this 'adapter_reopen' action is
-		 * guaranteed to be the only action being there (highest action
-		 * which prevents other actions from being created).
-		 * Resulting from that, the wake signal recognized here
-		 * _must_ be the one belonging to the 'exchange port
-		 * data' request.
-		 */
 		down(&adapter->erp_ready_sem);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
 			ZFCP_LOG_INFO("error: exchange of port data "
@@ -2396,29 +2381,19 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 				      zfcp_get_busid_by_adapter(adapter));
 			break;
 		}
-
 		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
 				      &adapter->status))
 			break;
 
-		ZFCP_LOG_DEBUG("host connection still initialising... "
-			       "waiting and retrying...\n");
-		/* sleep a little bit before retry */
-		sleep = retries < ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES ?
-				ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP :
-				ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP;
-		msleep(jiffies_to_msecs(sleep));
-	}
-
-	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
-			     &adapter->status)) {
-		ZFCP_LOG_INFO("error: exchange of port data for "
-			      "adapter %s failed\n",
-			      zfcp_get_busid_by_adapter(adapter));
-		retval = ZFCP_ERP_FAILED;
-	}
+		if (retries < ZFCP_EXCHANGE_PORT_DATA_SHORT_RETRIES) {
+			sleep = ZFCP_EXCHANGE_PORT_DATA_SHORT_SLEEP;
+			retries++;
+		} else
+			sleep = ZFCP_EXCHANGE_PORT_DATA_LONG_SLEEP;
+		schedule_timeout(sleep);
+	} while (1);
 
-	return retval;
+	return ZFCP_ERP_SUCCEEDED;
 }
 
 /*
diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_fsf.c linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_fsf.c	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_fsf.c	2005-12-01 01:16:29.000000000 +0100
@@ -2191,13 +2191,10 @@ zfcp_fsf_exchange_port_data(struct zfcp_
                 return -EOPNOTSUPP;
         }
 
-	timer = kmalloc(sizeof(struct timer_list), GFP_KERNEL);
-	if (!timer)
-		return -ENOMEM;
-
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
-                                     0, 0, &lock_flags, &fsf_req);
+				     erp_action ? ZFCP_REQ_AUTO_CLEANUP : 0,
+				     0, &lock_flags, &fsf_req);
 	if (retval < 0) {
 		ZFCP_LOG_INFO("error: Out of resources. Could not create an "
                               "exchange port data request for"
@@ -2205,25 +2202,33 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 			      zfcp_get_busid_by_adapter(adapter));
 		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
 					lock_flags);
-		goto out;
-	}
-
-	if (erp_action) {
-		erp_action->fsf_req = fsf_req;
-		fsf_req->erp_action = erp_action;
+		return retval;
 	}
 
 	if (data)
-	fsf_req->data = (unsigned long) data;
+		fsf_req->data = (unsigned long) data;
 
 	sbale = zfcp_qdio_sbale_req(fsf_req, fsf_req->sbal_curr, 0);
         sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
         sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
 
-	init_timer(timer);
-	timer->function = zfcp_fsf_request_timeout_handler;
-	timer->data = (unsigned long) adapter;
-	timer->expires = ZFCP_FSF_REQUEST_TIMEOUT;
+	if (erp_action) {
+		erp_action->fsf_req = fsf_req;
+		fsf_req->erp_action = erp_action;
+		timer = &erp_action->timer;
+	} else {
+		timer = kmalloc(sizeof(struct timer_list), GFP_ATOMIC);
+		if (!timer) {
+			write_unlock_irqrestore(&adapter->request_queue.queue_lock,
+						lock_flags);
+			zfcp_fsf_req_free(fsf_req);
+			return -ENOMEM;
+		}
+		init_timer(timer);
+		timer->function = zfcp_fsf_request_timeout_handler;
+		timer->data = (unsigned long) adapter;
+		timer->expires = ZFCP_FSF_REQUEST_TIMEOUT;
+	}
 
 	retval = zfcp_fsf_req_send(fsf_req, timer);
 	if (retval) {
@@ -2233,23 +2238,22 @@ zfcp_fsf_exchange_port_data(struct zfcp_
 		zfcp_fsf_req_free(fsf_req);
 		if (erp_action)
 			erp_action->fsf_req = NULL;
+		else
+			kfree(timer);
 		write_unlock_irqrestore(&adapter->request_queue.queue_lock,
 					lock_flags);
-		goto out;
+		return retval;
 	}
 
-	ZFCP_LOG_DEBUG("Exchange Port Data request initiated (adapter %s)\n",
-		       zfcp_get_busid_by_adapter(adapter));
-
-	write_unlock_irqrestore(&adapter->request_queue.queue_lock,
-				lock_flags);
+	write_unlock_irqrestore(&adapter->request_queue.queue_lock, lock_flags);
 
-	wait_event(fsf_req->completion_wq,
-		   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
-	del_timer_sync(timer);
-	zfcp_fsf_req_free(fsf_req);
- out:
-	kfree(timer);
+	if (!erp_action) {
+		wait_event(fsf_req->completion_wq,
+			   fsf_req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
+		del_timer_sync(timer);
+		zfcp_fsf_req_free(fsf_req);
+		kfree(timer);
+	}
 	return retval;
 }
 
