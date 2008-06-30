From: christof.schmitt@de.ibm.com
Subject: [patch 10/11] zfcp: Cleanup code in zfcp_erp.c
Date: Mon, 30 Jun 2008 12:52:46 +0200
Message-ID: <20080630110101.633684000@de.ibm.com>
References: <20080630105236.960064000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:20774 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbYF3LBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 07:01:17 -0400
Content-Disposition: inline; filename=erp-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Cleanup the code in zfcp_erp.c, move erp internal definititions to
this file and move FSF timeout handling to the FSF layer.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h |   45 
 drivers/s390/scsi/zfcp_erp.c | 3528 ++++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_ext.h |   25 
 drivers/s390/scsi/zfcp_fsf.c |   43 
 4 files changed, 1359 insertions(+), 2282 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-06-30 11:27:42.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-06-30 11:28:44.000000000 +0200
@@ -8,373 +8,399 @@
 
 #include "zfcp_ext.h"
 
-static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int, u8,
-					    void *);
-static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *, int, u8,
-						void *);
-static int zfcp_erp_port_reopen_internal(struct zfcp_port *, int, u8, void *);
-static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *, int, u8, void *);
-
-static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *, int, u8,
-					     void *);
-static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *, int, u8,
-					     void *);
-
-static void zfcp_erp_adapter_block(struct zfcp_adapter *, int);
-static void zfcp_erp_adapter_unblock(struct zfcp_adapter *);
-static void zfcp_erp_port_block(struct zfcp_port *, int);
-static void zfcp_erp_port_unblock(struct zfcp_port *);
-static void zfcp_erp_unit_block(struct zfcp_unit *, int);
-static void zfcp_erp_unit_unblock(struct zfcp_unit *);
-
-static int zfcp_erp_thread(void *);
-
-static int zfcp_erp_strategy(struct zfcp_erp_action *);
-
-static int zfcp_erp_strategy_do_action(struct zfcp_erp_action *);
-static int zfcp_erp_strategy_memwait(struct zfcp_erp_action *);
-static int zfcp_erp_strategy_check_target(struct zfcp_erp_action *, int);
-static int zfcp_erp_strategy_check_unit(struct zfcp_unit *, int);
-static int zfcp_erp_strategy_check_port(struct zfcp_port *, int);
-static int zfcp_erp_strategy_check_adapter(struct zfcp_adapter *, int);
-static int zfcp_erp_strategy_statechange(int, u32, struct zfcp_adapter *,
-					 struct zfcp_port *,
-					 struct zfcp_unit *, int);
-static int zfcp_erp_strategy_statechange_detected(atomic_t *, u32);
-static int zfcp_erp_strategy_followup_actions(int, struct zfcp_adapter *,
-					      struct zfcp_port *,
-					      struct zfcp_unit *, int);
-static int zfcp_erp_strategy_check_queues(struct zfcp_adapter *);
-static int zfcp_erp_strategy_check_action(struct zfcp_erp_action *, int);
-
-static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *, int);
-static int zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open_fsf_xconfig(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *);
-static int zfcp_erp_adapter_strategy_open_fsf_statusread(
-	struct zfcp_erp_action *);
-
-static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *);
-static int zfcp_erp_port_forced_strategy_close(struct zfcp_erp_action *);
-
-static int zfcp_erp_port_strategy(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_clearstati(struct zfcp_port *);
-static int zfcp_erp_port_strategy_close(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open_nameserver(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open_nameserver_wakeup(
-	struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open_common_lookup(struct zfcp_erp_action *);
-static int zfcp_erp_port_strategy_open_port(struct zfcp_erp_action *);
-
-static int zfcp_erp_unit_strategy(struct zfcp_erp_action *);
-static int zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *);
-static int zfcp_erp_unit_strategy_close(struct zfcp_erp_action *);
-static int zfcp_erp_unit_strategy_open(struct zfcp_erp_action *);
-
-static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *);
-static void zfcp_erp_action_dismiss_port(struct zfcp_port *);
-static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *);
-static void zfcp_erp_action_dismiss(struct zfcp_erp_action *);
-
-static int zfcp_erp_action_enqueue(int, struct zfcp_adapter *,
-				   struct zfcp_port *, struct zfcp_unit *,
-				   u8 id, void *ref);
-static int zfcp_erp_action_dequeue(struct zfcp_erp_action *);
-static void zfcp_erp_action_cleanup(int, struct zfcp_adapter *,
-				    struct zfcp_port *, struct zfcp_unit *,
-				    int);
-
-static void zfcp_erp_action_ready(struct zfcp_erp_action *);
-static int  zfcp_erp_action_exists(struct zfcp_erp_action *);
+#define ZFCP_MAX_ERPS                   3
 
-static void zfcp_erp_action_to_ready(struct zfcp_erp_action *);
-static void zfcp_erp_action_to_running(struct zfcp_erp_action *);
+enum zfcp_erp_act_flags {
+	ZFCP_STATUS_ERP_TIMEDOUT	= 0x10000000,
+	ZFCP_STATUS_ERP_CLOSE_ONLY	= 0x01000000,
+	ZFCP_STATUS_ERP_DISMISSING	= 0x00100000,
+	ZFCP_STATUS_ERP_DISMISSED	= 0x00200000,
+	ZFCP_STATUS_ERP_LOWMEM		= 0x00400000,
+};
 
-static void zfcp_erp_memwait_handler(unsigned long);
+enum zfcp_erp_steps {
+	ZFCP_ERP_STEP_UNINITIALIZED	= 0x0000,
+	ZFCP_ERP_STEP_FSF_XCONFIG	= 0x0001,
+	ZFCP_ERP_STEP_PHYS_PORT_CLOSING	= 0x0010,
+	ZFCP_ERP_STEP_PORT_CLOSING	= 0x0100,
+	ZFCP_ERP_STEP_NAMESERVER_OPEN	= 0x0200,
+	ZFCP_ERP_STEP_NAMESERVER_LOOKUP	= 0x0400,
+	ZFCP_ERP_STEP_PORT_OPENING	= 0x0800,
+	ZFCP_ERP_STEP_UNIT_CLOSING	= 0x1000,
+	ZFCP_ERP_STEP_UNIT_OPENING	= 0x2000,
+};
 
-/**
- * zfcp_close_fsf - stop FSF operations for an adapter
- *
- * Dismiss and cleanup all pending fsf_reqs (this wakes up all initiators of
- * requests waiting for completion; especially this returns SCSI commands
- * with error state).
- */
-static void zfcp_close_fsf(struct zfcp_adapter *adapter)
+enum zfcp_erp_act_type {
+	ZFCP_ERP_ACTION_REOPEN_UNIT        = 1,
+	ZFCP_ERP_ACTION_REOPEN_PORT	   = 2,
+	ZFCP_ERP_ACTION_REOPEN_PORT_FORCED = 3,
+	ZFCP_ERP_ACTION_REOPEN_ADAPTER     = 4,
+};
+
+enum zfcp_erp_act_state {
+	ZFCP_ERP_ACTION_RUNNING = 1,
+	ZFCP_ERP_ACTION_READY   = 2,
+};
+
+enum zfcp_erp_act_result {
+	ZFCP_ERP_SUCCEEDED = 0,
+	ZFCP_ERP_FAILED    = 1,
+	ZFCP_ERP_CONTINUES = 2,
+	ZFCP_ERP_EXIT      = 3,
+	ZFCP_ERP_DISMISSED = 4,
+	ZFCP_ERP_NOMEM     = 5,
+};
+
+static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int mask)
 {
-	/* close queues to ensure that buffers are not accessed by adapter */
-	zfcp_qdio_close(adapter);
-	zfcp_fsf_req_dismiss_all(adapter);
-	/* reset FSF request sequence number */
-	adapter->fsf_req_seq_no = 0;
-	/* all ports and units are closed */
-	zfcp_erp_modify_adapter_status(adapter, 24, NULL,
-				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
+	zfcp_erp_modify_adapter_status(adapter, 15, NULL,
+				       ZFCP_STATUS_COMMON_UNBLOCKED | mask,
+				       ZFCP_CLEAR);
 }
 
-/**
- * zfcp_fsf_request_timeout_handler - called if a request timed out
- * @data: pointer to adapter for handler function
- *
- * This function needs to be called if requests (ELS, Generic Service,
- * or SCSI commands) exceed a certain time limit. The assumption is
- * that after the time limit the adapter get stuck. So we trigger a reopen of
- * the adapter.
- */
-static void zfcp_fsf_request_timeout_handler(unsigned long data)
+static int zfcp_erp_action_exists(struct zfcp_erp_action *act)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62,
-				NULL);
+	struct zfcp_erp_action *curr_act;
+
+	list_for_each_entry(curr_act, &act->adapter->erp_running_head, list)
+		if (act == curr_act)
+			return ZFCP_ERP_ACTION_RUNNING;
+	return 0;
 }
 
-void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req, unsigned long timeout)
+static void zfcp_erp_action_ready(struct zfcp_erp_action *act)
 {
-	fsf_req->timer.function = zfcp_fsf_request_timeout_handler;
-	fsf_req->timer.data = (unsigned long) fsf_req->adapter;
-	fsf_req->timer.expires = jiffies + timeout;
-	add_timer(&fsf_req->timer);
+	struct zfcp_adapter *adapter = act->adapter;
+
+	list_move(&act->list, &act->adapter->erp_ready_head);
+	zfcp_rec_dbf_event_action(146, act);
+	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(2, adapter);
 }
 
-/*
- * function:
- *
- * purpose:	called if an adapter failed,
- *		initiates adapter recovery which is done
- *		asynchronously
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
- */
-static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *adapter,
-					    int clear_mask, u8 id, void *ref)
+static void zfcp_erp_action_dismiss(struct zfcp_erp_action *act)
 {
-	int retval;
+	act->status |= ZFCP_STATUS_ERP_DISMISSED;
+	if (zfcp_erp_action_exists(act) == ZFCP_ERP_ACTION_RUNNING)
+		zfcp_erp_action_ready(act);
+}
 
-	zfcp_erp_adapter_block(adapter, clear_mask);
+static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
+{
+	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
+		zfcp_erp_action_dismiss(&unit->erp_action);
+}
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status)) {
-		/* ensure propagation of failed status to new devices */
-		zfcp_erp_adapter_failed(adapter, 13, NULL);
-		retval = -EIO;
-		goto out;
-	}
-	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
-					 adapter, NULL, NULL, id, ref);
+static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
+{
+	struct zfcp_unit *unit;
 
- out:
-	return retval;
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
+		zfcp_erp_action_dismiss(&port->erp_action);
+	else
+		list_for_each_entry(unit, &port->unit_list_head, list)
+		    zfcp_erp_action_dismiss_unit(unit);
 }
 
-/*
- * function:
- *
- * purpose:	Wrappper for zfcp_erp_adapter_reopen_internal
- *              used to ensure the correct locking
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
- */
-int zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear_mask,
-			    u8 id, void *ref)
+static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
 {
-	int retval;
-	unsigned long flags;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_adapter_reopen_internal(adapter, clear_mask, id, ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	struct zfcp_port *port;
 
-	return retval;
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
+		zfcp_erp_action_dismiss(&adapter->erp_action);
+	else
+		list_for_each_entry(port, &adapter->port_list_head, list)
+		    zfcp_erp_action_dismiss_port(port);
 }
 
-int zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear_mask,
-			      u8 id, void *ref)
+static int zfcp_erp_required_act(int want, struct zfcp_adapter *adapter,
+				 struct zfcp_port *port,
+				 struct zfcp_unit *unit)
 {
-	int retval;
+	int need = want;
+	int u_status, p_status, a_status;
 
-	retval = zfcp_erp_adapter_reopen(adapter,
-					 ZFCP_STATUS_COMMON_RUNNING |
-					 ZFCP_STATUS_COMMON_ERP_FAILED |
-					 clear_mask, id, ref);
+	switch (want) {
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		u_status = atomic_read(&unit->status);
+		if (u_status & ZFCP_STATUS_COMMON_ERP_INUSE)
+			return 0;
+		p_status = atomic_read(&port->status);
+		if (!(p_status & ZFCP_STATUS_COMMON_RUNNING) ||
+		      p_status & ZFCP_STATUS_COMMON_ERP_FAILED)
+			return 0;
+		if (!(p_status & ZFCP_STATUS_COMMON_UNBLOCKED))
+			need = ZFCP_ERP_ACTION_REOPEN_PORT;
+		/* fall through */
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		p_status = atomic_read(&port->status);
+		if (p_status & ZFCP_STATUS_COMMON_ERP_INUSE)
+			return 0;
+		a_status = atomic_read(&adapter->status);
+		if (!(a_status & ZFCP_STATUS_COMMON_RUNNING) ||
+		      a_status & ZFCP_STATUS_COMMON_ERP_FAILED)
+			return 0;
+		if (!(a_status & ZFCP_STATUS_COMMON_UNBLOCKED))
+			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
+		/* fall through */
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		a_status = atomic_read(&adapter->status);
+		if (a_status & ZFCP_STATUS_COMMON_ERP_INUSE)
+			return 0;
+	}
 
-	return retval;
+	return need;
 }
 
-int zfcp_erp_port_shutdown(struct zfcp_port *port, int clear_mask, u8 id,
-			   void *ref)
+static struct zfcp_erp_action *zfcp_erp_setup_act(int need,
+						  struct zfcp_adapter *adapter,
+						  struct zfcp_port *port,
+						  struct zfcp_unit *unit)
 {
-	int retval;
+	struct zfcp_erp_action *erp_action;
+	u32 status = 0;
 
-	retval = zfcp_erp_port_reopen(port,
-				      ZFCP_STATUS_COMMON_RUNNING |
-				      ZFCP_STATUS_COMMON_ERP_FAILED |
-				      clear_mask, id, ref);
+	switch (need) {
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		zfcp_unit_get(unit);
+		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
+		erp_action = &unit->erp_action;
+		if (!(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_RUNNING))
+			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+		break;
 
-	return retval;
-}
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		zfcp_port_get(port);
+		zfcp_erp_action_dismiss_port(port);
+		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
+		erp_action = &port->erp_action;
+		if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_RUNNING))
+			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+		break;
 
-int zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear_mask, u8 id,
-			   void *ref)
-{
-	int retval;
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		zfcp_adapter_get(adapter);
+		zfcp_erp_action_dismiss_adapter(adapter);
+		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
+		erp_action = &adapter->erp_action;
+		if (!(atomic_read(&adapter->status) &
+		      ZFCP_STATUS_COMMON_RUNNING))
+			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+		break;
 
-	retval = zfcp_erp_unit_reopen(unit,
-				      ZFCP_STATUS_COMMON_RUNNING |
-				      ZFCP_STATUS_COMMON_ERP_FAILED |
-				      clear_mask, id, ref);
+	default:
+		return NULL;
+	}
 
-	return retval;
+	memset(erp_action, 0, sizeof(struct zfcp_erp_action));
+	erp_action->adapter = adapter;
+	erp_action->port = port;
+	erp_action->unit = unit;
+	erp_action->action = need;
+	erp_action->status = status;
+
+	return erp_action;
 }
 
-/*
- * function:
- *
- * purpose:	called if a port failed to be opened normally
- *		initiates Forced Reopen recovery which is done
- *		asynchronously
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
- */
-static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *port,
-						int clear_mask, u8 id,
-						void *ref)
+static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
+				   struct zfcp_port *port,
+				   struct zfcp_unit *unit, u8 id, void *ref)
 {
-	int retval;
+	int retval = 1, need;
+	struct zfcp_erp_action *act = NULL;
 
-	zfcp_erp_port_block(port, clear_mask);
+	if (!(atomic_read(&adapter->status) &
+	      ZFCP_STATUS_ADAPTER_ERP_THREAD_UP))
+		return -EIO;
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
-		retval = -EIO;
+	need = zfcp_erp_required_act(want, adapter, port, unit);
+	if (!need)
 		goto out;
-	}
-
-	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT_FORCED,
-					 port->adapter, port, NULL, id, ref);
 
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
+	act = zfcp_erp_setup_act(need, adapter, port, unit);
+	if (!act)
+		goto out;
+	++adapter->erp_total_count;
+	list_add_tail(&act->list, &adapter->erp_ready_head);
+	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread(1, adapter);
+	retval = 0;
  out:
