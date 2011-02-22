From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 03/11] zfcp: Replace kmem_cache for "status read" data
Date: Tue, 22 Feb 2011 19:54:40 +0100
Message-ID: <20110222185536.276224234@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33968 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab1BVSzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:41 -0500
Content-Disposition: inline; filename=703-zfcp-kmem-cache-status.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp requires a mempool for the status read data blocks to resubmit
the "status read" requests at any time. Each status read data block
has the size of a page (4096 bytes) and needs to be placed in one
page.

Instead of having a kmem_cache for allocating page sized chunks, use
mempool_create_page_pool to create a mempool returning pages and
remove the zfcp kmem_cache.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c |   20 ++++++--------------
 drivers/s390/scsi/zfcp_def.h |    3 +--
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_fsf.c |   12 +++++++-----
 4 files changed, 15 insertions(+), 22 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -132,11 +132,6 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.qtcb_cache)
 		goto out_qtcb_cache;
 
-	zfcp_data.sr_buffer_cache = zfcp_cache_hw_align("zfcp_sr",
-					sizeof(struct fsf_status_read_buffer));
-	if (!zfcp_data.sr_buffer_cache)
-		goto out_sr_cache;
-
 	zfcp_data.gid_pn_cache = zfcp_cache_hw_align("zfcp_gid",
 					sizeof(struct zfcp_fc_gid_pn));
 	if (!zfcp_data.gid_pn_cache)
@@ -181,8 +176,6 @@ out_transport:
 out_adisc_cache:
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 out_gid_cache:
-	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
-out_sr_cache:
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 out_qtcb_cache:
 	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
@@ -199,7 +192,6 @@ static void __exit zfcp_module_exit(void
 	fc_release_transport(zfcp_data.scsi_transport_template);
 	kmem_cache_destroy(zfcp_data.adisc_cache);
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
-	kmem_cache_destroy(zfcp_data.sr_buffer_cache);
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
 }
@@ -264,10 +256,10 @@ static int zfcp_allocate_low_mem_buffers
 	if (!adapter->pool.qtcb_pool)
 		return -ENOMEM;
 
-	adapter->pool.status_read_data =
-		mempool_create_slab_pool(FSF_STATUS_READS_RECOM,
-					 zfcp_data.sr_buffer_cache);
-	if (!adapter->pool.status_read_data)
+	BUILD_BUG_ON(sizeof(struct fsf_status_read_buffer) > PAGE_SIZE);
+	adapter->pool.sr_data =
+		mempool_create_page_pool(FSF_STATUS_READS_RECOM, 0);
+	if (!adapter->pool.sr_data)
 		return -ENOMEM;
 
 	adapter->pool.gid_pn =
@@ -290,8 +282,8 @@ static void zfcp_free_low_mem_buffers(st
 		mempool_destroy(adapter->pool.qtcb_pool);
 	if (adapter->pool.status_read_req)
 		mempool_destroy(adapter->pool.status_read_req);
-	if (adapter->pool.status_read_data)
-		mempool_destroy(adapter->pool.status_read_data);
+	if (adapter->pool.sr_data)
+		mempool_destroy(adapter->pool.sr_data);
 	if (adapter->pool.gid_pn)
 		mempool_destroy(adapter->pool.gid_pn);
 }
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -107,7 +107,7 @@ struct zfcp_adapter_mempool {
 	mempool_t *scsi_req;
 	mempool_t *scsi_abort;
 	mempool_t *status_read_req;
-	mempool_t *status_read_data;
+	mempool_t *sr_data;
 	mempool_t *gid_pn;
 	mempool_t *qtcb_pool;
 };
@@ -319,7 +319,6 @@ struct zfcp_data {
 	struct scsi_transport_template *scsi_transport_template;
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
-	struct kmem_cache	*sr_buffer_cache;
 	struct kmem_cache	*gid_pn_cache;
 	struct kmem_cache	*adisc_cache;
 };
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -732,7 +732,7 @@ static int zfcp_erp_adapter_strategy_ope
 	if (zfcp_erp_adapter_strategy_open_fsf_xport(act) == ZFCP_ERP_FAILED)
 		return ZFCP_ERP_FAILED;
 
-	if (mempool_resize(act->adapter->pool.status_read_data,
+	if (mempool_resize(act->adapter->pool.sr_data,
 			   act->adapter->stat_read_buf_num, GFP_KERNEL))
 		return ZFCP_ERP_FAILED;
 
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -212,7 +212,7 @@ static void zfcp_fsf_status_read_handler
 
 	if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED) {
 		zfcp_dbf_hba_fsf_uss("fssrh_1", req);
-		mempool_free(sr_buf, adapter->pool.status_read_data);
+		mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
 		zfcp_fsf_req_free(req);
 		return;
 	}
@@ -265,7 +265,7 @@ static void zfcp_fsf_status_read_handler
 		break;
 	}
 
-	mempool_free(sr_buf, adapter->pool.status_read_data);
+	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
 	zfcp_fsf_req_free(req);
 
 	atomic_inc(&adapter->stat_miss);
@@ -723,6 +723,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 	struct zfcp_adapter *adapter = qdio->adapter;
 	struct zfcp_fsf_req *req;
 	struct fsf_status_read_buffer *sr_buf;
+	struct page *page;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -736,11 +737,12 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 		goto out;
 	}
 
-	sr_buf = mempool_alloc(adapter->pool.status_read_data, GFP_ATOMIC);
-	if (!sr_buf) {
+	page = mempool_alloc(adapter->pool.sr_data, GFP_ATOMIC);
+	if (!page) {
 		retval = -ENOMEM;
 		goto failed_buf;
 	}
+	sr_buf = page_address(page);
 	memset(sr_buf, 0, sizeof(*sr_buf));
 	req->data = sr_buf;
 
@@ -755,7 +757,7 @@ int zfcp_fsf_status_read(struct zfcp_qdi
 
 failed_req_send:
 	req->data = NULL;
-	mempool_free(sr_buf, adapter->pool.status_read_data);
+	mempool_free(virt_to_page(sr_buf), adapter->pool.sr_data);
 failed_buf:
 	zfcp_dbf_hba_fsf_uss("fssr__1", req);
 	zfcp_fsf_req_free(req);

