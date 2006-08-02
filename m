From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/3] zfcp: minor erp bug fixes
Date: Wed, 2 Aug 2006 11:05:52 +0200
Message-ID: <20060802090552.GA11392@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:12468 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750741AbWHBJJs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Aug 2006 05:09:48 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.13.7/8.13.7) with ESMTP id k7299kIK124328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 09:09:46 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k729DEDZ049194
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 11:13:14 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k7299jSO012958
	for <linux-scsi@vger.kernel.org>; Wed, 2 Aug 2006 11:09:45 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Bug fixes for zfcp's erp:
- trigger adapter reopen if do_QDIO fails
- avoid erp deadlock if registration of scsi target or remote port hang
- do not treat as error if exchange port data fails
- decrease timeout for target reset and aborts
- mark unit failed if slave_destroy is called

Additionally some code cleanup was done:
- made some functions void when retval is not of interest
- shortened initialization of zfcp's host_template
- corrected some comments

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h  |    2 
 drivers/s390/scsi/zfcp_erp.c  |  196 ++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_ext.h  |    3 -
 drivers/s390/scsi/zfcp_scsi.c |   73 ++++++++-------
 4 files changed, 107 insertions(+), 167 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 72293f3..904d6a7 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -80,7 +80,7 @@ zfcp_address_to_sg(void *address, struct
 #define REQUEST_LIST_SIZE 128
 
 /********************* SCSI SPECIFIC DEFINES *********************************/
-#define ZFCP_SCSI_ER_TIMEOUT                    (100*HZ)
+#define ZFCP_SCSI_ER_TIMEOUT                    (10*HZ)
 
 /********************* CIO/QDIO SPECIFIC DEFINES *****************************/
 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index f74412b..7f60b6f 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -64,8 +64,8 @@ static int zfcp_erp_strategy_check_actio
 static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *, int);
 static int zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_close_qdio(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_close_fsf(struct zfcp_erp_action *);
+static void zfcp_erp_adapter_strategy_close_qdio(struct zfcp_erp_action *);
+static void zfcp_erp_adapter_strategy_close_fsf(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *);
 static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *);
@@ -93,10 +93,9 @@ static int zfcp_erp_unit_strategy_clears
 static int zfcp_erp_unit_strategy_close(struct zfcp_erp_action *);
 static int zfcp_erp_unit_strategy_open(struct zfcp_erp_action *);
 
-static int zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *);
-static int zfcp_erp_action_dismiss_port(struct zfcp_port *);
-static int zfcp_erp_action_dismiss_unit(struct zfcp_unit *);
-static int zfcp_erp_action_dismiss(struct zfcp_erp_action *);
+static void zfcp_erp_action_dismiss_port(struct zfcp_port *);
+static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *);
+static void zfcp_erp_action_dismiss(struct zfcp_erp_action *);
 
 static int zfcp_erp_action_enqueue(int, struct zfcp_adapter *,
 				   struct zfcp_port *, struct zfcp_unit *);
@@ -135,29 +134,39 @@ zfcp_fsf_request_timeout_handler(unsigne
 	zfcp_erp_adapter_reopen(adapter, 0);
 }
 
-/*
- * function:	zfcp_fsf_scsi_er_timeout_handler
- *
- * purpose:     This function needs to be called whenever a SCSI error recovery
- *              action (abort/reset) does not return.
- *              Re-opening the adapter means that the command can be returned
- *              by zfcp (it is guarranteed that it does not return via the
- *              adapter anymore). The buffer can then be used again.
- *    
- * returns:     sod all
+/**
+ * zfcp_fsf_scsi_er_timeout_handler - timeout handler for scsi eh tasks
+ *
+ * This function needs to be called whenever a SCSI error recovery
+ * action (abort/reset) does not return.  Re-opening the adapter means
+ * that the abort/reset command can be returned by zfcp. It won't complete
+ * via the adapter anymore (because qdio queues are closed). If ERP is
+ * already running on this adapter it will be stopped.
  */
