From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/7] zfcp: Redesign of the debug tracing for SCSI records.
Date: Thu, 02 Dec 2010 15:16:15 +0100
Message-ID: <20101202141919.254972067@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57260 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab0LBOTX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:23 -0500
Content-Disposition: inline; filename=704-zfcp-debug-tracing-scsi.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

This patch is the continuation to redesign the zfcp tracing to a more
straight-forward and easy to extend scheme.

This patch deals with all trace records of the zfcp SCSI area.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c  |  232 ++++++++----------------------------------
 drivers/s390/scsi/zfcp_dbf.h  |  129 ++++++++++++-----------
 drivers/s390/scsi/zfcp_ext.h  |    4 
 drivers/s390/scsi/zfcp_fsf.c  |    2 
 drivers/s390/scsi/zfcp_scsi.c |   30 ++---
 5 files changed, 132 insertions(+), 265 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -3,7 +3,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -52,70 +52,6 @@ void zfcp_dbf_pl_write(struct zfcp_dbf *
 	spin_unlock(&dbf->pay_lock);
 }
 
-static void zfcp_dbf_tag(char **p, const char *label, const char *tag)
-{
-	int i;
-
-	*p += sprintf(*p, "%-24s", label);
-	for (i = 0; i < ZFCP_DBF_TAG_SIZE; i++)
-		*p += sprintf(*p, "%c", tag[i]);
-	*p += sprintf(*p, "\n");
-}
-
-static void zfcp_dbf_out(char **buf, const char *s, const char *format, ...)
-{
-	va_list arg;
-
-	*buf += sprintf(*buf, "%-24s", s);
-	va_start(arg, format);
-	*buf += vsprintf(*buf, format, arg);
-	va_end(arg);
-	*buf += sprintf(*buf, "\n");
-}
-
-static void zfcp_dbf_outd(char **p, const char *label, char *buffer,
-			  int buflen, int offset, int total_size)
-{
-	if (!offset)
-		*p += sprintf(*p, "%-24s  ", label);
-	while (buflen--) {
-		if (offset > 0) {
-			if ((offset % 32) == 0)
-				*p += sprintf(*p, "\n%-24c  ", ' ');
-			else if ((offset % 4) == 0)
-				*p += sprintf(*p, " ");
-		}
-		*p += sprintf(*p, "%02x", *buffer++);
-		if (++offset == total_size) {
-			*p += sprintf(*p, "\n");
-			break;
-		}
-	}
-	if (!total_size)
-		*p += sprintf(*p, "\n");
-}
-
-static int zfcp_dbf_view_header(debug_info_t *id, struct debug_view *view,
-				int area, debug_entry_t *entry, char *out_buf)
-{
-	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)DEBUG_DATA(entry);
-	struct timespec t;
-	char *p = out_buf;
-
-	if (strncmp(dump->tag, "dump", ZFCP_DBF_TAG_SIZE) != 0) {
-		stck_to_timespec(entry->id.stck, &t);
-		zfcp_dbf_out(&p, "timestamp", "%011lu:%06lu",
-			     t.tv_sec, t.tv_nsec);
-		zfcp_dbf_out(&p, "cpu", "%02i", entry->id.fields.cpuid);
-	} else	{
-		zfcp_dbf_outd(&p, "", dump->data, dump->size, dump->offset,
-			      dump->total_size);
-		if ((dump->offset + dump->size) == dump->total_size)
-			p += sprintf(p, "\n");
-	}
-	return p - out_buf;
-}
-
 /**
  * zfcp_dbf_hba_fsf_res - trace event for fsf responses
  * @tag: tag indicating which kind of unsolicited status has been received
@@ -393,131 +329,57 @@ void zfcp_dbf_san_in_els(char *tag, stru
 		     fsf->req_id, ntoh24(srb->d_id));
 }
 
-void _zfcp_dbf_scsi(const char *tag, const char *tag2, int level,
-		    struct zfcp_dbf *dbf, struct scsi_cmnd *scsi_cmnd,
-		    struct zfcp_fsf_req *fsf_req, unsigned long old_req_id)
+/**
+ * zfcp_dbf_scsi - trace event for scsi commands
+ * @tag: identifier for event
+ * @sc: pointer to struct scsi_cmnd
+ * @fsf: pointer to struct zfcp_fsf_req
+ */
+void zfcp_dbf_scsi(char *tag, struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf)
 {
-	struct zfcp_dbf_scsi_record *rec = &dbf->scsi_buf;
-	struct zfcp_dbf_dump *dump = (struct zfcp_dbf_dump *)rec;
-	unsigned long flags;
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *) sc->device->host->hostdata[0];
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_dbf_scsi *rec = &dbf->scsi_buf;
 	struct fcp_resp_with_ext *fcp_rsp;
