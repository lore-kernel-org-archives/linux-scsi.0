From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 01/10] ibmvfc: Fix invalid error response handling
Date: Thu, 28 May 2009 16:17:22 -0500
Message-ID: <200905282115.n4SLFH6q029819@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45625 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759997AbZE1VRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 17:17:23 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e7.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SL5lhP026467
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:05:47 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHOJu244274
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:24 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLFHZ1029901
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:15:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fix an obvious bug in processing error responses for SCSI commands
which can result in successful responses being incorrectly returned
with DID_ERROR.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_fcp_rsp_len_chk drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fix_fcp_rsp_len_chk	2009-05-12 16:17:49.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-05-13 15:56:44.000000000 -0500
@@ -275,7 +275,7 @@ static int ibmvfc_get_err_result(struct 
 	int fc_rsp_len = rsp->fcp_rsp_len;
 
 	if ((rsp->flags & FCP_RSP_LEN_VALID) &&
-	    ((!fc_rsp_len && fc_rsp_len != 4 && fc_rsp_len != 8) ||
+	    ((fc_rsp_len && fc_rsp_len != 4 && fc_rsp_len != 8) ||
 	     rsp->data.info.rsp_code))
 		return DID_ERROR << 16;
 
_