+	zfcp_rec_dbf_event_trigger(id, ref, want, need, act,
+				   adapter, port, unit);
 	return retval;
 }
 
-/*
- * function:
- *
- * purpose:	Wrappper for zfcp_erp_port_forced_reopen_internal
- *              used to ensure the correct locking
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
+static int _zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter,
+				    int clear_mask, u8 id, void *ref)
+{
+	zfcp_erp_adapter_block(adapter, clear_mask);
+
+	/* ensure propagation of failed status to new devices */
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
+		zfcp_erp_adapter_failed(adapter, 13, NULL);
+		return -EIO;
+	}
+	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
+				       adapter, NULL, NULL, id, ref);
+}
+
+/**
+ * zfcp_erp_adapter_reopen - Reopen adapter.
+ * @adapter: Adapter to reopen.
+ * @clear: Status flags to clear.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
  */
-int zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear_mask, u8 id,
-				void *ref)
+void zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear,
+			     u8 id, void *ref)
 {
-	int retval;
 	unsigned long flags;
-	struct zfcp_adapter *adapter;
 
-	adapter = port->adapter;
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_forced_reopen_internal(port, clear_mask, id,
-						      ref);
+	_zfcp_erp_adapter_reopen(adapter, clear, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+}
 
-	return retval;
+/**
+ * zfcp_erp_adapter_shutdown - Shutdown adapter.
+ * @adapter: Adapter to shut down.
+ * @clear: Status flags to clear.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
+ */
+void zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear,
+			       u8 id, void *ref)
+{
+	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
+	zfcp_erp_adapter_reopen(adapter, clear | flags, id, ref);
 }
 
-/*
- * function:
- *
- * purpose:	called if a port is to be opened
- *		initiates Reopen recovery which is done
- *		asynchronously
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
+/**
+ * zfcp_erp_port_shutdown - Shutdown port
+ * @port: Port to shut down.
+ * @clear: Status flags to clear.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
  */
-static int zfcp_erp_port_reopen_internal(struct zfcp_port *port, int clear_mask,
-					 u8 id, void *ref)
+void zfcp_erp_port_shutdown(struct zfcp_port *port, int clear, u8 id, void *ref)
 {
-	int retval;
+	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
+	zfcp_erp_port_reopen(port, clear | flags, id, ref);
+}
+
+/**
+ * zfcp_erp_unit_shutdown - Shutdown unit
+ * @unit: Unit to shut down.
+ * @clear: Status flags to clear.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
+ */
+void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, u8 id, void *ref)
+{
+	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
+	zfcp_erp_unit_reopen(unit, clear | flags, id, ref);
+}
+
+static void zfcp_erp_port_block(struct zfcp_port *port, int clear)
+{
+	zfcp_erp_modify_port_status(port, 17, NULL,
+				    ZFCP_STATUS_COMMON_UNBLOCKED | clear,
+				    ZFCP_CLEAR);
+}
+
+static void _zfcp_erp_port_forced_reopen(struct zfcp_port *port,
+					 int clear, u8 id, void *ref)
+{
+	zfcp_erp_port_block(port, clear);
+
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		return;
+
+	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT_FORCED,
+				port->adapter, port, NULL, id, ref);
+}
+
+/**
+ * zfcp_erp_port_forced_reopen - Forced close of port and open again
+ * @port: Port to force close and to reopen.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
+ */
+void zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear, u8 id,
+				 void *ref)
+{
+	unsigned long flags;
+	struct zfcp_adapter *adapter = port->adapter;
+
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	write_lock(&adapter->erp_lock);
+	_zfcp_erp_port_forced_reopen(port, clear, id, ref);
+	write_unlock(&adapter->erp_lock);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+}
 
-	zfcp_erp_port_block(port, clear_mask);
+static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, u8 id,
+				 void *ref)
+{
+	zfcp_erp_port_block(port, clear);
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
 		/* ensure propagation of failed status to new devices */
 		zfcp_erp_port_failed(port, 14, NULL);
-		retval = -EIO;
-		goto out;
+		return -EIO;
 	}
 
-	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT,
-					 port->adapter, port, NULL, id, ref);
-
- out:
-	return retval;
+	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT,
+				       port->adapter, port, NULL, id, ref);
 }
 
 /**
- * zfcp_erp_port_reopen - initiate reopen of a remote port
- * @port: port to be reopened
- * @clear_mask: specifies flags in port status to be cleared
- * Return: 0 on success, < 0 on error
+ * zfcp_erp_port_reopen - trigger remote port recovery
+ * @port: port to recover
+ * @clear_mask: flags in port status to be cleared
  *
- * This is a wrappper function for zfcp_erp_port_reopen_internal. It ensures
- * correct locking. An error recovery task is initiated to do the reopen.
- * To wait for the completion of the reopen zfcp_erp_wait should be used.
+ * Returns 0 if recovery has been triggered, < 0 if not.
  */
-int zfcp_erp_port_reopen(struct zfcp_port *port, int clear_mask, u8 id,
-			 void *ref)
+int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, u8 id, void *ref)
 {
-	int retval;
 	unsigned long flags;
+	int retval;
 	struct zfcp_adapter *adapter = port->adapter;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_reopen_internal(port, clear_mask, id, ref);
+	retval = _zfcp_erp_port_reopen(port, clear, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	return retval;
 }
 
-/*
- * function:
- *
- * purpose:	called if a unit is to be opened
- *		initiates Reopen recovery which is done
- *		asynchronously
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
- */
-static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *unit, int clear_mask,
-					 u8 id, void *ref)
+static void zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
+{
+	zfcp_erp_modify_unit_status(unit, 19, NULL,
+				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
+				    ZFCP_CLEAR);
+}
+
+static void _zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, u8 id,
+				  void *ref)
 {
-	int retval;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	zfcp_erp_unit_block(unit, clear_mask);
+	zfcp_erp_unit_block(unit, clear);
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status)) {
-		retval = -EIO;
-		goto out;
-	}
+	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		return;
 
-	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_UNIT,
-					 adapter, unit->port, unit, id, ref);
- out:
-	return retval;
+	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_UNIT,
+				adapter, unit->port, unit, id, ref);
 }
 
 /**
@@ -382,790 +408,655 @@ static int zfcp_erp_unit_reopen_internal
  * @unit: unit to be reopened
  * @clear_mask: specifies flags in unit status to be cleared
  * Return: 0 on success, < 0 on error
- *
- * This is a wrappper for zfcp_erp_unit_reopen_internal. It ensures correct
- * locking. An error recovery task is initiated to do the reopen.
- * To wait for the completion of the reopen zfcp_erp_wait should be used.
  */
-int zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear_mask, u8 id,
-			 void *ref)
+void zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, u8 id, void *ref)
 {
-	int retval;
 	unsigned long flags;
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-
-	port = unit->port;
-	adapter = port->adapter;
+	struct zfcp_port *port = unit->port;
+	struct zfcp_adapter *adapter = port->adapter;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_unit_reopen_internal(unit, clear_mask, id, ref);
+	_zfcp_erp_unit_reopen(unit, clear, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-
-	return retval;
-}
-
-/**
- * zfcp_erp_adapter_block - mark adapter as blocked, block scsi requests
- */
-static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int clear_mask)
-{
-	zfcp_erp_modify_adapter_status(adapter, 15, NULL,
-				       ZFCP_STATUS_COMMON_UNBLOCKED |
-				       clear_mask, ZFCP_CLEAR);
 }
 
-/* FIXME: isn't really atomic */
-/*
- * returns the mask which has not been set so far, i.e.
- * 0 if no bit has been changed, !0 if some bit has been changed
- */
-static int atomic_test_and_set_mask(unsigned long mask, atomic_t *v)
+static int status_change_set(unsigned long mask, atomic_t *status)
 {
-	int changed_bits = (atomic_read(v) /*XOR*/^ mask) & mask;
-	atomic_set_mask(mask, v);
-	return changed_bits;
+	return (atomic_read(status) ^ mask) & mask;
 }
 
-/* FIXME: isn't really atomic */
-/*
- * returns the mask which has not been cleared so far, i.e.
- * 0 if no bit has been changed, !0 if some bit has been changed
- */
-static int atomic_test_and_clear_mask(unsigned long mask, atomic_t *v)
+static int status_change_clear(unsigned long mask, atomic_t *status)
 {
-	int changed_bits = atomic_read(v) & mask;
-	atomic_clear_mask(mask, v);
-	return changed_bits;
+	return atomic_read(status) & mask;
 }
 
-/**
- * zfcp_erp_adapter_unblock - mark adapter as unblocked, allow scsi requests
- */
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
-	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-				     &adapter->status))
+	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
 		zfcp_rec_dbf_event_adapter(16, NULL, adapter);
+	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
 }
 
-/*
- * function:
- *
- * purpose:	disable I/O,
- *		return any open requests and clean them up,
- *		aim: no pending and incoming I/O
- *
- * returns:
- */
-static void
-zfcp_erp_port_block(struct zfcp_port *port, int clear_mask)
+static void zfcp_erp_port_unblock(struct zfcp_port *port)
 {
-	zfcp_erp_modify_port_status(port, 17, NULL,
-				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
-				    ZFCP_CLEAR);
+	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
+		zfcp_rec_dbf_event_port(18, NULL, port);
+	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
-/*
- * function:
- *
- * purpose:	enable I/O
- *
- * returns:
- */
-static void
-zfcp_erp_port_unblock(struct zfcp_port *port)
+static void zfcp_erp_unit_unblock(struct zfcp_unit *unit)
 {
-	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-				     &port->status))
-		zfcp_rec_dbf_event_port(18, NULL, port);
+	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status))
+		zfcp_rec_dbf_event_unit(20, NULL, unit);
+	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
 }
 
-/*
- * function:
- *
- * purpose:	disable I/O,
- *		return any open requests and clean them up,
- *		aim: no pending and incoming I/O
- *
- * returns:
- */
-static void
-zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
+static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
-	zfcp_erp_modify_unit_status(unit, 19, NULL,
-				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
-				    ZFCP_CLEAR);
+	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
+	zfcp_rec_dbf_event_action(145, erp_action);
 }
 
-/*
- * function:
- *
- * purpose:	enable I/O
- *
- * returns:
- */
-static void
-zfcp_erp_unit_unblock(struct zfcp_unit *unit)
+static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
 {
-	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-				     &unit->status))
-		zfcp_rec_dbf_event_unit(20, NULL, unit);
+	struct zfcp_adapter *adapter = act->adapter;
+
+	if (!act->fsf_req)
+		return;
+
+	spin_lock(&adapter->req_list_lock);
+	if (zfcp_reqlist_find_safe(adapter, act->fsf_req) &&
+	    act->fsf_req->erp_action == act) {
+		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
+				   ZFCP_STATUS_ERP_TIMEDOUT)) {
+			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
+			zfcp_rec_dbf_event_action(142, act);
+		}
+		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
+			zfcp_rec_dbf_event_action(143, act);
+		if (act->fsf_req->status & (ZFCP_STATUS_FSFREQ_COMPLETED |
+					    ZFCP_STATUS_FSFREQ_DISMISSED))
+			act->fsf_req = NULL;
+	} else
+		act->fsf_req = NULL;
+	spin_unlock(&adapter->req_list_lock);
 }
 
-static void
-zfcp_erp_action_ready(struct zfcp_erp_action *erp_action)
+/**
+ * zfcp_erp_notify - Trigger ERP action.
+ * @erp_action: ERP action to continue.
+ * @set_mask: ERP action status flags to set.
+ */
+void zfcp_erp_notify(struct zfcp_erp_action *erp_action, unsigned long set_mask)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
+	unsigned long flags;
 
-	zfcp_erp_action_to_ready(erp_action);
-	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(2, adapter);
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	<0			erp_action not found in any list
- *		ZFCP_ERP_ACTION_READY	erp_action is in ready list
- *		ZFCP_ERP_ACTION_RUNNING	erp_action is in running list
- *
- * locks:	erp_lock must be held
- */
-static int
-zfcp_erp_action_exists(struct zfcp_erp_action *erp_action)
-{
-	int retval = -EINVAL;
-	struct list_head *entry;
-	struct zfcp_erp_action *entry_erp_action;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	/* search in running list */
-	list_for_each(entry, &adapter->erp_running_head) {
-		entry_erp_action =
-		    list_entry(entry, struct zfcp_erp_action, list);
-		if (entry_erp_action == erp_action) {
-			retval = ZFCP_ERP_ACTION_RUNNING;
-			goto out;
-		}
-	}
-	/* search in ready list */
-	list_for_each(entry, &adapter->erp_ready_head) {
-		entry_erp_action =
-		    list_entry(entry, struct zfcp_erp_action, list);
-		if (entry_erp_action == erp_action) {
-			retval = ZFCP_ERP_ACTION_READY;
-			goto out;
-		}
-	}
-
- out:
-	return retval;
-}
-
-/*
- * purpose:	checks current status of action (timed out, dismissed, ...)
- *		and does appropriate preparations (dismiss fsf request, ...)
- *
- * locks:	called under erp_lock (disabled interrupts)
- */
-static void
-zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *erp_action)
-{
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	if (erp_action->fsf_req) {
-		/* take lock to ensure that request is not deleted meanwhile */
-		spin_lock(&adapter->req_list_lock);
-		if (zfcp_reqlist_find_safe(adapter, erp_action->fsf_req) &&
-		    erp_action->fsf_req->erp_action == erp_action) {
-			/* fsf_req still exists */
-			/* dismiss fsf_req of timed out/dismissed erp_action */
-			if (erp_action->status & (ZFCP_STATUS_ERP_DISMISSED |
-						  ZFCP_STATUS_ERP_TIMEDOUT)) {
-				erp_action->fsf_req->status |=
-					ZFCP_STATUS_FSFREQ_DISMISSED;
-				zfcp_rec_dbf_event_action(142, erp_action);
-			}
-			if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
-				zfcp_rec_dbf_event_action(143, erp_action);
-			/*
-			 * If fsf_req is neither dismissed nor completed
-			 * then keep it running asynchronously and don't mess
-			 * with the association of erp_action and fsf_req.
-			 */
-			if (erp_action->fsf_req->status &
-					(ZFCP_STATUS_FSFREQ_COMPLETED |
-					       ZFCP_STATUS_FSFREQ_DISMISSED)) {
-				/* forget about association between fsf_req
-				   and erp_action */
-				erp_action->fsf_req = NULL;
-			}
-		} else {
-			/*
-			 * even if this fsf_req has gone, forget about
-			 * association between erp_action and fsf_req
-			 */
-			erp_action->fsf_req = NULL;
-		}
-		spin_unlock(&adapter->req_list_lock);
-	}
-}
-
-/**
- * zfcp_erp_async_handler_nolock - complete erp_action
- *
- * Used for normal completion, time-out, dismissal and failure after
- * low memory condition.
- */
-static void zfcp_erp_async_handler_nolock(struct zfcp_erp_action *erp_action,
-					  unsigned long set_mask)
-{
+	write_lock_irqsave(&adapter->erp_lock, flags);
 	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING) {
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
-	} else {
-		/* action is ready or gone - nothing to do */
 	}
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 /**
- * zfcp_erp_async_handler - wrapper for erp_async_handler_nolock w/ locking
+ * zfcp_erp_timeout_handler - Trigger ERP action from timed out ERP request
+ * @data: ERP action (from timer data)
  */
-void zfcp_erp_async_handler(struct zfcp_erp_action *erp_action,
-			    unsigned long set_mask)
+void zfcp_erp_timeout_handler(unsigned long data)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	unsigned long flags;
-
-	write_lock_irqsave(&adapter->erp_lock, flags);
-	zfcp_erp_async_handler_nolock(erp_action, set_mask);
-	write_unlock_irqrestore(&adapter->erp_lock, flags);
+	struct zfcp_erp_action *act = (struct zfcp_erp_action *) data;
+	zfcp_erp_notify(act, ZFCP_STATUS_ERP_TIMEDOUT);
 }
 
