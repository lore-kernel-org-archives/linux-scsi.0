From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/12] zfcp: Allow running unit/LUN shutdown without acquiring reference
Date: Wed, 08 Sep 2010 14:39:54 +0200
Message-ID: <20100908124353.288204789@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:56556 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab0IHMn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:57 -0400
Content-Disposition: inline; filename=704-zfcp-shutdown-ref.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change for the LUN data to be part of the scsi_device, the
slave_destroy callback will be the final call to the
zfcp_erp_unit_shutdown function. The erp tries to acquire a reference
to run the action asynchronously and fail, if it cannot get the
reference. But calling scsi_device_get from slave_destroy will fail,
because the scsi_device is already in the state SDEV_DEL.

Introduce a new call into the zfcp erp to solve this: The function
zfcp_erp_unit_shutdown_wait will close the LUN and wait for the erp to
finish without acquiring an additional reference. The wait allows to
omit the reference; the caller waiting for the erp to finish already
has a reference that holds the struct in place.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |   98 +++++++++++++++++++++++++++----------------
 drivers/s390/scsi/zfcp_ext.h |    1 
 2 files changed, 63 insertions(+), 36 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:28.000000000 +0200
@@ -21,6 +21,7 @@ enum zfcp_erp_act_flags {
 	ZFCP_STATUS_ERP_DISMISSING	= 0x00100000,
 	ZFCP_STATUS_ERP_DISMISSED	= 0x00200000,
 	ZFCP_STATUS_ERP_LOWMEM		= 0x00400000,
+	ZFCP_STATUS_ERP_NO_REF		= 0x00800000,
 };
 
 enum zfcp_erp_steps {
@@ -169,22 +170,22 @@ static int zfcp_erp_required_act(int wan
 	return need;
 }
 
-static struct zfcp_erp_action *zfcp_erp_setup_act(int need,
+static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 						  struct zfcp_adapter *adapter,
 						  struct zfcp_port *port,
 						  struct zfcp_unit *unit)
 {
 	struct zfcp_erp_action *erp_action;
-	u32 status = 0;
 
 	switch (need) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (!get_device(&unit->dev))
-			return NULL;
+		if (!(act_status & ZFCP_STATUS_ERP_NO_REF))
+			if (!get_device(&unit->dev))
+				return NULL;
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
 		erp_action = &unit->erp_action;
 		if (!(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_RUNNING))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
@@ -195,7 +196,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
 		erp_action = &port->erp_action;
 		if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_RUNNING))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
@@ -205,7 +206,7 @@ static struct zfcp_erp_action *zfcp_erp_
 		erp_action = &adapter->erp_action;
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING))
-			status = ZFCP_STATUS_ERP_CLOSE_ONLY;
+			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
 
 	default:
@@ -217,14 +218,15 @@ static struct zfcp_erp_action *zfcp_erp_
 	erp_action->port = port;
 	erp_action->unit = unit;
 	erp_action->action = need;
-	erp_action->status = status;
+	erp_action->status = act_status;
 
 	return erp_action;
 }
 
 static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
 				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, char *id, void *ref)
