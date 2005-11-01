From: brking@us.ibm.com
Subject: [PATCH 05/26] ipr: Handle unknown errors
Date: Tue, 01 Nov 2005 17:00:41 -0600
Message-ID: <200511012300.jA1N0gcC020608@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:10705 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751401AbVKAXAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2005 18:00:43 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id jA1N0gdI027868
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:42 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id jA1N0gbn105824
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:42 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id jA1N0gLV020614
	for <linux-scsi@vger.kernel.org>; Tue, 1 Nov 2005 18:00:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Better handle errors received which are not known to the device driver.
Just dump the hex data so that we have a hope of figuring out what
went wrong.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    6 +-----
 1 files changed, 1 insertion(+), 5 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_handle_unknown_error drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_handle_unknown_error	2005-08-30 10:26:41.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2005-08-30 10:26:41.000000000 -0500
@@ -1157,12 +1157,8 @@ static void ipr_handle_log_data(struct i
 		ipr_log_array_error(ioa_cfg, hostrcb);
 		break;
 	case IPR_HOST_RCB_OVERLAY_ID_DEFAULT:
-		ipr_log_generic_error(ioa_cfg, hostrcb);
-		break;
 	default:
-		dev_err(&ioa_cfg->pdev->dev,
-			"Unknown error received. Overlay ID: %d\n",
-			hostrcb->hcam.overlay_id);
+		ipr_log_generic_error(ioa_cfg, hostrcb);
 		break;
 	}
 }
_
