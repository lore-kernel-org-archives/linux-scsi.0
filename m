From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/22] zfcp: Replace global config_lock with local list locks
Date: Tue, 24 Nov 2009 16:53:58 +0100
Message-ID: <20091124160136.219728000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57696 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758151AbZKXQBb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:31 -0500
Content-Disposition: inline; filename=700-zfcp-config-lock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The global config_lock was used to protect the configuration organized
in independent lists. It is not necessary to have a lock on driver
level for this purpose.  This patch replaces the global config_lock
with a set of local list locks.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   80 ++++++++++++++++------------
 drivers/s390/scsi/zfcp_ccw.c   |   23 ++++----
 drivers/s390/scsi/zfcp_def.h   |    9 +--
 drivers/s390/scsi/zfcp_erp.c   |  116 +++++++++++++++++++++--------------------
 drivers/s390/scsi/zfcp_fc.c    |   49 +++++++----------
 drivers/s390/scsi/zfcp_fsf.c   |   22 +++----
 drivers/s390/scsi/zfcp_scsi.c  |   52 ++++++++----------
 drivers/s390/scsi/zfcp_sysfs.c |   48 +++++++---------
 8 files changed, 199 insertions(+), 200 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-11-24 12:36:31.000000000 +0100
@@ -187,7 +187,6 @@ static int __init zfcp_module_init(void)
 		goto out_gid_cache;
 
 	mutex_init(&zfcp_data.config_mutex);
-	rwlock_init(&zfcp_data.config_lock);
 
 	zfcp_data.scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
@@ -238,12 +237,18 @@ module_init(zfcp_module_init);
  */
 struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *port, u64 fcp_lun)
 {
+	unsigned long flags;
 	struct zfcp_unit *unit;
 
-	list_for_each_entry(unit, &port->unit_list_head, list)
+	read_lock_irqsave(&port->unit_list_lock, flags);
+	list_for_each_entry(unit, &port->unit_list, list)
 		if ((unit->fcp_lun == fcp_lun) &&
-		    !(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_REMOVE))
-		    return unit;
+		    !(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_REMOVE)) {
+			zfcp_unit_get(unit);
+			read_unlock_irqrestore(&port->unit_list_lock, flags);
+			return unit;
+		}
+	read_unlock_irqrestore(&port->unit_list_lock, flags);
 	return NULL;
 }
 
@@ -257,12 +262,18 @@ struct zfcp_unit *zfcp_get_unit_by_lun(s
 struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *adapter,
 					u64 wwpn)
 {
+	unsigned long flags;
 	struct zfcp_port *port;
 
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
 		if ((port->wwpn == wwpn) &&
-		    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE))
+		    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE)) {
+			zfcp_port_get(port);
+			read_unlock_irqrestore(&adapter->port_list_lock, flags);
 			return port;
+		}
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 	return NULL;
 }
 
