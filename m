From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/11] zfcp: Add support for unchained FSF requests
Date: Fri, 19 Dec 2008 16:57:01 +0100
Message-ID: <20081219155756.915261000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61213 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbYLSP6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:58:04 -0500
Content-Disposition: inline; filename=z900-2008-12-18.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Petermann <martin@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Add the support to send CT and ELS requests as unchained FSF requests. This is
required for older hardware and was somehow omitted during the cleanup of the
FSF layer. The req_count and resp_count attributes are unused, so remove them
instead of adding a special case for setting them. Also add debug data and a
warning, when the ct request hits a limit.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Martin Petermann <martin@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c |    2 +
 drivers/s390/scsi/zfcp_dbf.h |    1 
 drivers/s390/scsi/zfcp_def.h |    9 -------
 drivers/s390/scsi/zfcp_fc.c  |   55 ++++++++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_fsf.c |   32 +++++++++++++++++++------
 drivers/s390/scsi/zfcp_fsf.h |    2 +
 6 files changed, 61 insertions(+), 40 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:39.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:42.000000000 +0100
@@ -37,9 +37,12 @@ struct gpn_ft_resp_acc {
 	u64 wwpn;
 } __attribute__ ((packed));
 
-#define ZFCP_GPN_FT_ENTRIES ((PAGE_SIZE - sizeof(struct ct_hdr)) \
-				/ sizeof(struct gpn_ft_resp_acc))
+#define ZFCP_CT_SIZE_ONE_PAGE	(PAGE_SIZE - sizeof(struct ct_hdr))
+#define ZFCP_GPN_FT_ENTRIES	(ZFCP_CT_SIZE_ONE_PAGE \
+					/ sizeof(struct gpn_ft_resp_acc))
 #define ZFCP_GPN_FT_BUFFERS 4