-void
-zfcp_fsf_scsi_er_timeout_handler(unsigned long data)
+void zfcp_fsf_scsi_er_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
+	unsigned long flags;
 
 	ZFCP_LOG_NORMAL("warning: SCSI error recovery timed out. "
 			"Restarting all operations on the adapter %s\n",
 			zfcp_get_busid_by_adapter(adapter));
 	debug_text_event(adapter->erp_dbf, 1, "eh_lmem_tout");
-	zfcp_erp_adapter_reopen(adapter, 0);
 
-	return;
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
+			     &adapter->status)) {
+		zfcp_erp_modify_adapter_status(adapter,
+		       ZFCP_STATUS_COMMON_UNBLOCKED|ZFCP_STATUS_COMMON_OPEN,
+		       ZFCP_CLEAR);
+		zfcp_erp_action_dismiss_adapter(adapter);
+		write_unlock_irqrestore(&adapter->erp_lock, flags);
+		/* dismiss all pending requests including requests for ERP */
+		zfcp_fsf_req_dismiss_all(adapter);
+		adapter->fsf_req_seq_no = 0;
+	} else
+		write_unlock_irqrestore(&adapter->erp_lock, flags);
+	zfcp_erp_adapter_reopen(adapter, 0);
 }
 
 /*
@@ -670,17 +679,10 @@ zfcp_erp_unit_reopen(struct zfcp_unit *u
 	return retval;
 }
 
-/*
- * function:	
- *
- * purpose:	disable I/O,
- *		return any open requests and clean them up,
- *		aim: no pending and incoming I/O
- *
- * returns:
+/**
+ * zfcp_erp_adapter_block - mark adapter as blocked, block scsi requests
  */
-static void
-zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int clear_mask)
+static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int clear_mask)
 {
 	debug_text_event(adapter->erp_dbf, 6, "a_bl");
 	zfcp_erp_modify_adapter_status(adapter,
@@ -688,15 +690,10 @@ zfcp_erp_adapter_block(struct zfcp_adapt
 				       clear_mask, ZFCP_CLEAR);
 }
 
-/*
- * function:	
- *
- * purpose:	enable I/O
- *
- * returns:
+/**
+ * zfcp_erp_adapter_unblock - mark adapter as unblocked, allow scsi requests
  */
-static void
-zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
+static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	debug_text_event(adapter->erp_dbf, 6, "a_ubl");
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
@@ -897,23 +894,15 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 	return retval;
 }
 
-/*
- * purpose:	generic handler for asynchronous events related to erp_action events
- *		(normal completion, time-out, dismissing, retry after
- *		low memory condition)
- *
- * note:	deletion of timer is not required (e.g. in case of a time-out),
- *		but a second try does no harm,
- *		we leave it in here to allow for greater simplification
+/**
+ * zfcp_erp_async_handler_nolock - complete erp_action
  *
- * returns:	0 - there was an action to handle
- *		!0 - otherwise
+ * Used for normal completion, time-out, dismissal and failure after
+ * low memory condition.
  */
-static int
-zfcp_erp_async_handler_nolock(struct zfcp_erp_action *erp_action,
-			      unsigned long set_mask)
+static void zfcp_erp_async_handler_nolock(struct zfcp_erp_action *erp_action,
+					  unsigned long set_mask)
 {
-	int retval;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING) {
@@ -924,43 +913,26 @@ zfcp_erp_async_handler_nolock(struct zfc
 			del_timer(&erp_action->timer);
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
-		retval = 0;
 	} else {
 		/* action is ready or gone - nothing to do */
 		debug_text_event(adapter->erp_dbf, 3, "a_asyh_gone");
 		debug_event(adapter->erp_dbf, 3, &erp_action->action,
 			    sizeof (int));
-		retval = 1;
 	}
-
-	return retval;
 }
 
-/*
- * purpose:	generic handler for asynchronous events related to erp_action
- *               events	(normal completion, time-out, dismissing, retry after
- *		low memory condition)
- *
- * note:	deletion of timer is not required (e.g. in case of a time-out),
- *		but a second try does no harm,
- *		we leave it in here to allow for greater simplification
- *
- * returns:	0 - there was an action to handle
- *		!0 - otherwise
+/**
+ * zfcp_erp_async_handler - wrapper for erp_async_handler_nolock w/ locking
  */
