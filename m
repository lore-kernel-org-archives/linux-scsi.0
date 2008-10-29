From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ibmvfc: Fix error reporting for some FC errors
Date: Wed, 29 Oct 2008 08:46:36 -0500
Message-ID: <200810291347.m9TDl4hx025236@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:47656 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbYJ2NrL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2008 09:47:11 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id m9TDkxCL015101
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:46:59 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id m9TDl9Ig089342
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:09 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m9TDl88k025421
	for <linux-scsi@vger.kernel.org>; Wed, 29 Oct 2008 07:47:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If either a "transport fault" or a "general transport" error is received
and no other error information is available, the command is improperly
returned as successful. Fix this to return DID_ERROR in this case.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fc_mapped_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_fc_mapped_fix	2008-09-19 08:55:23.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-09-19 08:55:23.000000000 -0500
@@ -278,13 +278,6 @@ static int ibmvfc_get_err_result(struct 
 	     rsp->data.info.rsp_code))
 		return DID_ERROR << 16;
 
-	if (!vfc_cmd->status) {
-		if (rsp->flags & FCP_RESID_OVER)
-			return rsp->scsi_status | (DID_ERROR << 16);
-		else
-			return rsp->scsi_status | (DID_OK << 16);
-	}
-
 	err = ibmvfc_get_err_index(vfc_cmd->status, vfc_cmd->error);
 	if (err >= 0)
 		return rsp->scsi_status | (cmd_status[err].result << 16);
@@ -1478,6 +1471,9 @@ static void ibmvfc_scsi_done(struct ibmv
 			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len && rsp_len <= 8)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
 
+			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
+				cmnd->result = (DID_ERROR << 16);
+
 			ibmvfc_log_error(evt);
 		}
 
_
