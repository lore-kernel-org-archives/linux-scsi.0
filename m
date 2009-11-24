From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 14/22] zfcp: Use common code definitions for FC CT structs
Date: Tue, 24 Nov 2009 16:54:10 +0100
Message-ID: <20091124160138.040588000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:53866 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234AbZKXQBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:33 -0500
Content-Disposition: inline; filename=713-zfcp-ct-defs.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use common code definitions for FC GPN_FT and GID_PN
instead of inventing private ones. Move the private structs still
required inside zfcp to zfcp_fc header file.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   13 ++--
 drivers/s390/scsi/zfcp_dbf.c |   36 +++++------
 drivers/s390/scsi/zfcp_def.h |   74 -----------------------
 drivers/s390/scsi/zfcp_fc.c  |  138 +++++++++++++++++--------------------------
 drivers/s390/scsi/zfcp_fc.h  |   80 ++++++++++++++++++++++++
 5 files changed, 161 insertions(+), 180 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-11-24 16:35:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-11-24 16:35:32.000000000 +0100
@@ -31,6 +31,7 @@
 #include <linux/miscdevice.h>
 #include <linux/seq_file.h>
 #include "zfcp_ext.h"
+#include "zfcp_fc.h"
 
 #define ZFCP_BUS_ID_SIZE	20
 
@@ -159,7 +160,7 @@ static int __init zfcp_module_init(void)
 	int retval = -ENOMEM;
 
 	zfcp_data.gpn_ft_cache = zfcp_cache_hw_align("zfcp_gpn",
-					sizeof(struct ct_iu_gpn_ft_req));
+					sizeof(struct zfcp_fc_gpn_ft_req));
 	if (!zfcp_data.gpn_ft_cache)
 		goto out;
 
@@ -174,7 +175,7 @@ static int __init zfcp_module_init(void)
 		goto out_sr_cache;
 
 	zfcp_data.gid_pn_cache = zfcp_cache_hw_align("zfcp_gid",
-					sizeof(struct zfcp_gid_pn_data));
+					sizeof(struct zfcp_fc_gid_pn));
 	if (!zfcp_data.gid_pn_cache)
 		goto out_gid_cache;
 
@@ -407,9 +408,9 @@ static int zfcp_allocate_low_mem_buffers
 	if (!adapter->pool.status_read_data)
 		return -ENOMEM;
 
-	adapter->pool.gid_pn_data =
+	adapter->pool.gid_pn =
 		mempool_create_slab_pool(1, zfcp_data.gid_pn_cache);
-	if (!adapter->pool.gid_pn_data)
+	if (!adapter->pool.gid_pn)
 		return -ENOMEM;
 
 	return 0;
