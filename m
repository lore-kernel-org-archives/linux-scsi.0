From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: zfcp: fix likely/unlikely usage
Date: Wed, 21 Feb 2007 09:28:00 +0100
Message-ID: <20070221082800.GB8184@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:47584 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXBUI30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Feb 2007 03:29:26 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.8/8.13.8) with ESMTP id l1L8TO3v063574
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 08:29:24 GMT
Received: from d06av03.portsmouth.uk.ibm.com (d06av03.portsmouth.uk.ibm.com [9.149.37.213])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l1L8TOW71286360
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 08:29:24 GMT
Received: from d06av03.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av03.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l1L8TOxf020645
	for <linux-scsi@vger.kernel.org>; Wed, 21 Feb 2007 08:29:24 GMT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Swen Schillig <swen@vnet.ibm.com>, linux-scsi@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

zfcp_fsf_protstatus_eval() takes always the 'wrong' branch.

Likely Profiling Results
 ---------------------------------------------------------
[+- ] Type | # True | # False | Function:Filename@Line
+unlikely  |   11042|        0  zfcp_fsf_protstatus_eval()

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fsf.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/s390/scsi/zfcp_fsf.c
===================================================================
--- linux-2.6.orig/drivers/s390/scsi/zfcp_fsf.c
+++ linux-2.6/drivers/s390/scsi/zfcp_fsf.c
@@ -299,9 +299,10 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 	}
 
 	/* log additional information provided by FSF (if any) */
-	if (unlikely(qtcb->header.log_length)) {
+	if (likely(qtcb->header.log_length)) {
 		/* do not trust them ;-) */
-		if (qtcb->header.log_start > sizeof(struct fsf_qtcb)) {
+		if (unlikely(qtcb->header.log_start >
+			     sizeof(struct fsf_qtcb))) {
 			ZFCP_LOG_NORMAL
 			    ("bug: ULP (FSF logging) log data starts "
 			     "beyond end of packet header. Ignored. "
@@ -310,8 +311,9 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 			     sizeof(struct fsf_qtcb));
 			goto forget_log;
 		}
-		if ((size_t) (qtcb->header.log_start + qtcb->header.log_length)
-		    > sizeof(struct fsf_qtcb)) {
+		if (unlikely((size_t) (qtcb->header.log_start +
+				       qtcb->header.log_length) >
+			     sizeof(struct fsf_qtcb))) {
 			ZFCP_LOG_NORMAL("bug: ULP (FSF logging) log data ends "
 					"beyond end of packet header. Ignored. "
 					"(start=%i, length=%i, size=%li)\n",

-- 
Heiko Carstens
Linux on System z Development

IBM Deutschland Entwicklung GmbH
Vorsitzender des Aufsichtsrats: Johann Weihen
Geschaeftsfuehrung : Herbert Kircher
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
