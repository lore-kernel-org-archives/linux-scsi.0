From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 4/6] ibmvfc: Sanitize response lengths
Date: Fri, 15 Aug 2008 10:59:26 -0500
Message-ID: <200808151600.m7FG07hS007533@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:46217 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbYHOQAL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 12:00:11 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG0AR8021701
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:10 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG09ej100812
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:09 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG09L5007692
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:09 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Sanitize the response lengths in order to prevent possible oopses
in the command response path.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_sanitize_sense drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_sanitize_sense	2008-08-14 12:44:03.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-08-14 12:44:03.000000000 -0500
@@ -1457,8 +1457,8 @@ static void ibmvfc_scsi_done(struct ibmv
 	struct ibmvfc_cmd *vfc_cmd = &evt->xfer_iu->cmd;
 	struct ibmvfc_fcp_rsp *rsp = &vfc_cmd->rsp;
 	struct scsi_cmnd *cmnd = evt->cmnd;
-	int rsp_len = 0;
-	int sense_len = rsp->fcp_sense_len;
+	u32 rsp_len = 0;
+	u32 sense_len = rsp->fcp_sense_len;
 
 	if (cmnd) {
 		if (vfc_cmd->response_flags & IBMVFC_ADAPTER_RESID_VALID)
@@ -1475,7 +1475,7 @@ static void ibmvfc_scsi_done(struct ibmv
 				rsp_len = rsp->fcp_rsp_len;
 			if ((sense_len + rsp_len) > SCSI_SENSE_BUFFERSIZE)
 				sense_len = SCSI_SENSE_BUFFERSIZE - rsp_len;
-			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len)
+			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len && rsp_len <= 8)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
 
 			ibmvfc_log_error(evt);
_
