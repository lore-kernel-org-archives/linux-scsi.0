From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/13] zfcp: Simplify zfcp data structures
Date: Wed, 01 Oct 2008 12:42:20 +0200
Message-ID: <20081001104801.390702000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:34226 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468AbYJAKsJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:09 -0400
Content-Disposition: inline; filename=zfcp_def-remove-unused.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Reduce the size of zfcp data structures by removing unused and
redundant members. scsi_lun is only the mangled version of the
fcp_lun. So, remove the redundant field and use the fcp_lun instead.

Since the queue lock and the pci_batch indicator are only used in the
request queue, move them from the common queue struct to the adapter
struct.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |   34 ---------------
 drivers/s390/scsi/zfcp_ccw.c   |   10 ++--
 drivers/s390/scsi/zfcp_def.h   |   26 ++---------
 drivers/s390/scsi/zfcp_erp.c   |    2 
 drivers/s390/scsi/zfcp_fc.c    |    3 -
 drivers/s390/scsi/zfcp_fsf.c   |   89 ++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_qdio.c  |   12 ++---
 drivers/s390/scsi/zfcp_scsi.c  |    8 ++-
 drivers/s390/scsi/zfcp_sysfs.c |    6 +-
 9 files changed, 77 insertions(+), 113 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-10-01 11:08:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-10-01 11:09:06.000000000 +0200
@@ -169,8 +169,6 @@ static int __init zfcp_module_init(void)
 		goto out_gid_cache;
 
 	INIT_LIST_HEAD(&zfcp_data.adapter_list_head);
-	INIT_LIST_HEAD(&zfcp_data.adapter_remove_lh);
-
 	sema_init(&zfcp_data.config_sema, 1);
 	rwlock_init(&zfcp_data.config_lock);
 
@@ -312,7 +310,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	}
 
 	zfcp_unit_get(unit);
-	unit->scsi_lun = scsilun_to_int((struct scsi_lun *)&unit->fcp_lun);
 
 	write_lock_irq(&zfcp_data.config_lock);
 	list_add_tail(&unit->list, &port->unit_list_head);
@@ -321,7 +318,6 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 
 	write_unlock_irq(&zfcp_data.config_lock);
 
-	port->units++;
 	zfcp_port_get(port);
 
 	return unit;
@@ -344,7 +340,6 @@ void zfcp_unit_dequeue(struct zfcp_unit 
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&unit->list);
 	write_unlock_irq(&zfcp_data.config_lock);
-	unit->port->units--;
 	zfcp_port_put(unit->port);
 	sysfs_remove_group(&unit->sysfs_device.kobj, &zfcp_sysfs_unit_attrs);
 	device_unregister(&unit->sysfs_device);
@@ -405,11 +400,6 @@ static void zfcp_free_low_mem_buffers(st
 		mempool_destroy(adapter->pool.data_gid_pn);
 }
 
-static void zfcp_dummy_release(struct device *dev)
-{
-	return;
-}
-
 /**
  * zfcp_status_read_refill - refill the long running status_read_requests
  * @adapter: ptr to struct zfcp_adapter for which the buffers should be refilled
@@ -484,7 +474,6 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	init_waitqueue_head(&adapter->erp_done_wqh);
 
 	INIT_LIST_HEAD(&adapter->port_list_head);
-	INIT_LIST_HEAD(&adapter->port_remove_lh);
 	INIT_LIST_HEAD(&adapter->erp_ready_head);
 	INIT_LIST_HEAD(&adapter->erp_running_head);
 
@@ -494,7 +483,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	spin_lock_init(&adapter->san_dbf_lock);
 	spin_lock_init(&adapter->scsi_dbf_lock);
 	spin_lock_init(&adapter->rec_dbf_lock);
-	spin_lock_init(&adapter->req_q.lock);
+	spin_lock_init(&adapter->req_q_lock);
 
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
@@ -513,28 +502,15 @@ int zfcp_adapter_enqueue(struct ccw_devi
 			       &zfcp_sysfs_adapter_attrs))
 		goto sysfs_failed;
 
-	adapter->generic_services.parent = &adapter->ccw_device->dev;
-	adapter->generic_services.release = zfcp_dummy_release;
-	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
-		 "generic_services");
-
-	if (device_register(&adapter->generic_services))
-		goto generic_services_failed;
-
 	write_lock_irq(&zfcp_data.config_lock);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 	list_add_tail(&adapter->list, &zfcp_data.adapter_list_head);
 	write_unlock_irq(&zfcp_data.config_lock);
 
-	zfcp_data.adapters++;
-
 	zfcp_fc_nameserver_init(adapter);
 
 	return 0;
 
-generic_services_failed:
-	sysfs_remove_group(&ccw_device->dev.kobj,
-			   &zfcp_sysfs_adapter_attrs);
 sysfs_failed:
 	zfcp_adapter_debug_unregister(adapter);
 debug_register_failed:
@@ -561,7 +537,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
 	zfcp_adapter_scsi_unregister(adapter);
-	device_unregister(&adapter->generic_services);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
@@ -579,9 +554,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	list_del(&adapter->list);
 	write_unlock_irq(&zfcp_data.config_lock);
 
-	/* decrease number of adapters in list */
-	zfcp_data.adapters--;
-
 	zfcp_qdio_free(adapter);
 
 	zfcp_free_low_mem_buffers(adapter);
