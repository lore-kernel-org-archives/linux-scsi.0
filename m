From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 06/11] zfcp: Use common FC kmem_cache for GPN_FT request
Date: Tue, 22 Feb 2011 19:54:43 +0100
Message-ID: <20110222185536.731418124@linux.vnet.ibm.com>
References: <20110222185437.385767855@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:59149 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab1BVSzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Feb 2011 13:55:39 -0500
Content-Disposition: inline; filename=706-zfcp-alloc-gpn-ft.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Switch the allocation of the GPN_FT request data to the FC kmem_cache
and remove the zfcp_gpn kmem_cache.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---


 drivers/s390/scsi/zfcp_aux.c |    8 ---
 drivers/s390/scsi/zfcp_def.h |    1 
 drivers/s390/scsi/zfcp_fc.c  |   87 +++++++++++++++----------------------------
 drivers/s390/scsi/zfcp_fc.h  |   26 +-----------
 4 files changed, 35 insertions(+), 87 deletions(-)
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -122,11 +122,6 @@ static int __init zfcp_module_init(void)
 {
 	int retval = -ENOMEM;
 
-	zfcp_data.gpn_ft_cache = zfcp_cache_hw_align("zfcp_gpn",
-					sizeof(struct zfcp_fc_gpn_ft_req));
-	if (!zfcp_data.gpn_ft_cache)
-		goto out;
-
 	zfcp_data.qtcb_cache = zfcp_cache_hw_align("zfcp_qtcb",
 					sizeof(struct fsf_qtcb));
 	if (!zfcp_data.qtcb_cache)
@@ -171,8 +166,6 @@ out_transport:
 out_fc_cache:
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
 out_qtcb_cache:
-	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
-out:
 	return retval;
 }
 