@@ -284,12 +295,11 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 {
 	struct zfcp_unit *unit;
 
-	read_lock_irq(&zfcp_data.config_lock);
-	if (zfcp_get_unit_by_lun(port, fcp_lun)) {
-		read_unlock_irq(&zfcp_data.config_lock);
+	unit = zfcp_get_unit_by_lun(port, fcp_lun);
+	if (unit) {
+		zfcp_unit_put(unit);
 		return ERR_PTR(-EINVAL);
 	}
-	read_unlock_irq(&zfcp_data.config_lock);
 
 	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
 	if (!unit)
@@ -335,13 +345,13 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 
 	zfcp_unit_get(unit);
 
-	write_lock_irq(&zfcp_data.config_lock);
-	list_add_tail(&unit->list, &port->unit_list_head);
+	write_lock_irq(&port->unit_list_lock);
+	list_add_tail(&unit->list, &port->unit_list);
+	write_unlock_irq(&port->unit_list_lock);
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
 
-	write_unlock_irq(&zfcp_data.config_lock);
-
 	zfcp_port_get(port);
 
 	return unit;
@@ -356,11 +366,11 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
  */
 void zfcp_unit_dequeue(struct zfcp_unit *unit)
 {
+	struct zfcp_port *port = unit->port;
+
 	wait_event(unit->remove_wq, atomic_read(&unit->refcount) == 0);
-	write_lock_irq(&zfcp_data.config_lock);
-	list_del(&unit->list);
-	write_unlock_irq(&zfcp_data.config_lock);
-	zfcp_port_put(unit->port);
+	list_del(&unit->list); /* no list locking required */
+	zfcp_port_put(port);
 	sysfs_remove_group(&unit->sysfs_device.kobj, &zfcp_sysfs_unit_attrs);
 	device_unregister(&unit->sysfs_device);
 }
@@ -539,11 +549,13 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (zfcp_fc_gs_setup(adapter))
 		goto generic_services_failed;
 
+	rwlock_init(&adapter->port_list_lock);
+	INIT_LIST_HEAD(&adapter->port_list);
+
 	init_waitqueue_head(&adapter->remove_wq);
 	init_waitqueue_head(&adapter->erp_ready_wq);
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
-	INIT_LIST_HEAD(&adapter->port_list_head);
 	INIT_LIST_HEAD(&adapter->erp_ready_head);
 	INIT_LIST_HEAD(&adapter->erp_running_head);
 
@@ -650,19 +662,20 @@ struct zfcp_port *zfcp_port_enqueue(stru
 {
 	struct zfcp_port *port;
 
-	read_lock_irq(&zfcp_data.config_lock);
-	if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
-		read_unlock_irq(&zfcp_data.config_lock);
-		return ERR_PTR(-EINVAL);
+	port = zfcp_get_port_by_wwpn(adapter, wwpn);
+	if (port) {
+		zfcp_port_put(port);
+		return ERR_PTR(-EEXIST);
 	}
-	read_unlock_irq(&zfcp_data.config_lock);
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
 		return ERR_PTR(-ENOMEM);
 
+	rwlock_init(&port->unit_list_lock);
+	INIT_LIST_HEAD(&port->unit_list);
+
 	init_waitqueue_head(&port->remove_wq);
-	INIT_LIST_HEAD(&port->unit_list_head);
 	INIT_WORK(&port->gid_pn_work, zfcp_fc_port_did_lookup);
 	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
 	INIT_WORK(&port->rport_work, zfcp_scsi_rport_work);
@@ -698,13 +711,13 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	zfcp_port_get(port);
 
-	write_lock_irq(&zfcp_data.config_lock);
-	list_add_tail(&port->list, &adapter->port_list_head);
+	write_lock_irq(&adapter->port_list_lock);
+	list_add_tail(&port->list, &adapter->port_list);
+	write_unlock_irq(&adapter->port_list_lock);
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
 
-	write_unlock_irq(&zfcp_data.config_lock);
-
 	zfcp_adapter_get(adapter);
 	return port;
 }
@@ -715,12 +728,11 @@ struct zfcp_port *zfcp_port_enqueue(stru
  */
 void zfcp_port_dequeue(struct zfcp_port *port)
 {
-	write_lock_irq(&zfcp_data.config_lock);
-	list_del(&port->list);
-	write_unlock_irq(&zfcp_data.config_lock);
+	struct zfcp_adapter *adapter = port->adapter;
+
+	list_del(&port->list); /* no list locking required here */
 	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
-	cancel_work_sync(&port->rport_work); /* usually not necessary */
-	zfcp_adapter_put(port->adapter);
+	zfcp_adapter_put(adapter);
 	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
 }
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-11-24 12:36:31.000000000 +0100
@@ -100,10 +100,11 @@ static void zfcp_ccw_remove(struct ccw_d
 
 	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	if (!adapter)
-		goto out;
 	mutex_unlock(&zfcp_data.config_mutex);
 
+	if (!adapter)
+		return;
+
 	cancel_work_sync(&adapter->scan_work);
 
 	mutex_lock(&zfcp_data.config_mutex);
@@ -111,18 +112,21 @@ static void zfcp_ccw_remove(struct ccw_d
 	/* this also removes the scsi devices, so call it first */
 	zfcp_adapter_scsi_unregister(adapter);
 
-	write_lock_irq(&zfcp_data.config_lock);
-	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
-		list_for_each_entry_safe(unit, u, &port->unit_list_head, list) {
-			list_move(&unit->list, &unit_remove_lh);
+	write_lock_irq(&adapter->port_list_lock);
+	list_for_each_entry_safe(port, p, &adapter->port_list, list) {
+		write_lock(&port->unit_list_lock);
+		list_for_each_entry_safe(unit, u, &port->unit_list, list) {
 			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
 					&unit->status);
+			list_move(&unit->list, &unit_remove_lh);
 		}
-		list_move(&port->list, &port_remove_lh);
+		write_unlock(&port->unit_list_lock);
 		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+		list_move(&port->list, &port_remove_lh);
 	}
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-	write_unlock_irq(&zfcp_data.config_lock);
+	write_unlock_irq(&adapter->port_list_lock);
+	mutex_unlock(&zfcp_data.config_mutex);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
 		list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
@@ -131,9 +135,6 @@ static void zfcp_ccw_remove(struct ccw_d
 	}
 	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
 	zfcp_adapter_dequeue(adapter);
-
-out:
-	mutex_unlock(&zfcp_data.config_mutex);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 12:36:31.000000000 +0100
@@ -461,7 +461,8 @@ struct zfcp_adapter {
         u32			hardware_version;  /* of FCP channel */
 	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
-	struct list_head	port_list_head;	   /* remote port list */
+	struct list_head	port_list;	   /* remote port list */
+	rwlock_t		port_list_lock;    /* port list lock */
 	unsigned long		req_no;		   /* unique FSF req number */
 	struct list_head	*req_list;	   /* list of pending reqs */
 	spinlock_t		req_list_lock;	   /* request list lock */
@@ -504,7 +505,8 @@ struct zfcp_port {
 	wait_queue_head_t      remove_wq;      /* can be used to wait for
 						  refcount drop to zero */
 	struct zfcp_adapter    *adapter;       /* adapter used to access port */
-	struct list_head       unit_list_head; /* head of logical unit list */
+	struct list_head	unit_list;	/* head of logical unit list */
+	rwlock_t		unit_list_lock; /* unit list lock */
 	atomic_t	       status;	       /* status of this remote port */
 	u64		       wwnn;	       /* WWNN if known */
 	u64		       wwpn;	       /* WWPN */
@@ -601,9 +603,6 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-	rwlock_t                config_lock;        /* serialises changes
-						       to adapter/port/unit
-						       lists */
 	struct mutex		config_mutex;
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
--- a/drivers/s390/scsi/zfcp_erp.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-11-24 12:36:31.000000000 +0100
@@ -99,9 +99,12 @@ static void zfcp_erp_action_dismiss_port
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else
-		list_for_each_entry(unit, &port->unit_list_head, list)
-		    zfcp_erp_action_dismiss_unit(unit);
+	else {
+		read_lock(&port->unit_list_lock);
+		list_for_each_entry(unit, &port->unit_list, list)
+			zfcp_erp_action_dismiss_unit(unit);
+		read_unlock(&port->unit_list_lock);
+	}
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
@@ -110,9 +113,12 @@ static void zfcp_erp_action_dismiss_adap
 
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&adapter->erp_action);
-	else
-		list_for_each_entry(port, &adapter->port_list_head, list)
+	else {
+		read_lock(&adapter->port_list_lock);
+		list_for_each_entry(port, &adapter->port_list, list)
 		    zfcp_erp_action_dismiss_port(port);
+		read_unlock(&adapter->port_list_lock);
+	}
 }
 
 static int zfcp_erp_required_act(int want, struct zfcp_adapter *adapter,
@@ -264,11 +270,16 @@ void zfcp_erp_adapter_reopen(struct zfcp
 {
 	unsigned long flags;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
-	_zfcp_erp_adapter_reopen(adapter, clear, id, ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	zfcp_erp_adapter_block(adapter, clear);
+	zfcp_scsi_schedule_rports_block(adapter);
+
+	write_lock_irqsave(&adapter->erp_lock, flags);
+	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+		zfcp_erp_adapter_failed(adapter, "erareo1", NULL);
+	else
+		zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER, adapter,
+					NULL, NULL, id, ref);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 /**
@@ -345,11 +356,9 @@ void zfcp_erp_port_forced_reopen(struct 
 	unsigned long flags;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+	write_lock_irqsave(&adapter->erp_lock, flags);
 	_zfcp_erp_port_forced_reopen(port, clear, id, ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id,
@@ -377,15 +386,13 @@ static int _zfcp_erp_port_reopen(struct 
  */
 int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id, void *ref)
 {
-	unsigned long flags;
 	int retval;
+	unsigned long flags;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+	write_lock_irqsave(&adapter->erp_lock, flags);
 	retval = _zfcp_erp_port_reopen(port, clear, id, ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	return retval;
 }
@@ -424,11 +431,9 @@ void zfcp_erp_unit_reopen(struct zfcp_un
 	struct zfcp_port *port = unit->port;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+	write_lock_irqsave(&adapter->erp_lock, flags);
 	_zfcp_erp_unit_reopen(unit, clear, id, ref);
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 static int status_change_set(unsigned long mask, atomic_t *status)
@@ -540,8 +545,10 @@ static void _zfcp_erp_port_reopen_all(st
 {
 	struct zfcp_port *port;
 
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock(&adapter->port_list_lock);
+	list_for_each_entry(port, &adapter->port_list, list)
 		_zfcp_erp_port_reopen(port, clear, id, ref);
+	read_unlock(&adapter->port_list_lock);
 }
 
 static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear,
@@ -549,8 +556,10 @@ static void _zfcp_erp_unit_reopen_all(st
 {
 	struct zfcp_unit *unit;
 
-	list_for_each_entry(unit, &port->unit_list_head, list)
+	read_lock(&port->unit_list_lock);
+	list_for_each_entry(unit, &port->unit_list, list)
 		_zfcp_erp_unit_reopen(unit, clear, id, ref);
+	read_unlock(&port->unit_list_lock);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -590,16 +599,14 @@ static void zfcp_erp_wakeup(struct zfcp_
 {
 	unsigned long flags;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	read_lock(&adapter->erp_lock);
+	read_lock_irqsave(&adapter->erp_lock, flags);
 	if (list_empty(&adapter->erp_ready_head) &&
 	    list_empty(&adapter->erp_running_head)) {
 			atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING,
 					  &adapter->status);
 			wake_up(&adapter->erp_done_wqh);
 	}
-	read_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	read_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 static int zfcp_erp_adapter_strategy_open_qdio(struct zfcp_erp_action *act)
@@ -1214,11 +1221,10 @@ static int zfcp_erp_strategy_do_action(s
 static int zfcp_erp_strategy(struct zfcp_erp_action *erp_action)
 {
 	int retval;
-	struct zfcp_adapter *adapter = erp_action->adapter;
 	unsigned long flags;
+	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+	write_lock_irqsave(&adapter->erp_lock, flags);
 
 	zfcp_erp_strategy_check_fsfreq(erp_action);
 
@@ -1231,11 +1237,9 @@ static int zfcp_erp_strategy(struct zfcp
 	zfcp_erp_action_to_running(erp_action);
 
 	/* no lock to allow for blocking operations */
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 	retval = zfcp_erp_strategy_do_action(erp_action);
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	write_lock(&adapter->erp_lock);
+	write_lock_irqsave(&adapter->erp_lock, flags);
 
 	if (erp_action->status & ZFCP_STATUS_ERP_DISMISSED)
 		retval = ZFCP_ERP_CONTINUES;
@@ -1273,8 +1277,7 @@ static int zfcp_erp_strategy(struct zfcp
 		zfcp_erp_strategy_followup_failed(erp_action);
 
  unlock:
-	write_unlock(&adapter->erp_lock);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	if (retval != ZFCP_ERP_CONTINUES)
 		zfcp_erp_action_cleanup(erp_action, retval);
@@ -1415,6 +1418,7 @@ void zfcp_erp_modify_adapter_status(stru
 				    void *ref, u32 mask, int set_or_clear)
 {
 	struct zfcp_port *port;
+	unsigned long flags;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
 	if (set_or_clear == ZFCP_SET) {
@@ -1429,10 +1433,13 @@ void zfcp_erp_modify_adapter_status(stru
 			atomic_set(&adapter->erp_counter, 0);
 	}
 
-	if (common_mask)
-		list_for_each_entry(port, &adapter->port_list_head, list)
+	if (common_mask) {
+		read_lock_irqsave(&adapter->port_list_lock, flags);
+		list_for_each_entry(port, &adapter->port_list, list)
 			zfcp_erp_modify_port_status(port, id, ref, common_mask,
 						    set_or_clear);
+		read_unlock_irqrestore(&adapter->port_list_lock, flags);
+	}
 }
 
 /**
@@ -1449,6 +1456,7 @@ void zfcp_erp_modify_port_status(struct 
 				 u32 mask, int set_or_clear)
 {
 	struct zfcp_unit *unit;
+	unsigned long flags;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
 	if (set_or_clear == ZFCP_SET) {
@@ -1463,10 +1471,13 @@ void zfcp_erp_modify_port_status(struct 
 			atomic_set(&port->erp_counter, 0);
 	}
 
-	if (common_mask)
-		list_for_each_entry(unit, &port->unit_list_head, list)
+	if (common_mask) {
+		read_lock_irqsave(&port->unit_list_lock, flags);
+		list_for_each_entry(unit, &port->unit_list, list)
 			zfcp_erp_modify_unit_status(unit, id, ref, common_mask,
 						    set_or_clear);
+		read_unlock_irqrestore(&port->unit_list_lock, flags);
+	}
 }
 
 /**
@@ -1502,12 +1513,8 @@ void zfcp_erp_modify_unit_status(struct 
  */
 void zfcp_erp_port_boxed(struct zfcp_port *port, char *id, void *ref)
 {
-	unsigned long flags;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
@@ -1535,13 +1542,9 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
  */
 void zfcp_erp_port_access_denied(struct zfcp_port *port, char *id, void *ref)
 {
-	unsigned long flags;
-
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED |
 				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
 /**
@@ -1574,12 +1577,15 @@ static void zfcp_erp_port_access_changed
 					 void *ref)
 {
 	struct zfcp_unit *unit;
+	unsigned long flags;
 	int status = atomic_read(&port->status);
 
 	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
-		list_for_each_entry(unit, &port->unit_list_head, list)
+		read_lock_irqsave(&port->unit_list_lock, flags);
+		list_for_each_entry(unit, &port->unit_list, list)
 				    zfcp_erp_unit_access_changed(unit, id, ref);
+		read_unlock_irqrestore(&port->unit_list_lock, flags);
 		return;
 	}
 
@@ -1595,14 +1601,14 @@ static void zfcp_erp_port_access_changed
 void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, char *id,
 				     void *ref)
 {
-	struct zfcp_port *port;
 	unsigned long flags;
+	struct zfcp_port *port;
 
 	if (adapter->connection_features & FSF_FEATURE_NPIV_MODE)
 		return;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
 		zfcp_erp_port_access_changed(port, id, ref);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 12:36:31.000000000 +0100
@@ -145,10 +145,11 @@ static void _zfcp_fc_incoming_rscn(struc
 				   struct fcp_rscn_element *elem)
 {
 	unsigned long flags;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_port *port;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
 		if ((port->d_id & range) == (elem->nport_did & range))
 			zfcp_fc_test_link(port);
 		if (!port->d_id)
@@ -156,8 +157,7 @@ static void _zfcp_fc_incoming_rscn(struc
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
 					     "fcrscn1", NULL);
 	}
-
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
 static void zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req)
@@ -187,18 +187,17 @@ static void zfcp_fc_incoming_rscn(struct
 
 static void zfcp_fc_incoming_wwpn(struct zfcp_fsf_req *req, u64 wwpn)
 {
+	unsigned long flags;
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_port *port;
-	unsigned long flags;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (port->wwpn == wwpn)
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
+		if (port->wwpn == wwpn) {
+			zfcp_erp_port_forced_reopen(port, 0, "fciwwp1", req);
 			break;
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-
-	if (port && (port->wwpn == wwpn))
-		zfcp_erp_port_forced_reopen(port, 0, "fciwwp1", req);
+		}
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
 static void zfcp_fc_incoming_plogi(struct zfcp_fsf_req *req)
@@ -579,20 +578,17 @@ static int zfcp_fc_send_gpn_ft(struct zf
 
 static void zfcp_fc_validate_port(struct zfcp_port *port)
 {
-	struct zfcp_adapter *adapter = port->adapter;
-
 	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC))
 		return;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
 	if ((port->supported_classes != 0) ||
-	    !list_empty(&port->unit_list_head)) {
+	    !list_empty(&port->unit_list)) {
 		zfcp_port_put(port);
 		return;
 	}
 	zfcp_erp_port_shutdown(port, 0, "fcpval1", NULL);
-	zfcp_erp_wait(adapter);
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
 }
@@ -605,6 +601,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	struct gpn_ft_resp_acc *acc = sg_virt(sg);
 	struct zfcp_adapter *adapter = ct->wka_port->adapter;
 	struct zfcp_port *port, *tmp;
+	unsigned long flags;
 	u32 d_id;
 	int ret = 0, x, last = 0;
 
@@ -643,21 +640,20 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 		/* skip the adapter's port and known remote ports */
 		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
-		port = zfcp_get_port_by_wwpn(adapter, acc->wwpn);
-		if (port)
-			continue;
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
-		if (IS_ERR(port))
-			ret = PTR_ERR(port);
-		else
+		if (!IS_ERR(port))
 			zfcp_erp_port_reopen(port, 0, "fcegpf1", NULL);
+		else if (PTR_ERR(port) != -EEXIST)
+			ret = PTR_ERR(port);
 	}
 
 	zfcp_erp_wait(adapter);
-	list_for_each_entry_safe(port, tmp, &adapter->port_list_head, list)
+	write_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry_safe(port, tmp, &adapter->port_list, list)
 		zfcp_fc_validate_port(port);
+	write_unlock_irqrestore(&adapter->port_list_lock, flags);
 	mutex_unlock(&zfcp_data.config_mutex);
 	return ret;
 }
@@ -760,15 +756,14 @@ int zfcp_fc_execute_els_fc_job(struct fc
 
 	els_fc_job->els.adapter = adapter;
 	if (rport) {
-		read_lock_irq(&zfcp_data.config_lock);
 		port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
-		if (port)
-			els_fc_job->els.d_id = port->d_id;
-		read_unlock_irq(&zfcp_data.config_lock);
 		if (!port) {
 			kfree(els_fc_job);
 			return -EINVAL;
 		}
+
+		els_fc_job->els.d_id = port->d_id;
+		zfcp_port_put(port);
 	} else {
 		port_did = job->request->rqst_data.h_els.port_id;
 		els_fc_job->els.d_id = (port_did[0] << 16) +
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 12:36:31.000000000 +0100
@@ -122,36 +122,32 @@ void zfcp_fsf_req_free(struct zfcp_fsf_r
 
 static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
 {
+	unsigned long flags;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_port *port;
 	int d_id = sr_buf->d_id & ZFCP_DID_MASK;
-	unsigned long flags;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
 		if (port->d_id == d_id) {
-			read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 			zfcp_erp_port_reopen(port, 0, "fssrpc1", req);
-			return;
+			break;
 		}
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
 static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, char *id,
 					 struct fsf_link_down_info *link_down)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	unsigned long flags;
 
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED)
 		return;
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	zfcp_scsi_schedule_rports_block(adapter);
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	if (!link_down)
 		goto out;
@@ -1765,9 +1761,11 @@ static void zfcp_fsf_close_physical_port
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		list_for_each_entry(unit, &port->unit_list_head, list)
+		read_lock(&port->unit_list_lock);
+		list_for_each_entry(unit, &port->unit_list, list)
 			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 					  &unit->status);
+		read_unlock(&port->unit_list_lock);
 		zfcp_erp_port_boxed(port, "fscpph2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
@@ -1787,9 +1785,11 @@ static void zfcp_fsf_close_physical_port
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port
 		 */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		list_for_each_entry(unit, &port->unit_list_head, list)
+		read_lock(&port->unit_list_lock);
+		list_for_each_entry(unit, &port->unit_list, list)
 			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
 					  &unit->status);
+		read_unlock(&port->unit_list_lock);
 		break;
 	}
 }
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:31.000000000 +0100
@@ -128,49 +128,44 @@ static int zfcp_scsi_queuecommand(struct
 }
 
 static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *adapter,
-					  int channel, unsigned int id,
-					  unsigned int lun)
+					  unsigned int id, u64 lun)
 {
+	unsigned long flags;
 	struct zfcp_port *port;
-	struct zfcp_unit *unit;
-	int scsi_lun;
+	struct zfcp_unit *unit = NULL;
 
-	list_for_each_entry(port, &adapter->port_list_head, list) {
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
 		if (!port->rport || (id != port->rport->scsi_target_id))
 			continue;
-		list_for_each_entry(unit, &port->unit_list_head, list) {
-			scsi_lun = scsilun_to_int(
-				(struct scsi_lun *)&unit->fcp_lun);
-			if (lun == scsi_lun)
-				return unit;
-		}
+		unit = zfcp_get_unit_by_lun(port, lun);
+		if (unit)
+			break;
 	}
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
-	return NULL;
+	return unit;
 }
 
 static int zfcp_scsi_slave_alloc(struct scsi_device *sdp)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_unit *unit;
-	unsigned long flags;
-	int retval = -ENXIO;
+	u64 lun;
 
 	adapter = (struct zfcp_adapter *) sdp->host->hostdata[0];
 	if (!adapter)
 		goto out;
 
-	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	unit = zfcp_unit_lookup(adapter, sdp->channel, sdp->id, sdp->lun);
+	int_to_scsilun(sdp->lun, (struct scsi_lun *)&lun);
+	unit = zfcp_unit_lookup(adapter, sdp->id, lun);
 	if (unit) {
 		sdp->hostdata = unit;
 		unit->device = sdp;
-		zfcp_unit_get(unit);
-		retval = 0;
+		return 0;
 	}
-	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 out:
-	return retval;
+	return -ENXIO;
 }
 
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
@@ -338,12 +333,12 @@ void zfcp_adapter_scsi_unregister(struct
 	if (!shost)
 		return;
 
-	read_lock_irq(&zfcp_data.config_lock);
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock_irq(&adapter->port_list_lock);
+	list_for_each_entry(port, &adapter->port_list, list)
 		if (port->rport)
 			port->rport = NULL;
+	read_unlock_irq(&adapter->port_list_lock);
 
-	read_unlock_irq(&zfcp_data.config_lock);
 	fc_remove_host(shost);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
@@ -508,7 +503,7 @@ static void zfcp_set_rport_dev_loss_tmo(
  * @rport: The FC rport where to teminate I/O
  *
  * Abort all pending SCSI commands for a port by closing the
- * port. Using a reopen for avoids a conflict with a shutdown
+ * port. Using a reopen avoiding a conflict with a shutdown
  * overwriting a reopen.
  */
 static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
@@ -518,11 +513,7 @@ static void zfcp_scsi_terminate_rport_io
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *)shost->hostdata[0];
 
-	write_lock_irq(&zfcp_data.config_lock);
 	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
-	if (port)
-		zfcp_port_get(port);
-	write_unlock_irq(&zfcp_data.config_lock);
 
 	if (port) {
 		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
@@ -589,10 +580,13 @@ void zfcp_scsi_schedule_rport_block(stru
 
 void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *adapter)
 {
+	unsigned long flags;
 	struct zfcp_port *port;
 
-	list_for_each_entry(port, &adapter->port_list_head, list)
+	read_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list)
 		zfcp_scsi_schedule_rport_block(port);
+	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
 
 void zfcp_scsi_rport_work(struct work_struct *work)
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-11-24 12:36:27.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-11-24 12:36:31.000000000 +0100
@@ -153,15 +153,14 @@ static ssize_t zfcp_sysfs_port_remove_st
 		goto out;
 	}
 
-	write_lock_irq(&zfcp_data.config_lock);
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
-	if (port && (atomic_read(&port->refcount) == 0)) {
-		zfcp_port_get(port);
+	if (port && (atomic_read(&port->refcount) == 1)) {
 		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+		write_lock_irq(&adapter->port_list_lock);
 		list_move(&port->list, &port_remove_lh);
+		write_unlock_irq(&adapter->port_list_lock);
 	} else
 		port = NULL;
-	write_unlock_irq(&zfcp_data.config_lock);
 
 	if (!port) {
 		retval = -ENXIO;
@@ -253,35 +252,28 @@ static ssize_t zfcp_sysfs_unit_remove_st
 		goto out;
 	}
 
-	write_lock_irq(&zfcp_data.config_lock);
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	if (unit) {
-		write_unlock_irq(&zfcp_data.config_lock);
-		/* wait for possible timeout during SCSI probe */
-		flush_work(&unit->scsi_work);
-		write_lock_irq(&zfcp_data.config_lock);
-
-		if (atomic_read(&unit->refcount) == 0) {
-			zfcp_unit_get(unit);
-			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
-					&unit->status);
-			list_move(&unit->list, &unit_remove_lh);
-		} else {
-			unit = NULL;
-		}
-	}
-
-	write_unlock_irq(&zfcp_data.config_lock);
-
 	if (!unit) {
-		retval = -ENXIO;
+		retval = -EINVAL;
 		goto out;
 	}
 
-	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
-	zfcp_erp_wait(unit->port->adapter);
-	zfcp_unit_put(unit);
-	zfcp_unit_dequeue(unit);
+	/* wait for possible timeout during SCSI probe */
+	flush_work(&unit->scsi_work);
+
+	if (atomic_read(&unit->refcount) == 1) {
+		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
+
+		write_lock_irq(&port->unit_list_lock);
+		list_move(&unit->list, &unit_remove_lh);
+		write_unlock_irq(&port->unit_list_lock);
+
+		zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
+		zfcp_erp_wait(unit->port->adapter);
+		zfcp_unit_put(unit);
+		zfcp_unit_dequeue(unit);
+	} else
+		zfcp_unit_put(unit);
 out:
 	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;