-/*
- * purpose:	is called for erp_action which was slept waiting for
- *		memory becoming avaliable,
- *		will trigger that this action will be continued
- */
-static void
-zfcp_erp_memwait_handler(unsigned long data)
+static void zfcp_erp_memwait_handler(unsigned long data)
 {
-	struct zfcp_erp_action *erp_action = (struct zfcp_erp_action *) data;
-
-	zfcp_erp_async_handler(erp_action, 0);
+	zfcp_erp_notify((struct zfcp_erp_action *)data, 0);
 }
 
-/*
- * purpose:	is called if an asynchronous erp step timed out,
- *		action gets an appropriate flag and will be processed
- *		accordingly
- */
-static void zfcp_erp_timeout_handler(unsigned long data)
+static void zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_erp_action *erp_action = (struct zfcp_erp_action *) data;
-
-	zfcp_erp_async_handler(erp_action, ZFCP_STATUS_ERP_TIMEDOUT);
+	init_timer(&erp_action->timer);
+	erp_action->timer.function = zfcp_erp_memwait_handler;
+	erp_action->timer.data = (unsigned long) erp_action;
+	erp_action->timer.expires = jiffies + HZ;
+	add_timer(&erp_action->timer);
 }
 
-/**
- * zfcp_erp_action_dismiss - dismiss an erp_action
- *
- * adapter->erp_lock must be held
- *
- * Dismissal of an erp_action is usually required if an erp_action of
- * higher priority is generated.
- */
-static void zfcp_erp_action_dismiss(struct zfcp_erp_action *erp_action)
+static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
+				      int clear, u8 id, void *ref)
 {
-	erp_action->status |= ZFCP_STATUS_ERP_DISMISSED;
-	if (zfcp_erp_action_exists(erp_action) == ZFCP_ERP_ACTION_RUNNING)
-		zfcp_erp_action_ready(erp_action);
+	struct zfcp_port *port;
+
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if (!atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA)
+			_zfcp_erp_port_reopen(port, clear, id, ref);
 }
 
-int
-zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
+static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear, u8 id,
+				      void *ref)
 {
-	int retval = 0;
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-
-	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
-	if (retval < 0)
-		dev_err(&adapter->ccw_device->dev,
-			"Creation of ERP thread failed.\n");
-	else {
-		wait_event(adapter->erp_thread_wqh,
-			   atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-					    &adapter->status));
-	}
+	struct zfcp_unit *unit;
 
-	return (retval < 0);
+	list_for_each_entry(unit, &port->unit_list_head, list)
+		_zfcp_erp_unit_reopen(unit, clear, id, ref);
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:
- *
- * context:	process (i.e. proc-fs or rmmod/insmod)
- *
- * note:	The caller of this routine ensures that the specified
- *		adapter has been shut down and that this operation
- *		has been completed. Thus, there are no pending erp_actions
- *		which would need to be handled here.
- */
-int
-zfcp_erp_thread_kill(struct zfcp_adapter *adapter)
+static void zfcp_erp_strategy_followup_actions(struct zfcp_erp_action *act)
 {
-	int retval = 0;
+	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_port *port = act->port;
+	struct zfcp_unit *unit = act->unit;
+	u32 status = act->status;
 
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
-	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock(2, adapter);
+	/* initiate follow-up actions depending on success of finished action */
+	switch (act->action) {
 
-	wait_event(adapter->erp_thread_wqh,
-		   !atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-				     &adapter->status));
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		if (status == ZFCP_ERP_SUCCEEDED)
+			_zfcp_erp_port_reopen_all(adapter, 0, 70, NULL);
+		else
+			_zfcp_erp_adapter_reopen(adapter, 0, 71, NULL);
+		break;
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
-			  &adapter->status);
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		if (status == ZFCP_ERP_SUCCEEDED)
+			_zfcp_erp_port_reopen(port, 0, 72, NULL);
+		else
+			_zfcp_erp_adapter_reopen(adapter, 0, 73, NULL);
+		break;
 
-	return retval;
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		if (status == ZFCP_ERP_SUCCEEDED)
+			_zfcp_erp_unit_reopen_all(port, 0, 74, NULL);
+		else
+			_zfcp_erp_port_forced_reopen(port, 0, 75, NULL);
+		break;
+
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		if (status != ZFCP_ERP_SUCCEEDED)
+			_zfcp_erp_port_reopen(unit->port, 0, 76, NULL);
+		break;
+	}
 }
 
-/*
- * purpose:	is run as a kernel thread,
- *		goes through list of error recovery actions of associated adapter
- *		and delegates single action to execution
- *
- * returns:	0
- */
-static int
-zfcp_erp_thread(void *data)
+static void zfcp_erp_wakeup(struct zfcp_adapter *adapter)
 {
-	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	struct list_head *next;
-	struct zfcp_erp_action *erp_action;
 	unsigned long flags;
 
-	daemonize("zfcperp%s", zfcp_get_busid_by_adapter(adapter));
-	/* Block all signals */
-	siginitsetinv(&current->blocked, 0);
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	wake_up(&adapter->erp_thread_wqh);
-
-	while (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
-				 &adapter->status)) {
-
-		write_lock_irqsave(&adapter->erp_lock, flags);
-		next = adapter->erp_ready_head.next;
-		write_unlock_irqrestore(&adapter->erp_lock, flags);
-
-		if (next != &adapter->erp_ready_head) {
-			erp_action =
-			    list_entry(next, struct zfcp_erp_action, list);
-			/*
-			 * process action (incl. [re]moving it
-			 * from 'ready' queue)
-			 */
-			zfcp_erp_strategy(erp_action);
-		}
-
-		/*
-		 * sleep as long as there is nothing to do, i.e.
-		 * no action in 'ready' queue to be processed and
-		 * thread is not to be killed
-		 */
-		zfcp_rec_dbf_event_thread_lock(4, adapter);
-		down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock(5, adapter);
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	read_lock(&adapter->erp_lock);
+	if (list_empty(&adapter->erp_ready_head) &&
+	    list_empty(&adapter->erp_running_head)) {
+			atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
+					  &adapter->status);
+			wake_up(&adapter->erp_done_wqh);
 	}
+	read_unlock(&adapter->erp_lock);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+}
 
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
-	wake_up(&adapter->erp_thread_wqh);
+static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *act)
+{
+	if (zfcp_qdio_open(act->adapter))
+		return ZFCP_ERP_FAILED;
+	init_waitqueue_head(&act->adapter->request_wq);
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &act->adapter->status);
+	return ZFCP_ERP_SUCCEEDED;
+}
 
-	return 0;
+static void zfcp_erp_enqueue_ptp_port(struct zfcp_adapter *adapter)
+{
+	struct zfcp_port *port;
+	port = zfcp_port_enqueue(adapter, adapter->peer_wwpn, 0,
+				 adapter->peer_d_id);
+	if (IS_ERR(port)) /* error or port already attached */
+		return;
+	_zfcp_erp_port_reopen(port, 0, 150, NULL);
 }
 
-/*
- * function:
- *
- * purpose:	drives single error recovery action and schedules higher and
- *		subordinate actions, if necessary
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully (deqd)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully (deqd)
- *		ZFCP_ERP_EXIT		- action finished (dequeued), offline
- *		ZFCP_ERP_DISMISSED	- action canceled (dequeued)
- */
-static int
-zfcp_erp_strategy(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_adapter_strat_fsf_xconf(struct zfcp_erp_action *erp_action)
 {
-	int retval = 0;
+	int retries;
+	int sleep = 1;
 	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
-	struct zfcp_unit *unit = erp_action->unit;
-	int action = erp_action->action;
-	u32 status = erp_action->status;
-	unsigned long flags;
-
-	/* serialise dismissing, timing out, moving, enqueueing */
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
 
-	/* dequeue dismissed action and leave, if required */
-	retval = zfcp_erp_strategy_check_action(erp_action, retval);
-	if (retval == ZFCP_ERP_DISMISSED) {
-		goto unlock;
-	}
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
 
-	/*
-	 * move action to 'running' queue before processing it
-	 * (to avoid a race condition regarding moving the
-	 * action to the 'running' queue and back)
-	 */
-	zfcp_erp_action_to_running(erp_action);
+	for (retries = 7; retries; retries--) {
+		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+				  &adapter->status);
+		write_lock_irq(&adapter->erp_lock);
+		zfcp_erp_action_to_running(erp_action);
+		write_unlock_irq(&adapter->erp_lock);
+		if (zfcp_fsf_exchange_config_data(erp_action)) {
+			atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+					  &adapter->status);
+			return ZFCP_ERP_FAILED;
+		}
 
-	/*
-	 * try to process action as far as possible,
-	 * no lock to allow for blocking operations (kmalloc, qdio, ...),
-	 * afterwards the lock is required again for the following reasons:
-	 * - dequeueing of finished action and enqueueing of
-	 *   follow-up actions must be atomic so that any other
-	 *   reopen-routine does not believe there is nothing to do
-	 *   and that it is safe to enqueue something else,
-	 * - we want to force any control thread which is dismissing
-	 *   actions to finish this before we decide about
-	 *   necessary steps to be taken here further
-	 */
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-	retval = zfcp_erp_strategy_do_action(erp_action);
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+		zfcp_rec_dbf_event_thread_lock(6, adapter);
+		down(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread_lock(7, adapter);
+		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
+			break;
 
-	/*
-	 * check for dismissed status again to avoid follow-up actions,
-	 * failing of targets and so on for dismissed actions,
-	 * we go through down() here because there has been an up()
-	 */
-	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED)
-		retval = ZFCP_ERP_CONTINUES;
+		if (!(atomic_read(&adapter->status) &
+		      ZFCP_STATUS_ADAPTER_HOST_CON_INIT))
+			break;
 
-	switch (retval) {
-	case ZFCP_ERP_NOMEM:
-		/* no memory to continue immediately, let it sleep */
-		if (!(erp_action->status & ZFCP_STATUS_ERP_LOWMEM)) {
-			++adapter->erp_low_mem_count;
-			erp_action->status |= ZFCP_STATUS_ERP_LOWMEM;
-		}
-		/* This condition is true if there is no memory available
-		   for any erp_action on this adapter. This implies that there
-		   are no elements in the memory pool(s) left for erp_actions.
-		   This might happen if an erp_action that used a memory pool
-		   element was timed out.
-		 */
-		if (adapter->erp_total_count == adapter->erp_low_mem_count)
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, NULL);
-		else
-			retval = zfcp_erp_strategy_memwait(erp_action);
-		goto unlock;
-	case ZFCP_ERP_CONTINUES:
-		/* leave since this action runs asynchronously */
-		if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
-			--adapter->erp_low_mem_count;
-			erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
-		}
-		goto unlock;
+		ssleep(sleep);
+		sleep *= 2;
 	}
-	/* ok, finished action (whatever its result is) */
 
-	/* check for unrecoverable targets */
-	retval = zfcp_erp_strategy_check_target(erp_action, retval);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
+			  &adapter->status);
 
-	/* action must be dequeued (here to allow for further ones) */
-	zfcp_erp_action_dequeue(erp_action);
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_XCONFIG_OK))
+		return ZFCP_ERP_FAILED;
 
-	/*
-	 * put this target through the erp mill again if someone has
-	 * requested to change the status of a target being online
-	 * to offline or the other way around
-	 * (old retval is preserved if nothing has to be done here)
-	 */
-	retval = zfcp_erp_strategy_statechange(action, status, adapter,
-					       port, unit, retval);
-
-	/*
-	 * leave if target is in permanent error state or if
-	 * action is repeated in order to process state change
-	 */
-	if (retval == ZFCP_ERP_EXIT) {
-		goto unlock;
-	}
+	if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
+		zfcp_erp_enqueue_ptp_port(adapter);
 
-	/* trigger follow up actions */
-	zfcp_erp_strategy_followup_actions(action, adapter, port, unit, retval);
+	return ZFCP_ERP_SUCCEEDED;
+}
 
- unlock:
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+static int zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *act)
+{
+	int ret;
+	struct zfcp_adapter *adapter = act->adapter;
 
-	if (retval != ZFCP_ERP_CONTINUES)
-		zfcp_erp_action_cleanup(action, adapter, port, unit, retval);
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
 
-	/*
-	 * a few tasks remain when the erp queues are empty
-	 * (don't do that if the last action evaluated was dismissed
-	 * since this clearly indicates that there is more to come) :
-	 * - close the name server port if it is open yet
-	 *   (enqueues another [probably] final action)
-	 * - otherwise, wake up whoever wants to be woken when we are
-	 *   done with erp
-	 */
-	if (retval != ZFCP_ERP_DISMISSED)
-		zfcp_erp_strategy_check_queues(adapter);
+	write_lock_irq(&adapter->erp_lock);
+	zfcp_erp_action_to_running(act);
+	write_unlock_irq(&adapter->erp_lock);
 
-	return retval;
+	ret = zfcp_fsf_exchange_port_data(act);
+	if (ret == -EOPNOTSUPP)
+		return ZFCP_ERP_SUCCEEDED;
+	if (ret)
+		return ZFCP_ERP_FAILED;
+
+	zfcp_rec_dbf_event_thread_lock(8, adapter);
+	down(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread_lock(9, adapter);
+	if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
+		return ZFCP_ERP_FAILED;
+
+	return ZFCP_ERP_SUCCEEDED;
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_DISMISSED	- if action has been dismissed
- *		retval			- otherwise
- */
-static int
-zfcp_erp_strategy_check_action(struct zfcp_erp_action *erp_action, int retval)
+static int zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *act)
 {
-	zfcp_erp_strategy_check_fsfreq(erp_action);
+	if (zfcp_erp_adapter_strat_fsf_xconf(act) == ZFCP_ERP_FAILED)
+		return ZFCP_ERP_FAILED;
 
-	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED) {
-		zfcp_erp_action_dequeue(erp_action);
-		retval = ZFCP_ERP_DISMISSED;
-	}
+	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
+		return ZFCP_ERP_FAILED;
 
-	return retval;
+	atomic_set(&act->adapter->stat_miss, 16);
+	if (zfcp_status_read_refill(act->adapter))
+		return ZFCP_ERP_FAILED;
+
+	return ZFCP_ERP_SUCCEEDED;
 }
 
-static int
-zfcp_erp_strategy_do_action(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *act,
+					     int close)
 {
-	int retval = ZFCP_ERP_FAILED;
+	int retval = ZFCP_ERP_SUCCEEDED;
+	struct zfcp_adapter *adapter = act->adapter;
 
-	/*
-	 * try to execute/continue action as far as possible,
-	 * note: no lock in subsequent strategy routines
-	 * (this allows these routine to call schedule, e.g.
-	 * kmalloc with such flags or qdio_initialize & friends)
-	 * Note: in case of timeout, the separate strategies will fail
-	 * anyhow. No need for a special action. Even worse, a nameserver
-	 * failure would not wake up waiting ports without the call.
-	 */
-	switch (erp_action->action) {
+	if (close)
+		goto close_only;
 
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		retval = zfcp_erp_adapter_strategy(erp_action);
-		break;
+	retval = zfcp_erp_adapter_strategy_open_qdio(act);
+	if (retval != ZFCP_ERP_SUCCEEDED)
+		goto failed_qdio;
 
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		retval = zfcp_erp_port_forced_strategy(erp_action);
-		break;
+	retval = zfcp_erp_adapter_strategy_open_fsf(act);
+	if (retval != ZFCP_ERP_SUCCEEDED)
+		goto failed_openfcp;
 
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		retval = zfcp_erp_port_strategy(erp_action);
-		break;
+	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &act->adapter->status);
+	schedule_work(&act->adapter->scan_work);
 
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		retval = zfcp_erp_unit_strategy(erp_action);
-		break;
-	}
+	return ZFCP_ERP_SUCCEEDED;
 
