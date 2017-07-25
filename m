From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [RFC 1/9] zfcp: drop unsuitable scsi_cmnd usage from SCSI traces for scsi_eh / TMF
Date: Tue, 25 Jul 2017 16:14:19 +0200
Message-ID: <20170725141427.35258-2-maier@linux.vnet.ibm.com>
References: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45963 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752306AbdGYOOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 10:14:49 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PEAlem017420
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:49 -0400
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bx4y3frrr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 10:14:48 -0400
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 15:14:47 +0100
In-Reply-To: <20170725141427.35258-1-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Cc: linux-s390@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, Benjamin Block <bblock@linux.vnet.ibm.com>

The SCSI command pointer passed to scsi_eh callbacks is just one arbitrary
command of potentially many that are in the eh queue to be processed.
The command is only used to indirectly pass the TMF scope in terms of
SCSI ID/target and SCSI LUN for LUN reset.

Hence, zfcp had filled in SCSI trace record fields which do not really
belong to the TMF. This was confusing.

Therefore, refactor the TMF tracing to work without SCSI command
and instead pass explicit arguments for SCSI ID and SCSI LUN.
As context we now need a pointer to zfcp_adapter.
To make it even clearer, we set all bits to 1 for the fields, which do
not belong to the TMF, to indicate that these fields are invalid.

The old zfcp_dbf_scsi() became zfcp_dbf_scsi_common() to now handle both
SCSI commands and TMFs. The old argument scsi_cmnd is now optional and
can be NULL with TMFs. Two new arguments scsi_id and scsi_lun are
optional and only used if scsi_cmnd is NULL, i.e. with TMFs.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c  | 51 ++++++++++++++++++++++++++++---------------
 drivers/s390/scsi/zfcp_dbf.h  | 26 +++++++++++++++-------
 drivers/s390/scsi/zfcp_ext.h  |  8 ++++---
 drivers/s390/scsi/zfcp_scsi.c | 20 ++++++++++++-----
 4 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 8227076c9cbb..dca624aaa7c0 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -577,16 +577,19 @@ void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
 }
 
 /**
- * zfcp_dbf_scsi - trace event for scsi commands
- * @tag: identifier for event
- * @sc: pointer to struct scsi_cmnd
- * @fsf: pointer to struct zfcp_fsf_req
+ * zfcp_dbf_scsi_common() - Common trace event helper for scsi.
+ * @tag: Identifier for event.
+ * @level: trace level of event.
+ * @adapter: Pointer to zfcp adapter as context for this event.
+ * @sc: Pointer to SCSI command, or NULL with task management function (TMF).
+ * @fsf: Pointer to FSF request, or NULL.
+ * @scsi_id: SCSI ID/target to indicate scope, only for TMF.
+ * @scsi_lun: SCSI LUN if TMF is Logical Unit Reset, else %ZFCP_DBF_INVALID_LUN.
  */
