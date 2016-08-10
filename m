From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 04/10] zfcp: retain trace level for SCSI and HBA FSF response records
Date: Wed, 10 Aug 2016 18:30:47 +0200
Message-ID: <1470846653-90691-5-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37791 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933024AbcHJSf4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:35:56 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7AGY9s3142963
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:36 -0400
Received: from e06smtp14.uk.ibm.com (e06smtp14.uk.ibm.com [195.75.94.110])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9tq49u-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:36 -0400
Received: from localhost
	by e06smtp14.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 10 Aug 2016 17:35:33 +0100
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

While retaining the actual filtering according to trace level,
the following commits started to write such filtered records
with a hardcoded record level of 1 instead of the actual record level:
commit 250a1352b95e1db3216e5c5d4f4365bea5122f4a
("[SCSI] zfcp: Redesign of the debug tracing for SCSI records.")
commit a54ca0f62f953898b05549391ac2a8a4dad6482b
("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")

Now we can distinguish written records again for offline level filtering.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 250a1352b95e ("[SCSI] zfcp: Redesign of the debug tracing for SCSI records.")
Fixes: a54ca0f62f95 ("[SCSI] zfcp: Redesign of the debug tracing for HBA records.")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 11 ++++++-----
 drivers/s390/scsi/zfcp_dbf.h |  4 ++--
 drivers/s390/scsi/zfcp_ext.h |  7 ++++---
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index 5d7fbe4e907e..2308253ddddc 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -3,7 +3,7 @@
  *
  * Debug traces for zfcp.
  *
- * Copyright IBM Corp. 2002, 2013
+ * Copyright IBM Corp. 2002, 2015
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -65,7 +65,7 @@ void zfcp_dbf_pl_write(struct zfcp_dbf *dbf, void *data, u16 length, char *area,
  * @tag: tag indicating which kind of unsolicited status has been received
  * @req: request for which a response was received
  */
-void zfcp_dbf_hba_fsf_res(char *tag, struct zfcp_fsf_req *req)
+void zfcp_dbf_hba_fsf_res(char *tag, int level, struct zfcp_fsf_req *req)
 {
 	struct zfcp_dbf *dbf = req->adapter->dbf;
 	struct fsf_qtcb_prefix *q_pref = &req->qtcb->prefix;
@@ -97,7 +97,7 @@ void zfcp_dbf_hba_fsf_res(char *tag, struct zfcp_fsf_req *req)
 				  rec->pl_len, "fsf_res", req->req_id);
 	}
 
-	debug_event(dbf->hba, 1, rec, sizeof(*rec));
+	debug_event(dbf->hba, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->hba_lock, flags);
 }
 
@@ -399,7 +399,8 @@ void zfcp_dbf_san_in_els(char *tag, struct zfcp_fsf_req *fsf)
  * @sc: pointer to struct scsi_cmnd
  * @fsf: pointer to struct zfcp_fsf_req
  */
-void zfcp_dbf_scsi(char *tag, struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf)
+void zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *sc,
+		   struct zfcp_fsf_req *fsf)
 {
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) sc->device->host->hostdata[0];
@@ -442,7 +443,7 @@ void zfcp_dbf_scsi(char *tag, struct scsi_cmnd *sc, struct zfcp_fsf_req *fsf)
 		}
 	}
 
-	debug_event(dbf->scsi, 1, rec, sizeof(*rec));
+	debug_event(dbf->scsi, level, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->scsi_lock, flags);
 }
 
diff --git a/drivers/s390/scsi/zfcp_dbf.h b/drivers/s390/scsi/zfcp_dbf.h
index 7901deb4ba89..c879b54046ee 100644
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -284,7 +284,7 @@ static inline
 void zfcp_dbf_hba_fsf_resp(char *tag, int level, struct zfcp_fsf_req *req)
 {
 	if (debug_level_enabled(req->adapter->dbf->hba, level))
-		zfcp_dbf_hba_fsf_res(tag, req);
+		zfcp_dbf_hba_fsf_res(tag, level, req);
 }
 
 /**
@@ -323,7 +323,7 @@ void _zfcp_dbf_scsi(char *tag, int level, struct scsi_cmnd *scmd,
 					scmd->device->host->hostdata[0];
 
 	if (debug_level_enabled(adapter->dbf->scsi, level))
-		zfcp_dbf_scsi(tag, scmd, req);
+		zfcp_dbf_scsi(tag, level, scmd, req);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 5b500652572b..fd03a943cde2 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -3,7 +3,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2015
  */
 
 #ifndef ZFCP_EXT_H
@@ -36,7 +36,7 @@ extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
 			      struct zfcp_port *, struct scsi_device *, u8, u8);
 extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
 extern void zfcp_dbf_hba_fsf_uss(char *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_hba_fsf_res(char *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_hba_fsf_res(char *, int, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_bit_err(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_berr(struct zfcp_dbf *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_hba_def_err(struct zfcp_adapter *, u64, u16, void **);
@@ -44,7 +44,8 @@ extern void zfcp_dbf_hba_basic(char *, struct zfcp_adapter *);
 extern void zfcp_dbf_san_req(char *, struct zfcp_fsf_req *, u32);
 extern void zfcp_dbf_san_res(char *, struct zfcp_fsf_req *);
 extern void zfcp_dbf_san_in_els(char *, struct zfcp_fsf_req *);
-extern void zfcp_dbf_scsi(char *, struct scsi_cmnd *, struct zfcp_fsf_req *);
+extern void zfcp_dbf_scsi(char *, int, struct scsi_cmnd *,
+			  struct zfcp_fsf_req *);
 
 /* zfcp_erp.c */
 extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
-- 
2.6.6

