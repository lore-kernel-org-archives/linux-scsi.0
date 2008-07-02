From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/11] zfcp: Cleanup of code in zfcp_aux.c
Date: Wed, 02 Jul 2008 10:56:37 +0200
Message-ID: <20080702085951.767589000@de.ibm.com>
References: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58292 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYGBJAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 05:00:47 -0400
Content-Disposition: inline; filename=aux-cleanup.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Overall cleanup of zfcp_aux.c to simplify code and follow kernel
coding style.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c        |  583 +++++++++++++-----------------------
 drivers/s390/scsi/zfcp_ccw.c        |    4 
 drivers/s390/scsi/zfcp_def.h        |   13 
 drivers/s390/scsi/zfcp_erp.c        |    2 
 drivers/s390/scsi/zfcp_ext.h        |    4 
 drivers/s390/scsi/zfcp_fc.c         |   18 -
 drivers/s390/scsi/zfcp_sysfs_port.c |    2 
 7 files changed, 238 insertions(+), 388 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-07-02 10:31:52.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-07-02 10:41:23.000000000 +0200
@@ -29,48 +29,14 @@
 #include "zfcp_ext.h"
 
 static char *device;
-/*********************** FUNCTION PROTOTYPES *********************************/
-
-/* written against the module interface */
-static int __init  zfcp_module_init(void);
-
-/*********************** KERNEL/MODULE PARAMETERS  ***************************/
-
-/* declare driver module init/cleanup functions */
-module_init(zfcp_module_init);
 
 MODULE_AUTHOR("IBM Deutschland Entwicklung GmbH - linux390@de.ibm.com");
