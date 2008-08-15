From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 5/6] ibmvfc: Add details to async event log
Date: Fri, 15 Aug 2008 10:59:27 -0500
Message-ID: <200808151600.m7FG09qk010091@d03av02.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:60996 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbYHOQAM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Aug 2008 12:00:12 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FFrYCe004162
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 11:53:34 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG0AdO092706
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG09DZ010138
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 10:00:10 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


When logging async events, also print the payload in addition to the
event received.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_ae_log drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_ae_log	2008-08-15 10:25:53.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-08-15 10:27:04.000000000 -0500
@@ -2084,7 +2084,8 @@ static void ibmvfc_handle_async(struct i
 {
 	const char *desc = ibmvfc_get_ae_desc(crq->event);
 
-	ibmvfc_log(vhost, 3, "%s event received\n", desc);
+	ibmvfc_log(vhost, 3, "%s event received. scsi_id: %lx, wwpn: %lx,"
+		   " node_name: %lx\n", desc, crq->scsi_id, crq->wwpn, crq->node_name);
 
 	switch (crq->event) {
 	case IBMVFC_AE_LINK_UP:
_
