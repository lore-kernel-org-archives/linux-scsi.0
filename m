From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 22/27] zfcp: Defer resource allocation to first ccw_set_online call
Date: Tue, 18 Aug 2009 15:43:27 +0200
Message-ID: <20090818135031.694162000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:57178 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758948AbZHRNub (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:31 -0400
Content-Disposition: inline; filename=cc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

So far, zfcp allocated all resources required for FCP
adapters/subchannels when the device was discovered in the ccw_probe
callback. If there are lots of unused FCP subchannels attached to a
system, this is a waste of resources. To alleviate this, defer the
resource allocation to the first call to ccw_set_online. To avoid
disruptions during possible following calls to ccw_set_offline and
then ccw_set_online, keep the adapter resources until the device is
finally being removed via ccw_remove. While doing this, also manage
the zfcp erp thread together with all other adapter resources in
zfcp_adapter_enqueue/dequeue.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-18 14:21:55.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-18 14:21:55.000000000 +0200
@@ -541,6 +541,9 @@ int zfcp_adapter_enqueue(struct ccw_devi
 	rwlock_init(&adapter->erp_lock);
 	rwlock_init(&adapter->abort_lock);
 
+	if (zfcp_erp_thread_setup(adapter))
+		goto erp_thread_failed;
+
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 	INIT_WORK(&adapter->scan_work, _zfcp_fc_scan_ports_later);
 
@@ -561,6 +564,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 		return 0;
 
 sysfs_failed:
+	zfcp_erp_thread_kill(adapter);
+erp_thread_failed:
 	zfcp_fc_gs_destroy(adapter);
 generic_services_failed:
 	zfcp_destroy_adapter_work_queue(adapter);
@@ -602,6 +607,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 		return;
 
 	zfcp_fc_gs_destroy(adapter);
+	zfcp_erp_thread_kill(adapter);
 	zfcp_destroy_adapter_work_queue(adapter);
 	zfcp_dbf_adapter_unregister(adapter->dbf);
 	zfcp_free_low_mem_buffers(adapter);
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-08-18 14:12:26.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-08-18 14:21:55.000000000 +0200
@@ -18,6 +18,9 @@ static int zfcp_ccw_suspend(struct ccw_d
 {
 	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
 
+	if (!adapter)
+		return 0;
+
 	down(&zfcp_data.config_sema);
 
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsusp1", NULL);
@@ -33,6 +36,9 @@ static int zfcp_ccw_activate(struct ccw_
 {
 	struct zfcp_adapter *adapter = dev_get_drvdata(&cdev->dev);
 
+	if (!adapter)
+		return 0;
+
 	zfcp_erp_modify_adapter_status(adapter, "ccresu1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
@@ -63,25 +69,14 @@ int zfcp_ccw_priv_sch(struct zfcp_adapte
  * zfcp_ccw_probe - probe function of zfcp driver
  * @ccw_device: pointer to belonging ccw device
  *
- * This function gets called by the common i/o layer and sets up the initial
- * data structures for each fcp adapter, which was detected by the system.
- * Also the sysfs files for this adapter will be created by this function.
- * In addition the nameserver port will be added to the ports of the adapter
- * and its sysfs representation will be created too.
+ * This function gets called by the common i/o layer for each FCP
+ * device found on the current system. This is only a stub to make cio
+ * work: To only allocate adapter resources for devices actually used,
+ * the allocation is deferred to the first call to ccw_set_online.
  */
 static int zfcp_ccw_probe(struct ccw_device *ccw_device)
 {
-	int retval = 0;
-
-	down(&zfcp_data.config_sema);
-	if (zfcp_adapter_enqueue(ccw_device)) {
-		dev_err(&ccw_device->dev,
-			"Setting up data structures for the "
-			"FCP adapter failed\n");
-		retval = -EINVAL;
-	}
-	up(&zfcp_data.config_sema);
-	return retval;
+	return 0;
 }
 
 /**
@@ -102,8 +97,11 @@ static void zfcp_ccw_remove(struct ccw_d
 	LIST_HEAD(port_remove_lh);
 
 	ccw_device_set_offline(ccw_device);
+
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
+	if (!adapter)
+		goto out;
 
 	write_lock_irq(&zfcp_data.config_lock);
 	list_for_each_entry_safe(port, p, &adapter->port_list_head, list) {
@@ -129,6 +127,7 @@ static void zfcp_ccw_remove(struct ccw_d
 	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
 	zfcp_adapter_dequeue(adapter);
 
+out:
 	up(&zfcp_data.config_sema);
 }
 
@@ -136,22 +135,33 @@ static void zfcp_ccw_remove(struct ccw_d
  * zfcp_ccw_set_online - set_online function of zfcp driver
  * @ccw_device: pointer to belonging ccw device
  *
- * This function gets called by the common i/o layer and sets an adapter
- * into state online. Setting an fcp device online means that it will be
- * registered with the SCSI stack, that the QDIO queues will be set up
- * and that the adapter will be opened (asynchronously).
+ * This function gets called by the common i/o layer and sets an
+ * adapter into state online.  The first call will allocate all
+ * adapter resources that will be retained until the device is removed
+ * via zfcp_ccw_remove.
+ *
+ * Setting an fcp device online means that it will be registered with
+ * the SCSI stack, that the QDIO queues will be set up and that the
+ * adapter will be opened.
  */
 static int zfcp_ccw_set_online(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
-	int retval;
+	int ret = 0;
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 
-	retval = zfcp_erp_thread_setup(adapter);
-	if (retval)
-		goto out;
+	if (!adapter) {
+		ret = zfcp_adapter_enqueue(ccw_device);
+		if (ret) {
+			dev_err(&ccw_device->dev,
+				"Setting up data structures for the "
+				"FCP adapter failed\n");
+			goto out;
+		}
+		adapter = dev_get_drvdata(&ccw_device->dev);
+	}
 
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
@@ -162,13 +172,11 @@ static int zfcp_ccw_set_online(struct cc
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
 				"ccsonl2", NULL);
 	zfcp_erp_wait(adapter);
+out:
 	up(&zfcp_data.config_sema);
-	flush_work(&adapter->scan_work);
-	return 0;
-
- out:
-	up(&zfcp_data.config_sema);
-	return retval;
+	if (!ret)
+		flush_work(&adapter->scan_work);
+	return ret;
 }
 
 /**
@@ -184,10 +192,13 @@ static int zfcp_ccw_set_offline(struct c
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
+	if (!adapter)
+		goto out;
+
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
-	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
+out:
 	return 0;
 }
 
@@ -244,6 +255,7 @@ static void zfcp_ccw_shutdown(struct ccw
 	adapter = dev_get_drvdata(&cdev->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
+	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
 }
 
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-18 14:21:55.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-18 14:21:55.000000000 +0200
@@ -150,6 +150,9 @@ static int zfcp_erp_required_act(int wan
 		a_status = atomic_read(&adapter->status);
 		if (a_status & ZFCP_STATUS_COMMON_ERP_INUSE)
 			return 0;
+		if (!(a_status & ZFCP_STATUS_COMMON_RUNNING) &&
+		    !(a_status & ZFCP_STATUS_COMMON_OPEN))
+			return 0; /* shutdown requested for closed adapter */
 	}
 
 	return need;
@@ -1349,6 +1352,8 @@ void zfcp_erp_thread_kill(struct zfcp_ad
 {
 	kthread_stop(adapter->erp_thread);
 	adapter->erp_thread = NULL;
+	WARN_ON(!list_empty(&adapter->erp_ready_head));
+	WARN_ON(!list_empty(&adapter->erp_running_head));
 }
 
 /**

