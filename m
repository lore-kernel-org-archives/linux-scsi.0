From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/11] zfcp: Remove obsolete erp_dbf trace
Date: Thu, 27 Mar 2008 14:22:05 +0100
Message-ID: <20080327133031.642561000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50815 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759664AbYC0Nag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:36 -0400
Content-Disposition: inline; filename=zfcp_erp_dbf_removal.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch removes the now obsolete erp_dbf trace.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    1 
 drivers/s390/scsi/zfcp_ccw.c  |    3 
 drivers/s390/scsi/zfcp_dbf.c  |   11 -
 drivers/s390/scsi/zfcp_def.h  |    8 -
 drivers/s390/scsi/zfcp_erp.c  |  305 ------------------------------------------
 drivers/s390/scsi/zfcp_fsf.c  |  199 ---------------------------
 drivers/s390/scsi/zfcp_qdio.c |    2 
 7 files changed, 4 insertions(+), 525 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-03-27 13:48:37.000000000 +0100
@@ -1030,7 +1030,6 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	/* initialize debug locks */
 
-	spin_lock_init(&adapter->erp_dbf_lock);
 	spin_lock_init(&adapter->hba_dbf_lock);
 	spin_lock_init(&adapter->san_dbf_lock);
 	spin_lock_init(&adapter->scsi_dbf_lock);
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:48:37.000000000 +0100
@@ -223,19 +223,16 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 	case CIO_GONE:
 		ZFCP_LOG_NORMAL("adapter %s: device gone\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf,1,"dev_gone");
 		zfcp_erp_adapter_shutdown(adapter, 0, 87, 0);
 		break;
 	case CIO_NO_PATH:
 		ZFCP_LOG_NORMAL("adapter %s: no path\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf,1,"no_path");
 		zfcp_erp_adapter_shutdown(adapter, 0, 88, 0);
 		break;
 	case CIO_OPER:
 		ZFCP_LOG_NORMAL("adapter %s: operational again\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf,1,"dev_oper");
 		zfcp_erp_modify_adapter_status(adapter, 11, 0,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:48:19.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:48:37.000000000 +0100
@@ -1302,15 +1302,6 @@ int zfcp_adapter_debug_register(struct z
 	char dbf_name[DEBUG_MAX_NAME_LEN];
 
 	/* debug feature area which records recovery activity */
-	sprintf(dbf_name, "zfcp_%s_erp", zfcp_get_busid_by_adapter(adapter));
-	adapter->erp_dbf = debug_register(dbf_name, dbfsize, 2,
-					  sizeof(struct zfcp_erp_dbf_record));
-	if (!adapter->erp_dbf)
-		goto failed;
-	debug_register_view(adapter->erp_dbf, &debug_hex_ascii_view);
-	debug_set_level(adapter->erp_dbf, 3);
-
-	/* debug feature area which records recovery activity */
 	sprintf(dbf_name, "zfcp_%s_rec", zfcp_get_busid_by_adapter(adapter));
 	adapter->rec_dbf = debug_register(dbf_name, dbfsize, 1,
 					  sizeof(struct zfcp_rec_dbf_record));
@@ -1368,12 +1359,10 @@ void zfcp_adapter_debug_unregister(struc
 	debug_unregister(adapter->san_dbf);
 	debug_unregister(adapter->hba_dbf);
 	debug_unregister(adapter->rec_dbf);
-	debug_unregister(adapter->erp_dbf);
 	adapter->scsi_dbf = NULL;
 	adapter->san_dbf = NULL;
 	adapter->hba_dbf = NULL;
 	adapter->rec_dbf = NULL;
-	adapter->erp_dbf = NULL;
 }
 
 #undef ZFCP_LOG_AREA
--- a/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:48:19.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:48:37.000000000 +0100
@@ -274,11 +274,6 @@ struct zfcp_dbf_dump {
 	u8 data[];		/* dump data */
 } __attribute__ ((packed));
 
-/* FIXME: to be inflated when reworking the erp dbf */
-struct zfcp_erp_dbf_record {
-	u8 dummy[16];
-} __attribute__ ((packed));
-
 struct zfcp_rec_dbf_record_thread {
 	u32 sema;
 	u32 total;
@@ -969,17 +964,14 @@ struct zfcp_adapter {
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
 	struct zfcp_port	*nameserver_port;  /* adapter's nameserver */
-	debug_info_t		*erp_dbf;
 	debug_info_t		*rec_dbf;
 	debug_info_t		*hba_dbf;
 	debug_info_t		*san_dbf;          /* debug feature areas */
 	debug_info_t		*scsi_dbf;
-	spinlock_t		erp_dbf_lock;
 	spinlock_t		rec_dbf_lock;
 	spinlock_t		hba_dbf_lock;
 	spinlock_t		san_dbf_lock;
 	spinlock_t		scsi_dbf_lock;
-	struct zfcp_erp_dbf_record	erp_dbf_buf;
 	struct zfcp_rec_dbf_record	rec_dbf_buf;
 	struct zfcp_hba_dbf_record	hba_dbf_buf;
 	struct zfcp_san_dbf_record	san_dbf_buf;
--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:48:19.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:48:37.000000000 +0100
@@ -132,11 +132,9 @@ static void zfcp_close_qdio(struct zfcp_
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
 	write_unlock_irq(&req_queue->queue_lock);
 
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down2a");
 	while (qdio_shutdown(adapter->ccw_device,
 			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
 		ssleep(1);
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down2b");
 
 	/* cleanup used outbound sbals */
 	count = atomic_read(&req_queue->free_count);
@@ -209,7 +207,6 @@ static int zfcp_erp_adapter_reopen_inter
 {
 	int retval;
 
-	debug_text_event(adapter->erp_dbf, 5, "a_ro");
 	ZFCP_LOG_DEBUG("reopen adapter %s\n",
 		       zfcp_get_busid_by_adapter(adapter));
 
@@ -218,7 +215,6 @@ static int zfcp_erp_adapter_reopen_inter
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status)) {
 		ZFCP_LOG_DEBUG("skipped reopen of failed adapter %s\n",
 			       zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf, 5, "a_ro_f");
 		/* ensure propagation of failed status to new devices */
 		zfcp_erp_adapter_failed(adapter, 13, 0);
 		retval = -EIO;
@@ -403,7 +399,6 @@ zfcp_erp_adisc_handler(unsigned long dat
 				"force physical port reopen "
 				"(adapter %s, port d_id=0x%06x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
-		debug_text_event(adapter->erp_dbf, 3, "forcreop");
 		if (zfcp_erp_port_forced_reopen(port, 0, 63, 0))
 			ZFCP_LOG_NORMAL("failed reopen of port "
 					"(adapter %s, wwpn=0x%016Lx)\n",
@@ -492,10 +487,6 @@ static int zfcp_erp_port_forced_reopen_i
 						int clear_mask, u8 id, u64 ref)
 {
 	int retval;
-	struct zfcp_adapter *adapter = port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 5, "pf_ro");
-	debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 
 	ZFCP_LOG_DEBUG("forced reopen of port 0x%016Lx on adapter %s\n",
 		       port->wwpn, zfcp_get_busid_by_port(port));
@@ -506,8 +497,6 @@ static int zfcp_erp_port_forced_reopen_i
 		ZFCP_LOG_DEBUG("skipped forced reopen of failed port 0x%016Lx "
 			       "on adapter %s\n", port->wwpn,
 			       zfcp_get_busid_by_port(port));
-		debug_text_event(adapter->erp_dbf, 5, "pf_ro_f");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		retval = -EIO;
 		goto out;
 	}
@@ -560,10 +549,6 @@ static int zfcp_erp_port_reopen_internal
 					 u8 id, u64 ref)
 {
 	int retval;
-	struct zfcp_adapter *adapter = port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 5, "p_ro");
-	debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 
 	ZFCP_LOG_DEBUG("reopen of port 0x%016Lx on adapter %s\n",
 		       port->wwpn, zfcp_get_busid_by_port(port));
@@ -574,8 +559,6 @@ static int zfcp_erp_port_reopen_internal
 		ZFCP_LOG_DEBUG("skipped reopen of failed port 0x%016Lx "
 			       "on adapter %s\n", port->wwpn,
 			       zfcp_get_busid_by_port(port));
-		debug_text_event(adapter->erp_dbf, 5, "p_ro_f");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* ensure propagation of failed status to new devices */
 		zfcp_erp_port_failed(port, 14, 0);
 		retval = -EIO;
@@ -630,8 +613,6 @@ static int zfcp_erp_unit_reopen_internal
 	int retval;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	debug_text_event(adapter->erp_dbf, 5, "u_ro");
-	debug_event(adapter->erp_dbf, 5, &unit->fcp_lun, sizeof (fcp_lun_t));
 	ZFCP_LOG_DEBUG("reopen of unit 0x%016Lx on port 0x%016Lx "
 		       "on adapter %s\n", unit->fcp_lun,
 		       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
@@ -643,9 +624,6 @@ static int zfcp_erp_unit_reopen_internal
 			       "on port 0x%016Lx on adapter %s\n",
 			       unit->fcp_lun, unit->port->wwpn,
 			       zfcp_get_busid_by_unit(unit));
-		debug_text_event(adapter->erp_dbf, 5, "u_ro_f");
-		debug_event(adapter->erp_dbf, 5, &unit->fcp_lun,
-			    sizeof (fcp_lun_t));
 		retval = -EIO;
 		goto out;
 	}
@@ -690,7 +668,6 @@ int zfcp_erp_unit_reopen(struct zfcp_uni
  */
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int clear_mask)
 {
-	debug_text_event(adapter->erp_dbf, 6, "a_bl");
 	zfcp_erp_modify_adapter_status(adapter, 15, 0,
 				       ZFCP_STATUS_COMMON_UNBLOCKED |
 				       clear_mask, ZFCP_CLEAR);
@@ -725,7 +702,6 @@ static int atomic_test_and_clear_mask(un
  */
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
-	debug_text_event(adapter->erp_dbf, 6, "a_ubl");
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &adapter->status))
 		zfcp_rec_dbf_event_adapter(16, 0, adapter);
@@ -743,10 +719,6 @@ static void zfcp_erp_adapter_unblock(str
 static void
 zfcp_erp_port_block(struct zfcp_port *port, int clear_mask)
 {
-	struct zfcp_adapter *adapter = port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "p_bl");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	zfcp_erp_modify_port_status(port, 17, 0,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
@@ -762,10 +734,6 @@ zfcp_erp_port_block(struct zfcp_port *po
 static void
 zfcp_erp_port_unblock(struct zfcp_port *port)
 {
-	struct zfcp_adapter *adapter = port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "p_ubl");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &port->status))
 		zfcp_rec_dbf_event_port(18, 0, port);
@@ -783,10 +751,6 @@ zfcp_erp_port_unblock(struct zfcp_port *
 static void
 zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "u_bl");
-	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
 	zfcp_erp_modify_unit_status(unit, 19, 0,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
@@ -802,10 +766,6 @@ zfcp_erp_unit_block(struct zfcp_unit *un
 static void
 zfcp_erp_unit_unblock(struct zfcp_unit *unit)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "u_ubl");
-	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &unit->status))
 		zfcp_rec_dbf_event_unit(20, 0, unit);
@@ -816,9 +776,6 @@ zfcp_erp_action_ready(struct zfcp_erp_ac
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	debug_text_event(adapter->erp_dbf, 4, "a_ar");
-	debug_event(adapter->erp_dbf, 4, &erp_action->action, sizeof (int));
-
 	zfcp_erp_action_to_ready(erp_action);
 	up(&adapter->erp_ready_sem);
 	zfcp_rec_dbf_event_thread(2, adapter, 0);
@@ -883,14 +840,9 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 		if (zfcp_reqlist_find_safe(adapter, erp_action->fsf_req) &&
 		    erp_action->fsf_req->erp_action == erp_action) {
 			/* fsf_req still exists */
-			debug_text_event(adapter->erp_dbf, 3, "a_ca_req");
-			debug_event(adapter->erp_dbf, 3, &erp_action->fsf_req,
-				    sizeof (unsigned long));
 			/* dismiss fsf_req of timed out/dismissed erp_action */
 			if (erp_action->status & (ZFCP_STATUS_ERP_DISMISSED |
 						  ZFCP_STATUS_ERP_TIMEDOUT)) {
-				debug_text_event(adapter->erp_dbf, 3,
-						 "a_ca_disreq");
 				erp_action->fsf_req->status |=
 					ZFCP_STATUS_FSFREQ_DISMISSED;
 				zfcp_rec_dbf_event_action(142, erp_action);
@@ -915,7 +867,6 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 				erp_action->fsf_req = NULL;
 			}
 		} else {
-			debug_text_event(adapter->erp_dbf, 3, "a_ca_gonereq");
 			/*
 			 * even if this fsf_req has gone, forget about
 			 * association between erp_action and fsf_req
@@ -923,8 +874,7 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 			erp_action->fsf_req = NULL;
 		}
 		spin_unlock(&adapter->req_list_lock);
-	} else
-		debug_text_event(adapter->erp_dbf, 3, "a_ca_noreq");
+	}
 }
 
 /**
@@ -936,19 +886,11 @@ zfcp_erp_strategy_check_fsfreq(struct zf
 static void zfcp_erp_async_handler_nolock(struct zfcp_erp_action *erp_action,
 					  unsigned long set_mask)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
 	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING) {
-		debug_text_event(adapter->erp_dbf, 2, "a_asyh_ex");
-		debug_event(adapter->erp_dbf, 2, &erp_action->action,
-			    sizeof (int));
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
 	} else {
 		/* action is ready or gone - nothing to do */
-		debug_text_event(adapter->erp_dbf, 3, "a_asyh_gone");
-		debug_event(adapter->erp_dbf, 3, &erp_action->action,
-			    sizeof (int));
 	}
 }
 
@@ -975,10 +917,6 @@ static void
 zfcp_erp_memwait_handler(unsigned long data)
 {
 	struct zfcp_erp_action *erp_action = (struct zfcp_erp_action *) data;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	debug_text_event(adapter->erp_dbf, 2, "a_mwh");
-	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
 
 	zfcp_erp_async_handler(erp_action, 0);
 }
@@ -991,10 +929,6 @@ zfcp_erp_memwait_handler(unsigned long d
 static void zfcp_erp_timeout_handler(unsigned long data)
 {
 	struct zfcp_erp_action *erp_action = (struct zfcp_erp_action *) data;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	debug_text_event(adapter->erp_dbf, 2, "a_th");
-	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
 
 	zfcp_erp_async_handler(erp_action, ZFCP_STATUS_ERP_TIMEDOUT);
 }
@@ -1009,11 +943,6 @@ static void zfcp_erp_timeout_handler(uns
  */
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	debug_text_event(adapter->erp_dbf, 2, "a_adis");
-	debug_event(adapter->erp_dbf, 2, &erp_action->action, sizeof (int));
-
 	erp_action->status |= ZFCP_STATUS_ERP_DISMISSED;
 	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING)
 		zfcp_erp_action_ready(erp_action);
@@ -1031,12 +960,10 @@ zfcp_erp_thread_setup(struct zfcp_adapte
 		ZFCP_LOG_NORMAL("error: creation of erp thread failed for "
 				"adapter %s\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf, 5, "a_thset_fail");
 	} else {
 		wait_event(adapter->erp_thread_wqh,
 			   atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
 					    &adapter->status));
-		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
 	}
 
 	return (retval < 0);
@@ -1072,8 +999,6 @@ zfcp_erp_thread_kill(struct zfcp_adapter
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
 			  &adapter->status);
 
-	debug_text_event(adapter->erp_dbf, 5, "a_thki_ok");
-
 	return retval;
 }
 
@@ -1096,7 +1021,6 @@ zfcp_erp_thread(void *data)
 	/* Block all signals */
 	siginitsetinv(&current->blocked, 0);
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	debug_text_event(adapter->erp_dbf, 5, "a_th_run");
 	wake_up(&adapter->erp_thread_wqh);
 
 	while (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
@@ -1124,11 +1048,9 @@ zfcp_erp_thread(void *data)
 		zfcp_rec_dbf_event_thread(4, adapter, 1);
 		down_interruptible(&adapter->erp_ready_sem);
 		zfcp_rec_dbf_event_thread(5, adapter, 1);
-		debug_text_event(adapter->erp_dbf, 5, "a_th_woken");
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	debug_text_event(adapter->erp_dbf, 5, "a_th_stop");
 	wake_up(&adapter->erp_thread_wqh);
 
 	return 0;
@@ -1164,7 +1086,6 @@ zfcp_erp_strategy(struct zfcp_erp_action
 	/* dequeue dismissed action and leave, if required */
 	retval = zfcp_erp_strategy_check_action(erp_action, retval);
 	if (retval == ZFCP_ERP_DISMISSED) {
-		debug_text_event(adapter->erp_dbf, 4, "a_st_dis1");
 		goto unlock;
 	}
 
@@ -1215,20 +1136,17 @@ zfcp_erp_strategy(struct zfcp_erp_action
 		   element was timed out.
 		 */
 		if (adapter->erp_total_count == adapter->erp_low_mem_count) {
-			debug_text_event(adapter->erp_dbf, 3, "a_st_lowmem");
 			ZFCP_LOG_NORMAL("error: no mempool elements available, "
 					"restarting I/O on adapter %s "
 					"to free mempool\n",
 					zfcp_get_busid_by_adapter(adapter));
 			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, 0);
 		} else {
-		debug_text_event(adapter->erp_dbf, 2, "a_st_memw");
 		retval = zfcp_erp_strategy_memwait(erp_action);
 		}
 		goto unlock;
 	case ZFCP_ERP_CONTINUES:
 		/* leave since this action runs asynchronously */
-		debug_text_event(adapter->erp_dbf, 6, "a_st_cont");
 		if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
 			--adapter->erp_low_mem_count;
 			erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
@@ -1257,7 +1175,6 @@ zfcp_erp_strategy(struct zfcp_erp_action
 	 * action is repeated in order to process state change
 	 */
 	if (retval == ZFCP_ERP_EXIT) {
-		debug_text_event(adapter->erp_dbf, 2, "a_st_exit");
 		goto unlock;
 	}
 
@@ -1283,8 +1200,6 @@ zfcp_erp_strategy(struct zfcp_erp_action
 	if (retval != ZFCP_ERP_DISMISSED)
 		zfcp_erp_strategy_check_queues(adapter);
 
-	debug_text_event(adapter->erp_dbf, 6, "a_st_done");
-
 	return retval;
 }
 
@@ -1299,17 +1214,12 @@ zfcp_erp_strategy(struct zfcp_erp_action
 static int
 zfcp_erp_strategy_check_action(struct zfcp_erp_action *erp_action, int retval)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
 	zfcp_erp_strategy_check_fsfreq(erp_action);
 
-	debug_event(adapter->erp_dbf, 5, &erp_action->action, sizeof (int));
 	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED) {
-		debug_text_event(adapter->erp_dbf, 3, "a_stcd_dis");
 		zfcp_erp_action_dequeue(erp_action);
 		retval = ZFCP_ERP_DISMISSED;
-	} else
-		debug_text_event(adapter->erp_dbf, 5, "a_stcd_nodis");
+	}
 
 	return retval;
 }
@@ -1318,7 +1228,6 @@ static int
 zfcp_erp_strategy_do_action(struct zfcp_erp_action *erp_action)
 {
 	int retval = ZFCP_ERP_FAILED;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	/*
 	 * try to execute/continue action as far as possible,
@@ -1348,9 +1257,6 @@ zfcp_erp_strategy_do_action(struct zfcp_
 		break;
 
 	default:
-		debug_text_exception(adapter->erp_dbf, 1, "a_stda_bug");
-		debug_event(adapter->erp_dbf, 1, &erp_action->action,
-			    sizeof (int));
 		ZFCP_LOG_NORMAL("bug: unknown erp action requested on "
 				"adapter %s (action=%d)\n",
 				zfcp_get_busid_by_adapter(erp_action->adapter),
@@ -1372,10 +1278,7 @@ static int
 zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 {
 	int retval = ZFCP_ERP_CONTINUES;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	debug_text_event(adapter->erp_dbf, 6, "a_mwinit");
-	debug_event(adapter->erp_dbf, 6, &erp_action->action, sizeof (int));
 	init_timer(&erp_action->timer);
 	erp_action->timer.function = zfcp_erp_memwait_handler;
 	erp_action->timer.data = (unsigned long) erp_action;
@@ -1398,7 +1301,6 @@ zfcp_erp_adapter_failed(struct zfcp_adap
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 	ZFCP_LOG_NORMAL("adapter erp failed on adapter %s\n",
 			zfcp_get_busid_by_adapter(adapter));
-	debug_text_event(adapter->erp_dbf, 2, "a_afail");
 }
 
 /*
@@ -1420,9 +1322,6 @@ zfcp_erp_port_failed(struct zfcp_port *p
 	else
 		ZFCP_LOG_NORMAL("port erp failed (adapter %s, wwpn=0x%016Lx)\n",
 				zfcp_get_busid_by_port(port), port->wwpn);
-
-	debug_text_event(port->adapter->erp_dbf, 2, "p_pfail");
-	debug_event(port->adapter->erp_dbf, 2, &port->wwpn, sizeof (wwn_t));
 }
 
 /*
@@ -1440,9 +1339,6 @@ zfcp_erp_unit_failed(struct zfcp_unit *u
 	ZFCP_LOG_NORMAL("unit erp failed on unit 0x%016Lx on port 0x%016Lx "
 			" on adapter %s\n", unit->fcp_lun,
 			unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-	debug_text_event(unit->port->adapter->erp_dbf, 2, "u_ufail");
-	debug_event(unit->port->adapter->erp_dbf, 2,
-		    &unit->fcp_lun, sizeof (fcp_lun_t));
 }
 
 /*
@@ -1466,10 +1362,6 @@ zfcp_erp_strategy_check_target(struct zf
 	struct zfcp_port *port = erp_action->port;
 	struct zfcp_unit *unit = erp_action->unit;
 
-	debug_text_event(adapter->erp_dbf, 5, "a_stct_norm");
-	debug_event(adapter->erp_dbf, 5, &erp_action->action, sizeof (int));
-	debug_event(adapter->erp_dbf, 5, &result, sizeof (int));
-
 	switch (erp_action->action) {
 
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
@@ -1496,9 +1388,6 @@ zfcp_erp_strategy_statechange(int action
 			      struct zfcp_port *port,
 			      struct zfcp_unit *unit, int retval)
 {
-	debug_text_event(adapter->erp_dbf, 3, "a_stsc");
-	debug_event(adapter->erp_dbf, 3, &action, sizeof (int));
-
 	switch (action) {
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
@@ -1551,10 +1440,6 @@ zfcp_erp_strategy_statechange_detected(a
 static int
 zfcp_erp_strategy_check_unit(struct zfcp_unit *unit, int result)
 {
-	debug_text_event(unit->port->adapter->erp_dbf, 5, "u_stct");
-	debug_event(unit->port->adapter->erp_dbf, 5, &unit->fcp_lun,
-		    sizeof (fcp_lun_t));
-
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&unit->erp_counter, 0);
@@ -1581,9 +1466,6 @@ zfcp_erp_strategy_check_unit(struct zfcp
 static int
 zfcp_erp_strategy_check_port(struct zfcp_port *port, int result)
 {
-	debug_text_event(port->adapter->erp_dbf, 5, "p_stct");
-	debug_event(port->adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
-
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&port->erp_counter, 0);
@@ -1610,8 +1492,6 @@ zfcp_erp_strategy_check_port(struct zfcp
 static int
 zfcp_erp_strategy_check_adapter(struct zfcp_adapter *adapter, int result)
 {
-	debug_text_event(adapter->erp_dbf, 5, "a_stct");
-
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&adapter->erp_counter, 0);
@@ -1703,9 +1583,6 @@ zfcp_erp_strategy_followup_actions(int a
 				   struct zfcp_port *port,
 				   struct zfcp_unit *unit, int status)
 {
-	debug_text_event(adapter->erp_dbf, 5, "a_stfol");
-	debug_event(adapter->erp_dbf, 5, &action, sizeof (int));
-
 	/* initiate follow-up actions depending on success of finished action */
 	switch (action) {
 
@@ -1749,12 +1626,10 @@ zfcp_erp_strategy_check_queues(struct zf
 	read_lock(&adapter->erp_lock);
 	if (list_empty(&adapter->erp_ready_head) &&
 	    list_empty(&adapter->erp_running_head)) {
-			debug_text_event(adapter->erp_dbf, 4, "a_cq_wake");
 			atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
 					  &adapter->status);
 			wake_up(&adapter->erp_done_wqh);
-	} else
-		debug_text_event(adapter->erp_dbf, 5, "a_cq_notempty");
+	}
 	read_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
@@ -1786,16 +1661,13 @@ void zfcp_erp_modify_adapter_status(stru
 
 	if (set_or_clear == ZFCP_SET) {
 		changed = atomic_test_and_set_mask(mask, &adapter->status);
-		debug_text_event(adapter->erp_dbf, 3, "a_mod_as_s");
 	} else {
 		changed = atomic_test_and_clear_mask(mask, &adapter->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&adapter->erp_counter, 0);
-		debug_text_event(adapter->erp_dbf, 3, "a_mod_as_c");
 	}
 	if (changed)
 		zfcp_rec_dbf_event_adapter(id, ref, adapter);
-	debug_event(adapter->erp_dbf, 3, &mask, sizeof (u32));
 
 	/* Deal with all underlying devices, only pass common_mask */
 	if (common_mask)
@@ -1818,17 +1690,13 @@ void zfcp_erp_modify_port_status(struct 
 
 	if (set_or_clear == ZFCP_SET) {
 		changed = atomic_test_and_set_mask(mask, &port->status);
-		debug_text_event(port->adapter->erp_dbf, 3, "p_mod_ps_s");
 	} else {
 		changed = atomic_test_and_clear_mask(mask, &port->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&port->erp_counter, 0);
-		debug_text_event(port->adapter->erp_dbf, 3, "p_mod_ps_c");
 	}
 	if (changed)
 		zfcp_rec_dbf_event_port(id, ref, port);
-	debug_event(port->adapter->erp_dbf, 3, &port->wwpn, sizeof (wwn_t));
-	debug_event(port->adapter->erp_dbf, 3, &mask, sizeof (u32));
 
 	/* Modify status of all underlying devices, only pass common mask */
 	if (common_mask)
@@ -1850,19 +1718,14 @@ void zfcp_erp_modify_unit_status(struct 
 
 	if (set_or_clear == ZFCP_SET) {
 		changed = atomic_test_and_set_mask(mask, &unit->status);
-		debug_text_event(unit->port->adapter->erp_dbf, 3, "u_mod_us_s");
 	} else {
 		changed = atomic_test_and_clear_mask(mask, &unit->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
 			atomic_set(&unit->erp_counter, 0);
 		}
-		debug_text_event(unit->port->adapter->erp_dbf, 3, "u_mod_us_c");
 	}
 	if (changed)
 		zfcp_rec_dbf_event_unit(id, ref, unit);
-	debug_event(unit->port->adapter->erp_dbf, 3, &unit->fcp_lun,
-		    sizeof (fcp_lun_t));
-	debug_event(unit->port->adapter->erp_dbf, 3, &mask, sizeof (u32));
 }
 
 /*
@@ -1946,10 +1809,6 @@ zfcp_erp_adapter_strategy(struct zfcp_er
 	else
 		retval = zfcp_erp_adapter_strategy_open(erp_action);
 
-	debug_text_event(adapter->erp_dbf, 3, "a_ast/ret");
-	debug_event(adapter->erp_dbf, 3, &erp_action->action, sizeof (int));
-	debug_event(adapter->erp_dbf, 3, &retval, sizeof (int));
-
 	if (retval == ZFCP_ERP_FAILED) {
 		ZFCP_LOG_INFO("Waiting to allow the adapter %s "
 			      "to recover itself\n",
@@ -2075,7 +1934,6 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 			      zfcp_get_busid_by_adapter(adapter));
 		goto failed_qdio_establish;
 	}
-	debug_text_event(adapter->erp_dbf, 3, "qdio_est");
 
 	if (qdio_activate(adapter->ccw_device, 0) != 0) {
 		ZFCP_LOG_INFO("error: activation of QDIO queues failed "
@@ -2083,7 +1941,6 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 			      zfcp_get_busid_by_adapter(adapter));
 		goto failed_qdio_activate;
 	}
-	debug_text_event(adapter->erp_dbf, 3, "qdio_act");
 
 	/*
 	 * put buffers into response queue,
@@ -2131,11 +1988,9 @@ zfcp_erp_adapter_strategy_open_qdio(stru
 	/* NOP */
 
  failed_qdio_activate:
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down1a");
 	while (qdio_shutdown(adapter->ccw_device,
 			     QDIO_FLAG_CLEANUP_USING_CLEAR) == -EINPROGRESS)
 		ssleep(1);
-	debug_text_event(adapter->erp_dbf, 3, "qdio_down1b");
 
  failed_qdio_establish:
  failed_sanity:
@@ -2181,14 +2036,12 @@ zfcp_erp_adapter_strategy_open_fsf_xconf
 		write_unlock_irq(&adapter->erp_lock);
 		if (zfcp_fsf_exchange_config_data(erp_action)) {
 			retval = ZFCP_ERP_FAILED;
-			debug_text_event(adapter->erp_dbf, 5, "a_fstx_xf");
 			ZFCP_LOG_INFO("error:  initiation of exchange of "
 				      "configuration data failed for "
 				      "adapter %s\n",
 				      zfcp_get_busid_by_adapter(adapter));
 			break;
 		}
-		debug_text_event(adapter->erp_dbf, 6, "a_fstx_xok");
 		ZFCP_LOG_DEBUG("Xchange underway\n");
 
 		/*
@@ -2254,13 +2107,10 @@ zfcp_erp_adapter_strategy_open_fsf_xport
 
 	ret = zfcp_fsf_exchange_port_data(erp_action);
 	if (ret == -EOPNOTSUPP) {
-		debug_text_event(adapter->erp_dbf, 3, "a_xport_notsupp");
 		return ZFCP_ERP_SUCCEEDED;
 	} else if (ret) {
-		debug_text_event(adapter->erp_dbf, 3, "a_xport_failed");
 		return ZFCP_ERP_FAILED;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "a_xport_ok");
 
 	ret = ZFCP_ERP_SUCCEEDED;
 	zfcp_rec_dbf_event_thread(8, adapter, 1);
@@ -2319,7 +2169,6 @@ zfcp_erp_port_forced_strategy(struct zfc
 {
 	int retval = ZFCP_ERP_FAILED;
 	struct zfcp_port *port = erp_action->port;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	switch (erp_action->step) {
 
@@ -2356,11 +2205,6 @@ zfcp_erp_port_forced_strategy(struct zfc
 		break;
 	}
 
-	debug_text_event(adapter->erp_dbf, 3, "p_pfst/ret");
-	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof (wwn_t));
-	debug_event(adapter->erp_dbf, 3, &erp_action->action, sizeof (int));
-	debug_event(adapter->erp_dbf, 3, &retval, sizeof (int));
-
 	return retval;
 }
 
@@ -2378,7 +2222,6 @@ zfcp_erp_port_strategy(struct zfcp_erp_a
 {
 	int retval = ZFCP_ERP_FAILED;
 	struct zfcp_port *port = erp_action->port;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	switch (erp_action->step) {
 
@@ -2411,11 +2254,6 @@ zfcp_erp_port_strategy(struct zfcp_erp_a
 		retval = zfcp_erp_port_strategy_open(erp_action);
 
  out:
-	debug_text_event(adapter->erp_dbf, 3, "p_pst/ret");
-	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof (wwn_t));
-	debug_event(adapter->erp_dbf, 3, &erp_action->action, sizeof (int));
-	debug_event(adapter->erp_dbf, 3, &retval, sizeof (int));
-
 	return retval;
 }
 
@@ -2607,13 +2445,7 @@ zfcp_erp_port_strategy_open_nameserver_w
 	read_lock_irqsave(&adapter->erp_lock, flags);
 	list_for_each_entry_safe(erp_action, tmp, &adapter->erp_running_head,
 				 list) {
-		debug_text_event(adapter->erp_dbf, 4, "p_pstnsw_n");
-		debug_event(adapter->erp_dbf, 4, &erp_action->port->wwpn,
-			    sizeof (wwn_t));
 		if (erp_action->step == ZFCP_ERP_STEP_NAMESERVER_OPEN) {
-			debug_text_event(adapter->erp_dbf, 3, "p_pstnsw_w");
-			debug_event(adapter->erp_dbf, 3,
-				    &erp_action->port->wwpn, sizeof (wwn_t));
 			if (atomic_test_mask(
 				    ZFCP_STATUS_COMMON_ERP_FAILED,
 				    &adapter->nameserver_port->status))
@@ -2638,26 +2470,18 @@ static int
 zfcp_erp_port_forced_strategy_close(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
 
 	retval = zfcp_fsf_close_physical_port(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "o_pfstc_nomem");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_PHYS_PORT_CLOSING;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "o_pfstc_cpf");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* could not send 'open', fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "o_pfstc_cpok");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	retval = ZFCP_ERP_CONTINUES;
  out:
 	return retval;
@@ -2667,10 +2491,6 @@ static int
 zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
 	int retval = 0;
-	struct zfcp_adapter *adapter = port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 5, "p_pstclst");
-	debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
 			  ZFCP_STATUS_COMMON_CLOSING |
@@ -2694,26 +2514,18 @@ static int
 zfcp_erp_port_strategy_close(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
 
 	retval = zfcp_fsf_close_port(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "p_pstc_nomem");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_PORT_CLOSING;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "p_pstc_cpf");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* could not send 'close', fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "p_pstc_cpok");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	retval = ZFCP_ERP_CONTINUES;
  out:
 	return retval;
@@ -2731,26 +2543,18 @@ static int
 zfcp_erp_port_strategy_open_port(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
 
 	retval = zfcp_fsf_open_port(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "p_psto_nomem");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_PORT_OPENING;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "p_psto_opf");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* could not send 'open', fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "p_psto_opok");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	retval = ZFCP_ERP_CONTINUES;
  out:
 	return retval;
@@ -2768,26 +2572,18 @@ static int
 zfcp_erp_port_strategy_open_common_lookup(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
 
 	retval = zfcp_ns_gid_pn_request(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "p_pstn_nomem");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "p_pstn_ref");
-		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* could not send nameserver request, fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "p_pstn_reok");
-	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
 	retval = ZFCP_ERP_CONTINUES;
  out:
 	return retval;
@@ -2808,7 +2604,6 @@ zfcp_erp_unit_strategy(struct zfcp_erp_a
 {
 	int retval = ZFCP_ERP_FAILED;
 	struct zfcp_unit *unit = erp_action->unit;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 
 	switch (erp_action->step) {
 
@@ -2855,10 +2650,6 @@ zfcp_erp_unit_strategy(struct zfcp_erp_a
 		break;
 	}
 
-	debug_text_event(adapter->erp_dbf, 3, "u_ust/ret");
-	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof (fcp_lun_t));
-	debug_event(adapter->erp_dbf, 3, &erp_action->action, sizeof (int));
-	debug_event(adapter->erp_dbf, 3, &retval, sizeof (int));
 	return retval;
 }
 
@@ -2866,10 +2657,6 @@ static int
 zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
 {
 	int retval = 0;
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 5, "u_ustclst");
-	debug_event(adapter->erp_dbf, 5, &unit->fcp_lun, sizeof (fcp_lun_t));
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
 			  ZFCP_STATUS_COMMON_CLOSING |
@@ -2893,28 +2680,18 @@ static int
 zfcp_erp_unit_strategy_close(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_unit *unit = erp_action->unit;
 
 	retval = zfcp_fsf_close_unit(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "u_ustc_nomem");
-		debug_event(adapter->erp_dbf, 5, &unit->fcp_lun,
-			    sizeof (fcp_lun_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_UNIT_CLOSING;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "u_ustc_cuf");
-		debug_event(adapter->erp_dbf, 5, &unit->fcp_lun,
-			    sizeof (fcp_lun_t));
 		/* could not send 'close', fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "u_ustc_cuok");
-	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
 	retval = ZFCP_ERP_CONTINUES;
 
  out:
@@ -2933,28 +2710,18 @@ static int
 zfcp_erp_unit_strategy_open(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_unit *unit = erp_action->unit;
 
 	retval = zfcp_fsf_open_unit(erp_action);
 	if (retval == -ENOMEM) {
-		debug_text_event(adapter->erp_dbf, 5, "u_usto_nomem");
-		debug_event(adapter->erp_dbf, 5, &unit->fcp_lun,
-			    sizeof (fcp_lun_t));
 		retval = ZFCP_ERP_NOMEM;
 		goto out;
 	}
 	erp_action->step = ZFCP_ERP_STEP_UNIT_OPENING;
 	if (retval != 0) {
-		debug_text_event(adapter->erp_dbf, 5, "u_usto_ouf");
-		debug_event(adapter->erp_dbf, 5, &unit->fcp_lun,
-			    sizeof (fcp_lun_t));
 		/* could not send 'open', fail */
 		retval = ZFCP_ERP_FAILED;
 		goto out;
 	}
-	debug_text_event(adapter->erp_dbf, 6, "u_usto_ouok");
-	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
 	retval = ZFCP_ERP_CONTINUES;
  out:
 	return retval;
@@ -3000,17 +2767,11 @@ static int zfcp_erp_action_enqueue(int w
 			      &adapter->status))
 		return -EIO;
 
-	debug_event(adapter->erp_dbf, 4, &want, sizeof (int));
 	/* check whether we really need this */
 	switch (want) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if (atomic_test_mask
 		    (ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status)) {
-			debug_text_event(adapter->erp_dbf, 4, "u_actenq_drp");
-			debug_event(adapter->erp_dbf, 4, &port->wwpn,
-				    sizeof (wwn_t));
-			debug_event(adapter->erp_dbf, 4, &unit->fcp_lun,
-				    sizeof (fcp_lun_t));
 			goto out;
 		}
 		if (!atomic_test_mask
@@ -3027,9 +2788,6 @@ static int zfcp_erp_action_enqueue(int w
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (atomic_test_mask
 		    (ZFCP_STATUS_COMMON_ERP_INUSE, &port->status)) {
-			debug_text_event(adapter->erp_dbf, 4, "p_actenq_drp");
-			debug_event(adapter->erp_dbf, 4, &port->wwpn,
-				    sizeof (wwn_t));
 			goto out;
 		}
 		/* fall through !!! */
@@ -3043,13 +2801,7 @@ static int zfcp_erp_action_enqueue(int w
 					      "0x%016Lx, action in use: %i)\n",
 					      want, port->wwpn,
 					      port->erp_action.action);
-				debug_text_event(adapter->erp_dbf, 4,
-						 "pf_actenq_drp");
-			} else
-				debug_text_event(adapter->erp_dbf, 4,
-						 "pf_actenq_drpcp");
-			debug_event(adapter->erp_dbf, 4, &port->wwpn,
-				    sizeof (wwn_t));
+			}
 			goto out;
 		}
 		if (!atomic_test_mask
@@ -3066,14 +2818,11 @@ static int zfcp_erp_action_enqueue(int w
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (atomic_test_mask
 		    (ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status)) {
-			debug_text_event(adapter->erp_dbf, 4, "a_actenq_drp");
 			goto out;
 		}
 		break;
 
 	default:
-		debug_text_exception(adapter->erp_dbf, 1, "a_actenq_bug");
-		debug_event(adapter->erp_dbf, 1, &want, sizeof (int));
 		ZFCP_LOG_NORMAL("bug: unknown erp action requested "
 				"on adapter %s (action=%d)\n",
 				zfcp_get_busid_by_adapter(adapter), want);
@@ -3082,9 +2831,6 @@ static int zfcp_erp_action_enqueue(int w
 
 	/* check whether we need something stronger first */
 	if (need) {
-		debug_text_event(adapter->erp_dbf, 4, "a_actenq_str");
-		debug_event(adapter->erp_dbf, 4, &need,
-			    sizeof (int));
 		ZFCP_LOG_DEBUG("stronger erp action %d needed before "
 			       "erp action %d on adapter %s\n",
 			       need, want, zfcp_get_busid_by_adapter(adapter));
@@ -3127,8 +2873,6 @@ static int zfcp_erp_action_enqueue(int w
 		break;
 	}
 
-	debug_text_event(adapter->erp_dbf, 4, "a_actenq");
-
 	memset(erp_action, 0, sizeof (struct zfcp_erp_action));
 	erp_action->adapter = adapter;
 	erp_action->port = port;
@@ -3161,8 +2905,6 @@ zfcp_erp_action_dequeue(struct zfcp_erp_
 		erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
 	}
 
-	debug_text_event(adapter->erp_dbf, 4, "a_actdeq");
-	debug_event(adapter->erp_dbf, 4, &erp_action->action, sizeof (int));
 	list_del(&erp_action->list);
 	zfcp_rec_dbf_event_action(144, erp_action);
 
@@ -3270,7 +3012,6 @@ static void zfcp_erp_action_dismiss_adap
 {
 	struct zfcp_port *port;
 
-	debug_text_event(adapter->erp_dbf, 5, "a_actab");
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status))
 		zfcp_erp_action_dismiss(&adapter->erp_action);
 	else
@@ -3281,10 +3022,7 @@ static void zfcp_erp_action_dismiss_adap
 static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 {
 	struct zfcp_unit *unit;
-	struct zfcp_adapter *adapter = port->adapter;
 
-	debug_text_event(adapter->erp_dbf, 5, "p_actab");
-	debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status))
 		zfcp_erp_action_dismiss(&port->erp_action);
 	else
@@ -3294,41 +3032,26 @@ static void zfcp_erp_action_dismiss_port
 
 static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 5, "u_actab");
-	debug_event(adapter->erp_dbf, 5, &unit->fcp_lun, sizeof (fcp_lun_t));
 	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status))
 		zfcp_erp_action_dismiss(&unit->erp_action);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "a_toru");
-	debug_event(adapter->erp_dbf, 6, &erp_action->action, sizeof (int));
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
 	zfcp_rec_dbf_event_action(145, erp_action);
 }
 
 static void zfcp_erp_action_to_ready(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	debug_text_event(adapter->erp_dbf, 6, "a_tore");
-	debug_event(adapter->erp_dbf, 6, &erp_action->action, sizeof (int));
 	list_move(&erp_action->list, &erp_action->adapter->erp_ready_head);
 	zfcp_rec_dbf_event_action(146, erp_action);
 }
 
 void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, u64 ref)
 {
-	struct zfcp_adapter *adapter = port->adapter;
 	unsigned long flags;
 
-	debug_text_event(adapter->erp_dbf, 3, "p_access_boxed");
-	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
@@ -3338,10 +3061,6 @@ void zfcp_erp_port_boxed(struct zfcp_por
 
 void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, u64 ref)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 3, "u_access_boxed");
-	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
@@ -3349,11 +3068,8 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
 
 void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, u64 ref)
 {
-	struct zfcp_adapter *adapter = port->adapter;
 	unsigned long flags;
 
-	debug_text_event(adapter->erp_dbf, 3, "p_access_denied");
-	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED |
@@ -3363,10 +3079,6 @@ void zfcp_erp_port_access_denied(struct 
 
 void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, u64 ref)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
-
-	debug_text_event(adapter->erp_dbf, 3, "u_access_denied");
-	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED |
 				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
@@ -3381,9 +3093,6 @@ void zfcp_erp_adapter_access_changed(str
 	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
 		return;
 
-	debug_text_event(adapter->erp_dbf, 3, "a_access_recover");
-	debug_event(adapter->erp_dbf, 3, zfcp_get_busid_by_adapter(adapter), 8);
-
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	if (adapter->nameserver_port)
 		zfcp_erp_port_access_changed(adapter->nameserver_port, id, ref);
@@ -3398,9 +3107,6 @@ void zfcp_erp_port_access_changed(struct
 	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_unit *unit;
 
-	debug_text_event(adapter->erp_dbf, 3, "p_access_recover");
-	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
-
 	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
 			      &port->status) &&
 	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
@@ -3424,9 +3130,6 @@ void zfcp_erp_unit_access_changed(struct
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	debug_text_event(adapter->erp_dbf, 3, "u_access_recover");
-	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
-
 	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
 			      &unit->status) &&
 	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 13:48:37.000000000 +0100
@@ -799,19 +799,14 @@ zfcp_fsf_status_read_port_closed(struct 
 	switch (status_buffer->status_subtype) {
 
 	case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
-		debug_text_event(adapter->erp_dbf, 3, "unsol_pc_phys:");
 		zfcp_erp_port_reopen(port, 0, 101, (u64)fsf_req);
 		break;
 
 	case FSF_STATUS_READ_SUB_ERROR_PORT:
-		debug_text_event(adapter->erp_dbf, 1, "unsol_pc_err:");
 		zfcp_erp_port_shutdown(port, 0, 122, (u64)fsf_req);
 		break;
 
 	default:
-		debug_text_event(adapter->erp_dbf, 0, "unsol_unk_sub:");
-		debug_exception(adapter->erp_dbf, 0,
-				&status_buffer->status_subtype, sizeof (u32));
 		ZFCP_LOG_NORMAL("bug: Undefined status subtype received "
 				"for a reopen indication on port with "
 				"d_id 0x%06x on the adapter %s. "
@@ -1002,7 +997,6 @@ zfcp_fsf_status_read_handler(struct zfcp
 		break;
 
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
-		debug_text_event(adapter->erp_dbf, 2, "unsol_features:");
 		ZFCP_LOG_INFO("List of supported features on adapter %s has "
 			      "been changed from 0x%08X to 0x%08X\n",
 			      zfcp_get_busid_by_adapter(adapter),
@@ -1151,8 +1145,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
-					 "fsf_s_phand_nv0");
 			/*
 			 * In this case a command that was sent prior to a port
 			 * reopen was aborted (handles are different). This is
@@ -1171,8 +1163,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 				      fsf_status_qual,
 				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
-					 "fsf_s_phand_nv1");
 			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
 						(u64)new_fsf_req);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1181,8 +1171,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 
 	case FSF_LUN_HANDLE_NOT_VALID:
 		if (fsf_stat_qual->word[0] != fsf_stat_qual->word[1]) {
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
-					 "fsf_s_lhand_nv0");
 			/*
 			 * In this case a command that was sent prior to a unit
 			 * reopen was aborted (handles are different).
@@ -1204,8 +1192,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 				      fsf_status_qual,
 				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
-					 "fsf_s_lhand_nv1");
 			zfcp_erp_port_reopen(unit->port, 0, 105,
 					     (u64)new_fsf_req);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1214,8 +1200,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 
 	case FSF_FCP_COMMAND_DOES_NOT_EXIST:
 		retval = 0;
-		debug_text_event(new_fsf_req->adapter->erp_dbf, 3,
-				 "fsf_s_no_exist");
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
 		break;
 
@@ -1223,8 +1207,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		ZFCP_LOG_INFO("Remote port 0x%016Lx on adapter %s needs to "
 			      "be reopened\n", unit->port->wwpn,
 			      zfcp_get_busid_by_unit(unit));
-		debug_text_event(new_fsf_req->adapter->erp_dbf, 2,
-				 "fsf_s_pboxed");
 		zfcp_erp_port_boxed(unit->port, 47, (u64)new_fsf_req);
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
@@ -1236,7 +1218,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
                         "to be reopened\n",
                         unit->fcp_lun, unit->port->wwpn,
                         zfcp_get_busid_by_unit(unit));
-                debug_text_event(new_fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
 		zfcp_erp_unit_boxed(unit, 48, (u64)new_fsf_req);
                 new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
                         | ZFCP_STATUS_FSFREQ_RETRY;
@@ -1245,26 +1226,17 @@ zfcp_fsf_abort_fcp_command_handler(struc
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (new_fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
 			zfcp_test_link(unit->port);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* SCSI stack will escalate */
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
 			ZFCP_LOG_NORMAL
 			    ("bug: Wrong status qualifier 0x%x arrived.\n",
 			     new_fsf_req->qtcb->header.fsf_status_qual.word[0]);
-			debug_text_event(new_fsf_req->adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(new_fsf_req->adapter->erp_dbf, 0,
-					&new_fsf_req->qtcb->header.
-					fsf_status_qual.word[0], sizeof (u32));
 			break;
 		}
 		break;
@@ -1278,11 +1250,6 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				new_fsf_req->qtcb->header.fsf_status);
-		debug_text_event(new_fsf_req->adapter->erp_dbf, 0,
-				 "fsf_s_inval:");
-		debug_exception(new_fsf_req->adapter->erp_dbf, 0,
-				&new_fsf_req->qtcb->header.fsf_status,
-				sizeof (u32));
 		break;
 	}
  skip_fsfstatus:
@@ -1485,7 +1452,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			      zfcp_get_busid_by_port(port),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(adapter, 0, 123, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1494,13 +1460,11 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
                 switch (header->fsf_status_qual.word[0]){
                 case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			/* reopening link to port */
-			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ltest");
 			zfcp_test_link(port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
                 case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* ERP strategy will escalate */
-			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
                 default:
@@ -1528,7 +1492,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 				break;
 			}
 		}
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
 		zfcp_erp_port_access_denied(port, 55, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1541,7 +1504,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_gcom_rej");
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -1554,7 +1516,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_phandle_nv");
 		zfcp_erp_adapter_reopen(adapter, 0, 106, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1563,7 +1524,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		ZFCP_LOG_INFO("port needs to be reopened "
 			      "(adapter %s, port d_id=0x%06x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
-		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(port, 49, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
@@ -1603,9 +1563,6 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
        default:
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n", header->fsf_status);
-		debug_text_event(adapter->erp_dbf, 0, "fsf_sq_inval:");
-		debug_exception(adapter->erp_dbf, 0,
-				&header->fsf_status_qual.word[0], sizeof (u32));
 		break;
 	}
 
@@ -1789,7 +1746,6 @@ static int zfcp_fsf_send_els_handler(str
 			      zfcp_get_busid_by_adapter(adapter),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(adapter, 0, 124, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1797,13 +1753,11 @@ static int zfcp_fsf_send_els_handler(str
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ltest");
 			if (port && (send_els->ls_code != ZFCP_LS_ADISC))
 				zfcp_test_link(port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
-			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			retval =
 			  zfcp_handle_els_rjt(header->fsf_status_qual.word[1],
@@ -1811,7 +1765,6 @@ static int zfcp_fsf_send_els_handler(str
 					      &header->fsf_status_qual.word[2]);
 			break;
 		case FSF_SQ_RETRY_IF_POSSIBLE:
-			debug_text_event(adapter->erp_dbf, 1, "fsf_sq_retry");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
@@ -1888,7 +1841,6 @@ static int zfcp_fsf_send_els_handler(str
 				break;
 			}
 		}
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
 		if (port != NULL)
 			zfcp_erp_port_access_denied(port, 56, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1900,9 +1852,6 @@ static int zfcp_fsf_send_els_handler(str
 			"(adapter: %s, fsf_status=0x%08x)\n",
 			zfcp_get_busid_by_adapter(adapter),
 			header->fsf_status);
-		debug_text_event(adapter->erp_dbf, 0, "fsf_sq_inval");
-		debug_exception(adapter->erp_dbf, 0,
-			&header->fsf_status_qual.word[0], sizeof(u32));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -2111,7 +2060,6 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"versions in comparison to this device "
 				"driver (try updated device driver)\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf, 0, "low_qtcb_ver");
 		zfcp_erp_adapter_shutdown(adapter, 0, 125, (u64)fsf_req);
 		return -EIO;
 	}
@@ -2121,7 +2069,6 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"versions than this device driver uses"
 				"(consider a microcode upgrade)\n",
 				zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(adapter->erp_dbf, 0, "high_qtcb_ver");
 		zfcp_erp_adapter_shutdown(adapter, 0, 126, (u64)fsf_req);
 		return -EIO;
 	}
@@ -2162,16 +2109,12 @@ zfcp_fsf_exchange_config_data_handler(st
 					adapter->peer_wwnn,
 					adapter->peer_wwpn,
 					adapter->peer_d_id);
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					"top-p-to-p");
 			break;
 		case FC_PORTTYPE_NLPORT:
 			ZFCP_LOG_NORMAL("error: Arbitrated loop fibrechannel "
 					"topology detected at adapter %s "
 					"unsupported, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "top-al");
 			zfcp_erp_adapter_shutdown(adapter, 0, 127, (u64)fsf_req);
 			return -EIO;
 		case FC_PORTTYPE_NPORT:
@@ -2187,8 +2130,6 @@ zfcp_fsf_exchange_config_data_handler(st
 					"of a type known to the zfcp "
 					"driver, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
-			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-					     "unknown-topo");
 			zfcp_erp_adapter_shutdown(adapter, 0, 128, (u64)fsf_req);
 			return -EIO;
 		}
@@ -2201,10 +2142,6 @@ zfcp_fsf_exchange_config_data_handler(st
 					bottom->max_qtcb_size,
 					zfcp_get_busid_by_adapter(adapter),
 					sizeof(struct fsf_qtcb));
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "qtcb-size");
-			debug_event(fsf_req->adapter->erp_dbf, 0,
-				    &bottom->max_qtcb_size, sizeof (u32));
 			zfcp_erp_adapter_shutdown(adapter, 0, 129, (u64)fsf_req);
 			return -EIO;
 		}
@@ -2212,8 +2149,6 @@ zfcp_fsf_exchange_config_data_handler(st
 				&adapter->status);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
-		debug_text_event(adapter->erp_dbf, 0, "xchg-inco");
-
 		if (zfcp_fsf_exchange_config_evaluate(fsf_req, 0))
 			return -EIO;
 
@@ -2224,9 +2159,6 @@ zfcp_fsf_exchange_config_data_handler(st
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf-stat-ng");
-		debug_event(fsf_req->adapter->erp_dbf, 0,
-			    &fsf_req->qtcb->header.fsf_status, sizeof(u32));
 		zfcp_erp_adapter_shutdown(adapter, 0, 130, (u64)fsf_req);
 		return -EIO;
 	}
@@ -2406,10 +2338,6 @@ zfcp_fsf_exchange_port_data_handler(stru
 		zfcp_fsf_link_down_info_eval(fsf_req, 43,
 			&qtcb->header.fsf_status_qual.link_down_info);
                 break;
-        default:
-		debug_text_event(adapter->erp_dbf, 0, "xchg-port-ng");
-		debug_event(adapter->erp_dbf, 0,
-			    &fsf_req->qtcb->header.fsf_status, sizeof(u32));
 	}
 }
 
@@ -2507,8 +2435,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		ZFCP_LOG_NORMAL("bug: remote port 0x%016Lx on adapter %s "
 				"is already open.\n",
 				port->wwpn, zfcp_get_busid_by_port(port));
-		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-				     "fsf_s_popen");
 		/*
 		 * This is a bug, however operation should continue normally
 		 * if it is simply ignored
@@ -2532,7 +2458,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 				break;
 			}
 		}
-		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
 		zfcp_erp_port_access_denied(port, 57, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2542,8 +2467,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			      "The remote port 0x%016Lx on adapter %s "
 			      "could not be opened. Disabling it.\n",
 			      port->wwpn, zfcp_get_busid_by_port(port));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_max_ports");
 		zfcp_erp_port_failed(port, 31, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2551,15 +2474,11 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
 			/* ERP strategy will escalate */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* ERP strategy will escalate */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_NO_RETRY_POSSIBLE:
@@ -2568,8 +2487,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 					"Disabling it.\n",
 					port->wwpn,
 					zfcp_get_busid_by_port(port));
-			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-					     "fsf_sq_no_retry");
 			zfcp_erp_port_failed(port, 32, (u64)fsf_req);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
@@ -2577,12 +2494,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			ZFCP_LOG_NORMAL
 			    ("bug: Wrong status qualifier 0x%x arrived.\n",
 			     header->fsf_status_qual.word[0]);
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(
-				fsf_req->adapter->erp_dbf, 0,
-				&header->fsf_status_qual.word[0],
-				sizeof (u32));
 			break;
 		}
 		break;
@@ -2625,17 +2536,12 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 					"warning: insufficient length of "
 					"PLOGI payload (%i)\n",
 					fsf_req->qtcb->bottom.support.els1_length);
-				debug_text_event(fsf_req->adapter->erp_dbf, 0,
-						 "fsf_s_short_plogi:");
 				/* skip sanity check and assume wwpn is ok */
 			} else {
 				if (plogi->serv_param.wwpn != port->wwpn) {
 					ZFCP_LOG_INFO("warning: d_id of port "
 						      "0x%016Lx changed during "
 						      "open\n", port->wwpn);
-					debug_text_event(
-						fsf_req->adapter->erp_dbf, 0,
-						"fsf_s_did_change:");
 					atomic_clear_mask(
 						ZFCP_STATUS_PORT_DID_DID,
 						&port->status);
@@ -2660,9 +2566,6 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				header->fsf_status);
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&header->fsf_status, sizeof (u32));
 		break;
 	}
 
@@ -2766,8 +2669,6 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_phand_nv");
 		zfcp_erp_adapter_reopen(port->adapter, 0, 107, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2793,10 +2694,6 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				fsf_req->qtcb->header.fsf_status);
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&fsf_req->qtcb->header.fsf_status,
-				sizeof (u32));
 		break;
 	}
 
@@ -2909,8 +2806,6 @@ zfcp_fsf_close_physical_port_handler(str
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_phand_nv");
 		zfcp_erp_adapter_reopen(port->adapter, 0, 108, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2932,7 +2827,6 @@ zfcp_fsf_close_physical_port_handler(str
 				break;
 			}
 		}
-		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
 		zfcp_erp_port_access_denied(port, 58, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -2943,7 +2837,6 @@ zfcp_fsf_close_physical_port_handler(str
 			       "to close it physically.\n",
 			       port->wwpn,
 			       zfcp_get_busid_by_port(port));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(port, 50, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -2959,26 +2852,17 @@ zfcp_fsf_close_physical_port_handler(str
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
 			/* This will now be escalated by ERP */
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* ERP strategy will escalate */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
 			ZFCP_LOG_NORMAL
 			    ("bug: Wrong status qualifier 0x%x arrived.\n",
 			     header->fsf_status_qual.word[0]);
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(
-				fsf_req->adapter->erp_dbf, 0,
-				&header->fsf_status_qual.word[0], sizeof (u32));
 			break;
 		}
 		break;
@@ -3001,9 +2885,6 @@ zfcp_fsf_close_physical_port_handler(str
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				header->fsf_status);
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&header->fsf_status, sizeof (u32));
 		break;
 	}
 
@@ -3135,7 +3016,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_ph_nv");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109,
 					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3146,8 +3026,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 				"remote port 0x%016Lx on adapter %s twice.\n",
 				unit->fcp_lun,
 				unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		debug_text_exception(adapter->erp_dbf, 0,
-				     "fsf_s_uopen");
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3169,7 +3047,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 				break;
 			}
 		}
-		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
 		zfcp_erp_unit_access_denied(unit, 59, (u64)fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
                 atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
@@ -3180,7 +3057,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(unit->port, 51, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -3221,8 +3097,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(adapter->erp_dbf, 2,
-				 "fsf_s_l_sh_vio");
 		zfcp_erp_unit_access_denied(unit, 60, (u64)fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
@@ -3237,8 +3111,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			      unit->fcp_lun,
 			      unit->port->wwpn,
 			      zfcp_get_busid_by_unit(unit));
-		debug_text_event(adapter->erp_dbf, 1,
-				 "fsf_s_max_units");
 		zfcp_erp_unit_failed(unit, 34, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3247,26 +3119,17 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			/* Re-establish link to port */
-			debug_text_event(adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
 			zfcp_test_link(unit->port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* ERP strategy will escalate */
-			debug_text_event(adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
 			ZFCP_LOG_NORMAL
 			    ("bug: Wrong status qualifier 0x%x arrived.\n",
 			     header->fsf_status_qual.word[0]);
-			debug_text_event(adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(adapter->erp_dbf, 0,
-					&header->fsf_status_qual.word[0],
-				sizeof (u32));
 		}
 		break;
 
@@ -3339,9 +3202,6 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				header->fsf_status);
-		debug_text_event(adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(adapter->erp_dbf, 0,
-				&header->fsf_status, sizeof (u32));
 		break;
 	}
 
@@ -3454,8 +3314,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_phand_nv");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110,
 					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3473,8 +3331,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_lhand_nv");
 		zfcp_erp_port_reopen(unit->port, 0, 111, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3484,7 +3340,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			       "needs to be reopened\n",
 			       unit->port->wwpn,
 			       zfcp_get_busid_by_unit(unit));
-		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(unit->port, 52, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -3494,27 +3349,17 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		switch (fsf_req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			/* re-establish link to port */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
 			zfcp_test_link(unit->port);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* ERP strategy will escalate */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
 			ZFCP_LOG_NORMAL
 			    ("bug: Wrong status qualifier 0x%x arrived.\n",
 			     fsf_req->qtcb->header.fsf_status_qual.word[0]);
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(
-				fsf_req->adapter->erp_dbf, 0,
-				&fsf_req->qtcb->header.fsf_status_qual.word[0],
-				sizeof (u32));
 			break;
 		}
 		break;
@@ -3535,10 +3380,6 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		ZFCP_LOG_NORMAL("bug: An unknown FSF Status was presented "
 				"(debug info 0x%x)\n",
 				fsf_req->qtcb->header.fsf_status);
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&fsf_req->qtcb->header.fsf_status,
-				sizeof (u32));
 		break;
 	}
 
@@ -3851,8 +3692,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_phand_nv");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112,
 					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3870,8 +3709,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_uhand_nv");
 		zfcp_erp_port_reopen(unit->port, 0, 113, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3888,8 +3725,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_hand_mis");
 		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114,
 					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3901,8 +3736,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      zfcp_get_busid_by_unit(unit),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
-				     "fsf_s_class_nsup");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 132,
 					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3920,8 +3753,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		debug_text_event(fsf_req->adapter->erp_dbf, 1,
-				 "fsf_s_fcp_lun_nv");
 		zfcp_erp_port_reopen(unit->port, 0, 115, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3944,7 +3775,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 				break;
 			}
 		}
-		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
 		zfcp_erp_unit_access_denied(unit, 61, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -3958,8 +3788,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      zfcp_get_busid_by_unit(unit),
 			      fsf_req->qtcb->bottom.io.data_direction);
 		/* stop operation for this adapter */
-		debug_text_event(fsf_req->adapter->erp_dbf, 0,
-				 "fsf_s_dir_ind_nv");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133,
 					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3974,8 +3802,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		     zfcp_get_busid_by_unit(unit),
 		     fsf_req->qtcb->bottom.io.fcp_cmnd_length);
 		/* stop operation for this adapter */
-		debug_text_event(fsf_req->adapter->erp_dbf, 0,
-				 "fsf_s_cmd_len_nv");
 		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134,
 					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3985,7 +3811,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
 		zfcp_erp_port_boxed(unit->port, 53, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
@@ -3996,7 +3821,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 				"wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
 				zfcp_get_busid_by_unit(unit),
 				unit->port->wwpn, unit->fcp_lun);
-		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
 		zfcp_erp_unit_boxed(unit, 54, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 			| ZFCP_STATUS_FSFREQ_RETRY;
@@ -4006,25 +3830,16 @@ zfcp_fsf_send_fcp_command_handler(struct
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
 			/* re-establish link to port */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ltest");
  			zfcp_test_link(unit->port);
 			break;
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			/* FIXME(hw) need proper specs for proper action */
 			/* let scsi stack deal with retries and escalation */
-			debug_text_event(fsf_req->adapter->erp_dbf, 1,
-					 "fsf_sq_ulp");
 			break;
 		default:
 			ZFCP_LOG_NORMAL
  			    ("Unknown status qualifier 0x%x arrived.\n",
 			     header->fsf_status_qual.word[0]);
-			debug_text_event(fsf_req->adapter->erp_dbf, 0,
-					 "fsf_sq_inval:");
-			debug_exception(fsf_req->adapter->erp_dbf, 0,
-					&header->fsf_status_qual.word[0],
-					sizeof(u32));
 			break;
 		}
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -4035,12 +3850,6 @@ zfcp_fsf_send_fcp_command_handler(struct
 
 	case FSF_FCP_RSP_AVAILABLE:
 		break;
-
-	default:
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_s_inval:");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-				&header->fsf_status, sizeof(u32));
-		break;
 	}
 
  skip_fsfstatus:
@@ -4620,9 +4429,6 @@ zfcp_fsf_control_file_handler(struct zfc
 			"was presented on the adapter %s\n",
 			header->fsf_status,
 			zfcp_get_busid_by_adapter(adapter));
-		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf_sq_inval");
-		debug_exception(fsf_req->adapter->erp_dbf, 0,
-			&header->fsf_status_qual.word[0], sizeof(u32));
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		retval = -EINVAL;
 		break;
@@ -4812,7 +4618,6 @@ static int zfcp_fsf_req_send(struct zfcp
 	volatile struct qdio_buffer_element *sbale;
 	int inc_seq_no;
 	int new_distance_from_int;
-	u64 dbg_tmp[2];
 	int retval = 0;
 
 	adapter = fsf_req->adapter;
@@ -4862,10 +4667,6 @@ static int zfcp_fsf_req_send(struct zfcp
 			 QDIO_FLAG_SYNC_OUTPUT,
 			 0, fsf_req->sbal_first, fsf_req->sbal_number, NULL);
 
-	dbg_tmp[0] = (unsigned long) sbale[0].addr;
-	dbg_tmp[1] = (u64) retval;
-	debug_event(adapter->erp_dbf, 4, (void *) dbg_tmp, 16);
-
 	if (unlikely(retval)) {
 		/* Queues are down..... */
 		retval = -EIO;
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-03-27 13:47:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-03-27 13:48:37.000000000 +0100
@@ -239,8 +239,6 @@ static void zfcp_qdio_reqid_check(struct
 	struct zfcp_fsf_req *fsf_req;
 	unsigned long flags;
 
-	debug_long_event(adapter->erp_dbf, 4, req_id);
-
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	fsf_req = zfcp_reqlist_find(adapter, req_id);
 

-- 
