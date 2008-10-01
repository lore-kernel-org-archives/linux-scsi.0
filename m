From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/13] zfcp: attach and release SAN nameserver port on demand
Date: Wed, 01 Oct 2008 12:42:17 +0200
Message-ID: <20081001104759.273535000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:54871 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYJAKsk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:40 -0400
Content-Disposition: inline; filename=zfcp_nameserver.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Changing the zfcp behaviour from always having the nameserver port
open to an on-demand strategy.  This strategy reduces the use of
limited resources like port connections. The patch provides a common
infrastructure which could be used for all WKA ports in future.

Also reduce the number of nameserver lookups by changing the zfcp
behaviour of always querying the nameserver for the corresponding
destination ID of the remote port.  If the destination ID has changed
during the reopen process we will be informed and then trigger a
nameserver query on demand.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |   65 +-----------
 drivers/s390/scsi/zfcp_dbf.c   |   14 +-
 drivers/s390/scsi/zfcp_def.h   |   31 ++++-
 drivers/s390/scsi/zfcp_erp.c   |  149 +++++++---------------------
 drivers/s390/scsi/zfcp_ext.h   |    7 -
 drivers/s390/scsi/zfcp_fc.c    |  215 ++++++++++++++++++++++++++++-------------
 drivers/s390/scsi/zfcp_fsf.c   |  137 ++++++++++++++++++++++++--
 drivers/s390/scsi/zfcp_sysfs.c |   19 ---
 8 files changed, 362 insertions(+), 275 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-09-30 16:42:52.000000000 +0200
@@ -450,19 +450,6 @@ static void _zfcp_status_read_scheduler(
 					     stat_work));
 }
 
-static int zfcp_nameserver_enqueue(struct zfcp_adapter *adapter)
-{
-	struct zfcp_port *port;
-
-	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
-				 ZFCP_DID_DIRECTORY_SERVICE);
-	if (IS_ERR(port))
-		return PTR_ERR(port);
-	zfcp_port_put(port);
-
-	return 0;
-}
-
 /**
  * zfcp_adapter_enqueue - enqueue a new adapter to the list
  * @ccw_device: pointer to the struct cc_device
@@ -552,7 +539,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	zfcp_data.adapters++;
 
-	zfcp_nameserver_enqueue(adapter);
+	zfcp_fc_nameserver_init(adapter);
 
 	return 0;
 
@@ -638,7 +625,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 {
 	struct zfcp_port *port;
 	int retval;
-	char *bus_id;
 
 	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
@@ -648,6 +634,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	INIT_LIST_HEAD(&port->unit_list_head);
 	INIT_LIST_HEAD(&port->unit_remove_lh);
+	INIT_WORK(&port->gid_pn_work, zfcp_erp_port_strategy_open_lookup);
 
 	port->adapter = adapter;
 	port->d_id = d_id;
@@ -657,34 +644,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set(&port->refcount, 0);
 
-	if (status & ZFCP_STATUS_PORT_WKA) {
-		switch (d_id) {
-		case ZFCP_DID_DIRECTORY_SERVICE:
-			bus_id = "directory";
-			break;
-		case ZFCP_DID_MANAGEMENT_SERVICE:
-			bus_id = "management";
-			break;
-		case ZFCP_DID_KEY_DISTRIBUTION_SERVICE:
-			bus_id = "key_distribution";
-			break;
-		case ZFCP_DID_ALIAS_SERVICE:
-			bus_id = "alias";
-			break;
-		case ZFCP_DID_TIME_SERVICE:
-			bus_id = "time";
-			break;
-		default:
-			kfree(port);
-			return ERR_PTR(-EINVAL);
-		}
-		snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE, "%s", bus_id);
-		port->sysfs_device.parent = &adapter->generic_services;
-	} else {
-		snprintf(port->sysfs_device.bus_id,
-			 BUS_ID_SIZE, "0x%016llx", wwpn);
-		port->sysfs_device.parent = &adapter->ccw_device->dev;
-	}
+	snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx", wwpn);
+	port->sysfs_device.parent = &adapter->ccw_device->dev;
 
 	port->sysfs_device.release = zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
@@ -700,12 +661,8 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	if (device_register(&port->sysfs_device))
 		goto err_out_free;
 
-	if (status & ZFCP_STATUS_PORT_WKA)
-		retval = sysfs_create_group(&port->sysfs_device.kobj,
-					    &zfcp_sysfs_ns_port_attrs);
-	else
-		retval = sysfs_create_group(&port->sysfs_device.kobj,
-					    &zfcp_sysfs_port_attrs);
+	retval = sysfs_create_group(&port->sysfs_device.kobj,
+				    &zfcp_sysfs_port_attrs);
 
 	if (retval) {
 		device_unregister(&port->sysfs_device);
@@ -718,9 +675,6 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	list_add_tail(&port->list, &adapter->port_list_head);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &port->status);
-	if (d_id == ZFCP_DID_DIRECTORY_SERVICE)
-		if (!adapter->nameserver_port)
-			adapter->nameserver_port = port;
 	adapter->ports++;
 
 	write_unlock_irq(&zfcp_data.config_lock);
@@ -749,12 +703,7 @@ void zfcp_port_dequeue(struct zfcp_port 
 		fc_remote_port_delete(port->rport);
 	port->rport = NULL;
 	zfcp_adapter_put(port->adapter);
-	if (atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA)
-		sysfs_remove_group(&port->sysfs_device.kobj,
-				   &zfcp_sysfs_ns_port_attrs);
-	else
-		sysfs_remove_group(&port->sysfs_device.kobj,
-				   &zfcp_sysfs_port_attrs);
+	sysfs_remove_group(&port->sysfs_device.kobj, &zfcp_sysfs_port_attrs);
 	device_unregister(&port->sysfs_device);
 }
 
--- a/drivers/s390/scsi/zfcp_def.h	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-09-30 16:43:36.000000000 +0200
@@ -253,6 +253,7 @@ struct zfcp_ls_adisc {
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 
 /* FC-PH/FC-GS well-known address identifiers for generic services */