-int
-zfcp_erp_async_handler(struct zfcp_erp_action *erp_action,
-		       unsigned long set_mask)
+void zfcp_erp_async_handler(struct zfcp_erp_action *erp_action,
+			    unsigned long set_mask)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	unsigned long flags;
-	int retval;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	retval = zfcp_erp_async_handler_nolock(erp_action, set_mask);
+	zfcp_erp_async_handler_nolock(erp_action, set_mask);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
-
-	return retval;
 }
 
 /*
@@ -997,17 +969,15 @@ zfcp_erp_timeout_handler(unsigned long d
 	zfcp_erp_async_handler(erp_action, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
-/*
- * purpose:	is called for an erp_action which needs to be ended
- *		though not being done,
- *		this is usually required if an higher is generated,
- *		action gets an appropriate flag and will be processed
- *		accordingly
+/**
+ * zfcp_erp_action_dismiss - dismiss an erp_action
  *
- * locks:	erp_lock held (thus we need to call another handler variant)
+ * adapter->erp_lock must be held
+ * 
+ * Dismissal of an erp_action is usually required if an erp_action of
+ * higher priority is generated.
  */
-static int
-zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
+static void zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
@@ -1015,8 +985,6 @@ zfcp_erp_action_dismiss(struct zfcp_erp_
 	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
 
 	zfcp_erp_async_handler_nolock(erp_action, ZFCP_STATUS_ERP_DISMISSED);
-
-	return 0;
 }
 
 int
@@ -2072,18 +2040,12 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 	return retval;
 }
 
-/*
- * function:    zfcp_qdio_cleanup
- *
- * purpose:	cleans up QDIO operation for the specified adapter
- *
- * returns:	0 - successful cleanup
- *		!0 - failed cleanup
+/**
+ * zfcp_erp_adapter_strategy_close_qdio - close qdio queues for an adapter
  */
-int
+static void
 zfcp_erp_adapter_strategy_close_qdio(struct zfcp_erp_action *erp_action)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
 	int first_used;
 	int used_count;
 	struct zfcp_adapter *adapter = erp_action->adapter;
@@ -2092,15 +2054,13 @@ zfcp_erp_adapter_strategy_close_qdio(str
 		ZFCP_LOG_DEBUG("error: attempt to shut down inactive QDIO "
 			       "queues on adapter %s\n",
 			       zfcp_get_busid_by_adapter(adapter));
-		retval = ZFCP_ERP_FAILED;
-		goto out;
+		return;
 	}
 
 	/*
 	 * Get queue_lock and clear QDIOUP flag. Thus it's guaranteed that
 	 * do_QDIO won't be called while qdio_shutdown is in progress.
 	 */
-
 	write_lock_irq(&adapter->request_queue.queue_lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
 	write_unlock_irq(&adapter->request_queue.queue_lock);
@@ -2132,8 +2092,6 @@ zfcp_erp_adapter_strategy_close_qdio(str
 	adapter->request_queue.free_index = 0;
 	atomic_set(&adapter->request_queue.free_count, 0);
 	adapter->request_queue.distance_from_int = 0;
- out:
-	return retval;
 }
 
 static int
@@ -2256,11 +2214,11 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 			      "%s)\n", zfcp_get_busid_by_adapter(adapter));
 		ret = ZFCP_ERP_FAILED;
 	}
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status)) {
-		ZFCP_LOG_INFO("error: exchange port data failed (adapter "
+
+	/* don't treat as error for the sake of compatibility */
+	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status))
+		ZFCP_LOG_INFO("warning: exchange port data failed (adapter "
 			      "%s\n", zfcp_get_busid_by_adapter(adapter));
-		ret = ZFCP_ERP_FAILED;
-	}
 
 	return ret;
 }
@@ -2290,18 +2248,12 @@ zfcp_erp_adapter_strategy_open_fsf_statu
 	return retval;
 }
 