@@ -620,9 +592,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 		return ERR_PTR(-ENOMEM);
 
 	init_waitqueue_head(&port->remove_wq);
-
 	INIT_LIST_HEAD(&port->unit_list_head);
-	INIT_LIST_HEAD(&port->unit_remove_lh);
 	INIT_WORK(&port->gid_pn_work, zfcp_erp_port_strategy_open_lookup);
 
 	port->adapter = adapter;
@@ -665,7 +635,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	list_add_tail(&port->list, &adapter->port_list_head);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
-	adapter->ports++;
 
 	write_unlock_irq(&zfcp_data.config_lock);
 
@@ -687,7 +656,6 @@ void zfcp_port_dequeue(struct zfcp_port 
 	wait_event(port->remove_wq, atomic_read(&port->refcount) == 0);
 	write_lock_irq(&zfcp_data.config_lock);
 	list_del(&port->list);
-	port->adapter->ports--;
 	write_unlock_irq(&zfcp_data.config_lock);
 	if (port->rport)
 		fc_remote_port_delete(port->rport);
--- a/drivers/s390/scsi/zfcp_def.h	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-10-01 11:09:06.000000000 +0200
@@ -412,14 +412,9 @@ struct zfcp_wka_port {
 };
 
 struct zfcp_qdio_queue {
-	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q]; /* SBALs */
-	u8		   first;	      /* index of next free bfr
-						 in queue (free_count>0) */
-	atomic_t           count;	      /* number of free buffers
-						 in queue */
-	spinlock_t	   lock;	      /* lock for operations on queue */
-	int                pci_batch;	      /* SBALs since PCI indication
-						 was last set */
+	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
+	u8		   first;	/* index of next free bfr in queue */
+	atomic_t           count;	/* number of free buffers in queue */
 };
 
 struct zfcp_erp_action {
@@ -471,13 +466,13 @@ struct zfcp_adapter {
 	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list_head;	   /* remote port list */
-	struct list_head        port_remove_lh;    /* head of ports to be
-						      removed */
-	u32			ports;	           /* number of remote ports */
 	unsigned long		req_no;		   /* unique FSF req number */
 	struct list_head	*req_list;	   /* list of pending reqs */
 	spinlock_t		req_list_lock;	   /* request list lock */
 	struct zfcp_qdio_queue	req_q;		   /* request queue */
+	spinlock_t		req_q_lock;	   /* for operations on queue */
+	int			req_q_pci_batch;   /* SBALs since PCI indication
+						      was last set */
 	u32			fsf_req_seq_no;	   /* FSF cmnd seq number */
 	wait_queue_head_t	request_wq;	   /* can be used to wait for
 						      more avaliable SBALs */
@@ -516,7 +511,6 @@ struct zfcp_adapter {
 	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
-	struct device           generic_services;  /* directory for WKA ports */
 	struct fc_host_statistics *fc_stats;
 	struct fsf_qtcb_bottom_port *stats_reset_data;
 	unsigned long		stats_reset;
@@ -533,9 +527,6 @@ struct zfcp_port {
 						  refcount drop to zero */
 	struct zfcp_adapter    *adapter;       /* adapter used to access port */
 	struct list_head       unit_list_head; /* head of logical unit list */
-	struct list_head       unit_remove_lh; /* head of luns to be removed
-						  list */
-	u32		       units;	       /* # of logical units in list */
 	atomic_t	       status;	       /* status of this remote port */
 	u64		       wwnn;	       /* WWNN if known */
 	u64		       wwpn;	       /* WWPN */
@@ -556,7 +547,6 @@ struct zfcp_unit {
 						  refcount drop to zero */
 	struct zfcp_port       *port;	       /* remote port of unit */
 	atomic_t	       status;	       /* status of this logical unit */
-	unsigned int	       scsi_lun;       /* own SCSI LUN */
 	u64		       fcp_lun;	       /* own FCP_LUN */
 	u32		       handle;	       /* handle assigned by FSF */
         struct scsi_device     *device;        /* scsi device struct pointer */
@@ -599,11 +589,7 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-        atomic_t                status;             /* Module status flags */
 	struct list_head	adapter_list_head;  /* head of adapter list */
-	struct list_head	adapter_remove_lh;  /* head of adapters to be
-						       removed */
-	u32			adapters;	    /* # of adapters in list */
 	rwlock_t                config_lock;        /* serialises changes
 						       to adapter/port/unit
 						       lists */
--- a/drivers/s390/scsi/zfcp_erp.c	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-10-01 11:09:06.000000000 +0200
@@ -1186,7 +1186,7 @@ static void zfcp_erp_scsi_scan(struct wo
 	struct zfcp_unit *unit = p->unit;
 	struct fc_rport *rport = unit->port->rport;
 	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-			 unit->scsi_lun, 0);
+			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
 	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	zfcp_unit_put(unit);
 	kfree(p);
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-10-01 11:09:06.000000000 +0200
@@ -105,13 +105,17 @@ static struct zfcp_unit *zfcp_unit_looku
 {
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
+	int scsi_lun;
 
 	list_for_each_entry(port, &adapter->port_list_head, list) {
 		if (!port->rport || (id != port->rport->scsi_target_id))
 			continue;
-		list_for_each_entry(unit, &port->unit_list_head, list)
-			if (lun == unit->scsi_lun)
+		list_for_each_entry(unit, &port->unit_list_head, list) {
+			scsi_lun = scsilun_to_int(
+				(struct scsi_lun *)&unit->fcp_lun);
+			if (lun == scsi_lun)
 				return unit;
+		}
 	}
 
 	return NULL;
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-10-01 11:08:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-10-01 11:09:06.000000000 +0200
@@ -47,6 +47,8 @@ static void zfcp_ccw_remove(struct ccw_d
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port, *p;
 	struct zfcp_unit *unit, *u;
+	LIST_HEAD(unit_remove_lh);
+	LIST_HEAD(port_remove_lh);
 
 	ccw_device_set_offline(ccw_device);
 	down(&zfcp_data.config_sema);
@@ -55,18 +57,18 @@ static void zfcp_ccw_remove(struct ccw_d
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
 		list_for_each_entry_safe(unit, u, &port->unit_list_head, list) {
-			list_move(&unit->list, &port->unit_remove_lh);
+			list_move(&unit->list, &unit_remove_lh);
 			atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE,
 					&unit->status);
 		}
-		list_move(&port->list, &adapter->port_remove_lh);
+		list_move(&port->list, &port_remove_lh);
 		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	}
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 	write_unlock_irq(&zfcp_data.config_lock);
 
-	list_for_each_entry_safe(port, p, &adapter->port_remove_lh, list) {
-		list_for_each_entry_safe(unit, u, &port->unit_remove_lh, list) {
+	list_for_each_entry_safe(port, p, &port_remove_lh, list) {
+		list_for_each_entry_safe(unit, u, &unit_remove_lh, list) {
 			if (atomic_read(&unit->status) &
 			    ZFCP_STATUS_UNIT_REGISTERED)
 				scsi_remove_device(unit->device);
--- a/drivers/s390/scsi/zfcp_fc.c	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-10-01 11:09:06.000000000 +0200
@@ -526,7 +526,8 @@ static void zfcp_validate_port(struct zf
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
-	if ((port->supported_classes != 0) || (port->units != 0)) {
+	if ((port->supported_classes != 0) ||
+	    !list_empty(&port->unit_list_head)) {
 		zfcp_port_put(port);
 		return;
 	}
--- a/drivers/s390/scsi/zfcp_sysfs.c	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2008-10-01 11:09:06.000000000 +0200
@@ -137,6 +137,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	struct zfcp_port *port;
 	u64 wwpn;
 	int retval = 0;
+	LIST_HEAD(port_remove_lh);
 
 	down(&zfcp_data.config_sema);
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
@@ -154,7 +155,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	if (port && (atomic_read(&port->refcount) == 0)) {
 		zfcp_port_get(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
-		list_move(&port->list, &adapter->port_remove_lh);
+		list_move(&port->list, &port_remove_lh);
 	} else
 		port = NULL;
 	write_unlock_irq(&zfcp_data.config_lock);
@@ -235,6 +236,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = 0;
+	LIST_HEAD(unit_remove_lh);
 
 	down(&zfcp_data.config_sema);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
@@ -252,7 +254,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	if (unit && (atomic_read(&unit->refcount) == 0)) {
 		zfcp_unit_get(unit);
 		atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
-		list_move(&unit->list, &port->unit_remove_lh);
+		list_move(&unit->list, &unit_remove_lh);
 	} else
 		unit = NULL;
 
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:08:27.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-10-01 11:09:06.000000000 +0200
@@ -639,12 +639,14 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_sbal_check(struct zfcp_qdio_queue *queue)
+static int zfcp_fsf_sbal_check(struct zfcp_adapter *adapter)
 {
-	spin_lock_bh(&queue->lock);
-	if (atomic_read(&queue->count))
+	struct zfcp_qdio_queue *req_q = &adapter->req_q;
+
+	spin_lock_bh(&adapter->req_q_lock);
+	if (atomic_read(&req_q->count))
 		return 1;
-	spin_unlock_bh(&queue->lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return 0;
 }
 
@@ -659,17 +661,16 @@ static int zfcp_fsf_sbal_available(struc
 static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
 {
 	long ret;
-	struct zfcp_qdio_queue *req_q = &adapter->req_q;
 
-	spin_unlock_bh(&req_q->lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	ret = wait_event_interruptible_timeout(adapter->request_wq,
-					zfcp_fsf_sbal_check(req_q), 5 * HZ);
+					zfcp_fsf_sbal_check(adapter), 5 * HZ);
 	if (ret > 0)
 		return 0;
 	if (!ret)
 		atomic_inc(&adapter->qdio_outb_full);
 
-	spin_lock_bh(&req_q->lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	return -EIO;
 }
 
@@ -811,7 +812,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	struct qdio_buffer_element *sbale;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -851,7 +852,7 @@ failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -924,7 +925,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	struct qdio_buffer_element *sbale;
 	struct zfcp_fsf_req *req = NULL;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
@@ -954,7 +955,7 @@ out_error_free:
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock(&adapter->req_q_lock);
 	return req;
 }
 
@@ -1043,7 +1044,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1085,7 +1086,7 @@ failed_send:
 	if (erp_action)
 		erp_action->fsf_req = NULL;
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return ret;
 }
 
@@ -1155,7 +1156,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
@@ -1189,7 +1190,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 failed_send:
 	zfcp_fsf_req_free(req);
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock(&adapter->req_q_lock);
 	return ret;
 }
 
@@ -1200,7 +1201,7 @@ int zfcp_fsf_exchange_config_data(struct
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter,
@@ -1232,7 +1233,7 @@ int zfcp_fsf_exchange_config_data(struct
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1243,7 +1244,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1271,7 +1272,7 @@ int zfcp_fsf_exchange_config_data_sync(s
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1296,7 +1297,7 @@ int zfcp_fsf_exchange_port_data(struct z
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
@@ -1322,7 +1323,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1342,7 +1343,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	if (!(adapter->adapter_features & FSF_FEATURE_HBAAPI_MANAGEMENT))
 		return -EOPNOTSUPP;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 
@@ -1364,7 +1365,7 @@ int zfcp_fsf_exchange_port_data_sync(str
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	if (!retval)
 		wait_event(req->completion_wq,
 			   req->status & ZFCP_STATUS_FSFREQ_COMPLETED);
@@ -1462,7 +1463,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1492,7 +1493,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1530,7 +1531,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1559,7 +1560,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1603,7 +1604,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1629,7 +1630,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1658,7 +1659,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1683,7 +1684,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 	if (retval)
 		zfcp_fsf_req_free(req);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1750,7 +1751,7 @@ int zfcp_fsf_close_physical_port(struct 
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1781,7 +1782,7 @@ int zfcp_fsf_close_physical_port(struct 
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -1924,7 +1925,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -1957,7 +1958,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -2010,7 +2011,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
@@ -2039,7 +2040,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 		erp_action->fsf_req = NULL;
 	}
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -2281,7 +2282,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
@@ -2380,7 +2381,7 @@ failed_scsi_cmnd:
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock(&adapter->req_q_lock);
 	return retval;
 }
 
@@ -2404,7 +2405,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
-	spin_lock(&adapter->req_q.lock);
+	spin_lock(&adapter->req_q_lock);
 	if (!zfcp_fsf_sbal_available(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, req_flags,
@@ -2437,7 +2438,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	zfcp_fsf_req_free(req);
 	req = NULL;
 out:
-	spin_unlock(&adapter->req_q.lock);
+	spin_unlock(&adapter->req_q_lock);
 	return req;
 }
 
@@ -2475,7 +2476,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 		return ERR_PTR(-EINVAL);
 	}
 
-	spin_lock_bh(&adapter->req_q.lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
@@ -2505,7 +2506,7 @@ struct zfcp_fsf_req *zfcp_fsf_control_fi
 	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
 	retval = zfcp_fsf_req_send(req);
 out:
-	spin_unlock_bh(&adapter->req_q.lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 
 	if (!retval) {
 		wait_event(req->completion_wq,
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-10-01 11:07:47.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-10-01 11:09:06.000000000 +0200
@@ -346,7 +346,7 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 	struct qdio_buffer_element *sbale;
 
 	/* acknowledgements for transferred buffers */
-	pci_batch = req_q->pci_batch + count;
+	pci_batch = adapter->req_q_pci_batch + count;
 	if (unlikely(pci_batch >= ZFCP_QDIO_PCI_INTERVAL)) {
 		pci_batch %= ZFCP_QDIO_PCI_INTERVAL;
 		pci = first + count - (pci_batch + 1);
@@ -366,7 +366,7 @@ int zfcp_qdio_send(struct zfcp_fsf_req *
 	atomic_sub(count, &req_q->count);
 	req_q->first += count;
 	req_q->first %= QDIO_MAX_BUFFERS_PER_Q;
-	req_q->pci_batch = pci_batch;
+	adapter->req_q_pci_batch = pci_batch;
 	return 0;
 }
 
@@ -422,9 +422,9 @@ void zfcp_qdio_close(struct zfcp_adapter
 
 	/* clear QDIOUP flag, thus do_QDIO is not called during qdio_shutdown */
 	req_q = &adapter->req_q;
-	spin_lock_bh(&req_q->lock);
+	spin_lock_bh(&adapter->req_q_lock);
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_QDIOUP, &adapter->status);
-	spin_unlock_bh(&req_q->lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 
 	qdio_shutdown(adapter->ccw_device, QDIO_FLAG_CLEANUP_USING_CLEAR);
 
@@ -437,7 +437,7 @@ void zfcp_qdio_close(struct zfcp_adapter
 	}
 	req_q->first = 0;
 	atomic_set(&req_q->count, 0);
-	req_q->pci_batch = 0;
+	adapter->req_q_pci_batch = 0;
 	adapter->resp_q.first = 0;
 	atomic_set(&adapter->resp_q.count, 0);
 }
@@ -475,7 +475,7 @@ int zfcp_qdio_open(struct zfcp_adapter *
 	/* set index of first avalable SBALS / number of available SBALS */
 	adapter->req_q.first = 0;
 	atomic_set(&adapter->req_q.count, QDIO_MAX_BUFFERS_PER_Q);
-	adapter->req_q.pci_batch = 0;
+	adapter->req_q_pci_batch = 0;
 
 	return 0;
 

-- 