@@ -185,7 +178,6 @@ static void __exit zfcp_module_exit(void
 	fc_release_transport(zfcp_data.scsi_transport_template);
 	kmem_cache_destroy(zfcp_fc_req_cache);
 	kmem_cache_destroy(zfcp_data.qtcb_cache);
-	kmem_cache_destroy(zfcp_data.gpn_ft_cache);
 }
 
 module_exit(zfcp_module_exit);
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -317,7 +317,6 @@ struct zfcp_fsf_req {
 struct zfcp_data {
 	struct scsi_host_template scsi_host_template;
 	struct scsi_transport_template *scsi_transport_template;
-	struct kmem_cache	*gpn_ft_cache;
 	struct kmem_cache	*qtcb_cache;
 };
 
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -528,68 +528,42 @@ void zfcp_fc_test_link(struct zfcp_port
 		put_device(&port->dev);
 }
 
-static void zfcp_free_sg_env(struct zfcp_fc_gpn_ft *gpn_ft, int buf_num)
+static struct zfcp_fc_req *zfcp_alloc_sg_env(int buf_num)
 {
-	struct scatterlist *sg = &gpn_ft->sg_req;
+	struct zfcp_fc_req *fc_req;
 
-	kmem_cache_free(zfcp_data.gpn_ft_cache, sg_virt(sg));
-	zfcp_sg_free_table(gpn_ft->sg_resp, buf_num);
-
-	kfree(gpn_ft);
-}
-
-static struct zfcp_fc_gpn_ft *zfcp_alloc_sg_env(int buf_num)
-{
-	struct zfcp_fc_gpn_ft *gpn_ft;
-	struct zfcp_fc_gpn_ft_req *req;
-
-	gpn_ft = kzalloc(sizeof(*gpn_ft), GFP_KERNEL);
-	if (!gpn_ft)
+	fc_req = kmem_cache_zalloc(zfcp_fc_req_cache, GFP_KERNEL);
+	if (!fc_req)
 		return NULL;
 
-	req = kmem_cache_zalloc(zfcp_data.gpn_ft_cache, GFP_KERNEL);
-	if (!req) {
-		kfree(gpn_ft);
-		gpn_ft = NULL;
-		goto out;
+	if (zfcp_sg_setup_table(&fc_req->sg_rsp, buf_num)) {
+		kmem_cache_free(zfcp_fc_req_cache, fc_req);
+		return NULL;
 	}
-	sg_init_one(&gpn_ft->sg_req, req, sizeof(*req));
 
-	if (zfcp_sg_setup_table(gpn_ft->sg_resp, buf_num)) {
-		zfcp_free_sg_env(gpn_ft, buf_num);
-		gpn_ft = NULL;
-	}
-out:
-	return gpn_ft;
-}
+	sg_init_one(&fc_req->sg_req, &fc_req->u.gpn_ft.req,
+		    sizeof(struct zfcp_fc_gpn_ft_req));
 
+	return fc_req;
+}
 
-static int zfcp_fc_send_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
+static int zfcp_fc_send_gpn_ft(struct zfcp_fc_req *fc_req,
 			       struct zfcp_adapter *adapter, int max_bytes)
 {
-	struct zfcp_fsf_ct_els *ct = &gpn_ft->ct;
-	struct zfcp_fc_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
+	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
+	struct zfcp_fc_gpn_ft_req *req = &fc_req->u.gpn_ft.req;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	int ret;
 
-	/* prepare CT IU for GPN_FT */
-	req->ct_hdr.ct_rev = FC_CT_REV;
-	req->ct_hdr.ct_fs_type = FC_FST_DIR;
-	req->ct_hdr.ct_fs_subtype = FC_NS_SUBTYPE;
-	req->ct_hdr.ct_options = 0;
-	req->ct_hdr.ct_cmd = FC_NS_GPN_FT;
-	req->ct_hdr.ct_mr_size = max_bytes / 4;
-	req->gpn_ft.fn_domain_id_scope = 0;
-	req->gpn_ft.fn_area_id_scope = 0;
+	zfcp_fc_ct_ns_init(&req->ct_hdr, FC_NS_GPN_FT, max_bytes);
 	req->gpn_ft.fn_fc4_type = FC_TYPE_FCP;
 
-	/* prepare zfcp_send_ct */
-	ct->handler = zfcp_fc_complete;
-	ct->handler_data = &completion;
-	ct->req = &gpn_ft->sg_req;
-	ct->resp = gpn_ft->sg_resp;
+	ct_els->handler = zfcp_fc_complete;
+	ct_els->handler_data = &completion;
+	ct_els->req = &fc_req->sg_req;
+	ct_els->resp = &fc_req->sg_rsp;
 
-	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL,
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct_els, NULL,
 			       ZFCP_FC_CTELS_TMO);
 	if (!ret)
 		wait_for_completion(&completion);
@@ -610,11 +584,11 @@ static void zfcp_fc_validate_port(struct
 	list_move_tail(&port->list, lh);
 }
 
-static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
+static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_req *fc_req,
 			       struct zfcp_adapter *adapter, int max_entries)
 {
-	struct zfcp_fsf_ct_els *ct = &gpn_ft->ct;
-	struct scatterlist *sg = gpn_ft->sg_resp;
+	struct zfcp_fsf_ct_els *ct_els = &fc_req->ct_els;
+	struct scatterlist *sg = &fc_req->sg_rsp;
 	struct fc_ct_hdr *hdr = sg_virt(sg);
 	struct fc_gpn_ft_resp *acc = sg_virt(sg);
 	struct zfcp_port *port, *tmp;
@@ -623,7 +597,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	u32 d_id;
 	int ret = 0, x, last = 0;
 
-	if (ct->status)
+	if (ct_els->status)
 		return -EIO;
 
 	if (hdr->ct_cmd != FC_FS_ACC) {
@@ -687,7 +661,7 @@ void zfcp_fc_scan_ports(struct work_stru
 	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
 						    scan_work);
 	int ret, i;
-	struct zfcp_fc_gpn_ft *gpn_ft;
+	struct zfcp_fc_req *fc_req;
 	int chain, max_entries, buf_num, max_bytes;
 
 	chain = adapter->adapter_features & FSF_FEATURE_ELS_CT_CHAINED_SBALS;
@@ -702,21 +676,22 @@ void zfcp_fc_scan_ports(struct work_stru
 	if (zfcp_fc_wka_port_get(&adapter->gs->ds))
 		return;
 
-	gpn_ft = zfcp_alloc_sg_env(buf_num);
-	if (!gpn_ft)
+	fc_req = zfcp_alloc_sg_env(buf_num);
+	if (!fc_req)
 		goto out;
 
 	for (i = 0; i < 3; i++) {
-		ret = zfcp_fc_send_gpn_ft(gpn_ft, adapter, max_bytes);
+		ret = zfcp_fc_send_gpn_ft(fc_req, adapter, max_bytes);
 		if (!ret) {
-			ret = zfcp_fc_eval_gpn_ft(gpn_ft, adapter, max_entries);
+			ret = zfcp_fc_eval_gpn_ft(fc_req, adapter, max_entries);
 			if (ret == -EAGAIN)
 				ssleep(1);
 			else
 				break;
 		}
 	}
-	zfcp_free_sg_env(gpn_ft, buf_num);
+	zfcp_sg_free_table(&fc_req->sg_rsp, buf_num);
+	kmem_cache_free(zfcp_fc_req_cache, fc_req);
 out:
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
 }
--- a/drivers/s390/scsi/zfcp_fc.h
+++ b/drivers/s390/scsi/zfcp_fc.h
@@ -84,28 +84,6 @@ struct zfcp_fc_gpn_ft_req {
 } __packed;
 
 /**
- * struct zfcp_fc_gpn_ft_resp - container for ct header plus gpn_ft response
- * @ct_hdr: FC GS common transport header
- * @gpn_ft: Array of gpn_ft response data to fill one memory page
- */
-struct zfcp_fc_gpn_ft_resp {
-	struct fc_ct_hdr	ct_hdr;
-	struct fc_gpn_ft_resp	gpn_ft[ZFCP_FC_GPN_FT_ENT_PAGE];
-} __packed;
-
-/**
- * struct zfcp_fc_gpn_ft - zfcp data for gpn_ft request
- * @ct: data passed to zfcp_fsf for issuing fsf request
- * @sg_req: scatter list entry for gpn_ft request
- * @sg_resp: scatter list entries for gpn_ft responses (per memory page)
- */
-struct zfcp_fc_gpn_ft {
-	struct zfcp_fsf_ct_els ct;
-	struct scatterlist sg_req;
-	struct scatterlist sg_resp[ZFCP_FC_GPN_FT_NUM_BUFS];
-};
-
-/**
  * struct zfcp_fc_req - Container for FC ELS and CT requests sent from zfcp
  * @ct_els: data required for issuing fsf command
  * @sg_req: scatterlist entry for request data
@@ -125,6 +103,10 @@ struct zfcp_fc_req {
 			struct zfcp_fc_gid_pn_req	req;
 			struct zfcp_fc_gid_pn_rsp	rsp;
 		} gid_pn;
+		struct {
+			struct scatterlist sg_rsp2[ZFCP_FC_GPN_FT_NUM_BUFS - 1];
+			struct zfcp_fc_gpn_ft_req	req;
+		} gpn_ft;
 	} u;
 };
 

