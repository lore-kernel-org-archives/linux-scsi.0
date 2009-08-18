From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/27] zfcp: Move debug data from zfcp_data to own data structure
Date: Tue, 18 Aug 2009 15:43:07 +0200
Message-ID: <20090818135029.014844000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:60473 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZHRNu3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:29 -0400
Content-Disposition: inline; filename=701-zfcp-debug-data.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The struct zfcp_adapter includes everything related to the debug
traces. This introduces dependences between the definitions in
zfcp_def.h and zfcp_dbf.h. Move all debug related data structures to a
new data structure to break those dependencies and manage the debug
data in zfcp_dbf.[hc].

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    4 
 drivers/s390/scsi/zfcp_dbf.c |  217 ++++++++++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_dbf.h |   17 +++
 drivers/s390/scsi/zfcp_def.h |   15 --
 drivers/s390/scsi/zfcp_fsf.h |    3 
 5 files changed, 143 insertions(+), 113 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:28:56.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:05.000000000 +0200
@@ -502,10 +502,6 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	spin_lock_init(&adapter->req_list_lock);
 
-	spin_lock_init(&adapter->hba_dbf_lock);
-	spin_lock_init(&adapter->san_dbf_lock);
-	spin_lock_init(&adapter->scsi_dbf_lock);
-	spin_lock_init(&adapter->rec_dbf_lock);
 	spin_lock_init(&adapter->req_q_lock);
 	spin_lock_init(&adapter->qdio_stat_lock);
 
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-08-17 11:29:05.000000000 +0200
@@ -3,7 +3,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -11,6 +11,7 @@
 
 #include <linux/ctype.h>
 #include <asm/debug.h>
+#include "zfcp_dbf.h"
 #include "zfcp_ext.h"
 
 static u32 dbfsize = 4;
@@ -126,6 +127,7 @@ static int zfcp_dbf_view_header(debug_in
 void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *fsf_req)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
+	struct zfcp_dbf *dbf = adapter->dbf;
 	struct fsf_qtcb *qtcb = fsf_req->qtcb;
 	union fsf_prot_status_qual *prot_status_qual =
 					&qtcb->prefix.prot_status_qual;
@@ -134,12 +136,12 @@ void zfcp_hba_dbf_event_fsf_response(str
 	struct zfcp_port *port;
 	struct zfcp_unit *unit;
 	struct zfcp_send_els *send_els;
-	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
 	struct zfcp_hba_dbf_record_response *response = &rec->u.response;
 	int level;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "resp", ZFCP_DBF_TAG_SIZE);
 
@@ -224,7 +226,7 @@ void zfcp_hba_dbf_event_fsf_response(str
 		break;
 	}
 
