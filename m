From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 3/6] ibmvfc: Fix hang on module removal
Date: Mon, 14 Jul 2008 14:36:31 -0500
Message-ID: <200807141936.m6EJah1k020236@d03av01.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38905 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYGNTgt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jul 2008 15:36:49 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6EJam6J031242
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:48 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6EJaleq1171586
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 15:36:47 -0400
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6EJakiB020346
	for <linux-scsi@vger.kernel.org>; Mon, 14 Jul 2008 13:36:46 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com


If certain ELS events are received during module removal, after the kthread
is stopped, the rmmod can hang. This fixes the ibmvfc driver so that ELS
events during rmmod are ignored by stopping all device activity prior to
killing the kthread and also changes reinitialization to not attempt a reinit
if the adapter has been taken offline.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvfc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reinit_fix drivers/scsi/ibmvscsi/ibmvfc.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_reinit_fix	2008-07-11 08:43:50.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2008-07-11 08:48:36.000000000 -0500
@@ -521,9 +521,10 @@ static void ibmvfc_set_host_action(struc
 static void ibmvfc_reinit_host(struct ibmvfc_host *vhost)
 {
 	if (vhost->action == IBMVFC_HOST_ACTION_NONE) {
-		scsi_block_requests(vhost->host);
-		ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING);
-		ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+		if (!ibmvfc_set_host_state(vhost, IBMVFC_INITIALIZING)) {
+			scsi_block_requests(vhost->host);
+			ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_QUERY);
+		}
 	} else
 		vhost->reinit = 1;
 
@@ -3811,10 +3812,12 @@ static int ibmvfc_remove(struct vio_dev 
 
 	ENTER;
 	ibmvfc_remove_trace_file(&vhost->host->shost_dev.kobj, &ibmvfc_trace_attr);
+	ibmvfc_link_down(vhost, IBMVFC_HOST_OFFLINE);
+	ibmvfc_wait_while_resetting(vhost);
+	ibmvfc_release_crq_queue(vhost);
 	kthread_stop(vhost->work_thread);
 	fc_remove_host(vhost->host);
 	scsi_remove_host(vhost->host);
-	ibmvfc_release_crq_queue(vhost);
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_purge_requests(vhost, DID_ERROR);
_
