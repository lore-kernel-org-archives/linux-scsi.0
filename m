From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 17/22] zfcp: Simplify handling of ct and els requests
Date: Tue, 24 Nov 2009 16:54:13 +0100
Message-ID: <20091124160138.489405000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44309 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933236AbZKXQBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:34 -0500
Content-Disposition: inline; filename=716-zfcp-request-handling.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Remove some redundancies in FC related code and trace:
- drop redundant data from SAN trace (local s_id that only changes
  during link down, ls_code that is already part of payload, d_id in
  ct response trace that is always the same as in ct request trace)
- use one common fsf struct to hold zfcp data for ct and els requests
- leverage common fsf struct for FC passthrough job data, allocate it
  with dd_bsg_data for passthrough requests and unify common code for
  ct and els passthrough request
- simplify callback handling in zfcp_fc

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c  |   56 +++------
 drivers/s390/scsi/zfcp_dbf.h  |    7 -
 drivers/s390/scsi/zfcp_def.h  |   46 -------
 drivers/s390/scsi/zfcp_ext.h  |   12 +
 drivers/s390/scsi/zfcp_fc.c   |  253 +++++++++++++++---------------------------
 drivers/s390/scsi/zfcp_fc.h   |    7 -
 drivers/s390/scsi/zfcp_fsf.c  |   28 ++--
 drivers/s390/scsi/zfcp_fsf.h  |   18 ++
 drivers/s390/scsi/zfcp_scsi.c |   18 --
 9 files changed, 160 insertions(+), 285 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-11-24 16:35:39.000000000 +0100