+#define ZFCP_DID_WKA				0xFFFFF0
 #define ZFCP_DID_MANAGEMENT_SERVICE		0xFFFFFA
 #define ZFCP_DID_TIME_SERVICE			0xFFFFFB
 #define ZFCP_DID_DIRECTORY_SERVICE		0xFFFFFC
@@ -264,13 +265,15 @@ struct zfcp_ls_adisc {
 #define ZFCP_STATUS_PORT_DID_DID		0x00000002
 #define ZFCP_STATUS_PORT_PHYS_CLOSING		0x00000004
 #define ZFCP_STATUS_PORT_NO_WWPN		0x00000008
-#define ZFCP_STATUS_PORT_NO_SCSI_ID		0x00000010
 #define ZFCP_STATUS_PORT_INVALID_WWPN		0x00000020
 
-/* for ports with well known addresses */
-#define ZFCP_STATUS_PORT_WKA \
-		(ZFCP_STATUS_PORT_NO_WWPN | \
-		 ZFCP_STATUS_PORT_NO_SCSI_ID)
+/* well known address (WKA) port status*/
+enum zfcp_wka_status {
+	ZFCP_WKA_PORT_OFFLINE,
+	ZFCP_WKA_PORT_CLOSING,
+	ZFCP_WKA_PORT_OPENING,
+	ZFCP_WKA_PORT_ONLINE,
+};
 
 /* logical unit status */
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
@@ -340,7 +343,7 @@ typedef void (*zfcp_send_ct_handler_t)(u
 
 /**
  * struct zfcp_send_ct - used to pass parameters to function zfcp_fsf_send_ct
- * @port: port where the request is sent to
+ * @wka_port: port where the request is sent to
  * @req: scatter-gather list for request
  * @resp: scatter-gather list for response
  * @req_count: number of elements in request scatter-gather list
@@ -352,7 +355,7 @@ typedef void (*zfcp_send_ct_handler_t)(u
  * @status: used to pass error status to calling function
  */
 struct zfcp_send_ct {
-	struct zfcp_port *port;
+	struct zfcp_wka_port *wka_port;
 	struct scatterlist *req;
 	struct scatterlist *resp;
 	unsigned int req_count;
@@ -406,6 +409,17 @@ struct zfcp_send_els {
 	int status;
 };
 
+struct zfcp_wka_port {
+	struct zfcp_adapter	*adapter;
+	wait_queue_head_t	completion_wq;
+	enum zfcp_wka_status	status;
+	atomic_t		refcount;
+	u32			d_id;
+	u32			handle;
+	struct mutex		mutex;
+	struct delayed_work	work;
+};
+
 struct zfcp_qdio_queue {
 	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q]; /* SBALs */
 	u8		   first;	      /* index of next free bfr
@@ -496,7 +510,7 @@ struct zfcp_adapter {
 						      actions */
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
-	struct zfcp_port	*nameserver_port;  /* adapter's nameserver */
+	struct zfcp_wka_port	nsp;		   /* adapter's nameserver */
 	debug_info_t		*rec_dbf;
 	debug_info_t		*hba_dbf;
 	debug_info_t		*san_dbf;          /* debug feature areas */
@@ -540,6 +554,7 @@ struct zfcp_port {
         atomic_t               erp_counter;
 	u32                    maxframe_size;
 	u32                    supported_classes;
+	struct work_struct     gid_pn_work;
 };
 
 struct zfcp_unit {
--- a/drivers/s390/scsi/zfcp_ext.h	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-09-30 16:42:52.000000000 +0200
@@ -91,17 +91,21 @@ extern void zfcp_erp_port_access_denied(
 extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8, void *);
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8, void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
+extern void zfcp_erp_port_strategy_open_lookup(struct work_struct *);
 
 /* zfcp_fc.c */
 extern int zfcp_scan_ports(struct zfcp_adapter *);
 extern void _zfcp_scan_ports_later(struct work_struct *);
 extern void zfcp_fc_incoming_els(struct zfcp_fsf_req *);
-extern int zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *);
+extern int zfcp_fc_ns_gid_pn(struct zfcp_erp_action *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
+extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
+extern int zfcp_fsf_open_wka_port(struct zfcp_wka_port *);
+extern int zfcp_fsf_close_wka_port(struct zfcp_wka_port *);
 extern int zfcp_fsf_close_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_close_physical_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_open_unit(struct zfcp_erp_action *);
@@ -153,7 +157,6 @@ extern struct fc_function_template zfcp_
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
 extern struct attribute_group zfcp_sysfs_adapter_attrs;
-extern struct attribute_group zfcp_sysfs_ns_port_attrs;
 extern struct attribute_group zfcp_sysfs_port_attrs;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
--- a/drivers/s390/scsi/zfcp_fc.c	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-09-30 16:42:52.000000000 +0200
@@ -39,6 +39,84 @@ struct zfcp_gpn_ft {
 	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
 };
 
+struct zfcp_fc_ns_handler_data {
+	struct completion done;
+	void (*handler)(unsigned long);
+	unsigned long handler_data;
+};
+
+static int zfcp_wka_port_get(struct zfcp_wka_port *wka_port)
+{
+	if (mutex_lock_interruptible(&wka_port->mutex))
+		return -ERESTARTSYS;
+
+	if (wka_port->status != ZFCP_WKA_PORT_ONLINE) {
+		wka_port->status = ZFCP_WKA_PORT_OPENING;
+		if (zfcp_fsf_open_wka_port(wka_port))
+			wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+	}
+
+	mutex_unlock(&wka_port->mutex);
+
+	wait_event_timeout(
+		wka_port->completion_wq,
+		wka_port->status == ZFCP_WKA_PORT_ONLINE ||
+		wka_port->status == ZFCP_WKA_PORT_OFFLINE,
+		HZ >> 1);
+
+	if (wka_port->status == ZFCP_WKA_PORT_ONLINE) {
+		atomic_inc(&wka_port->refcount);
+		return 0;
+	}
+	return -EIO;
+}
+
+static void zfcp_wka_port_offline(struct work_struct *work)
+{
+	struct delayed_work *dw = container_of(work, struct delayed_work, work);
+	struct zfcp_wka_port *wka_port =
+			container_of(dw, struct zfcp_wka_port, work);
+
+	wait_event(wka_port->completion_wq,
+			atomic_read(&wka_port->refcount) == 0);
+
+	mutex_lock(&wka_port->mutex);
+	if ((atomic_read(&wka_port->refcount) != 0) ||
+	    (wka_port->status != ZFCP_WKA_PORT_ONLINE))
+		goto out;
+
+	wka_port->status = ZFCP_WKA_PORT_CLOSING;
+	if (zfcp_fsf_close_wka_port(wka_port)) {
+		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		wake_up(&wka_port->completion_wq);
+	}
+out:
+	mutex_unlock(&wka_port->mutex);
+}
+
+static void zfcp_wka_port_put(struct zfcp_wka_port *wka_port)
+{
+	if (atomic_dec_return(&wka_port->refcount) != 0)
+		return;
+	/* wait 10 miliseconds, other reqs might pop in */
+	schedule_delayed_work(&wka_port->work, HZ / 100);
+}
+
+void zfcp_fc_nameserver_init(struct zfcp_adapter *adapter)
+{
+	struct zfcp_wka_port *wka_port = &adapter->nsp;
+
+	init_waitqueue_head(&wka_port->completion_wq);
+
+	wka_port->adapter = adapter;
+	wka_port->d_id = ZFCP_DID_DIRECTORY_SERVICE;
+
+	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+	atomic_set(&wka_port->refcount, 0);
+	mutex_init(&wka_port->mutex);
+	INIT_DELAYED_WORK(&wka_port->work, zfcp_wka_port_offline);
+}
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -47,9 +125,6 @@ static void _zfcp_fc_incoming_rscn(struc
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
-		if ((atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA) ==
-		      ZFCP_STATUS_PORT_WKA)
-			continue;
 		/* FIXME: ZFCP_STATUS_PORT_DID_DID check is racy */
 		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_DID_DID))
 			/* Try to connect to unused ports anyway. */
@@ -158,7 +233,18 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 		zfcp_fc_incoming_rscn(fsf_req);
 }
 
-static void zfcp_ns_gid_pn_handler(unsigned long data)
+static void zfcp_fc_ns_handler(unsigned long data)
+{
+	struct zfcp_fc_ns_handler_data *compl_rec =
+			(struct zfcp_fc_ns_handler_data *) data;
+
+	if (compl_rec->handler)
+		compl_rec->handler(compl_rec->handler_data);
+
+	complete(&compl_rec->done);
+}
+
+static void zfcp_fc_ns_gid_pn_eval(unsigned long data)
 {
 	struct zfcp_gid_pn_data *gid_pn = (struct zfcp_gid_pn_data *) data;
 	struct zfcp_send_ct *ct = &gid_pn->ct;
@@ -167,43 +253,31 @@ static void zfcp_ns_gid_pn_handler(unsig
 	struct zfcp_port *port = gid_pn->port;
 
 	if (ct->status)
-		goto out;
+		return;
 	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT) {
 		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
-		goto out;
+		return;
 	}
 	/* paranoia */
 	if (ct_iu_req->wwpn != port->wwpn)
-		goto out;
+		return;
 	/* looks like a valid d_id */
 	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
 	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
-out:
-	mempool_free(gid_pn, port->adapter->pool.data_gid_pn);
 }
 
-/**
- * zfcp_fc_ns_gid_pn_request - initiate GID_PN nameserver request
- * @erp_action: pointer to zfcp_erp_action where GID_PN request is needed
- * return: -ENOMEM on error, 0 otherwise
- */
-int zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *erp_action)
+int static zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *erp_action,
+				     struct zfcp_gid_pn_data *gid_pn)
 {
-	int ret;
-	struct zfcp_gid_pn_data *gid_pn;
 	struct zfcp_adapter *adapter = erp_action->adapter;
-
-	gid_pn = mempool_alloc(adapter->pool.data_gid_pn, GFP_ATOMIC);
-	if (!gid_pn)
-		return -ENOMEM;
-
-	memset(gid_pn, 0, sizeof(*gid_pn));
+	struct zfcp_fc_ns_handler_data compl_rec;
+	int ret;
 
 	/* setup parameters for send generic command */
 	gid_pn->port = erp_action->port;
-	gid_pn->ct.port = adapter->nameserver_port;
-	gid_pn->ct.handler = zfcp_ns_gid_pn_handler;
-	gid_pn->ct.handler_data = (unsigned long) gid_pn;
+	gid_pn->ct.wka_port = &adapter->nsp;
+	gid_pn->ct.handler = zfcp_fc_ns_handler;
+	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
 	gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
 	gid_pn->ct.req = &gid_pn->req;
 	gid_pn->ct.resp = &gid_pn->resp;
@@ -223,10 +297,42 @@ int zfcp_fc_ns_gid_pn_request(struct zfc
 	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_MAX_SIZE;
 	gid_pn->ct_iu_req.wwpn = erp_action->port->wwpn;
 
+	init_completion(&compl_rec.done);
+	compl_rec.handler = zfcp_fc_ns_gid_pn_eval;
+	compl_rec.handler_data = (unsigned long) gid_pn;
 	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
 			       erp_action);
+	if (!ret)
+		wait_for_completion(&compl_rec.done);
+	return ret;
+}
+
+/**
+ * zfcp_fc_ns_gid_pn_request - initiate GID_PN nameserver request
+ * @erp_action: pointer to zfcp_erp_action where GID_PN request is needed
+ * return: -ENOMEM on error, 0 otherwise
+ */
+int zfcp_fc_ns_gid_pn(struct zfcp_erp_action *erp_action)
+{
+	int ret;
+	struct zfcp_gid_pn_data *gid_pn;
+	struct zfcp_adapter *adapter = erp_action->adapter;
+
+	gid_pn = mempool_alloc(adapter->pool.data_gid_pn, GFP_ATOMIC);
+	if (!gid_pn)
+		return -ENOMEM;
+
+	memset(gid_pn, 0, sizeof(*gid_pn));
+
+	ret = zfcp_wka_port_get(&adapter->nsp);
 	if (ret)
-		mempool_free(gid_pn, adapter->pool.data_gid_pn);
+		goto out;
+
+	ret = zfcp_fc_ns_gid_pn_request(erp_action, gid_pn);
+
+	zfcp_wka_port_put(&adapter->nsp);
+out:
+	mempool_free(gid_pn, adapter->pool.data_gid_pn);
 	return ret;
 }
 
