From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvfc: Fixup command response translation
Date: Mon, 15 Dec 2008 17:09:05 -0600
Message-ID: <200812152310.mBFNA0Qd014233@d03av04.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:46696 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYLOXKC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Dec 2008 18:10:02 -0500
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id mBFN9FnT007759
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 16:09:15 -0700
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mBFNA1Gv187238
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 16:10:01 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mBFNA169014269
	for <linux-scsi@vger.kernel.org>; Mon, 15 Dec 2008 16:10:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If a link down event is received, outstanding commands may get
returned to the ibmvfc driver with a "transaction cancelled implicit"
response. This is currently translated to DID_ABORT, which does
not get retried by SCSI core, but rather passes the failure up
the stack. This can result in I/O errors at the filesystem level.
Fix up this response a well as a few other error responses.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_response drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_response	2008-12-11 16:05:43.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-12-11 16:09:49.000000000 -0600
@@ -101,7 +101,7 @@ static const struct {
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_UNABLE_TO_ESTABLISH, DID_ERROR, 1, 1, "unable to establish" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_XPORT_FAULT, DID_OK, 1, 0, "transport fault" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_CMD_TIMEOUT, DID_TIME_OUT, 1, 1, "command timeout" },
-	{ IBMVFC_FABRIC_MAPPED, IBMVFC_ENETDOWN, DID_NO_CONNECT, 1, 1, "network down" },
+	{ IBMVFC_FABRIC_MAPPED, IBMVFC_ENETDOWN, DID_TRANSPORT_DISRUPTED, 1, 1, "network down" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_HW_FAILURE, DID_ERROR, 1, 1, "hardware failure" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_LINK_DOWN_ERR, DID_REQUEUE, 0, 0, "link down" },
 	{ IBMVFC_FABRIC_MAPPED, IBMVFC_LINK_DEAD_ERR, DID_ERROR, 0, 0, "link dead" },
@@ -115,11 +115,11 @@ static const struct {
 
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_CRQ_FAILURE, DID_REQUEUE, 1, 1, "CRQ failure" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_SW_FAILURE, DID_ERROR, 0, 1, "software failure" },
-	{ IBMVFC_VIOS_FAILURE, IBMVFC_INVALID_PARAMETER, DID_ABORT, 0, 1, "invalid parameter" },
-	{ IBMVFC_VIOS_FAILURE, IBMVFC_MISSING_PARAMETER, DID_ABORT, 0, 1, "missing parameter" },
+	{ IBMVFC_VIOS_FAILURE, IBMVFC_INVALID_PARAMETER, DID_ERROR, 0, 1, "invalid parameter" },
+	{ IBMVFC_VIOS_FAILURE, IBMVFC_MISSING_PARAMETER, DID_ERROR, 0, 1, "missing parameter" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_HOST_IO_BUS, DID_ERROR, 1, 1, "host I/O bus failure" },
-	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED, DID_ABORT, 0, 1, "transaction cancelled" },
-	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED_IMPLICIT, DID_ABORT, 0, 1, "transaction cancelled implicit" },
+	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED, DID_ERROR, 0, 1, "transaction cancelled" },
+	{ IBMVFC_VIOS_FAILURE, IBMVFC_TRANS_CANCELLED_IMPLICIT, DID_ERROR, 0, 1, "transaction cancelled implicit" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_INSUFFICIENT_RESOURCE, DID_REQUEUE, 1, 1, "insufficient resources" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_PLOGI_REQUIRED, DID_ERROR, 0, 1, "port login required" },
 	{ IBMVFC_VIOS_FAILURE, IBMVFC_COMMAND_FAILED, DID_ERROR, 1, 1, "command failed" },
_