-	return retval;
+ close_only:
+	atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+			  &act->adapter->status);
+
+ failed_openfcp:
+	/* close queues to ensure that buffers are not accessed by adapter */
+	zfcp_qdio_close(adapter);
+	zfcp_fsf_req_dismiss_all(adapter);
+	adapter->fsf_req_seq_no = 0;
+	/* all ports and units are closed */
+	zfcp_erp_modify_adapter_status(adapter, 24, NULL,
+				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
+ failed_qdio:
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
+			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+			  ZFCP_STATUS_ADAPTER_XPORT_OK,
+			  &act->adapter->status);
+	return retval;
 }
 
-/*
- * function:
- *
- * purpose:	triggers retry of this action after a certain amount of time
- *		by means of timer provided by erp_action
- *
- * returns:	ZFCP_ERP_CONTINUES - erp_action sleeps in erp running queue
- */
-static int
-zfcp_erp_strategy_memwait(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_adapter_strategy(struct zfcp_erp_action *act)
 {
-	int retval = ZFCP_ERP_CONTINUES;
+	int retval;
 
-	init_timer(&erp_action->timer);
-	erp_action->timer.function = zfcp_erp_memwait_handler;
-	erp_action->timer.data = (unsigned long) erp_action;
-	erp_action->timer.expires = jiffies + ZFCP_ERP_MEMWAIT_TIMEOUT;
-	add_timer(&erp_action->timer);
+	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &act->adapter->status);
+	zfcp_erp_adapter_strategy_generic(act, 1); /* close */
+	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING, &act->adapter->status);
+	if (act->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
+		return ZFCP_ERP_EXIT;
+
+	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &act->adapter->status);
+	retval = zfcp_erp_adapter_strategy_generic(act, 0); /* open */
+	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING, &act->adapter->status);
+
+	if (retval == ZFCP_ERP_FAILED)
+		ssleep(8);
 
 	return retval;
 }
 
-/*
- * function:    zfcp_erp_adapter_failed
- *
- * purpose:     sets the adapter and all underlying devices to ERP_FAILED
- *
- */
-void
-zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, void *ref)
+static int zfcp_erp_port_forced_strategy_close(struct zfcp_erp_action *act)
 {
-	zfcp_erp_modify_adapter_status(adapter, id, ref,
-				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
-	dev_err(&adapter->ccw_device->dev, "Adapter ERP failed.\n");
+	int retval;
+
+	retval = zfcp_fsf_close_physical_port(act);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	act->step = ZFCP_ERP_STEP_PHYS_PORT_CLOSING;
+	if (retval)
+		return ZFCP_ERP_FAILED;
+
+	return ZFCP_ERP_CONTINUES;
 }
 
-/*
- * function:    zfcp_erp_port_failed
- *
- * purpose:     sets the port and all underlying devices to ERP_FAILED
- *
- */
-void
-zfcp_erp_port_failed(struct zfcp_port *port, u8 id, void *ref)
+static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
-	zfcp_erp_modify_port_status(port, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
+			  ZFCP_STATUS_COMMON_CLOSING |
+			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
+			  ZFCP_STATUS_PORT_DID_DID |
+			  ZFCP_STATUS_PORT_PHYS_CLOSING |
+			  ZFCP_STATUS_PORT_INVALID_WWPN,
+			  &port->status);
+}
 
-	if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
-		dev_err(&port->adapter->ccw_device->dev,
-			"Port ERP failed for WKA port d_id=0x%06x.\n",
-			port->d_id);
-	else
-		dev_err(&port->adapter->ccw_device->dev,
-			"Port ERP failed for port wwpn=0x%016Lx.\n",
-			port->wwpn);
+static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
+{
+	struct zfcp_port *port = erp_action->port;
+	int status = atomic_read(&port->status);
+
+	switch (erp_action->step) {
+	case ZFCP_ERP_STEP_UNINITIALIZED:
+		zfcp_erp_port_strategy_clearstati(port);
+		if ((status & ZFCP_STATUS_PORT_PHYS_OPEN) &&
+		    (status & ZFCP_STATUS_COMMON_OPEN))
+			return zfcp_erp_port_forced_strategy_close(erp_action);
+		else
+			return ZFCP_ERP_FAILED;
+
+	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
+		if (status & ZFCP_STATUS_PORT_PHYS_OPEN)
+			return ZFCP_ERP_SUCCEEDED;
+	}
+	return ZFCP_ERP_FAILED;
 }
 
-/*
- * function:    zfcp_erp_unit_failed
- *
- * purpose:     sets the unit to ERP_FAILED
- *
- */
-void
-zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, void *ref)
+static int zfcp_erp_port_strategy_close(struct zfcp_erp_action *erp_action)
 {
-	zfcp_erp_modify_unit_status(unit, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+	int retval;
 
-	dev_err(&unit->port->adapter->ccw_device->dev,
-		"Unit ERP failed for unit 0x%016Lx on port 0x%016Lx.\n",
-		unit->fcp_lun, unit->port->wwpn);
+	retval = zfcp_fsf_close_port(erp_action);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	erp_action->step = ZFCP_ERP_STEP_PORT_CLOSING;
+	if (retval)
+		return ZFCP_ERP_FAILED;
+	return ZFCP_ERP_CONTINUES;
 }
 
-/*
- * function:	zfcp_erp_strategy_check_target
- *
- * purpose:	increments the erp action count on the device currently in
- *              recovery if the action failed or resets the count in case of
- *              success. If a maximum count is exceeded the device is marked
- *              as ERP_FAILED.
- *		The 'blocked' state of a target which has been recovered
- *              successfully is reset.
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (not considered)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully
- *		ZFCP_ERP_EXIT		- action failed and will not continue
- */
-static int
-zfcp_erp_strategy_check_target(struct zfcp_erp_action *erp_action, int result)
+static int zfcp_erp_port_strategy_open_port(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
-	struct zfcp_unit *unit = erp_action->unit;
+	int retval;
 
-	switch (erp_action->action) {
+	retval = zfcp_fsf_open_port(erp_action);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	erp_action->step = ZFCP_ERP_STEP_PORT_OPENING;
+	if (retval)
+		return ZFCP_ERP_FAILED;
+	return ZFCP_ERP_CONTINUES;
+}
 
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		result = zfcp_erp_strategy_check_unit(unit, result);
-		break;
+static void zfcp_erp_port_strategy_open_ns_wake(struct zfcp_erp_action *ns_act)
+{
+	unsigned long flags;
+	struct zfcp_adapter *adapter = ns_act->adapter;
+	struct zfcp_erp_action *act, *tmp;
+	int status;
 
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		result = zfcp_erp_strategy_check_port(port, result);
-		break;
+	read_lock_irqsave(&adapter->erp_lock, flags);
+	list_for_each_entry_safe(act, tmp, &adapter->erp_running_head, list) {
+		if (act->step == ZFCP_ERP_STEP_NAMESERVER_OPEN) {
+			status = atomic_read(&adapter->nameserver_port->status);
+			if (status & ZFCP_STATUS_COMMON_ERP_FAILED)
+				zfcp_erp_port_failed(act->port, 27, NULL);
+			zfcp_erp_action_ready(act);
+		}
+	}
+	read_unlock_irqrestore(&adapter->erp_lock, flags);
+}
 
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		result = zfcp_erp_strategy_check_adapter(adapter, result);
-		break;
+static int zfcp_erp_port_strategy_open_nameserver(struct zfcp_erp_action *act)
+{
+	int retval;
+
+	switch (act->step) {
+	case ZFCP_ERP_STEP_UNINITIALIZED:
+	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
+	case ZFCP_ERP_STEP_PORT_CLOSING:
+		return zfcp_erp_port_strategy_open_port(act);
+
+	case ZFCP_ERP_STEP_PORT_OPENING:
+		if (atomic_read(&act->port->status) & ZFCP_STATUS_COMMON_OPEN)
+			retval = ZFCP_ERP_SUCCEEDED;
+		else
+			retval = ZFCP_ERP_FAILED;
+		/* this is needed anyway  */
+		zfcp_erp_port_strategy_open_ns_wake(act);
+		return retval;
+
+	default:
+		return ZFCP_ERP_FAILED;
 	}
+}
 
-	return result;
+static int zfcp_erp_port_strategy_open_lookup(struct zfcp_erp_action *act)
+{
+	int retval;
+
+	retval = zfcp_fc_ns_gid_pn_request(act);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	act->step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
+	if (retval)
+		return ZFCP_ERP_FAILED;
+	return ZFCP_ERP_CONTINUES;
 }
 
-static int
-zfcp_erp_strategy_statechange(int action,
-			      u32 status,
-			      struct zfcp_adapter *adapter,
-			      struct zfcp_port *port,
-			      struct zfcp_unit *unit, int retval)
+static int zfcp_erp_open_ptp_port(struct zfcp_erp_action *act)
 {
-	switch (action) {
+	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_port *port = act->port;
 
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (zfcp_erp_strategy_statechange_detected(&adapter->status,
-							   status)) {
-			zfcp_erp_adapter_reopen_internal(adapter,
-						ZFCP_STATUS_COMMON_ERP_FAILED,
-						67, NULL);
-			retval = ZFCP_ERP_EXIT;
+	if (port->wwpn != adapter->peer_wwpn) {
+		dev_err(&adapter->ccw_device->dev,
+			"Failed to open port 0x%016Lx, "
+			"Peer WWPN 0x%016Lx does not "
+			"match.\n", port->wwpn,
+			adapter->peer_wwpn);
+		zfcp_erp_port_failed(port, 25, NULL);
+		return ZFCP_ERP_FAILED;
+	}
+	port->d_id = adapter->peer_d_id;
+	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
+	return zfcp_erp_port_strategy_open_port(act);
+}
+
+static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
+{
+	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_port *port = act->port;
+	struct zfcp_port *ns_port = adapter->nameserver_port;
+	int p_status = atomic_read(&port->status);
+
+	switch (act->step) {
+	case ZFCP_ERP_STEP_UNINITIALIZED:
+	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
+	case ZFCP_ERP_STEP_PORT_CLOSING:
+		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
+			return zfcp_erp_open_ptp_port(act);
+		if (!ns_port) {
+			dev_err(&adapter->ccw_device->dev,
+				"Nameserver port unavailable.\n");
+			return ZFCP_ERP_FAILED;
 		}
-		break;
+		if (!(atomic_read(&ns_port->status) &
+		      ZFCP_STATUS_COMMON_UNBLOCKED)) {
+			/* nameserver port may live again */
+			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
+					&ns_port->status);
+			if (zfcp_erp_port_reopen(ns_port, 0, 77, act) >= 0) {
+				act->step = ZFCP_ERP_STEP_NAMESERVER_OPEN;
+				return ZFCP_ERP_CONTINUES;
+			}
+			return ZFCP_ERP_FAILED;
+		}
+		/* else nameserver port is already open, fall through */
+	case ZFCP_ERP_STEP_NAMESERVER_OPEN:
+		if (!(atomic_read(&ns_port->status) & ZFCP_STATUS_COMMON_OPEN))
+			return ZFCP_ERP_FAILED;
+		return zfcp_erp_port_strategy_open_lookup(act);
 
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (zfcp_erp_strategy_statechange_detected(&port->status,
-							   status)) {
-			zfcp_erp_port_reopen_internal(port,
-						ZFCP_STATUS_COMMON_ERP_FAILED,
-						68, NULL);
-			retval = ZFCP_ERP_EXIT;
+	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
+		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
+			if (p_status & (ZFCP_STATUS_PORT_INVALID_WWPN)) {
+				zfcp_erp_port_failed(port, 26, NULL);
+				return ZFCP_ERP_EXIT;
+			}
+			return ZFCP_ERP_FAILED;
 		}
+		return zfcp_erp_port_strategy_open_port(act);
+
+	case ZFCP_ERP_STEP_PORT_OPENING:
+		/* D_ID might have changed during open */
+		if ((p_status & ZFCP_STATUS_COMMON_OPEN) &&
+		    (p_status & ZFCP_STATUS_PORT_DID_DID))
+			return ZFCP_ERP_SUCCEEDED;
+		/* fall through otherwise */
+	}
+	return ZFCP_ERP_FAILED;
+}
+
+static int zfcp_erp_port_strategy_open(struct zfcp_erp_action *act)
+{
+	if (atomic_read(&act->port->status) & (ZFCP_STATUS_PORT_WKA))
+		return zfcp_erp_port_strategy_open_nameserver(act);
+	return zfcp_erp_port_strategy_open_common(act);
+}
+
+static int zfcp_erp_port_strategy(struct zfcp_erp_action *erp_action)
+{
+	struct zfcp_port *port = erp_action->port;
+
+	switch (erp_action->step) {
+	case ZFCP_ERP_STEP_UNINITIALIZED:
+		zfcp_erp_port_strategy_clearstati(port);
+		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+			return zfcp_erp_port_strategy_close(erp_action);
 		break;
 
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (zfcp_erp_strategy_statechange_detected(&unit->status,
-							   status)) {
-			zfcp_erp_unit_reopen_internal(unit,
-						ZFCP_STATUS_COMMON_ERP_FAILED,
-						69, NULL);
-			retval = ZFCP_ERP_EXIT;
-		}
+	case ZFCP_ERP_STEP_PORT_CLOSING:
+		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)
+			return ZFCP_ERP_FAILED;
 		break;
 	}
+	if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
+		return ZFCP_ERP_EXIT;
+	else
+		return zfcp_erp_port_strategy_open(erp_action);
 
-	return retval;
+	return ZFCP_ERP_FAILED;
+}
+
+static void zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
+{
+	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
+			  ZFCP_STATUS_COMMON_CLOSING |
+			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
+			  ZFCP_STATUS_UNIT_SHARED |
+			  ZFCP_STATUS_UNIT_READONLY,
+			  &unit->status);
+}
+
+static int zfcp_erp_unit_strategy_close(struct zfcp_erp_action *erp_action)
+{
+	int retval = zfcp_fsf_close_unit(erp_action);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	erp_action->step = ZFCP_ERP_STEP_UNIT_CLOSING;
+	if (retval)
+		return ZFCP_ERP_FAILED;
+	return ZFCP_ERP_CONTINUES;
+}
+
+static int zfcp_erp_unit_strategy_open(struct zfcp_erp_action *erp_action)
+{
+	int retval = zfcp_fsf_open_unit(erp_action);
+	if (retval == -ENOMEM)
+		return ZFCP_ERP_NOMEM;
+	erp_action->step = ZFCP_ERP_STEP_UNIT_OPENING;
+	if (retval)
+		return  ZFCP_ERP_FAILED;
+	return ZFCP_ERP_CONTINUES;
 }
 
-static int
-zfcp_erp_strategy_statechange_detected(atomic_t * target_status, u32 erp_status)
+static int zfcp_erp_unit_strategy(struct zfcp_erp_action *erp_action)
 {
-	return
-	    /* take it online */
-	    (atomic_test_mask(ZFCP_STATUS_COMMON_RUNNING, target_status) &&
-	     (ZFCP_STATUS_ERP_CLOSE_ONLY & erp_status)) ||
-	    /* take it offline */
-	    (!atomic_test_mask(ZFCP_STATUS_COMMON_RUNNING, target_status) &&
-	     !(ZFCP_STATUS_ERP_CLOSE_ONLY & erp_status));
+	struct zfcp_unit *unit = erp_action->unit;
+
+	switch (erp_action->step) {
+	case ZFCP_ERP_STEP_UNINITIALIZED:
+		zfcp_erp_unit_strategy_clearstati(unit);
+		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
+			return zfcp_erp_unit_strategy_close(erp_action);
+		/* already closed, fall through */
+	case ZFCP_ERP_STEP_UNIT_CLOSING:
+		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
+			return ZFCP_ERP_FAILED;
+		if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
+			return ZFCP_ERP_EXIT;
+		return zfcp_erp_unit_strategy_open(erp_action);
+
+	case ZFCP_ERP_STEP_UNIT_OPENING:
+		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
+			return ZFCP_ERP_SUCCEEDED;
+	}
+	return ZFCP_ERP_FAILED;
 }
 
-static int
-zfcp_erp_strategy_check_unit(struct zfcp_unit *unit, int result)
+static int zfcp_erp_strategy_check_unit(struct zfcp_unit *unit, int result)
 {
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
@@ -1177,29 +1068,25 @@ zfcp_erp_strategy_check_unit(struct zfcp
 		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS)
 			zfcp_erp_unit_failed(unit, 21, NULL);
 		break;
-	case ZFCP_ERP_EXIT :
-		/* nothing */
-		break;
 	}
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &unit->status)) {
-		zfcp_erp_unit_block(unit, 0); /* for ZFCP_ERP_SUCCEEDED */
+	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
+		zfcp_erp_unit_block(unit, 0);
 		result = ZFCP_ERP_EXIT;
 	}
