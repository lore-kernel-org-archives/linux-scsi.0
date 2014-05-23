From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvscsi: Abort init sequence during error recovery
Date: Fri, 23 May 2014 10:47:22 -0500
Message-ID: <201405231547.s4NFlMGV009346@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44698 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbaEWPr0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2014 11:47:26 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 23 May 2014 11:47:25 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id E045138C804A
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:47:23 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id s4NFlN379568766
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 15:47:23 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s4NFlNmI009376
	for <linux-scsi@vger.kernel.org>; Fri, 23 May 2014 11:47:23 -0400
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
+++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2014-05-23 10:36:33.000000000 -0500
@@ -797,7 +797,8 @@ static void purge_requests(struct ibmvsc
 				       evt->hostdata->dev);
 			if (evt->cmnd_done)
 				evt->cmnd_done(evt->cmnd);
-		} else if (evt->done)
+		} else if (tmp_evt->done && tmp_evt->crq.format != VIOSRP_MAD_FORMAT &&
+			   tmp_evt->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
 			evt->done(evt);
 		free_event_struct(&evt->hostdata->pool, evt);
 		spin_lock_irqsave(hostdata->host->host_lock, flags);
_

