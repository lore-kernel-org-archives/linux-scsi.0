From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 23/27] zfcp: Replace config semaphore with mutex
Date: Tue, 18 Aug 2009 15:43:28 +0200
Message-ID: <20090818135031.834931000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49735 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758986AbZHRNuf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:35 -0400
Content-Disposition: inline; filename=727-zfcp-config-mutex.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The config semaphore is only used as a mutex, so replace it with a
simple mutex.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   22 +++++++++++-----------
 drivers/s390/scsi/zfcp_ccw.c   |   20 ++++++++++----------
 drivers/s390/scsi/zfcp_def.h   |    3 +--
 drivers/s390/scsi/zfcp_fc.c    |    4 ++--
 drivers/s390/scsi/zfcp_sysfs.c |   16 ++++++++--------
 5 files changed, 32 insertions(+), 33 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:30:21.000000000 +0200
@@ -84,7 +84,7 @@ static void __init zfcp_init_device_conf
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	read_lock_irq(&zfcp_data.config_lock);
 	adapter = zfcp_get_adapter_by_busid(busid);
 	if (adapter)
@@ -99,20 +99,20 @@ static void __init zfcp_init_device_conf
 	unit = zfcp_unit_enqueue(port, lun);
 	if (IS_ERR(unit))
 		goto out_unit;
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	ccw_device_set_online(adapter->ccw_device);
 
 	zfcp_erp_wait(adapter);
 	flush_work(&unit->scsi_work);
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	zfcp_unit_put(unit);
 out_unit:
 	zfcp_port_put(port);
 out_port:
 	zfcp_adapter_put(adapter);
 out_adapter:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	return;
 }
 
@@ -176,7 +176,7 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	sema_init(&zfcp_data.config_sema, 1);
+	mutex_init(&zfcp_data.config_mutex);
 	rwlock_init(&zfcp_data.config_lock);
 
 	zfcp_data.scsi_transport_template =