-MODULE_DESCRIPTION
-    ("FCP (SCSI over Fibre Channel) HBA driver for IBM System z9 and zSeries");
+MODULE_DESCRIPTION("FCP HBA driver");
 MODULE_LICENSE("GPL");
 
 module_param(device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
-/****************************************************************/
-/************** Functions without logging ***********************/
-/****************************************************************/
-
-void
-_zfcp_hex_dump(char *addr, int count)
-{
-	int i;
-	for (i = 0; i < count; i++) {
-		printk("%02x", addr[i]);
-		if ((i % 4) == 3)
-			printk(" ");
-		if ((i % 32) == 31)
-			printk("\n");
-	}
-	if (((i-1) % 32) != 31)
-		printk("\n");
-}
-
-
-/****************************************************************/
-/****** Functions to handle the request ID hash table    ********/
-/****************************************************************/
-
 static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
 {
 	int idx;
@@ -85,11 +51,12 @@ static int zfcp_reqlist_alloc(struct zfc
 	return 0;
 }
 
-static void zfcp_reqlist_free(struct zfcp_adapter *adapter)
-{
-	kfree(adapter->req_list);
-}
-
+/**
+ * zfcp_reqlist_isempty - is the request list empty
+ * @adapter: pointer to struct zfcp_adapter
+ *
+ * Returns: true if list is empty, false otherwise
+ */
 int zfcp_reqlist_isempty(struct zfcp_adapter *adapter)
 {
 	unsigned int idx;
@@ -100,62 +67,58 @@ int zfcp_reqlist_isempty(struct zfcp_ada
 	return 1;
 }
 
-/****************************************************************/
-/************** Uncategorised Functions *************************/
-/****************************************************************/
-
-/**
- * zfcp_device_setup - setup function
- * @str: pointer to parameter string
- *
- * Parse "device=..." parameter string.
- */
-static int __init
-zfcp_device_setup(char *devstr)
+static int __init zfcp_device_setup(char *devstr)
 {
-	char *tmp, *str;
-	size_t len;
+	char *token;
+	char *str;
 
 	if (!devstr)
 		return 0;
 
-	len = strlen(devstr) + 1;
-	str = kmalloc(len, GFP_KERNEL);
-	if (!str) {
-		pr_err("zfcp: Could not allocate memory for "
-		       "device parameter string, device not attached.\n");
+	/* duplicate devstr and keep the original for sysfs presentation*/
+	str = kmalloc(strlen(devstr) + 1, GFP_KERNEL);
+	if (!str)
 		return 0;
-	}
-	memcpy(str, devstr, len);
 
-	tmp = strchr(str, ',');
-	if (!tmp)
-		goto err_out;
-	*tmp++ = '\0';
-	strncpy(zfcp_data.init_busid, str, BUS_ID_SIZE);
-	zfcp_data.init_busid[BUS_ID_SIZE-1] = '\0';
+	strcpy(str, devstr);
 
-	zfcp_data.init_wwpn = simple_strtoull(tmp, &tmp, 0);
-	if (*tmp++ != ',')
+	token = strsep(&str, ",");
+	if (!token || strlen(token) >= BUS_ID_SIZE)
 		goto err_out;
-	if (*tmp == '\0')
+	strncpy(zfcp_data.init_busid, token, BUS_ID_SIZE);
+
+	token = strsep(&str, ",");
+	if (!token || strict_strtoull(token, 0, &zfcp_data.init_wwpn))
 		goto err_out;
 
-	zfcp_data.init_fcp_lun = simple_strtoull(tmp, &tmp, 0);
-	if (*tmp != '\0')
+	token = strsep(&str, ",");
+	if (!token || strict_strtoull(token, 0, &zfcp_data.init_fcp_lun))
 		goto err_out;
+
 	kfree(str);
 	return 1;
 
  err_out:
-	pr_err("zfcp: Parse error for device parameter string %s, "
-	       "device not attached.\n", str);
 	kfree(str);
+	pr_err("zfcp: Parse error for device parameter string %s, "
+	       "device not attached.\n", devstr);
 	return 0;
 }
 
-static void __init
-zfcp_init_device_configure(void)
+static struct zfcp_adapter *zfcp_get_adapter_by_busid(char *bus_id)
+{
+	struct zfcp_adapter *adapter;
+
+	list_for_each_entry(adapter, &zfcp_data.adapter_list_head, list)
+		if ((strncmp(bus_id, adapter->ccw_device->dev.bus_id,
+			     BUS_ID_SIZE) == 0) &&
+		    !(atomic_read(&adapter->status) &
+		      ZFCP_STATUS_COMMON_REMOVE))
+		    return adapter;
+	return NULL;
+}
+
+static void __init zfcp_init_device_configure(void)
 {
 	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
@@ -168,92 +131,72 @@ zfcp_init_device_configure(void)
 		zfcp_adapter_get(adapter);
 	read_unlock_irq(&zfcp_data.config_lock);
 
-	if (adapter == NULL)
+	if (!adapter)
 		goto out_adapter;
 	port = zfcp_port_enqueue(adapter, zfcp_data.init_wwpn, 0, 0);
-	if (!port)
+	if (IS_ERR(port))
 		goto out_port;
 	unit = zfcp_unit_enqueue(port, zfcp_data.init_fcp_lun);
-	if (!unit)
+	if (IS_ERR(unit))
 		goto out_unit;
 	up(&zfcp_data.config_sema);
 	ccw_device_set_online(adapter->ccw_device);
 	zfcp_erp_wait(adapter);
 	down(&zfcp_data.config_sema);
 	zfcp_unit_put(unit);
- out_unit:
+out_unit:
 	zfcp_port_put(port);
- out_port:
+out_port:
 	zfcp_adapter_put(adapter);
- out_adapter:
+out_adapter:
 	up(&zfcp_data.config_sema);
 	return;
 }
 
-static int calc_alignment(int size)
+static struct kmem_cache *zfcp_cache_create(int size, char *name)
 {
 	int align = 1;
-
-	if (!size)
-		return 0;
-
 	while ((size - align) > 0)
 		align <<= 1;
-
-	return align;
+	return kmem_cache_create(name , size, align, 0, NULL);
 }
 
-static int __init
-zfcp_module_init(void)
+static int __init zfcp_module_init(void)
 {
 	int retval = -ENOMEM;
-	int size, align;
 
-	size = sizeof(struct zfcp_fsf_req_qtcb);
-	align = calc_alignment(size);
-	zfcp_data.fsf_req_qtcb_cache =
-		kmem_cache_create("zfcp_fsf", size, align, 0, NULL);
+	zfcp_data.fsf_req_qtcb_cache = zfcp_cache_create(
+			sizeof(struct zfcp_fsf_req_qtcb), "zfcp_fsf");
 	if (!zfcp_data.fsf_req_qtcb_cache)
 		goto out;
 
-	size = sizeof(struct fsf_status_read_buffer);
-	align = calc_alignment(size);
-	zfcp_data.sr_buffer_cache =
-		kmem_cache_create("zfcp_sr", size, align, 0, NULL);
+	zfcp_data.sr_buffer_cache = zfcp_cache_create(
+			sizeof(struct fsf_status_read_buffer), "zfcp_sr");
 	if (!zfcp_data.sr_buffer_cache)
 		goto out_sr_cache;
 
-	size = sizeof(struct zfcp_gid_pn_data);
-	align = calc_alignment(size);
-	zfcp_data.gid_pn_cache =
-		kmem_cache_create("zfcp_gid", size, align, 0, NULL);
+	zfcp_data.gid_pn_cache = zfcp_cache_create(
+			sizeof(struct zfcp_gid_pn_data), "zfcp_gid");
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	/* initialize adapter list */
 	INIT_LIST_HEAD(&zfcp_data.adapter_list_head);
-
-	/* initialize adapters to be removed list head */
 	INIT_LIST_HEAD(&zfcp_data.adapter_remove_lh);
 
+	sema_init(&zfcp_data.config_sema, 1);
+	rwlock_init(&zfcp_data.config_lock);
+
 	zfcp_data.scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
 	if (!zfcp_data.scsi_transport_template)
 		goto out_transport;
 
 	retval = misc_register(&zfcp_cfdc_misc);
-	if (retval != 0) {
+	if (retval) {
 		pr_err("zfcp: registration of misc device zfcp_cfdc failed\n");
 		goto out_misc;
 	}
 
-	/* Initialise proc semaphores */
-	sema_init(&zfcp_data.config_sema, 1);
-
-	/* initialise configuration rw lock */
-	rwlock_init(&zfcp_data.config_lock);
-
-	/* setup dynamic I/O */
 	retval = zfcp_ccw_register();
 	if (retval) {
 		pr_err("zfcp: Registration with common I/O layer failed.\n");
@@ -265,157 +208,83 @@ zfcp_module_init(void)
 
 	goto out;
 
- out_ccw_register:
+out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
- out_misc:
+out_misc:
 	fc_release_transport(zfcp_data.scsi_transport_template);
- out_transport:
+out_transport:
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
- out_gid_cache:
+out_gid_cache:
 	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
- out_sr_cache:
+out_sr_cache:
 	kmem_cache_destroy(zfcp_data.fsf_req_qtcb_cache);
- out:
+out:
 	return retval;
 }
 
-/****************************************************************/
-/****** Functions for configuration/set-up of structures ********/
-/****************************************************************/
+module_init(zfcp_module_init);
 
 /**
  * zfcp_get_unit_by_lun - find unit in unit list of port by FCP LUN
  * @port: pointer to port to search for unit
  * @fcp_lun: FCP LUN to search for
- * Traverse list of all units of a port and return pointer to a unit
- * with the given FCP LUN.
+ *
+ * Returns: pointer to zfcp_unit or NULL
  */
-struct zfcp_unit *
-zfcp_get_unit_by_lun(struct zfcp_port *port, fcp_lun_t fcp_lun)
+struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *port,
+				       fcp_lun_t fcp_lun)
 {
 	struct zfcp_unit *unit;
-	int found = 0;
 
-	list_for_each_entry(unit, &port->unit_list_head, list) {
+	list_for_each_entry(unit, &port->unit_list_head, list)
 		if ((unit->fcp_lun == fcp_lun) &&
-		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status))
-		{
-			found = 1;
-			break;
-		}
-	}
-	return found ? unit : NULL;
+		    !(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_REMOVE))
+		    return unit;
+	return NULL;
 }
 
 /**
  * zfcp_get_port_by_wwpn - find port in port list of adapter by wwpn
  * @adapter: pointer to adapter to search for port
  * @wwpn: wwpn to search for
- * Traverse list of all ports of an adapter and return pointer to a port
- * with the given wwpn.
+ *
+ * Returns: pointer to zfcp_port or NULL
  */
-struct zfcp_port *
-zfcp_get_port_by_wwpn(struct zfcp_adapter *adapter, wwn_t wwpn)
+struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *adapter,
+					wwn_t wwpn)
 {
 	struct zfcp_port *port;
-	int found = 0;
 
-	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if ((port->wwpn == wwpn) &&
-		    !(atomic_read(&port->status) &
-		      (ZFCP_STATUS_PORT_NO_WWPN | ZFCP_STATUS_COMMON_REMOVE))) {
-			found = 1;
-			break;
-		}
-	}
-	return found ? port : NULL;
-}
-
-/**
- * zfcp_get_port_by_did - find port in port list of adapter by d_id
- * @adapter: pointer to adapter to search for port
- * @d_id: d_id to search for
- * Traverse list of all ports of an adapter and return pointer to a port
- * with the given d_id.
- */
-struct zfcp_port *
-zfcp_get_port_by_did(struct zfcp_adapter *adapter, u32 d_id)
-{
-	struct zfcp_port *port;
-	int found = 0;
-
-	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if ((port->d_id == d_id) &&
-		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status))
-		{
-			found = 1;
-			break;
-		}
-	}
-	return found ? port : NULL;
-}
-
-/**
- * zfcp_get_adapter_by_busid - find adpater in adapter list by bus_id
- * @bus_id: bus_id to search for
- * Traverse list of all adapters and return pointer to an adapter
- * with the given bus_id.
- */
-struct zfcp_adapter *
-zfcp_get_adapter_by_busid(char *bus_id)
-{
-	struct zfcp_adapter *adapter;
-	int found = 0;
-
-	list_for_each_entry(adapter, &zfcp_data.adapter_list_head, list) {
-		if ((strncmp(bus_id, zfcp_get_busid_by_adapter(adapter),
-			     BUS_ID_SIZE) == 0) &&
-		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE,
-				      &adapter->status)){
-			found = 1;
-			break;
-		}
-	}
-	return found ? adapter : NULL;
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if ((port->wwpn == wwpn) && !(atomic_read(&port->status) &
+		      (ZFCP_STATUS_PORT_NO_WWPN | ZFCP_STATUS_COMMON_REMOVE)))
+			return port;
+	return NULL;
 }
 
 /**
  * zfcp_unit_enqueue - enqueue unit to unit list of a port.
  * @port: pointer to port where unit is added
  * @fcp_lun: FCP LUN of unit to be enqueued
- * Return: pointer to enqueued unit on success, NULL on error
+ * Returns: pointer to enqueued unit on success, ERR_PTR on error
  * Locks: config_sema must be held to serialize changes to the unit list
  *
  * Sets up some unit internal structures and creates sysfs entry.
  */
