From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Fri, 23 May 2014 10:52:10 -0500
Message-ID: <201405231552.s4NFqA9C027982@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50981 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbaEWPwV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 11:52:21 -0400
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 23 May 2014 11:52:20 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id ECDC4C9003E
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:52:06 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp23032.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4NFqChI4653456
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 15:52:12 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4NFqB89028021
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:52:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, nfont@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


If a CRQ reset is triggered for some reason while in the middle
of performing VSCSI adapter initialization, we don't want to
call the done function for the initialization MAD commands as
this will only result in two threads attempting initialization
at the same time, resulting in failures.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_purge_fix	2014-05-23 10:36:04.000000000 -0500
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:50:03.000000000 -0500
@@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
 				evt->cmnd_done(evt->cmnd);
-		} else if (evt->done)
+		} else if (evt->done && evt->crq.format != VIOSRP_MAD_FORMAT &&
+			   evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
 		spin_lock_irqsave(hostdata->host->host_lock, flags);
_

