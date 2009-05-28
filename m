From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 02/10] ibmvfc: Fixup GFP flags for target allocations
Date: Thu, 28 May 2009 16:17:24 -0500
Message-ID: <200905282117.n4SLHOXU011939@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40644 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760450AbZE1VRX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 May 2009 17:17:23 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n4SLJv7q023389
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:19:57 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n4SLHPBd242080
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:25 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n4SLHPYI011970
	for <linux-scsi@vger.kernel.org>; Thu, 28 May 2009 17:17:25 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Since target allocations can occur while resetting the virtual adapter,
we shouldn't be using GFP_KERNEL for them as it could hang. Switch to
use GFP_NOIO.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_target_gfp_flags drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_target_gfp_flags	2009-03-31 08:45:51.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-03-31 08:45:51.000000000 -0500
@@ -3420,7 +3420,7 @@ static int ibmvfc_alloc_target(struct ib
 	}
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
 
-	tgt = mempool_alloc(vhost->tgt_pool, GFP_KERNEL);
+	tgt = mempool_alloc(vhost->tgt_pool, GFP_NOIO);
 	if (!tgt) {
 		dev_err(vhost->dev, "Target allocation failure for scsi id %08llx\n",
 			scsi_id);
_