-struct zfcp_unit *
-zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
+struct zfcp_unit *zfcp_unit_enqueue(struct zfcp_port *port, fcp_lun_t fcp_lun)
 {
 	struct zfcp_unit *unit;
 
-	/*
-	 * check that there is no unit with this FCP_LUN already in list
-	 * and enqueue it.
-	 * Note: Unlike for the adapter and the port, this is an error
-	 */
-	read_lock_irq(&zfcp_data.config_lock);
-	unit = zfcp_get_unit_by_lun(port, fcp_lun);
-	read_unlock_irq(&zfcp_data.config_lock);
-	if (unit)
-		return NULL;
-
-	unit = kzalloc(sizeof (struct zfcp_unit), GFP_KERNEL);
+	unit = kzalloc(sizeof(struct zfcp_unit), GFP_KERNEL);
 	if (!unit)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
-	/* initialise reference count stuff */
 	atomic_set(&unit->refcount, 0);
 	init_waitqueue_head(&unit->remove_wq);
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
 
-	/* setup for sysfs registration */
 	snprintf(unit->sysfs_device.bus_id, BUS_ID_SIZE, "0x%016llx", fcp_lun);
 	unit->sysfs_device.parent = &port->sysfs_device;
 	unit->sysfs_device.release = zfcp_sysfs_unit_release;
@@ -432,14 +301,19 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
 	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
 
-	if (device_register(&unit->sysfs_device)) {
-		kfree(unit);
-		return NULL;
+	read_lock_irq(&zfcp_data.config_lock);
+	if (zfcp_get_unit_by_lun(port, fcp_lun)) {
+		read_unlock_irq(&zfcp_data.config_lock);
+		goto err_out_free;
 	}
+	read_unlock_irq(&zfcp_data.config_lock);
+
+	if (device_register(&unit->sysfs_device))
+		goto err_out_free;
 
 	if (zfcp_sysfs_unit_create_files(&unit->sysfs_device)) {
 		device_unregister(&unit->sysfs_device);
-		return NULL;
+		return ERR_PTR(-EIO);
 	}
 
 	zfcp_unit_get(unit);
@@ -449,16 +323,27 @@ zfcp_unit_enqueue(struct zfcp_port *port
 	list_add_tail(&unit->list, &port->unit_list_head);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);
 	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
+
 	write_unlock_irq(&zfcp_data.config_lock);
 
 	port->units++;
 	zfcp_port_get(port);
 
 	return unit;
+
+err_out_free:
+	kfree(unit);
+	return ERR_PTR(-EINVAL);
 }
 
-void
-zfcp_unit_dequeue(struct zfcp_unit *unit)
+/**
+ * zfcp_unit_dequeue - dequeue unit
+ * @unit: pointer to zfcp_unit
+ *
+ * waits until all work is done on unit and removes it then from the unit->list
+ * of the associated port.
+ */
+void zfcp_unit_dequeue(struct zfcp_unit *unit)
 {
 	zfcp_unit_wait(unit);
 	write_lock_irq(&zfcp_data.config_lock);
@@ -470,64 +355,47 @@ zfcp_unit_dequeue(struct zfcp_unit *unit
 	device_unregister(&unit->sysfs_device);
 }
 
-/*
- * Allocates a combined QTCB/fsf_req buffer for erp actions and fcp/SCSI
- * commands.
- * It also genrates fcp-nameserver request/response buffer and unsolicited
- * status read fsf_req buffers.
- *
- * locks:       must only be called with zfcp_data.config_sema taken
- */
-static int
-zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
+static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
+	/* must only be called with zfcp_data.config_sema taken */
 	adapter->pool.fsf_req_erp =
-		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_ERP_NR,
-					 zfcp_data.fsf_req_qtcb_cache);
+		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_erp)
 		return -ENOMEM;
 
 	adapter->pool.fsf_req_scsi =