-/*
- * function:    zfcp_fsf_cleanup
- *
- * purpose:	cleanup FSF operation for specified adapter
- *
- * returns:	0 - FSF operation successfully cleaned up
- *		!0 - failed to cleanup FSF operation for this adapter
+/**
+ * zfcp_erp_adapter_strategy_close_fsf - stop FSF operations for an adapter
  */
-static int
+static void
 zfcp_erp_adapter_strategy_close_fsf(struct zfcp_erp_action *erp_action)
 {
-	int retval = ZFCP_ERP_SUCCEEDED;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	/*
@@ -2315,8 +2267,6 @@ zfcp_erp_adapter_strategy_close_fsf(stru
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
-
-	return retval;
 }
 
 /*
@@ -3291,10 +3241,8 @@ zfcp_erp_action_cleanup(int action, stru
 }
 
 
-static int
-zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
+void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
 	struct zfcp_port *port;
 
 	debug_text_event(adapter->erp_dbf, 5, "a_actab");
@@ -3303,14 +3251,10 @@ zfcp_erp_action_dismiss_adapter(struct z
 	else
 		list_for_each_entry(port, &adapter->port_list_head, list)
 		    zfcp_erp_action_dismiss_port(port);
-
-	return retval;
 }
 
-static int
-zfcp_erp_action_dismiss_port(struct zfcp_port *port)
+static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 {
-	int retval = 0;
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter = port->adapter;
 
@@ -3321,22 +3265,16 @@ zfcp_erp_action_dismiss_port(struct zfcp
 	else
 		list_for_each_entry(unit, &port->unit_list_head, list)
 		    zfcp_erp_action_dismiss_unit(unit);
-
-	return retval;
 }
 
-static int
-zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
+static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
 {
-	int retval = 0;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	debug_text_event(adapter->erp_dbf, 5, "u_actab");
 	debug_event(adapter->erp_dbf, 5, &unit->fcp_lun, sizeof (fcp_lun_t));
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status))
 		zfcp_erp_action_dismiss(&unit->erp_action);
-
-	return retval;
 }
 
 static inline void
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 04bb3a9..146d7a2 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -139,6 +139,7 @@ extern void zfcp_erp_modify_adapter_stat
 extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int);
 extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int);
 extern void zfcp_erp_adapter_failed(struct zfcp_adapter *);
+extern void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *);
 
 extern void zfcp_erp_modify_port_status(struct zfcp_port *, u32, int);
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int);
@@ -155,7 +156,7 @@ extern void zfcp_erp_unit_failed(struct 
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern int  zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern int  zfcp_erp_wait(struct zfcp_adapter *);
-extern int  zfcp_erp_async_handler(struct zfcp_erp_action *, unsigned long);
+extern void zfcp_erp_async_handler(struct zfcp_erp_action *, unsigned long);
 
 extern int  zfcp_test_link(struct zfcp_port *);
 
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 671f4a6..1bb5508 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -30,7 +30,6 @@ static int zfcp_scsi_queuecommand(struct
 				  void (*done) (struct scsi_cmnd *));
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *);
-static int zfcp_scsi_eh_bus_reset_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *);
 static int zfcp_task_management_function(struct zfcp_unit *, u8,
 					 struct scsi_cmnd *);
@@ -46,30 +45,22 @@ struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
 		.name			= ZFCP_NAME,
 		.proc_name		= "zfcp",
-		.proc_info		= NULL,
-		.detect			= NULL,
 		.slave_alloc		= zfcp_scsi_slave_alloc,
 		.slave_configure	= zfcp_scsi_slave_configure,
 		.slave_destroy		= zfcp_scsi_slave_destroy,
 		.queuecommand		= zfcp_scsi_queuecommand,
 		.eh_abort_handler	= zfcp_scsi_eh_abort_handler,
 		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
-		.eh_bus_reset_handler	= zfcp_scsi_eh_bus_reset_handler,
+		.eh_bus_reset_handler	= zfcp_scsi_eh_host_reset_handler,
 		.eh_host_reset_handler	= zfcp_scsi_eh_host_reset_handler,
 		.can_queue		= 4096,
 		.this_id		= -1,
-		/*
-		 * FIXME:
-		 * one less? can zfcp_create_sbale cope with it?
-		 */
 		.sg_tablesize		= ZFCP_MAX_SBALES_PER_REQ,
 		.cmd_per_lun		= 1,
-		.unchecked_isa_dma	= 0,
 		.use_clustering		= 1,
 		.sdev_attrs		= zfcp_sysfs_sdev_attrs,
 	},
 	.driver_version = ZFCP_VERSION,
