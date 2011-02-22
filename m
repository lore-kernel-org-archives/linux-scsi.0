From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 04/11] zfcp: Introduce new kmem_cache for FC request and response data
Date: Tue, 22 Feb 2011 19:54:41 +0100
Message-ID: <20110222185536.427694219@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:60843 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702Ab1BVSzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:39 -0500
Content-Disposition: inline; filename=704-zfcp-kmem-cache-fc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

A data buffer that is passed to the hardware must not cross a page
boundary. zfcp uses a series of kmem_caches to align the data to not
cross a page boundary. Introduce a new kmem_cache for the FC requests
sent from the zfcp driver and use it for the ELS ADISC data.  The goal
is to migrate to the FC kmem_cache in later patches and remove the
request specific kmem_caches.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c |   14 ++++++-------
 drivers/s390/scsi/zfcp_def.h |    1 
 drivers/s390/scsi/zfcp_ext.h |    1 
 drivers/s390/scsi/zfcp_fc.c  |   46 ++++++++++++++++++++++---------------------
 drivers/s390/scsi/zfcp_fc.h  |   27 ++++++++++++++-----------
 5 files changed, 47 insertions(+), 42 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -137,10 +137,10 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
-	zfcp_data.adisc_cache = zfcp_cache_hw_align("zfcp_adisc",
-					sizeof(struct zfcp_fc_els_adisc));
-	if (!zfcp_data.adisc_cache)
-		goto out_adisc_cache;
+	zfcp_fc_req_cache = zfcp_cache_hw_align("zfcp_fc_req",
+						sizeof(struct zfcp_fc_req));
+	if (!zfcp_fc_req_cache)
+		goto out_fc_cache;
 
 	zfcp_data.scsi_transport_template =
 		fc_attach_transport(&zfcp_transport_functions);
@@ -172,8 +172,8 @@ out_ccw_register:
 out_misc:
 	fc_release_transport(zfcp_data.scsi_transport_template);
 out_transport:
