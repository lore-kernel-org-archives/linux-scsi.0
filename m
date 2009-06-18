From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvfc: Process async events before command responses
Date: Thu, 18 Jun 2009 09:06:52 -0500
Message-ID: <200906181404.n5IE4Zuf015313@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33954 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756509AbZFROGz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Jun 2009 10:06:55 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n5IE2GYX025675
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 10:02:16 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n5IE6tqn255154
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 10:06:56 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n5IE4bBd015479
	for <linux-scsi@vger.kernel.org>; Thu, 18 Jun 2009 10:04:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


Since async events could indicate changes to link status, or
events which could affect decisions made during discovery, we should
process async events prior to command completion responses.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_async_first drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_async_first	2009-06-16 13:29:55.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2009-06-16 13:29:55.000000000 -0500
@@ -2783,27 +2783,27 @@ static void ibmvfc_tasklet(void *data)
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	while (!done) {
-		/* Pull all the valid messages off the CRQ */
-		while ((crq = ibmvfc_next_crq(vhost)) != NULL) {
-			ibmvfc_handle_crq(crq, vhost);
-			crq->valid = 0;
-		}
-
 		/* Pull all the valid messages off the async CRQ */
 		while ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
 		}
 
-		vio_enable_interrupts(vdev);
-		if ((crq = ibmvfc_next_crq(vhost)) != NULL) {
-			vio_disable_interrupts(vdev);
+		/* Pull all the valid messages off the CRQ */
+		while ((crq = ibmvfc_next_crq(vhost)) != NULL) {
 			ibmvfc_handle_crq(crq, vhost);
 			crq->valid = 0;
-		} else if ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
+		}
+
+		vio_enable_interrupts(vdev);
+		if ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
 			vio_disable_interrupts(vdev);
 			ibmvfc_handle_async(async, vhost);
 			async->valid = 0;
+		} else if ((crq = ibmvfc_next_crq(vhost)) != NULL) {
+			vio_disable_interrupts(vdev);
+			ibmvfc_handle_crq(crq, vhost);
+			crq->valid = 0;
 		} else
 			done = 1;
 	}
_
