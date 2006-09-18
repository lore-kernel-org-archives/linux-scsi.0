From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH 2/6] zfcp: create private slab caches to guarantee proper data alignment
Date: Mon, 18 Sep 2006 22:28:49 +0200
Message-ID: <20060918202849.GA10489@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:41514 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S964930AbWIRUdg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 16:33:36 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.8/8.13.8) with ESMTP id k8IKXZY7104762
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 20:33:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8IKcJNj2637976
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:38:19 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8IKXYib013926
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 22:33:35 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>

From: Heiko Carstens <heiko.carstens@de.ibm.com>

zfcp: create private slab caches to guarantee proper data alignment

Create private slab caches in order to guarantee proper alignment of
data structures that get passed to hardware.

Sidenote: with this patch slab cache debugging will finally work on s390
(at least no known problems left).

Furthermore this patch does some minor cleanups:
- use do { } while (0) constructs instead of empty defines to avoid subtle
compile bugs
- store ptr for transport template in struct zfcp_data

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |   76 +++++++++++++++++++++++++++++++----------
 drivers/s390/scsi/zfcp_def.h  |   24 ++++++++-----
 drivers/s390/scsi/zfcp_ext.h  |    1 -
 drivers/s390/scsi/zfcp_fsf.c  |   33 ++++++++++++------
 drivers/s390/scsi/zfcp_scsi.c |    5 +--
 5 files changed, 96 insertions(+), 43 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index adc9d8f..d2b094d 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -299,11 +299,45 @@ zfcp_init_device_configure(void)
 	return;
 }
 
+static int calc_alignment(int size)
+{
+	int align = 1;
+
+	if (!size)
+		return 0;
+
+	while ((size - align) > 0)
+		align <<= 1;
+
+	return align;
+}
+
 static int __init
 zfcp_module_init(void)
 {
+	int retval = -ENOMEM;
+	int size, align;
+
+	size = sizeof(struct zfcp_fsf_req_qtcb);
+	align = calc_alignment(size);
+	zfcp_data.fsf_req_qtcb_cache =
+		kmem_cache_create("zfcp_fsf", size, align, 0, NULL, NULL);
+	if (!zfcp_data.fsf_req_qtcb_cache)
+		goto out;
 
-	int retval = 0;
+	size = sizeof(struct fsf_status_read_buffer);
+	align = calc_alignment(size);
+	zfcp_data.sr_buffer_cache =
+		kmem_cache_create("zfcp_sr", size, align, 0, NULL, NULL);
+	if (!zfcp_data.sr_buffer_cache)
+		goto out_sr_cache;
+
+	size = sizeof(struct zfcp_gid_pn_data);
+	align = calc_alignment(size);
+	zfcp_data.gid_pn_cache =
+		kmem_cache_create("zfcp_gid", size, align, 0, NULL, NULL);
+	if (!zfcp_data.gid_pn_cache)
+		goto out_gid_cache;
 
 	atomic_set(&zfcp_data.loglevel, loglevel);
 
@@ -313,15 +347,16 @@ zfcp_module_init(void)
 	/* initialize adapters to be removed list head */
 	INIT_LIST_HEAD(&zfcp_data.adapter_remove_lh);
 
-	zfcp_transport_template = fc_attach_transport(&zfcp_transport_functions);
-	if (!zfcp_transport_template)
-		return -ENODEV;
+	zfcp_data.scsi_transport_template =
+		fc_attach_transport(&zfcp_transport_functions);
+	if (!zfcp_data.scsi_transport_template)
+		goto out_transport;
 
 	retval = misc_register(&zfcp_cfdc_misc);
 	if (retval != 0) {
 		ZFCP_LOG_INFO("registration of misc device "
 			      "zfcp_cfdc failed\n");
-		goto out;
+		goto out_misc;
 	}
 
 	ZFCP_LOG_TRACE("major/minor for zfcp_cfdc: %d/%d\n",
@@ -333,9 +368,6 @@ zfcp_module_init(void)
 	/* initialise configuration rw lock */
 	rwlock_init(&zfcp_data.config_lock);
 
-	/* save address of data structure managing the driver module */
-	zfcp_data.scsi_host_template.module = THIS_MODULE;
-
 	/* setup dynamic I/O */
 	retval = zfcp_ccw_register();
 	if (retval) {
@@ -350,6 +382,14 @@ zfcp_module_init(void)
 
  out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
+ out_misc:
+	fc_release_transport(zfcp_data.scsi_transport_template);
+ out_transport:
+	kmem_cache_destroy(zfcp_data.gid_pn_cache);
+ out_gid_cache:
+	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
+ out_sr_cache:
+	kmem_cache_destroy(zfcp_data.fsf_req_qtcb_cache);
  out:
 	return retval;
 }
@@ -935,20 +975,20 @@ static int
 zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	adapter->pool.fsf_req_erp =
-		mempool_create_kmalloc_pool(ZFCP_POOL_FSF_REQ_ERP_NR,
-				sizeof(struct zfcp_fsf_req_pool_element));
+		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_ERP_NR,
+					 zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_erp)
 		return -ENOMEM;
 
 	adapter->pool.fsf_req_scsi =
-		mempool_create_kmalloc_pool(ZFCP_POOL_FSF_REQ_SCSI_NR,
-				sizeof(struct zfcp_fsf_req_pool_element));
+		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_SCSI_NR,
+					 zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_scsi)
 		return -ENOMEM;
 
 	adapter->pool.fsf_req_abort =