-		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_SCSI_NR,
-					 zfcp_data.fsf_req_qtcb_cache);
+		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_scsi)
 		return -ENOMEM;
 
 	adapter->pool.fsf_req_abort =
-		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_ABORT_NR,
-					 zfcp_data.fsf_req_qtcb_cache);
+		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_abort)
 		return -ENOMEM;
 
 	adapter->pool.fsf_req_status_read =
-		mempool_create_kmalloc_pool(ZFCP_POOL_STATUS_READ_NR,
+		mempool_create_kmalloc_pool(FSF_STATUS_READS_RECOM,
 					    sizeof(struct zfcp_fsf_req));
 	if (!adapter->pool.fsf_req_status_read)
 		return -ENOMEM;
 
 	adapter->pool.data_status_read =
-		mempool_create_slab_pool(ZFCP_POOL_STATUS_READ_NR,
+		mempool_create_slab_pool(FSF_STATUS_READS_RECOM,
 					 zfcp_data.sr_buffer_cache);
 	if (!adapter->pool.data_status_read)
 		return -ENOMEM;
 
 	adapter->pool.data_gid_pn =
-		mempool_create_slab_pool(ZFCP_POOL_DATA_GID_PN_NR,
-					 zfcp_data.gid_pn_cache);
+		mempool_create_slab_pool(1, zfcp_data.gid_pn_cache);
 	if (!adapter->pool.data_gid_pn)
 		return -ENOMEM;
 
 	return 0;
 }
 
-/**
- * zfcp_free_low_mem_buffers - free memory pools of an adapter
- * @adapter: pointer to zfcp_adapter for which memory pools should be freed
- * locking:  zfcp_data.config_sema must be held
- */
-static void
-zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
+static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
+	/* zfcp_data.config_sema must be held */
 	if (adapter->pool.fsf_req_erp)
 		mempool_destroy(adapter->pool.fsf_req_erp);
 	if (adapter->pool.fsf_req_scsi)
@@ -547,6 +415,15 @@ static void zfcp_dummy_release(struct de
 	return;
 }
 
+/**
+ * zfcp_status_read_refill - refill the long running status_read_requests
+ * @adapter: ptr to struct zfcp_adapter for which the buffers should be refilled
+ *
+ * Returns: 0 on success, 1 otherwise
+ *
+ * if there are 16 or more status_read requests missing an adapter_reopen
+ * is triggered
+ */
 int zfcp_status_read_refill(struct zfcp_adapter *adapter)
 {
 	while (atomic_read(&adapter->stat_miss) > 0)
@@ -573,27 +450,25 @@ static int zfcp_nameserver_enqueue(struc
 
 	port = zfcp_port_enqueue(adapter, 0, ZFCP_STATUS_PORT_WKA,
 				 ZFCP_DID_DIRECTORY_SERVICE);
-	if (!port)
-		return -ENXIO;
+	if (IS_ERR(port))
+		return PTR_ERR(port);
 	zfcp_port_put(port);
 
 	return 0;
 }
 
-/*
+/**
+ * zfcp_adapter_enqueue - enqueue a new adapter to the list
+ * @ccw_device: pointer to the struct cc_device
+ *
+ * Returns:	0             if a new adapter was successfully enqueued
+ *		-ENOMEM       if alloc failed
  * Enqueues an adapter at the end of the adapter list in the driver data.
  * All adapter internal structures are set up.
  * Proc-fs entries are also created.
- *
- * FIXME: Use -ENOMEM as return code for allocation failures
- *
- * returns:	0             if a new adapter was successfully enqueued
- *              ZFCP_KNOWN    if an adapter with this devno was already present
- *		-ENOMEM       if alloc failed
  * locks:	config_sema must be held to serialise changes to the adapter list
  */
-struct zfcp_adapter *
-zfcp_adapter_enqueue(struct ccw_device *ccw_device)
+int zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 {
 	struct zfcp_adapter *adapter;
 
@@ -602,15 +477,13 @@ zfcp_adapter_enqueue(struct ccw_device *
 	 * are protected by the config_sema, which must be held to get here
 	 */
 
-	/* try to allocate new adapter data structure (zeroed) */
-	adapter = kzalloc(sizeof (struct zfcp_adapter), GFP_KERNEL);
+	adapter = kzalloc(sizeof(struct zfcp_adapter), GFP_KERNEL);
 	if (!adapter)
-		goto out;
+		return -ENOMEM;
 
 	ccw_device->handler = NULL;
-
-	/* save ccw_device pointer */
 	adapter->ccw_device = ccw_device;
+	atomic_set(&adapter->refcount, 0);
 
 	if (zfcp_qdio_allocate(adapter))
 		goto qdio_allocate_failed;
@@ -618,47 +491,34 @@ zfcp_adapter_enqueue(struct ccw_device *
 	if (zfcp_allocate_low_mem_buffers(adapter))
 		goto failed_low_mem_buffers;
 
-	/* initialise reference count stuff */
-	atomic_set(&adapter->refcount, 0);
+	if (zfcp_reqlist_alloc(adapter))
+		goto failed_low_mem_buffers;
+
+	if (zfcp_adapter_debug_register(adapter))
+		goto debug_register_failed;
+
 	init_waitqueue_head(&adapter->remove_wq);
+	init_waitqueue_head(&adapter->erp_thread_wqh);
+	init_waitqueue_head(&adapter->erp_done_wqh);
 
-	/* initialise list of ports */
 	INIT_LIST_HEAD(&adapter->port_list_head);
-
-	/* initialise list of ports to be removed */
 	INIT_LIST_HEAD(&adapter->port_remove_lh);
+	INIT_LIST_HEAD(&adapter->erp_ready_head);
+	INIT_LIST_HEAD(&adapter->erp_running_head);
 
-	/* initialize list of fsf requests */
 	spin_lock_init(&adapter->req_list_lock);
-	if (zfcp_reqlist_alloc(adapter))
-		goto failed_low_mem_buffers;
-
-	/* initialize debug locks */
 
 	spin_lock_init(&adapter->hba_dbf_lock);
 	spin_lock_init(&adapter->san_dbf_lock);
 	spin_lock_init(&adapter->scsi_dbf_lock);
 	spin_lock_init(&adapter->rec_dbf_lock);
 
-	if (zfcp_adapter_debug_register(adapter))
-		goto debug_register_failed;
-
-	/* initialize error recovery stuff */
-
 	rwlock_init(&adapter->erp_lock);
-	sema_init(&adapter->erp_ready_sem, 0);
-	INIT_LIST_HEAD(&adapter->erp_ready_head);
-	INIT_LIST_HEAD(&adapter->erp_running_head);
-
-	/* initialize abort lock */
 	rwlock_init(&adapter->abort_lock);
+	rwlock_init(&adapter->req_q.lock);
 
-	/* initialise some erp stuff */
-	init_waitqueue_head(&adapter->erp_thread_wqh);
-	init_waitqueue_head(&adapter->erp_done_wqh);
+	sema_init(&adapter->erp_ready_sem, 0);
 
-	/* initialize lock of associated request queue */
-	rwlock_init(&adapter->req_q.lock);
 	INIT_WORK(&adapter->stat_work, _zfcp_status_read_scheduler);
 	INIT_WORK(&adapter->scan_work, _zfcp_scan_ports_later);
 
@@ -678,7 +538,6 @@ zfcp_adapter_enqueue(struct ccw_device *
 	if (device_register(&adapter->generic_services))
 		goto generic_services_failed;
 
-	/* put allocated adapter at list tail */
 	write_lock_irq(&zfcp_data.config_lock);
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 	list_add_tail(&adapter->list, &zfcp_data.adapter_list_head);
@@ -688,33 +547,29 @@ zfcp_adapter_enqueue(struct ccw_device *
 
 	zfcp_nameserver_enqueue(adapter);
 
-	goto out;
+	return 0;
 
- generic_services_failed:
+generic_services_failed:
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
- sysfs_failed:
+sysfs_failed:
 	zfcp_adapter_debug_unregister(adapter);
- debug_register_failed:
+debug_register_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
-	zfcp_reqlist_free(adapter);
- failed_low_mem_buffers:
+	kfree(adapter->req_list);
+failed_low_mem_buffers:
 	zfcp_free_low_mem_buffers(adapter);
- qdio_allocate_failed:
+qdio_allocate_failed:
 	zfcp_qdio_free(adapter);
 	kfree(adapter);
-	adapter = NULL;
- out:
-	return adapter;
+	return -ENOMEM;
 }
 
-/*
- * returns:	0 - struct zfcp_adapter  data structure successfully removed
- *		!0 - struct zfcp_adapter  data structure could not be removed
- *			(e.g. still used)
+/**
+ * zfcp_adapter_dequeue - remove the adapter from the resource list
+ * @adapter: pointer to struct zfcp_adapter which should be removed
  * locks:	adapter list write lock is assumed to be held by caller
  */
-void
-zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
+void zfcp_adapter_dequeue(struct zfcp_adapter *adapter)
 {
 	int retval = 0;
 	unsigned long flags;
@@ -729,10 +584,8 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	spin_lock_irqsave(&adapter->req_list_lock, flags);
 	retval = zfcp_reqlist_isempty(adapter);
 	spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-	if (!retval) {
-		retval = -EBUSY;
-		goto out;
-	}
+	if (!retval)
+		return;
 
 	zfcp_adapter_debug_unregister(adapter);
 
@@ -747,12 +600,10 @@ zfcp_adapter_dequeue(struct zfcp_adapter
 	zfcp_qdio_free(adapter);
 
 	zfcp_free_low_mem_buffers(adapter);
-	zfcp_reqlist_free(adapter);
+	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
 	kfree(adapter);
- out:
-	return;
 }
 
 /**
@@ -761,77 +612,58 @@ zfcp_adapter_dequeue(struct zfcp_adapter
  * @wwpn: WWPN of the remote port to be enqueued
  * @status: initial status for the port
  * @d_id: destination id of the remote port to be enqueued
- * Return: pointer to enqueued port on success, NULL on error
+ * Returns: pointer to enqueued port on success, ERR_PTR on error
  * Locks: config_sema must be held to serialize changes to the port list
  *
  * All port internal structures are set up and the sysfs entry is generated.
  * d_id is used to enqueue ports with a well known address like the Directory
  * Service for nameserver lookup.
  */
-struct zfcp_port *
-zfcp_port_enqueue(struct zfcp_adapter *adapter, wwn_t wwpn, u32 status,
-		  u32 d_id)
+struct zfcp_port *zfcp_port_enqueue(struct zfcp_adapter *adapter, wwn_t wwpn,
+				     u32 status, u32 d_id)
 {
 	struct zfcp_port *port;
-	int check_wwpn;
+	char *bus_id;
 
-	check_wwpn = !(status & ZFCP_STATUS_PORT_NO_WWPN);
-	/*
-	 * check that there is no port with this WWPN already in list
-	 */
-	if (check_wwpn) {
-		read_lock_irq(&zfcp_data.config_lock);
-		port = zfcp_get_port_by_wwpn(adapter, wwpn);
-		read_unlock_irq(&zfcp_data.config_lock);
-		if (port)
-			return NULL;
-	}
-
-	port = kzalloc(sizeof (struct zfcp_port), GFP_KERNEL);
+	port = kzalloc(sizeof(struct zfcp_port), GFP_KERNEL);
 	if (!port)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
-	/* initialise reference count stuff */
-	atomic_set(&port->refcount, 0);
 	init_waitqueue_head(&port->remove_wq);
 
 	INIT_LIST_HEAD(&port->unit_list_head);
 	INIT_LIST_HEAD(&port->unit_remove_lh);
 
 	port->adapter = adapter;
+	port->d_id = d_id;
+	port->wwpn = wwpn;
 
-	if (check_wwpn)
-		port->wwpn = wwpn;
-
-	atomic_set_mask(status, &port->status);
+	/* mark port unusable as long as sysfs registration is not complete */
+	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
+	atomic_set(&port->refcount, 0);
 
-	/* setup for sysfs registration */
 	if (status & ZFCP_STATUS_PORT_WKA) {
 		switch (d_id) {
 		case ZFCP_DID_DIRECTORY_SERVICE:
-			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
-				 "directory");
+			bus_id = "directory";
 			break;
 		case ZFCP_DID_MANAGEMENT_SERVICE:
-			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
-				 "management");
+			bus_id = "management";
 			break;
 		case ZFCP_DID_KEY_DISTRIBUTION_SERVICE:
-			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
-				 "key_distribution");
+			bus_id = "key_distribution";
 			break;
 		case ZFCP_DID_ALIAS_SERVICE:
-			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
-				 "alias");
+			bus_id = "alias";
 			break;
 		case ZFCP_DID_TIME_SERVICE:
-			snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE,
-				 "time");
+			bus_id = "time";
 			break;
 		default:
 			kfree(port);
-			return NULL;
+			return ERR_PTR(-EINVAL);
 		}
+		snprintf(port->sysfs_device.bus_id, BUS_ID_SIZE, "%s", bus_id);
 		port->sysfs_device.parent = &adapter->generic_services;
 	} else {
 		snprintf(port->sysfs_device.bus_id,
@@ -839,22 +671,23 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 		port->sysfs_device.parent = &adapter->ccw_device->dev;
 	}
 
-	port->d_id = d_id;
-
 	port->sysfs_device.release = zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
 
-	/* mark port unusable as long as sysfs registration is not complete */
-	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status);
+	read_lock_irq(&zfcp_data.config_lock);
+	if (!(status & ZFCP_STATUS_PORT_NO_WWPN))
+		if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
+			read_unlock_irq(&zfcp_data.config_lock);
+			goto err_out_free;
+		}
+	read_unlock_irq(&zfcp_data.config_lock);
 
-	if (device_register(&port->sysfs_device)) {
-		kfree(port);
-		return NULL;
-	}
+	if (device_register(&port->sysfs_device))
+		goto err_out_free;
 
 	if (zfcp_sysfs_port_create_files(&port->sysfs_device, status)) {
 		device_unregister(&port->sysfs_device);
-		return NULL;
+		goto err_out;
 	}
 
 	zfcp_port_get(port);
@@ -867,15 +700,23 @@ zfcp_port_enqueue(struct zfcp_adapter *a
 		if (!adapter->nameserver_port)
 			adapter->nameserver_port = port;
 	adapter->ports++;
+
 	write_unlock_irq(&zfcp_data.config_lock);
 
 	zfcp_adapter_get(adapter);
-
 	return port;
+
+err_out_free:
+	kfree(port);
+err_out:
+	return ERR_PTR(-EINVAL);
 }
 
-void
-zfcp_port_dequeue(struct zfcp_port *port)
+/**
+ * zfcp_port_dequeue - dequeues a port from the port list of the adapter
+ * @port: pointer to struct zfcp_port which should be removed
+ */
+void zfcp_port_dequeue(struct zfcp_port *port)
 {
 	zfcp_port_wait(port);
 	write_lock_irq(&zfcp_data.config_lock);
@@ -891,6 +732,12 @@ zfcp_port_dequeue(struct zfcp_port *port
 	device_unregister(&port->sysfs_device);
 }
 
+/**
+ * zfcp_sg_free_table - free memory used by scatterlists
+ * @sg: pointer to scatterlist
+ * @count: number of scatterlist which are to be free'ed
+ * the scatterlist are expected to reference pages always
+ */
 void zfcp_sg_free_table(struct scatterlist *sg, int count)
 {
 	int i;
@@ -902,6 +749,14 @@ void zfcp_sg_free_table(struct scatterli
 			break;
 }
 
+/**
+ * zfcp_sg_setup_table - init scatterlist and allocate, assign buffers
+ * @sg: pointer to struct scatterlist
+ * @count: number of scatterlists which should be assigned with buffers
+ * of size page
+ *
+ * Returns: 0 on success, -ENOMEM otherwise
+ */
 int zfcp_sg_setup_table(struct scatterlist *sg, int count)
 {
 	void *addr;
--- a/drivers/s390/scsi/zfcp_def.h	2008-07-02 10:32:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2008-07-02 10:41:23.000000000 +0200
@@ -730,13 +730,6 @@ struct zfcp_data {
 	struct kmem_cache		*gid_pn_cache;
 };
 
-/* number of elements for various memory pools */
-#define ZFCP_POOL_FSF_REQ_ERP_NR	1
-#define ZFCP_POOL_FSF_REQ_SCSI_NR	1
-#define ZFCP_POOL_FSF_REQ_ABORT_NR	1
-#define ZFCP_POOL_STATUS_READ_NR	FSF_STATUS_READS_RECOM
-#define ZFCP_POOL_DATA_GID_PN_NR	1
-
 /* struct used by memory pools for fsf_requests */
 struct zfcp_fsf_req_qtcb {
 	struct zfcp_fsf_req fsf_req;
@@ -757,12 +750,6 @@ struct zfcp_fsf_req_qtcb {
            ((atomic_read(target) & mask) == mask)
 #endif
 
-extern void _zfcp_hex_dump(char *, int);
-#define ZFCP_HEX_DUMP(level, addr, count) \
-		if (ZFCP_LOG_CHECK(level)) { \
-			_zfcp_hex_dump(addr, count); \
-		}
-
 #define zfcp_get_busid_by_adapter(adapter) (adapter->ccw_device->dev.bus_id)
 #define zfcp_get_busid_by_port(port) (zfcp_get_busid_by_adapter(port->adapter))
 #define zfcp_get_busid_by_unit(unit) (zfcp_get_busid_by_port(unit->port))
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-07-02 10:30:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2008-07-02 10:41:23.000000000 +0200
@@ -74,7 +74,7 @@ zfcp_sysfs_unit_add_store(struct device 
 		goto out;
 
 	unit = zfcp_unit_enqueue(port, fcp_lun);
-	if (!unit)
+	if (IS_ERR(unit))
 		goto out;
 
 	retval = 0;
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-07-02 10:30:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-07-02 10:32:59.000000000 +0200
@@ -20,12 +20,10 @@
  */
 static int zfcp_ccw_probe(struct ccw_device *ccw_device)
 {
-	struct zfcp_adapter *adapter;
 	int retval = 0;
 
 	down(&zfcp_data.config_sema);
-	adapter = zfcp_adapter_enqueue(ccw_device);
-	if (!adapter) {
+	if (zfcp_adapter_enqueue(ccw_device)) {
 		dev_err(&ccw_device->dev,
 			"Setup of data structures failed.\n");
 		retval = -EINVAL;
--- a/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:32:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-07-02 10:41:23.000000000 +0200
@@ -26,9 +26,7 @@ extern void zfcp_sysfs_unit_release(stru
 /**************************** CONFIGURATION  *********************************/
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, fcp_lun_t);
 extern struct zfcp_port *zfcp_get_port_by_wwpn(struct zfcp_adapter *, wwn_t);
-extern struct zfcp_port *zfcp_get_port_by_did(struct zfcp_adapter *, u32);
-struct zfcp_adapter *zfcp_get_adapter_by_busid(char *);
-extern struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *);
+extern int    zfcp_adapter_enqueue(struct ccw_device *);
 extern int    zfcp_adapter_debug_register(struct zfcp_adapter *);
 extern void   zfcp_adapter_dequeue(struct zfcp_adapter *);
 extern void   zfcp_adapter_debug_unregister(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_erp.c	2008-07-02 10:30:43.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-07-02 10:41:23.000000000 +0200
@@ -1675,7 +1675,7 @@ static void zfcp_erp_open_ptp_port(struc
 	struct zfcp_port *port;
 	port = zfcp_port_enqueue(adapter, adapter->peer_wwpn, 0,
 				 adapter->peer_d_id);
-	if (!port) /* error or port already attached */
+	if (IS_ERR(port)) /* error or port already attached */
 		return;
 	zfcp_erp_port_reopen_internal(port, 0, 150, NULL);
 }
--- a/drivers/s390/scsi/zfcp_fc.c	2008-07-02 10:31:45.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-07-02 10:41:23.000000000 +0200
@@ -39,6 +39,18 @@ struct zfcp_gpn_ft {
 	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
 };
 
+static struct zfcp_port *zfcp_get_port_by_did(struct zfcp_adapter *adapter,
+					      u32 d_id)
+{
+	struct zfcp_port *port;
+
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		if ((port->d_id == d_id) &&
+		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status))
+			return port;
+	return NULL;
+}
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -496,10 +508,10 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_PORT_DID_DID |
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
-		if (port)
-			zfcp_erp_port_reopen(port, 0, 149, NULL);
+		if (IS_ERR(port))
+			ret = PTR_ERR(port);
 		else
-			ret = -ENOMEM;
+			zfcp_erp_port_reopen(port, 0, 149, NULL);
 		if (acc->control & 0x80) /* last entry */
 			break;
 	}

-- 