-	debug_event(adapter->hba_dbf, level, rec, sizeof(*rec));
+	debug_event(dbf->hba_dbf, level, rec, sizeof(*rec));
 
 	/* have fcp channel microcode fixed to use as little as possible */
 	if (fsf_req->fsf_command != FSF_QTCB_FCP_CMND) {
@@ -232,11 +234,11 @@ void zfcp_hba_dbf_event_fsf_response(str
 		char *buf = (char *)qtcb + qtcb->header.log_start;
 		int len = qtcb->header.log_length;
 		for (; len && !buf[len - 1]; len--);
-		zfcp_dbf_hexdump(adapter->hba_dbf, rec, sizeof(*rec), level,
-				 buf, len);
+		zfcp_dbf_hexdump(dbf->hba_dbf, rec, sizeof(*rec), level, buf,
+				 len);
 	}
 
-	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 
 /**
@@ -248,10 +250,11 @@ void zfcp_hba_dbf_event_fsf_response(str
 void zfcp_hba_dbf_event_fsf_unsol(const char *tag, struct zfcp_adapter *adapter,
 				  struct fsf_status_read_buffer *status_buffer)
 {
-	struct zfcp_hba_dbf_record *rec = &adapter->hba_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_hba_dbf_record *rec = &dbf->hba_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, "stat", ZFCP_DBF_TAG_SIZE);
 	strncpy(rec->tag2, tag, ZFCP_DBF_TAG_SIZE);
@@ -293,8 +296,8 @@ void zfcp_hba_dbf_event_fsf_unsol(const 
 		       &status_buffer->payload, rec->u.status.payload_size);
 	}
 
-	debug_event(adapter->hba_dbf, 2, rec, sizeof(*rec));
-	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+	debug_event(dbf->hba_dbf, 2, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 
 /**
@@ -308,17 +311,18 @@ void zfcp_hba_dbf_event_qdio(struct zfcp
 			     unsigned int qdio_error, int sbal_index,
 			     int sbal_count)
 {
-	struct zfcp_hba_dbf_record *r = &adapter->hba_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_hba_dbf_record *r = &dbf->hba_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "qdio", ZFCP_DBF_TAG_SIZE);
 	r->u.qdio.qdio_error = qdio_error;
 	r->u.qdio.sbal_index = sbal_index;
 	r->u.qdio.sbal_count = sbal_count;
-	debug_event(adapter->hba_dbf, 0, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+	debug_event(dbf->hba_dbf, 0, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 
 /**
@@ -329,17 +333,18 @@ void zfcp_hba_dbf_event_qdio(struct zfcp
 void zfcp_hba_dbf_event_berr(struct zfcp_adapter *adapter,
 			     struct zfcp_fsf_req *req)
 {
-	struct zfcp_hba_dbf_record *r = &adapter->hba_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_hba_dbf_record *r = &dbf->hba_dbf_buf;
 	struct fsf_status_read_buffer *sr_buf = req->data;
 	struct fsf_bit_error_payload *err = &sr_buf->payload.bit_error;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->hba_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->hba_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "berr", ZFCP_DBF_TAG_SIZE);
 	memcpy(&r->u.berr, err, sizeof(struct fsf_bit_error_payload));
-	debug_event(adapter->hba_dbf, 0, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->hba_dbf_lock, flags);
+	debug_event(dbf->hba_dbf, 0, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->hba_dbf_lock, flags);
 }
 static void zfcp_hba_dbf_view_response(char **p,
 				       struct zfcp_hba_dbf_record_response *r)
@@ -554,7 +559,8 @@ static struct debug_view zfcp_rec_dbf_vi
  */
 void zfcp_rec_dbf_event_thread(char *id2, struct zfcp_adapter *adapter)
 {
-	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
 	unsigned long flags = 0;
 	struct list_head *entry;
 	unsigned ready = 0, running = 0, total;
@@ -565,15 +571,15 @@ void zfcp_rec_dbf_event_thread(char *id2
 		running++;
 	total = adapter->erp_total_count;
 
-	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_THREAD;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.thread.total = total;
 	r->u.thread.ready = ready;
 	r->u.thread.running = running;
-	debug_event(adapter->rec_dbf, 6, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+	debug_event(dbf->rec_dbf, 6, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
 }
 
 /**
@@ -596,10 +602,11 @@ static void zfcp_rec_dbf_event_target(ch
 				      atomic_t *status, atomic_t *erp_count,
 				      u64 wwpn, u32 d_id, u64 fcp_lun)
 {
-	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TARGET;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -609,8 +616,8 @@ static void zfcp_rec_dbf_event_target(ch
 	r->u.target.d_id = d_id;
 	r->u.target.fcp_lun = fcp_lun;
 	r->u.target.erp_count = atomic_read(erp_count);
-	debug_event(adapter->rec_dbf, 3, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+	debug_event(dbf->rec_dbf, 3, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
 }
 
 /**
@@ -672,10 +679,11 @@ void zfcp_rec_dbf_event_trigger(char *id
 				void *action, struct zfcp_adapter *adapter,
 				struct zfcp_port *port, struct zfcp_unit *unit)
 {
-	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TRIGGER;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -692,8 +700,8 @@ void zfcp_rec_dbf_event_trigger(char *id
 		r->u.trigger.us = atomic_read(&unit->status);
 		r->u.trigger.fcp_lun = unit->fcp_lun;
 	}
-	debug_event(adapter->rec_dbf, action ? 1 : 4, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+	debug_event(dbf->rec_dbf, action ? 1 : 4, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
 }
 
 /**
@@ -704,10 +712,11 @@ void zfcp_rec_dbf_event_trigger(char *id
 void zfcp_rec_dbf_event_action(char *id2, struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
-	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_rec_dbf_record *r = &dbf->rec_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_ACTION;
 	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
@@ -715,8 +724,8 @@ void zfcp_rec_dbf_event_action(char *id2
 	r->u.action.status = erp_action->status;
 	r->u.action.step = erp_action->step;
 	r->u.action.fsf_req = (unsigned long)erp_action->fsf_req;
-	debug_event(adapter->rec_dbf, 5, r, sizeof(*r));
-	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+	debug_event(dbf->rec_dbf, 5, r, sizeof(*r));
+	spin_unlock_irqrestore(&dbf->rec_dbf_lock, flags);
 }
 
 /**
@@ -728,13 +737,14 @@ void zfcp_san_dbf_event_ct_request(struc
 	struct zfcp_send_ct *ct = (struct zfcp_send_ct *)fsf_req->data;
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
+	struct zfcp_dbf *dbf = adapter->dbf;
 	struct ct_hdr *hdr = sg_virt(ct->req);
-	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
+	struct zfcp_san_dbf_record *r = &dbf->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_request *oct = &r->u.ct_req;
 	int level = 3;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "octc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
@@ -749,10 +759,10 @@ void zfcp_san_dbf_event_ct_request(struc
 	oct->max_res_size = hdr->max_res_size;
 	oct->len = min((int)ct->req->length - (int)sizeof(struct ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(adapter->san_dbf, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+	debug_event(dbf->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(dbf->san_dbf, r, sizeof(*r), level,
 			 (void *)hdr + sizeof(struct ct_hdr), oct->len);
-	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
 }
 
 /**
@@ -765,12 +775,13 @@ void zfcp_san_dbf_event_ct_response(stru
 	struct zfcp_wka_port *wka_port = ct->wka_port;
 	struct zfcp_adapter *adapter = wka_port->adapter;
 	struct ct_hdr *hdr = sg_virt(ct->resp);
-	struct zfcp_san_dbf_record *r = &adapter->san_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_san_dbf_record *r = &dbf->san_dbf_buf;
 	struct zfcp_san_dbf_record_ct_response *rct = &r->u.ct_resp;
 	int level = 3;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	strncpy(r->tag, "rctc", ZFCP_DBF_TAG_SIZE);
 	r->fsf_reqid = fsf_req->req_id;
@@ -785,10 +796,10 @@ void zfcp_san_dbf_event_ct_response(stru
 	rct->max_res_size = hdr->max_res_size;
 	rct->len = min((int)ct->resp->length - (int)sizeof(struct ct_hdr),
 		       ZFCP_DBF_SAN_MAX_PAYLOAD);
-	debug_event(adapter->san_dbf, level, r, sizeof(*r));
-	zfcp_dbf_hexdump(adapter->san_dbf, r, sizeof(*r), level,
+	debug_event(dbf->san_dbf, level, r, sizeof(*r));
+	zfcp_dbf_hexdump(dbf->san_dbf, r, sizeof(*r), level,
 			 (void *)hdr + sizeof(struct ct_hdr), rct->len);
-	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
 }
 
 static void zfcp_san_dbf_event_els(const char *tag, int level,
@@ -797,10 +808,11 @@ static void zfcp_san_dbf_event_els(const
 				   int buflen)
 {
 	struct zfcp_adapter *adapter = fsf_req->adapter;
-	struct zfcp_san_dbf_record *rec = &adapter->san_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_san_dbf_record *rec = &dbf->san_dbf_buf;
 	unsigned long flags;
 
-	spin_lock_irqsave(&adapter->san_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->san_dbf_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 	strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
 	rec->fsf_reqid = fsf_req->req_id;
@@ -808,10 +820,10 @@ static void zfcp_san_dbf_event_els(const
 	rec->s_id = s_id;
 	rec->d_id = d_id;
 	rec->u.els.ls_code = ls_code;
-	debug_event(adapter->san_dbf, level, rec, sizeof(*rec));
-	zfcp_dbf_hexdump(adapter->san_dbf, rec, sizeof(*rec), level,
+	debug_event(dbf->san_dbf, level, rec, sizeof(*rec));
+	zfcp_dbf_hexdump(dbf->san_dbf, rec, sizeof(*rec), level,
 			 buffer, min(buflen, ZFCP_DBF_SAN_MAX_PAYLOAD));
-	spin_unlock_irqrestore(&adapter->san_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->san_dbf_lock, flags);
 }
 
 /**
@@ -915,14 +927,15 @@ static void zfcp_scsi_dbf_event(const ch
 				struct zfcp_fsf_req *fsf_req,
 				unsigned long old_req_id)
 {
-	struct zfcp_scsi_dbf_record *rec = &adapter->scsi_dbf_buf;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_scsi_dbf_record *rec = &dbf->scsi_dbf_buf;
 	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
 	unsigned long flags;
 	struct fcp_rsp_iu *fcp_rsp;
 	char *fcp_rsp_info = NULL, *fcp_sns_info = NULL;
 	int offset = 0, buflen = 0;
 
-	spin_lock_irqsave(&adapter->scsi_dbf_lock, flags);
+	spin_lock_irqsave(&dbf->scsi_dbf_lock, flags);
 	do {
 		memset(rec, 0, sizeof(*rec));
 		if (offset == 0) {
@@ -981,9 +994,9 @@ static void zfcp_scsi_dbf_event(const ch
 			memcpy(dump->data, fcp_sns_info + offset, dump->size);
 			offset += dump->size;
 		}
-		debug_event(adapter->scsi_dbf, level, rec, sizeof(*rec));
+		debug_event(dbf->scsi_dbf, level, rec, sizeof(*rec));
 	} while (offset < buflen);
-	spin_unlock_irqrestore(&adapter->scsi_dbf_lock, flags);
+	spin_unlock_irqrestore(&dbf->scsi_dbf_lock, flags);
 }
 
 /**
@@ -1087,6 +1100,22 @@ static struct debug_view zfcp_scsi_dbf_v
 	NULL
 };
 
+static debug_info_t *zfcp_dbf_reg(const char *name, int level,
+				  struct debug_view *view, int size)
+{
+	struct debug_info *d;
+
+	d = debug_register(name, dbfsize, level, size);
+	if (!d)
+		return NULL;
+
+	debug_register_view(d, &debug_hex_ascii_view);
+	debug_register_view(d, view);
+	debug_set_level(d, level);
+
+	return d;
+}
+
 /**
  * zfcp_adapter_debug_register - registers debug feature for an adapter
  * @adapter: pointer to adapter for which debug features should be registered
@@ -1095,52 +1124,56 @@ static struct debug_view zfcp_scsi_dbf_v
 int zfcp_adapter_debug_register(struct zfcp_adapter *adapter)
 {
 	char dbf_name[DEBUG_MAX_NAME_LEN];
+	struct zfcp_dbf *dbf;
+
+	dbf = kmalloc(sizeof(struct zfcp_dbf), GFP_KERNEL);
+	if (!dbf)
+		return -ENOMEM;
+
+	spin_lock_init(&dbf->hba_dbf_lock);
+	spin_lock_init(&dbf->san_dbf_lock);
+	spin_lock_init(&dbf->scsi_dbf_lock);
+	spin_lock_init(&dbf->rec_dbf_lock);
 
 	/* debug feature area which records recovery activity */
 	sprintf(dbf_name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
-	adapter->rec_dbf = debug_register(dbf_name, dbfsize, 1,
-					  sizeof(struct zfcp_rec_dbf_record));
-	if (!adapter->rec_dbf)
-		goto failed;
-	debug_register_view(adapter->rec_dbf, &debug_hex_ascii_view);
-	debug_register_view(adapter->rec_dbf, &zfcp_rec_dbf_view);
-	debug_set_level(adapter->rec_dbf, 3);
+	dbf->rec_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_rec_dbf_view,
+				    sizeof(struct zfcp_rec_dbf_record));
+	if (!dbf->rec_dbf)
+		goto fail_rec;
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
 	sprintf(dbf_name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
-	adapter->hba_dbf = debug_register(dbf_name, dbfsize, 1,
-					  sizeof(struct zfcp_hba_dbf_record));
-	if (!adapter->hba_dbf)
-		goto failed;
-	debug_register_view(adapter->hba_dbf, &debug_hex_ascii_view);
-	debug_register_view(adapter->hba_dbf, &zfcp_hba_dbf_view);
-	debug_set_level(adapter->hba_dbf, 3);
+	dbf->hba_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_hba_dbf_view,
+				    sizeof(struct zfcp_hba_dbf_record));
+	if (!dbf->hba_dbf)
+		goto fail_hba;
 
 	/* debug feature area which records SAN command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
-	adapter->san_dbf = debug_register(dbf_name, dbfsize, 1,
-					  sizeof(struct zfcp_san_dbf_record));
-	if (!adapter->san_dbf)
-		goto failed;
-	debug_register_view(adapter->san_dbf, &debug_hex_ascii_view);
-	debug_register_view(adapter->san_dbf, &zfcp_san_dbf_view);
-	debug_set_level(adapter->san_dbf, 6);
+	dbf->san_dbf = zfcp_dbf_reg(dbf_name, 6, &zfcp_san_dbf_view,
+				    sizeof(struct zfcp_san_dbf_record));
+	if (!dbf->san_dbf)
+		goto fail_san;
 
 	/* debug feature area which records SCSI command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
-	adapter->scsi_dbf = debug_register(dbf_name, dbfsize, 1,
-					   sizeof(struct zfcp_scsi_dbf_record));
-	if (!adapter->scsi_dbf)
-		goto failed;
-	debug_register_view(adapter->scsi_dbf, &debug_hex_ascii_view);
-	debug_register_view(adapter->scsi_dbf, &zfcp_scsi_dbf_view);
-	debug_set_level(adapter->scsi_dbf, 3);
+	dbf->scsi_dbf = zfcp_dbf_reg(dbf_name, 3, &zfcp_scsi_dbf_view,
+				     sizeof(struct zfcp_scsi_dbf_record));
+	if (!dbf->scsi_dbf)
+		goto fail_scsi;
 
+	adapter->dbf = dbf;
 	return 0;
 
- failed:
-	zfcp_adapter_debug_unregister(adapter);
-
+fail_scsi:
+	debug_unregister(dbf->san_dbf);
+fail_san:
+	debug_unregister(dbf->hba_dbf);
+fail_hba:
+	debug_unregister(dbf->rec_dbf);
+fail_rec:
+	kfree(dbf);
 	return -ENOMEM;
 }
 
@@ -1150,12 +1183,10 @@ int zfcp_adapter_debug_register(struct z
  */
 void zfcp_adapter_debug_unregister(struct zfcp_adapter *adapter)
 {
-	debug_unregister(adapter->scsi_dbf);
-	debug_unregister(adapter->san_dbf);
-	debug_unregister(adapter->hba_dbf);
-	debug_unregister(adapter->rec_dbf);
-	adapter->scsi_dbf = NULL;
-	adapter->san_dbf = NULL;
-	adapter->hba_dbf = NULL;
-	adapter->rec_dbf = NULL;
+	debug_unregister(adapter->dbf->scsi_dbf);
+	debug_unregister(adapter->dbf->san_dbf);
+	debug_unregister(adapter->dbf->hba_dbf);
+	debug_unregister(adapter->dbf->rec_dbf);
+	kfree(adapter->dbf);
+	adapter->dbf = NULL;
 }
--- a/drivers/s390/scsi/zfcp_dbf.h	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.h	2009-08-17 11:29:05.000000000 +0200
@@ -2,7 +2,7 @@
  * This file is part of the zfcp device driver for
  * FCP adapters for IBM System z9 and zSeries.
  *
- * Copyright IBM Corp. 2008, 2008
+ * Copyright IBM Corp. 2008, 2009
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -222,4 +222,19 @@ struct zfcp_scsi_dbf_record {
 	u8 sns_info[ZFCP_DBF_SCSI_FCP_SNS_INFO];
 } __attribute__ ((packed));
 
+struct zfcp_dbf {
+	debug_info_t			*rec_dbf;
+	debug_info_t			*hba_dbf;
+	debug_info_t			*san_dbf;
+	debug_info_t			*scsi_dbf;
+	spinlock_t			rec_dbf_lock;
+	spinlock_t			hba_dbf_lock;
+	spinlock_t			san_dbf_lock;
+	spinlock_t			scsi_dbf_lock;
+	struct zfcp_rec_dbf_record	rec_dbf_buf;
+	struct zfcp_hba_dbf_record	hba_dbf_buf;
+	struct zfcp_san_dbf_record	san_dbf_buf;
+	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
+};
+
 #endif /* ZFCP_DBF_H */
--- a/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-08-17 11:29:05.000000000 +0200
@@ -37,10 +37,8 @@
 #include <asm/debug.h>
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
-#include "zfcp_dbf.h"
 #include "zfcp_fsf.h"
 
-
 /********************* GENERAL DEFINES *********************************/
 
 #define REQUEST_LIST_SIZE 128
@@ -468,18 +466,7 @@ struct zfcp_adapter {
 	u32			erp_low_mem_count; /* nr of erp actions waiting
 						      for memory */
 	struct zfcp_wka_ports	*gs;		   /* generic services */
-	debug_info_t		*rec_dbf;
-	debug_info_t		*hba_dbf;
-	debug_info_t		*san_dbf;          /* debug feature areas */
-	debug_info_t		*scsi_dbf;
-	spinlock_t		rec_dbf_lock;
-	spinlock_t		hba_dbf_lock;
-	spinlock_t		san_dbf_lock;
-	spinlock_t		scsi_dbf_lock;
-	struct zfcp_rec_dbf_record	rec_dbf_buf;
-	struct zfcp_hba_dbf_record	hba_dbf_buf;
-	struct zfcp_san_dbf_record	san_dbf_buf;
-	struct zfcp_scsi_dbf_record	scsi_dbf_buf;
+	struct zfcp_dbf		*dbf;		   /* debug traces */
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
 	struct fc_host_statistics *fc_stats;
--- a/drivers/s390/scsi/zfcp_fsf.h	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.h	2009-08-17 11:29:05.000000000 +0200
@@ -3,13 +3,14 @@
  *
  * Interface to the FSF support functions.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #ifndef FSF_H
 #define FSF_H
 
 #include <linux/pfn.h>
+#include <linux/scatterlist.h>
 
 #define FSF_QTCB_CURRENT_VERSION		0x00000001
 

