From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/5] ibmvfc: Properly set cancel flags when cancelling abort
Date: Fri, 12 Apr 2013 08:25:15 -0500
Message-ID: <201304121325.r3CDPFe4024986@d01av05.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58942 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab3DLNZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Apr 2013 09:25:21 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 12 Apr 2013 09:25:20 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5228138C8056
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3CDPGeN262964
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:17 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3CDPGaB025002
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 09:25:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rcjenn@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, brking@linux.vnet.ibm.com


The flags on a cancel operation are intended to indicate what,
if any, TMF will follow the cancel request. This fixes a case
where we were incorrectly setting the abort task set flag on
the cancel flag when we were cancelling an abort task set.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_cancel_flags drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_cancel_flags	2013-01-22 07:44:23.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-01-22 07:44:56.000000000 -0600
@@ -2327,7 +2327,7 @@ static int ibmvfc_abort_task_set(struct
 	timeout = wait_for_completion_timeout(&evt->comp, timeout);
 
 	if (!timeout) {
-		rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
+		rc = ibmvfc_cancel_all(sdev, 0);
 		if (!rc) {
 			rc = ibmvfc_wait_for_ops(vhost, sdev->hostdata, ibmvfc_match_key);
 			if (rc == SUCCESS)
_

