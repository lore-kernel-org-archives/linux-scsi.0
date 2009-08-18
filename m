From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/27] zfcp: Improve request allocation through mempools
Date: Tue, 18 Aug 2009 15:43:15 +0200
Message-ID: <20090818135030.064369000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:47040 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531AbZHRNua (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:30 -0400
Content-Disposition: inline; filename=711-zfcp-special-case.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Remove the special case for NO_QTCB requests and optimize the
mempool and cache processing for fsfreqs. Especially use seperate
mempools for the zfcp_fsf_req and zfcp_qtcb structs.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   98 ++++++++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_def.h |   31 +++++++------
 drivers/s390/scsi/zfcp_fc.c  |   19 ++------
 drivers/s390/scsi/zfcp_fsf.c |   92 +++++++++++++++++++++-------------------
 4 files changed, 127 insertions(+), 113 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:13.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:21.000000000 +0200
@@ -42,6 +42,12 @@ static char *init_device;
 module_param_named(device, init_device, charp, 0400);
 MODULE_PARM_DESC(device, "specify initial device");
 
+static struct kmem_cache *zfcp_cache_hw_align(const char *name,
+					      unsigned long size)
+{
+	return kmem_cache_create(name, size, roundup_pow_of_two(size), 0, NULL);
+}
+
 static int zfcp_reqlist_alloc(struct zfcp_adapter *adapter)
 {
 	int idx;
@@ -110,14 +116,6 @@ out_adapter:
 	return;
 }
 
-static struct kmem_cache *zfcp_cache_create(int size, char *name)
-{
-	int align = 1;
-	while ((size - align) > 0)
-		align <<= 1;
-	return kmem_cache_create(name , size, align, 0, NULL);
-}
-
 static void __init zfcp_init_device_setup(char *devstr)
 {
 	char *token;
@@ -158,18 +156,23 @@ static int __init zfcp_module_init(void)
 {
 	int retval = -ENOMEM;
 
-	zfcp_data.fsf_req_qtcb_cache = zfcp_cache_create(
-			sizeof(struct zfcp_fsf_req_qtcb), "zfcp_fsf");
-	if (!zfcp_data.fsf_req_qtcb_cache)
+	zfcp_data.gpn_ft_cache = zfcp_cache_hw_align("zfcp_gpn",
+					sizeof(struct ct_iu_gpn_ft_req));
+	if (!zfcp_data.gpn_ft_cache)
 		goto out;
 
-	zfcp_data.sr_buffer_cache = zfcp_cache_create(
-			sizeof(struct fsf_status_read_buffer), "zfcp_sr");
+	zfcp_data.qtcb_cache = zfcp_cache_hw_align("zfcp_qtcb",
+					sizeof(struct fsf_qtcb));
+	if (!zfcp_data.qtcb_cache)
+		goto out_qtcb_cache;
+
+	zfcp_data.sr_buffer_cache = zfcp_cache_hw_align("zfcp_sr",
+					sizeof(struct fsf_status_read_buffer));
 	if (!zfcp_data.sr_buffer_cache)
 		goto out_sr_cache;
 
-	zfcp_data.gid_pn_cache = zfcp_cache_create(
-			sizeof(struct zfcp_gid_pn_data), "zfcp_gid");
+	zfcp_data.gid_pn_cache = zfcp_cache_hw_align("zfcp_gid",
+					sizeof(struct zfcp_gid_pn_data));
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
@@ -209,7 +212,9 @@ out_transport:
 out_gid_cache:
 	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
 out_sr_cache:
-	kmem_cache_destroy(zfcp_data.fsf_req_qtcb_cache);
+	kmem_cache_destroy(zfcp_data.qtcb_cache);
+out_qtcb_cache:
+	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
 out:
 	return retval;
 }
@@ -354,36 +359,41 @@ void zfcp_unit_dequeue(struct zfcp_unit 
 static int zfcp_allocate_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	/* must only be called with zfcp_data.config_sema taken */
-	adapter->pool.fsf_req_erp =
-		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
-	if (!adapter->pool.fsf_req_erp)
+	adapter->pool.erp_req =
+		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
+	if (!adapter->pool.erp_req)
 		return -ENOMEM;
 
-	adapter->pool.fsf_req_scsi =
-		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
-	if (!adapter->pool.fsf_req_scsi)
+	adapter->pool.scsi_req =
+		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
+	if (!adapter->pool.scsi_req)
 		return -ENOMEM;
 
-	adapter->pool.fsf_req_abort =
-		mempool_create_slab_pool(1, zfcp_data.fsf_req_qtcb_cache);
-	if (!adapter->pool.fsf_req_abort)
+	adapter->pool.scsi_abort =
+		mempool_create_kmalloc_pool(1, sizeof(struct zfcp_fsf_req));
+	if (!adapter->pool.scsi_abort)
 		return -ENOMEM;
 
-	adapter->pool.fsf_req_status_read =
+	adapter->pool.status_read_req =
 		mempool_create_kmalloc_pool(FSF_STATUS_READS_RECOM,
 					    sizeof(struct zfcp_fsf_req));
-	if (!adapter->pool.fsf_req_status_read)
+	if (!adapter->pool.status_read_req)
+		return -ENOMEM;
+
+	adapter->pool.qtcb_pool =
+		mempool_create_slab_pool(3, zfcp_data.qtcb_cache);
+	if (!adapter->pool.qtcb_pool)
 		return -ENOMEM;
 
-	adapter->pool.data_status_read =
+	adapter->pool.status_read_data =
 		mempool_create_slab_pool(FSF_STATUS_READS_RECOM,
 					 zfcp_data.sr_buffer_cache);
-	if (!adapter->pool.data_status_read)
+	if (!adapter->pool.status_read_data)
 		return -ENOMEM;
 
-	adapter->pool.data_gid_pn =
+	adapter->pool.gid_pn_data =
 		mempool_create_slab_pool(1, zfcp_data.gid_pn_cache);
-	if (!adapter->pool.data_gid_pn)
+	if (!adapter->pool.gid_pn_data)
 		return -ENOMEM;
 
 	return 0;
@@ -392,18 +402,20 @@ static int zfcp_allocate_low_mem_buffers
 static void zfcp_free_low_mem_buffers(struct zfcp_adapter *adapter)
 {
 	/* zfcp_data.config_sema must be held */
-	if (adapter->pool.fsf_req_erp)
-		mempool_destroy(adapter->pool.fsf_req_erp);
-	if (adapter->pool.fsf_req_scsi)
-		mempool_destroy(adapter->pool.fsf_req_scsi);
-	if (adapter->pool.fsf_req_abort)
-		mempool_destroy(adapter->pool.fsf_req_abort);
-	if (adapter->pool.fsf_req_status_read)
-		mempool_destroy(adapter->pool.fsf_req_status_read);
-	if (adapter->pool.data_status_read)
-		mempool_destroy(adapter->pool.data_status_read);
-	if (adapter->pool.data_gid_pn)
-		mempool_destroy(adapter->pool.data_gid_pn);
+	if (adapter->pool.erp_req)
+		mempool_destroy(adapter->pool.erp_req);
+	if (adapter->pool.scsi_req)
+		mempool_destroy(adapter->pool.scsi_req);
+	if (adapter->pool.scsi_abort)
+		mempool_destroy(adapter->pool.scsi_abort);
+	if (adapter->pool.qtcb_pool)
+		mempool_destroy(adapter->pool.qtcb_pool);
+	if (adapter->pool.status_read_req)
+		mempool_destroy(adapter->pool.status_read_req);
+	if (adapter->pool.status_read_data)
+		mempool_destroy(adapter->pool.status_read_data);
+	if (adapter->pool.gid_pn_data)
+		mempool_destroy(adapter->pool.gid_pn_data);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:21.000000000 +0200
@@ -264,12 +264,13 @@ struct zfcp_fsf_req;
 
 /* holds various memory pools of an adapter */
 struct zfcp_adapter_mempool {
-	mempool_t *fsf_req_erp;
-	mempool_t *fsf_req_scsi;
-	mempool_t *fsf_req_abort;
-	mempool_t *fsf_req_status_read;
-	mempool_t *data_status_read;
-	mempool_t *data_gid_pn;
+	mempool_t *erp_req;
+	mempool_t *scsi_req;
+	mempool_t *scsi_abort;
+	mempool_t *status_read_req;
+	mempool_t *status_read_data;
+	mempool_t *gid_pn_data;
+	mempool_t *qtcb_pool;
 };
 
 /*
@@ -303,6 +304,15 @@ struct ct_iu_gid_pn_resp {
 	u32 d_id;
 } __attribute__ ((packed));
 
+struct ct_iu_gpn_ft_req {
+	struct ct_hdr header;
+	u8 flags;
+	u8 domain_id_scope;
+	u8 area_id_scope;
+	u8 fc4_type;
+} __attribute__ ((packed));
+
+
 /**
  * struct zfcp_send_ct - used to pass parameters to function zfcp_fsf_send_ct
  * @wka_port: port where the request is sent to
@@ -559,18 +569,13 @@ struct zfcp_data {
 						       lists */
 	struct semaphore        config_sema;        /* serialises configuration
 						       changes */
-	struct kmem_cache	*fsf_req_qtcb_cache;
+	struct kmem_cache	*gpn_ft_cache;
+	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;
 	struct workqueue_struct	*work_queue;
 };
 
-/* struct used by memory pools for fsf_requests */
-struct zfcp_fsf_req_qtcb {
-	struct zfcp_fsf_req fsf_req;
-	struct fsf_qtcb qtcb;
-};
-
 /********************** ZFCP SPECIFIC DEFINES ********************************/
 
 #define ZFCP_SET                0x00000100
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:13.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:21.000000000 +0200
@@ -25,14 +25,6 @@ static u32 rscn_range_mask[] = {
 	[RSCN_FABRIC_ADDRESS]		= 0x000000,
 };
 
-struct ct_iu_gpn_ft_req {
-	struct ct_hdr header;
-	u8 flags;
-	u8 domain_id_scope;
-	u8 area_id_scope;
-	u8 fc4_type;
-} __attribute__ ((packed));
-
 struct gpn_ft_resp_acc {
 	u8 control;
 	u8 port_id[3];
@@ -322,8 +314,7 @@ int static zfcp_fc_ns_gid_pn_request(str
 	init_completion(&compl_rec.done);
 	compl_rec.handler = zfcp_fc_ns_gid_pn_eval;
 	compl_rec.handler_data = (unsigned long) gid_pn;
-	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.fsf_req_erp,
-			       erp_action);
+	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.erp_req, erp_action);
 	if (!ret)
 		wait_for_completion(&compl_rec.done);
 	return ret;
@@ -340,7 +331,7 @@ int zfcp_fc_ns_gid_pn(struct zfcp_erp_ac
 	struct zfcp_gid_pn_data *gid_pn;
 	struct zfcp_adapter *adapter = erp_action->adapter;
 
-	gid_pn = mempool_alloc(adapter->pool.data_gid_pn, GFP_ATOMIC);
+	gid_pn = mempool_alloc(adapter->pool.gid_pn_data, GFP_ATOMIC);
 	if (!gid_pn)
 		return -ENOMEM;
 
@@ -354,7 +345,7 @@ int zfcp_fc_ns_gid_pn(struct zfcp_erp_ac
 
 	zfcp_wka_port_put(&adapter->gs->ds);
 out:
-	mempool_free(gid_pn, adapter->pool.data_gid_pn);
+	mempool_free(gid_pn, adapter->pool.gid_pn_data);
 	return ret;
 }
 
@@ -497,7 +488,7 @@ static void zfcp_free_sg_env(struct zfcp
 {
 	struct scatterlist *sg = &gpn_ft->sg_req;
 
-	kfree(sg_virt(sg)); /* free request buffer */
+	kmem_cache_free(zfcp_data.gpn_ft_cache, sg_virt(sg));
 	zfcp_sg_free_table(gpn_ft->sg_resp, buf_num);
 
 	kfree(gpn_ft);
@@ -512,7 +503,7 @@ static struct zfcp_gpn_ft *zfcp_alloc_sg
 	if (!gpn_ft)
 		return NULL;
 
-	req = kzalloc(sizeof(struct ct_iu_gpn_ft_req), GFP_KERNEL);
+	req = kmem_cache_alloc(zfcp_data.gpn_ft_cache, GFP_KERNEL);
 	if (!req) {
 		kfree(gpn_ft);
 		gpn_ft = NULL;
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-08-17 11:29:21.000000000 +0200
@@ -14,7 +14,6 @@
 #include "zfcp_dbf.h"
 
 #define ZFCP_REQ_AUTO_CLEANUP	0x00000002
-#define ZFCP_REQ_NO_QTCB	0x00000008
 
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
@@ -112,14 +111,15 @@ static void zfcp_fsf_class_not_supp(stru
 void zfcp_fsf_req_free(struct zfcp_fsf_req *req)
 {
 	if (likely(req->pool)) {
+		if (likely(req->qtcb))
+			mempool_free(req->qtcb, req->adapter->pool.qtcb_pool);
 		mempool_free(req, req->pool);
 		return;
 	}
 
-	if (req->qtcb) {
-		kmem_cache_free(zfcp_data.fsf_req_qtcb_cache, req);
-		return;
-	}
+	if (likely(req->qtcb))
+		kmem_cache_free(zfcp_data.qtcb_cache, req->qtcb);
+	kfree(req);
 }
 
 static void zfcp_fsf_status_read_port_closed(struct zfcp_fsf_req *req)
@@ -251,7 +251,7 @@ static void zfcp_fsf_status_read_handler
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_hba_dbf_event_fsf_unsol("dism", adapter, sr_buf);
-		mempool_free(sr_buf, adapter->pool.data_status_read);
+		mempool_free(sr_buf, adapter->pool.status_read_data);
 		zfcp_fsf_req_free(req);
 		return;
 	}
@@ -303,7 +303,7 @@ static void zfcp_fsf_status_read_handler
 		break;
 	}
 
-	mempool_free(sr_buf, adapter->pool.data_status_read);
+	mempool_free(sr_buf, adapter->pool.status_read_data);
 	zfcp_fsf_req_free(req);
 
 	atomic_inc(&adapter->stat_miss);
@@ -669,34 +669,37 @@ static int zfcp_fsf_req_sbal_get(struct 
 	return -EIO;
 }
 
-static struct zfcp_fsf_req *zfcp_fsf_alloc_noqtcb(mempool_t *pool)
+static struct zfcp_fsf_req *zfcp_fsf_alloc(mempool_t *pool)
 {
 	struct zfcp_fsf_req *req;
-	req = mempool_alloc(pool, GFP_ATOMIC);
-	if (!req)
+
+	if (likely(pool))
+		req = mempool_alloc(pool, GFP_ATOMIC);
+	else
+		req = kmalloc(sizeof(*req), GFP_ATOMIC);
+
+	if (unlikely(!req))
 		return NULL;
+
 	memset(req, 0, sizeof(*req));
 	req->pool = pool;
 	return req;
 }
 
-static struct zfcp_fsf_req *zfcp_fsf_alloc_qtcb(mempool_t *pool)
+static struct fsf_qtcb *zfcp_qtcb_alloc(mempool_t *pool)
 {
-	struct zfcp_fsf_req_qtcb *qtcb;
+	struct fsf_qtcb *qtcb;
 
 	if (likely(pool))
 		qtcb = mempool_alloc(pool, GFP_ATOMIC);
 	else
-		qtcb = kmem_cache_alloc(zfcp_data.fsf_req_qtcb_cache,
-					GFP_ATOMIC);
+		qtcb = kmem_cache_alloc(zfcp_data.qtcb_cache, GFP_ATOMIC);
+
 	if (unlikely(!qtcb))
 		return NULL;
 
 	memset(qtcb, 0, sizeof(*qtcb));
-	qtcb->fsf_req.qtcb = &qtcb->qtcb;
-	qtcb->fsf_req.pool = pool;
-
-	return &qtcb->fsf_req;
+	return qtcb;
 }
 
 static struct zfcp_fsf_req *zfcp_fsf_req_create(struct zfcp_adapter *adapter,
@@ -704,14 +707,8 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 						mempool_t *pool)
 {
 	struct qdio_buffer_element *sbale;
-
-	struct zfcp_fsf_req *req;
 	struct zfcp_qdio_queue *req_q = &adapter->req_q;
-
-	if (req_flags & ZFCP_REQ_NO_QTCB)
-		req = zfcp_fsf_alloc_noqtcb(pool);
-	else
-		req = zfcp_fsf_alloc_qtcb(pool);
+	struct zfcp_fsf_req *req = zfcp_fsf_alloc(pool);
 
 	if (unlikely(!req))
 		return ERR_PTR(-ENOMEM);
@@ -735,7 +732,17 @@ static struct zfcp_fsf_req *zfcp_fsf_req
 	sbale[0].addr = (void *) req->req_id;
 	sbale[0].flags |= SBAL_FLAGS0_COMMAND;
 
-	if (likely(req->qtcb)) {
+	if (likely(fsf_cmd != FSF_QTCB_UNSOLICITED_STATUS)) {
+		if (likely(pool))
+			req->qtcb = zfcp_qtcb_alloc(adapter->pool.qtcb_pool);
+		else
+			req->qtcb = zfcp_qtcb_alloc(NULL);
+
+		if (unlikely(!req->qtcb)) {
+			zfcp_fsf_req_free(req);
+			return ERR_PTR(-ENOMEM);
+		}
+
 		req->qtcb->prefix.req_seq_no = req->adapter->fsf_req_seq_no;
 		req->qtcb->prefix.req_id = req->req_id;
 		req->qtcb->prefix.ulp_info = 26;
@@ -811,9 +818,8 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 
-	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS,
-				  ZFCP_REQ_NO_QTCB,
-				  adapter->pool.fsf_req_status_read);
+	req = zfcp_fsf_req_create(adapter, FSF_QTCB_UNSOLICITED_STATUS, 0,
+				  adapter->pool.status_read_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -823,7 +829,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	sbale[2].flags |= SBAL_FLAGS_LAST_ENTRY;
 	req->sbale_curr = 2;
 
-	sr_buf = mempool_alloc(adapter->pool.data_status_read, GFP_ATOMIC);
+	sr_buf = mempool_alloc(adapter->pool.status_read_data, GFP_ATOMIC);
 	if (!sr_buf) {
 		retval = -ENOMEM;
 		goto failed_buf;
@@ -841,7 +847,7 @@ int zfcp_fsf_status_read(struct zfcp_ada
 	goto out;
 
 failed_req_send:
-	mempool_free(sr_buf, adapter->pool.data_status_read);
+	mempool_free(sr_buf, adapter->pool.status_read_data);
 failed_buf:
 	zfcp_fsf_req_free(req);
 	zfcp_hba_dbf_event_fsf_unsol("fail", adapter, NULL);
@@ -919,7 +925,7 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_ABORT_FCP_CMND,
-				  0, adapter->pool.fsf_req_abort);
+				  0, adapter->pool.scsi_abort);
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;
@@ -1231,7 +1237,7 @@ int zfcp_fsf_exchange_config_data(struct
 	req = zfcp_fsf_req_create(adapter,
 				  FSF_QTCB_EXCHANGE_CONFIG_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1327,7 +1333,7 @@ int zfcp_fsf_exchange_port_data(struct z
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_PORT_DATA,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1497,7 +1503,7 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	req = zfcp_fsf_req_create(adapter,
 				  FSF_QTCB_OPEN_PORT_WITH_DID,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1566,7 +1572,7 @@ int zfcp_fsf_close_port(struct zfcp_erp_
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1643,7 +1649,7 @@ int zfcp_fsf_open_wka_port(struct zfcp_w
 	req = zfcp_fsf_req_create(adapter,
 				  FSF_QTCB_OPEN_PORT_WITH_DID,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1697,7 +1703,7 @@ int zfcp_fsf_close_wka_port(struct zfcp_
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (unlikely(IS_ERR(req))) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1788,7 +1794,7 @@ int zfcp_fsf_close_physical_port(struct 
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_PHYSICAL_PORT,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -1960,7 +1966,7 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_OPEN_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -2045,7 +2051,7 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_CLOSE_LUN,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_erp);
+				  adapter->pool.erp_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -2349,7 +2355,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	}
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
 				  ZFCP_REQ_AUTO_CLEANUP,
-				  adapter->pool.fsf_req_scsi);
+				  adapter->pool.scsi_req);
 	if (IS_ERR(req)) {
 		retval = PTR_ERR(req);
 		goto out;
@@ -2460,7 +2466,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND, 0,
-				  adapter->pool.fsf_req_scsi);
+				  adapter->pool.scsi_req);
 	if (IS_ERR(req)) {
 		req = NULL;
 		goto out;

