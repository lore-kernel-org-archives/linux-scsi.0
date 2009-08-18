From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 17/27] zfcp: introduce _setup, _destroy for qdio and FC
Date: Tue, 18 Aug 2009 15:43:22 +0200
Message-ID: <20090818135031.013704000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56271 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=718-zfcp-setup-destroy.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Extract independent data structures and introduce common _setup and
_destroy routines for QDIO and Fibre Channel related data structures

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c  |   42 ++++++++-----------------
 drivers/s390/scsi/zfcp_ext.h  |    7 ++--
 drivers/s390/scsi/zfcp_fc.c   |   36 +++++++++++++++-------
 drivers/s390/scsi/zfcp_qdio.c |   68 ++++++++++++++++++++++++++++--------------
 4 files changed, 89 insertions(+), 64 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:45.000000000 +0200
@@ -506,30 +506,18 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (!adapter)
 		return -ENOMEM;
 
-	adapter->gs = kzalloc(sizeof(struct zfcp_wka_ports), GFP_KERNEL);
-	if (!adapter->gs) {
-		kfree(adapter);
-		return -ENOMEM;
-	}
-
-	adapter->qdio = kzalloc(sizeof(struct zfcp_qdio), GFP_KERNEL);
-	if (!adapter->qdio)
-		goto qdio_mem_failed;
-
-	adapter->qdio->adapter = adapter;
-
 	ccw_device->handler = NULL;
 	adapter->ccw_device = ccw_device;
 	atomic_set(&adapter->refcount, 0);
 
-	if (zfcp_qdio_allocate(adapter->qdio, ccw_device))
-		goto qdio_allocate_failed;
+	if (zfcp_qdio_setup(adapter))
+		goto qdio_failed;
 
 	if (zfcp_allocate_low_mem_buffers(adapter))
-		goto failed_low_mem_buffers;
+		goto low_mem_buffers_failed;
 
 	if (zfcp_reqlist_alloc(adapter))
-		goto failed_low_mem_buffers;
+		goto low_mem_buffers_failed;
 
 	if (zfcp_dbf_adapter_register(adapter))
 		goto debug_register_failed;
@@ -537,6 +525,9 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	if (zfcp_setup_adapter_work_queue(adapter))
 		goto work_queue_failed;
 
+	if (zfcp_fc_gs_setup(adapter))
+		goto generic_services_failed;
+
 	init_waitqueue_head(&adapter->remove_wq);
 	init_waitqueue_head(&adapter->erp_thread_wqh);
 	init_waitqueue_head(&adapter->erp_done_wqh);
@@ -547,9 +538,6 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	spin_lock_init(&adapter->req_list_lock);
 
-	spin_lock_init(&adapter->qdio->req_q_lock);
-	spin_lock_init(&adapter->qdio->stat_lock);
-
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
@@ -570,24 +558,23 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		goto sysfs_failed;
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
-	zfcp_fc_wka_ports_init(adapter);
 
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
 
 sysfs_failed:
+	zfcp_fc_gs_destroy(adapter);
+generic_services_failed:
 	zfcp_destroy_adapter_work_queue(adapter);
 work_queue_failed:
 	zfcp_dbf_adapter_unregister(adapter->dbf);
 debug_register_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
 	kfree(adapter->req_list);
-failed_low_mem_buffers:
+low_mem_buffers_failed:
 	zfcp_free_low_mem_buffers(adapter);
-qdio_allocate_failed:
-	zfcp_qdio_free(adapter->qdio);
-	kfree(adapter->qdio);
-qdio_mem_failed:
+qdio_failed:
+	zfcp_qdio_destroy(adapter->qdio);
 	kfree(adapter);
 	return -ENOMEM;
 }
@@ -616,15 +603,14 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 	if (!retval)
 		return;
 
+	zfcp_fc_gs_destroy(adapter);
 	zfcp_destroy_adapter_work_queue(adapter);
 	zfcp_dbf_adapter_unregister(adapter->dbf);
-	zfcp_qdio_free(adapter->qdio);
 	zfcp_free_low_mem_buffers(adapter);
+	zfcp_qdio_destroy(adapter->qdio);
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
-	kfree(adapter->gs);
-	kfree(adapter->qdio);
 	kfree(adapter);
 }
 
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:45.000000000 +0200
@@ -100,7 +100,8 @@ extern void zfcp_fc_plogi_evaluate(struc
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *);
-extern void zfcp_fc_wka_ports_init(struct zfcp_adapter *);
+extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
+extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
 extern int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *);
 extern int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *);
 
@@ -134,8 +135,8 @@ extern struct zfcp_fsf_req *zfcp_fsf_abo
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 
 /* zfcp_qdio.c */
