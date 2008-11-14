From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/4] ibmvfc: Handle port login required response
Date: Fri, 14 Nov 2008 13:33:53 -0600
Message-ID: <200811141934.mAEJYMLf022041@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:33291 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755000AbYKNTeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2008 14:34:31 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e38.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEJXbVH018581
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:33:37 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEJYOXG119844
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:34:26 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEJYNOU022055
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 12:34:23 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


The virtual fibre channel stack can return a failure response for a command
indicating the port login has been invalidated without sending the client
an async event. Add code to handle this response and initiate a PLOGI.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 +++
 drivers/scsi/ibmvscsi/ibmvfc.h |    1 +
 2 files changed, 4 insertions(+)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_port_login_reqd drivers/scsi/ibmvscsi/ibmvfc.h
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.h~ibmvfc_port_login_reqd	2008-11-13 16:20:22.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.h	2008-11-13 16:22:46.000000000 -0600
@@ -109,6 +109,7 @@ enum ibmvfc_vios_errors {
 	IBMVFC_TRANS_CANCELLED			= 0x0006,
 	IBMVFC_TRANS_CANCELLED_IMPLICIT	= 0x0007,
 	IBMVFC_INSUFFICIENT_RESOURCE		= 0x0008,
+	IBMVFC_PLOGI_REQUIRED			= 0x0010,
 	IBMVFC_COMMAND_FAILED			= 0x8000,
 };
 
diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_port_login_reqd drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_port_login_reqd	2008-11-13 16:22:53.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-11-13 16:44:02.000000000 -0600
@@ -121,6 +121,7 @@ static const struct {
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED, DID_ABORT, 0, 1, "transaction cancelled" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED_IMPLICIT, DID_ABORT, 0, 1, "transaction cancelled implicit" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_INSUFFICIENT_RESOURCE, DID_REQUEUE, 1, 1, "insufficient resources" },
+	{ IBMVFC_VIOS_FAILURE, IBMVFC_PLOGI_REQUIRED, DID_ERROR, 0, 1, "port login required" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_COMMAND_FAILED, DID_ERROR, 1, 1, "command failed" },
 
 	{ IBMVFC_FC_FAILURE, IBMVFC_INVALID_ELS_CMD_CODE, DID_ERROR, 0, 1, "invalid ELS command code" },
@@ -1475,6 +1476,8 @@ static void ibmvfc_scsi_done(struct ibmv
 				sense_len = SCSI_SENSE_BUFFERSIZE - rsp_len;
 			if ((rsp->flags & FCP_SNS_LEN_VALID) && rsp->fcp_sense_len && rsp_len <= 8)
 				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);
+			if ((vfc_cmd->status & IBMVFC_VIOS_FAILURE) && (vfc_cmd->error == IBMVFC_PLOGI_REQUIRED))
+				ibmvfc_reinit_host(evt->vhost);
 
 			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESID_OVER)))
 				cmnd->result = (DID_ERROR << 16);
_
