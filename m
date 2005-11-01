From: brking@us.ibm.com
Subject: [PATCH 06/26] ipr: Error logging cleanup
Date: Tue, 01 Nov 2005 17:00:47 -0600
Message-ID: <200511012300.jA1N0mrF026783@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:1996 "EHLO e32.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751402AbVKAXAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:00:49 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0nCG026465
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:49 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jA1N1rDC541120
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:01:53 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0mvQ026815
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 16:00:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Simplify error logging path, sanitize error length returned
by the adapter.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 drivers/scsi/ipr.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_error_cleanup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_error_cleanup	2005-10-31 20:42:13.500354432 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-10-31 21:52:55.806425880 -0600
@@ -1141,11 +1141,10 @@ static void ipr_handle_log_data(struct i
 
 	if (ioa_cfg->log_level < IPR_DEFAULT_LOG_LEVEL)
 		return;
+	if (be32_to_cpu(hostrcb->hcam.length) > sizeof(hostrcb->hcam.u.raw))
+		hostrcb->hcam.length = cpu_to_be32(sizeof(hostrcb->hcam.u.raw));
 
 	switch (hostrcb->hcam.overlay_id) {
-	case IPR_HOST_RCB_OVERLAY_ID_1:
-		ipr_log_generic_error(ioa_cfg, hostrcb);
-		break;
 	case IPR_HOST_RCB_OVERLAY_ID_2:
 		ipr_log_cache_error(ioa_cfg, hostrcb);
 		break;
@@ -1156,6 +1155,7 @@ static void ipr_handle_log_data(struct i
 	case IPR_HOST_RCB_OVERLAY_ID_6:
 		ipr_log_array_error(ioa_cfg, hostrcb);
 		break;
+	case IPR_HOST_RCB_OVERLAY_ID_1:
 	case IPR_HOST_RCB_OVERLAY_ID_DEFAULT:
 	default:
 		ipr_log_generic_error(ioa_cfg, hostrcb);
_
