From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 15/22] zfcp: Move WKA port to zfcp FC code
Date: Tue, 24 Nov 2009 16:54:11 +0100
Message-ID: <20091124160138.188499000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:59648 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235AbZKXQBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:33 -0500
Content-Disposition: inline; filename=714-zfcp-wka-move.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The well-known-address (WKA) port handling code is part of the FC code
in zfcp. Move everything WKA related to the zfcp_fc files and use the
common zfcp_fc prefix for structs and functions. Drop the unused key
management service while renaming the struct, no request could ever
reach this service in zfcp and it is obsolete anyway.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |    5 ++--
 drivers/s390/scsi/zfcp_def.h |   31 +-------------------------
 drivers/s390/scsi/zfcp_ext.h |    6 ++---
 drivers/s390/scsi/zfcp_fc.c  |   44 ++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_fc.h  |   50 +++++++++++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c |   22 +++++++++---------
 6 files changed, 90 insertions(+), 68 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:32.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:36.000000000 +0100
@@ -13,6 +13,7 @@
 #include <asm/debug.h>
 #include "zfcp_dbf.h"
 #include "zfcp_ext.h"
+#include "zfcp_fc.h"
 
 static u32 dbfsize = 4;
 
@@ -681,7 +682,7 @@ void zfcp_dbf_rec_action(char *id2, stru
 void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct fc_ct_hdr *hdr = sg_virt(ct->req);
@@ -718,7 +719,7 @@ void zfcp_dbf_san_ct_request(struct zfcp
 void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct fc_ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_dbf *dbf = adapter->dbf;
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:32.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:36.000000000 +0100
@@ -104,14 +104,6 @@
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
 #define ZFCP_STATUS_PORT_LINK_TEST		0x00000002
 
-/* well known address (WKA) port status*/
-enum zfcp_wka_status {
-	ZFCP_WKA_PORT_OFFLINE,
-	ZFCP_WKA_PORT_CLOSING,
-	ZFCP_WKA_PORT_OPENING,
-	ZFCP_WKA_PORT_ONLINE,
-};
-
 /* logical unit status */
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
@@ -155,7 +147,7 @@ struct zfcp_adapter_mempool {
  * @status: used to pass error status to calling function
  */
 struct zfcp_send_ct {
-	struct zfcp_wka_port *wka_port;
+	struct zfcp_fc_wka_port *wka_port;
 	struct scatterlist *req;
 	struct scatterlist *resp;
 	void (*handler)(unsigned long);
@@ -190,25 +182,6 @@ struct zfcp_send_els {
 	int status;
 };
 
-struct zfcp_wka_port {
-	struct zfcp_adapter	*adapter;
-	wait_queue_head_t	completion_wq;
-	enum zfcp_wka_status	status;
-	atomic_t		refcount;
-	u32			d_id;
-	u32			handle;
-	struct mutex		mutex;
-	struct delayed_work	work;
-};
-
-struct zfcp_wka_ports {
-	struct zfcp_wka_port ms; 	/* management service */
-	struct zfcp_wka_port ts; 	/* time service */
-	struct zfcp_wka_port ds; 	/* directory service */
-	struct zfcp_wka_port as; 	/* alias service */
-	struct zfcp_wka_port ks; 	/* key distribution service */
-};
-
 struct zfcp_qdio_queue {
 	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
 	u8		   first;	/* index of next free bfr in queue */
@@ -309,7 +282,7 @@ struct zfcp_adapter {
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
 	struct task_struct	*erp_thread;
-	struct zfcp_wka_ports	*gs;		   /* generic services */
+	struct zfcp_fc_wka_ports *gs;		   /* generic services */
 	struct zfcp_dbf		*dbf;		   /* debug traces */
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct fc_host_statistics *fc_stats;
--- a/drivers/s390/scsi/zfcp_ext.h	2009-11-24 16:35:29.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-11-24 16:35:36.000000000 +0100
@@ -103,7 +103,7 @@ extern void zfcp_fc_trigger_did_lookup(s
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fc_els_flogi *);
 extern void zfcp_fc_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
-extern void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *);
+extern void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *);
@@ -111,8 +111,8 @@ extern int zfcp_fc_execute_ct_fc_job(str
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
-extern int zfcp_fsf_open_wka_port(struct zfcp_wka_port *);
-extern int zfcp_fsf_close_wka_port(struct zfcp_wka_port *);
+extern int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *);
+extern int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *);
 extern int zfcp_fsf_close_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_close_physical_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_open_unit(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:32.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:36.000000000 +0100
@@ -28,25 +28,25 @@ struct zfcp_fc_ns_handler_data {
 	unsigned long handler_data;
 };
 
-static int zfcp_fc_wka_port_get(struct zfcp_wka_port *wka_port)
+static int zfcp_fc_wka_port_get(struct zfcp_fc_wka_port *wka_port)
 {
 	if (mutex_lock_interruptible(&wka_port->mutex))
 		return -ERESTARTSYS;
 
-	if (wka_port->status == ZFCP_WKA_PORT_OFFLINE ||
-	    wka_port->status == ZFCP_WKA_PORT_CLOSING) {
-		wka_port->status = ZFCP_WKA_PORT_OPENING;
+	if (wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE ||
+	    wka_port->status == ZFCP_FC_WKA_PORT_CLOSING) {
+		wka_port->status = ZFCP_FC_WKA_PORT_OPENING;
 		if (zfcp_fsf_open_wka_port(wka_port))
-			wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+			wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 	}
 
 	mutex_unlock(&wka_port->mutex);
 
 	wait_event(wka_port->completion_wq,
-		   wka_port->status == ZFCP_WKA_PORT_ONLINE ||
-		   wka_port->status == ZFCP_WKA_PORT_OFFLINE);
+		   wka_port->status == ZFCP_FC_WKA_PORT_ONLINE ||
+		   wka_port->status == ZFCP_FC_WKA_PORT_OFFLINE);
 
-	if (wka_port->status == ZFCP_WKA_PORT_ONLINE) {
+	if (wka_port->status == ZFCP_FC_WKA_PORT_ONLINE) {
 		atomic_inc(&wka_port->refcount);
 		return 0;
 	}
@@ -56,24 +56,24 @@ static int zfcp_fc_wka_port_get(struct z
 static void zfcp_fc_wka_port_offline(struct work_struct *work)
 {
 	struct delayed_work *dw = to_delayed_work(work);
-	struct zfcp_wka_port *wka_port =
-			container_of(dw, struct zfcp_wka_port, work);
+	struct zfcp_fc_wka_port *wka_port =
+			container_of(dw, struct zfcp_fc_wka_port, work);
 
 	mutex_lock(&wka_port->mutex);
 	if ((atomic_read(&wka_port->refcount) != 0) ||
-	    (wka_port->status != ZFCP_WKA_PORT_ONLINE))
+	    (wka_port->status != ZFCP_FC_WKA_PORT_ONLINE))
 		goto out;
 
-	wka_port->status = ZFCP_WKA_PORT_CLOSING;
+	wka_port->status = ZFCP_FC_WKA_PORT_CLOSING;
 	if (zfcp_fsf_close_wka_port(wka_port)) {
-		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 		wake_up(&wka_port->completion_wq);
 	}
 out:
 	mutex_unlock(&wka_port->mutex);
 }
 
-static void zfcp_fc_wka_port_put(struct zfcp_wka_port *wka_port)
+static void zfcp_fc_wka_port_put(struct zfcp_fc_wka_port *wka_port)
 {
 	if (atomic_dec_return(&wka_port->refcount) != 0)
 		return;
@@ -81,7 +81,7 @@ static void zfcp_fc_wka_port_put(struct 
 	schedule_delayed_work(&wka_port->work, HZ / 100);
 }
 
-static void zfcp_fc_wka_port_init(struct zfcp_wka_port *wka_port, u32 d_id,
+static void zfcp_fc_wka_port_init(struct zfcp_fc_wka_port *wka_port, u32 d_id,
 				  struct zfcp_adapter *adapter)
 {
 	init_waitqueue_head(&wka_port->completion_wq);
@@ -89,21 +89,21 @@ static void zfcp_fc_wka_port_init(struct
 	wka_port->adapter = adapter;
 	wka_port->d_id = d_id;
 
-	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+	wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 	atomic_set(&wka_port->refcount, 0);
 	mutex_init(&wka_port->mutex);
 	INIT_DELAYED_WORK(&wka_port->work, zfcp_fc_wka_port_offline);
 }
 
-static void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
+static void zfcp_fc_wka_port_force_offline(struct zfcp_fc_wka_port *wka)
 {
 	cancel_delayed_work_sync(&wka->work);
 	mutex_lock(&wka->mutex);
-	wka->status = ZFCP_WKA_PORT_OFFLINE;
+	wka->status = ZFCP_FC_WKA_PORT_OFFLINE;
 	mutex_unlock(&wka->mutex);
 }
 
-void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *gs)
+void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *gs)
 {
 	if (!gs)
 		return;
@@ -111,7 +111,6 @@ void zfcp_fc_wka_ports_force_offline(str
 	zfcp_fc_wka_port_force_offline(&gs->ts);
 	zfcp_fc_wka_port_force_offline(&gs->ds);
 	zfcp_fc_wka_port_force_offline(&gs->as);
-	zfcp_fc_wka_port_force_offline(&gs->ks);
 }
 
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
@@ -834,9 +833,9 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 
 int zfcp_fc_gs_setup(struct zfcp_adapter *adapter)
 {
-	struct zfcp_wka_ports *wka_ports;
+	struct zfcp_fc_wka_ports *wka_ports;
 
-	wka_ports = kzalloc(sizeof(struct zfcp_wka_ports), GFP_KERNEL);
+	wka_ports = kzalloc(sizeof(struct zfcp_fc_wka_ports), GFP_KERNEL);
 	if (!wka_ports)
 		return -ENOMEM;
 
@@ -845,7 +844,6 @@ int zfcp_fc_gs_setup(struct zfcp_adapter
 	zfcp_fc_wka_port_init(&wka_ports->ts, FC_FID_TIME_SERV, adapter);
 	zfcp_fc_wka_port_init(&wka_ports->ds, FC_FID_DIR_SERV, adapter);
 	zfcp_fc_wka_port_init(&wka_ports->as, FC_FID_ALIASES, adapter);
-	zfcp_fc_wka_port_init(&wka_ports->ks, FC_FID_SEC_KEY, adapter);
 
 	return 0;
 }
--- a/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:32.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:36.000000000 +0100
@@ -112,6 +112,56 @@ struct zfcp_fc_els_adisc {
 };
 
 /**
+ * enum zfcp_fc_wka_status - FC WKA port status in zfcp
+ * @ZFCP_FC_WKA_PORT_OFFLINE: Port is closed and not in use
+ * @ZFCP_FC_WKA_PORT_CLOSING: The FSF "close port" request is pending
+ * @ZFCP_FC_WKA_PORT_OPENING: The FSF "open port" request is pending
+ * @ZFCP_FC_WKA_PORT_ONLINE: The port is open and the port handle is valid
+ */
+enum zfcp_fc_wka_status {
+	ZFCP_FC_WKA_PORT_OFFLINE,
+	ZFCP_FC_WKA_PORT_CLOSING,
+	ZFCP_FC_WKA_PORT_OPENING,
+	ZFCP_FC_WKA_PORT_ONLINE,
+};
+
+/**
+ * struct zfcp_fc_wka_port - representation of well-known-address (WKA) FC port
+ * @adapter: Pointer to adapter structure this WKA port belongs to
+ * @completion_wq: Wait for completion of open/close command
+ * @status: Current status of WKA port
+ * @refcount: Reference count to keep port open as long as it is in use
+ * @d_id: FC destination id or well-known-address
+ * @handle: FSF handle for the open WKA port
+ * @mutex: Mutex used during opening/closing state changes
+ * @work: For delaying the closing of the WKA port
+ */
+struct zfcp_fc_wka_port {
+	struct zfcp_adapter	*adapter;
+	wait_queue_head_t	completion_wq;
+	enum zfcp_fc_wka_status	status;
+	atomic_t		refcount;
+	u32			d_id;
+	u32			handle;
+	struct mutex		mutex;
+	struct delayed_work	work;
+};
+
+/**
+ * struct zfcp_fc_wka_ports - Data structures for FC generic services
+ * @ms: FC Management service
+ * @ts: FC time service
+ * @ds: FC directory service
+ * @as: FC alias service
+ */
+struct zfcp_fc_wka_ports {
+	struct zfcp_fc_wka_port ms;
+	struct zfcp_fc_wka_port ts;
+	struct zfcp_fc_wka_port ds;
+	struct zfcp_fc_wka_port as;
+};
+
+/**
  * zfcp_fc_scsi_to_fcp - setup FCP command with data from scsi_cmnd
  * @fcp: fcp_cmnd to setup
  * @scsi: scsi_cmnd where to get LUN, task attributes/flags and CDB
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 16:35:29.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 16:35:36.000000000 +0100
@@ -1096,7 +1096,7 @@ static int zfcp_fsf_setup_ct_els(struct 
  */
 int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool)
 {
-	struct zfcp_wka_port *wka_port = ct->wka_port;
+	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
@@ -1610,11 +1610,11 @@ out:
 
 static void zfcp_fsf_open_wka_port_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_wka_port *wka_port = req->data;
+	struct zfcp_fc_wka_port *wka_port = req->data;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR) {
-		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 		goto out;
 	}
 
@@ -1627,13 +1627,13 @@ static void zfcp_fsf_open_wka_port_handl
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		/* fall through */
 	case FSF_ACCESS_DENIED:
-		wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+		wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 		break;
 	case FSF_GOOD:
 		wka_port->handle = header->port_handle;
 		/* fall through */
 	case FSF_PORT_ALREADY_OPEN:
-		wka_port->status = ZFCP_WKA_PORT_ONLINE;
+		wka_port->status = ZFCP_FC_WKA_PORT_ONLINE;
 	}
 out:
 	wake_up(&wka_port->completion_wq);
@@ -1641,10 +1641,10 @@ out:
 
 /**
  * zfcp_fsf_open_wka_port - create and send open wka-port request
- * @wka_port: pointer to struct zfcp_wka_port
+ * @wka_port: pointer to struct zfcp_fc_wka_port
  * Returns: 0 on success, error otherwise
  */
-int zfcp_fsf_open_wka_port(struct zfcp_wka_port *wka_port)
+int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
@@ -1683,23 +1683,23 @@ out:
 
 static void zfcp_fsf_close_wka_port_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_wka_port *wka_port = req->data;
+	struct zfcp_fc_wka_port *wka_port = req->data;
 
 	if (req->qtcb->header.fsf_status == FSF_PORT_HANDLE_NOT_VALID) {
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		zfcp_erp_adapter_reopen(wka_port->adapter, 0, "fscwph1", req);
 	}
 
-	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
+	wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
 	wake_up(&wka_port->completion_wq);
 }
 
 /**
  * zfcp_fsf_close_wka_port - create and send close wka port request
- * @erp_action: pointer to struct zfcp_erp_action
+ * @wka_port: WKA port to open
  * Returns: 0 on success, error otherwise
  */
-int zfcp_fsf_close_wka_port(struct zfcp_wka_port *wka_port)
+int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct qdio_buffer_element *sbale;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;