@@ -339,30 +445,6 @@ void zfcp_test_link(struct zfcp_port *po
 		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
 
-static int zfcp_scan_get_nameserver(struct zfcp_adapter *adapter)
-{
-	int ret;
-
-	if (!adapter->nameserver_port)
-		return -EINTR;
-
-	if (!(atomic_read(&adapter->nameserver_port->status) &
-	      ZFCP_STATUS_COMMON_UNBLOCKED)) {
-		ret = zfcp_erp_port_reopen(adapter->nameserver_port, 0, 148,
-					   NULL);
-		if (ret)
-			return ret;
-		zfcp_erp_wait(adapter);
-	}
-	return !(atomic_read(&adapter->nameserver_port->status) &
-		 ZFCP_STATUS_COMMON_UNBLOCKED);
-}
-
-static void zfcp_gpn_ft_handler(unsigned long _done)
-{
-	complete((struct completion *)_done);
-}
-
 static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft)
 {
 	struct scatterlist *sg = &gpn_ft->sg_req;
@@ -404,7 +486,7 @@ static int zfcp_scan_issue_gpn_ft(struct
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct ct_iu_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
-	struct completion done;
+	struct zfcp_fc_ns_handler_data compl_rec;
 	int ret;
 
 	/* prepare CT IU for GPN_FT */
@@ -421,19 +503,20 @@ static int zfcp_scan_issue_gpn_ft(struct
 	req->fc4_type = ZFCP_CT_SCSI_FCP;
 
 	/* prepare zfcp_send_ct */
-	ct->port = adapter->nameserver_port;
-	ct->handler = zfcp_gpn_ft_handler;
-	ct->handler_data = (unsigned long)&done;
+	ct->wka_port = &adapter->nsp;
+	ct->handler = zfcp_fc_ns_handler;
+	ct->handler_data = (unsigned long)&compl_rec;
 	ct->timeout = 10;
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
 	ct->req_count = 1;
 	ct->resp_count = ZFCP_GPN_FT_BUFFERS;
 
-	init_completion(&done);
+	init_completion(&compl_rec.done);
+	compl_rec.handler = NULL;
 	ret = zfcp_fsf_send_ct(ct, NULL, NULL);
 	if (!ret)
-		wait_for_completion(&done);
+		wait_for_completion(&compl_rec.done);
 	return ret;
 }
 
@@ -443,8 +526,6 @@ static void zfcp_validate_port(struct zf
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_NOESC, &port->status);
 
-	if (port == adapter->nameserver_port)
-		return;
 	if ((port->supported_classes != 0) || (port->units != 0)) {
 		zfcp_port_put(port);
 		return;
@@ -461,7 +542,7 @@ static int zfcp_scan_eval_gpn_ft(struct 
 	struct scatterlist *sg = gpn_ft->sg_resp;
 	struct ct_hdr *hdr = sg_virt(sg);
 	struct gpn_ft_resp_acc *acc = sg_virt(sg);
-	struct zfcp_adapter *adapter = ct->port->adapter;
+	struct zfcp_adapter *adapter = ct->wka_port->adapter;
 	struct zfcp_port *port, *tmp;
 	u32 d_id;
 	int ret = 0, x, last = 0;
@@ -491,6 +572,9 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		d_id = acc->port_id[0] << 16 | acc->port_id[1] << 8 |
 		       acc->port_id[2];
 
+		/* don't attach ports with a well known address */
+		if ((d_id & ZFCP_DID_WKA) == ZFCP_DID_WKA)
+			continue;
 		/* skip the adapter's port and known remote ports */
 		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
@@ -529,13 +613,15 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
 
-	ret = zfcp_scan_get_nameserver(adapter);
+	ret = zfcp_wka_port_get(&adapter->nsp);
 	if (ret)
 		return ret;
 
 	gpn_ft = zfcp_alloc_sg_env();
-	if (!gpn_ft)
-		return -ENOMEM;
+	if (!gpn_ft) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	for (i = 0; i < 3; i++) {
 		ret = zfcp_scan_issue_gpn_ft(gpn_ft, adapter);
@@ -548,7 +634,8 @@ int zfcp_scan_ports(struct zfcp_adapter 
 		}
 	}
 	zfcp_free_sg_env(gpn_ft);
-
+out:
+	zfcp_wka_port_put(&adapter->nsp);
 	return ret;
 }
 
--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 16:42:52.000000000 +0200
@@ -23,7 +23,6 @@ enum zfcp_erp_steps {
 	ZFCP_ERP_STEP_FSF_XCONFIG	= 0x0001,
 	ZFCP_ERP_STEP_PHYS_PORT_CLOSING	= 0x0010,
 	ZFCP_ERP_STEP_PORT_CLOSING	= 0x0100,
-	ZFCP_ERP_STEP_NAMESERVER_OPEN	= 0x0200,
 	ZFCP_ERP_STEP_NAMESERVER_LOOKUP	= 0x0400,
 	ZFCP_ERP_STEP_PORT_OPENING	= 0x0800,
 	ZFCP_ERP_STEP_UNIT_CLOSING	= 0x1000,
@@ -532,8 +531,7 @@ static void _zfcp_erp_port_reopen_all(st
 	struct zfcp_port *port;
 
 	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_WKA))
-			_zfcp_erp_port_reopen(port, clear, id, ref);
+		_zfcp_erp_port_reopen(port, clear, id, ref);
 }
 
 static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear, u8 id,
@@ -777,7 +775,6 @@ static int zfcp_erp_port_forced_strategy
 static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_PORT_DID_DID |
 			  ZFCP_STATUS_PORT_PHYS_CLOSING |
 			  ZFCP_STATUS_PORT_INVALID_WWPN,
 			  &port->status);
@@ -830,62 +827,6 @@ static int zfcp_erp_port_strategy_open_p
 	return ZFCP_ERP_CONTINUES;
 }
 
