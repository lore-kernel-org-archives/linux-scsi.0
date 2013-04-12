From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/5] ibmvfc: Send cancel when link is down
Date: Fri, 12 Apr 2013 08:25:17 -0500
Message-ID: <201304121325.r3CDPHwa025040@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37313 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab3DLNZX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 09:25:23 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Apr 2013 09:25:22 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 87B7EC9001D
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:18 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3CDPIlo308990
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:18 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3CDPIV2025052
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcjenn@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


If attempting to abort requests due to a fail fail timeout
or error handling while the link is down, we cannot send
an abort out on the fabric. We can, however, send a cancel
to the VIOS. This fixes ibmvfc to send a cancel in this
case to prevent error handling from failing and/or
escalating.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_cancel_when_link_down drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_cancel_when_link_down	2013-01-23 08:12:09.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-01-23 09:18:46.000000000 -0600
@@ -2179,7 +2179,7 @@ static int ibmvfc_cancel_all(struct scsi
 		return 0;
 	}
 
-	if (vhost->state == IBMVFC_ACTIVE) {
+	if (vhost->logged_in) {
 		evt = ibmvfc_get_event(vhost);
 		ibmvfc_init_event(evt, ibmvfc_sync_completion, IBMVFC_MAD_FORMAT);
 
@@ -2190,7 +2190,10 @@ static int ibmvfc_cancel_all(struct scsi
 		tmf->common.length = sizeof(*tmf);
 		tmf->scsi_id = rport->port_id;
 		int_to_scsilun(sdev->lun, &tmf->lun);
-		tmf->flags = (type | IBMVFC_TMF_LUA_VALID);
+		if (vhost->state == IBMVFC_ACTIVE)
+			tmf->flags = (type | IBMVFC_TMF_LUA_VALID);
+		else
+			tmf->flags = IBMVFC_TMF_LUA_VALID;
 		tmf->cancel_key = (unsigned long)sdev->hostdata;
 		tmf->my_cancel_key = (unsigned long)starget->hostdata;
 
@@ -2389,7 +2392,7 @@ static int ibmvfc_eh_abort_handler(struc
 {
 	struct scsi_device *sdev = cmd->device;
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
-	int cancel_rc, block_rc, abort_rc = 0;
+	int cancel_rc, block_rc;
 	int rc = FAILED;
 
 	ENTER;
@@ -2397,11 +2400,11 @@ static int ibmvfc_eh_abort_handler(struc
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
-		abort_rc = ibmvfc_abort_task_set(sdev);
+		ibmvfc_abort_task_set(sdev);
 	} else
 		cancel_rc = ibmvfc_cancel_all(sdev, 0);
 
-	if (!cancel_rc && !abort_rc)
+	if (!cancel_rc)
 		rc = ibmvfc_wait_for_ops(vhost, sdev, ibmvfc_match_lun);
 
 	if (block_rc == FAST_IO_FAIL && rc != FAILED)
_