-		mempool_create_kmalloc_pool(ZFCP_POOL_FSF_REQ_ABORT_NR,
-				sizeof(struct zfcp_fsf_req_pool_element));
+		mempool_create_slab_pool(ZFCP_POOL_FSF_REQ_ABORT_NR,
+					 zfcp_data.fsf_req_qtcb_cache);
 	if (!adapter->pool.fsf_req_abort)
 		return -ENOMEM;
 
@@ -959,14 +999,14 @@ zfcp_allocate_low_mem_buffers(struct zfc
 		return -ENOMEM;
 
 	adapter->pool.data_status_read =
-		mempool_create_kmalloc_pool(ZFCP_POOL_STATUS_READ_NR,
-					sizeof(struct fsf_status_read_buffer));
+		mempool_create_slab_pool(ZFCP_POOL_STATUS_READ_NR,
+					 zfcp_data.sr_buffer_cache);
 	if (!adapter->pool.data_status_read)
 		return -ENOMEM;
 
 	adapter->pool.data_gid_pn =
-		mempool_create_kmalloc_pool(ZFCP_POOL_DATA_GID_PN_NR,
-					    sizeof(struct zfcp_gid_pn_data));
+		mempool_create_slab_pool(ZFCP_POOL_DATA_GID_PN_NR,
+					 zfcp_data.gid_pn_cache);
 	if (!adapter->pool.data_gid_pn)
 		return -ENOMEM;
 
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 94d1b74..ef1cd49 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -19,7 +19,6 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA. 
  */ 
 
-
 #ifndef ZFCP_DEF_H
 #define ZFCP_DEF_H
 
@@ -32,6 +31,10 @@ #include <linux/major.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/timer.h>
+#include <linux/slab.h>
+#include <linux/mempool.h>
+#include <linux/syscalls.h>
+#include <linux/ioctl.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_cmnd.h>
@@ -39,14 +42,11 @@ #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_transport_fc.h>
-#include "zfcp_fsf.h"
 #include <asm/ccwdev.h>
 #include <asm/qdio.h>
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
-#include <linux/mempool.h>
-#include <linux/syscalls.h>
-#include <linux/ioctl.h>
+#include "zfcp_fsf.h"
 
 
 /********************* GENERAL DEFINES *********************************/
@@ -543,7 +543,7 @@ do { \
 } while (0)
 	
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_NORMAL
-# define ZFCP_LOG_NORMAL(fmt, args...)
+# define ZFCP_LOG_NORMAL(fmt, args...)	do { } while (0)
 #else
 # define ZFCP_LOG_NORMAL(fmt, args...) \
 do { \
@@ -553,7 +553,7 @@ do { \
 #endif
 
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_INFO
-# define ZFCP_LOG_INFO(fmt, args...)
+# define ZFCP_LOG_INFO(fmt, args...)	do { } while (0)
 #else
 # define ZFCP_LOG_INFO(fmt, args...) \
 do { \
@@ -563,14 +563,14 @@ do { \
 #endif
 
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_DEBUG
-# define ZFCP_LOG_DEBUG(fmt, args...)
+# define ZFCP_LOG_DEBUG(fmt, args...)	do { } while (0)
 #else
 # define ZFCP_LOG_DEBUG(fmt, args...) \
 	ZFCP_LOG(ZFCP_LOG_LEVEL_DEBUG, fmt , ##args)
 #endif
 
 #if ZFCP_LOG_LEVEL_LIMIT < ZFCP_LOG_LEVEL_TRACE
-# define ZFCP_LOG_TRACE(fmt, args...)
+# define ZFCP_LOG_TRACE(fmt, args...)	do { } while (0)
 #else
 # define ZFCP_LOG_TRACE(fmt, args...) \
 	ZFCP_LOG(ZFCP_LOG_LEVEL_TRACE, fmt , ##args)
@@ -1016,6 +1016,7 @@ typedef void zfcp_fsf_req_handler_t(stru
 /* driver data */
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
+	struct scsi_transport_template *scsi_transport_template;
         atomic_t                status;             /* Module status flags */
 	struct list_head	adapter_list_head;  /* head of adapter list */
 	struct list_head	adapter_remove_lh;  /* head of adapters to be
@@ -1031,6 +1032,9 @@ struct zfcp_data {
 	wwn_t                   init_wwpn;
 	fcp_lun_t               init_fcp_lun;
 	char 			*driver_version;
+	kmem_cache_t		*fsf_req_qtcb_cache;
+	kmem_cache_t		*sr_buffer_cache;
+	kmem_cache_t		*gid_pn_cache;
 };
 
 /**
@@ -1051,7 +1055,7 @@ #define ZFCP_POOL_STATUS_READ_NR	ZFCP_ST
 #define ZFCP_POOL_DATA_GID_PN_NR	1
 
 /* struct used by memory pools for fsf_requests */
-struct zfcp_fsf_req_pool_element {
+struct zfcp_fsf_req_qtcb {
 	struct zfcp_fsf_req fsf_req;
 	struct fsf_qtcb qtcb;
 };
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index b45d1bf..4f4ef0c 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -130,7 +130,6 @@ extern int zfcp_scsi_command_async(struc
 				   struct scsi_cmnd *, struct timer_list *);
 extern int zfcp_scsi_command_sync(struct zfcp_unit *, struct scsi_cmnd *,
 				  struct timer_list *);
-extern struct scsi_transport_template *zfcp_transport_template;
 extern struct fc_function_template zfcp_transport_functions;
 
 /******************************** ERP ****************************************/
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index ff2eacf..4913ffb 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -100,14 +100,19 @@ zfcp_fsf_req_alloc(mempool_t *pool, int 
 	if (req_flags & ZFCP_REQ_NO_QTCB)
 		size = sizeof(struct zfcp_fsf_req);
 	else
-		size = sizeof(struct zfcp_fsf_req_pool_element);
+		size = sizeof(struct zfcp_fsf_req_qtcb);
 
-	if (likely(pool != NULL))
+	if (likely(pool))
 		ptr = mempool_alloc(pool, GFP_ATOMIC);
-	else
-		ptr = kmalloc(size, GFP_ATOMIC);
+	else {
+		if (req_flags & ZFCP_REQ_NO_QTCB)
+			ptr = kmalloc(size, GFP_ATOMIC);
+		else
+			ptr = kmem_cache_alloc(zfcp_data.fsf_req_qtcb_cache,
+					       SLAB_ATOMIC);
+	}
 
-	if (unlikely(NULL == ptr))
+	if (unlikely(!ptr))
 		goto out;
 
 	memset(ptr, 0, size);
@@ -115,9 +120,8 @@ zfcp_fsf_req_alloc(mempool_t *pool, int 
 	if (req_flags & ZFCP_REQ_NO_QTCB) {
 		fsf_req = (struct zfcp_fsf_req *) ptr;
 	} else {
-		fsf_req = &((struct zfcp_fsf_req_pool_element *) ptr)->fsf_req;
-		fsf_req->qtcb =
-			&((struct zfcp_fsf_req_pool_element *) ptr)->qtcb;
+		fsf_req = &((struct zfcp_fsf_req_qtcb *) ptr)->fsf_req;
+		fsf_req->qtcb =	&((struct zfcp_fsf_req_qtcb *) ptr)->qtcb;
 	}
 
 	fsf_req->pool = pool;
@@ -139,10 +143,17 @@ zfcp_fsf_req_alloc(mempool_t *pool, int 
 void
 zfcp_fsf_req_free(struct zfcp_fsf_req *fsf_req)
 {
-	if (likely(fsf_req->pool != NULL))
+	if (likely(fsf_req->pool)) {
 		mempool_free(fsf_req, fsf_req->pool);
-	else
-		kfree(fsf_req);
+		return;
+	}
+
+	if (fsf_req->qtcb) {
+		kmem_cache_free(zfcp_data.fsf_req_qtcb_cache, fsf_req);
+		return;
+	}
+
+	kfree(fsf_req);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 1bb5508..4857ccc 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -39,11 +39,10 @@ static struct zfcp_unit *zfcp_unit_looku
 
 static struct device_attribute *zfcp_sysfs_sdev_attrs[];
 
-struct scsi_transport_template *zfcp_transport_template;
-
 struct zfcp_data zfcp_data = {
 	.scsi_host_template = {
 		.name			= ZFCP_NAME,
+		.module			= THIS_MODULE,
 		.proc_name		= "zfcp",
 		.slave_alloc		= zfcp_scsi_slave_alloc,
 		.slave_configure	= zfcp_scsi_slave_configure,
@@ -607,7 +606,7 @@ zfcp_adapter_scsi_register(struct zfcp_a
 	adapter->scsi_host->max_channel = 0;
 	adapter->scsi_host->unique_id = unique_id++;	/* FIXME */
 	adapter->scsi_host->max_cmd_len = ZFCP_MAX_SCSI_CMND_LENGTH;
-	adapter->scsi_host->transportt = zfcp_transport_template;
+	adapter->scsi_host->transportt = zfcp_data.scsi_transport_template;
 
 	/*
 	 * save a pointer to our own adapter data structure within
-- 
1.4.2.1.g80823

