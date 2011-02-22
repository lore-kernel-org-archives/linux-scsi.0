From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 07/11] zfcp: Move qtcb kmem_cache to zfcp_fsf.c
Date: Tue, 22 Feb 2011 19:54:44 +0100
Message-ID: <20110222185536.886880858@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33969 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab1BVSzk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:40 -0500
Content-Disposition: inline; filename=707-zfcp-kmem-cache-qtcb.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Move the kmem_cache for allocating the qtcb to zfcp_fsf.c and rename
it accordingly.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c |   12 ++++++------
 drivers/s390/scsi/zfcp_def.h |    1 -
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fsf.c |    6 ++++--
 4 files changed, 11 insertions(+), 9 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -122,9 +122,9 @@ static int __init zfcp_module_init(void)
 {
 	int retval = -ENOMEM;
 
-	zfcp_data.qtcb_cache = zfcp_cache_hw_align("zfcp_qtcb",
-					sizeof(struct fsf_qtcb));
-	if (!zfcp_data.qtcb_cache)
+	zfcp_fsf_qtcb_cache = zfcp_cache_hw_align("zfcp_fsf_qtcb",
+						  sizeof(struct fsf_qtcb));
+	if (!zfcp_fsf_qtcb_cache)
 		goto out_qtcb_cache;
 
 	zfcp_fc_req_cache = zfcp_cache_hw_align("zfcp_fc_req",
@@ -164,7 +164,7 @@ out_misc:
 out_transport:
 	kmem_cache_destroy(zfcp_fc_req_cache);
 out_fc_cache:
-	kmem_cache_destroy(zfcp_data.qtcb_cache);
+	kmem_cache_destroy(zfcp_fsf_qtcb_cache);
 out_qtcb_cache:
 	return retval;
 }
@@ -177,7 +177,7 @@ static void __exit zfcp_module_exit(void
 	misc_deregister(&zfcp_cfdc_misc);
 	fc_release_transport(zfcp_data.scsi_transport_template);
 	kmem_cache_destroy(zfcp_fc_req_cache);
-	kmem_cache_destroy(zfcp_data.qtcb_cache);
+	kmem_cache_destroy(zfcp_fsf_qtcb_cache);
 }
 
 module_exit(zfcp_module_exit);
@@ -236,7 +236,7 @@ static int zfcp_allocate_low_mem_buffers
 		return -ENOMEM;
 
 	adapter->pool.qtcb_pool =
-		mempool_create_slab_pool(4, zfcp_data.qtcb_cache);
+		mempool_create_slab_pool(4, zfcp_fsf_qtcb_cache);
 	if (!adapter->pool.qtcb_pool)
 		return -ENOMEM;
 
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -317,7 +317,6 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-	struct kmem_cache	*qtcb_cache;
 };
 
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -98,6 +98,7 @@ extern int zfcp_fc_exec_bsg_job(struct f
 extern int zfcp_fc_timeout_bsg_job(struct fc_bsg_job *);
 
 /* zfcp_fsf.c */
+extern struct kmem_cache *zfcp_fsf_qtcb_cache;
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *);
 extern int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *);
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -18,6 +18,8 @@
 #include "zfcp_qdio.h"
 #include "zfcp_reqlist.h"
 
+struct kmem_cache *zfcp_fsf_qtcb_cache;
+
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
@@ -83,7 +85,7 @@ void zfcp_fsf_req_free(struct zfcp_fsf_r
 	}
 
 	if (likely(req->qtcb))
-		kmem_cache_free(zfcp_data.qtcb_cache, req->qtcb);
+		kmem_cache_free(zfcp_fsf_qtcb_cache, req->qtcb);
 	kfree(req);
 }
 
@@ -628,7 +630,7 @@ static struct fsf_qtcb *zfcp_qtcb_alloc(
 	if (likely(pool))
 		qtcb = mempool_alloc(pool, GFP_ATOMIC);
 	else
-		qtcb = kmem_cache_alloc(zfcp_data.qtcb_cache, GFP_ATOMIC);
+		qtcb = kmem_cache_alloc(zfcp_fsf_qtcb_cache, GFP_ATOMIC);
 
 	if (unlikely(!qtcb))
 		return NULL;