-static void zfcp_erp_port_strategy_open_ns_wake(struct zfcp_erp_action *ns_act)
-{
-	unsigned long flags;
-	struct zfcp_adapter *adapter = ns_act->adapter;
-	struct zfcp_erp_action *act, *tmp;
-	int status;
-
-	read_lock_irqsave(&adapter->erp_lock, flags);
-	list_for_each_entry_safe(act, tmp, &adapter->erp_running_head, list) {
-		if (act->step == ZFCP_ERP_STEP_NAMESERVER_OPEN) {
-			status = atomic_read(&adapter->nameserver_port->status);
-			if (status & ZFCP_STATUS_COMMON_ERP_FAILED)
-				zfcp_erp_port_failed(act->port, 27, NULL);
-			zfcp_erp_action_ready(act);
-		}
-	}
-	read_unlock_irqrestore(&adapter->erp_lock, flags);
-}
-
-static int zfcp_erp_port_strategy_open_nameserver(struct zfcp_erp_action *act)
-{
-	int retval;
-
-	switch (act->step) {
-	case ZFCP_ERP_STEP_UNINITIALIZED:
-	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-	case ZFCP_ERP_STEP_PORT_CLOSING:
-		return zfcp_erp_port_strategy_open_port(act);
-
-	case ZFCP_ERP_STEP_PORT_OPENING:
-		if (atomic_read(&act->port->status) & ZFCP_STATUS_COMMON_OPEN)
-			retval = ZFCP_ERP_SUCCEEDED;
-		else
-			retval = ZFCP_ERP_FAILED;
-		/* this is needed anyway  */
-		zfcp_erp_port_strategy_open_ns_wake(act);
-		return retval;
-
-	default:
-		return ZFCP_ERP_FAILED;
-	}
-}
-
-static int zfcp_erp_port_strategy_open_lookup(struct zfcp_erp_action *act)
-{
-	int retval;
-
-	retval = zfcp_fc_ns_gid_pn_request(act);
-	if (retval == -ENOMEM)
-		return ZFCP_ERP_NOMEM;
-	act->step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
-	if (retval)
-		return ZFCP_ERP_FAILED;
-	return ZFCP_ERP_CONTINUES;
-}
-
 static int zfcp_erp_open_ptp_port(struct zfcp_erp_action *act)
 {
 	struct zfcp_adapter *adapter = act->adapter;
@@ -900,11 +841,25 @@ static int zfcp_erp_open_ptp_port(struct
 	return zfcp_erp_port_strategy_open_port(act);
 }
 
+void zfcp_erp_port_strategy_open_lookup(struct work_struct *work)
+{
+	int retval;
+	struct zfcp_port *port = container_of(work, struct zfcp_port,
+					      gid_pn_work);
+
+	retval = zfcp_fc_ns_gid_pn(&port->erp_action);
+	if (retval == -ENOMEM)
+		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_NOMEM);
+	port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
+	if (retval)
+		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_FAILED);
+
+}
+
 static int zfcp_erp_port_strategy_open_common(struct zfcp_erp_action *act)
 {
 	struct zfcp_adapter *adapter = act->adapter;
 	struct zfcp_port *port = act->port;
-	struct zfcp_port *ns_port = adapter->nameserver_port;
 	int p_status = atomic_read(&port->status);
 
 	switch (act->step) {
@@ -913,29 +868,10 @@ static int zfcp_erp_port_strategy_open_c
 	case ZFCP_ERP_STEP_PORT_CLOSING:
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
-		if (!ns_port) {
-			dev_err(&adapter->ccw_device->dev,
-				"Attaching the name server port to the "
-				"FCP device failed\n");
-			return ZFCP_ERP_FAILED;
-		}
-		if (!(atomic_read(&ns_port->status) &
-		      ZFCP_STATUS_COMMON_UNBLOCKED)) {
-			/* nameserver port may live again */
-			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
-					&ns_port->status);
-			if (zfcp_erp_port_reopen(ns_port, 0, 77, act) >= 0) {
-				act->step = ZFCP_ERP_STEP_NAMESERVER_OPEN;
-				return ZFCP_ERP_CONTINUES;
-			}
-			return ZFCP_ERP_FAILED;
+		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
+			schedule_work(&port->gid_pn_work);
+			return ZFCP_ERP_CONTINUES;
 		}
-		/* else nameserver port is already open, fall through */
-	case ZFCP_ERP_STEP_NAMESERVER_OPEN:
-		if (!(atomic_read(&ns_port->status) & ZFCP_STATUS_COMMON_OPEN))
-			return ZFCP_ERP_FAILED;
-		return zfcp_erp_port_strategy_open_lookup(act);
-
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
 		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
 			if (p_status & (ZFCP_STATUS_PORT_INVALID_WWPN)) {
@@ -948,25 +884,26 @@ static int zfcp_erp_port_strategy_open_c
 
 	case ZFCP_ERP_STEP_PORT_OPENING:
 		/* D_ID might have changed during open */
-		if ((p_status & ZFCP_STATUS_COMMON_OPEN) &&
-		    (p_status & ZFCP_STATUS_PORT_DID_DID))
-			return ZFCP_ERP_SUCCEEDED;
+		if (p_status & ZFCP_STATUS_COMMON_OPEN) {
+			if (p_status & ZFCP_STATUS_PORT_DID_DID)
+				return ZFCP_ERP_SUCCEEDED;
+			else {
+				act->step = ZFCP_ERP_STEP_PORT_CLOSING;
+				return ZFCP_ERP_CONTINUES;
+			}
 		/* fall through otherwise */
+		}
 	}
 	return ZFCP_ERP_FAILED;
 }
 