-
 	return result;
 }
 
-static int
-zfcp_erp_strategy_check_port(struct zfcp_port *port, int result)
+static int zfcp_erp_strategy_check_port(struct zfcp_port *port, int result)
 {
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&port->erp_counter, 0);
 		zfcp_erp_port_unblock(port);
 		break;
+
 	case ZFCP_ERP_FAILED :
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_NOESC, &port->status)) {
+		if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC) {
 			zfcp_erp_port_block(port, 0);
 			result = ZFCP_ERP_EXIT;
 		}
@@ -1207,1402 +1094,588 @@ zfcp_erp_strategy_check_port(struct zfcp
 		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS)
 			zfcp_erp_port_failed(port, 22, NULL);
 		break;
-	case ZFCP_ERP_EXIT :
-		/* nothing */
-		break;
 	}
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
-		zfcp_erp_port_block(port, 0); /* for ZFCP_ERP_SUCCEEDED */
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
+		zfcp_erp_port_block(port, 0);
 		result = ZFCP_ERP_EXIT;
 	}
-
 	return result;
 }
 
-static int
-zfcp_erp_strategy_check_adapter(struct zfcp_adapter *adapter, int result)
+static int zfcp_erp_strategy_check_adapter(struct zfcp_adapter *adapter,
+					   int result)
 {
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
 		atomic_set(&adapter->erp_counter, 0);
 		zfcp_erp_adapter_unblock(adapter);
 		break;
+
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&adapter->erp_counter);
 		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS)
 			zfcp_erp_adapter_failed(adapter, 23, NULL);
 		break;
-	case ZFCP_ERP_EXIT :
-		/* nothing */
-		break;
 	}
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status)) {
-		zfcp_erp_adapter_block(adapter, 0); /* for ZFCP_ERP_SUCCEEDED */
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
+		zfcp_erp_adapter_block(adapter, 0);
 		result = ZFCP_ERP_EXIT;
 	}
-
 	return result;
 }
 
-struct zfcp_erp_add_work {
-	struct zfcp_unit  *unit;
-	struct work_struct work;
-};
-
-/**
- * zfcp_erp_scsi_scan
- * @data: pointer to a struct zfcp_erp_add_work
- *
- * Registers a logical unit with the SCSI stack.
- */
-static void zfcp_erp_scsi_scan(struct work_struct *work)
+static int zfcp_erp_strategy_check_target(struct zfcp_erp_action *erp_action,
+					  int result)
 {
-	struct zfcp_erp_add_work *p =
-		container_of(work, struct zfcp_erp_add_work, work);
-	struct zfcp_unit *unit = p->unit;
-	struct fc_rport *rport = unit->port->rport;
-	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-			 unit->scsi_lun, 0);
-	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	zfcp_unit_put(unit);
-	kfree(p);
-}
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_port *port = erp_action->port;
+	struct zfcp_unit *unit = erp_action->unit;
 
-/**
- * zfcp_erp_schedule_work
- * @unit: pointer to unit which should be registered with SCSI stack
- *
- * Schedules work which registers a unit with the SCSI stack
- */
-static void
-zfcp_erp_schedule_work(struct zfcp_unit *unit)
-{
-	struct zfcp_erp_add_work *p;
+	switch (erp_action->action) {
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p) {
-		dev_err(&unit->port->adapter->ccw_device->dev,
-			"Out of resources. Could not register unit 0x%016Lx "
-			"on port 0x%016Lx with SCSI stack.\n",
-			unit->fcp_lun, unit->port->wwpn);
-		return;
-	}
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		result = zfcp_erp_strategy_check_unit(unit, result);
+		break;
 
-	zfcp_unit_get(unit);
-	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
-	p->unit = unit;
-	schedule_work(&p->work);
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		result = zfcp_erp_strategy_check_port(port, result);
+		break;
+
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		result = zfcp_erp_strategy_check_adapter(adapter, result);
+		break;
+	}
+	return result;
 }
 
-/*
- * function:
- *
- * purpose:	remaining things in good cases,
- *		escalation in bad cases
- *
- * returns:
- */
-static int
-zfcp_erp_strategy_followup_actions(int action,
-				   struct zfcp_adapter *adapter,
-				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, int status)
+static int zfcp_erp_strat_change_det(atomic_t *target_status, u32 erp_status)
 {
-	/* initiate follow-up actions depending on success of finished action */
-	switch (action) {
+	int status = atomic_read(target_status);
+
+	if ((status & ZFCP_STATUS_COMMON_RUNNING) &&
+	    (erp_status & ZFCP_STATUS_ERP_CLOSE_ONLY))
+		return 1; /* take it online */
+
+	if (!(status & ZFCP_STATUS_COMMON_RUNNING) &&
+	    !(erp_status & ZFCP_STATUS_ERP_CLOSE_ONLY))
+		return 1; /* take it offline */
+
+	return 0;
+}
 
+static int zfcp_erp_strategy_statechange(struct zfcp_erp_action *act, int ret)
+{
+	int action = act->action;
+	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_port *port = act->port;
+	struct zfcp_unit *unit = act->unit;
+	u32 erp_status = act->status;
+
+	switch (action) {
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_all_internal(adapter, 0, 70, NULL);
-		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 71, NULL);
+		if (zfcp_erp_strat_change_det(&adapter->status, erp_status)) {
+			_zfcp_erp_adapter_reopen(adapter,
+						 ZFCP_STATUS_COMMON_ERP_FAILED,
+						 67, NULL);
+			return ZFCP_ERP_EXIT;
+		}
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(port, 0, 72, NULL);
-		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 73, NULL);
-		break;
-
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_unit_reopen_all_internal(port, 0, 74, NULL);
-		else
-			zfcp_erp_port_forced_reopen_internal(port, 0, 75, NULL);
+		if (zfcp_erp_strat_change_det(&port->status, erp_status)) {
+			_zfcp_erp_port_reopen(port,
+					      ZFCP_STATUS_COMMON_ERP_FAILED,
+					      68, NULL);
+			return ZFCP_ERP_EXIT;
+		}
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		/* Nothing to do if status == ZFCP_ERP_SUCCEEDED */
-		if (status != ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(unit->port, 0, 76, NULL);
+		if (zfcp_erp_strat_change_det(&unit->status, erp_status)) {
+			_zfcp_erp_unit_reopen(unit,
+					      ZFCP_STATUS_COMMON_ERP_FAILED,
+					      69, NULL);
+			return ZFCP_ERP_EXIT;
+		}
 		break;
 	}
-
-	return 0;
+	return ret;
 }
 
-static int
-zfcp_erp_strategy_check_queues(struct zfcp_adapter *adapter)
+static void zfcp_erp_action_dequeue(struct zfcp_erp_action *erp_action)
 {
-	unsigned long flags;
+	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	read_lock(&adapter->erp_lock);
-	if (list_empty(&adapter->erp_ready_head) &&
-	    list_empty(&adapter->erp_running_head)) {
-			atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
-					  &adapter->status);
-			wake_up(&adapter->erp_done_wqh);
+	adapter->erp_total_count--;
+	if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
+		adapter->erp_low_mem_count--;
+		erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
 	}
-	read_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
-	return 0;
-}
+	list_del(&erp_action->list);
+	zfcp_rec_dbf_event_action(144, erp_action);
 
-/**
- * zfcp_erp_wait - wait for completion of error recovery on an adapter
- * @adapter: adapter for which to wait for completion of its error recovery
- * Return: 0
- */
-int
-zfcp_erp_wait(struct zfcp_adapter *adapter)
-{
-	int retval = 0;
+	switch (erp_action->action) {
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+				  &erp_action->unit->status);
+		break;
 
-	wait_event(adapter->erp_done_wqh,
-		   !atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
-				     &adapter->status));
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+				  &erp_action->port->status);
+		break;
 
-	return retval;
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+				  &erp_action->adapter->status);
+		break;
+	}
 }
 
-void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, u8 id,
-				    void *ref, u32 mask, int set_or_clear)
-{
-	struct zfcp_port *port;
-	u32 changed, common_mask = mask & ZFCP_COMMON_FLAGS;
-
-	if (set_or_clear == ZFCP_SET) {
-		changed = atomic_test_and_set_mask(mask, &adapter->status);
-	} else {
-		changed = atomic_test_and_clear_mask(mask, &adapter->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
-			atomic_set(&adapter->erp_counter, 0);
-	}
-	if (changed)
-		zfcp_rec_dbf_event_adapter(id, ref, adapter);
+struct zfcp_erp_add_work {
+	struct zfcp_unit  *unit;
+	struct work_struct work;
+};
 
-	/* Deal with all underlying devices, only pass common_mask */
-	if (common_mask)
-		list_for_each_entry(port, &adapter->port_list_head, list)
-			zfcp_erp_modify_port_status(port, id, ref, common_mask,
-						    set_or_clear);
+static void zfcp_erp_scsi_scan(struct work_struct *work)
+{
+	struct zfcp_erp_add_work *p =
+		container_of(work, struct zfcp_erp_add_work, work);
+	struct zfcp_unit *unit = p->unit;
+	struct fc_rport *rport = unit->port->rport;
+	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+			 unit->scsi_lun, 0);
+	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
+	zfcp_unit_put(unit);
+	kfree(p);
 }
 
-/*
- * function:	zfcp_erp_modify_port_status
- *
- * purpose:	sets the port and all underlying devices to ERP_FAILED
- *
- */
-void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, void *ref,
-				 u32 mask, int set_or_clear)
+static void zfcp_erp_schedule_work(struct zfcp_unit *unit)
 {
-	struct zfcp_unit *unit;
-	u32 changed, common_mask = mask & ZFCP_COMMON_FLAGS;
+	struct zfcp_erp_add_work *p;
 
-	if (set_or_clear == ZFCP_SET) {
-		changed = atomic_test_and_set_mask(mask, &port->status);
-	} else {
-		changed = atomic_test_and_clear_mask(mask, &port->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
-			atomic_set(&port->erp_counter, 0);
+	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		dev_err(&unit->port->adapter->ccw_device->dev,
+			"Out of resources. Could not register unit "
+			"0x%016Lx on port 0x%016Lx with SCSI stack.\n",
+			unit->fcp_lun, unit->port->wwpn);
+		return;
 	}
-	if (changed)
-		zfcp_rec_dbf_event_port(id, ref, port);
 
-	/* Modify status of all underlying devices, only pass common mask */
-	if (common_mask)
-		list_for_each_entry(unit, &port->unit_list_head, list)
-			zfcp_erp_modify_unit_status(unit, id, ref, common_mask,
-						    set_or_clear);
+	zfcp_unit_get(unit);
+	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
+	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
+	p->unit = unit;
+	schedule_work(&p->work);
 }
 
-/*
- * function:	zfcp_erp_modify_unit_status
- *
- * purpose:	sets the unit to ERP_FAILED
- *
- */
-void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, void *ref,
-				 u32 mask, int set_or_clear)
+static void zfcp_erp_rport_register(struct zfcp_port *port)
 {
-	u32 changed;
-
-	if (set_or_clear == ZFCP_SET) {
-		changed = atomic_test_and_set_mask(mask, &unit->status);
-	} else {
-		changed = atomic_test_and_clear_mask(mask, &unit->status);
-		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
-			atomic_set(&unit->erp_counter, 0);
-		}
+	struct fc_rport_identifiers ids;
+	ids.node_name = port->wwnn;
+	ids.port_name = port->wwpn;
+	ids.port_id = port->d_id;
+	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
+	port->rport = fc_remote_port_add(port->adapter->scsi_host, 0, &ids);
+	if (!port->rport) {
+		dev_err(&port->adapter->ccw_device->dev,
+			"Failed registration of rport "
+			"0x%016Lx.\n", port->wwpn);
+		return;
 	}
-	if (changed)
-		zfcp_rec_dbf_event_unit(id, ref, unit);
-}
-
-/*
- * function:
- *
- * purpose:	Wrappper for zfcp_erp_port_reopen_all_internal
- *              used to ensure the correct locking
- *
- * returns:	0	- initiated action successfully
- *		<0	- failed to initiate action
- */
-int zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter, int clear_mask,
-			     u8 id, void *ref)
-{
-	int retval;
-	unsigned long flags;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_reopen_all_internal(adapter, clear_mask, id,
-						   ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
-	return retval;
+	scsi_target_unblock(&port->rport->dev);
+	port->rport->maxframe_size = port->maxframe_size;
+	port->rport->supported_classes = port->supported_classes;
 }
 
-static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *adapter,
-					     int clear_mask, u8 id, void *ref)
+static void zfcp_erp_rports_del(struct zfcp_adapter *adapter)
 {
-	int retval = 0;
 	struct zfcp_port *port;
-
 	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
-			zfcp_erp_port_reopen_internal(port, clear_mask, id,
-						      ref);
-
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	FIXME
- */
-static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *port,
-					     int clear_mask, u8 id, void *ref)
-{
-	int retval = 0;
-	struct zfcp_unit *unit;
-
-	list_for_each_entry(unit, &port->unit_list_head, list)
-		zfcp_erp_unit_reopen_internal(unit, clear_mask, id, ref);
-
-	return retval;
+		if (port->rport && !(atomic_read(&port->status) &
+					ZFCP_STATUS_PORT_WKA)) {
+			fc_remote_port_delete(port->rport);
+			port->rport = NULL;
+		}
 }
 