-	struct fcp_resp_rsp_info *fcp_rsp_info = NULL;
-	char *fcp_sns_info = NULL;
-	int offset = 0, buflen = 0;
+	struct fcp_resp_rsp_info *fcp_rsp_info;
+	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->scsi_lock, flags);
-	do {
-		memset(rec, 0, sizeof(*rec));
-		if (offset == 0) {
-			strncpy(rec->tag, tag, ZFCP_DBF_TAG_SIZE);
-			strncpy(rec->tag2, tag2, ZFCP_DBF_TAG_SIZE);
-			if (scsi_cmnd != NULL) {
-				if (scsi_cmnd->device) {
-					rec->scsi_id = scsi_cmnd->device->id;
-					rec->scsi_lun = scsi_cmnd->device->lun;
-				}
-				rec->scsi_result = scsi_cmnd->result;
-				rec->scsi_cmnd = (unsigned long)scsi_cmnd;
-				memcpy(rec->scsi_opcode, scsi_cmnd->cmnd,
-					min((int)scsi_cmnd->cmd_len,
-						ZFCP_DBF_SCSI_OPCODE));
-				rec->scsi_retries = scsi_cmnd->retries;
-				rec->scsi_allowed = scsi_cmnd->allowed;
-			}
-			if (fsf_req != NULL) {
-				fcp_rsp = (struct fcp_resp_with_ext *)
-					&(fsf_req->qtcb->bottom.io.fcp_rsp);
-				fcp_rsp_info = (struct fcp_resp_rsp_info *)
-					&fcp_rsp[1];
-				fcp_sns_info = (char *) &fcp_rsp[1];
-				if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL)
-					fcp_sns_info += fcp_rsp->ext.fr_sns_len;
-
-				rec->rsp_validity = fcp_rsp->resp.fr_flags;
-				rec->rsp_scsi_status = fcp_rsp->resp.fr_status;
-				rec->rsp_resid = fcp_rsp->ext.fr_resid;
-				if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL)
-					rec->rsp_code = fcp_rsp_info->rsp_code;
-				if (fcp_rsp->resp.fr_flags & FCP_SNS_LEN_VAL) {
-					buflen = min(fcp_rsp->ext.fr_sns_len,
-					   (u32)ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO);
-					rec->sns_info_len = buflen;
-					memcpy(rec->sns_info, fcp_sns_info,
-					       min(buflen,
-						   ZFCP_DBF_SCSI_FCP_SNS_INFO));
-					offset += min(buflen,
-						      ZFCP_DBF_SCSI_FCP_SNS_INFO);
-				}
-
-				rec->fsf_reqid = fsf_req->req_id;
-				rec->fsf_seqno = fsf_req->seq_no;
-				rec->fsf_issued = fsf_req->issued;
-			}
-			rec->old_fsf_reqid = old_req_id;
-		} else {
-			strncpy(dump->tag, "dump", ZFCP_DBF_TAG_SIZE);
-			dump->total_size = buflen;
-			dump->offset = offset;
-			dump->size = min(buflen - offset,
-					 (int)sizeof(struct
-						     zfcp_dbf_scsi_record) -
-					 (int)sizeof(struct zfcp_dbf_dump));
-			memcpy(dump->data, fcp_sns_info + offset, dump->size);
-			offset += dump->size;
-		}
-		debug_event(dbf->scsi, level, rec, sizeof(*rec));
-	} while (offset < buflen);
-	spin_unlock_irqrestore(&dbf->scsi_lock, flags);
-}
+	memset(rec, 0, sizeof(*rec));
 