-	kmem_cache_destroy(zfcp_data.adisc_cache);
-out_adisc_cache:
+	kmem_cache_destroy(zfcp_fc_req_cache);
+out_fc_cache:
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 out_gid_cache:
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
@@ -190,7 +190,7 @@ static void __exit zfcp_module_exit(void
 	ccw_driver_unregister(&zfcp_ccw_driver);
 	misc_deregister(&zfcp_cfdc_misc);
 	fc_release_transport(zfcp_data.scsi_transport_template);
-	kmem_cache_destroy(zfcp_data.adisc_cache);
+	kmem_cache_destroy(zfcp_fc_req_cache);
 	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -320,7 +320,6 @@ struct zfcp_data {
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
 	struct kmem_cache	*gid_pn_cache;
-	struct kmem_cache	*adisc_cache;
 };
 
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -80,6 +80,7 @@ extern void zfcp_erp_notify(struct zfcp_
 extern void zfcp_erp_timeout_handler(unsigned long);
 
 /* zfcp_fc.c */
+extern struct kmem_cache *zfcp_fc_req_cache;
 extern void zfcp_fc_enqueue_event(struct zfcp_adapter *,
 				enum fc_host_event_code event_code, u32);
 extern void zfcp_fc_post_event(struct work_struct *);
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -16,6 +16,8 @@
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 
+struct kmem_cache *zfcp_fc_req_cache;
+
 static u32 zfcp_fc_rscn_range_mask[] = {
 	[ELS_ADDR_FMT_PORT]		= 0xFFFFFF,
 	[ELS_ADDR_FMT_AREA]		= 0xFFFF00,
@@ -419,11 +421,11 @@ void zfcp_fc_plogi_evaluate(struct zfcp_
 
 static void zfcp_fc_adisc_handler(void *data)
 {
-	struct zfcp_fc_els_adisc *adisc = data;
-	struct zfcp_port *port = adisc->els.port;
-	struct fc_els_adisc *adisc_resp = &adisc->adisc_resp;
+	struct zfcp_fc_req *fc_req = data;
+	struct zfcp_port *port = fc_req->ct_els.port;
+	struct fc_els_adisc *adisc_resp = &fc_req->u.adisc.rsp;
 
-	if (adisc->els.status) {
+	if (fc_req->ct_els.status) {
 		/* request rejected or timed out */
 		zfcp_erp_port_forced_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
 					    "fcadh_1");
@@ -445,42 +447,42 @@ static void zfcp_fc_adisc_handler(void *
  out:
 	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
 	put_device(&port->dev);
-	kmem_cache_free(zfcp_data.adisc_cache, adisc);
+	kmem_cache_free(zfcp_fc_req_cache, fc_req);
 }
 
 static int zfcp_fc_adisc(struct zfcp_port *port)
 {
-	struct zfcp_fc_els_adisc *adisc;
+	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
+	struct Scsi_Host *shost = adapter->scsi_host;
 	int ret;
 
-	adisc = kmem_cache_zalloc(zfcp_data.adisc_cache, GFP_ATOMIC);
-	if (!adisc)
+	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_ATOMIC);
+	if (!fc_req)
 		return -ENOMEM;
 
-	adisc->els.port = port;
-	adisc->els.req = &adisc->req;
-	adisc->els.resp = &adisc->resp;
-	sg_init_one(adisc->els.req, &adisc->adisc_req,
+	fc_req->ct_els.port = port;
+	fc_req->ct_els.req = &fc_req->sg_req;
+	fc_req->ct_els.resp = &fc_req->sg_rsp;
+	sg_init_one(&fc_req->sg_req, &fc_req->u.adisc.req,
 		    sizeof(struct fc_els_adisc));
-	sg_init_one(adisc->els.resp, &adisc->adisc_resp,
+	sg_init_one(&fc_req->sg_rsp, &fc_req->u.adisc.rsp,
 		    sizeof(struct fc_els_adisc));
 
-	adisc->els.handler = zfcp_fc_adisc_handler;
-	adisc->els.handler_data = adisc;
+	fc_req->ct_els.handler = zfcp_fc_adisc_handler;
+	fc_req->ct_els.handler_data = fc_req;
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
-	adisc->adisc_req.adisc_wwpn = fc_host_port_name(adapter->scsi_host);
-	adisc->adisc_req.adisc_wwnn = fc_host_node_name(adapter->scsi_host);
-	adisc->adisc_req.adisc_cmd = ELS_ADISC;
-	hton24(adisc->adisc_req.adisc_port_id,
-	       fc_host_port_id(adapter->scsi_host));
+	fc_req->u.adisc.req.adisc_wwpn = fc_host_port_name(shost);
+	fc_req->u.adisc.req.adisc_wwnn = fc_host_node_name(shost);
+	fc_req->u.adisc.req.adisc_cmd = ELS_ADISC;
+	hton24(fc_req->u.adisc.req.adisc_port_id, fc_host_port_id(shost));
 
-	ret = zfcp_fsf_send_els(adapter, port->d_id, &adisc->els,
+	ret = zfcp_fsf_send_els(adapter, port->d_id, &fc_req->ct_els,
 				ZFCP_FC_CTELS_TMO);
 	if (ret)
-		kmem_cache_free(zfcp_data.adisc_cache, adisc);
+		kmem_cache_free(zfcp_fc_req_cache, fc_req);
 
 	return ret;
 }
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -123,19 +123,22 @@ struct zfcp_fc_gpn_ft {
 };
 
 /**
- * struct zfcp_fc_els_adisc - everything required in zfcp for issuing ELS ADISC
- * @els: data required for issuing els fsf command
- * @req: scatterlist entry for ELS ADISC request
- * @resp: scatterlist entry for ELS ADISC response
- * @adisc_req: ELS ADISC request data
- * @adisc_resp: ELS ADISC response data
+ * struct zfcp_fc_req - Container for FC ELS and CT requests sent from zfcp
+ * @ct_els: data required for issuing fsf command
+ * @sg_req: scatterlist entry for request data
+ * @sg_rsp: scatterlist entry for response data
+ * @u: request specific data
  */
-struct zfcp_fc_els_adisc {
-	struct zfcp_fsf_ct_els els;
-	struct scatterlist req;
-	struct scatterlist resp;
-	struct fc_els_adisc adisc_req;
-	struct fc_els_adisc adisc_resp;
+struct zfcp_fc_req {
+	struct zfcp_fsf_ct_els				ct_els;
+	struct scatterlist				sg_req;
+	struct scatterlist				sg_rsp;
+	union {
+		struct {
+			struct fc_els_adisc		req;
+			struct fc_els_adisc		rsp;
+		} adisc;
+	} u;
 };
 
 /**