@@ -429,8 +430,8 @@ static void zfcp_free_low_mem_buffers(st
 		mempool_destroy(adapter->pool.status_read_req);
 	if (adapter->pool.status_read_data)
 		mempool_destroy(adapter->pool.status_read_data);
-	if (adapter->pool.gid_pn_data)
-		mempool_destroy(adapter->pool.gid_pn_data);
+	if (adapter->pool.gid_pn)
+		mempool_destroy(adapter->pool.gid_pn);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:32.000000000 +0100
@@ -684,7 +684,7 @@ void zfcp_dbf_san_ct_request(struct zfcp
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
-	struct ct_hdr *hdr = sg_virt(ct->req);
+	struct fc_ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_dbf_san_record *r = &dbf->san_buf;
 	struct zfcp_dbf_san_record_ct_request *oct = &r->u.ct_req;
 	int level = 3;
@@ -697,17 +697,17 @@ void zfcp_dbf_san_ct_request(struct zfcp
 	r->fsf_seqno = fsf_req->seq_no;
 	r->s_id = fc_host_port_id(adapter->scsi_host);
 	r->d_id = wka_port->d_id;
-	oct->cmd_req_code = hdr->cmd_rsp_code;
-	oct->revision = hdr->revision;
-	oct->gs_type = hdr->gs_type;
-	oct->gs_subtype = hdr->gs_subtype;
-	oct->options = hdr->options;
-	oct->max_res_size = hdr->max_res_size;
-	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
+	oct->cmd_req_code = hdr->ct_cmd;
+	oct->revision = hdr->ct_rev;
+	oct->gs_type = hdr->ct_fs_type;
+	oct->gs_subtype = hdr->ct_fs_subtype;
+	oct->options = hdr->ct_options;
+	oct->max_res_size = hdr->ct_mr_size;
+	oct->len = min((int)ct->req->length - (int)sizeof(struct fc_ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
 	debug_event(dbf->san, level, r, sizeof(*r));
 	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
-			 (void *)hdr + sizeof(struct ct_hdr), oct->len);
+			 (void *)hdr + sizeof(struct fc_ct_hdr), oct->len);
 	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
@@ -720,7 +720,7 @@ void zfcp_dbf_san_ct_response(struct zfc
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
-	struct ct_hdr *hdr = sg_virt(ct->resp);
+	struct fc_ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_san_record *r = &dbf->san_buf;
 	struct zfcp_dbf_san_record_ct_response *rct = &r->u.ct_resp;
@@ -734,17 +734,17 @@ void zfcp_dbf_san_ct_response(struct zfc
 	r->fsf_seqno = fsf_req->seq_no;
 	r->s_id = wka_port->d_id;
 	r->d_id = fc_host_port_id(adapter->scsi_host);
-	rct->cmd_rsp_code = hdr->cmd_rsp_code;
-	rct->revision = hdr->revision;
-	rct->reason_code = hdr->reason_code;
-	rct->expl = hdr->reason_code_expl;
-	rct->vendor_unique = hdr->vendor_unique;
-	rct->max_res_size = hdr->max_res_size;
-	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
+	rct->cmd_rsp_code = hdr->ct_cmd;
+	rct->revision = hdr->ct_rev;
+	rct->reason_code = hdr->ct_reason;
+	rct->expl = hdr->ct_explan;
+	rct->vendor_unique = hdr->ct_vendor;
+	rct->max_res_size = hdr->ct_mr_size;
+	rct->len = min((int)ct->resp->length - (int)sizeof(struct fc_ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
 	debug_event(dbf->san, level, r, sizeof(*r));
 	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
-			 (void *)hdr + sizeof(struct ct_hdr), rct->len);
+			 (void *)hdr + sizeof(struct fc_ct_hdr), rct->len);
 	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:32.000000000 +0100
@@ -75,25 +75,6 @@
 
 #define ZFCP_DID_MASK           0x00FFFFFF
 
-/*
- * FC-GS-2 stuff
- */
-#define ZFCP_CT_REVISION		0x01
-#define ZFCP_CT_DIRECTORY_SERVICE	0xFC
-#define ZFCP_CT_NAME_SERVER		0x02
-#define ZFCP_CT_SYNCHRONOUS		0x00
-#define ZFCP_CT_SCSI_FCP		0x08
-#define ZFCP_CT_UNABLE_TO_PERFORM_CMD	0x09
-#define ZFCP_CT_GID_PN			0x0121
-#define ZFCP_CT_GPN_FT			0x0172
-#define ZFCP_CT_ACCEPT			0x8002
-#define ZFCP_CT_REJECT			0x8001
-
-/*
- * FC-GS-4 stuff
- */
-#define ZFCP_CT_TIMEOUT			(3 * R_A_TOV)
-
 /*************** ADAPTER/PORT/UNIT AND FSF_REQ STATUS FLAGS ******************/
 
 /*
@@ -119,9 +100,6 @@
 #define ZFCP_STATUS_ADAPTER_ERP_PENDING		0x00000100
 #define ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED	0x00000200
 
-/* FC-PH/FC-GS well-known address identifiers for generic services */
-#define ZFCP_DID_WKA				0xFFFFF0
-
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
 #define ZFCP_STATUS_PORT_LINK_TEST		0x00000002
@@ -162,50 +140,10 @@ struct zfcp_adapter_mempool {
 	mempool_t *scsi_abort;
 	mempool_t *status_read_req;
 	mempool_t *status_read_data;
-	mempool_t *gid_pn_data;
+	mempool_t *gid_pn;
 	mempool_t *qtcb_pool;
 };
 
-/*
- * header for CT_IU
- */
-struct ct_hdr {
-	u8 revision;		// 0x01
-	u8 in_id[3];		// 0x00
-	u8 gs_type;		// 0xFC	Directory Service
-	u8 gs_subtype;		// 0x02	Name Server
-	u8 options;		// 0x00 single bidirectional exchange
-	u8 reserved0;
-	u16 cmd_rsp_code;	// 0x0121 GID_PN, or 0x0100 GA_NXT
-	u16 max_res_size;	// <= (4096 - 16) / 4
-	u8 reserved1;
-	u8 reason_code;
-	u8 reason_code_expl;
-	u8 vendor_unique;
-} __attribute__ ((packed));
-
-/* nameserver request CT_IU -- for requests where
- * a port name is required */
-struct ct_iu_gid_pn_req {
-	struct ct_hdr header;
-	u64 wwpn;
-} __attribute__ ((packed));
-
-/* FS_ACC IU and data unit for GID_PN nameserver request */
-struct ct_iu_gid_pn_resp {
-	struct ct_hdr header;
-	u32 d_id;
-} __attribute__ ((packed));
-
-struct ct_iu_gpn_ft_req {
-	struct ct_hdr header;
-	u8 flags;
-	u8 domain_id_scope;
-	u8 area_id_scope;
-	u8 fc4_type;
-} __attribute__ ((packed));
-
-
 /**
  * struct zfcp_send_ct - used to pass parameters to function zfcp_fsf_send_ct
  * @wka_port: port where the request is sent to
@@ -226,16 +164,6 @@ struct zfcp_send_ct {
 	int status;
 };
 
-/* used for name server requests in error recovery */
-struct zfcp_gid_pn_data {
-	struct zfcp_send_ct ct;
-	struct scatterlist req;
-	struct scatterlist resp;
-	struct ct_iu_gid_pn_req ct_iu_req;
-	struct ct_iu_gid_pn_resp ct_iu_resp;
-        struct zfcp_port *port;
-};
-
 /**
  * struct zfcp_send_els - used to pass parameters to function zfcp_fsf_send_els
  * @adapter: adapter where request is sent from
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:32.000000000 +0100
@@ -22,32 +22,6 @@ static u32 zfcp_fc_rscn_range_mask[] = {
 	[ELS_ADDR_FMT_FAB]		= 0x000000,
 };
 
-struct gpn_ft_resp_acc {
-	u8 control;
-	u8 port_id[3];
-	u8 reserved[4];
-	u64 wwpn;
-} __attribute__ ((packed));
-
-#define ZFCP_CT_SIZE_ONE_PAGE	(PAGE_SIZE - sizeof(struct ct_hdr))
-#define ZFCP_GPN_FT_ENTRIES	(ZFCP_CT_SIZE_ONE_PAGE \
-					/ sizeof(struct gpn_ft_resp_acc))
-#define ZFCP_GPN_FT_BUFFERS 4
-#define ZFCP_GPN_FT_MAX_SIZE (ZFCP_GPN_FT_BUFFERS * PAGE_SIZE \
-				- sizeof(struct ct_hdr))
-#define ZFCP_GPN_FT_MAX_ENTRIES ZFCP_GPN_FT_BUFFERS * (ZFCP_GPN_FT_ENTRIES + 1)
-
-struct ct_iu_gpn_ft_resp {
-	struct ct_hdr header;
-	struct gpn_ft_resp_acc accept[ZFCP_GPN_FT_ENTRIES];
-} __attribute__ ((packed));
-
-struct zfcp_gpn_ft {
-	struct zfcp_send_ct ct;
-	struct scatterlist sg_req;
-	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
-};
-
 struct zfcp_fc_ns_handler_data {
 	struct completion done;
 	void (*handler)(unsigned long);
@@ -251,26 +225,26 @@ static void zfcp_fc_ns_handler(unsigned 
 
 static void zfcp_fc_ns_gid_pn_eval(unsigned long data)
 {
-	struct zfcp_gid_pn_data *gid_pn = (struct zfcp_gid_pn_data *) data;
+	struct zfcp_fc_gid_pn *gid_pn = (struct zfcp_fc_gid_pn *) data;
 	struct zfcp_send_ct *ct = &gid_pn->ct;
-	struct ct_iu_gid_pn_req *ct_iu_req = sg_virt(ct->req);
-	struct ct_iu_gid_pn_resp *ct_iu_resp = sg_virt(ct->resp);
+	struct zfcp_fc_gid_pn_req *gid_pn_req = sg_virt(ct->req);
+	struct zfcp_fc_gid_pn_resp *gid_pn_resp = sg_virt(ct->resp);
 	struct zfcp_port *port = gid_pn->port;
 
 	if (ct->status)
 		return;
-	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT)
+	if (gid_pn_resp->ct_hdr.ct_cmd != FC_FS_ACC)
 		return;
 
 	/* paranoia */
-	if (ct_iu_req->wwpn != port->wwpn)
+	if (gid_pn_req->gid_pn.fn_wwpn != port->wwpn)
 		return;
 	/* looks like a valid d_id */
-	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
+	port->d_id = ntoh24(gid_pn_resp->gid_pn.fp_fid);
 }
 
 static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
-				     struct zfcp_gid_pn_data *gid_pn)
+				     struct zfcp_fc_gid_pn *gid_pn)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_fc_ns_handler_data compl_rec;
@@ -281,21 +255,21 @@ static int zfcp_fc_ns_gid_pn_request(str
 	gid_pn->ct.wka_port = &adapter->gs->ds;
 	gid_pn->ct.handler = zfcp_fc_ns_handler;
 	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
-	gid_pn->ct.req = &gid_pn->req;
-	gid_pn->ct.resp = &gid_pn->resp;
-	sg_init_one(&gid_pn->req, &gid_pn->ct_iu_req,
-		    sizeof(struct ct_iu_gid_pn_req));
-	sg_init_one(&gid_pn->resp, &gid_pn->ct_iu_resp,
-		    sizeof(struct ct_iu_gid_pn_resp));
+	gid_pn->ct.req = &gid_pn->sg_req;
+	gid_pn->ct.resp = &gid_pn->sg_resp;
+	sg_init_one(&gid_pn->sg_req, &gid_pn->gid_pn_req,
+		    sizeof(struct zfcp_fc_gid_pn_req));
+	sg_init_one(&gid_pn->sg_resp, &gid_pn->gid_pn_resp,
+		    sizeof(struct zfcp_fc_gid_pn_resp));
 
 	/* setup nameserver request */
-	gid_pn->ct_iu_req.header.revision = ZFCP_CT_REVISION;
-	gid_pn->ct_iu_req.header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
-	gid_pn->ct_iu_req.header.gs_subtype = ZFCP_CT_NAME_SERVER;
-	gid_pn->ct_iu_req.header.options = ZFCP_CT_SYNCHRONOUS;
-	gid_pn->ct_iu_req.header.cmd_rsp_code = ZFCP_CT_GID_PN;
-	gid_pn->ct_iu_req.header.max_res_size = ZFCP_CT_SIZE_ONE_PAGE / 4;
-	gid_pn->ct_iu_req.wwpn = port->wwpn;
+	gid_pn->gid_pn_req.ct_hdr.ct_rev = FC_CT_REV;
+	gid_pn->gid_pn_req.ct_hdr.ct_fs_type = FC_FST_DIR;
+	gid_pn->gid_pn_req.ct_hdr.ct_fs_subtype = FC_NS_SUBTYPE;
+	gid_pn->gid_pn_req.ct_hdr.ct_options = 0;
+	gid_pn->gid_pn_req.ct_hdr.ct_cmd = FC_NS_GID_PN;
+	gid_pn->gid_pn_req.ct_hdr.ct_mr_size = ZFCP_FC_CT_SIZE_PAGE / 4;
+	gid_pn->gid_pn_req.gid_pn.fn_wwpn = port->wwpn;
 
 	init_completion(&compl_rec.done);
 	compl_rec.handler = zfcp_fc_ns_gid_pn_eval;
@@ -314,10 +288,10 @@ static int zfcp_fc_ns_gid_pn_request(str
 static int zfcp_fc_ns_gid_pn(struct zfcp_port *port)
 {
 	int ret;
-	struct zfcp_gid_pn_data *gid_pn;
+	struct zfcp_fc_gid_pn *gid_pn;
 	struct zfcp_adapter *adapter = port->adapter;
 
-	gid_pn = mempool_alloc(adapter->pool.gid_pn_data, GFP_ATOMIC);
+	gid_pn = mempool_alloc(adapter->pool.gid_pn, GFP_ATOMIC);
 	if (!gid_pn)
 		return -ENOMEM;
 
@@ -331,7 +305,7 @@ static int zfcp_fc_ns_gid_pn(struct zfcp
 
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
 out:
-	mempool_free(gid_pn, adapter->pool.gid_pn_data);
+	mempool_free(gid_pn, adapter->pool.gid_pn);
 	return ret;
 }
 
@@ -508,7 +482,7 @@ void zfcp_fc_test_link(struct zfcp_port 
 		put_device(&port->sysfs_device);
 }
 
-static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft, int buf_num)
+static void zfcp_free_sg_env(struct zfcp_fc_gpn_ft *gpn_ft, int buf_num)
 {
 	struct scatterlist *sg = &gpn_ft->sg_req;
 
@@ -518,10 +492,10 @@ static void zfcp_free_sg_env(struct zfcp
 	kfree(gpn_ft);
 }
 
-static struct zfcp_gpn_ft *zfcp_alloc_sg_env(int buf_num)
+static struct zfcp_fc_gpn_ft *zfcp_alloc_sg_env(int buf_num)
 {
-	struct zfcp_gpn_ft *gpn_ft;
-	struct ct_iu_gpn_ft_req *req;
+	struct zfcp_fc_gpn_ft *gpn_ft;
+	struct zfcp_fc_gpn_ft_req *req;
 
 	gpn_ft = kzalloc(sizeof(*gpn_ft), GFP_KERNEL);
 	if (!gpn_ft)
@@ -544,25 +518,24 @@ out:
 }
 
 
-static int zfcp_fc_send_gpn_ft(struct zfcp_gpn_ft *gpn_ft,
+static int zfcp_fc_send_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
 			       struct zfcp_adapter *adapter, int max_bytes)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
-	struct ct_iu_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
+	struct zfcp_fc_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
 	struct zfcp_fc_ns_handler_data compl_rec;
 	int ret;
 
 	/* prepare CT IU for GPN_FT */
-	req->header.revision = ZFCP_CT_REVISION;
-	req->header.gs_type = ZFCP_CT_DIRECTORY_SERVICE;
-	req->header.gs_subtype = ZFCP_CT_NAME_SERVER;
-	req->header.options = ZFCP_CT_SYNCHRONOUS;
-	req->header.cmd_rsp_code = ZFCP_CT_GPN_FT;
-	req->header.max_res_size = max_bytes / 4;
-	req->flags = 0;
-	req->domain_id_scope = 0;
-	req->area_id_scope = 0;
-	req->fc4_type = ZFCP_CT_SCSI_FCP;
+	req->ct_hdr.ct_rev = FC_CT_REV;
+	req->ct_hdr.ct_fs_type = FC_FST_DIR;
+	req->ct_hdr.ct_fs_subtype = FC_NS_SUBTYPE;
+	req->ct_hdr.ct_options = 0;
+	req->ct_hdr.ct_cmd = FC_NS_GPN_FT;
+	req->ct_hdr.ct_mr_size = max_bytes / 4;
+	req->gpn_ft.fn_domain_id_scope = 0;
+	req->gpn_ft.fn_area_id_scope = 0;
+	req->gpn_ft.fn_fc4_type = FC_TYPE_FCP;
 
 	/* prepare zfcp_send_ct */
 	ct->wka_port = &adapter->gs->ds;
@@ -593,12 +566,12 @@ static void zfcp_fc_validate_port(struct
 	list_move_tail(&port->list, lh);
 }
 
-static int zfcp_fc_eval_gpn_ft(struct zfcp_gpn_ft *gpn_ft, int max_entries)
+static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft, int max_entries)
 {
 	struct zfcp_send_ct *ct = &gpn_ft->ct;
 	struct scatterlist *sg = gpn_ft->sg_resp;
-	struct ct_hdr *hdr = sg_virt(sg);
-	struct gpn_ft_resp_acc *acc = sg_virt(sg);
+	struct fc_ct_hdr *hdr = sg_virt(sg);
+	struct fc_gpn_ft_resp *acc = sg_virt(sg);
 	struct zfcp_adapter *adapter = ct->wka_port->adapter;
 	struct zfcp_port *port, *tmp;
 	unsigned long flags;
@@ -609,38 +582,37 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	if (ct->status)
 		return -EIO;
 
-	if (hdr->cmd_rsp_code != ZFCP_CT_ACCEPT) {
-		if (hdr->reason_code == ZFCP_CT_UNABLE_TO_PERFORM_CMD)
+	if (hdr->ct_cmd != FC_FS_ACC) {
+		if (hdr->ct_reason == FC_BA_RJT_UNABLE)
 			return -EAGAIN; /* might be a temporary condition */
 		return -EIO;
 	}
 
-	if (hdr->max_res_size) {
+	if (hdr->ct_mr_size) {
 		dev_warn(&adapter->ccw_device->dev,
 			 "The name server reported %d words residual data\n",
-			 hdr->max_res_size);
+			 hdr->ct_mr_size);
 		return -E2BIG;
 	}
 
 	/* first entry is the header */
 	for (x = 1; x < max_entries && !last; x++) {
-		if (x % (ZFCP_GPN_FT_ENTRIES + 1))
+		if (x % (ZFCP_FC_GPN_FT_ENT_PAGE + 1))
 			acc++;
 		else
 			acc = sg_virt(++sg);
 
-		last = acc->control & 0x80;
-		d_id = acc->port_id[0] << 16 | acc->port_id[1] << 8 |
-		       acc->port_id[2];
+		last = acc->fp_flags & FC_NS_FID_LAST;
+		d_id = ntoh24(acc->fp_fid);
 
 		/* don't attach ports with a well known address */
-		if ((d_id & ZFCP_DID_WKA) == ZFCP_DID_WKA)
+		if (d_id >= FC_FID_WELL_KNOWN_BASE)
 			continue;
 		/* skip the adapter's port and known remote ports */
-		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
+		if (acc->fp_wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
 
-		port = zfcp_port_enqueue(adapter, acc->wwpn,
+		port = zfcp_port_enqueue(adapter, acc->fp_wwpn,
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
 		if (!IS_ERR(port))
 			zfcp_erp_port_reopen(port, 0, "fcegpf1", NULL);
@@ -672,13 +644,13 @@ void zfcp_fc_scan_ports(struct work_stru
 	struct zfcp_adapter *adapter = container_of(work, struct zfcp_adapter,
 						    scan_work);
 	int ret, i;
-	struct zfcp_gpn_ft *gpn_ft;
+	struct zfcp_fc_gpn_ft *gpn_ft;
 	int chain, max_entries, buf_num, max_bytes;
 
 	chain = adapter->adapter_features & FSF_FEATURE_ELS_CT_CHAINED_SBALS;
-	buf_num = chain ? ZFCP_GPN_FT_BUFFERS : 1;
-	max_entries = chain ? ZFCP_GPN_FT_MAX_ENTRIES : ZFCP_GPN_FT_ENTRIES;
-	max_bytes = chain ? ZFCP_GPN_FT_MAX_SIZE : ZFCP_CT_SIZE_ONE_PAGE;
+	buf_num = chain ? ZFCP_FC_GPN_FT_NUM_BUFS : 1;
+	max_entries = chain ? ZFCP_FC_GPN_FT_MAX_ENT : ZFCP_FC_GPN_FT_ENT_PAGE;
+	max_bytes = chain ? ZFCP_FC_GPN_FT_MAX_SIZE : ZFCP_FC_CT_SIZE_PAGE;
 
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT &&
 	    fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPIV)
--- a/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:32.000000000 +0100
@@ -12,9 +12,89 @@
 
 #include <scsi/fc/fc_els.h>
 #include <scsi/fc/fc_fcp.h>
+#include <scsi/fc/fc_ns.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 
+#define ZFCP_FC_CT_SIZE_PAGE	  (PAGE_SIZE - sizeof(struct fc_ct_hdr))
+#define ZFCP_FC_GPN_FT_ENT_PAGE	  (ZFCP_FC_CT_SIZE_PAGE \
+					/ sizeof(struct fc_gpn_ft_resp))
+#define ZFCP_FC_GPN_FT_NUM_BUFS	  4 /* memory pages */
+
+#define ZFCP_FC_GPN_FT_MAX_SIZE	  (ZFCP_FC_GPN_FT_NUM_BUFS * PAGE_SIZE \
+					- sizeof(struct fc_ct_hdr))
+#define ZFCP_FC_GPN_FT_MAX_ENT	  (ZFCP_FC_GPN_FT_NUM_BUFS * \
+					(ZFCP_FC_GPN_FT_ENT_PAGE + 1))
+
+/**
+ * struct zfcp_fc_gid_pn_req - container for ct header plus gid_pn request
+ * @ct_hdr: FC GS common transport header
+ * @gid_pn: GID_PN request
+ */
+struct zfcp_fc_gid_pn_req {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_ns_gid_pn	gid_pn;
+} __packed;
+
+/**
+ * struct zfcp_fc_gid_pn_resp - container for ct header plus gid_pn response
+ * @ct_hdr: FC GS common transport header
+ * @gid_pn: GID_PN response
+ */
+struct zfcp_fc_gid_pn_resp {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_gid_pn_resp	gid_pn;
+} __packed;
+
+/**
+ * struct zfcp_fc_gid_pn - everything required in zfcp for gid_pn request
+ * @ct: data passed to zfcp_fsf for issuing fsf request
+ * @sg_req: scatterlist entry for request data
+ * @sg_resp: scatterlist entry for response data
+ * @gid_pn_req: GID_PN request data
+ * @gid_pn_resp: GID_PN response data
+ */
+struct zfcp_fc_gid_pn {
+	struct zfcp_send_ct ct;
+	struct scatterlist sg_req;
+	struct scatterlist sg_resp;
+	struct zfcp_fc_gid_pn_req gid_pn_req;
+	struct zfcp_fc_gid_pn_resp gid_pn_resp;
+	struct zfcp_port *port;
+};
+
+/**
+ * struct zfcp_fc_gpn_ft - container for ct header plus gpn_ft request
+ * @ct_hdr: FC GS common transport header
+ * @gpn_ft: GPN_FT request
+ */
+struct zfcp_fc_gpn_ft_req {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_ns_gid_ft	gpn_ft;
+} __packed;
+
+/**
+ * struct zfcp_fc_gpn_ft_resp - container for ct header plus gpn_ft response
+ * @ct_hdr: FC GS common transport header
+ * @gpn_ft: Array of gpn_ft response data to fill one memory page
+ */
+struct zfcp_fc_gpn_ft_resp {
+	struct fc_ct_hdr	ct_hdr;
+	struct fc_gpn_ft_resp	gpn_ft[ZFCP_FC_GPN_FT_ENT_PAGE];
+} __packed;
+
+/**
+ * struct zfcp_fc_gpn_ft - zfcp data for gpn_ft request
+ * @ct: data passed to zfcp_fsf for issuing fsf request
+ * @sg_req: scatter list entry for gpn_ft request
+ * @sg_resp: scatter list entries for gpn_ft responses (per memory page)
+ */
+struct zfcp_fc_gpn_ft {
+	struct zfcp_send_ct ct;
+	struct scatterlist sg_req;
+	struct scatterlist sg_resp[ZFCP_FC_GPN_FT_NUM_BUFS];
+};
+
 /**
  * struct zfcp_fc_els_adisc - everything required in zfcp for issuing ELS ADISC
  * @els: data required for issuing els fsf command

