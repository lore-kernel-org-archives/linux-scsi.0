From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 05/11] zfcp: Allocate GID_PN data through new FC kmem_cache
Date: Tue, 22 Feb 2011 19:54:42 +0100
Message-ID: <20110222185536.579180734@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:33967 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab1BVSzl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:41 -0500
Content-Disposition: inline; filename=705-zfcp-alloc-gid-pn.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Allocate the data for the GID_PN request through the new FC
kmem_cache. While updating the GID_PN code, also introduce a helper
function for initializing the CT header for FC nameserver requests.
Remove the "paranoia" check as well, the GID_PN request data does not
suddenly change.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c |   10 -----
 drivers/s390/scsi/zfcp_def.h |    1 
 drivers/s390/scsi/zfcp_fc.c  |   78 ++++++++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_fc.h  |   25 +++----------
 4 files changed, 45 insertions(+), 69 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -132,11 +132,6 @@ static int __init zfcp_module_init(void)
 	if (!zfcp_data.qtcb_cache)
 		goto out_qtcb_cache;
 
-	zfcp_data.gid_pn_cache = zfcp_cache_hw_align("zfcp_gid",
-					sizeof(struct zfcp_fc_gid_pn));
-	if (!zfcp_data.gid_pn_cache)
-		goto out_gid_cache;
-
 	zfcp_fc_req_cache = zfcp_cache_hw_align("zfcp_fc_req",
 						sizeof(struct zfcp_fc_req));
 	if (!zfcp_fc_req_cache)
@@ -174,8 +169,6 @@ out_misc:
 out_transport:
 	kmem_cache_destroy(zfcp_fc_req_cache);
 out_fc_cache:
-	kmem_cache_destroy(zfcp_data.gid_pn_cache);
-out_gid_cache:
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 out_qtcb_cache:
 	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
@@ -191,7 +184,6 @@ static void __exit zfcp_module_exit(void
 	misc_deregister(&zfcp_cfdc_misc);
 	fc_release_transport(zfcp_data.scsi_transport_template);
 	kmem_cache_destroy(zfcp_fc_req_cache);
-	kmem_cache_destroy(zfcp_data.gid_pn_cache);
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
 }
@@ -263,7 +255,7 @@ static int zfcp_allocate_low_mem_buffers
 		return -ENOMEM;
 
 	adapter->pool.gid_pn =
-		mempool_create_slab_pool(1, zfcp_data.gid_pn_cache);
+		mempool_create_slab_pool(1, zfcp_fc_req_cache);
 	if (!adapter->pool.gid_pn)
 		return -ENOMEM;
 
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -319,7 +319,6 @@ struct zfcp_data {
 	struct scsi_transport_template *scsi_transport_template;
 	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
-	struct kmem_cache	*gid_pn_cache;
 };
 
 #endif /* ZFCP_DEF_H */
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -262,24 +262,18 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 		zfcp_fc_incoming_rscn(fsf_req);
 }
 
-static void zfcp_fc_ns_gid_pn_eval(void *data)
+static void zfcp_fc_ns_gid_pn_eval(struct zfcp_fc_req *fc_req)
 {
-	struct zfcp_fc_gid_pn *gid_pn = data;
-	struct zfcp_fsf_ct_els *ct = &gid_pn->ct;
-	struct zfcp_fc_gid_pn_req *gid_pn_req = sg_virt(ct->req);
-	struct zfcp_fc_gid_pn_resp *gid_pn_resp = sg_virt(ct->resp);
-	struct zfcp_port *port = gid_pn->port;
+	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
+	struct zfcp_fc_gid_pn_rsp *gid_pn_rsp = &fc_req->u.gid_pn.rsp;
 
-	if (ct->status)
+	if (ct_els->status)
 		return;
-	if (gid_pn_resp->ct_hdr.ct_cmd != FC_FS_ACC)
+	if (gid_pn_rsp->ct_hdr.ct_cmd != FC_FS_ACC)
 		return;
 
-	/* paranoia */
-	if (gid_pn_req->gid_pn.fn_wwpn != port->wwpn)
-		return;
 	/* looks like a valid d_id */
-	port->d_id = ntoh24(gid_pn_resp->gid_pn.fp_fid);
+	ct_els->port->d_id = ntoh24(gid_pn_rsp->gid_pn.fp_fid);
 }
 
 static void zfcp_fc_complete(void *data)
@@ -287,69 +281,73 @@ static void zfcp_fc_complete(void *data)
 	complete(data);
 }
 
+static void zfcp_fc_ct_ns_init(struct fc_ct_hdr *ct_hdr, u16 cmd, u16 mr_size)
+{
+	ct_hdr->ct_rev = FC_CT_REV;
+	ct_hdr->ct_fs_type = FC_FST_DIR;
+	ct_hdr->ct_fs_subtype = FC_NS_SUBTYPE;
+	ct_hdr->ct_cmd = cmd;
+	ct_hdr->ct_mr_size = mr_size / 4;
+}
+
 static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
-				     struct zfcp_fc_gid_pn *gid_pn)
+				     struct zfcp_fc_req *fc_req)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 	DECLARE_COMPLETION_ONSTACK(completion);
+	struct zfcp_fc_gid_pn_req *gid_pn_req = &fc_req->u.gid_pn.req;
+	struct zfcp_fc_gid_pn_rsp *gid_pn_rsp = &fc_req->u.gid_pn.rsp;
 	int ret;
 
 	/* setup parameters for send generic command */
