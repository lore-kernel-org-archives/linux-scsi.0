From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 08/10] zfcp: fix D_ID field with actual value on tracing SAN responses
Date: Wed, 10 Aug 2016 18:30:51 +0200
Message-ID: <1470846653-90691-9-git-send-email-maier@linux.vnet.ibm.com>
References: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59027 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753566AbcHJSbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:31:18 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7AGY8nU142867
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:49 -0400
Received: from e06smtp06.uk.ibm.com (e06smtp06.uk.ibm.com [195.75.94.102])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24qm9tq4gy-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 10 Aug 2016 12:35:49 -0400
Received: from localhost
	by e06smtp06.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Wed, 10 Aug 2016 17:35:47 +0100
In-Reply-To: <1470846653-90691-1-git-send-email-maier@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, "#2 . 6 . 38+" <stable@vger.kernel.org>

With commit 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
we lost the N_Port-ID where an ELS response comes from.
With commit 7c7dc196814b9e1d5cc254dc579a5fa78ae524f7
("[SCSI] zfcp: Simplify handling of ct and els requests")
we lost the N_Port-ID where a CT response comes from.
It's especially useful if the request SAN trace record
with D_ID was already lost due to trace buffer wrap.

GS uses an open WKA port handle and ELS just a D_ID, and
only for ELS we could get D_ID from QTCB bottom via zfcp_fsf_req.
To cover both cases, add a new field to zfcp_fsf_ct_els
and fill it in on request to use in SAN response trace.
Strictly speaking the D_ID on SAN response is the FC frame's S_ID.
We don't need a field for the other end which is always us.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Fixes: 2c55b750a884 ("[SCSI] zfcp: Redesign of the debug tracing for SAN records.")
Fixes: 7c7dc196814b ("[SCSI] zfcp: Simplify handling of ct and els requests")
Cc: <stable@vger.kernel.org> #2.6.38+
Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_dbf.c | 2 +-
 drivers/s390/scsi/zfcp_fsf.c | 2 ++
 drivers/s390/scsi/zfcp_fsf.h | 4 +++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
index ceb934c93232..968897f5e1c6 100644
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -407,7 +407,7 @@ void zfcp_dbf_san_res(char *tag, struct zfcp_fsf_req *fsf)
 
 	length = (u16)(ct_els->resp->length + FC_CT_HDR_LEN);
 	zfcp_dbf_san(tag, dbf, sg_virt(ct_els->resp), ZFCP_DBF_SAN_RES, length,
-		     fsf->req_id, 0);
+		     fsf->req_id, ct_els->d_id);
 }
 
 /**
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index f56906f09bb3..75f820ca17b7 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -1079,6 +1079,7 @@ int zfcp_fsf_send_ct(struct zfcp_fc_wka_port *wka_port,
 
 	req->handler = zfcp_fsf_send_ct_handler;
 	req->qtcb->header.port_handle = wka_port->handle;
+	ct->d_id = wka_port->d_id;
 	req->data = ct;
 
 	zfcp_dbf_san_req("fssct_1", req, wka_port->d_id);
@@ -1175,6 +1176,7 @@ int zfcp_fsf_send_els(struct zfcp_adapter *adapter, u32 d_id,
 
 	hton24(req->qtcb->bottom.support.d_id, d_id);
 	req->handler = zfcp_fsf_send_els_handler;
+	els->d_id = d_id;
 	req->data = els;
 
 	zfcp_dbf_san_req("fssels1", req, d_id);
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 57ae3ae1046d..be1c04b334c5 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -3,7 +3,7 @@
  *
  * Interface to the FSF support functions.
  *
- * Copyright IBM Corp. 2002, 2010
+ * Copyright IBM Corp. 2002, 2015
  */
 
 #ifndef FSF_H
@@ -436,6 +436,7 @@ struct zfcp_blk_drv_data {
  * @handler_data: data passed to handler function
  * @port: Optional pointer to port for zfcp internal ELS (only test link ADISC)
  * @status: used to pass error status to calling function
+ * @d_id: Destination ID of either open WKA port for CT or of D_ID for ELS
  */
 struct zfcp_fsf_ct_els {
 	struct scatterlist *req;
@@ -444,6 +445,7 @@ struct zfcp_fsf_ct_els {
 	void *handler_data;
 	struct zfcp_port *port;
 	int status;
+	u32 d_id;
 };
 
 #endif				/* FSF_H */
-- 
2.6.6