-static int zfcp_erp_port_strategy_open(struct zfcp_erp_action *act)
-{
-	if (atomic_read(&act->port->status) & (ZFCP_STATUS_PORT_WKA))
-		return zfcp_erp_port_strategy_open_nameserver(act);
-	return zfcp_erp_port_strategy_open_common(act);
-}
-
 static int zfcp_erp_port_strategy(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_port *port = erp_action->port;
 
+	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_NOESC)
+		goto close_init_done;
+
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
 		zfcp_erp_port_strategy_clearstati(port);
@@ -979,12 +916,12 @@ static int zfcp_erp_port_strategy(struct
 			return ZFCP_ERP_FAILED;
 		break;
 	}
+
+close_init_done:
 	if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
 		return ZFCP_ERP_EXIT;
-	else
-		return zfcp_erp_port_strategy_open(erp_action);
 
-	return ZFCP_ERP_FAILED;
+	return zfcp_erp_port_strategy_open_common(erp_action);
 }
 
 static void zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
@@ -1296,12 +1233,10 @@ static void zfcp_erp_rport_register(stru
 static void zfcp_erp_rports_del(struct zfcp_adapter *adapter)
 {
 	struct zfcp_port *port;
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (port->rport && !(atomic_read(&port->status) &
-					ZFCP_STATUS_PORT_WKA)) {
-			fc_remote_port_delete(port->rport);
-			port->rport = NULL;
-		}
+	list_for_each_entry(port, &adapter->port_list_head, list) {
+		fc_remote_port_delete(port->rport);
+		port->rport = NULL;
+	}
 }
 
 static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
@@ -1737,9 +1672,8 @@ static void zfcp_erp_port_access_changed
 
 	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
-		if (!(status & ZFCP_STATUS_PORT_WKA))
-			list_for_each_entry(unit, &port->unit_list_head, list)
-				zfcp_erp_unit_access_changed(unit, id, ref);
+		list_for_each_entry(unit, &port->unit_list_head, list)
+				    zfcp_erp_unit_access_changed(unit, id, ref);
 		return;
 	}
 
