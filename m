From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ibmvfc: Fix oops in interrupt handler
Date: Fri, 14 Nov 2008 13:33:50 -0600
Message-ID: <200811141934.mAEJYKOP024058@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34421 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbYKNTeW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2008 14:34:22 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id mAEJYIkp006373
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:18 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mAEJYLsQ180956
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:21 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mAEJYLre024075
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2008 14:34:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Fixes an oops that can occur in the interrupt handler
if we get a lot of async events.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_crq_oops drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_crq_oops	2008-11-14 10:50:47.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-11-14 10:51:03.000000000 -0600
@@ -2721,7 +2721,7 @@ static irqreturn_t ibmvfc_interrupt(int 
 		} else if ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_async(async, vhost);
-			crq->valid = 0;
+			async->valid = 0;
 		} else
 			done = 1;
 	}
_