-extern int zfcp_qdio_allocate(struct zfcp_qdio *, struct ccw_device *);
-extern void zfcp_qdio_free(struct zfcp_qdio *);
+extern int zfcp_qdio_setup(struct zfcp_adapter *);
+extern void zfcp_qdio_destroy(struct zfcp_qdio *);
 extern int zfcp_qdio_send(struct zfcp_qdio *, struct zfcp_queue_req *);
 extern struct qdio_buffer_element
 	*zfcp_qdio_sbale_req(struct zfcp_qdio *, struct zfcp_queue_req *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:45.000000000 +0200
@@ -141,17 +141,6 @@ void zfcp_fc_wka_ports_force_offline(str
 	zfcp_fc_wka_port_force_offline(&gs->ks);
 }
 
-void zfcp_fc_wka_ports_init(struct zfcp_adapter *adapter)
-{
-	struct zfcp_wka_ports *gs = adapter->gs;
-
-	zfcp_fc_wka_port_init(&gs->ms, FC_FID_MGMT_SERV, adapter);
-	zfcp_fc_wka_port_init(&gs->ts, FC_FID_TIME_SERV, adapter);
-	zfcp_fc_wka_port_init(&gs->ds, FC_FID_DIR_SERV, adapter);
-	zfcp_fc_wka_port_init(&gs->as, FC_FID_ALIASES, adapter);
-	zfcp_fc_wka_port_init(&gs->ks, FC_FID_SEC_KEY, adapter);
-}
-
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -870,3 +859,28 @@ int zfcp_fc_execute_ct_fc_job(struct fc_
 	}
 	return ret;
 }
+
+int zfcp_fc_gs_setup(struct zfcp_adapter *adapter)
+{
+	struct zfcp_wka_ports *wka_ports;
+
+	wka_ports = kzalloc(sizeof(struct zfcp_wka_ports), GFP_KERNEL);
+	if (!wka_ports)
+		return -ENOMEM;
+
+	adapter->gs = wka_ports;
+	zfcp_fc_wka_port_init(&wka_ports->ms, FC_FID_MGMT_SERV, adapter);
+	zfcp_fc_wka_port_init(&wka_ports->ts, FC_FID_TIME_SERV, adapter);
+	zfcp_fc_wka_port_init(&wka_ports->ds, FC_FID_DIR_SERV, adapter);
+	zfcp_fc_wka_port_init(&wka_ports->as, FC_FID_ALIASES, adapter);
+	zfcp_fc_wka_port_init(&wka_ports->ks, FC_FID_SEC_KEY, adapter);
+
+	return 0;
+}
+
+void zfcp_fc_gs_destroy(struct zfcp_adapter *adapter)
+{
+	kfree(adapter->gs);
+	adapter->gs = NULL;
+}
+
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:29:38.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-08-17 11:29:45.000000000 +0200
@@ -34,27 +34,6 @@ zfcp_qdio_sbale(struct zfcp_qdio_queue *
 	return &q->sbal[sbal_idx]->element[sbale_idx];
 }
 
-/**
- * zfcp_qdio_free - free memory used by request- and resposne queue
- * @qdio: pointer to the zfcp_qdio structure
- */
-void zfcp_qdio_free(struct zfcp_qdio *qdio)
-{
-	struct qdio_buffer **sbal_req, **sbal_resp;
-	int p;
-
-	if (qdio->adapter->ccw_device)
-		qdio_free(qdio->adapter->ccw_device);
-
-	sbal_req = qdio->req_q.sbal;
-	sbal_resp = qdio->resp_q.sbal;
-
-	for (p = 0; p < QDIO_MAX_BUFFERS_PER_Q; p += QBUFF_PER_PAGE) {
-		free_page((unsigned long) sbal_req[p]);
-		free_page((unsigned long) sbal_resp[p]);
-	}
-}
-
 static void zfcp_qdio_handler_error(struct zfcp_qdio *qdio, char *id)
 {
 	struct zfcp_adapter *adapter = qdio->adapter;
@@ -383,7 +362,7 @@ static void zfcp_qdio_setup_init_data(st
  * Returns: -ENOMEM on memory allocation error or return value from
  *          qdio_allocate
  */
-int zfcp_qdio_allocate(struct zfcp_qdio *qdio, struct ccw_device *ccw_dev)
+static int zfcp_qdio_allocate(struct zfcp_qdio *qdio)
 {
 	struct qdio_initialize init_data;
 
@@ -477,3 +456,48 @@ failed_establish:
 		"Setting up the QDIO connection to the FCP adapter failed\n");
 	return -EIO;
 }
+
+void zfcp_qdio_destroy(struct zfcp_qdio *qdio)
+{
+	struct qdio_buffer **sbal_req, **sbal_resp;
+	int p;
+
+	if (!qdio)
+		return;
+
+	if (qdio->adapter->ccw_device)
+		qdio_free(qdio->adapter->ccw_device);
+
+	sbal_req = qdio->req_q.sbal;
+	sbal_resp = qdio->resp_q.sbal;
+
+	for (p = 0; p < QDIO_MAX_BUFFERS_PER_Q; p += QBUFF_PER_PAGE) {
+		free_page((unsigned long) sbal_req[p]);
+		free_page((unsigned long) sbal_resp[p]);
+	}
+
+	kfree(qdio);
+}
+
+int zfcp_qdio_setup(struct zfcp_adapter *adapter)
+{
+	struct zfcp_qdio *qdio;
+
+	qdio = kzalloc(sizeof(struct zfcp_qdio), GFP_KERNEL);
+	if (!qdio)
+		return -ENOMEM;
+
+	qdio->adapter = adapter;
+
+	if (zfcp_qdio_allocate(qdio)) {
+		zfcp_qdio_destroy(qdio);
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&qdio->req_q_lock);
+	spin_lock_init(&qdio->stat_lock);
+
+	adapter->qdio = qdio;
+	return 0;
+}
+