-	/* rest initialised with zeros */
 };
 
 /* Find start of Response Information in FCP response unit*/
@@ -176,8 +167,14 @@ zfcp_scsi_slave_alloc(struct scsi_device
 	return retval;
 }
 
-static void
-zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
+/**
+ * zfcp_scsi_slave_destroy - called when scsi device is removed
+ *
+ * Remove reference to associated scsi device for an zfcp_unit.
+ * Mark zfcp_unit as failed. The scsi device might be deleted via sysfs
+ * or a scan for this device might have failed.
+ */
+static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 
@@ -185,6 +182,7 @@ zfcp_scsi_slave_destroy(struct scsi_devi
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;
+		zfcp_erp_unit_failed(unit);
 		zfcp_unit_put(unit);
 	} else {
 		ZFCP_LOG_NORMAL("bug: no unit associated with SCSI device at "
@@ -549,35 +547,38 @@ zfcp_task_management_function(struct zfc
 }
 
 /**
- * zfcp_scsi_eh_bus_reset_handler - reset bus (reopen adapter)
+ * zfcp_scsi_eh_host_reset_handler - handler for host and bus reset
+ *
+ * If ERP is already running it will be stopped.
  */
-int
-zfcp_scsi_eh_bus_reset_handler(struct scsi_cmnd *scpnt)
+int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_unit *unit = (struct zfcp_unit*) scpnt->device->hostdata;
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	ZFCP_LOG_NORMAL("bus reset because of problems with "
-			"unit 0x%016Lx\n", unit->fcp_lun);
-	zfcp_erp_adapter_reopen(adapter, 0);
-	zfcp_erp_wait(adapter);
-
-	return SUCCESS;
-}
+	struct zfcp_unit *unit;
+	struct zfcp_adapter *adapter;
+	unsigned long flags;
 
-/**
- * zfcp_scsi_eh_host_reset_handler - reset host (reopen adapter)
- */
-int
-zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
-{
-	struct zfcp_unit *unit = (struct zfcp_unit*) scpnt->device->hostdata;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	unit = (struct zfcp_unit*) scpnt->device->hostdata;
+	adapter = unit->port->adapter;
 
-	ZFCP_LOG_NORMAL("host reset because of problems with "
+	ZFCP_LOG_NORMAL("host/bus reset because of problems with "
 			"unit 0x%016Lx\n", unit->fcp_lun);
-	zfcp_erp_adapter_reopen(adapter, 0);
-	zfcp_erp_wait(adapter);
+
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
+			     &adapter->status)) {
+		zfcp_erp_modify_adapter_status(adapter,
+		       ZFCP_STATUS_COMMON_UNBLOCKED|ZFCP_STATUS_COMMON_OPEN,
+		       ZFCP_CLEAR);
+		zfcp_erp_action_dismiss_adapter(adapter);
+		write_unlock_irqrestore(&adapter->erp_lock, flags);
+		zfcp_fsf_req_dismiss_all(adapter);
+		adapter->fsf_req_seq_no = 0;
+		zfcp_erp_adapter_reopen(adapter, 0);
+	} else {
+		write_unlock_irqrestore(&adapter->erp_lock, flags);
+		zfcp_erp_adapter_reopen(adapter, 0);
+		zfcp_erp_wait(adapter);
+	}
 
 	return SUCCESS;
 }
-- 
1.4.2.rc2.gef1d9

