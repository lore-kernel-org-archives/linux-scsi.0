From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: please revert [PATCH] s390: zfcp act enhancements
Date: Wed, 17 Nov 2004 15:09:16 +0100
Message-ID: <20041117140916.GA7344@mschwid3.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:57243 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S262324AbUKQOJn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2004 09:09:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@lst.de>, linux390@de.ibm.com, linux-scsi@vger.kernel.org

> That cset is adding tons of not used intree exports to the zfcp driver,
> for an IBM module for an API (SNIA HBA API) that we as we as the scsi
> team have rejected.

Heiko created a patch to remove the hba api event callback functions
and the related EXPORT_SYMBOLS again. That leaves the access control
enhancements of the disputed patch intact. Sorry for the hassle.

blue skies,
  Martin.

---

[patch] s390: remove zfcp hba api callbacks.

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Remove the disputed hba api event callback code.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

diffstat:
 drivers/s390/scsi/zfcp_aux.c  |  181 ++----------------------------------------
 drivers/s390/scsi/zfcp_def.h  |   27 ------
 drivers/s390/scsi/zfcp_erp.c  |   12 --
 drivers/s390/scsi/zfcp_ext.h  |   20 ----
 drivers/s390/scsi/zfcp_fsf.c  |   13 ---
 drivers/s390/scsi/zfcp_scsi.c |    5 -
 6 files changed, 18 insertions(+), 240 deletions(-)

diff -urN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2004-11-17 14:31:13.000000000 +0100
@@ -29,7 +29,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_AUX_REVISION "$Revision: 1.144 $"
+#define ZFCP_AUX_REVISION "$Revision: 1.145 $"
 
 #include "zfcp_ext.h"
 
@@ -45,6 +45,13 @@
 static void zfcp_ns_gid_pn_handler(unsigned long);
 
 /* miscellaneous */
+static inline int zfcp_sg_list_alloc(struct zfcp_sg_list *, size_t);
+static inline void zfcp_sg_list_free(struct zfcp_sg_list *);
+static inline int zfcp_sg_list_copy_from_user(struct zfcp_sg_list *,
+					      void __user *, size_t);
+static inline int zfcp_sg_list_copy_to_user(void __user *,
+					    struct zfcp_sg_list *, size_t);
+
 static int zfcp_cfdc_dev_ioctl(struct inode *, struct file *,
 	unsigned int, unsigned long);
 
@@ -337,11 +344,8 @@
 	if (zfcp_device_setup(device))
 		zfcp_init_device_configure();
 
-	init_waitqueue_head(&zfcp_callbacks.wq);
-
 	goto out;
 
-
  out_ccw_register:
 	misc_deregister(&zfcp_cfdc_misc);
  out_misc_register:
@@ -559,7 +563,7 @@
  * elements of the scatter-gather list. The maximum size of a single element
  * in the scatter-gather list is PAGE_SIZE.
  */
-int
+static inline int
 zfcp_sg_list_alloc(struct zfcp_sg_list *sg_list, size_t size)
 {
 	struct scatterlist *sg;
@@ -607,7 +611,7 @@
  * Memory for each element in the scatter-gather list is freed.
  * Finally sg_list->sg is freed itself and sg_list->count is reset.
  */
-void
+static inline void
 zfcp_sg_list_free(struct zfcp_sg_list *sg_list)
 {
 	struct scatterlist *sg;
@@ -652,7 +656,7 @@
  * @size: number of bytes to be copied
  * Return: 0 on success, -EFAULT if copy_from_user fails.
  */
-int
+static inline int
 zfcp_sg_list_copy_from_user(struct zfcp_sg_list *sg_list,
 			    void __user *user_buffer,
                             size_t size)
@@ -690,7 +694,7 @@
  * @size: number of bytes to be copied
  * Return: 0 on success, -EFAULT if copy_to_user fails
  */
-int
+static inline int
 zfcp_sg_list_copy_to_user(void __user  *user_buffer,
 			  struct zfcp_sg_list *sg_list,
                           size_t size)
@@ -1418,8 +1422,6 @@
 
 	zfcp_adapter_get(adapter);
 
-	zfcp_cb_port_add(port);
-
 	return port;
 }
 
@@ -1646,8 +1648,6 @@
 		zfcp_fsf_incoming_els_rscn(adapter, status_buffer);
 	else
 		zfcp_fsf_incoming_els_unknown(adapter, status_buffer);
-
-	zfcp_cb_incoming_els(adapter, status_buffer->payload);
 }
 
 
