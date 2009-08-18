From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 12/27] zfcp: Move workqueue to adapter struct
Date: Tue, 18 Aug 2009 15:43:17 +0200
Message-ID: <20090818135030.334246000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57701 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=713-zfcp-work-queue.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Remove the global driver work queue and replace it with a workqueue
local to the adapter. The usage of this workqueue makes this the
correct place for the structure. In addition multiple adapters won't
block each other due to the serialization of the queued work.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 12:41:58.000000000 +0200
@@ -176,8 +176,6 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	zfcp_data.work_queue = create_singlethread_workqueue("zfcp_wq");
-
 	sema_init(&zfcp_data.config_sema, 1);
 	rwlock_init(&zfcp_data.config_lock);
 
@@ -458,6 +456,27 @@ static void zfcp_print_sl(struct seq_fil
 		   adapter->fsf_lic_version);
 }
 
+static int zfcp_setup_adapter_work_queue(struct zfcp_adapter *adapter)
+{
+	char name[TASK_COMM_LEN];
+
+	snprintf(name, sizeof(name), "zfcp_q_%s",
+		 dev_name(&adapter->ccw_device->dev));
+	adapter->work_queue = create_singlethread_workqueue(name);
+
+	if (adapter->work_queue)
+		return 0;
+	return -ENOMEM;
+}
+
+static void zfcp_destroy_adapter_work_queue(struct zfcp_adapter *adapter)
+{
+	if (adapter->work_queue)
+		destroy_workqueue(adapter->work_queue);
+	adapter->work_queue = NULL;
+
+}
+
 /**
  * zfcp_adapter_enqueue - enqueue a new adapter to the list
  * @ccw_device: pointer to the struct cc_device
@@ -504,6 +523,9 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (zfcp_adapter_debug_register(adapter))
 		goto debug_register_failed;
 
+	if (zfcp_setup_adapter_work_queue(adapter))
+		goto work_queue_failed;
+
 	init_waitqueue_head(&adapter->remove_wq);
 	init_waitqueue_head(&adapter->erp_thread_wqh);
 	init_waitqueue_head(&adapter->erp_done_wqh);
@@ -543,6 +565,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		return 0;
 
 sysfs_failed:
+	zfcp_destroy_adapter_work_queue(adapter);
+work_queue_failed:
 	zfcp_adapter_debug_unregister(adapter);
 debug_register_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
@@ -579,6 +603,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	if (!retval)
 		return;
 
+	zfcp_destroy_adapter_work_queue(adapter);
 	zfcp_adapter_debug_unregister(adapter);
 	zfcp_qdio_free(adapter);
 	zfcp_free_low_mem_buffers(adapter);
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 12:41:58.000000000 +0200
@@ -485,6 +485,7 @@ struct zfcp_adapter {
 	struct work_struct	scan_work;
 	struct service_level	service_level;
 	atomic_t		qdio_outb_full;	   /* queue full incidents */
+	struct workqueue_struct	*work_queue;
 };
 
 struct zfcp_port {
@@ -573,7 +574,6 @@ struct zfcp_data {
 	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;
-	struct workqueue_struct	*work_queue;
 };
 
 /********************** ZFCP SPECIFIC DEFINES ********************************/
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-17 12:41:58.000000000 +0200
@@ -875,7 +875,7 @@ static int zfcp_erp_port_strategy_open_c
 			return zfcp_erp_open_ptp_port(act);
 		if (!port->d_id) {
 			zfcp_port_get(port);
-			if (!queue_work(zfcp_data.work_queue,
+			if (!queue_work(adapter->work_queue,
 					&port->gid_pn_work))
 				zfcp_port_put(port);
 			return ZFCP_ERP_CONTINUES;
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 12:41:58.000000000 +0200
@@ -480,7 +480,7 @@ out:
 void zfcp_test_link(struct zfcp_port *port)
 {
 	zfcp_port_get(port);
-	if (!queue_work(zfcp_data.work_queue, &port->test_link_work))
+	if (!queue_work(port->adapter->work_queue, &port->test_link_work))
 		zfcp_port_put(port);
 }
 
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 12:41:58.000000000 +0200
@@ -305,7 +305,7 @@ static void zfcp_fsf_status_read_handler
 	zfcp_fsf_req_free(req);
 
 	atomic_inc(&adapter->stat_miss);
-	queue_work(zfcp_data.work_queue, &adapter->stat_work);
+	queue_work(adapter->work_queue, &adapter->stat_work);
 }
 
 static void zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *req)
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 12:41:58.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-08-17 12:41:58.000000000 +0200
@@ -572,7 +572,7 @@ void zfcp_scsi_schedule_rport_register(s
 	zfcp_port_get(port);
 	port->rport_task = RPORT_ADD;
 
-	if (!queue_work(zfcp_data.work_queue, &port->rport_work))
+	if (!queue_work(port->adapter->work_queue, &port->rport_work))
 		zfcp_port_put(port);
 }
 
@@ -581,7 +581,8 @@ void zfcp_scsi_schedule_rport_block(stru
 	zfcp_port_get(port);
 	port->rport_task = RPORT_DEL;
 
-	if (port->rport && queue_work(zfcp_data.work_queue, &port->rport_work))
+	if (port->rport && queue_work(port->adapter->work_queue,
+				      &port->rport_work))
 		return;
 
 	zfcp_port_put(port);

