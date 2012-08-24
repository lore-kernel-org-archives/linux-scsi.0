From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/3] ibmvfc: Ignore fabric RSCNs when link is dead
Date: Fri, 24 Aug 2012 16:51:01 -0500
Message-ID: <201208242151.q7OLp1YW013204@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48775 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758176Ab2HXVvI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Aug 2012 17:51:08 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 24 Aug 2012 17:51:07 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 515AD38C803B
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:04 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q7OLp4B8124152
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q7OLp2PX013244
	for <linux-scsi@vger.kernel.org>; Fri, 24 Aug 2012 17:51:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcj@linux.vnet.ibm.com, stimmer@linux.vnet.ibm.com, brking@linux.vnet.ibm.com


This fixes an issues seen where a Fabric RSCN event was received
while the link was down, which resulted in repeated attempts to log back
into the fabric, which then failed, resulting in the ibmvfc driver
taking the host offline. Fix this by delaying taking any action
regarding the fabric RSCN until the link comes back up.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_link_dead_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_link_dead_fix	2012-08-24 16:43:33.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2012-08-24 16:43:33.000000000 -0500
@@ -2625,8 +2625,10 @@ static void ibmvfc_handle_async(struct i
 	case IBMVFC_AE_SCN_FABRIC:
 	case IBMVFC_AE_SCN_DOMAIN:
 		vhost->events_to_log |= IBMVFC_AE_RSCN;
-		vhost->delay_init = 1;
-		__ibmvfc_reset_host(vhost);
+		if (vhost->state < IBMVFC_HALTED) {
+			vhost->delay_init = 1;
+			__ibmvfc_reset_host(vhost);
+		}
 		break;
 	case IBMVFC_AE_SCN_NPORT:
 	case IBMVFC_AE_SCN_GROUP:
_