@@ -266,7 +266,7 @@ static void zfcp_sysfs_unit_release(stru
  * @port: pointer to port where unit is added
  * @fcp_lun: FCP LUN of unit to be enqueued
  * Returns: pointer to enqueued unit on success, ERR_PTR on error
- * Locks: config_sema must be held to serialize changes to the unit list
+ * Locks: config_mutex must be held to serialize changes to the unit list
  *
  * Sets up some unit internal structures and creates sysfs entry.
  */
@@ -356,7 +356,7 @@ void zfcp_unit_dequeue(struct zfcp_unit 
 
 static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
-	/* must only be called with zfcp_data.config_sema taken */
+	/* must only be called with zfcp_data.config_mutex taken */
 	adapter->pool.erp_req =
 		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
 	if (!adapter->pool.erp_req)
@@ -404,7 +404,7 @@ static int zfcp_allocate_low_mem_buffers
 
 static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
-	/* zfcp_data.config_sema must be held */
+	/* zfcp_data.config_mutex must be held */
 	if (adapter->pool.erp_req)
 		mempool_destroy(adapter->pool.erp_req);
 	if (adapter->pool.scsi_req)
@@ -491,7 +491,7 @@ static void zfcp_destroy_adapter_work_qu
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
  * Proc-fs entries are also created.
- * locks:	config_sema must be held to serialise changes to the adapter list
+ * locks: config_mutex must be held to serialize changes to the adapter list
  */
 int zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 {
@@ -499,7 +499,7 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	/*
 	 * Note: It is safe to release the list_lock, as any list changes
-	 * are protected by the config_sema, which must be held to get here
+	 * are protected by the config_mutex, which must be held to get here
 	 */
 
 	adapter = kzalloc(sizeof(struct zfcp_adapter), GFP_KERNEL);
@@ -630,7 +630,7 @@ static void zfcp_sysfs_port_release(stru
  * @status: initial status for the port
  * @d_id: destination id of the remote port to be enqueued
  * Returns: pointer to enqueued port on success, ERR_PTR on error
- * Locks: config_sema must be held to serialize changes to the port list
+ * Locks: config_mutex must be held to serialize changes to the port list
  *
  * All port internal structures are set up and the sysfs entry is generated.
  * d_id is used to enqueue ports with a well known address like the Directory
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-08-17 11:30:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-08-17 11:30:21.000000000 +0200
@@ -21,12 +21,12 @@ static int zfcp_ccw_suspend(struct ccw_d
 	if (!adapter)
 		return 0;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsusp1", NULL);
 	zfcp_erp_wait(adapter);
 
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 
 	return 0;
 }
@@ -98,7 +98,7 @@ static void zfcp_ccw_remove(struct ccw_d
 
 	ccw_device_set_offline(ccw_device);
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	if (!adapter)
 		goto out;
@@ -128,7 +128,7 @@ static void zfcp_ccw_remove(struct ccw_d
 	zfcp_adapter_dequeue(adapter);
 
 out:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 }
 
 /**
@@ -149,7 +149,7 @@ static int zfcp_ccw_set_online(struct cc
 	struct zfcp_adapter *adapter;
 	int ret = 0;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 
 	if (!adapter) {
@@ -173,7 +173,7 @@ static int zfcp_ccw_set_online(struct cc
 				"ccsonl2", NULL);
 	zfcp_erp_wait(adapter);
 out:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	if (!ret)
 		flush_work(&adapter->scan_work);
 	return ret;
@@ -190,14 +190,14 @@ static int zfcp_ccw_set_offline(struct c
 {
 	struct zfcp_adapter *adapter;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
 	if (!adapter)
 		goto out;
 
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 out:
 	return 0;
 }
@@ -251,12 +251,12 @@ static void zfcp_ccw_shutdown(struct ccw
 {
 	struct zfcp_adapter *adapter;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&cdev->dev);
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 }
 
 static struct ccw_driver zfcp_ccw_driver = {
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:30:18.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:30:21.000000000 +0200
@@ -604,8 +604,7 @@ struct zfcp_data {
 	rwlock_t                config_lock;        /* serialises changes
 						       to adapter/port/unit
 						       lists */
-	struct semaphore        config_sema;        /* serialises configuration
-						       changes */
+	struct mutex		config_mutex;
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:30:18.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:30:21.000000000 +0200
@@ -613,7 +613,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 		return -E2BIG;
 	}
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 
 	/* first entry is the header */
 	for (x = 1; x < max_entries && !last; x++) {
@@ -647,7 +647,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	zfcp_erp_wait(adapter);
 	list_for_each_entry_safe(port, tmp, &adapter->port_list_head, list)
 		zfcp_fc_validate_port(port);
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	return ret;
 }
 
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-08-17 11:29:48.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-08-17 11:30:21.000000000 +0200
@@ -88,7 +88,7 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 	unsigned long val;						       \
 	int retval = 0;							       \
 									       \
-	down(&zfcp_data.config_sema);					       \
+	mutex_lock(&zfcp_data.config_mutex);				       \
 	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_REMOVE) {	       \
 		retval = -EBUSY;					       \
 		goto out;						       \
@@ -105,7 +105,7 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 				  _reopen_id, NULL);			       \
 	zfcp_erp_wait(_adapter);					       \
 out:									       \
-	up(&zfcp_data.config_sema);					       \
+	mutex_unlock(&zfcp_data.config_mutex);				       \
 	return retval ? retval : (ssize_t) count;			       \
 }									       \
 static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
@@ -142,7 +142,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	int retval = 0;
 	LIST_HEAD(port_remove_lh);
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -173,7 +173,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
  out:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
 }
 static ZFCP_DEV_ATTR(adapter, port_remove, S_IWUSR, NULL,
@@ -207,7 +207,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 	u64 fcp_lun;
 	int retval = -EINVAL;
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -226,7 +226,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
 out:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
@@ -241,7 +241,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	int retval = 0;
 	LIST_HEAD(unit_remove_lh);
 
-	down(&zfcp_data.config_sema);
+	mutex_lock(&zfcp_data.config_mutex);
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE) {
 		retval = -EBUSY;
 		goto out;
@@ -282,7 +282,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	zfcp_unit_put(unit);
 	zfcp_unit_dequeue(unit);
 out:
-	up(&zfcp_data.config_sema);
+	mutex_unlock(&zfcp_data.config_mutex);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);