-	gid_pn->port = port;
-	gid_pn->ct.handler = zfcp_fc_complete;
-	gid_pn->ct.handler_data = &completion;
-	gid_pn->ct.req = &gid_pn->sg_req;
-	gid_pn->ct.resp = &gid_pn->sg_resp;
-	sg_init_one(&gid_pn->sg_req, &gid_pn->gid_pn_req,
-		    sizeof(struct zfcp_fc_gid_pn_req));
-	sg_init_one(&gid_pn->sg_resp, &gid_pn->gid_pn_resp,
-		    sizeof(struct zfcp_fc_gid_pn_resp));
-
-	/* setup nameserver request */
-	gid_pn->gid_pn_req.ct_hdr.ct_rev = FC_CT_REV;
-	gid_pn->gid_pn_req.ct_hdr.ct_fs_type = FC_FST_DIR;
-	gid_pn->gid_pn_req.ct_hdr.ct_fs_subtype = FC_NS_SUBTYPE;
-	gid_pn->gid_pn_req.ct_hdr.ct_options = 0;
-	gid_pn->gid_pn_req.ct_hdr.ct_cmd = FC_NS_GID_PN;
-	gid_pn->gid_pn_req.ct_hdr.ct_mr_size = ZFCP_FC_CT_SIZE_PAGE / 4;
-	gid_pn->gid_pn_req.gid_pn.fn_wwpn = port->wwpn;
+	fc_req->ct_els.port = port;
+	fc_req->ct_els.handler = zfcp_fc_complete;
+	fc_req->ct_els.handler_data = &completion;
+	fc_req->ct_els.req = &fc_req->sg_req;
+	fc_req->ct_els.resp = &fc_req->sg_rsp;
+	sg_init_one(&fc_req->sg_req, gid_pn_req, sizeof(*gid_pn_req));
+	sg_init_one(&fc_req->sg_rsp, gid_pn_rsp, sizeof(*gid_pn_rsp));
+
+	zfcp_fc_ct_ns_init(&gid_pn_req->ct_hdr,
+			   FC_NS_GID_PN, ZFCP_FC_CT_SIZE_PAGE);
+	gid_pn_req->gid_pn.fn_wwpn = port->wwpn;
 
-	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &gid_pn->ct,
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &fc_req->ct_els,
 			       adapter->pool.gid_pn_req,
 			       ZFCP_FC_CTELS_TMO);
 	if (!ret) {
 		wait_for_completion(&completion);
-		zfcp_fc_ns_gid_pn_eval(gid_pn);
+		zfcp_fc_ns_gid_pn_eval(fc_req);
 	}
 	return ret;
 }
 
 /**
- * zfcp_fc_ns_gid_pn_request - initiate GID_PN nameserver request
+ * zfcp_fc_ns_gid_pn - initiate GID_PN nameserver request
  * @port: port where GID_PN request is needed
  * return: -ENOMEM on error, 0 otherwise
  */
 static int zfcp_fc_ns_gid_pn(struct zfcp_port *port)
 {
 	int ret;
-	struct zfcp_fc_gid_pn *gid_pn;
+	struct zfcp_fc_req *fc_req;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	gid_pn = mempool_alloc(adapter->pool.gid_pn, GFP_ATOMIC);
-	if (!gid_pn)
+	fc_req = mempool_alloc(adapter->pool.gid_pn, GFP_ATOMIC);
+	if (!fc_req)
 		return -ENOMEM;
 
-	memset(gid_pn, 0, sizeof(*gid_pn));
+	memset(fc_req, 0, sizeof(*fc_req));
 
 	ret = zfcp_fc_wka_port_get(&adapter->gs->ds);
 	if (ret)
 		goto out;
 
-	ret = zfcp_fc_ns_gid_pn_request(port, gid_pn);
+	ret = zfcp_fc_ns_gid_pn_request(port, fc_req);
 
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
 out:
-	mempool_free(gid_pn, adapter->pool.gid_pn);
+	mempool_free(fc_req, adapter->pool.gid_pn);
 	return ret;
 }
 
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -64,33 +64,16 @@ struct zfcp_fc_gid_pn_req {
 } __packed;
 
 /**
- * struct zfcp_fc_gid_pn_resp - container for ct header plus gid_pn response
+ * struct zfcp_fc_gid_pn_rsp - container for ct header plus gid_pn response
  * @ct_hdr: FC GS common transport header
  * @gid_pn: GID_PN response
  */
-struct zfcp_fc_gid_pn_resp {
+struct zfcp_fc_gid_pn_rsp {
 	struct fc_ct_hdr	ct_hdr;
 	struct fc_gid_pn_resp	gid_pn;
 } __packed;
 
 /**
- * struct zfcp_fc_gid_pn - everything required in zfcp for gid_pn request
- * @ct: data passed to zfcp_fsf for issuing fsf request
- * @sg_req: scatterlist entry for request data
- * @sg_resp: scatterlist entry for response data
- * @gid_pn_req: GID_PN request data
- * @gid_pn_resp: GID_PN response data
- */
-struct zfcp_fc_gid_pn {
-	struct zfcp_fsf_ct_els ct;
-	struct scatterlist sg_req;
-	struct scatterlist sg_resp;
-	struct zfcp_fc_gid_pn_req gid_pn_req;
-	struct zfcp_fc_gid_pn_resp gid_pn_resp;
-	struct zfcp_port *port;
-};
-
-/**
  * struct zfcp_fc_gpn_ft - container for ct header plus gpn_ft request
  * @ct_hdr: FC GS common transport header
  * @gpn_ft: GPN_FT request
@@ -138,6 +121,10 @@ struct zfcp_fc_req {
 			struct fc_els_adisc		req;
 			struct fc_els_adisc		rsp;
 		} adisc;
+		struct {
+			struct zfcp_fc_gid_pn_req	req;
+			struct zfcp_fc_gid_pn_rsp	rsp;
+		} gid_pn;
 	} u;
 };
 

