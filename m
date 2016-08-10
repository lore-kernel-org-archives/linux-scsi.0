From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 06/10] zfcp: trace on request for open and close of WKA port
Date: Wed, 10 Aug 2016 18:30:49 +0200
Message-ID: <1470846653-90691-7-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:6466 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753763AbcHJStR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:49:17 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7AGYISh102964
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:40 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9tfa93-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:40 -0400
Received: from localhost
	by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 10 Aug 2016 17:35:38 +0100
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

Since commit a54ca0f62f953898b05549391ac2a8a4dad6482b
("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
HBA records no longer contain WWPN, D_ID, or LUN
to reduce duplicate information which is already in REC records.
In contrast to "regular" target ports, we don't use recovery to open
WKA ports such as directory/nameserver, so we don't get REC records.
Therefore, introduce pseudo REC running records without any
actual recovery action but including D_ID of WKA port on open/close.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 32 ++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_ext.h |  1 +
 drivers/s390/scsi/zfcp_fsf.c |  8 ++++++--
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index e6ff199f7572..df68a4df8cdb 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -321,6 +321,38 @@ void zfcp_dbf_rec_run(char *tag, struct zfcp_erp_action *erp)
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
+/**
+ * zfcp_dbf_rec_run_wka - trace wka port event with info like running recovery
+ * @tag: identifier for event
+ * @wka_port: well known address port
+ * @req_id: request ID to correlate with potential HBA trace record
+ */
+void zfcp_dbf_rec_run_wka(char *tag, struct zfcp_fc_wka_port *wka_port,
+			  u64 req_id)
+{
+	struct zfcp_dbf *dbf = wka_port->adapter->dbf;
+	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dbf->rec_lock, flags);
+	memset(rec, 0, sizeof(*rec));
+
+	rec->id = ZFCP_DBF_REC_RUN;
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	rec->port_status = wka_port->status;
+	rec->d_id = wka_port->d_id;
+	rec->lun = ZFCP_DBF_INVALID_LUN;
+
+	rec->u.run.fsf_req_id = req_id;
+	rec->u.run.rec_status = ~0;
+	rec->u.run.rec_step = ~0;
+	rec->u.run.rec_action = ~0;
+	rec->u.run.rec_count = ~0;
+
+	debug_event(dbf->rec, 1, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
+}
+
 static inline
 void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf, void *data, u8 id, u16 len,
 		  u64 req_id, u32 d_id)
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index fd03a943cde2..c8fed9fa1cca 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -35,6 +35,7 @@ extern void zfcp_dbf_adapter_unregister(struct zfcp_adapter *);
 extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
 			      struct zfcp_port *, struct scsi_device *, u8, u8);
 extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
+extern void zfcp_dbf_rec_run_wka(char *, struct zfcp_fc_wka_port *, u64);
 extern void zfcp_dbf_hba_fsf_uss(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_fsf_res(char *, int, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index 96d35a7209fa..f56906f09bb3 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1581,7 +1581,7 @@ out:
 int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req;
+	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1610,6 +1610,8 @@ int zfcp_fsf_open_wka_port(struct zfcp_fc_wka_port *wka_port)
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
+	if (req && !IS_ERR(req))
+		zfcp_dbf_rec_run_wka("fsowp_1", wka_port, req->req_id);
 	return retval;
 }
 
@@ -1634,7 +1636,7 @@ static void zfcp_fsf_close_wka_port_handler(struct zfcp_fsf_req *req)
 int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 {
 	struct zfcp_qdio *qdio = wka_port->adapter->qdio;
-	struct zfcp_fsf_req *req;
+	struct zfcp_fsf_req *req = NULL;
 	int retval = -EIO;
 
 	spin_lock_irq(&qdio->req_q_lock);
@@ -1663,6 +1665,8 @@ int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *wka_port)
 		zfcp_fsf_req_free(req);
 out:
 	spin_unlock_irq(&qdio->req_q_lock);
+	if (req && !IS_ERR(req))
+		zfcp_dbf_rec_run_wka("fscwp_1", wka_port, req->req_id);
 	return retval;
 }
 
-- 
2.6.6