-/*
- * function:
- *
- * purpose:	this routine executes the 'Reopen Adapter' action
- *		(the entire action is processed synchronously, since
- *		there are no actions which might be run concurrently
- *		per definition)
- *
- * returns:	ZFCP_ERP_SUCCEEDED	- action finished successfully
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_adapter_strategy(struct zfcp_erp_action *erp_action)
+static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 {
-	int retval;
+	struct zfcp_adapter *adapter = act->adapter;
+	struct zfcp_port *port = act->port;
+	struct zfcp_unit *unit = act->unit;
 
-	retval = zfcp_erp_adapter_strategy_close(erp_action);
-	if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
-		retval = ZFCP_ERP_EXIT;
-	else
-		retval = zfcp_erp_adapter_strategy_open(erp_action);
+	switch (act->action) {
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		if ((result == ZFCP_ERP_SUCCEEDED) &&
+		    !unit->device && port->rport) {
+			atomic_set_mask(ZFCP_STATUS_UNIT_REGISTERED,
+					&unit->status);
+			if (!(atomic_read(&unit->status) &
+			      ZFCP_STATUS_UNIT_SCSI_WORK_PENDING))
+				zfcp_erp_schedule_work(unit);
+		}
+		zfcp_unit_put(unit);
+		break;
 
-	if (retval == ZFCP_ERP_FAILED)
-		ssleep(ZFCP_TYPE2_RECOVERY_TIME);
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		if (atomic_read(&port->status) & ZFCP_STATUS_PORT_NO_WWPN) {
+			zfcp_port_put(port);
+			return;
+		}
+		if ((result == ZFCP_ERP_SUCCEEDED) && !port->rport)
+			zfcp_erp_rport_register(port);
+		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {
+			fc_remote_port_delete(port->rport);
+			port->rport = NULL;
+		}
+		zfcp_port_put(port);
+		break;
 
-	return retval;
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		if (result != ZFCP_ERP_SUCCEEDED)
+			zfcp_erp_rports_del(adapter);
+		zfcp_adapter_put(adapter);
+		break;
+	}
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_SUCCEEDED      - action finished successfully
- *              ZFCP_ERP_FAILED         - action finished unsuccessfully
- */
-static int
-zfcp_erp_adapter_strategy_close(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_strategy_do_action(struct zfcp_erp_action *erp_action)
 {
-	int retval;
-
-	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING,
-			&erp_action->adapter->status);
-	retval = zfcp_erp_adapter_strategy_generic(erp_action, 1);
-	atomic_clear_mask(ZFCP_STATUS_COMMON_CLOSING,
-			  &erp_action->adapter->status);
-
-	return retval;
+	switch (erp_action->action) {
+	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
+		return zfcp_erp_adapter_strategy(erp_action);
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
+		return zfcp_erp_port_forced_strategy(erp_action);
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		return zfcp_erp_port_strategy(erp_action);
+	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+		return zfcp_erp_unit_strategy(erp_action);
+	}
+	return ZFCP_ERP_FAILED;
 }
 
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_SUCCEEDED      - action finished successfully
- *              ZFCP_ERP_FAILED         - action finished unsuccessfully
- */
-static int
-zfcp_erp_adapter_strategy_open(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_strategy(struct zfcp_erp_action *erp_action)
 {
 	int retval;
+	struct zfcp_adapter *adapter = erp_action->adapter;
+	unsigned long flags;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING,
-			&erp_action->adapter->status);
-	retval = zfcp_erp_adapter_strategy_generic(erp_action, 0);
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING,
-			  &erp_action->adapter->status);
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	write_lock(&adapter->erp_lock);
 
-	return retval;
-}
+	zfcp_erp_strategy_check_fsfreq(erp_action);
 
-/*
- * function:    zfcp_register_adapter
- *
- * purpose:	allocate the irq associated with this devno and register
- *		the FSF adapter with the SCSI stack
- *
- * returns:
- */
-static int
-zfcp_erp_adapter_strategy_generic(struct zfcp_erp_action *erp_action, int close)
-{
-	int retval = ZFCP_ERP_SUCCEEDED;
+	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED) {
+		zfcp_erp_action_dequeue(erp_action);
+		retval = ZFCP_ERP_DISMISSED;
+		goto unlock;
+	}
 
-	if (close)
-		goto close_only;
+	zfcp_erp_action_to_running(erp_action);
 
-	retval = zfcp_erp_adapter_strategy_open_qdio(erp_action);
-	if (retval != ZFCP_ERP_SUCCEEDED)
-		goto failed_qdio;
+	/* no lock to allow for blocking operations */
+	write_unlock(&adapter->erp_lock);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	retval = zfcp_erp_strategy_do_action(erp_action);
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	write_lock(&adapter->erp_lock);
 
-	retval = zfcp_erp_adapter_strategy_open_fsf(erp_action);
-	if (retval != ZFCP_ERP_SUCCEEDED)
-		goto failed_openfcp;
+	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED)
+		retval = ZFCP_ERP_CONTINUES;
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &erp_action->adapter->status);
-	schedule_work(&erp_action->adapter->scan_work);
-	goto out;
-
- close_only:
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
-			  &erp_action->adapter->status);
-
- failed_openfcp:
-	zfcp_close_fsf(erp_action->adapter);
- failed_qdio:
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
-			  ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-			  ZFCP_STATUS_ADAPTER_XPORT_OK,
-			  &erp_action->adapter->status);
- out:
-	return retval;
-}
-
-/*
- * function:    zfcp_qdio_init
- *
- * purpose:	setup QDIO operation for specified adapter
- *
- * returns:	0 - successful setup
- *		!0 - failed setup
- */
-static int
-zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *erp_action)
-{
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	if (zfcp_qdio_open(adapter))
-		return ZFCP_ERP_FAILED;
-
-	/* initialize waitqueue used to wait for free SBALs in requests queue */
-	init_waitqueue_head(&adapter->request_wq);
-
-	/* ok, we did it - skip all cleanups for different failures */
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	return ZFCP_ERP_SUCCEEDED;
-}
-
-
-static int
-zfcp_erp_adapter_strategy_open_fsf(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_erp_adapter_strategy_open_fsf_xconfig(erp_action);
-	if (retval == ZFCP_ERP_FAILED)
-		return ZFCP_ERP_FAILED;
-
-	retval = zfcp_erp_adapter_strategy_open_fsf_xport(erp_action);
-	if (retval == ZFCP_ERP_FAILED)
-		return ZFCP_ERP_FAILED;
-
-	return zfcp_erp_adapter_strategy_open_fsf_statusread(erp_action);
-}
-
-static void zfcp_erp_open_ptp_port(struct zfcp_adapter *adapter)
-{
-	struct zfcp_port *port;
-	port = zfcp_port_enqueue(adapter, adapter->peer_wwpn, 0,
-				 adapter->peer_d_id);
-	if (IS_ERR(port)) /* error or port already attached */
-		return;
-	zfcp_erp_port_reopen_internal(port, 0, 150, NULL);
-}
-
-static int
-zfcp_erp_adapter_strategy_open_fsf_xconfig(struct zfcp_erp_action *erp_action)
-{
-	int retries;
-	int sleep = ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK, &adapter->status);
-
-	for (retries = ZFCP_EXCHANGE_CONFIG_DATA_RETRIES; retries; retries--) {
-		atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-				  &adapter->status);
-		write_lock_irq(&adapter->erp_lock);
-		zfcp_erp_action_to_running(erp_action);
-		write_unlock_irq(&adapter->erp_lock);
-		if (zfcp_fsf_exchange_config_data(erp_action)) {
-			atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-					  &adapter->status);
-			return ZFCP_ERP_FAILED;
-		}
-
-		/*
-		 * Why this works:
-		 * Both the normal completion handler as well as the timeout
-		 * handler will do an 'up' when the 'exchange config data'
-		 * request completes or times out. Thus, the signal to go on
-		 * won't be lost utilizing this semaphore.
-		 * Furthermore, this 'adapter_reopen' action is
-		 * guaranteed to be the only action being there (highest action
-		 * which prevents other actions from being created).
-		 * Resulting from that, the wake signal recognized here
-		 * _must_ be the one belonging to the 'exchange config
-		 * data' request.
-		 */
-		zfcp_rec_dbf_event_thread_lock(6, adapter);
-		down(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock(7, adapter);
-		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
-			break;
-
-		if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-				     &adapter->status))
-			break;
-
-		/* sleep a little bit before retry */
-		ssleep(sleep);
-		sleep *= 2;
-	}
-
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
-			  &adapter->status);
-
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
-			      &adapter->status))
-		return ZFCP_ERP_FAILED;
-
-	if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
-		zfcp_erp_open_ptp_port(adapter);
-
-	return ZFCP_ERP_SUCCEEDED;
-}
-
-static int
-zfcp_erp_adapter_strategy_open_fsf_xport(struct zfcp_erp_action *erp_action)
-{
-	int ret;
-	struct zfcp_adapter *adapter;
-
-	adapter = erp_action->adapter;
-	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-
-	write_lock_irq(&adapter->erp_lock);
-	zfcp_erp_action_to_running(erp_action);
-	write_unlock_irq(&adapter->erp_lock);
-
-	ret = zfcp_fsf_exchange_port_data(erp_action);
-	if (ret == -EOPNOTSUPP) {
-		return ZFCP_ERP_SUCCEEDED;
-	} else if (ret) {
-		return ZFCP_ERP_FAILED;
-	}
-
-	ret = ZFCP_ERP_SUCCEEDED;
-	zfcp_rec_dbf_event_thread_lock(8, adapter);
-	down(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock(9, adapter);
-	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
-		ret = ZFCP_ERP_FAILED;
-
-	return ret;
-}
-
-static int
-zfcp_erp_adapter_strategy_open_fsf_statusread(struct zfcp_erp_action
-					      *erp_action)
-{
-	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	atomic_set(&adapter->stat_miss, 16);
-	return zfcp_status_read_refill(adapter);
-}
-
-/*
- * function:
- *
- * purpose:	this routine executes the 'Reopen Physical Port' action
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
-{
-	int retval = ZFCP_ERP_FAILED;
-	struct zfcp_port *port = erp_action->port;
-
-	switch (erp_action->step) {
-
-		/*
-		 * FIXME:
-		 * the ULP spec. begs for waiting for oustanding commands
-		 */
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_port_strategy_clearstati(port);
-		/*
-		 * it would be sufficient to test only the normal open flag
-		 * since the phys. open flag cannot be set if the normal
-		 * open flag is unset - however, this is for readabilty ...
-		 */
-		if (atomic_test_mask((ZFCP_STATUS_PORT_PHYS_OPEN |
-				      ZFCP_STATUS_COMMON_OPEN),
-			             &port->status)) {
-			retval =
-			    zfcp_erp_port_forced_strategy_close(erp_action);
-		} else
-			retval = ZFCP_ERP_FAILED;
-		break;
-
-	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-		if (atomic_test_mask(ZFCP_STATUS_PORT_PHYS_OPEN,
-				     &port->status)) {
-			retval = ZFCP_ERP_FAILED;
-		} else
-			retval = ZFCP_ERP_SUCCEEDED;
-		break;
-	}
-
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:	this routine executes the 'Reopen Port' action
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_strategy(struct zfcp_erp_action *erp_action)
-{
-	int retval = ZFCP_ERP_FAILED;
-	struct zfcp_port *port = erp_action->port;
-
-	switch (erp_action->step) {
-
-		/*
-		 * FIXME:
-		 * the ULP spec. begs for waiting for oustanding commands
-		 */
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_port_strategy_clearstati(port);
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status)) {
-			retval = zfcp_erp_port_strategy_close(erp_action);
-			goto out;
-		}		/* else it's already closed, open it */
-		break;
-
-	case ZFCP_ERP_STEP_PORT_CLOSING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status)) {
-			retval = ZFCP_ERP_FAILED;
-			goto out;
-		}		/* else it's closed now, open it */
-		break;
-	}
-	if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
-		retval = ZFCP_ERP_EXIT;
-	else
-		retval = zfcp_erp_port_strategy_open(erp_action);
-
- out:
-	return retval;
-}
-
-static int
-zfcp_erp_port_strategy_open(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	if (atomic_test_mask(ZFCP_STATUS_PORT_WKA,
-			     &erp_action->port->status))
-		retval = zfcp_erp_port_strategy_open_nameserver(erp_action);
-	else
-		retval = zfcp_erp_port_strategy_open_common(erp_action);
-
-	return retval;
-}
-
-static int
-zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *erp_action)
-{
-	int retval = 0;
-	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_port *port = erp_action->port;
-
-	switch (erp_action->step) {
-
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-	case ZFCP_ERP_STEP_PORT_CLOSING:
-		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP) {
-			if (port->wwpn != adapter->peer_wwpn) {
-				dev_err(&adapter->ccw_device->dev,
-					"Failed to open port 0x%016Lx, "
-					"Peer WWPN 0x%016Lx does not match.\n",
-					port->wwpn, adapter->peer_wwpn);
-				zfcp_erp_port_failed(port, 25, NULL);
-				retval = ZFCP_ERP_FAILED;
-				break;
-			}
-			port->d_id = adapter->peer_d_id;
-			atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
-			retval = zfcp_erp_port_strategy_open_port(erp_action);
-			break;
-		}
-
-		if (!adapter->nameserver_port) {
-			dev_err(&adapter->ccw_device->dev,
-				"Nameserver port unavailable.\n");
-			retval = ZFCP_ERP_FAILED;
-			break;
-		}
-		if (!atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
-				      &adapter->nameserver_port->status)) {
-			/* nameserver port may live again */
-			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
-					&adapter->nameserver_port->status);
-			if (zfcp_erp_port_reopen(adapter->nameserver_port, 0,
-						 77, erp_action) >= 0) {
-				erp_action->step =
-					ZFCP_ERP_STEP_NAMESERVER_OPEN;
-				retval = ZFCP_ERP_CONTINUES;
-			} else
-				retval = ZFCP_ERP_FAILED;
-			break;
-		}
-		/* else nameserver port is already open, fall through */
-	case ZFCP_ERP_STEP_NAMESERVER_OPEN:
-		if (!atomic_test_mask(ZFCP_STATUS_COMMON_OPEN,
-				      &adapter->nameserver_port->status))
-			retval = ZFCP_ERP_FAILED;
-		else
-			retval = zfcp_erp_port_strategy_open_common_lookup
-				(erp_action);
-		break;
-
-	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
-		if (!atomic_test_mask(ZFCP_STATUS_PORT_DID_DID, &port->status)) {
-			if (atomic_test_mask
-			    (ZFCP_STATUS_PORT_INVALID_WWPN, &port->status)) {
-				zfcp_erp_port_failed(port, 26, NULL);
-				retval = ZFCP_ERP_EXIT;
-			} else
-				retval = ZFCP_ERP_FAILED;
-		} else
-			retval = zfcp_erp_port_strategy_open_port(erp_action);
-		break;
-
-	case ZFCP_ERP_STEP_PORT_OPENING:
-		/* D_ID might have changed during open */
-		if (atomic_test_mask((ZFCP_STATUS_COMMON_OPEN |
-				      ZFCP_STATUS_PORT_DID_DID),
-				     &port->status))
-			retval = ZFCP_ERP_SUCCEEDED;
-		else
-			retval = ZFCP_ERP_FAILED;
-		break;
-
-	default:
-		/* unknown erp step */
-		retval = ZFCP_ERP_FAILED;
-	}
-
-	return retval;
-}
-
-static int
-zfcp_erp_port_strategy_open_nameserver(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-	struct zfcp_port *port = erp_action->port;
-
-	switch (erp_action->step) {
-
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-	case ZFCP_ERP_STEP_PORT_CLOSING:
-		retval = zfcp_erp_port_strategy_open_port(erp_action);
-		break;
-
-	case ZFCP_ERP_STEP_PORT_OPENING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &port->status))
-			retval = ZFCP_ERP_SUCCEEDED;
-		else
-			retval = ZFCP_ERP_FAILED;
-		/* this is needed anyway (dont care for retval of wakeup) */
-		zfcp_erp_port_strategy_open_nameserver_wakeup(erp_action);
-		break;
-
-	default:
-		/* unknown erp step */
-		retval = ZFCP_ERP_FAILED;
-	}
-
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:	makes the erp thread continue with reopen (physical) port
- *		actions which have been paused until the name server port
- *		is opened (or failed)
- *
- * returns:	0	(a kind of void retval, its not used)
- */
-static int
-zfcp_erp_port_strategy_open_nameserver_wakeup(struct zfcp_erp_action
-					      *ns_erp_action)
-{
-	int retval = 0;
-	unsigned long flags;
-	struct zfcp_adapter *adapter = ns_erp_action->adapter;
-	struct zfcp_erp_action *erp_action, *tmp;
-
-	read_lock_irqsave(&adapter->erp_lock, flags);
-	list_for_each_entry_safe(erp_action, tmp, &adapter->erp_running_head,
-				 list) {
-		if (erp_action->step == ZFCP_ERP_STEP_NAMESERVER_OPEN) {
-			if (atomic_test_mask(
-				    ZFCP_STATUS_COMMON_ERP_FAILED,
-				    &adapter->nameserver_port->status))
-				zfcp_erp_port_failed(erp_action->port, 27,
-						     NULL);
-			zfcp_erp_action_ready(erp_action);
-		}
-	}
-	read_unlock_irqrestore(&adapter->erp_lock, flags);
-
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_forced_strategy_close(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fsf_close_physical_port(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_PHYS_PORT_CLOSING;
-	if (retval != 0) {
-		/* could not send 'open', fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
- out:
-	return retval;
-}
-
-static int
-zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
-{
-	int retval = 0;
-
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
-			  ZFCP_STATUS_COMMON_CLOSING |
-			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_PORT_DID_DID |
-			  ZFCP_STATUS_PORT_PHYS_CLOSING |
-			  ZFCP_STATUS_PORT_INVALID_WWPN,
-			  &port->status);
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_strategy_close(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fsf_close_port(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_PORT_CLOSING;
-	if (retval != 0) {
-		/* could not send 'close', fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
- out:
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_strategy_open_port(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fsf_open_port(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_PORT_OPENING;
-	if (retval != 0) {
-		/* could not send 'open', fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
- out:
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_port_strategy_open_common_lookup(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fc_ns_gid_pn_request(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
-	if (retval != 0) {
-		/* could not send nameserver request, fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
- out:
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:	this routine executes the 'Reopen Unit' action
- *		currently no retries
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_SUCCEEDED	- action finished successfully
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_unit_strategy(struct zfcp_erp_action *erp_action)
-{
-	int retval = ZFCP_ERP_FAILED;
-	struct zfcp_unit *unit = erp_action->unit;
-
-	switch (erp_action->step) {
-
-		/*
-		 * FIXME:
-		 * the ULP spec. begs for waiting for oustanding commands
-		 */
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_unit_strategy_clearstati(unit);
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status)) {
-			retval = zfcp_erp_unit_strategy_close(erp_action);
-			break;
-		}
-		/* else it's already closed, fall through */
-	case ZFCP_ERP_STEP_UNIT_CLOSING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status))
-			retval = ZFCP_ERP_FAILED;
-		else
-			if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
-				retval = ZFCP_ERP_EXIT;
-			else
-				retval =
-				    zfcp_erp_unit_strategy_open(erp_action);
-		break;
-
-	case ZFCP_ERP_STEP_UNIT_OPENING:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status))
-			retval = ZFCP_ERP_SUCCEEDED;
-		else
-			retval = ZFCP_ERP_FAILED;
-		break;
-	}
-
-	return retval;
-}
-
-static int
-zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
-{
-	int retval = 0;
-
-	atomic_clear_mask(ZFCP_STATUS_COMMON_OPENING |
-			  ZFCP_STATUS_COMMON_CLOSING |
-			  ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_UNIT_SHARED |
-			  ZFCP_STATUS_UNIT_READONLY,
-			  &unit->status);
-
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_unit_strategy_close(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fsf_close_unit(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_UNIT_CLOSING;
-	if (retval != 0) {
-		/* could not send 'close', fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
-
- out:
-	return retval;
-}
-
-/*
- * function:
- *
- * purpose:
- *
- * returns:	ZFCP_ERP_CONTINUES	- action continues (asynchronously)
- *		ZFCP_ERP_FAILED		- action finished unsuccessfully
- */
-static int
-zfcp_erp_unit_strategy_open(struct zfcp_erp_action *erp_action)
-{
-	int retval;
-
-	retval = zfcp_fsf_open_unit(erp_action);
-	if (retval == -ENOMEM) {
-		retval = ZFCP_ERP_NOMEM;
-		goto out;
-	}
-	erp_action->step = ZFCP_ERP_STEP_UNIT_OPENING;
-	if (retval != 0) {
-		/* could not send 'open', fail */
-		retval = ZFCP_ERP_FAILED;
-		goto out;
-	}
-	retval = ZFCP_ERP_CONTINUES;
- out:
-	return retval;
-}
-
-void zfcp_erp_start_timer(struct zfcp_fsf_req *fsf_req)
-{
-	BUG_ON(!fsf_req->erp_action);
-	fsf_req->timer.function = zfcp_erp_timeout_handler;
-	fsf_req->timer.data = (unsigned long) fsf_req->erp_action;
-	fsf_req->timer.expires = jiffies + ZFCP_ERP_FSFREQ_TIMEOUT;
-	add_timer(&fsf_req->timer);
-}
-
-/*
- * function:
- *
- * purpose:	enqueue the specified error recovery action, if needed
- *
- * returns:
- */
-static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
-				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, u8 id, void *ref)
-{
-	int retval = 1, need = want;
-	struct zfcp_erp_action *erp_action = NULL;
-	u32 status = 0;
-
-	/*
-	 * We need some rules here which check whether we really need
-	 * this action or whether we should just drop it.
-	 * E.g. if there is a unfinished 'Reopen Port' request then we drop a
-	 * 'Reopen Unit' request for an associated unit since we can't
-	 * satisfy this request now. A 'Reopen Port' action will trigger
-	 * 'Reopen Unit' actions when it completes.
-	 * Thus, there are only actions in the queue which can immediately be
-	 * executed. This makes the processing of the action queue more
-	 * efficient.
-	 */
-
-	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
-			      &adapter->status))
-		return -EIO;
-
-	/* check whether we really need this */
-	switch (want) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status)) {
-			goto out;
-		}
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_RUNNING, &port->status) ||
-		    atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_FAILED, &port->status)) {
-			goto out;
-		}
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
-			need = ZFCP_ERP_ACTION_REOPEN_PORT;
-		/* fall through !!! */
-
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_INUSE, &port->status)) {
-			goto out;
-		}
-		/* fall through !!! */
-
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				     &port->status))
-			goto out;
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_RUNNING, &adapter->status) ||
-		    atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_FAILED, &adapter->status)) {
-			goto out;
+	switch (retval) {
+	case ZFCP_ERP_NOMEM:
+		if (!(erp_action->status & ZFCP_STATUS_ERP_LOWMEM)) {
+			++adapter->erp_low_mem_count;
+			erp_action->status |= ZFCP_STATUS_ERP_LOWMEM;
 		}
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
-			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
-		/* fall through !!! */
-
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (atomic_test_mask
-		    (ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status)) {
-			goto out;
+		if (adapter->erp_total_count == adapter->erp_low_mem_count)
+			_zfcp_erp_adapter_reopen(adapter, 0, 66, NULL);
+		else {
+			zfcp_erp_strategy_memwait(erp_action);
+			retval = ZFCP_ERP_CONTINUES;
 		}
-		break;
-
-	default:
-		/* unknown erp action */
-		goto out;
-	}
-
-	/* mark adapter to have some error recovery pending */
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
-
-	/* setup error recovery action */
-	switch (need) {
-
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		zfcp_unit_get(unit);
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
-		erp_action = &unit->erp_action;
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_RUNNING, &unit->status))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
-		break;
-
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		zfcp_port_get(port);
-		zfcp_erp_action_dismiss_port(port);
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
-		erp_action = &port->erp_action;
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_RUNNING, &port->status))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
-		break;
+		goto unlock;
 
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		zfcp_adapter_get(adapter);
-		zfcp_erp_action_dismiss_adapter(adapter);
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status);
-		erp_action = &adapter->erp_action;
-		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_RUNNING, &adapter->status))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
-		break;
+	case ZFCP_ERP_CONTINUES:
+		if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
+			--adapter->erp_low_mem_count;
+			erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
+		}
+		goto unlock;
 	}
 