@@ -1762,10 +1696,7 @@ void zfcp_erp_adapter_access_changed(str
 		return;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	if (adapter->nameserver_port)
-		zfcp_erp_port_access_changed(adapter->nameserver_port, id, ref);
 	list_for_each_entry(port, &adapter->port_list_head, list)
-		if (port != adapter->nameserver_port)
-			zfcp_erp_port_access_changed(port, id, ref);
+		zfcp_erp_port_access_changed(port, id, ref);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-09-30 16:42:52.000000000 +0200
@@ -961,7 +961,6 @@ static void zfcp_fsf_send_ct_handler(str
 {
 	struct zfcp_adapter *adapter = req->adapter;
 	struct zfcp_send_ct *send_ct = req->data;
-	struct zfcp_port *port = send_ct->port;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	send_ct->status = -EINVAL;
@@ -980,17 +979,14 @@ static void zfcp_fsf_send_ct_handler(str
         case FSF_ADAPTER_STATUS_AVAILABLE:
                 switch (header->fsf_status_qual.word[0]){
                 case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_test_link(port);
                 case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
                 }
                 break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_port(req, port);
 		break;
         case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, 49, req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1041,8 +1037,8 @@ static int zfcp_fsf_setup_sbals(struct z
 int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool,
 		     struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_port *port = ct->port;
-	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
 
@@ -1063,7 +1059,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 		goto failed_send;
 
 	req->handler = zfcp_fsf_send_ct_handler;
-	req->qtcb->header.port_handle = port->handle;
+	req->qtcb->header.port_handle = wka_port->handle;
 	req->qtcb->bottom.support.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.support.timeout = ct->timeout;
 	req->data = ct;
@@ -1435,9 +1431,6 @@ static void zfcp_fsf_open_port_handler(s
 		 * another GID_PN straight after a port has been opened.
 		 * Alternately, an ADISC/PDISC ELS should suffice, as well.
 		 */
-		if (atomic_read(&port->status) & ZFCP_STATUS_PORT_NO_WWPN)
-			break;
-
 		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
 		if (req->qtcb->bottom.support.els1_length >= sizeof(*plogi)) {
 			if (plogi->serv_param.wwpn != port->wwpn)
@@ -1568,6 +1561,130 @@ out:
 	return retval;
 }
 
+static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_wka_port *wka_port = req->data;
+	struct fsf_qtcb_header *header = &req->qtcb->header;
+
+	if (req->status & ZFCP_STATUS_FSFREQ_ERROR) {
+		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		goto out;
+	}
+
+	switch (header->fsf_status) {
+	case FSF_MAXIMUM_NUMBER_OF_PORTS_EXCEEDED:
+		dev_warn(&req->adapter->ccw_device->dev,
+			 "Opening WKA port 0x%x failed\n", wka_port->d_id);
+	case FSF_ADAPTER_STATUS_AVAILABLE:
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+	case FSF_ACCESS_DENIED:
+		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		break;
+	case FSF_PORT_ALREADY_OPEN:
+	case FSF_GOOD:
+		wka_port->handle = header->port_handle;
+		wka_port->status = ZFCP_WKA_PORT_ONLINE;
+	}
+out:
+	wake_up(&wka_port->completion_wq);
+}
+
+/**
+ * zfcp_fsf_open_wka_port - create and send open wka-port request
+ * @wka_port: pointer to struct zfcp_wka_port
+ * Returns: 0 on success, error otherwise
+ */
+int zfcp_fsf_open_wka_port(struct zfcp_wka_port *wka_port)
+{
+	struct qdio_buffer_element *sbale;
+	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock_bh(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter,
+				  FSF_QTCB_OPEN_PORT_WITH_DID,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
+	}
+
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
+	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+
+	req->handler = zfcp_fsf_open_wka_port_handler;
+	req->qtcb->bottom.support.d_id = wka_port->d_id;
+	req->data = wka_port;
+
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(req);
+	if (retval)
+		zfcp_fsf_req_free(req);
+out:
+	spin_unlock_bh(&adapter->req_q.lock);
+	return retval;
+}
+
+static void zfcp_fsf_close_wka_port_handler(struct zfcp_fsf_req *req)
+{
+	struct zfcp_wka_port *wka_port = req->data;
+
+	if (req->qtcb->header.fsf_status == FSF_PORT_HANDLE_NOT_VALID) {
+		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
+		zfcp_erp_adapter_reopen(wka_port->adapter, 0, 107, req);
+	}
+
+	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+	wake_up(&wka_port->completion_wq);
+}
+
+/**
+ * zfcp_fsf_close_wka_port - create and send close wka port request
+ * @erp_action: pointer to struct zfcp_erp_action
+ * Returns: 0 on success, error otherwise
+ */
+int zfcp_fsf_close_wka_port(struct zfcp_wka_port *wka_port)
+{
+	struct qdio_buffer_element *sbale;
+	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_fsf_req *req;
+	int retval = -EIO;
+
+	spin_lock_bh(&adapter->req_q.lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
+		goto out;
+
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
+				  ZFCP_REQ_AUTO_CLEANUP,
+				  adapter->pool.fsf_req_erp);
+	if (unlikely(IS_ERR(req))) {
+		retval = PTR_ERR(req);
+		goto out;
+	}
+
+	sbale = zfcp_qdio_sbale_req(req);
+	sbale[0].flags |= SBAL_FLAGS0_TYPE_READ;
+	sbale[1].flags |= SBAL_FLAGS_LAST_ENTRY;
+
+	req->handler = zfcp_fsf_close_wka_port_handler;
+	req->data = wka_port;
+	req->qtcb->header.port_handle = wka_port->handle;
+
+	zfcp_fsf_start_timer(req, ZFCP_FSF_REQUEST_TIMEOUT);
+	retval = zfcp_fsf_req_send(req);
+	if (retval)
+		zfcp_fsf_req_free(req);
+out:
+	spin_unlock_bh(&adapter->req_q.lock);
+	return retval;
+}
+
 static void zfcp_fsf_close_physical_port_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_port *port = req->data;
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 16:26:32.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-09-30 16:42:52.000000000 +0200
@@ -519,7 +519,7 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[75]	= "physical port recovery escalation after failed port "
 		  "recovery",
 	[76]	= "port recovery escalation after failed unit recovery",
-	[77]	= "recovery opening nameserver port",
+	[77]	= "",
 	[78]	= "duplicate request id",
 	[79]	= "link down",
 	[80]	= "exclusive read-only unit access unsupported",
@@ -829,8 +829,8 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 void zfcp_san_dbf_event_ct_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_port *port = ct->port;
-	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
@@ -842,7 +842,7 @@ void zfcp_san_dbf_event_ct_request(struc
 	r->fsf_reqid = (unsigned long)fsf_req;
 	r->fsf_seqno = fsf_req->seq_no;
 	r->s_id = fc_host_port_id(adapter->scsi_host);
-	r->d_id = port->d_id;
+	r->d_id = wka_port->d_id;
 	oct->cmd_req_code = hdr->cmd_rsp_code;
 	oct->revision = hdr->revision;
 	oct->gs_type = hdr->gs_type;
@@ -863,8 +863,8 @@ void zfcp_san_dbf_event_ct_request(struc
 void zfcp_san_dbf_event_ct_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_port *port = ct->port;
-	struct zfcp_adapter *adapter = port->adapter;
+	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
@@ -875,7 +875,7 @@ void zfcp_san_dbf_event_ct_response(stru
 	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = (unsigned long)fsf_req;
 	r->fsf_seqno = fsf_req->seq_no;
-	r->s_id = port->d_id;
+	r->s_id = wka_port->d_id;
 	r->d_id = fc_host_port_id(adapter->scsi_host);
 	rct->cmd_rsp_code = hdr->cmd_rsp_code;
 	rct->revision = hdr->revision;
--- a/drivers/s390/scsi/zfcp_sysfs.c	2008-09-30 16:26:31.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2008-09-30 16:42:52.000000000 +0200
@@ -273,22 +273,7 @@ out:
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);
 
-static struct attribute *zfcp_port_ns_attrs[] = {
-	&dev_attr_port_failed.attr,
-	&dev_attr_port_in_recovery.attr,
-	&dev_attr_port_status.attr,
-	&dev_attr_port_access_denied.attr,
-	NULL
-};
-
-/**
- * zfcp_sysfs_ns_port_attrs - sysfs attributes for nameserver
- */
-struct attribute_group zfcp_sysfs_ns_port_attrs = {
-	.attrs = zfcp_port_ns_attrs,
-};
-
-static struct attribute *zfcp_port_no_ns_attrs[] = {
+static struct attribute *zfcp_port_attrs[] = {
 	&dev_attr_unit_add.attr,
 	&dev_attr_unit_remove.attr,
 	&dev_attr_port_failed.attr,
@@ -302,7 +287,7 @@ static struct attribute *zfcp_port_no_ns
  * zfcp_sysfs_port_attrs - sysfs attributes for all other ports
  */
 struct attribute_group zfcp_sysfs_port_attrs = {
-	.attrs = zfcp_port_no_ns_attrs,
+	.attrs = zfcp_port_attrs,
 };
 
 static struct attribute *zfcp_unit_attrs[] = {

-- 