+#define ZFCP_GPN_FT_MAX_SIZE (ZFCP_GPN_FT_BUFFERS * PAGE_SIZE \
+				- sizeof(struct ct_hdr))
 #define ZFCP_GPN_FT_MAX_ENTRIES ZFCP_GPN_FT_BUFFERS * (ZFCP_GPN_FT_ENTRIES + 1)
 
 struct ct_iu_gpn_ft_resp {
@@ -279,8 +282,6 @@ int static zfcp_fc_ns_gid_pn_request(str
 	gid_pn->ct.timeout = ZFCP_NS_GID_PN_TIMEOUT;
 	gid_pn->ct.req = &gid_pn->req;
 	gid_pn->ct.resp = &gid_pn->resp;
-	gid_pn->ct.req_count = 1;
-	gid_pn->ct.resp_count = 1;
 	sg_init_one(&gid_pn->req, &gid_pn->ct_iu_req,
 		    sizeof(struct ct_iu_gid_pn_req));
 	sg_init_one(&gid_pn->resp, &gid_pn->ct_iu_resp,
@@ -292,7 +293,7 @@ int static zfcp_fc_ns_gid_pn_request(str
 	gid_pn->ct_iu_req.header.gs_subtype = ZFCP_CT_NAME_SERVER;
 	gid_pn->ct_iu_req.header.options = ZFCP_CT_SYNCHRONOUS;
 	gid_pn->ct_iu_req.header.cmd_rsp_code = ZFCP_CT_GID_PN;
-	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_MAX_SIZE;
+	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_SIZE_ONE_PAGE / 4;
 	gid_pn->ct_iu_req.wwpn = erp_action->port->wwpn;
 
 	init_completion(&compl_rec.done);
@@ -402,8 +403,6 @@ static int zfcp_fc_adisc(struct zfcp_por
 	sg_init_one(adisc->els.resp, &adisc->ls_adisc_acc,
 		    sizeof(struct zfcp_ls_adisc));
 
-	adisc->els.req_count = 1;
-	adisc->els.resp_count = 1;
 	adisc->els.adapter = adapter;
 	adisc->els.port = port;
 	adisc->els.d_id = port->d_id;
@@ -443,17 +442,17 @@ void zfcp_test_link(struct zfcp_port *po
 		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
 
-static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft)
+static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft, int buf_num)
 {
 	struct scatterlist *sg = &gpn_ft->sg_req;
 
 	kfree(sg_virt(sg)); /* free request buffer */
-	zfcp_sg_free_table(gpn_ft->sg_resp, ZFCP_GPN_FT_BUFFERS);
+	zfcp_sg_free_table(gpn_ft->sg_resp, buf_num);
 
 	kfree(gpn_ft);
 }
 
-static struct zfcp_gpn_ft *zfcp_alloc_sg_env(void)
+static struct zfcp_gpn_ft *zfcp_alloc_sg_env(int buf_num)
 {
 	struct zfcp_gpn_ft *gpn_ft;
 	struct ct_iu_gpn_ft_req *req;
@@ -470,8 +469,8 @@ static struct zfcp_gpn_ft *zfcp_alloc_sg
 	}
 	sg_init_one(&gpn_ft->sg_req, req, sizeof(*req));
 
-	if (zfcp_sg_setup_table(gpn_ft->sg_resp, ZFCP_GPN_FT_BUFFERS)) {
-		zfcp_free_sg_env(gpn_ft);
+	if (zfcp_sg_setup_table(gpn_ft->sg_resp, buf_num)) {
+		zfcp_free_sg_env(gpn_ft, buf_num);
 		gpn_ft = NULL;
 	}
 out:
@@ -480,7 +479,8 @@ out:
 
 
 static int zfcp_scan_issue_gpn_ft(struct zfcp_gpn_ft *gpn_ft,
-				  struct zfcp_adapter *adapter)
+				  struct zfcp_adapter *adapter,
+				  int max_bytes)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct ct_iu_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
@@ -493,8 +493,7 @@ static int zfcp_scan_issue_gpn_ft(struct
 	req->header.gs_subtype = ZFCP_CT_NAME_SERVER;
 	req->header.options = ZFCP_CT_SYNCHRONOUS;
 	req->header.cmd_rsp_code = ZFCP_CT_GPN_FT;
-	req->header.max_res_size = (sizeof(struct gpn_ft_resp_acc) *
-					(ZFCP_GPN_FT_MAX_ENTRIES - 1)) >> 2;
+	req->header.max_res_size = max_bytes / 4;
 	req->flags = 0;
 	req->domain_id_scope = 0;
 	req->area_id_scope = 0;
@@ -507,8 +506,6 @@ static int zfcp_scan_issue_gpn_ft(struct
 	ct->timeout = 10;
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
-	ct->req_count = 1;
-	ct->resp_count = ZFCP_GPN_FT_BUFFERS;
 
 	init_completion(&compl_rec.done);
 	compl_rec.handler = NULL;
@@ -535,7 +532,7 @@ static void zfcp_validate_port(struct zf
 	zfcp_port_dequeue(port);
 }
 
-static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft)
+static int zfcp_scan_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct scatterlist *sg = gpn_ft->sg_resp;
@@ -555,13 +552,17 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		return -EIO;
 	}
 
-	if (hdr->max_res_size)
+	if (hdr->max_res_size) {
+		dev_warn(&adapter->ccw_device->dev,
+			 "The name server reported %d words residual data\n",
+			 hdr->max_res_size);
 		return -E2BIG;
+	}
 
 	down(&zfcp_data.config_sema);
 
 	/* first entry is the header */
-	for (x = 1; x < ZFCP_GPN_FT_MAX_ENTRIES && !last; x++) {
+	for (x = 1; x < max_entries && !last; x++) {
 		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
 			acc++;
 		else
@@ -606,6 +607,12 @@ int zfcp_scan_ports(struct zfcp_adapter 
 {
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
+	int chain, max_entries, buf_num, max_bytes;
+
+	chain = adapter->adapter_features & FSF_FEATURE_ELS_CT_CHAINED_SBALS;
+	buf_num = chain ? ZFCP_GPN_FT_BUFFERS : 1;
+	max_entries = chain ? ZFCP_GPN_FT_MAX_ENTRIES : ZFCP_GPN_FT_ENTRIES;
+	max_bytes = chain ? ZFCP_GPN_FT_MAX_SIZE : ZFCP_CT_SIZE_ONE_PAGE;
 
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
@@ -614,23 +621,23 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	if (ret)
 		return ret;
 
-	gpn_ft = zfcp_alloc_sg_env();
+	gpn_ft = zfcp_alloc_sg_env(buf_num);
 	if (!gpn_ft) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
 	for (i = 0; i < 3; i++) {
-		ret = zfcp_scan_issue_gpn_ft(gpn_ft, adapter);
+		ret = zfcp_scan_issue_gpn_ft(gpn_ft, adapter, max_bytes);
 		if (!ret) {
-			ret = zfcp_scan_eval_gpn_ft(gpn_ft);
+			ret = zfcp_scan_eval_gpn_ft(gpn_ft, max_entries);
 			if (ret == -EAGAIN)
 				ssleep(1);
 			else
 				break;
 		}
 	}
-	zfcp_free_sg_env(gpn_ft);
+	zfcp_free_sg_env(gpn_ft, buf_num);
 out:
 	zfcp_wka_port_put(&adapter->nsp);
 	return ret;
--- a/drivers/s390/scsi/zfcp_fsf.h	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.h	2008-12-19 14:38:42.000000000 +0100
@@ -164,6 +164,7 @@
 #define FSF_FEATURE_LUN_SHARING			0x00000004
 #define FSF_FEATURE_NOTIFICATION_LOST		0x00000008
 #define FSF_FEATURE_HBAAPI_MANAGEMENT           0x00000010
+#define FSF_FEATURE_ELS_CT_CHAINED_SBALS	0x00000020
 #define FSF_FEATURE_UPDATE_ALERT		0x00000100
 #define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 
@@ -322,6 +323,7 @@ struct fsf_nport_serv_param {
 	u8  vendor_version_level[16];
 } __attribute__ ((packed));
 
+#define FSF_PLOGI_MIN_LEN	112
 struct fsf_plogi {
 	u32    code;
 	struct fsf_nport_serv_param serv_param;
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:39.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:42.000000000 +0100
@@ -1010,12 +1010,29 @@ skip_fsfstatus:
 		send_ct->handler(send_ct->handler_data);
 }
 
-static int zfcp_fsf_setup_sbals(struct zfcp_fsf_req *req,
-				struct scatterlist *sg_req,
-				struct scatterlist *sg_resp, int max_sbals)
+static int zfcp_fsf_setup_ct_els_sbals(struct zfcp_fsf_req *req,
+				       struct scatterlist *sg_req,
+				       struct scatterlist *sg_resp,
+				       int max_sbals)
 {
+	struct qdio_buffer_element *sbale = zfcp_qdio_sbale_req(req);
+	u32 feat = req->adapter->adapter_features;
 	int bytes;
 
+	if (!(feat & FSF_FEATURE_ELS_CT_CHAINED_SBALS)) {
+		if (sg_req->length > PAGE_SIZE || sg_resp->length > PAGE_SIZE ||
+		    !sg_is_last(sg_req) || !sg_is_last(sg_resp))
+			return -EOPNOTSUPP;
+
+		sbale[0].flags |= SBAL_FLAGS0_TYPE_WRITE_READ;
+		sbale[2].addr   = sg_virt(sg_req);
+		sbale[2].length = sg_req->length;
+		sbale[3].addr   = sg_virt(sg_resp);
+		sbale[3].length = sg_resp->length;
+		sbale[3].flags |= SBAL_FLAGS_LAST_ENTRY;
+		return 0;
+	}
+
 	bytes = zfcp_qdio_sbals_from_sg(req, SBAL_FLAGS0_TYPE_WRITE_READ,
 					sg_req, max_sbals);
 	if (bytes <= 0)
@@ -1057,8 +1074,8 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 		goto out;
 	}
 
-	ret = zfcp_fsf_setup_sbals(req, ct->req, ct->resp,
-				   FSF_MAX_SBALS_PER_REQ);
+	ret = zfcp_fsf_setup_ct_els_sbals(req, ct->req, ct->resp,
+					  FSF_MAX_SBALS_PER_REQ);
 	if (ret)
 		goto failed_send;
 
@@ -1168,7 +1185,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 		goto out;
 	}
 
-	ret = zfcp_fsf_setup_sbals(req, els->req, els->resp, 2);
+	ret = zfcp_fsf_setup_ct_els_sbals(req, els->req, els->resp, 2);
 
 	if (ret)
 		goto failed_send;
@@ -1437,7 +1454,8 @@ static void zfcp_fsf_open_port_handler(s
 		 * Alternately, an ADISC/PDISC ELS should suffice, as well.
 		 */
 		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
-		if (req->qtcb->bottom.support.els1_length >= sizeof(*plogi)) {
+		if (req->qtcb->bottom.support.els1_length >=
+		    FSF_PLOGI_MIN_LEN) {
 			if (plogi->serv_param.wwpn != port->wwpn)
 				port->d_id = 0;
 			else {
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:38:40.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-12-19 14:38:42.000000000 +0100
@@ -933,6 +933,7 @@ void zfcp_san_dbf_event_ct_response(stru
 	rct->reason_code = hdr->reason_code;
 	rct->expl = hdr->reason_code_expl;
 	rct->vendor_unique = hdr->vendor_unique;
+	rct->max_res_size = hdr->max_res_size;
 	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
 	debug_event(adapter->san_dbf, level, r, sizeof(*r));
@@ -1040,6 +1041,7 @@ static int zfcp_san_dbf_view_format(debu
 		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
 		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
 		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
+		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
 	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
--- a/drivers/s390/scsi/zfcp_dbf.h	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.h	2008-12-19 14:38:42.000000000 +0100
@@ -171,6 +171,7 @@ struct zfcp_san_dbf_record_ct_response {
 	u8 reason_code;
 	u8 expl;
 	u8 vendor_unique;
+	u16 max_res_size;
 	u32 len;
 } __attribute__ ((packed));
 
--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:40.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:43.000000000 +0100
@@ -196,7 +196,6 @@ struct zfcp_ls_adisc {
 #define ZFCP_CT_UNABLE_TO_PERFORM_CMD	0x09
 #define ZFCP_CT_GID_PN			0x0121
 #define ZFCP_CT_GPN_FT			0x0172
-#define ZFCP_CT_MAX_SIZE		0x1020
 #define ZFCP_CT_ACCEPT			0x8002
 #define ZFCP_CT_REJECT			0x8001
 
@@ -324,8 +323,6 @@ struct ct_iu_gid_pn_resp {
  * @wka_port: port where the request is sent to
  * @req: scatter-gather list for request
  * @resp: scatter-gather list for response
- * @req_count: number of elements in request scatter-gather list
- * @resp_count: number of elements in response scatter-gather list
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
  * @timeout: FSF timeout for this request
@@ -336,8 +333,6 @@ struct zfcp_send_ct {
 	struct zfcp_wka_port *wka_port;
 	struct scatterlist *req;
 	struct scatterlist *resp;
-	unsigned int req_count;
-	unsigned int resp_count;
 	void (*handler)(unsigned long);
 	unsigned long handler_data;
 	int timeout;
@@ -362,8 +357,6 @@ struct zfcp_gid_pn_data {
  * @d_id: destiniation id of port where request is sent to
  * @req: scatter-gather list for request
  * @resp: scatter-gather list for response
- * @req_count: number of elements in request scatter-gather list
- * @resp_count: number of elements in response scatter-gather list
  * @handler: handler function (called for response to the request)
  * @handler_data: data passed to handler function
  * @completion: completion for synchronization purposes
@@ -376,8 +369,6 @@ struct zfcp_send_els {
 	u32 d_id;
 	struct scatterlist *req;
 	struct scatterlist *resp;
-	unsigned int req_count;
-	unsigned int resp_count;
 	void (*handler)(unsigned long);
 	unsigned long handler_data;
 	struct completion *completion;

-- 
