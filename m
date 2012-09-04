From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 3/8] zfcp: Bounds checking for deferred error trace
Date: Tue, 04 Sep 2012 15:23:31 +0200
Message-ID: <20120904132348.521443300@linux.vnet.ibm.com>
References: <20120904132328.564402930@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:36238 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757086Ab2IDN3o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 09:29:44 -0400
Received: from /spool/local
	by e06smtp16.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 4 Sep 2012 14:29:42 +0100
Content-Disposition: inline; filename=707-zfcp-bounds-checking-for-deferred-error-trace.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

From: Steffen Maier <maier@linux.vnet.ibm.com>

The pl vector has scount elements, i.e. pl[scount-1] is the last valid
element. For maximum sized requests, payload->counter == scount after
the last loop iteration. Therefore, do bounds checking first (with
boolean shortcut) to not access the invalid element pl[scount].

Do not trust the maximum sbale->scount value from the HBA
but ensure we won't access the pl vector out of our allocated bounds.
While at it, clean up scoping and prevent unnecessary memset.

Minor fix for 86a9668a8d29ea711613e1cb37efa68e7c4db564
"[SCSI] zfcp: support for hardware data router"

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #3.2+
---
 drivers/s390/scsi/zfcp_dbf.c  |    2 +-
 drivers/s390/scsi/zfcp_qdio.c |   16 ++++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -191,7 +191,7 @@ void zfcp_dbf_hba_def_err(struct zfcp_ad
 	length = min((u16)sizeof(struct qdio_buffer),
 		     (u16)ZFCP_DBF_PAY_MAX_REC);
 
-	while ((char *)pl[payload->counter] && payload->counter < scount) {
+	while (payload->counter < scount && (char *)pl[payload->counter]) {
 		memcpy(payload->data, (char *)pl[payload->counter], length);
 		debug_event(dbf->pay, 1, payload, zfcp_dbf_plen(length));
 		payload->counter++;
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -102,18 +102,22 @@ static void zfcp_qdio_int_resp(struct cc
 {
 	struct zfcp_qdio *qdio = (struct zfcp_qdio *) parm;
 	struct zfcp_adapter *adapter = qdio->adapter;
-	struct qdio_buffer_element *sbale;
 	int sbal_no, sbal_idx;
-	void *pl[ZFCP_QDIO_MAX_SBALS_PER_REQ + 1];
-	u64 req_id;
-	u8 scount;
 
 	if (unlikely(qdio_err)) {
-		memset(pl, 0, ZFCP_QDIO_MAX_SBALS_PER_REQ * sizeof(void *));
 		if (zfcp_adapter_multi_buffer_active(adapter)) {
+			void *pl[ZFCP_QDIO_MAX_SBALS_PER_REQ + 1];
+			struct qdio_buffer_element *sbale;
+			u64 req_id;
+			u8 scount;
+
+			memset(pl, 0,
+			       ZFCP_QDIO_MAX_SBALS_PER_REQ * sizeof(void *));
 			sbale = qdio->res_q[idx]->element;
 			req_id = (u64) sbale->addr;
-			scount = sbale->scount + 1; /* incl. signaling SBAL */
+			scount = min(sbale->scount + 1,
+				     ZFCP_QDIO_MAX_SBALS_PER_REQ + 1);
+				     /* incl. signaling SBAL */
 
 			for (sbal_no = 0; sbal_no < scount; sbal_no++) {
 				sbal_idx = (idx + sbal_no) %

