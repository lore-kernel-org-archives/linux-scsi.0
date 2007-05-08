From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 4/5] zfcp: clear adapter failed flag if an fsf request times out.
Date: Tue, 8 May 2007 11:18:50 +0200
Message-ID: <200705081118.51048.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:40712 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934567AbXEHJQM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 05:16:12 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Must clear adapter failed flag if an fsf request times out. This is
necessary because on link down situations the failed flags gets set
but the QDIO queues are still up. Since an adapter reopen will be
skipped if the failed flag is set an adapter_reopen that is issued
on fsf request timeout has no effect if the local link is down.
Might lead to locked up system if the SCSI stack is waiting for abort
completion.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c	2007-05-07 16:26:34.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-05-07 16:33:54.000000000 +0200
@@ -179,7 +179,7 @@
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	zfcp_erp_adapter_reopen(adapter, 0);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
 }

 void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req, unsigned long timeout)


-------------------------------------------------------
