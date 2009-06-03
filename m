From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/4] ibmvscsi: Add specific timeouts for operations
Date: Wed, 03 Jun 2009 09:54:32 -0500
Message-ID: <200906031454.n53EsXdG031590@d03av03.boulder.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37860 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbZFCOyn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Jun 2009 10:54:43 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by e9.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n53EgOmb026595
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 10:42:24 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n53EsiGD1437904
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 10:54:44 -0400
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n53EsY2O031701
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2009 08:54:35 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, rcjenn@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com


From: Robert Jennings <rcj@linux.vnet.ibm.com>

Previously we had one timeout that was used for all types of operations.
This adds specific timeout values for different operations (init, login,
adapter info MAD, abort task, and LUN reset).

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~timeouts drivers/scsi/ibmvscsi/ibmvscsi.c
--- linux-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~timeouts	2009-05-29 14:09:22.000000000 -0500
+++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-03 09:23:20.000000000 -0500
@@ -87,7 +87,11 @@
  */
 static int max_id = 64;
 static int max_channel = 3;
-static int init_timeout = 5;
+static int init_timeout = 300;
+static int login_timeout = 60;
+static int info_timeout = 30;
+static int abort_timeout = 60;
+static int reset_timeout = 60;
 static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 static int max_events = IBMVSCSI_MAX_REQUESTS_DEFAULT + 2;
 
@@ -849,7 +853,7 @@ static void send_mad_adapter_info(struct
 	init_event_struct(evt_struct,
 			  adapter_info_rsp,
 			  VIOSRP_MAD_FORMAT,
-			  init_timeout);
+			  info_timeout);
 	
 	req = &evt_struct->iu.mad.adapter_info;
 	memset(req, 0x00, sizeof(*req));
@@ -871,7 +875,7 @@ static void send_mad_adapter_info(struct
 	}
 	
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	if (ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2)) {
+	if (ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2)) {
 		dev_err(hostdata->dev, "couldn't send ADAPTER_INFO_REQ!\n");
 		dma_unmap_single(hostdata->dev,
 				 addr,
@@ -947,7 +951,7 @@ static int send_srp_login(struct ibmvscs
 	init_event_struct(evt_struct,
 			  login_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  init_timeout);
+			  login_timeout);
 
 	login = &evt_struct->iu.srp.login_req;
 	memset(login, 0x00, sizeof(struct srp_login_req));
@@ -962,7 +966,7 @@ static int send_srp_login(struct ibmvscs
 	 */
 	atomic_set(&hostdata->request_limit, 0);
 
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
 	return rc;
@@ -1029,7 +1033,7 @@ static int ibmvscsi_eh_abort_handler(str
 		init_event_struct(evt,
 				  sync_completion,
 				  VIOSRP_SRP_FORMAT,
-				  init_timeout);
+				  abort_timeout);
 
 		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 	
@@ -1043,7 +1047,7 @@ static int ibmvscsi_eh_abort_handler(str
 		evt->sync_srp = &srp_rsp;
 
 		init_completion(&evt->comp);
-		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, abort_timeout * 2);
 
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
@@ -1152,7 +1156,7 @@ static int ibmvscsi_eh_device_reset_hand
 		init_event_struct(evt,
 				  sync_completion,
 				  VIOSRP_SRP_FORMAT,
-				  init_timeout);
+				  reset_timeout);
 
 		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 
@@ -1165,7 +1169,7 @@ static int ibmvscsi_eh_device_reset_hand
 		evt->sync_srp = &srp_rsp;
 
 		init_completion(&evt->comp);
-		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, reset_timeout * 2);
 
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
@@ -1397,7 +1401,7 @@ static int ibmvscsi_do_host_config(struc
 	init_event_struct(evt_struct,
 			  sync_completion,
 			  VIOSRP_MAD_FORMAT,
-			  init_timeout);
+			  info_timeout);
 
 	host_config = &evt_struct->iu.mad.host_config;
 
@@ -1419,7 +1423,7 @@ static int ibmvscsi_do_host_config(struc
 
 	init_completion(&evt_struct->comp);
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rc == 0)
 		wait_for_completion(&evt_struct->comp);
@@ -1444,7 +1448,7 @@ static int ibmvscsi_slave_configure(stru
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
-		blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
 	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
_
