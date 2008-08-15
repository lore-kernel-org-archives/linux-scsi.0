From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 2/6] ibmvfc: Fixup host state during reinit
Date: Fri, 15 Aug 2008 10:59:22 -0500
Message-ID: <200808151600.m7FG04j7027652@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39557 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYHOQAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 12:00:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG05qL009663
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:05 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG05cC207640
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:05 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG04mM027704
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If an ELS is received while the virtual fibre channel adapter is going through
its discovery, a flag is set which causes discovery to get re-driven. However,
the hosts's state does not get set back to IBMVFC_INITIALIZING and scsi_block_requests
does not get called again, which can result in queuecommand ops getting sent during
discovery. This should not occur and may cause problems. One example is that we
may no longer be logged into the target we send the command to, resulting in a failure
which should not have occurred.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reinit_state_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reinit_state_fix	2008-08-13 11:12:33.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-08-13 15:34:20.000000000 -0500
@@ -3602,8 +3602,9 @@ static void ibmvfc_do_work(struct ibmvfc
 			}
 		}
 
-		if (vhost->reinit) {
+		if (vhost->reinit && !ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
 			vhost->reinit = 0;
+			scsi_block_requests(vhost->host);
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
 		} else {
 			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_NONE);
_
