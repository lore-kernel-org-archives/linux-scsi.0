From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: [PATCH 2/8] zfcp: Make trace record tags unique
Date: Tue, 04 Sep 2012 15:23:30 +0200
Message-ID: <20120904132348.412804031@linux.vnet.ibm.com>
References: <20120904132328.564402930@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:39458 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab2IDN3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Sep 2012 09:29:43 -0400
Received: from /spool/local
	by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
	Tue, 4 Sep 2012 14:29:41 +0100
Content-Disposition: inline; filename=706-zfcp-make-trace-record-tags-unique.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Steffen Maier <maier@linux.vnet.ibm.com>, stable@vger.kernel.org

From: Steffen Maier <maier@linux.vnet.ibm.com>

Duplicate fssrh_2 from a54ca0f62f953898b05549391ac2a8a4dad6482b
"[SCSI] zfcp: Redesign of the debug tracing for HBA records."
complicates distinction of generic status read response from
local link up.
Duplicate fsscth1 from 2c55b750a884b86dea8b4cc5f15e1484cc47a25c
"[SCSI] zfcp: Redesign of the debug tracing for SAN records."
complicates distinction of good common transport response from
invalid port handle.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org> #2.6.38+
---
 drivers/s390/scsi/zfcp_fsf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -219,7 +219,7 @@ static void zfcp_fsf_status_read_handler
 		return;
 	}
 
-	zfcp_dbf_hba_fsf_uss("fssrh_2", req);
+	zfcp_dbf_hba_fsf_uss("fssrh_4", req);
 
 	switch (sr_buf->status_type) {
 	case FSF_STATUS_READ_PORT_CLOSED:
@@ -915,7 +915,7 @@ static void zfcp_fsf_send_ct_handler(str
 
 	switch (header->fsf_status) {
         case FSF_GOOD:
-		zfcp_dbf_san_res("fsscth1", req);
+		zfcp_dbf_san_res("fsscth2", req);
 		ct->status = 0;
 		break;
         case FSF_SERVICE_CLASS_NOT_SUPPORTED:

