From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 2/7] zfcp: Redesign of the debug tracing for SAN records.
Date: Thu, 02 Dec 2010 15:16:13 +0100
Message-ID: <20101202141918.947611880@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:50421 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab0LBOTY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:24 -0500
Content-Disposition: inline; filename=702-zfcp-debug-tracing-san.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

This patch is the continuation to redesign the zfcp tracing to a more
straight-forward and easy to extend scheme.

This patch deals with all trace records of the zfcp SAN area.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |  205 ++++++++++---------------------------------
 drivers/s390/scsi/zfcp_dbf.h |   68 ++++++--------
 drivers/s390/scsi/zfcp_ext.h |    8 -
 drivers/s390/scsi/zfcp_fc.c  |    2 
 drivers/s390/scsi/zfcp_fsf.c |    8 -
 5 files changed, 87 insertions(+), 204 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-12-02 11:14:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-12-02 11:14:00.000000000 +0100
@@ -527,183 +527,79 @@ void zfcp_dbf_rec_run(char *tag, struct
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
-/**
- * zfcp_dbf_san_ct_request - trace event for issued CT request
- * @fsf_req: request containing issued CT data
- * @d_id: destination id where ct request is sent to
- */
-void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *fsf_req, u32 d_id)
-{
-	struct zfcp_fsf_ct_els *ct = (struct zfcp_fsf_ct_els *)fsf_req->data;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct fc_ct_hdr *hdr = sg_virt(ct->req);
-	struct zfcp_dbf_san_record *r = &dbf->san_buf;
-	struct zfcp_dbf_san_record_ct_request *oct = &r->u.ct_req;
-	int level = 3;
-	unsigned long flags;
-
-	spin_lock_irqsave(&dbf->san_lock, flags);
-	memset(r, 0, sizeof(*r));
-	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
-	r->fsf_reqid = fsf_req->req_id;
-	r->fsf_seqno = fsf_req->seq_no;
-	oct->d_id = d_id;
-	oct->cmd_req_code = hdr->ct_cmd;
-	oct->revision = hdr->ct_rev;
-	oct->gs_type = hdr->ct_fs_type;
-	oct->gs_subtype = hdr->ct_fs_subtype;
-	oct->options = hdr->ct_options;
-	oct->max_res_size = hdr->ct_mr_size;
-	oct->len = min((int)ct->req->length - (int)sizeof(struct fc_ct_hdr),
-		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(dbf->san, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
-			 (void *)hdr + sizeof(struct fc_ct_hdr), oct->len);
-	spin_unlock_irqrestore(&dbf->san_lock, flags);
-}
-
-/**
- * zfcp_dbf_san_ct_response - trace event for completion of CT request
- * @fsf_req: request containing CT response
- */
-void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *fsf_req)
+static inline
+void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf, void *data, u8 id, u16 len,
+		  u64 req_id, u32 d_id)
 {
-	struct zfcp_fsf_ct_els *ct = (struct zfcp_fsf_ct_els *)fsf_req->data;
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct fc_ct_hdr *hdr = sg_virt(ct->resp);
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_dbf_san_record *r = &dbf->san_buf;
-	struct zfcp_dbf_san_record_ct_response *rct = &r->u.ct_resp;
-	int level = 3;
+	struct zfcp_dbf_san *rec = &dbf->san_buf;
+	u16 rec_len;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->san_lock, flags);
-	memset(r, 0, sizeof(*r));
-	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
-	r->fsf_reqid = fsf_req->req_id;
-	r->fsf_seqno = fsf_req->seq_no;
-	rct->cmd_rsp_code = hdr->ct_cmd;
-	rct->revision = hdr->ct_rev;
-	rct->reason_code = hdr->ct_reason;
-	rct->expl = hdr->ct_explan;
-	rct->vendor_unique = hdr->ct_vendor;
-	rct->max_res_size = hdr->ct_mr_size;
-	rct->len = min((int)ct->resp->length - (int)sizeof(struct fc_ct_hdr),
-		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(dbf->san, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(dbf->san, r, sizeof(*r), level,
-			 (void *)hdr + sizeof(struct fc_ct_hdr), rct->len);
-	spin_unlock_irqrestore(&dbf->san_lock, flags);
-}
+	memset(rec, 0, sizeof(*rec));
 
-static void zfcp_dbf_san_els(const char *tag, int level,
-			     struct zfcp_fsf_req *fsf_req, u32 d_id,
-			     void *buffer, int buflen)
-{
-	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_dbf_san_record *rec = &dbf->san_buf;
-	unsigned long flags;
+	rec->id = id;
+	rec->fsf_req_id = req_id;
+	rec->d_id = d_id;
+	rec_len = min(len, (u16)ZFCP_DBF_SAN_MAX_PAYLOAD);
+	memcpy(rec->payload, data, rec_len);
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
 
-	spin_lock_irqsave(&dbf->san_lock, flags);
-	memset(rec, 0, sizeof(*rec));
-	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
-	rec->fsf_reqid = fsf_req->req_id;
-	rec->fsf_seqno = fsf_req->seq_no;
-	rec->u.els.d_id = d_id;
-	debug_event(dbf->san, level, rec, sizeof(*rec));
-	zfcp_dbf_hexdump(dbf->san, rec, sizeof(*rec), level,
-			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
+	debug_event(dbf->san, 1, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
 /**
- * zfcp_dbf_san_els_request - trace event for issued ELS
- * @fsf_req: request containing issued ELS
+ * zfcp_dbf_san_req - trace event for issued SAN request
+ * @tag: indentifier for event
+ * @fsf_req: request containing issued CT data
+ * d_id: destination ID
  */
-void zfcp_dbf_san_els_request(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
 {
-	struct zfcp_fsf_ct_els *els = (struct zfcp_fsf_ct_els *)fsf_req->data;
-	u32 d_id = ntoh24(fsf_req->qtcb->bottom.support.d_id);
-
-	zfcp_dbf_san_els("oels", 2, fsf_req, d_id,
-			 sg_virt(els->req), els->req->length);
+	struct zfcp_dbf *dbf = fsf->adapter->dbf;
+	struct zfcp_fsf_ct_els *ct_els = fsf->data;
+	u16 length;
+
+	length = (u16)(ct_els->req->length + FC_CT_HDR_LEN);
+	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->req), ZFCP_DBF_SAN_REQ, length,
+		     fsf->req_id, d_id);
 }
 
 /**
- * zfcp_dbf_san_els_response - trace event for completed ELS
- * @fsf_req: request containing ELS response
+ * zfcp_dbf_san_res - trace event for received SAN request
+ * @tag: indentifier for event
+ * @fsf_req: request containing issued CT data
  */
-void zfcp_dbf_san_els_response(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 {
-	struct zfcp_fsf_ct_els *els = (struct zfcp_fsf_ct_els *)fsf_req->data;
-	u32 d_id = ntoh24(fsf_req->qtcb->bottom.support.d_id);
-
-	zfcp_dbf_san_els("rels", 2, fsf_req, d_id,
-			       sg_virt(els->resp), els->resp->length);
+	struct zfcp_dbf *dbf = fsf->adapter->dbf;
+	struct zfcp_fsf_ct_els *ct_els = fsf->data;
+	u16 length;
+
+	length = (u16)(ct_els->resp->length + FC_CT_HDR_LEN);
+	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->resp), ZFCP_DBF_SAN_RES, length,
+		     fsf->req_id, 0);
 }
 
 /**
- * zfcp_dbf_san_incoming_els - trace event for incomig ELS
- * @fsf_req: request containing unsolicited status buffer with incoming ELS
+ * zfcp_dbf_san_in_els - trace event for incoming ELS
+ * @tag: indentifier for event
+ * @fsf_req: request containing issued CT data
  */
-void zfcp_dbf_san_incoming_els(struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
 {
-	struct fsf_status_read_buffer *buf =
-			(struct fsf_status_read_buffer *)fsf_req->data;
-	int length = (int)buf->length -
-		     (int)((void *)&buf->payload - (void *)buf);
-
-	zfcp_dbf_san_els("iels", 1, fsf_req, ntoh24(buf->d_id),
-			       (void *)buf->payload.data, length);
+	struct zfcp_dbf *dbf = fsf->adapter->dbf;
+	struct fsf_status_read_buffer *srb =
+		(struct fsf_status_read_buffer *) fsf->data;
+	u16 length;
+
+	length = (u16)(srb->length -
+			offsetof(struct fsf_status_read_buffer, payload));
+	zfcp_dbf_san(tag, dbf, srb->payload.data, ZFCP_DBF_SAN_ELS, length,
+		     fsf->req_id, ntoh24(srb->d_id));
 }
 
-static int zfcp_dbf_san_view_format(debug_info_t *id, struct debug_view *view,
-				    char *out_buf, const char *in_buf)
-{
-	struct zfcp_dbf_san_record *r = (struct zfcp_dbf_san_record *)in_buf;
-	char *p = out_buf;
-
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
-		return 0;
-
-	zfcp_dbf_tag(&p, "tag", r->tag);
-	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
-	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-
-	if (strncmp(r->tag, "octc", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_dbf_san_record_ct_request *ct = &r->u.ct_req;
-		zfcp_dbf_out(&p, "d_id", "0x%06x", ct->d_id);
-		zfcp_dbf_out(&p, "cmd_req_code", "0x%04x", ct->cmd_req_code);
-		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
-		zfcp_dbf_out(&p, "gs_type", "0x%02x", ct->gs_type);
-		zfcp_dbf_out(&p, "gs_subtype", "0x%02x", ct->gs_subtype);
-		zfcp_dbf_out(&p, "options", "0x%02x", ct->options);
-		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-	} else if (strncmp(r->tag, "rctc", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_dbf_san_record_ct_response *ct = &r->u.ct_resp;
-		zfcp_dbf_out(&p, "cmd_rsp_code", "0x%04x", ct->cmd_rsp_code);
-		zfcp_dbf_out(&p, "revision", "0x%02x", ct->revision);
-		zfcp_dbf_out(&p, "reason_code", "0x%02x", ct->reason_code);
-		zfcp_dbf_out(&p, "reason_code_expl", "0x%02x", ct->expl);
-		zfcp_dbf_out(&p, "vendor_unique", "0x%02x", ct->vendor_unique);
-		zfcp_dbf_out(&p, "max_res_size", "0x%04x", ct->max_res_size);
-	} else if (strncmp(r->tag, "oels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(r->tag, "rels", ZFCP_DBF_TAG_SIZE) == 0 ||
-		   strncmp(r->tag, "iels", ZFCP_DBF_TAG_SIZE) == 0) {
-		struct zfcp_dbf_san_record_els *els = &r->u.els;
-		zfcp_dbf_out(&p, "d_id", "0x%06x", els->d_id);
-	}
-	return p - out_buf;
-}
-
-static struct debug_view zfcp_dbf_san_view = {
-	.name = "structured",
-	.header_proc = zfcp_dbf_view_header,
-	.format_proc = zfcp_dbf_san_view_format,
-};
-
 void _zfcp_dbf_scsi(const char *tag, const char *tag2, int level,
 		    struct zfcp_dbf *dbf, struct scsi_cmnd *scsi_cmnd,
 		    struct zfcp_fsf_req *fsf_req, unsigned long old_req_id)
@@ -882,8 +778,7 @@ int zfcp_dbf_adapter_register(struct zfc
 
 	/* debug feature area which records SAN command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
-	dbf->san = zfcp_dbf_reg(dbf_name, 6, &zfcp_dbf_san_view,
-				sizeof(struct zfcp_dbf_san_record));
+	dbf->san = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_san));
 	if (!dbf->san)
 		goto err_out;
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2010-12-02 11:14:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2010-12-02 11:14:00.000000000 +0100
@@ -108,6 +108,34 @@ struct zfcp_dbf_rec {
 	} u;
 } __packed;
 
+/**
+ * enum zfcp_dbf_san_id - SAN trace record identifier
+ * @ZFCP_DBF_SAN_REQ: request trace record id
+ * @ZFCP_DBF_SAN_RES: response trace record id
+ * @ZFCP_DBF_SAN_ELS: extended link service record id
+ */
+enum zfcp_dbf_san_id {
+	ZFCP_DBF_SAN_REQ	= 1,
+	ZFCP_DBF_SAN_RES	= 2,
+	ZFCP_DBF_SAN_ELS	= 3,
+};
+
+/** struct zfcp_dbf_san - trace record for SAN requests and responses
+ * @id: unique number of recovery record type
+ * @tag: identifier string specifying the location of initiation
+ * @fsf_req_id: request id for fsf requests
+ * @payload: unformatted information related to request/response
+ * @d_id: destination id
+ */
+struct zfcp_dbf_san {
+	u8 id;
+	char tag[ZFCP_DBF_TAG_LEN];
+	u64 fsf_req_id;
+	u32 d_id;
+#define ZFCP_DBF_SAN_MAX_PAYLOAD (FC_CT_HDR_LEN + 32)
+	char payload[ZFCP_DBF_SAN_MAX_PAYLOAD];
+} __packed;
+
 struct zfcp_dbf_hba_record_response {
 	u32 fsf_command;
 	u64 fsf_reqid;
@@ -176,44 +204,6 @@ struct zfcp_dbf_hba_record {
 	} u;
 } __attribute__ ((packed));
 
-struct zfcp_dbf_san_record_ct_request {
-	u16 cmd_req_code;
-	u8 revision;
-	u8 gs_type;
-	u8 gs_subtype;
-	u8 options;
-	u16 max_res_size;
-	u32 len;
-	u32 d_id;
-} __attribute__ ((packed));
-
-struct zfcp_dbf_san_record_ct_response {
-	u16 cmd_rsp_code;
-	u8 revision;
-	u8 reason_code;
-	u8 expl;
-	u8 vendor_unique;
-	u16 max_res_size;
-	u32 len;
-} __attribute__ ((packed));
-
-struct zfcp_dbf_san_record_els {
-	u32 d_id;
-} __attribute__ ((packed));
-
-struct zfcp_dbf_san_record {
-	u8 tag[ZFCP_DBF_TAG_SIZE];
-	u64 fsf_reqid;
-	u32 fsf_seqno;
-	union {
-		struct zfcp_dbf_san_record_ct_request ct_req;
-		struct zfcp_dbf_san_record_ct_response ct_resp;
-		struct zfcp_dbf_san_record_els els;
-	} u;
-} __attribute__ ((packed));
-
-#define ZFCP_DBF_SAN_MAX_PAYLOAD 1024
-
 struct zfcp_dbf_scsi_record {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
 	u8 tag2[ZFCP_DBF_TAG_SIZE];
@@ -250,7 +240,7 @@ struct zfcp_dbf {
 	spinlock_t			scsi_lock;
 	struct zfcp_dbf_rec		rec_buf;
 	struct zfcp_dbf_hba_record	hba_buf;
-	struct zfcp_dbf_san_record	san_buf;
+	struct zfcp_dbf_san		san_buf;
 	struct zfcp_dbf_scsi_record	scsi_buf;
 	struct zfcp_adapter		*adapter;
 };
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-12-02 11:14:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-12-02 11:14:00.000000000 +0100
@@ -55,11 +55,9 @@ extern void _zfcp_dbf_hba_fsf_unsol(cons
 					  struct fsf_status_read_buffer *);
 extern void zfcp_dbf_hba_qdio(struct zfcp_dbf *, unsigned int, int, int);
 extern void zfcp_dbf_hba_berr(struct zfcp_dbf *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_san_ct_request(struct zfcp_fsf_req *, u32);
-extern void zfcp_dbf_san_ct_response(struct zfcp_fsf_req *);
-extern void zfcp_dbf_san_els_request(struct zfcp_fsf_req *);
-extern void zfcp_dbf_san_els_response(struct zfcp_fsf_req *);
-extern void zfcp_dbf_san_incoming_els(struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
+extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_san_in_els(char *, struct zfcp_fsf_req *);
 extern void _zfcp_dbf_scsi(const char *, const char *, int, struct zfcp_dbf *,
 			   struct scsi_cmnd *, struct zfcp_fsf_req *,
 			   unsigned long);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2010-12-02 11:13:24.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2010-12-02 11:14:00.000000000 +0100
@@ -251,7 +251,7 @@ void zfcp_fc_incoming_els(struct zfcp_fs
 		(struct fsf_status_read_buffer *) fsf_req->data;
 	unsigned int els_type = status_buffer->payload.data[0];
 
-	zfcp_dbf_san_incoming_els(fsf_req);
+	zfcp_dbf_san_in_els("fciels1", fsf_req);
 	if (els_type == ELS_PLOGI)
 		zfcp_fc_incoming_plogi(fsf_req);
 	else if (els_type == ELS_LOGO)
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-12-02 11:14:00.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-12-02 11:14:00.000000000 +0100
@@ -882,7 +882,7 @@ static void zfcp_fsf_send_ct_handler(str
 
 	switch (header->fsf_status) {
         case FSF_GOOD:
-		zfcp_dbf_san_ct_response(req);
+		zfcp_dbf_san_res("fsscth1", req);
 		ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -1025,7 +1025,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_
 	req->qtcb->header.port_handle = wka_port->handle;
 	req->data = ct;
 
-	zfcp_dbf_san_ct_request(req, wka_port->d_id);
+	zfcp_dbf_san_req("fssct_1", req, wka_port->d_id);
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)
@@ -1053,7 +1053,7 @@ static void zfcp_fsf_send_els_handler(st
 
 	switch (header->fsf_status) {
 	case FSF_GOOD:
-		zfcp_dbf_san_els_response(req);
+		zfcp_dbf_san_res("fsselh1", req);
 		send_els->status = 0;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -1127,7 +1127,7 @@ int zfcp_fsf_send_els(struct zfcp_adapte
 	req->handler = zfcp_fsf_send_els_handler;
 	req->data = els;
 
-	zfcp_dbf_san_els_request(req);
+	zfcp_dbf_san_req("fssels1", req, d_id);
 
 	ret = zfcp_fsf_req_send(req);
 	if (ret)