-void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
-		   struct zfcp_fsf_req *fsf)
+void zfcp_dbf_scsi_common(char *tag, int level, struct zfcp_adapter *adapter,
+			  struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf,
+			  unsigned int scsi_id, u64 scsi_lun)
 {
-	struct zfcp_adapter *adapter =
-		(struct zfcp_adapter *) sc->device->host->hostdata[0];
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_scsi *rec = &dbf->scsi_buf;
 	struct fcp_resp_with_ext *fcp_rsp;
@@ -598,16 +601,28 @@ void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
 
 	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
 	rec->id = ZFCP_DBF_SCSI_CMND;
-	rec->scsi_result = sc->result;
-	rec->scsi_retries = sc->retries;
-	rec->scsi_allowed = sc->allowed;
-	rec->scsi_id = sc->device->id;
-	rec->scsi_lun = (u32)sc->device->lun;
-	rec->scsi_lun_64_hi = (u32)(sc->device->lun >> 32);
-	rec->host_scribble = (unsigned long)sc->host_scribble;
-
-	memcpy(rec->scsi_opcode, sc->cmnd,
-	       min((int)sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
+	if (sc) {
+		rec->scsi_result = sc->result;
+		rec->scsi_retries = sc->retries;
+		rec->scsi_allowed = sc->allowed;
+		rec->scsi_id = sc->device->id;
+		rec->scsi_lun = (u32)sc->device->lun;
+		rec->scsi_lun_64_hi = (u32)(sc->device->lun >> 32);
+		rec->host_scribble = (unsigned long)sc->host_scribble;
+
+		memcpy(rec->scsi_opcode, sc->cmnd,
+		       min_t(int, sc->cmd_len, ZFCP_DBF_SCSI_OPCODE));
+	} else {
+		rec->scsi_result = ~0;
+		rec->scsi_retries = ~0;
+		rec->scsi_allowed = ~0;
+		rec->scsi_id = scsi_id;
+		rec->scsi_lun = (u32)scsi_lun;
+		rec->scsi_lun_64_hi = (u32)(scsi_lun >> 32);
+		rec->host_scribble = ~0;
+
+		memset(rec->scsi_opcode, 0xff, ZFCP_DBF_SCSI_OPCODE);
+	}
 
 	if (fsf) {
 		rec->fsf_req_id = fsf->req_id;
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 3508c00458f4..6e29e7cccbc4 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -358,7 +358,8 @@ void _zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *scmd,
 					scmd->device->host->hostdata[0];
 
 	if (debug_level_enabled(adapter->dbf->scsi, level))
-		zfcp_dbf_scsi(tag, level, scmd, req);
+		zfcp_dbf_scsi_common(tag, level, adapter, scmd, req,
+				     ~0, ZFCP_DBF_INVALID_LUN);
 }
 
 /**
@@ -401,16 +402,24 @@ void zfcp_dbf_scsi_abort(char *tag, struct scsi_cmnd *scmd,
 }
 
 /**
- * zfcp_dbf_scsi_devreset - trace event for Logical Unit or Target Reset
- * @tag: tag indicating success or failure of reset operation
- * @scmnd: SCSI command which caused this error recovery
- * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
+ * zfcp_dbf_scsi_devreset() - Trace event for Logical Unit or Target Reset.
+ * @tag: Tag indicating success or failure of reset operation.
+ * @adapter: Pointer to zfcp adapter as context for this event.
+ * @flag: Indicates type of reset (Target Reset, Logical Unit Reset).
+ * @fsf_req: Pointer to FSF request representing the TMF, or NULL.
+ * @scsi_id: SCSI ID/target to indicate scope of task management function (TMF).
+ * @scsi_lun: SCSI LUN if TMF is Logical Unit Reset, else %ZFCP_DBF_INVALID_LUN.
  */
 static inline
-void zfcp_dbf_scsi_devreset(char *tag, struct scsi_cmnd *scmnd, u8 flag,
-			    struct zfcp_fsf_req *fsf_req)
+void zfcp_dbf_scsi_devreset(char *tag, struct zfcp_adapter *adapter, u8 flag,
+			    struct zfcp_fsf_req *fsf_req,
+			    unsigned int scsi_id, u64 scsi_lun)
 {
 	char tmp_tag[ZFCP_DBF_TAG_LEN];
+	static int const level = 1;
+
+	if (unlikely(!debug_level_enabled(adapter->dbf->scsi, level)))
+		return;
 
 	if (flag == FCP_TMF_TGT_RESET)
 		memcpy(tmp_tag, "tr_", 3);
@@ -418,7 +427,8 @@ void zfcp_dbf_scsi_devreset(char *tag, struct scsi_cmnd *scmnd, u8 flag,
 		memcpy(tmp_tag, "lr_", 3);
 
 	memcpy(&tmp_tag[3], tag, 4);
-	_zfcp_dbf_scsi(tmp_tag, 1, scmnd, fsf_req);
+	zfcp_dbf_scsi_common(tmp_tag, level, adapter, NULL, fsf_req,
+			     scsi_id, scsi_lun);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index a9e968717dd9..f3101bc5d1bc 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -3,7 +3,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2016
+ * Copyright IBM Corp. 2002, 2017
  */
 
 #ifndef ZFCP_EXT_H
@@ -46,8 +46,10 @@ extern void zfcp_dbf_hba_basic(char *, struct zfcp_adapter *);
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_in_els(char *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_scsi(char *, int, struct scsi_cmnd *,
-			  struct zfcp_fsf_req *);
+extern void zfcp_dbf_scsi_common(char *tag, int level,
+				 struct zfcp_adapter *adapter,
+				 struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf,
+				 unsigned int scsi_id, u64 scsi_lun);
 
 /* zfcp_erp.c */
 extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index ec3ddd1d31d5..cd0f811452b7 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -262,10 +262,15 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
+	unsigned int scsi_id = zfcp_sdev->port->starget_id;
+	u64 scsi_lun = ZFCP_DBF_INVALID_LUN;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
 
+	if (tm_flags == FCP_TMF_LUN_RESET)
+		scsi_lun = scpnt->device->lun;
+
 	while (retry--) {
 		fsf_req = zfcp_fsf_fcp_task_mgmt(scpnt, tm_flags);
 		if (fsf_req)
@@ -274,28 +279,33 @@ static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 		zfcp_erp_wait(adapter);
 		ret = fc_block_scsi_eh(scpnt);
 		if (ret) {
-			zfcp_dbf_scsi_devreset("fiof", scpnt, tm_flags, NULL);
+			zfcp_dbf_scsi_devreset("fiof", adapter, tm_flags, NULL,
+					       scsi_id, scsi_lun);
 			return ret;
 		}
 
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_dbf_scsi_devreset("nres", scpnt, tm_flags, NULL);
+			zfcp_dbf_scsi_devreset("nres", adapter, tm_flags, NULL,
+					       scsi_id, scsi_lun);
 			return SUCCESS;
 		}
 	}
 	if (!fsf_req) {
-		zfcp_dbf_scsi_devreset("reqf", scpnt, tm_flags, NULL);
+		zfcp_dbf_scsi_devreset("reqf", adapter, tm_flags, NULL,
+				       scsi_id, scsi_lun);
 		return FAILED;
 	}
 
 	wait_for_completion(&fsf_req->completion);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
-		zfcp_dbf_scsi_devreset("fail", scpnt, tm_flags, fsf_req);
+		zfcp_dbf_scsi_devreset("fail", adapter, tm_flags, fsf_req,
+				       scsi_id, scsi_lun);
 		retval = FAILED;
 	} else {
-		zfcp_dbf_scsi_devreset("okay", scpnt, tm_flags, fsf_req);
+		zfcp_dbf_scsi_devreset("okay", adapter, tm_flags, fsf_req,
+				       scsi_id, scsi_lun);
 		zfcp_scsi_forget_cmnds(zfcp_sdev, tm_flags);
 	}
 
-- 
2.11.2