@@ -179,7 +179,6 @@ void _zfcp_dbf_hba_fsf_response(const ch
 	case FSF_QTCB_SEND_ELS:
 		send_els = (struct zfcp_send_els *)fsf_req->data;
 		response->u.els.d_id = ntoh24(qtcb->bottom.support.d_id);
-		response->u.els.ls_code = send_els->ls_code >> 24;
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -349,7 +348,6 @@ static void zfcp_dbf_hba_view_response(c
 
 	case FSF_QTCB_SEND_ELS:
 		zfcp_dbf_out(p, "d_id", "0x%06x", r->u.els.d_id);
-		zfcp_dbf_out(p, "ls_code", "0x%02x", r->u.els.ls_code);
 		break;
 
 	case FSF_QTCB_ABORT_FCP_CMND:
@@ -678,12 +676,12 @@ void zfcp_dbf_rec_action(char *id2, stru
 /**
  * zfcp_dbf_san_ct_request - trace event for issued CT request
  * @fsf_req: request containing issued CT data
+ * @d_id: destination id where ct request is sent to
  */
-void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *fsf_req, u32 d_id)
 {
-	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
-	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_fsf_ct_els *ct = (struct zfcp_fsf_ct_els *)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct fc_ct_hdr *hdr = sg_virt(ct->req);
 	struct zfcp_dbf_san_record *r = &dbf->san_buf;
@@ -696,8 +694,7 @@ void zfcp_dbf_san_ct_request(struct zfcp
 	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
 	r->fsf_seqno = fsf_req->seq_no;
-	r->s_id = fc_host_port_id(adapter->scsi_host);
-	r->d_id = wka_port->d_id;
+	oct->d_id = d_id;
 	oct->cmd_req_code = hdr->ct_cmd;
 	oct->revision = hdr->ct_rev;
 	oct->gs_type = hdr->ct_fs_type;
@@ -718,9 +715,8 @@ void zfcp_dbf_san_ct_request(struct zfcp
  */
 void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
-	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
-	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_fsf_ct_els *ct = (struct zfcp_fsf_ct_els *)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fc_ct_hdr *hdr = sg_virt(ct->resp);
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_san_record *r = &dbf->san_buf;
@@ -733,8 +729,6 @@ void zfcp_dbf_san_ct_response(struct zfc
 	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
 	r->fsf_seqno = fsf_req->seq_no;
-	r->s_id = wka_port->d_id;
-	r->d_id = fc_host_port_id(adapter->scsi_host);
 	rct->cmd_rsp_code = hdr->ct_cmd;
 	rct->revision = hdr->ct_rev;
 	rct->reason_code = hdr->ct_reason;
@@ -750,8 +744,8 @@ void zfcp_dbf_san_ct_response(struct zfc
 }
 
 static void zfcp_dbf_san_els(const char *tag, int level,
-			     struct zfcp_fsf_req *fsf_req, u32 s_id, u32 d_id,
-			     u8 ls_code, void *buffer, int buflen)
+			     struct zfcp_fsf_req *fsf_req, u32 d_id,
+			     void *buffer, int buflen)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct zfcp_dbf *dbf = adapter->dbf;
@@ -763,9 +757,7 @@ static void zfcp_dbf_san_els(const char 
 	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 	rec->fsf_reqid = fsf_req->req_id;
 	rec->fsf_seqno = fsf_req->seq_no;
-	rec->s_id = s_id;
-	rec->d_id = d_id;
-	rec->u.els.ls_code = ls_code;
+	rec->u.els.d_id = d_id;
 	debug_event(dbf->san, level, rec, sizeof(*rec));
 	zfcp_dbf_hexdump(dbf->san, rec, sizeof(*rec), level,
 			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
@@ -778,12 +770,11 @@ static void zfcp_dbf_san_els(const char 
  */
 void zfcp_dbf_san_els_request(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
+	struct zfcp_fsf_ct_els *els = (struct zfcp_fsf_ct_els *)fsf_req->data;
+	u32 d_id = ntoh24(fsf_req->qtcb->bottom.support.d_id);
 
-	zfcp_dbf_san_els("oels", 2, fsf_req,
-			       fc_host_port_id(els->adapter->scsi_host),
-			       els->d_id, *(u8 *) sg_virt(els->req),
-			       sg_virt(els->req), els->req->length);
+	zfcp_dbf_san_els("oels", 2, fsf_req, d_id,
+			 sg_virt(els->req), els->req->length);
 }
 
 /**
@@ -792,12 +783,11 @@ void zfcp_dbf_san_els_request(struct zfc
  */
 void zfcp_dbf_san_els_response(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_send_els *els = (struct zfcp_send_els *)fsf_req->data;
+	struct zfcp_fsf_ct_els *els = (struct zfcp_fsf_ct_els *)fsf_req->data;
+	u32 d_id = ntoh24(fsf_req->qtcb->bottom.support.d_id);
 
-	zfcp_dbf_san_els("rels", 2, fsf_req, els->d_id,
-			       fc_host_port_id(els->adapter->scsi_host),
-			       *(u8 *)sg_virt(els->req), sg_virt(els->resp),
-			       els->resp->length);
+	zfcp_dbf_san_els("rels", 2, fsf_req, d_id,
+			       sg_virt(els->resp), els->resp->length);
 }
 
 /**
@@ -806,16 +796,13 @@ void zfcp_dbf_san_els_response(struct zf
  */
 void zfcp_dbf_san_incoming_els(struct zfcp_fsf_req *fsf_req)
 {
-	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_status_read_buffer *buf =
 			(struct fsf_status_read_buffer *)fsf_req->data;
 	int length = (int)buf->length -
 		     (int)((void *)&buf->payload - (void *)buf);
 
 	zfcp_dbf_san_els("iels", 1, fsf_req, ntoh24(buf->d_id),
-			       fc_host_port_id(adapter->scsi_host),
-			       buf->payload.data[0], (void *)buf->payload.data,
-			       length);
+			       (void *)buf->payload.data, length);
 }
 
 static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
@@ -830,11 +817,10 @@ static int zfcp_dbf_san_view_format(debu
 	zfcp_dbf_tag(&p, "tag", r->tag);
 	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
 	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-	zfcp_dbf_out(&p, "s_id", "0x%06x", r->s_id);
-	zfcp_dbf_out(&p, "d_id", "0x%06x", r->d_id);
 
 	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_dbf_san_record_ct_request *ct = &r->u.ct_req;
+		zfcp_dbf_out(&p, "d_id", "0x%06x", ct->d_id);
 		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x", ct->cmd_req_code);
 		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
 		zfcp_dbf_out(&p, "gs_type", "0x%02x", ct->gs_type);
@@ -853,7 +839,7 @@ static int zfcp_dbf_san_view_format(debu
 		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
 		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
 		struct zfcp_dbf_san_record_els *els = &r->u.els;
-		zfcp_dbf_out(&p, "ls_code", "0x%02x", els->ls_code);
+		zfcp_dbf_out(&p, "d_id", "0x%06x", els->d_id);
 	}
 	return p - out_buf;
 }
--- a/drivers/s390/scsi/zfcp_dbf.h	2009-11-24 16:35:25.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.h	2009-11-24 16:35:39.000000000 +0100
@@ -123,7 +123,6 @@ struct zfcp_dbf_hba_record_response {
 		} unit;
 		struct {
 			u32 d_id;
-			u8 ls_code;
 		} els;
 	} u;
 } __attribute__ ((packed));
@@ -167,6 +166,7 @@ struct zfcp_dbf_san_record_ct_request {
 	u8 options;
 	u16 max_res_size;
 	u32 len;
+	u32 d_id;
 } __attribute__ ((packed));
 
 struct zfcp_dbf_san_record_ct_response {
@@ -180,16 +180,13 @@ struct zfcp_dbf_san_record_ct_response {
 } __attribute__ ((packed));
 
 struct zfcp_dbf_san_record_els {
-	u8 ls_code;
-	u32 len;
+	u32 d_id;
 } __attribute__ ((packed));
 
 struct zfcp_dbf_san_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u64 fsf_reqid;
 	u32 fsf_seqno;
-	u32 s_id;
-	u32 d_id;
 	union {
 		struct zfcp_dbf_san_record_ct_request ct_req;
 		struct zfcp_dbf_san_record_ct_response ct_resp;
--- a/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-11-24 16:35:39.000000000 +0100
@@ -132,52 +132,6 @@ struct zfcp_adapter_mempool {
 	mempool_t *qtcb_pool;
 };
 
-/**
- * struct zfcp_send_ct - used to pass parameters to function zfcp_fsf_send_ct
- * @wka_port: port where the request is sent to
- * @req: scatter-gather list for request
- * @resp: scatter-gather list for response
- * @handler: handler function (called for response to the request)
- * @handler_data: data passed to handler function
- * @completion: completion for synchronization purposes
- * @status: used to pass error status to calling function
- */
-struct zfcp_send_ct {
-	struct zfcp_fc_wka_port *wka_port;
-	struct scatterlist *req;
-	struct scatterlist *resp;
-	void (*handler)(unsigned long);
-	unsigned long handler_data;
-	struct completion *completion;
-	int status;
-};
-
-/**
- * struct zfcp_send_els - used to pass parameters to function zfcp_fsf_send_els
- * @adapter: adapter where request is sent from
- * @port: port where ELS is destinated (port reference count has to be increased)
- * @d_id: destiniation id of port where request is sent to
- * @req: scatter-gather list for request
- * @resp: scatter-gather list for response
- * @handler: handler function (called for response to the request)
- * @handler_data: data passed to handler function
- * @completion: completion for synchronization purposes
- * @ls_code: hex code of ELS command
- * @status: used to pass error status to calling function
- */
-struct zfcp_send_els {
-	struct zfcp_adapter *adapter;
-	struct zfcp_port *port;
-	u32 d_id;
-	struct scatterlist *req;
-	struct scatterlist *resp;
-	void (*handler)(unsigned long);
-	unsigned long handler_data;
-	struct completion *completion;
-	int ls_code;
-	int status;
-};
-
 struct zfcp_qdio_queue {
 	struct qdio_buffer *sbal[QDIO_MAX_BUFFERS_PER_Q];
 	u8		   first;	/* index of next free bfr in queue */
--- a/drivers/s390/scsi/zfcp_ext.h	2009-11-24 16:35:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-11-24 16:35:39.000000000 +0100
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <scsi/fc/fc_els.h>
 #include "zfcp_def.h"
+#include "zfcp_fc.h"
 
 /* zfcp_aux.c */
 extern struct zfcp_unit *zfcp_get_unit_by_lun(struct zfcp_port *, u64);
@@ -55,7 +56,7 @@ extern void _zfcp_dbf_hba_fsf_unsol(cons
 					  struct fsf_status_read_buffer *);
 extern void zfcp_dbf_hba_qdio(struct zfcp_dbf *, unsigned int, int, int);
 extern void zfcp_dbf_hba_berr(struct zfcp_dbf *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_els_request(struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_els_response(struct zfcp_fsf_req *);
@@ -106,8 +107,7 @@ extern void zfcp_fc_link_test_work(struc
 extern void zfcp_fc_wka_ports_force_offline(struct zfcp_fc_wka_ports *);
 extern int zfcp_fc_gs_setup(struct zfcp_adapter *);
 extern void zfcp_fc_gs_destroy(struct zfcp_adapter *);
-extern int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *);
-extern int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *);
+extern int zfcp_fc_exec_bsg_job(struct fc_bsg_job *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
@@ -128,8 +128,10 @@ extern struct zfcp_fsf_req *zfcp_fsf_con
 extern void zfcp_fsf_req_dismiss_all(struct zfcp_adapter *);
 extern int zfcp_fsf_status_read(struct zfcp_qdio *);
 extern int zfcp_status_read_refill(struct zfcp_adapter *adapter);
-extern int zfcp_fsf_send_ct(struct zfcp_send_ct *, mempool_t *);
-extern int zfcp_fsf_send_els(struct zfcp_send_els *);
+extern int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *, struct zfcp_fsf_ct_els *,
+			    mempool_t *);
+extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
+			     struct zfcp_fsf_ct_els *);
 extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
 					  struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-11-24 16:35:39.000000000 +0100
@@ -22,12 +22,6 @@ static u32 zfcp_fc_rscn_range_mask[] = {
 	[ELS_ADDR_FMT_FAB]		= 0x000000,
 };
 
-struct zfcp_fc_ns_handler_data {
-	struct completion done;
-	void (*handler)(unsigned long);
-	unsigned long handler_data;
-};
-
 static int zfcp_fc_wka_port_get(struct zfcp_fc_wka_port *wka_port)
 {
 	if (mutex_lock_interruptible(&wka_port->mutex))
@@ -211,21 +205,10 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 		zfcp_fc_incoming_rscn(fsf_req);
 }
 
-static void zfcp_fc_ns_handler(unsigned long data)
-{
-	struct zfcp_fc_ns_handler_data *compl_rec =
-			(struct zfcp_fc_ns_handler_data *) data;
-
-	if (compl_rec->handler)
-		compl_rec->handler(compl_rec->handler_data);
-
-	complete(&compl_rec->done);
-}
-
-static void zfcp_fc_ns_gid_pn_eval(unsigned long data)
+static void zfcp_fc_ns_gid_pn_eval(void *data)
 {
-	struct zfcp_fc_gid_pn *gid_pn = (struct zfcp_fc_gid_pn *) data;
-	struct zfcp_send_ct *ct = &gid_pn->ct;
+	struct zfcp_fc_gid_pn *gid_pn = data;
+	struct zfcp_fsf_ct_els *ct = &gid_pn->ct;
 	struct zfcp_fc_gid_pn_req *gid_pn_req = sg_virt(ct->req);
 	struct zfcp_fc_gid_pn_resp *gid_pn_resp = sg_virt(ct->resp);
 	struct zfcp_port *port = gid_pn->port;
@@ -242,18 +225,22 @@ static void zfcp_fc_ns_gid_pn_eval(unsig
 	port->d_id = ntoh24(gid_pn_resp->gid_pn.fp_fid);
 }
 
+static void zfcp_fc_complete(void *data)
+{
+	complete(data);
+}
+
 static int zfcp_fc_ns_gid_pn_request(struct zfcp_port *port,
 				     struct zfcp_fc_gid_pn *gid_pn)
 {
 	struct zfcp_adapter *adapter = port->adapter;
-	struct zfcp_fc_ns_handler_data compl_rec;
+	DECLARE_COMPLETION_ONSTACK(completion);
 	int ret;
 
 	/* setup parameters for send generic command */
 	gid_pn->port = port;
-	gid_pn->ct.wka_port = &adapter->gs->ds;
-	gid_pn->ct.handler = zfcp_fc_ns_handler;
-	gid_pn->ct.handler_data = (unsigned long) &compl_rec;
+	gid_pn->ct.handler = zfcp_fc_complete;
+	gid_pn->ct.handler_data = &completion;
 	gid_pn->ct.req = &gid_pn->sg_req;
 	gid_pn->ct.resp = &gid_pn->sg_resp;
 	sg_init_one(&gid_pn->sg_req, &gid_pn->gid_pn_req,
@@ -270,12 +257,12 @@ static int zfcp_fc_ns_gid_pn_request(str
 	gid_pn->gid_pn_req.ct_hdr.ct_mr_size = ZFCP_FC_CT_SIZE_PAGE / 4;
 	gid_pn->gid_pn_req.gid_pn.fn_wwpn = port->wwpn;
 
-	init_completion(&compl_rec.done);
-	compl_rec.handler = zfcp_fc_ns_gid_pn_eval;
-	compl_rec.handler_data = (unsigned long) gid_pn;
-	ret = zfcp_fsf_send_ct(&gid_pn->ct, adapter->pool.gid_pn_req);
-	if (!ret)
-		wait_for_completion(&compl_rec.done);
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, &gid_pn->ct,
+			       adapter->pool.gid_pn_req);
+	if (!ret) {
+		wait_for_completion(&completion);
+		zfcp_fc_ns_gid_pn_eval(gid_pn);
+	}
 	return ret;
 }
 
@@ -374,9 +361,9 @@ void zfcp_fc_plogi_evaluate(struct zfcp_
 		port->supported_classes |= FC_COS_CLASS4;
 }
 
-static void zfcp_fc_adisc_handler(unsigned long data)
+static void zfcp_fc_adisc_handler(void *data)
 {
-	struct zfcp_fc_els_adisc *adisc = (struct zfcp_fc_els_adisc *) data;
+	struct zfcp_fc_els_adisc *adisc = data;
 	struct zfcp_port *port = adisc->els.port;
 	struct fc_els_adisc *adisc_resp = &adisc->adisc_resp;
 
@@ -414,6 +401,7 @@ static int zfcp_fc_adisc(struct zfcp_por
 	if (!adisc)
 		return -ENOMEM;
 
+	adisc->els.port = port;
 	adisc->els.req = &adisc->req;
 	adisc->els.resp = &adisc->resp;
 	sg_init_one(adisc->els.req, &adisc->adisc_req,
@@ -421,21 +409,18 @@ static int zfcp_fc_adisc(struct zfcp_por
 	sg_init_one(adisc->els.resp, &adisc->adisc_resp,
 		    sizeof(struct fc_els_adisc));
 
-	adisc->els.adapter = adapter;
-	adisc->els.port = port;
-	adisc->els.d_id = port->d_id;
 	adisc->els.handler = zfcp_fc_adisc_handler;
-	adisc->els.handler_data = (unsigned long) adisc;
-	adisc->els.ls_code = adisc->adisc_req.adisc_cmd = ELS_ADISC;
+	adisc->els.handler_data = adisc;
 
 	/* acc. to FC-FS, hard_nport_id in ADISC should not be set for ports
 	   without FC-AL-2 capability, so we don't set it */
 	adisc->adisc_req.adisc_wwpn = fc_host_port_name(adapter->scsi_host);
 	adisc->adisc_req.adisc_wwnn = fc_host_node_name(adapter->scsi_host);
+	adisc->adisc_req.adisc_cmd = ELS_ADISC;
 	hton24(adisc->adisc_req.adisc_port_id,
 	       fc_host_port_id(adapter->scsi_host));
 
-	return zfcp_fsf_send_els(&adisc->els);
+	return zfcp_fsf_send_els(adapter, port->d_id, &adisc->els);
 }
 
 void zfcp_fc_link_test_work(struct work_struct *work)
@@ -520,9 +505,9 @@ out:
 static int zfcp_fc_send_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
 			       struct zfcp_adapter *adapter, int max_bytes)
 {
-	struct zfcp_send_ct *ct = &gpn_ft->ct;
+	struct zfcp_fsf_ct_els *ct = &gpn_ft->ct;
 	struct zfcp_fc_gpn_ft_req *req = sg_virt(&gpn_ft->sg_req);
-	struct zfcp_fc_ns_handler_data compl_rec;
+	DECLARE_COMPLETION_ONSTACK(completion);
 	int ret;
 
 	/* prepare CT IU for GPN_FT */
@@ -537,17 +522,14 @@ static int zfcp_fc_send_gpn_ft(struct zf
 	req->gpn_ft.fn_fc4_type = FC_TYPE_FCP;
 
 	/* prepare zfcp_send_ct */
-	ct->wka_port = &adapter->gs->ds;
-	ct->handler = zfcp_fc_ns_handler;
-	ct->handler_data = (unsigned long)&compl_rec;
+	ct->handler = zfcp_fc_complete;
+	ct->handler_data = &completion;
 	ct->req = &gpn_ft->sg_req;
 	ct->resp = gpn_ft->sg_resp;
 
-	init_completion(&compl_rec.done);
-	compl_rec.handler = NULL;
-	ret = zfcp_fsf_send_ct(ct, NULL);
+	ret = zfcp_fsf_send_ct(&adapter->gs->ds, ct, NULL);
 	if (!ret)
-		wait_for_completion(&compl_rec.done);
+		wait_for_completion(&completion);
 	return ret;
 }
 
@@ -565,13 +547,13 @@ static void zfcp_fc_validate_port(struct
 	list_move_tail(&port->list, lh);
 }
 
-static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft, int max_entries)
+static int zfcp_fc_eval_gpn_ft(struct zfcp_fc_gpn_ft *gpn_ft,
+			       struct zfcp_adapter *adapter, int max_entries)
 {
-	struct zfcp_send_ct *ct = &gpn_ft->ct;
+	struct zfcp_fsf_ct_els *ct = &gpn_ft->ct;
 	struct scatterlist *sg = gpn_ft->sg_resp;
 	struct fc_ct_hdr *hdr = sg_virt(sg);
 	struct fc_gpn_ft_resp *acc = sg_virt(sg);
-	struct zfcp_adapter *adapter = ct->wka_port->adapter;
 	struct zfcp_port *port, *tmp;
 	unsigned long flags;
 	LIST_HEAD(remove_lh);
@@ -665,7 +647,7 @@ void zfcp_fc_scan_ports(struct work_stru
 	for (i = 0; i < 3; i++) {
 		ret = zfcp_fc_send_gpn_ft(gpn_ft, adapter, max_bytes);
 		if (!ret) {
-			ret = zfcp_fc_eval_gpn_ft(gpn_ft, max_entries);
+			ret = zfcp_fc_eval_gpn_ft(gpn_ft, adapter, max_entries);
 			if (ret == -EAGAIN)
 				ssleep(1);
 			else
@@ -677,160 +659,109 @@ out:
 	zfcp_fc_wka_port_put(&adapter->gs->ds);
 }
 
-
-struct zfcp_els_fc_job {
-	struct zfcp_send_els els;
-	struct fc_bsg_job *job;
-};
-
-static void zfcp_fc_generic_els_handler(unsigned long data)
+static void zfcp_fc_ct_els_job_handler(void *data)
 {
-	struct zfcp_els_fc_job *els_fc_job = (struct zfcp_els_fc_job *) data;
-	struct fc_bsg_job *job = els_fc_job->job;
-	struct fc_bsg_reply *reply = job->reply;
+	struct fc_bsg_job *job = data;
+	struct zfcp_fsf_ct_els *zfcp_ct_els = job->dd_data;
+	int status = zfcp_ct_els->status;
+	int reply_status;
 
-	if (els_fc_job->els.status) {
-		/* request rejected or timed out */
-		reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_REJECT;
-		goto out;
-	}
-
-	reply->reply_data.ctels_reply.status = FC_CTELS_STATUS_OK;
-	reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-
-out:
-	job->state_flags = FC_RQST_STATE_DONE;
+	reply_status = status ? FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
+	job->reply->reply_data.ctels_reply.status = reply_status;
+	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
 	job->job_done(job);
-	kfree(els_fc_job);
 }
 
-int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *job)
+static int zfcp_fc_exec_els_job(struct fc_bsg_job *job,
+				struct zfcp_adapter *adapter)
 {
-	struct zfcp_els_fc_job *els_fc_job;
+	struct zfcp_fsf_ct_els *els = job->dd_data;
 	struct fc_rport *rport = job->rport;
-	struct Scsi_Host *shost;
-	struct zfcp_adapter *adapter;
 	struct zfcp_port *port;
-	u8 *port_did;
-
-	shost = rport ? rport_to_shost(rport) : job->shost;
-	adapter = (struct zfcp_adapter *)shost->hostdata[0];
-
-	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
-		return -EINVAL;
-
-	els_fc_job = kzalloc(sizeof(struct zfcp_els_fc_job), GFP_KERNEL);
-	if (!els_fc_job)
-		return -ENOMEM;
+	u32 d_id;
 
-	els_fc_job->els.adapter = adapter;
 	if (rport) {
 		port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
-		if (!port) {
-			kfree(els_fc_job);
+		if (!port)
 			return -EINVAL;
-		}
 
-		els_fc_job->els.d_id = port->d_id;
+		d_id = port->d_id;
 		put_device(&port->sysfs_device);
-	} else {
-		port_did = job->request->rqst_data.h_els.port_id;
-		els_fc_job->els.d_id = (port_did[0] << 16) +
-					(port_did[1] << 8) + port_did[2];
-	}
-
-	els_fc_job->els.req = job->request_payload.sg_list;
-	els_fc_job->els.resp = job->reply_payload.sg_list;
-	els_fc_job->els.handler = zfcp_fc_generic_els_handler;
-	els_fc_job->els.handler_data = (unsigned long) els_fc_job;
-	els_fc_job->job = job;
+	} else
+		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
 
-	return zfcp_fsf_send_els(&els_fc_job->els);
+	return zfcp_fsf_send_els(adapter, d_id, els);
 }
 
-struct zfcp_ct_fc_job {
-	struct zfcp_send_ct ct;
-	struct fc_bsg_job *job;
-};
-
-static void zfcp_fc_generic_ct_handler(unsigned long data)
-{
-	struct zfcp_ct_fc_job *ct_fc_job = (struct zfcp_ct_fc_job *) data;
-	struct fc_bsg_job *job = ct_fc_job->job;
-
-	job->reply->reply_data.ctels_reply.status = ct_fc_job->ct.status ?
-				FC_CTELS_STATUS_REJECT : FC_CTELS_STATUS_OK;
-	job->reply->reply_payload_rcv_len = job->reply_payload.payload_len;
-	job->state_flags = FC_RQST_STATE_DONE;
-	job->job_done(job);
-
-	zfcp_fc_wka_port_put(ct_fc_job->ct.wka_port);
-
-	kfree(ct_fc_job);
-}
-
-int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *job)
+static int zfcp_fc_exec_ct_job(struct fc_bsg_job *job,
+			       struct zfcp_adapter *adapter)
 {
 	int ret;
 	u8 gs_type;
-	struct fc_rport *rport = job->rport;
-	struct Scsi_Host *shost;
-	struct zfcp_adapter *adapter;
-	struct zfcp_ct_fc_job *ct_fc_job;
+	struct zfcp_fsf_ct_els *ct = job->dd_data;
+	struct zfcp_fc_wka_port *wka_port;
 	u32 preamble_word1;
 
-	shost = rport ? rport_to_shost(rport) : job->shost;
-
-	adapter = (struct zfcp_adapter *)shost->hostdata[0];
-	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
-		return -EINVAL;
-
-	ct_fc_job = kzalloc(sizeof(struct zfcp_ct_fc_job), GFP_KERNEL);
-	if (!ct_fc_job)
-		return -ENOMEM;
-
 	preamble_word1 = job->request->rqst_data.r_ct.preamble_word1;
 	gs_type = (preamble_word1 & 0xff000000) >> 24;
 
 	switch (gs_type) {
 	case FC_FST_ALIAS:
-		ct_fc_job->ct.wka_port = &adapter->gs->as;
+		wka_port = &adapter->gs->as;
 		break;
 	case FC_FST_MGMT:
-		ct_fc_job->ct.wka_port = &adapter->gs->ms;
+		wka_port = &adapter->gs->ms;
 		break;
 	case FC_FST_TIME:
-		ct_fc_job->ct.wka_port = &adapter->gs->ts;
+		wka_port = &adapter->gs->ts;
 		break;
 	case FC_FST_DIR:
-		ct_fc_job->ct.wka_port = &adapter->gs->ds;
+		wka_port = &adapter->gs->ds;
 		break;
 	default:
-		kfree(ct_fc_job);
 		return -EINVAL; /* no such service */
 	}
 
-	ret = zfcp_fc_wka_port_get(ct_fc_job->ct.wka_port);
-	if (ret) {
-		kfree(ct_fc_job);
+	ret = zfcp_fc_wka_port_get(wka_port);
+	if (ret)
 		return ret;
-	}
 
-	ct_fc_job->ct.req = job->request_payload.sg_list;
-	ct_fc_job->ct.resp = job->reply_payload.sg_list;
-	ct_fc_job->ct.handler = zfcp_fc_generic_ct_handler;
-	ct_fc_job->ct.handler_data = (unsigned long) ct_fc_job;
-	ct_fc_job->ct.completion = NULL;
-	ct_fc_job->job = job;
+	ret = zfcp_fsf_send_ct(wka_port, ct, NULL);
+	if (ret)
+		zfcp_fc_wka_port_put(wka_port);
 
-	ret = zfcp_fsf_send_ct(&ct_fc_job->ct, NULL);
-	if (ret) {
-		kfree(ct_fc_job);
-		zfcp_fc_wka_port_put(ct_fc_job->ct.wka_port);
-	}
 	return ret;
 }
 
+int zfcp_fc_exec_bsg_job(struct fc_bsg_job *job)
+{
+	struct Scsi_Host *shost;
+	struct zfcp_adapter *adapter;
+	struct zfcp_fsf_ct_els *ct_els = job->dd_data;
+
+	shost = job->rport ? rport_to_shost(job->rport) : job->shost;
+	adapter = (struct zfcp_adapter *)shost->hostdata[0];
+
+	if (!(atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_OPEN))
+		return -EINVAL;
+
+	ct_els->req = job->request_payload.sg_list;
+	ct_els->resp = job->reply_payload.sg_list;
+	ct_els->handler = zfcp_fc_ct_els_job_handler;
+	ct_els->handler_data = job;
+
+	switch (job->request->msgcode) {
+	case FC_BSG_RPT_ELS:
+	case FC_BSG_HST_ELS_NOLOGIN:
+		return zfcp_fc_exec_els_job(job, adapter);
+	case FC_BSG_RPT_CT:
+	case FC_BSG_HST_CT:
+		return zfcp_fc_exec_ct_job(job, adapter);
+	default:
+		return -EINVAL;
+	}
+}
+
 int zfcp_fc_gs_setup(struct zfcp_adapter *adapter)
 {
 	struct zfcp_fc_wka_ports *wka_ports;
--- a/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.h	2009-11-24 16:35:39.000000000 +0100
@@ -15,6 +15,7 @@
 #include <scsi/fc/fc_ns.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
+#include "zfcp_fsf.h"
 
 #define ZFCP_FC_CT_SIZE_PAGE	  (PAGE_SIZE - sizeof(struct fc_ct_hdr))
 #define ZFCP_FC_GPN_FT_ENT_PAGE	  (ZFCP_FC_CT_SIZE_PAGE \
@@ -55,7 +56,7 @@ struct zfcp_fc_gid_pn_resp {
  * @gid_pn_resp: GID_PN response data
  */
 struct zfcp_fc_gid_pn {
-	struct zfcp_send_ct ct;
+	struct zfcp_fsf_ct_els ct;
 	struct scatterlist sg_req;
 	struct scatterlist sg_resp;
 	struct zfcp_fc_gid_pn_req gid_pn_req;
@@ -90,7 +91,7 @@ struct zfcp_fc_gpn_ft_resp {
  * @sg_resp: scatter list entries for gpn_ft responses (per memory page)
  */
 struct zfcp_fc_gpn_ft {
-	struct zfcp_send_ct ct;
+	struct zfcp_fsf_ct_els ct;
 	struct scatterlist sg_req;
 	struct scatterlist sg_resp[ZFCP_FC_GPN_FT_NUM_BUFS];
 };
@@ -104,7 +105,7 @@ struct zfcp_fc_gpn_ft {
  * @adisc_resp: ELS ADISC response data
  */
 struct zfcp_fc_els_adisc {
-	struct zfcp_send_els els;
+	struct zfcp_fsf_ct_els els;
 	struct scatterlist req;
 	struct scatterlist resp;
 	struct fc_els_adisc adisc_req;
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 16:35:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-11-24 16:35:39.000000000 +0100
@@ -961,10 +961,10 @@ out:
 static void zfcp_fsf_send_ct_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct zfcp_send_ct *send_ct = req->data;
+	struct zfcp_fsf_ct_els *ct = req->data;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
-	send_ct->status = -EINVAL;
+	ct->status = -EINVAL;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		goto skip_fsfstatus;
@@ -972,7 +972,7 @@ static void zfcp_fsf_send_ct_handler(str
 	switch (header->fsf_status) {
         case FSF_GOOD:
 		zfcp_dbf_san_ct_response(req);
-		send_ct->status = 0;
+		ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
 		zfcp_fsf_class_not_supp(req);
@@ -1004,8 +1004,8 @@ static void zfcp_fsf_send_ct_handler(str
 	}
 
 skip_fsfstatus:
-	if (send_ct->handler)
-		send_ct->handler(send_ct->handler_data);
+	if (ct->handler)
+		ct->handler(ct->handler_data);
 }
 
 static void zfcp_fsf_setup_ct_els_unchained(struct qdio_buffer_element *sbale,
@@ -1094,9 +1094,9 @@ static int zfcp_fsf_setup_ct_els(struct 
  * @ct: pointer to struct zfcp_send_ct with data for request
  * @pool: if non-null this mempool is used to allocate struct zfcp_fsf_req
  */
-int zfcp_fsf_send_ct(struct zfcp_send_ct *ct, mempool_t *pool)
+int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
+		     struct zfcp_fsf_ct_els *ct, mempool_t *pool)
 {
-	struct zfcp_fc_wka_port *wka_port = ct->wka_port;
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
 	struct zfcp_fsf_req *req;
 	int ret = -EIO;
@@ -1122,7 +1122,7 @@ int zfcp_fsf_send_ct(struct zfcp_send_ct
 	req->qtcb->header.port_handle = wka_port->handle;
 	req->data = ct;
 
-	zfcp_dbf_san_ct_request(req);
+	zfcp_dbf_san_ct_request(req, wka_port->d_id);
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
@@ -1139,7 +1139,7 @@ out:
 
 static void zfcp_fsf_send_els_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_send_els *send_els = req->data;
+	struct zfcp_fsf_ct_els *send_els = req->data;
 	struct zfcp_port *port = send_els->port;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
@@ -1159,9 +1159,6 @@ static void zfcp_fsf_send_els_handler(st
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]){
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			if (port && (send_els->ls_code != ELS_ADISC))
-				zfcp_fc_test_link(port);
-			/*fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 		case FSF_SQ_RETRY_IF_POSSIBLE:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1193,10 +1190,11 @@ skip_fsfstatus:
  * zfcp_fsf_send_els - initiate an ELS command (FC-FS)
  * @els: pointer to struct zfcp_send_els with data for the command
  */
-int zfcp_fsf_send_els(struct zfcp_send_els *els)
+int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
+		      struct zfcp_fsf_ct_els *els)
 {
 	struct zfcp_fsf_req *req;
-	struct zfcp_qdio *qdio = els->adapter->qdio;
+	struct zfcp_qdio *qdio = adapter->qdio;
 	int ret = -EIO;
 
 	spin_lock_bh(&qdio->req_q_lock);
@@ -1216,7 +1214,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 	if (ret)
 		goto failed_send;
 
-	hton24(req->qtcb->bottom.support.d_id, els->d_id);
+	hton24(req->qtcb->bottom.support.d_id, d_id);
 	req->handler = zfcp_fsf_send_els_handler;
 	req->data = els;
 
--- a/drivers/s390/scsi/zfcp_fsf.h	2009-11-24 16:35:38.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.h	2009-11-24 16:35:39.000000000 +0100
@@ -437,4 +437,22 @@ struct zfcp_blk_drv_data {
 	u64 fabric_lat;
 } __attribute__ ((packed));
 
+/**
+ * struct zfcp_fsf_ct_els - zfcp data for ct or els request
+ * @req: scatter-gather list for request
+ * @resp: scatter-gather list for response
+ * @handler: handler function (called for response to the request)
+ * @handler_data: data passed to handler function
+ * @port: Optional pointer to port for zfcp internal ELS (only test link ADISC)
+ * @status: used to pass error status to calling function
+ */
+struct zfcp_fsf_ct_els {
+	struct scatterlist *req;
+	struct scatterlist *resp;
+	void (*handler)(void *);
+	void *handler_data;
+	struct zfcp_port *port;
+	int status;
+};
+
 #endif				/* FSF_H */
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 16:35:25.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 16:35:39.000000000 +0100
@@ -14,6 +14,7 @@
 #include <asm/atomic.h>
 #include "zfcp_ext.h"
 #include "zfcp_dbf.h"
+#include "zfcp_fc.h"
 
 static unsigned int default_depth = 32;
 module_param_named(queue_depth, default_depth, uint, 0600);
@@ -628,20 +629,6 @@ void zfcp_scsi_scan(struct work_struct *
 	put_device(&unit->sysfs_device);
 }
 
-static int zfcp_execute_fc_job(struct fc_bsg_job *job)
-{
-	switch (job->request->msgcode) {
-	case FC_BSG_RPT_ELS:
-	case FC_BSG_HST_ELS_NOLOGIN:
-		return zfcp_fc_execute_els_fc_job(job);
-	case FC_BSG_RPT_CT:
-	case FC_BSG_HST_CT:
-		return zfcp_fc_execute_ct_fc_job(job);
-	default:
-		return -EINVAL;
-	}
-}
-
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
@@ -662,13 +649,14 @@ struct fc_function_template zfcp_transpo
 	.get_host_port_state = zfcp_get_host_port_state,
 	.terminate_rport_io = zfcp_scsi_terminate_rport_io,
 	.show_host_port_state = 1,
-	.bsg_request = zfcp_execute_fc_job,
+	.bsg_request = zfcp_fc_exec_bsg_job,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */
 	.show_host_port_type = 1,
 	.show_host_speed = 1,
 	.show_host_port_id = 1,
 	.disable_target_scan = 1,
+	.dd_bsg_size = sizeof(struct zfcp_fsf_ct_els),
 };
 
 struct zfcp_data zfcp_data = {