@@ -1974,161 +1974,4 @@
 	return ret;
 }
 
-
-#undef ZFCP_LOG_AREA
-
-/****************************************************************/
-/******* HBA API Support related Functions  *********************/
-/****************************************************************/
-#define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_FC
-
-struct zfcp_callbacks zfcp_callbacks = { };
-
-/**
- * zfcp_register_callbacks - register callbacks for event handling in HBA API
- * @callbacks: set of callback functions to be registered
- */
-void
-zfcp_register_callbacks(struct zfcp_callbacks *callbacks)
-{
-	zfcp_callbacks.incoming_els = callbacks->incoming_els;
-	zfcp_callbacks.link_down = callbacks->link_down;
-	zfcp_callbacks.link_up = callbacks->link_up;
-	zfcp_callbacks.adapter_add = callbacks->adapter_add;
-	zfcp_callbacks.port_add = callbacks->port_add;
-	zfcp_callbacks.unit_add = callbacks->unit_add;
-}
-
-/**
- * zfcp_unregister_callbacks - deregister callbacks for event handling
- */
-void
-zfcp_unregister_callbacks(void)
-{
-	zfcp_callbacks.incoming_els = NULL;
-	zfcp_callbacks.link_down = NULL;
-	zfcp_callbacks.link_up = NULL;
-	zfcp_callbacks.adapter_add = NULL;
-	zfcp_callbacks.port_add = NULL;
-	zfcp_callbacks.unit_add = NULL;
-
-	/* wait until all callbacks returned */
-	wait_event(zfcp_callbacks.wq,
-		   atomic_read(&zfcp_callbacks.refcount) == 0);
-}
-
-/**
- * zfcp_cb_incoming_els - make callback for incoming els
- * @adpater: adapter where ELS was received
- * @payload: received ELS payload
- */
-void
-zfcp_cb_incoming_els(struct zfcp_adapter *adapter, void *payload)
-{
-	zfcp_cb_incoming_els_t cb;
-
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.incoming_els;
-	if (cb)
-		cb(adapter, payload);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
-/**
- * zfcp_cb_link_down - make callback for link down event
- * @adapter: adapter where link down occurred
- */
-void
-zfcp_cb_link_down(struct zfcp_adapter *adapter)
-{
-	zfcp_cb_link_down_t cb;
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.link_down;
-	if (cb)
-		cb(adapter);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
-/**
- * zfcp_cb_link_up - make callback for link up event
- * @adapter: adapter where link up occurred
- */
-void
-zfcp_cb_link_up(struct zfcp_adapter *adapter)
-{
-	zfcp_cb_link_up_t cb;
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.link_up;
-	if (cb)
-		cb(adapter);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
-/**
- * zfcp_cb_adapter_add - make callback for adapter add event
- * @adapter: adapter which was added/activated
- */
-void
-zfcp_cb_adapter_add(struct zfcp_adapter *adapter)
-{
-	zfcp_cb_adapter_add_t cb;
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.adapter_add;
-	if (cb)
-		cb(adapter);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
-/**
- * zfcp_cb_port_add - make callback for port add event
- * @port: port which was added
- */
-void
-zfcp_cb_port_add(struct zfcp_port *port)
-{
-	zfcp_cb_port_add_t cb;
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.port_add;
-	if (cb)
-		cb(port);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
-/**
- * zfcp_cb_unit_add - make callback for unit add event
- * @unit: unit which was added
- */
-void
-zfcp_cb_unit_add(struct zfcp_unit *unit)
-{
-	zfcp_cb_unit_add_t cb;
-	atomic_inc(&zfcp_callbacks.refcount);
-	cb = zfcp_callbacks.unit_add;
-	if (cb)
-		cb(unit);
-	if (atomic_dec_return(&zfcp_callbacks.refcount) == 0)
-		wake_up(&zfcp_callbacks.wq);
-}
-
 #undef ZFCP_LOG_AREA
-
-EXPORT_SYMBOL(zfcp_sg_list_alloc);
-EXPORT_SYMBOL(zfcp_sg_list_free);
-EXPORT_SYMBOL(zfcp_sg_size);
-EXPORT_SYMBOL(zfcp_sg_list_copy_from_user);
-EXPORT_SYMBOL(zfcp_sg_list_copy_to_user);
-EXPORT_SYMBOL(zfcp_get_unit_by_lun);
-EXPORT_SYMBOL(zfcp_get_port_by_wwpn);
-EXPORT_SYMBOL(zfcp_get_port_by_did);
-EXPORT_SYMBOL(zfcp_get_adapter_by_busid);
-EXPORT_SYMBOL(zfcp_register_callbacks);
-EXPORT_SYMBOL(zfcp_unregister_callbacks);
-EXPORT_SYMBOL(zfcp_port_enqueue);
-EXPORT_SYMBOL(zfcp_unit_enqueue);
-EXPORT_SYMBOL(zfcp_unit_dequeue);
-EXPORT_SYMBOL(zfcp_check_ct_response);
diff -urN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2004-11-17 14:25:18.000000000 +0100
@@ -35,7 +35,7 @@
 #define ZFCP_DEF_H
 
 /* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_DEF_REVISION "$Revision: 1.107 $"
+#define ZFCP_DEF_REVISION "$Revision: 1.110 $"
 
 /*************************** INCLUDES *****************************************/
 
@@ -1118,29 +1118,4 @@
 	wait_event(adapter->remove_wq, atomic_read(&adapter->refcount) == 0);
 }
 
-
-/*
- *  stuff needed for callback handling
- */
-
-typedef void (*zfcp_cb_incoming_els_t) (struct zfcp_adapter *, void *);
-typedef void (*zfcp_cb_link_down_t) (struct zfcp_adapter *);
-typedef void (*zfcp_cb_link_up_t) (struct zfcp_adapter *);
-typedef void (*zfcp_cb_adapter_add_t) (struct zfcp_adapter *);
-typedef void (*zfcp_cb_port_add_t) (struct zfcp_port *);
-typedef void (*zfcp_cb_unit_add_t) (struct zfcp_unit *);
-
-struct zfcp_callbacks {
-	atomic_t refcount;
-	wait_queue_head_t wq;
-	zfcp_cb_incoming_els_t incoming_els;
-	zfcp_cb_link_down_t link_down;
-	zfcp_cb_link_up_t link_up;
-	zfcp_cb_adapter_add_t adapter_add;
-	zfcp_cb_port_add_t port_add;
-	zfcp_cb_unit_add_t unit_add;
-};
-
-extern struct zfcp_callbacks zfcp_callbacks;
-
 #endif /* ZFCP_DEF_H */
diff -urN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2004-11-17 14:25:18.000000000 +0100
@@ -32,7 +32,7 @@
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
 
 /* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_ERP_REVISION "$Revision: 1.79 $"
+#define ZFCP_ERP_REVISION "$Revision: 1.83 $"
 
 #include "zfcp_ext.h"
 
@@ -3347,11 +3347,9 @@
 		if ((result == ZFCP_ERP_SUCCEEDED)
 		    && (!atomic_test_mask(ZFCP_STATUS_UNIT_TEMPORARY,
 					  &unit->status))
-		    && (!unit->device)) {
+		    && (!unit->device))
  			scsi_add_device(unit->port->adapter->scsi_host, 0,
  					unit->port->scsi_id, unit->scsi_lun);
-			zfcp_cb_unit_add(unit);
-		}
 		zfcp_unit_put(unit);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
@@ -3587,9 +3585,3 @@
 }
 
 #undef ZFCP_LOG_AREA
-
-EXPORT_SYMBOL(zfcp_erp_wait);
-EXPORT_SYMBOL(zfcp_erp_port_reopen);
-EXPORT_SYMBOL(zfcp_erp_unit_reopen);
-EXPORT_SYMBOL(zfcp_erp_unit_shutdown);
-EXPORT_SYMBOL(zfcp_fsf_request_timeout_handler);
diff -urN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2004-11-17 14:25:18.000000000 +0100
@@ -32,7 +32,7 @@
 #ifndef ZFCP_EXT_H
 #define ZFCP_EXT_H
 /* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_EXT_REVISION "$Revision: 1.60 $"
+#define ZFCP_EXT_REVISION "$Revision: 1.61 $"
 
 #include "zfcp_def.h"
 
@@ -183,22 +183,4 @@
 extern void zfcp_cmd_dbf_event_scsi(const char *, struct scsi_cmnd *);
 extern void zfcp_in_els_dbf_event(struct zfcp_adapter *, const char *,
 				  struct fsf_status_read_buffer *, int);
-extern int zfcp_sg_list_alloc(struct zfcp_sg_list *, size_t);
-extern void zfcp_sg_list_free(struct zfcp_sg_list *);
-extern int zfcp_sg_list_copy_from_user(struct zfcp_sg_list *, void __user *,
-				       size_t);
-extern int zfcp_sg_list_copy_to_user(void __user *, struct zfcp_sg_list *,
-				     size_t);
-extern size_t zfcp_sg_size(struct scatterlist *, unsigned int);
-
-void zfcp_register_callbacks(struct zfcp_callbacks *);
-void zfcp_unregister_callbacks(void);
-
-extern void zfcp_cb_incoming_els(struct zfcp_adapter *, void *);
-extern void zfcp_cb_link_down(struct zfcp_adapter *);
-extern void zfcp_cb_link_up(struct zfcp_adapter *);
-extern void zfcp_cb_adapter_add(struct zfcp_adapter *);
-extern void zfcp_cb_port_add(struct zfcp_port *);
-extern void zfcp_cb_unit_add(struct zfcp_unit *);
-
 #endif	/* ZFCP_EXT_H */
diff -urN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2004-11-17 14:25:18.000000000 +0100
@@ -31,7 +31,7 @@
  */
 
 /* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_FSF_C_REVISION "$Revision: 1.83 $"
+#define ZFCP_FSF_C_REVISION "$Revision: 1.86 $"
 
 #include "zfcp_ext.h"
 
@@ -1020,8 +1020,6 @@
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
 				&adapter->status);
 		zfcp_erp_adapter_failed(adapter);
-
-		zfcp_cb_link_down(adapter);
 		break;
 
 	case FSF_STATUS_READ_LINK_UP:
@@ -1037,9 +1035,6 @@
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
 					| ZFCP_STATUS_COMMON_ERP_FAILED);
-
-		zfcp_cb_link_up(adapter);
-
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
@@ -2255,8 +2250,6 @@
 		}
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
-		zfcp_cb_adapter_add(adapter);
-
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
 		debug_text_event(adapter->erp_dbf, 0, "xchg-inco");
@@ -5138,7 +5131,3 @@
 }
 
 #undef ZFCP_LOG_AREA
-
-EXPORT_SYMBOL(zfcp_fsf_exchange_port_data);
-EXPORT_SYMBOL(zfcp_fsf_send_ct);
-EXPORT_SYMBOL(zfcp_fsf_send_els);
diff -urN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2004-11-17 14:24:51.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2004-11-17 14:25:18.000000000 +0100
@@ -32,7 +32,7 @@
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_SCSI
 
 /* this drivers version (do not edit !!! generated and updated by cvs) */
-#define ZFCP_SCSI_REVISION "$Revision: 1.72 $"
+#define ZFCP_SCSI_REVISION "$Revision: 1.73 $"
 
 #include "zfcp_ext.h"
 
@@ -948,6 +948,3 @@
 };
 
 #undef ZFCP_LOG_AREA
-
-EXPORT_SYMBOL(zfcp_data);
-EXPORT_SYMBOL(zfcp_scsi_command_sync);
