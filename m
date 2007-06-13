From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/5] ibmvscsi: Abort path fix
Date: Wed, 13 Jun 2007 17:12:40 -0500
Message-ID: <200706132212.l5DMCeBp013228@d01av04.pok.ibm.com>
References: <11817727312836-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:55307 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980AbXFMWMn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jun 2007 18:12:43 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5DMCflD032709
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:41 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5DMCfVk556656
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:41 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5DMCfwe013239
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jun 2007 18:12:41 -0400
In-Reply-To: <11817727312836-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: santil@linux.vnet.ibm.com
Cc: rcjenn@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Since it is completely possible for scsi core to call 
a LLDD's eh_abort function after the command has completed,
fix ibmvscsi to return SUCCESS if this is the case.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_abort_fix drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_abort_fix	2007-06-12 14:50:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2007-06-12 14:50:50.000000000 -0500
@@ -1018,7 +1018,7 @@ static int ibmvscsi_eh_abort_handler(str
 
 	if (!found_evt) {
 		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
-		return FAILED;
+		return SUCCESS;
 	}
 
 	evt = get_event_struct(&hostdata->pool);
_