-	memset(erp_action, 0, sizeof (struct zfcp_erp_action));
-	erp_action->adapter = adapter;
-	erp_action->port = port;
-	erp_action->unit = unit;
-	erp_action->action = need;
-	erp_action->status = status;
+	retval = zfcp_erp_strategy_check_target(erp_action, retval);
+	zfcp_erp_action_dequeue(erp_action);
+	retval = zfcp_erp_strategy_statechange(erp_action, retval);
+	if (retval == ZFCP_ERP_EXIT)
+		goto unlock;
+	zfcp_erp_strategy_followup_actions(erp_action);
 
-	++adapter->erp_total_count;
+ unlock:
+	write_unlock(&adapter->erp_lock);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+
+	if (retval != ZFCP_ERP_CONTINUES)
+		zfcp_erp_action_cleanup(erp_action, retval);
 
-	/* finally put it into 'ready' queue and kick erp thread */
-	list_add_tail(&erp_action->list, &adapter->erp_ready_head);
-	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(1, adapter);
-	retval = 0;
- out:
-	zfcp_rec_dbf_event_trigger(id, ref, want, need, erp_action,
-				   adapter, port, unit);
 	return retval;
 }
 
-static int
-zfcp_erp_action_dequeue(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_thread(void *data)
 {
-	int retval = 0;
-	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
+	struct list_head *next;
+	struct zfcp_erp_action *act;
+	unsigned long flags;
 
-	--adapter->erp_total_count;
-	if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
-		--adapter->erp_low_mem_count;
-		erp_action->status &= ~ZFCP_STATUS_ERP_LOWMEM;
-	}
+	daemonize("zfcperp%s", adapter->ccw_device->dev.bus_id);
+	/* Block all signals */
+	siginitsetinv(&current->blocked, 0);
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
+	wake_up(&adapter->erp_thread_wqh);
 
-	list_del(&erp_action->list);
-	zfcp_rec_dbf_event_action(144, erp_action);
+	while (!(atomic_read(&adapter->status) &
+		 ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL)) {
+		write_lock_irqsave(&adapter->erp_lock, flags);
+		next = adapter->erp_ready_head.next;
+		write_unlock_irqrestore(&adapter->erp_lock, flags);
 
-	switch (erp_action->action) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				  &erp_action->unit->status);
-		break;
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				  &erp_action->port->status);
-		break;
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				  &erp_action->adapter->status);
-		break;
-	default:
-		/* bug */
-		break;
+		if (next != &adapter->erp_ready_head) {
+			act = list_entry(next, struct zfcp_erp_action, list);
+
+			/* there is more to come after dismission, no notify */
+			if (zfcp_erp_strategy(act) != ZFCP_ERP_DISMISSED)
+				zfcp_erp_wakeup(adapter);
+		}
+
+		zfcp_rec_dbf_event_thread(4, adapter);
+		down_interruptible(&adapter->erp_ready_sem);
+		zfcp_rec_dbf_event_thread(5, adapter);
 	}
-	return retval;
+
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
+	wake_up(&adapter->erp_thread_wqh);
+
+	return 0;
 }
 
 /**
- * zfcp_erp_action_cleanup
+ * zfcp_erp_thread_setup - Start ERP thread for adapter
+ * @adapter: Adapter to start the ERP thread for
  *
- * Register unit with scsi stack if appropriate and fix reference counts.
- * Note: Temporary units are not registered with scsi stack.
+ * Returns 0 on success or error code from kernel_thread()
  */
-static void
-zfcp_erp_action_cleanup(int action, struct zfcp_adapter *adapter,
-			struct zfcp_port *port, struct zfcp_unit *unit,
-			int result)
+int zfcp_erp_thread_setup(struct zfcp_adapter *adapter)
 {
-	switch (action) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if ((result == ZFCP_ERP_SUCCEEDED)
-		    && (!atomic_test_mask(ZFCP_STATUS_UNIT_TEMPORARY,
-					  &unit->status))
-		    && !unit->device
-		    && port->rport) {
-			atomic_set_mask(ZFCP_STATUS_UNIT_REGISTERED,
-					&unit->status);
-			if (atomic_test_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING,
-					     &unit->status) == 0)
-				zfcp_erp_schedule_work(unit);
-		}
-		zfcp_unit_put(unit);
-		break;
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (atomic_test_mask(ZFCP_STATUS_PORT_NO_WWPN,
-				     &port->status)) {
-			zfcp_port_put(port);
-			break;
-		}
+	int retval;
 
-		if ((result == ZFCP_ERP_SUCCEEDED)
-		    && !port->rport) {
-			struct fc_rport_identifiers ids;
-			ids.node_name = port->wwnn;
-			ids.port_name = port->wwpn;
-			ids.port_id = port->d_id;
-			ids.roles = FC_RPORT_ROLE_FCP_TARGET;
-			port->rport =
-				fc_remote_port_add(adapter->scsi_host, 0, &ids);
-			if (!port->rport)
-				dev_err(&adapter->ccw_device->dev,
-					"Failed registration of rport "
-					"0x%016Lx.\n", port->wwpn);
-			else {
-				scsi_target_unblock(&port->rport->dev);
-				port->rport->maxframe_size = port->maxframe_size;
-				port->rport->supported_classes =
-					port->supported_classes;
-			}
-		}
-		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {
-			fc_remote_port_delete(port->rport);
-			port->rport = NULL;
-		}
-		zfcp_port_put(port);
-		break;
-	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (result != ZFCP_ERP_SUCCEEDED) {
-			list_for_each_entry(port, &adapter->port_list_head, list)
-				if (port->rport &&
-				    !atomic_test_mask(ZFCP_STATUS_PORT_WKA,
-						      &port->status)) {
-					fc_remote_port_delete(port->rport);
-					port->rport = NULL;
-				}
-		}
-		zfcp_adapter_put(adapter);
-		break;
-	default:
-		break;
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
+	retval = kernel_thread(zfcp_erp_thread, adapter, SIGCHLD);
+	if (retval < 0) {
+		dev_err(&adapter->ccw_device->dev,
+			"Creation of ERP thread failed.\n");
+		return retval;
 	}
+	wait_event(adapter->erp_thread_wqh,
+		   atomic_read(&adapter->status) &
+			ZFCP_STATUS_ADAPTER_ERP_THREAD_UP);
+	return 0;
 }
 
+/**
+ * zfcp_erp_thread_kill - Stop ERP thread.
+ * @adapter: Adapter where the ERP thread should be stopped.
+ *
+ * The caller of this routine ensures that the specified adapter has
+ * been shut down and that this operation has been completed. Thus,
+ * there are no pending erp_actions which would need to be handled
+ * here.
+ */
+void zfcp_erp_thread_kill(struct zfcp_adapter *adapter)
+{
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
+	up(&adapter->erp_ready_sem);
+	zfcp_rec_dbf_event_thread_lock(2, adapter);
+
+	wait_event(adapter->erp_thread_wqh,
+		   !(atomic_read(&adapter->status) &
+				ZFCP_STATUS_ADAPTER_ERP_THREAD_UP));
 
-static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
+	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL,
+			  &adapter->status);
+}
+
+/**
+ * zfcp_erp_adapter_failed - Set adapter status to failed.
+ * @adapter: Failed adapter.
+ * @id: Event id for debug trace.
+ * @ref: Reference for debug trace.
+ */
+void zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, void *ref)
 {
-	struct zfcp_port *port;
+	zfcp_erp_modify_adapter_status(adapter, id, ref,
+				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+	dev_err(&adapter->ccw_device->dev, "Adapter ERP failed.\n");
+}
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &adapter->status))
-		zfcp_erp_action_dismiss(&adapter->erp_action);
+/**
+ * zfcp_erp_port_failed - Set port status to failed.
+ * @port: Failed port.
+ * @id: Event id for debug trace.
+ * @ref: Reference for debug trace.
+ */
+void zfcp_erp_port_failed(struct zfcp_port *port, u8 id, void *ref)
+{
+	zfcp_erp_modify_port_status(port, id, ref,
+				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+
+	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA)
+		dev_err(&port->adapter->ccw_device->dev,
+			"Port ERP failed for WKA port d_id=0x%06x.\n",
+			port->d_id);
 	else
-		list_for_each_entry(port, &adapter->port_list_head, list)
-		    zfcp_erp_action_dismiss_port(port);
+		dev_err(&port->adapter->ccw_device->dev,
+			"Port ERP failed for port wwpn=0x%016Lx.\n",
+			port->wwpn);
 }
 
-static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
+/**
+ * zfcp_erp_unit_failed - Set unit status to failed.
+ * @unit: Failed unit.
+ * @id: Event id for debug trace.
+ * @ref: Reference for debug trace.
+ */
+void zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, void *ref)
 {
-	struct zfcp_unit *unit;
+	zfcp_erp_modify_unit_status(unit, id, ref,
+				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status))
-		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		list_for_each_entry(unit, &port->unit_list_head, list)
-		    zfcp_erp_action_dismiss_unit(unit);
+	dev_err(&unit->port->adapter->ccw_device->dev,
+		"Unit ERP failed for unit 0x%016Lx on port 0x%016Lx.\n",
+		unit->fcp_lun, unit->port->wwpn);
 }
 