-static int zfcp_dbf_scsi_view_format(debug_info_t *id, struct debug_view *view,
-				     char *out_buf, const char *in_buf)
-{
-	struct zfcp_dbf_scsi_record *r = (struct zfcp_dbf_scsi_record *)in_buf;
-	struct timespec t;
-	char *p = out_buf;
-
-	if (strncmp(r->tag, "dump", ZFCP_DBF_TAG_SIZE) == 0)
-		return 0;
-
-	zfcp_dbf_tag(&p, "tag", r->tag);
-	zfcp_dbf_tag(&p, "tag2", r->tag2);
-	zfcp_dbf_out(&p, "scsi_id", "0x%08x", r->scsi_id);
-	zfcp_dbf_out(&p, "scsi_lun", "0x%08x", r->scsi_lun);
-	zfcp_dbf_out(&p, "scsi_result", "0x%08x", r->scsi_result);
-	zfcp_dbf_out(&p, "scsi_cmnd", "0x%0Lx", r->scsi_cmnd);
-	zfcp_dbf_outd(&p, "scsi_opcode", r->scsi_opcode, ZFCP_DBF_SCSI_OPCODE,
-		      0, ZFCP_DBF_SCSI_OPCODE);
-	zfcp_dbf_out(&p, "scsi_retries", "0x%02x", r->scsi_retries);
-	zfcp_dbf_out(&p, "scsi_allowed", "0x%02x", r->scsi_allowed);
-	if (strncmp(r->tag, "abrt", ZFCP_DBF_TAG_SIZE) == 0)
-		zfcp_dbf_out(&p, "old_fsf_reqid", "0x%0Lx", r->old_fsf_reqid);
-	zfcp_dbf_out(&p, "fsf_reqid", "0x%0Lx", r->fsf_reqid);
-	zfcp_dbf_out(&p, "fsf_seqno", "0x%08x", r->fsf_seqno);
-	stck_to_timespec(r->fsf_issued, &t);
-	zfcp_dbf_out(&p, "fsf_issued", "%011lu:%06lu", t.tv_sec, t.tv_nsec);
-
-	if (strncmp(r->tag, "rslt", ZFCP_DBF_TAG_SIZE) == 0) {
-		zfcp_dbf_out(&p, "fcp_rsp_validity", "0x%02x", r->rsp_validity);
-		zfcp_dbf_out(&p, "fcp_rsp_scsi_status", "0x%02x",
-			     r->rsp_scsi_status);
-		zfcp_dbf_out(&p, "fcp_rsp_resid", "0x%08x", r->rsp_resid);
-		zfcp_dbf_out(&p, "fcp_rsp_code", "0x%08x", r->rsp_code);
-		zfcp_dbf_out(&p, "fcp_sns_info_len", "0x%08x", r->sns_info_len);
-		zfcp_dbf_outd(&p, "fcp_sns_info", r->sns_info,
-			      min((int)r->sns_info_len,
-			      ZFCP_DBF_SCSI_FCP_SNS_INFO), 0,
-			      r->sns_info_len);
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->id = ZFCP_DBF_SCSI_CMND;
+	rec->scsi_result = sc->result;
+	rec->scsi_retries = sc->retries;
+	rec->scsi_allowed = sc->allowed;
+	rec->scsi_id = sc->device->id;
+	rec->scsi_lun = sc->device->lun;
+	rec->host_scribble = (unsigned long)sc->host_scribble;
+
+	memcpy(rec->scsi_opcode, sc->cmnd,
+	       min((int)sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
+
+	if (fsf) {
+		rec->fsf_req_id = fsf->req_id;
+		fcp_rsp = (struct fcp_resp_with_ext *)
+				&(fsf->qtcb->bottom.io.fcp_rsp);
+		memcpy(&rec->fcp_rsp, fcp_rsp, FCP_RESP_WITH_EXT);
+		if (fcp_rsp->resp.fr_flags & FCP_RSP_LEN_VAL) {
+			fcp_rsp_info = (struct fcp_resp_rsp_info *) &fcp_rsp[1];
+			rec->fcp_rsp_info = fcp_rsp_info->rsp_code;
+		}
+		if (fcp_rsp->resp.fr_flags & FCP_SNS_LEN_VAL) {
+			rec->pl_len = min((u16)SCSI_SENSE_BUFFERSIZE,
+					  (u16)ZFCP_DBF_PAY_MAX_REC);
+			zfcp_dbf_pl_write(dbf, sc->sense_buffer, rec->pl_len,
+					  "fcp_sns", fsf->req_id);
+		}
 	}
-	p += sprintf(p, "\n");
-	return p - out_buf;
-}
 
-static struct debug_view zfcp_dbf_scsi_view = {
-	.name = "structured",
-	.header_proc = zfcp_dbf_view_header,
-	.format_proc = zfcp_dbf_scsi_view_format,
-};
+	debug_event(adapter->dbf->scsi, 1, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->scsi_lock, flags);
+}
 
 static debug_info_t *zfcp_dbf_reg(const char *name, int level,
 				  struct debug_view *view, int size)
@@ -584,8 +446,8 @@ int zfcp_dbf_adapter_register(struct zfc
 
 	/* debug feature area which records SCSI command failures and recovery */
 	sprintf(dbf_name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
-	dbf->scsi = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_scsi_view,
-				 sizeof(struct zfcp_dbf_scsi_record));
+	dbf->scsi = zfcp_dbf_reg(dbf_name, 3, NULL,
+				 sizeof(struct zfcp_dbf_scsi));
 	if (!dbf->scsi)
 		goto err_out;
 
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -19,14 +19,6 @@
 
 #define ZFCP_DBF_INVALID_LUN	0xFFFFFFFFFFFFFFFFull
 
-struct zfcp_dbf_dump {
-	u8 tag[ZFCP_DBF_TAG_SIZE];
-	u32 total_size;		/* size of total dump data */
-	u32 offset;		/* how much data has being already dumped */
-	u32 size;		/* how much data comes with this record */
-	u8 data[];		/* dump data */
-} __attribute__ ((packed));
-
 /**
  * struct zfcp_dbf_rec_trigger - trace record for triggered recovery action
  * @ready: number of ready recovery actions
@@ -193,6 +185,47 @@ struct zfcp_dbf_hba {
 } __packed;
 
 /**
+ * enum zfcp_dbf_scsi_id - scsi trace record identifier
+ * @ZFCP_DBF_SCSI_CMND: scsi command trace record
+ */
+enum zfcp_dbf_scsi_id {
+	ZFCP_DBF_SCSI_CMND	= 1,
+};
+
+/**
+ * struct zfcp_dbf_scsi - common trace record for SCSI records
+ * @id: unique number of recovery record type
+ * @tag: identifier string specifying the location of initiation
+ * @scsi_id: scsi device id
+ * @scsi_lun: scsi device logical unit number
+ * @scsi_result: scsi result
+ * @scsi_retries: current retry number of scsi request
+ * @scsi_allowed: allowed retries
+ * @fcp_rsp_info: FCP response info
+ * @scsi_opcode: scsi opcode
+ * @fsf_req_id: request id of fsf request
+ * @host_scribble: LLD specific data attached to SCSI request
+ * @pl_len: length of paload stored as zfcp_dbf_pay
+ * @fsf_rsp: response for fsf request
+ */
+struct zfcp_dbf_scsi {
+	u8 id;
+	char tag[ZFCP_DBF_TAG_LEN];
+	u32 scsi_id;
+	u32 scsi_lun;
+	u32 scsi_result;
+	u8 scsi_retries;
+	u8 scsi_allowed;
+	u8 fcp_rsp_info;
+#define ZFCP_DBF_SCSI_OPCODE	16
+	u8 scsi_opcode[ZFCP_DBF_SCSI_OPCODE];
+	u64 fsf_req_id;
+	u64 host_scribble;
+	u16 pl_len;
+	struct fcp_resp_with_ext fcp_rsp;
+} __packed;
+
+/**
  * struct zfcp_dbf_pay - trace record for unformatted payload information
  * @area: area this record is originated from
  * @counter: ascending record number
@@ -207,31 +240,6 @@ struct zfcp_dbf_pay {
 	char data[ZFCP_DBF_PAY_MAX_REC];
 } __packed;
 
-struct zfcp_dbf_scsi_record {
-	u8 tag[ZFCP_DBF_TAG_SIZE];
-	u8 tag2[ZFCP_DBF_TAG_SIZE];
-	u32 scsi_id;
-	u32 scsi_lun;
-	u32 scsi_result;
-	u64 scsi_cmnd;
-#define ZFCP_DBF_SCSI_OPCODE	16
-	u8 scsi_opcode[ZFCP_DBF_SCSI_OPCODE];
-	u8 scsi_retries;
-	u8 scsi_allowed;
-	u64 fsf_reqid;
-	u32 fsf_seqno;
-	u64 fsf_issued;
-	u64 old_fsf_reqid;
-	u8 rsp_validity;
-	u8 rsp_scsi_status;
-	u32 rsp_resid;
-	u8 rsp_code;
-#define ZFCP_DBF_SCSI_FCP_SNS_INFO	16
-#define ZFCP_DBF_SCSI_MAX_FCP_SNS_INFO	256
-	u32 sns_info_len;
-	u8 sns_info[ZFCP_DBF_SCSI_FCP_SNS_INFO];
-} __attribute__ ((packed));
-
 struct zfcp_dbf {
 	debug_info_t			*pay;
 	debug_info_t			*rec;
@@ -246,7 +254,7 @@ struct zfcp_dbf {
 	struct zfcp_dbf_rec		rec_buf;
 	struct zfcp_dbf_hba		hba_buf;
 	struct zfcp_dbf_san		san_buf;
-	struct zfcp_dbf_scsi_record	scsi_buf;
+	struct zfcp_dbf_scsi		scsi_buf;
 	struct zfcp_dbf_pay		pay_buf;
 	struct zfcp_adapter		*adapter;
 };
@@ -260,7 +268,7 @@ void zfcp_dbf_hba_fsf_resp(char *tag, in
 
 /**
  * zfcp_dbf_hba_fsf_response - trace event for request completion
- * @fsf_req: request that has been completed
+ * @req: request that has been completed
  */
 static inline
 void zfcp_dbf_hba_fsf_response(struct zfcp_fsf_req *req)
@@ -287,57 +295,53 @@ void zfcp_dbf_hba_fsf_response(struct zf
 }
 
 static inline
-void zfcp_dbf_scsi(const char *tag, const char *tag2, int level,
-		   struct zfcp_dbf *dbf, struct scsi_cmnd *scmd,
-		   struct zfcp_fsf_req *req, unsigned long old_id)
+void _zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *scmd,
+		   struct zfcp_fsf_req *req)
 {
-	if (level <= dbf->scsi->level)
-		_zfcp_dbf_scsi(tag, tag2, level, dbf, scmd, req, old_id);
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)
+					scmd->device->host->hostdata[0];
+
+	if (level <= adapter->dbf->scsi->level)
+		zfcp_dbf_scsi(tag, scmd, req);
 }
 
 /**
  * zfcp_dbf_scsi_result - trace event for SCSI command completion
- * @dbf: adapter dbf trace
  * @scmd: SCSI command pointer
  * @req: FSF request used to issue SCSI command
  */
 static inline
-void zfcp_dbf_scsi_result(struct zfcp_dbf *dbf, struct scsi_cmnd *scmd,
-			  struct zfcp_fsf_req *req)
+void zfcp_dbf_scsi_result(struct scsi_cmnd *scmd, struct zfcp_fsf_req *req)
 {
 	if (scmd->result != 0)
-		zfcp_dbf_scsi("rslt", "erro", 3, dbf, scmd, req, 0);
+		_zfcp_dbf_scsi("rsl_err", 3, scmd, req);
 	else if (scmd->retries > 0)
-		zfcp_dbf_scsi("rslt", "retr", 4, dbf, scmd, req, 0);
+		_zfcp_dbf_scsi("rsl_ret", 4, scmd, req);
 	else
-		zfcp_dbf_scsi("rslt", "norm", 6, dbf, scmd, req, 0);
+		_zfcp_dbf_scsi("rsl_nor", 6, scmd, req);
 }
 
 /**
  * zfcp_dbf_scsi_fail_send - trace event for failure to send SCSI command
- * @dbf: adapter dbf trace
  * @scmd: SCSI command pointer
  */
 static inline
-void zfcp_dbf_scsi_fail_send(struct zfcp_dbf *dbf, struct scsi_cmnd *scmd)
+void zfcp_dbf_scsi_fail_send(struct scsi_cmnd *scmd)
 {
-	zfcp_dbf_scsi("rslt", "fail", 4, dbf, scmd, NULL, 0);
+	_zfcp_dbf_scsi("rsl_fai", 4, scmd, NULL);
 }
 
 /**
  * zfcp_dbf_scsi_abort - trace event for SCSI command abort
  * @tag: tag indicating success or failure of abort operation
- * @adapter: adapter thas has been used to issue SCSI command to be aborted
  * @scmd: SCSI command to be aborted
- * @new_req: request containing abort (might be NULL)
- * @old_id: identifier of request containg SCSI command to be aborted
+ * @fsf_req: request containing abort (might be NULL)
  */
 static inline
-void zfcp_dbf_scsi_abort(const char *tag, struct zfcp_dbf *dbf,
-			 struct scsi_cmnd *scmd, struct zfcp_fsf_req *new_req,
-			 unsigned long old_id)
+void zfcp_dbf_scsi_abort(char *tag, struct scsi_cmnd *scmd,
+			 struct zfcp_fsf_req *fsf_req)
 {
-	zfcp_dbf_scsi("abrt", tag, 1, dbf, scmd, new_req, old_id);
+	_zfcp_dbf_scsi(tag, 1, scmd, fsf_req);
 }
 
 /**
@@ -347,12 +351,17 @@ void zfcp_dbf_scsi_abort(const char *tag
  * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
  */
 static inline
-void zfcp_dbf_scsi_devreset(const char *tag, struct scsi_cmnd *scmnd, u8 flag)
+void zfcp_dbf_scsi_devreset(char *tag, struct scsi_cmnd *scmnd, u8 flag)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
+	char tmp_tag[ZFCP_DBF_TAG_LEN];
+
+	if (flag == FCP_TMF_TGT_RESET)
+		memcpy(tmp_tag, "tr_", 3);
+	else
+		memcpy(tmp_tag, "lr_", 3);
 
-	zfcp_dbf_scsi(flag == FCP_TMF_TGT_RESET ? "trst" : "lrst", tag, 1,
-		      zfcp_sdev->port->adapter->dbf, scmnd, NULL, 0);
+	memcpy(&tmp_tag[3], tag, 4);
+	_zfcp_dbf_scsi(tmp_tag, 1, scmnd, NULL);
 }
 
 #endif /* ZFCP_DBF_H */
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -56,9 +56,7 @@ extern void zfcp_dbf_hba_berr(struct zfc
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_in_els(char *, struct zfcp_fsf_req *);
-extern void _zfcp_dbf_scsi(const char *, const char *, int, struct zfcp_dbf *,
-			   struct scsi_cmnd *, struct zfcp_fsf_req *,
-			   unsigned long);
+extern void zfcp_dbf_scsi(char *, struct scsi_cmnd *, struct zfcp_fsf_req *);
 
 /* zfcp_erp.c */
 extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2105,7 +2105,7 @@ static void zfcp_fsf_fcp_cmnd_handler(st
 
 skip_fsfstatus:
 	zfcp_fsf_req_trace(req, scpnt);
-	zfcp_dbf_scsi_result(req->adapter->dbf, scpnt, req);
+	zfcp_dbf_scsi_result(scpnt, req);
 
 	scpnt->host_scribble = NULL;
 	(scpnt->scsi_done) (scpnt);
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -68,11 +68,8 @@ static int zfcp_scsi_slave_configure(str
 
 static void zfcp_scsi_command_fail(struct scsi_cmnd *scpnt, int result)
 {
-	struct zfcp_adapter *adapter =
-		(struct zfcp_adapter *) scpnt->device->host->hostdata[0];
-
 	set_host_byte(scpnt, result);
-	zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
+	zfcp_dbf_scsi_fail_send(scpnt);
 	scpnt->scsi_done(scpnt);
 }
 
@@ -80,7 +77,6 @@ static
 int zfcp_scsi_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scpnt)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
 	int    status, scsi_result, ret;
 
@@ -91,7 +87,7 @@ int zfcp_scsi_queuecommand(struct Scsi_H
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
-		zfcp_dbf_scsi_fail_send(adapter->dbf, scpnt);
+		zfcp_dbf_scsi_fail_send(scpnt);
 		scpnt->scsi_done(scpnt);
 		return 0;
 	}
@@ -182,8 +178,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	old_req = zfcp_reqlist_find(adapter->req_list, old_reqid);
 	if (!old_req) {
 		write_unlock_irqrestore(&adapter->abort_lock, flags);
-		zfcp_dbf_scsi_abort("lte1", adapter->dbf, scpnt, NULL,
-				    old_reqid);
+		zfcp_dbf_scsi_abort("abrt_or", scpnt, NULL);
 		return FAILED; /* completion could be in progress */
 	}
 	old_req->data = NULL;
@@ -198,29 +193,32 @@ static int zfcp_scsi_eh_abort_handler(st
 
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
-		if (ret)
+		if (ret) {
+			zfcp_dbf_scsi_abort("abrt_bl", scpnt, NULL);
 			return ret;
+		}
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_dbf_scsi_abort("nres", adapter->dbf, scpnt, NULL,
-					    old_reqid);
+			zfcp_dbf_scsi_abort("abrt_ru", scpnt, NULL);
 			return SUCCESS;
 		}
 	}
-	if (!abrt_req)
+	if (!abrt_req) {
+		zfcp_dbf_scsi_abort("abrt_ar", scpnt, NULL);
 		return FAILED;
+	}
 
 	wait_for_completion(&abrt_req->completion);
 
 	if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTSUCCEEDED)
-		dbf_tag = "okay";
+		dbf_tag = "abrt_ok";
 	else if (abrt_req->status & ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED)
-		dbf_tag = "lte2";
+		dbf_tag = "abrt_nn";
 	else {
-		dbf_tag = "fail";
+		dbf_tag = "abrt_fa";
 		retval = FAILED;
 	}
-	zfcp_dbf_scsi_abort(dbf_tag, adapter->dbf, scpnt, abrt_req, old_reqid);
+	zfcp_dbf_scsi_abort(dbf_tag, scpnt, abrt_req);
 	zfcp_fsf_req_free(abrt_req);
 	return retval;
 }

