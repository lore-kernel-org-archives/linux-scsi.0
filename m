From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ibmvfc: Fix another hang on module removal
Date: Fri, 15 Aug 2008 10:59:21 -0500
Message-ID: <200808151600.m7FG032b029528@d01av01.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39556 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659AbYHOQAG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2008 12:00:06 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7FG04bl009656
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:04 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7FG04es159570
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:04 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7FG03bl029542
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2008 12:00:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


This fixes a hang on module removal. The module removal code was setting
the hosts's state to IBMVFC_HOST_OFFLINE before tearing down the kernel
thread, but, due to a bug in ibmvfc_wait_while_resetting, was not waiting
for the kernel thread's offlining work to be done prior to destroying
the kernel thread, which left the scsi host in a blocked state which we
never got out of.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_remove_hang_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_remove_hang_fix	2008-08-13 11:12:32.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-08-13 15:43:44.000000000 -0500
@@ -1059,9 +1059,10 @@ static void ibmvfc_get_starget_port_id(s
 static int ibmvfc_wait_while_resetting(struct ibmvfc_host *vhost)
 {
 	long timeout = wait_event_timeout(vhost->init_wait_q,
-					  (vhost->state == IBMVFC_ACTIVE ||
-					   vhost->state == IBMVFC_HOST_OFFLINE ||
-					   vhost->state == IBMVFC_LINK_DEAD),
+					  ((vhost->state == IBMVFC_ACTIVE ||
+					    vhost->state == IBMVFC_HOST_OFFLINE ||
+					    vhost->state == IBMVFC_LINK_DEAD) &&
+					   vhost->action == IBMVFC_HOST_ACTION_NONE),
 					  (init_timeout * HZ));
 
 	return timeout ? 0 : -EIO;
_