+				   struct zfcp_unit *unit, char *id, void *ref,
+				   u32 act_status)
 {
 	int retval = 1, need;
 	struct zfcp_erp_action *act = NULL;
@@ -236,10 +238,10 @@ static int zfcp_erp_action_enqueue(int w
 	if (!need)
 		goto out;
 
-	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
-	act = zfcp_erp_setup_act(need, adapter, port, unit);
+	act = zfcp_erp_setup_act(need, act_status, adapter, port, unit);
 	if (!act)
 		goto out;
+	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
 	wake_up(&adapter->erp_ready_wq);
@@ -262,7 +264,7 @@ static int _zfcp_erp_adapter_reopen(stru
 		return -EIO;
 	}
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
-				       adapter, NULL, NULL, id, ref);
+				       adapter, NULL, NULL, id, ref, 0);
 }
 
 /**
@@ -285,7 +287,7 @@ void zfcp_erp_adapter_reopen(struct zfcp
 		zfcp_erp_adapter_failed(adapter, "erareo1", NULL);
 	else
 		zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER, adapter,
-					NULL, NULL, id, ref);
+					NULL, NULL, id, ref, 0);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
@@ -317,20 +319,6 @@ void zfcp_erp_port_shutdown(struct zfcp_
 	zfcp_erp_port_reopen(port, clear | flags, id, ref);
 }
 
-/**
- * zfcp_erp_unit_shutdown - Shutdown unit
- * @unit: Unit to shut down.
- * @clear: Status flags to clear.
- * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
- */
-void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, char *id,
-			    void *ref)
-{
-	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
-	zfcp_erp_unit_reopen(unit, clear | flags, id, ref);
-}
-
 static void zfcp_erp_port_block(struct zfcp_port *port, int clear)
 {
 	zfcp_erp_modify_port_status(port, "erpblk1", NULL,
@@ -348,7 +336,7 @@ static void _zfcp_erp_port_forced_reopen
 		return;
 
 	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT_FORCED,
-				port->adapter, port, NULL, id, ref);
+				port->adapter, port, NULL, id, ref, 0);
 }
 
 /**
@@ -381,7 +369,7 @@ static int _zfcp_erp_port_reopen(struct
 	}
 
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT,
-				       port->adapter, port, NULL, id, ref);
+				       port->adapter, port, NULL, id, ref, 0);
 }
 
 /**
@@ -412,7 +400,7 @@ static void zfcp_erp_unit_block(struct z
 }
 
 static void _zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, char *id,
-				  void *ref)
+				  void *ref, u32 act_status)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
@@ -422,7 +410,7 @@ static void _zfcp_erp_unit_reopen(struct
 		return;
 
 	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_UNIT,
-				adapter, unit->port, unit, id, ref);
+				adapter, unit->port, unit, id, ref, act_status);
 }
 
 /**
@@ -439,8 +427,45 @@ void zfcp_erp_unit_reopen(struct zfcp_un
 	struct zfcp_adapter *adapter = port->adapter;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_unit_reopen(unit, clear, id, ref);
+	_zfcp_erp_unit_reopen(unit, clear, id, ref, 0);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
+}
+
+/**
+ * zfcp_erp_unit_shutdown - Shutdown unit
+ * @unit: Unit to shut down.
+ * @clear: Status flags to clear.
+ * @id: Id for debug trace event.
+ * @ref: Reference for debug trace event.
+ */
+void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, char *id,
+			    void *ref)
+{
+	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
+	zfcp_erp_unit_reopen(unit, clear | flags, id, ref);
+}
+
+/**
+ * zfcp_erp_unit_shutdown_wait - Shutdown unit and wait for erp completion
+ * @unit: Unit to shut down.
+ * @id: Id for debug trace event.
+ *
+ * Do not acquire a reference for the unit when creating the ERP
+ * action. It is safe, because this function waits for the ERP to
+ * complete first.
+ */
+void zfcp_erp_unit_shutdown_wait(struct zfcp_unit *unit, char *id)
+{
+	unsigned long flags;
+	struct zfcp_port *port = unit->port;
+	struct zfcp_adapter *adapter = port->adapter;
+	int clear = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
+
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	_zfcp_erp_unit_reopen(unit, clear, id, NULL, ZFCP_STATUS_ERP_NO_REF);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
+
+	zfcp_erp_wait(adapter);
 }
 
 static int status_change_set(unsigned long mask, atomic_t *status)
@@ -566,7 +591,7 @@ static void _zfcp_erp_unit_reopen_all(st
 
 	read_lock(&port->unit_list_lock);
 	list_for_each_entry(unit, &port->unit_list, list)
-		_zfcp_erp_unit_reopen(unit, clear, id, ref);
+		_zfcp_erp_unit_reopen(unit, clear, id, ref, 0);
 	read_unlock(&port->unit_list_lock);
 }
 
@@ -583,7 +608,7 @@ static void zfcp_erp_strategy_followup_f
 		_zfcp_erp_port_reopen(act->port, 0, "ersff_3", NULL);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		_zfcp_erp_unit_reopen(act->unit, 0, "ersff_4", NULL);
+		_zfcp_erp_unit_reopen(act->unit, 0, "ersff_4", NULL, 0);
 		break;
 	}
 }
@@ -1143,7 +1168,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&unit->status, erp_status)) {
 			_zfcp_erp_unit_reopen(unit,
 					      ZFCP_STATUS_COMMON_ERP_FAILED,
-					      "ersscg3", NULL);
+					      "ersscg3", NULL, 0);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1191,7 +1216,8 @@ static void zfcp_erp_action_cleanup(stru
 
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		put_device(&unit->dev);
+		if (!(act->status & ZFCP_STATUS_ERP_NO_REF))
+			put_device(&unit->dev);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:27.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:28.000000000 +0200
@@ -80,6 +80,7 @@ extern void zfcp_erp_modify_unit_status(
 					int);
 extern void zfcp_erp_unit_reopen(struct zfcp_unit *, int, char *, void *);
 extern void zfcp_erp_unit_shutdown(struct zfcp_unit *, int, char *, void *);
+extern void zfcp_erp_unit_shutdown_wait(struct zfcp_unit *, char *);
 extern void zfcp_erp_unit_failed(struct zfcp_unit *, char *, void *);
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);

