From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 09/11] zfcp: Move SCSI host and transport templates out of struct zfcp_data
Date: Tue, 22 Feb 2011 19:54:46 +0100
Message-ID: <20110222185537.191158203@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:52307 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab1BVSzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:40 -0500
Content-Disposition: inline; filename=709-zfcp-move-templates.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The SCSI host and transport templates are the only members left in the
global zfcp_data struct. Move them out of zfcp_data  and remove the
now unused zfcp_data struct. Also update the names of the register and
unregister functions to use the zfcp_scsi prefix.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c  |   14 ++++----
 drivers/s390/scsi/zfcp_def.h  |    6 ---
 drivers/s390/scsi/zfcp_ext.h  |    6 +--
 drivers/s390/scsi/zfcp_scsi.c |   70 ++++++++++++++++++++++--------------------
 4 files changed, 48 insertions(+), 48 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -132,11 +132,11 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_fc_req_cache)
 		goto out_fc_cache;
 
-	zfcp_data.scsi_transport_template =
+	zfcp_scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
-	if (!zfcp_data.scsi_transport_template)
+	if (!zfcp_scsi_transport_template)
 		goto out_transport;
-	scsi_transport_reserve_device(zfcp_data.scsi_transport_template,
+	scsi_transport_reserve_device(zfcp_scsi_transport_template,
 				      sizeof(struct zfcp_scsi_dev));
 
 
@@ -160,7 +160,7 @@ static int __init zfcp_module_init(void)
 out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
 out_misc:
-	fc_release_transport(zfcp_data.scsi_transport_template);
+	fc_release_transport(zfcp_scsi_transport_template);
 out_transport:
 	kmem_cache_destroy(zfcp_fc_req_cache);
 out_fc_cache:
@@ -175,7 +175,7 @@ static void __exit zfcp_module_exit(void
 {
 	ccw_driver_unregister(&zfcp_ccw_driver);
 	misc_deregister(&zfcp_cfdc_misc);
-	fc_release_transport(zfcp_data.scsi_transport_template);
+	fc_release_transport(zfcp_scsi_transport_template);
 	kmem_cache_destroy(zfcp_fc_req_cache);
 	kmem_cache_destroy(zfcp_fsf_qtcb_cache);
 }
@@ -413,7 +413,7 @@ struct zfcp_adapter *zfcp_adapter_enqueu
 	adapter->dma_parms.max_segment_size = ZFCP_QDIO_SBALE_LEN;
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
 
-	if (!zfcp_adapter_scsi_register(adapter))
+	if (!zfcp_scsi_adapter_register(adapter))
 		return adapter;
 
 failed:
@@ -430,7 +430,7 @@ void zfcp_adapter_unregister(struct zfcp
 	zfcp_destroy_adapter_work_queue(adapter);
 
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	zfcp_adapter_scsi_unregister(adapter);
+	zfcp_scsi_adapter_unregister(adapter);
 	sysfs_remove_group(&cdev->dev.kobj, &zfcp_sysfs_adapter_attrs);
 
 	zfcp_erp_thread_kill(adapter);
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -313,10 +313,4 @@ struct zfcp_fsf_req {
 	void			(*handler)(struct zfcp_fsf_req *);
 };
 
-/* driver data */
-struct zfcp_data {
-	struct scsi_host_template scsi_host_template;
-	struct scsi_transport_template *scsi_transport_template;
-};
-
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -141,9 +141,9 @@ extern struct zfcp_fsf_req *zfcp_fsf_get
 					     struct qdio_buffer *);
 
 /* zfcp_scsi.c */
-extern struct zfcp_data zfcp_data;
-extern int zfcp_adapter_scsi_register(struct zfcp_adapter *);
-extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
+extern struct scsi_transport_template *zfcp_scsi_transport_template;
+extern int zfcp_scsi_adapter_register(struct zfcp_adapter *);
+extern void zfcp_scsi_adapter_unregister(struct zfcp_adapter *);
 extern struct fc_function_template zfcp_transport_functions;
 extern void zfcp_scsi_rport_work(struct work_struct *);
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -292,7 +292,37 @@ static int zfcp_scsi_eh_host_reset_handl
 	return SUCCESS;
 }
 
-int zfcp_adapter_scsi_register(struct zfcp_adapter *adapter)
+struct scsi_transport_template *zfcp_scsi_transport_template;
+
+static struct scsi_host_template zfcp_scsi_host_template = {
+	.module			 = THIS_MODULE,
+	.name			 = "zfcp",
+	.queuecommand		 = zfcp_scsi_queuecommand,
+	.eh_abort_handler	 = zfcp_scsi_eh_abort_handler,
+	.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
+	.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
+	.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
+	.slave_alloc		 = zfcp_scsi_slave_alloc,
+	.slave_configure	 = zfcp_scsi_slave_configure,
+	.slave_destroy		 = zfcp_scsi_slave_destroy,
+	.change_queue_depth	 = zfcp_scsi_change_queue_depth,
+	.proc_name		 = "zfcp",
+	.can_queue		 = 4096,
+	.this_id		 = -1,
+	.sg_tablesize		 = ZFCP_QDIO_MAX_SBALES_PER_REQ,
+	.max_sectors		 = (ZFCP_QDIO_MAX_SBALES_PER_REQ * 8),
+	.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
+	.cmd_per_lun		 = 1,
+	.use_clustering		 = 1,
+	.shost_attrs		 = zfcp_sysfs_shost_attrs,
+	.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
+};
+
+/**
+ * zfcp_scsi_adapter_register - Register SCSI and FC host with SCSI midlayer
+ * @adapter: The zfcp adapter to register with the SCSI midlayer
+ */
+int zfcp_scsi_adapter_register(struct zfcp_adapter *adapter)
 {
 	struct ccw_dev_id dev_id;
 
@@ -301,7 +331,7 @@ int zfcp_adapter_scsi_register(struct zf
 
 	ccw_device_get_id(adapter->ccw_device, &dev_id);
 	/* register adapter as SCSI host with mid layer of SCSI stack */
-	adapter->scsi_host = scsi_host_alloc(&zfcp_data.scsi_host_template,
+	adapter->scsi_host = scsi_host_alloc(&zfcp_scsi_host_template,
 					     sizeof (struct zfcp_adapter *));
 	if (!adapter->scsi_host) {
 		dev_err(&adapter->ccw_device->dev,
@@ -316,7 +346,7 @@ int zfcp_adapter_scsi_register(struct zf
 	adapter->scsi_host->max_channel = 0;
 	adapter->scsi_host->unique_id = dev_id.devno;
 	adapter->scsi_host->max_cmd_len = 16; /* in struct fcp_cmnd */
-	adapter->scsi_host->transportt = zfcp_data.scsi_transport_template;
+	adapter->scsi_host->transportt = zfcp_scsi_transport_template;
 
 	adapter->scsi_host->hostdata[0] = (unsigned long) adapter;
 
@@ -328,7 +358,11 @@ int zfcp_adapter_scsi_register(struct zf
 	return 0;
 }
 
-void zfcp_adapter_scsi_unregister(struct zfcp_adapter *adapter)
+/**
+ * zfcp_scsi_adapter_unregister - Unregister SCSI and FC host from SCSI midlayer
+ * @adapter: The zfcp adapter to unregister.
+ */
+void zfcp_scsi_adapter_unregister(struct zfcp_adapter *adapter)
 {
 	struct Scsi_Host *shost;
 	struct zfcp_port *port;
@@ -346,8 +380,6 @@ void zfcp_adapter_scsi_unregister(struct
 	scsi_remove_host(shost);
 	scsi_host_put(shost);
 	adapter->scsi_host = NULL;
-
-	return;
 }
 
 static struct fc_host_statistics*
@@ -692,29 +724,3 @@ struct fc_function_template zfcp_transpo
 	.show_host_port_id = 1,
 	.dd_bsg_size = sizeof(struct zfcp_fsf_ct_els),
 };
-
-struct zfcp_data zfcp_data = {
-	.scsi_host_template = {
-		.name			 = "zfcp",
-		.module			 = THIS_MODULE,
-		.proc_name		 = "zfcp",
-		.change_queue_depth	 = zfcp_scsi_change_queue_depth,
-		.slave_alloc		 = zfcp_scsi_slave_alloc,
-		.slave_configure	 = zfcp_scsi_slave_configure,
-		.slave_destroy		 = zfcp_scsi_slave_destroy,
-		.queuecommand		 = zfcp_scsi_queuecommand,
-		.eh_abort_handler	 = zfcp_scsi_eh_abort_handler,
-		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
-		.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
-		.eh_host_reset_handler	 = zfcp_scsi_eh_host_reset_handler,
-		.can_queue		 = 4096,
-		.this_id		 = -1,
-		.sg_tablesize		 = ZFCP_QDIO_MAX_SBALES_PER_REQ,
-		.cmd_per_lun		 = 1,
-		.use_clustering		 = 1,
-		.sdev_attrs		 = zfcp_sysfs_sdev_attrs,
-		.max_sectors		 = (ZFCP_QDIO_MAX_SBALES_PER_REQ * 8),
-		.dma_boundary		 = ZFCP_QDIO_SBALE_LEN - 1,
-		.shost_attrs		 = zfcp_sysfs_shost_attrs,
-	},
-};

