From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: [PATCH 22/22] zfcp: early returns for traces disabled via level
Date: Fri, 28 Jul 2017 12:31:08 +0200
Message-ID: <535ec12785894bb32aa0c3e8c12649cb5938b6aa.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59110 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751940AbdG1KbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Jul 2017 06:31:16 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6SASbFf100977
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:16 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2c035vhasy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 06:31:15 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Fri, 28 Jul 2017 11:31:14 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v6SAVBFW37093544
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 10:31:11 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2721BAE09E
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:29 +0100 (BST)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 08074AE0A0
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:29 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.213])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jul 2017 11:27:28 +0100 (BST)
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
In-Reply-To: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
References: <cover.1501085249.git.bblock@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Martin Peschke <mpeschke@linux.vnet.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Benjamin Block <bblock@linux.vnet.ibm.com>

From: Martin Peschke <mpeschke@linux.vnet.ibm.com>

This patch adds early checks to avoid burning CPU cycles on
the assembly of trace entries which would be skipped anyway.

Introduce a static const variable to keep the trace level to check with
debug_level_enabled() in sync with the actual trace emit with
debug_event(). In order not to refactor the SAN tracing too much,
simply use a define instead.

This change is only for the non / semi hot paths,
while the actual (I/O) hot path was already improved earlier:
zfcp_dbf_scsi() is already guarded by its only caller _zfcp_dbf_scsi()
since commit dcd20e2316cd ("[SCSI] zfcp: Only collect SCSI debug data for
matching trace levels").
zfcp_dbf_hba_fsf_res() is already guarded by its only caller
zfcp_dbf_hba_fsf_response() since commit 2e261af84cdb ("[SCSI] zfcp: Only
collect FSF/HBA debug data for matching trace levels").

Signed-off-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
[maier@linux.vnet.ibm.com: rebase, reword, default level 3 branch prediction]
Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 54 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 484da0b2d678..8227076c9cbb 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -113,8 +113,12 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 	struct zfcp_dbf *dbf = req->adapter->dbf;
 	struct fsf_status_read_buffer *srb = req->data;
 	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
+	static int const level = 2;
 	unsigned long flags;
 
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
 	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
@@ -142,7 +146,7 @@ void zfcp_dbf_hba_fsf_uss(char *tag, struct zfcp_fsf_req *req)
 		zfcp_dbf_pl_write(dbf, srb->payload.data, rec->pl_len,
 				  "fsf_uss", req->req_id);
 log:
-	debug_event(dbf->hba, 2, rec, sizeof(*rec));
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
@@ -156,8 +160,12 @@ void zfcp_dbf_hba_bit_err(char *tag, struct zfcp_fsf_req *req)
 	struct zfcp_dbf *dbf = req->adapter->dbf;
 	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
 	struct fsf_status_read_buffer *sr_buf = req->data;
+	static int const level = 1;
 	unsigned long flags;
 
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
 	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
@@ -169,7 +177,7 @@ void zfcp_dbf_hba_bit_err(char *tag, struct zfcp_fsf_req *req)
 	memcpy(&rec->u.be, &sr_buf->payload.bit_error,
 	       sizeof(struct fsf_bit_error_payload));
 
-	debug_event(dbf->hba, 1, rec, sizeof(*rec));
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
@@ -186,8 +194,12 @@ void zfcp_dbf_hba_def_err(struct zfcp_adapter *adapter, u64 req_id, u16 scount,
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_pay *payload = &dbf->pay_buf;
 	unsigned long flags;
+	static int const level = 1;
 	u16 length;
 
+	if (unlikely(!debug_level_enabled(dbf->pay, level)))
+		return;
+
 	if (!pl)
 		return;
 
@@ -202,7 +214,7 @@ void zfcp_dbf_hba_def_err(struct zfcp_adapter *adapter, u64 req_id, u16 scount,
 
 	while (payload->counter < scount && (char *)pl[payload->counter]) {
 		memcpy(payload->data, (char *)pl[payload->counter], length);
-		debug_event(dbf->pay, 1, payload, zfcp_dbf_plen(length));
+		debug_event(dbf->pay, level, payload, zfcp_dbf_plen(length));
 		payload->counter++;
 	}
 
@@ -217,15 +229,19 @@ void zfcp_dbf_hba_basic(char *tag, struct zfcp_adapter *adapter)
 {
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_hba *rec = &dbf->hba_buf;
+	static int const level = 1;
 	unsigned long flags;
 
+	if (unlikely(!debug_level_enabled(dbf->hba, level)))
+		return;
+
 	spin_lock_irqsave(&dbf->hba_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
 	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
 	rec->id = ZFCP_DBF_HBA_BASIC;
 
-	debug_event(dbf->hba, 1, rec, sizeof(*rec));
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
@@ -264,9 +280,13 @@ void zfcp_dbf_rec_trig(char *tag, struct zfcp_adapter *adapter,
 {
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
+	static int const level = 1;
 	struct list_head *entry;
 	unsigned long flags;
 
+	if (unlikely(!debug_level_enabled(dbf->rec, level)))
+		return;
+
 	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
@@ -283,7 +303,7 @@ void zfcp_dbf_rec_trig(char *tag, struct zfcp_adapter *adapter,
 	rec->u.trig.want = want;
 	rec->u.trig.need = need;
 
-	debug_event(dbf->rec, 1, rec, sizeof(*rec));
+	debug_event(dbf->rec, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
@@ -300,6 +320,9 @@ void zfcp_dbf_rec_run_lvl(int level, char *tag, struct zfcp_erp_action *erp)
 	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
 	unsigned long flags;
 
+	if (!debug_level_enabled(dbf->rec, level))
+		return;
+
 	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
@@ -345,8 +368,12 @@ void zfcp_dbf_rec_run_wka(char *tag, struct zfcp_fc_wka_port *wka_port,
 {
 	struct zfcp_dbf *dbf = wka_port->adapter->dbf;
 	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
+	static int const level = 1;
 	unsigned long flags;
 
+	if (unlikely(!debug_level_enabled(dbf->rec, level)))
+		return;
+
 	spin_lock_irqsave(&dbf->rec_lock, flags);
 	memset(rec, 0, sizeof(*rec));
 
@@ -362,10 +389,12 @@ void zfcp_dbf_rec_run_wka(char *tag, struct zfcp_fc_wka_port *wka_port,
 	rec->u.run.rec_action = ~0;
 	rec->u.run.rec_count = ~0;
 
-	debug_event(dbf->rec, 1, rec, sizeof(*rec));
+	debug_event(dbf->rec, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
+#define ZFCP_DBF_SAN_LEVEL 1
+
 static inline
 void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf,
 		  char *paytag, struct scatterlist *sg, u8 id, u16 len,
@@ -408,7 +437,7 @@ void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf,
 				      (u16)(sg->length - offset));
 			/* cap_len <= pay_sum < cap_len+ZFCP_DBF_PAY_MAX_REC */
 			memcpy(payload->data, sg_virt(sg) + offset, pay_len);
-			debug_event(dbf->pay, 1, payload,
+			debug_event(dbf->pay, ZFCP_DBF_SAN_LEVEL, payload,
 				    zfcp_dbf_plen(pay_len));
 			payload->counter++;
 			offset += pay_len;
@@ -418,7 +447,7 @@ void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf,
 	spin_unlock(&dbf->pay_lock);
 
 out:
-	debug_event(dbf->san, 1, rec, sizeof(*rec));
+	debug_event(dbf->san, ZFCP_DBF_SAN_LEVEL, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->san_lock, flags);
 }
 
@@ -434,6 +463,9 @@ void zfcp_dbf_san_req(char *tag, struct zfcp_fsf_req *fsf, u32 d_id)
 	struct zfcp_fsf_ct_els *ct_els = fsf->data;
 	u16 length;
 
+	if (unlikely(!debug_level_enabled(dbf->san, ZFCP_DBF_SAN_LEVEL)))
+		return;
+
 	length = (u16)zfcp_qdio_real_bytes(ct_els->req);
 	zfcp_dbf_san(tag, dbf, "san_req", ct_els->req, ZFCP_DBF_SAN_REQ,
 		     length, fsf->req_id, d_id, length);
@@ -512,6 +544,9 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 	struct zfcp_fsf_ct_els *ct_els = fsf->data;
 	u16 length;
 
+	if (unlikely(!debug_level_enabled(dbf->san, ZFCP_DBF_SAN_LEVEL)))
+		return;
+
 	length = (u16)zfcp_qdio_real_bytes(ct_els->resp);
 	zfcp_dbf_san(tag, dbf, "san_res", ct_els->resp, ZFCP_DBF_SAN_RES,
 		     length, fsf->req_id, ct_els->d_id,
@@ -531,6 +566,9 @@ void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
 	u16 length;
 	struct scatterlist sg;
 
+	if (unlikely(!debug_level_enabled(dbf->san, ZFCP_DBF_SAN_LEVEL)))
+		return;
+
 	length = (u16)(srb->length -
 			offsetof(struct fsf_status_read_buffer, payload));
 	sg_init_one(&sg, srb->payload.data, length);
-- 
2.11.2