-static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
+/**
+ * zfcp_erp_wait - wait for completion of error recovery on an adapter
+ * @adapter: adapter for which to wait for completion of its error recovery
+ */
+void zfcp_erp_wait(struct zfcp_adapter *adapter)
 {
-	if (atomic_test_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status))
-		zfcp_erp_action_dismiss(&unit->erp_action);
+	wait_event(adapter->erp_done_wqh,
+		   !(atomic_read(&adapter->status) &
+			ZFCP_STATUS_ADAPTER_ERP_PENDING));
 }
 
-static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
+/**
+ * zfcp_erp_modify_adapter_status - change adapter status bits
+ * @adapter: adapter to change the status
+ * @id: id for the debug trace
+ * @ref: reference for the debug trace
+ * @mask: status bits to change
+ * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
+ *
+ * Changes in common status bits are propagated to attached ports and units.
+ */
+void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, u8 id,
+				    void *ref, u32 mask, int set_or_clear)
 {
-	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
-	zfcp_rec_dbf_event_action(145, erp_action);
+	struct zfcp_port *port;
+	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+
+	if (set_or_clear == ZFCP_SET) {
+		if (status_change_set(mask, &adapter->status))
+			zfcp_rec_dbf_event_adapter(id, ref, adapter);
+		atomic_set_mask(mask, &adapter->status);
+	} else {
+		if (status_change_clear(mask, &adapter->status))
+			zfcp_rec_dbf_event_adapter(id, ref, adapter);
+		atomic_clear_mask(mask, &adapter->status);
+		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
+			atomic_set(&adapter->erp_counter, 0);
+	}
+
+	if (common_mask)
+		list_for_each_entry(port, &adapter->port_list_head, list)
+			zfcp_erp_modify_port_status(port, id, ref, common_mask,
+						    set_or_clear);
+}
+
+/**
+ * zfcp_erp_modify_port_status - change port status bits
+ * @port: port to change the status bits
+ * @id: id for the debug trace
+ * @ref: reference for the debug trace
+ * @mask: status bits to change
+ * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
+ *
+ * Changes in common status bits are propagated to attached units.
+ */
+void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, void *ref,
+				 u32 mask, int set_or_clear)
+{
+	struct zfcp_unit *unit;
+	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+
+	if (set_or_clear == ZFCP_SET) {
+		if (status_change_set(mask, &port->status))
+			zfcp_rec_dbf_event_port(id, ref, port);
+		atomic_set_mask(mask, &port->status);
+	} else {
+		if (status_change_clear(mask, &port->status))
+			zfcp_rec_dbf_event_port(id, ref, port);
+		atomic_clear_mask(mask, &port->status);
+		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
+			atomic_set(&port->erp_counter, 0);
+	}
+
+	if (common_mask)
+		list_for_each_entry(unit, &port->unit_list_head, list)
+			zfcp_erp_modify_unit_status(unit, id, ref, common_mask,
+						    set_or_clear);
 }
 
-static void zfcp_erp_action_to_ready(struct zfcp_erp_action *erp_action)
+/**
+ * zfcp_erp_modify_unit_status - change unit status bits
+ * @unit: unit to change the status bits
+ * @id: id for the debug trace
+ * @ref: reference for the debug trace
+ * @mask: status bits to change
+ * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
+ */
+void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, void *ref,
+				 u32 mask, int set_or_clear)
 {
-	list_move(&erp_action->list, &erp_action->adapter->erp_ready_head);
-	zfcp_rec_dbf_event_action(146, erp_action);
+	if (set_or_clear == ZFCP_SET) {
+		if (status_change_set(mask, &unit->status))
+			zfcp_rec_dbf_event_unit(id, ref, unit);
+		atomic_set_mask(mask, &unit->status);
+	} else {
+		if (status_change_clear(mask, &unit->status))
+			zfcp_rec_dbf_event_unit(id, ref, unit);
+		atomic_clear_mask(mask, &unit->status);
+		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
+			atomic_set(&unit->erp_counter, 0);
+		}
+	}
 }
 
+/**
+ * zfcp_erp_port_boxed - Mark port as "boxed" and start ERP
+ * @port: The "boxed" port.
+ * @id: The debug trace id.
+ * @id: Reference for the debug trace.
+ */
 void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, void *ref)
 {
 	unsigned long flags;
@@ -2614,6 +1687,12 @@ void zfcp_erp_port_boxed(struct zfcp_por
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
+/**
+ * zfcp_erp_unit_boxed - Mark unit as "boxed" and start ERP
+ * @port: The "boxed" unit.
+ * @id: The debug trace id.
+ * @id: Reference for the debug trace.
+ */
 void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
@@ -2621,6 +1700,15 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
+/**
+ * zfcp_erp_port_access_denied - Adapter denied access to port.
+ * @port: port where access has been denied
+ * @id: id for debug trace
+ * @ref: reference for debug trace
+ *
+ * Since the adapter has denied access, stop using the port and the
+ * attached units.
+ */
 void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, void *ref)
 {
 	unsigned long flags;
@@ -2632,6 +1720,14 @@ void zfcp_erp_port_access_denied(struct 
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
+/**
+ * zfcp_erp_unit_access_denied - Adapter denied access to unit.
+ * @unit: unit where access has been denied
+ * @id: id for debug trace
+ * @ref: reference for debug trace
+ *
+ * Since the adapter has denied access, stop using the unit.
+ */
 void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
@@ -2639,33 +1735,26 @@ void zfcp_erp_unit_access_denied(struct 
 				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }
 
-void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, u8 id,
-				     void *ref)
+static void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id,
+					 void *ref)
 {
-	struct zfcp_port *port;
-	unsigned long flags;
-
-	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
+	int status = atomic_read(&unit->status);
+	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
+			ZFCP_STATUS_COMMON_ACCESS_BOXED)))
 		return;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	if (adapter->nameserver_port)
-		zfcp_erp_port_access_changed(adapter->nameserver_port, id, ref);
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (port != adapter->nameserver_port)
-			zfcp_erp_port_access_changed(port, id, ref);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
-void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id, void *ref)
+static void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id,
+					 void *ref)
 {
 	struct zfcp_unit *unit;
+	int status = atomic_read(&port->status);
 
-	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
-			      &port->status) &&
-	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
-			      &port->status)) {
-		if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
+	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
+			ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
+		if (!(status & ZFCP_STATUS_PORT_WKA))
 			list_for_each_entry(unit, &port->unit_list_head, list)
 				zfcp_erp_unit_access_changed(unit, id, ref);
 		return;
@@ -2674,13 +1763,26 @@ void zfcp_erp_port_access_changed(struct
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
-void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id, void *ref)
+/**
+ * zfcp_erp_adapter_access_changed - Process change in adapter ACT
+ * @adapter: Adapter where the Access Control Table (ACT) changed
+ * @id: Id for debug trace
+ * @ref: Reference for debug trace
+ */
+void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, u8 id,
+				     void *ref)
 {
-	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
-			      &unit->status) &&
-	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
-			      &unit->status))
+	struct zfcp_port *port;
+	unsigned long flags;
+
+	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
 		return;
 
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	if (adapter->nameserver_port)
+		zfcp_erp_port_access_changed(adapter->nameserver_port, id, ref);
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if (port != adapter->nameserver_port)
+			zfcp_erp_port_access_changed(port, id, ref);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
--- a/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:28:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-06-30 11:28:44.000000000 +0200
@@ -91,17 +91,11 @@ zfcp_address_to_sg(void *address, struct
         /* max. number of (data buffer) SBALEs in largest SBAL chain
            multiplied with number of sectors per 4k block */
 
-#define ZFCP_TYPE2_RECOVERY_TIME        8	/* seconds */
-
 /********************* FSF SPECIFIC DEFINES *********************************/
 
 /* ATTENTION: value must not be used by hardware */
 #define FSF_QTCB_UNSOLICITED_STATUS		0x6305
 
-/* Do 1st retry in 1 second, then double the timeout for each following retry */
-#define ZFCP_EXCHANGE_CONFIG_DATA_FIRST_SLEEP	1
-#define ZFCP_EXCHANGE_CONFIG_DATA_RETRIES	7
-
 /* timeout value for "default timer" for fsf requests */
 #define ZFCP_FSF_REQUEST_TIMEOUT (60*HZ)
 
@@ -349,45 +343,6 @@ struct zfcp_rc_entry {
 #define ZFCP_STATUS_FSFREQ_RETRY                0x00000800
 #define ZFCP_STATUS_FSFREQ_DISMISSED            0x00001000
 
-/*********************** ERROR RECOVERY PROCEDURE DEFINES ********************/
-
-#define ZFCP_MAX_ERPS                   3
-
-#define ZFCP_ERP_FSFREQ_TIMEOUT		(30 * HZ)
-#define ZFCP_ERP_MEMWAIT_TIMEOUT	HZ
-
-#define ZFCP_STATUS_ERP_TIMEDOUT	0x10000000
-#define ZFCP_STATUS_ERP_CLOSE_ONLY	0x01000000
-#define ZFCP_STATUS_ERP_DISMISSING	0x00100000
-#define ZFCP_STATUS_ERP_DISMISSED	0x00200000
-#define ZFCP_STATUS_ERP_LOWMEM		0x00400000
-
-#define ZFCP_ERP_STEP_UNINITIALIZED	0x00000000
-#define ZFCP_ERP_STEP_FSF_XCONFIG	0x00000001
-#define ZFCP_ERP_STEP_PHYS_PORT_CLOSING	0x00000010
-#define ZFCP_ERP_STEP_PORT_CLOSING	0x00000100
-#define ZFCP_ERP_STEP_NAMESERVER_OPEN	0x00000200
-#define ZFCP_ERP_STEP_NAMESERVER_LOOKUP	0x00000400
-#define ZFCP_ERP_STEP_PORT_OPENING	0x00000800
-#define ZFCP_ERP_STEP_UNIT_CLOSING	0x00001000
-#define ZFCP_ERP_STEP_UNIT_OPENING	0x00002000
-
-/* Ordered by escalation level (necessary for proper erp-code operation) */
-#define ZFCP_ERP_ACTION_REOPEN_ADAPTER		0x4
-#define ZFCP_ERP_ACTION_REOPEN_PORT_FORCED	0x3
-#define ZFCP_ERP_ACTION_REOPEN_PORT		0x2
-#define ZFCP_ERP_ACTION_REOPEN_UNIT		0x1
-
-#define ZFCP_ERP_ACTION_RUNNING			0x1
-#define ZFCP_ERP_ACTION_READY			0x2
-
-#define ZFCP_ERP_SUCCEEDED	0x0
-#define ZFCP_ERP_FAILED		0x1
-#define ZFCP_ERP_CONTINUES	0x2
-#define ZFCP_ERP_EXIT		0x3
-#define ZFCP_ERP_DISMISSED	0x4
-#define ZFCP_ERP_NOMEM		0x5
-
 /************************* STRUCTURE DEFINITIONS *****************************/
 
 struct zfcp_fsf_req;
--- a/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:28:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-06-30 11:28:44.000000000 +0200
@@ -67,8 +67,6 @@ extern int  zfcp_fsf_exchange_port_data_
                                              struct fsf_qtcb_bottom_port *);
 extern struct zfcp_fsf_req *zfcp_fsf_control_file(struct zfcp_adapter *adapter,
 					   struct zfcp_fsf_cfdc *fsf_cfdc);
-extern void zfcp_fsf_start_timer(struct zfcp_fsf_req *, unsigned long);
-extern void zfcp_erp_start_timer(struct zfcp_fsf_req *);
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int  zfcp_fsf_status_read(struct zfcp_adapter *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
@@ -103,37 +101,34 @@ extern struct fc_function_template zfcp_
 /******************************** ERP ****************************************/
 extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, void *,
 					   u32, int);
-extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, void *);
-extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, void *);
+extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, void *);
+extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, void *);
 extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, void *);
 
 extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, void *, u32,
 					int);
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, u8, void *);
-extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, void *);
-extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, void *);
+extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, void *);
+extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, void *);
 extern void zfcp_erp_port_failed(struct zfcp_port *, u8, void *);
-extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int, u8, void *);
 
 extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, void *, u32,
 					int);
-extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, void *);
-extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, void *);
+extern void zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, void *);
+extern void zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, void *);
 extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, void *);
 
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
-extern int  zfcp_erp_thread_kill(struct zfcp_adapter *);
-extern int  zfcp_erp_wait(struct zfcp_adapter *);
-extern void zfcp_erp_async_handler(struct zfcp_erp_action *, unsigned long);
+extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
+extern void zfcp_erp_wait(struct zfcp_adapter *);
+extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
 
 extern void zfcp_erp_port_boxed(struct zfcp_port *, u8 id, void *ref);
 extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, void *ref);
 extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, void *ref);
 extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8 id, void *ref);
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8, void *);
-extern void zfcp_erp_port_access_changed(struct zfcp_port *, u8, void *);
-extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, void *);
-
+extern void zfcp_erp_timeout_handler(unsigned long);
 /******************************** AUX ****************************************/
 extern void zfcp_sg_free_table(struct scatterlist *sg, int count);
 extern int  zfcp_sg_setup_table(struct scatterlist *sg, int count);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:28:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-06-30 11:28:44.000000000 +0200
@@ -8,6 +8,31 @@
 
 #include "zfcp_ext.h"
 
+static void zfcp_fsf_request_timeout_handler(unsigned long data)
+{
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62,
+				NULL);
+}
+
+static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
+				 unsigned long timeout)
+{
+	fsf_req->timer.function = zfcp_fsf_request_timeout_handler;
+	fsf_req->timer.data = (unsigned long) fsf_req->adapter;
+	fsf_req->timer.expires = jiffies + timeout;
+	add_timer(&fsf_req->timer);
+}
+
+static void zfcp_fsf_start_erp_timer(struct zfcp_fsf_req *fsf_req)
+{
+	BUG_ON(!fsf_req->erp_action);
+	fsf_req->timer.function = zfcp_erp_timeout_handler;
+	fsf_req->timer.data = (unsigned long) fsf_req->erp_action;
+	fsf_req->timer.expires = jiffies + 30 * HZ;
+	add_timer(&fsf_req->timer);
+}
+
 /* association between FSF command and FSF QTCB type */
 static u32 fsf_qtcb_type[] = {
 	[FSF_QTCB_FCP_CMND] =             FSF_IO_COMMAND,
@@ -485,7 +510,7 @@ void zfcp_fsf_req_complete(struct zfcp_f
 	req->handler(req);
 
 	if (req->erp_action)
-		zfcp_erp_async_handler(req->erp_action, 0);
+		zfcp_erp_notify(req->erp_action, 0);
 	req->status |= ZFCP_STATUS_FSFREQ_COMPLETED;
 
 	if (likely(req->status & ZFCP_STATUS_FSFREQ_CLEANUP))
@@ -1108,7 +1133,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	if (erp_action) {
 		erp_action->fsf_req = req;
 		req->erp_action = erp_action;
-		zfcp_erp_start_timer(req);
+		zfcp_fsf_start_erp_timer(req);
 	} else
 		zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 
@@ -1263,7 +1288,7 @@ int zfcp_fsf_exchange_config_data(struct
 	req->handler = zfcp_fsf_exchange_config_data_handler;
 	erp_action->fsf_req = req;
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1353,7 +1378,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	req->erp_action = erp_action;
 	erp_action->fsf_req = req;
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1530,7 +1555,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	erp_action->fsf_req = req;
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->port->status);
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1601,7 +1626,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	erp_action->fsf_req = req;
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->port->status);
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1699,7 +1724,7 @@ int zfcp_fsf_close_physical_port(struct 
 	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
 			&erp_action->port->status);
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1878,7 +1903,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPENING, &erp_action->unit->status);
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
@@ -1963,7 +1988,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	erp_action->fsf_req = req;
 	atomic_set_mask(ZFCP_STATUS_COMMON_CLOSING, &erp_action->unit->status);
 
-	zfcp_erp_start_timer(req);
+	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);

-- 
