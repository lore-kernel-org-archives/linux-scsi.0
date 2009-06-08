From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCHv2 2/5] ibmvscsi: Add specific timeouts for operations
Date: Mon, 08 Jun 2009 16:19:03 -0500
Message-ID: <200906082119.n58LJ32i014664@d01av04.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:49648 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755448AbZFHVTC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Jun 2009 17:19:02 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.13.1/8.13.1) with ESMTP id n58LEkSg004699
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:14:46 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n58LJ4p7254694
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:19:04 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n58LJ3wE014699
	for <linux-scsi@vger.kernel.org>; Mon, 8 Jun 2009 17:19:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com


From: Robert Jennings <rcj@linux.vnet.ibm.com>

Previously we had one timeout that was used for all types of operations.
This adds specific timeout values for different operations (init, login,
adapter info MAD, abort task, and LUN reset).

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 drivers/scsi/ibmvscsi/ibmvscsi.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~timeouts drivers/scsi/ibmvscsi/ibmvscsi.c
--- scsi-misc-2.6/drivers/scsi/ibmvscsi/ibmvscsi.c~timeouts	2009-06-08 15:54:12.000000000 -0500
+++ scsi-misc-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2009-06-08 15:54:12.000000000 -0500
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
@@ -944,7 +948,7 @@ static int send_srp_login(struct ibmvscs
 	init_event_struct(evt_struct,
 			  login_rsp,
 			  VIOSRP_SRP_FORMAT,
-			  init_timeout);
+			  login_timeout);
 
 	login = &evt_struct->iu.srp.login_req;
 	memset(login, 0x00, sizeof(struct srp_login_req));
@@ -959,7 +963,7 @@ static int send_srp_login(struct ibmvscs
 	 */
 	atomic_set(&hostdata->request_limit, 0);
 
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, login_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	dev_info(hostdata->dev, "sent SRP login\n");
 	return rc;
@@ -1026,7 +1030,7 @@ static int ibmvscsi_eh_abort_handler(str
 		init_event_struct(evt,
 				  sync_completion,
 				  VIOSRP_SRP_FORMAT,
-				  init_timeout);
+				  abort_timeout);
 
 		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 	
@@ -1040,7 +1044,7 @@ static int ibmvscsi_eh_abort_handler(str
 		evt->sync_srp = &srp_rsp;
 
 		init_completion(&evt->comp);
-		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, abort_timeout * 2);
 
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
@@ -1149,7 +1153,7 @@ static int ibmvscsi_eh_device_reset_hand
 		init_event_struct(evt,
 				  sync_completion,
 				  VIOSRP_SRP_FORMAT,
-				  init_timeout);
+				  reset_timeout);
 
 		tsk_mgmt = &evt->iu.srp.tsk_mgmt;
 
@@ -1162,7 +1166,7 @@ static int ibmvscsi_eh_device_reset_hand
 		evt->sync_srp = &srp_rsp;
 
 		init_completion(&evt->comp);
-		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, reset_timeout * 2);
 
 		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
 			break;
@@ -1394,7 +1398,7 @@ static int ibmvscsi_do_host_config(struc
 	init_event_struct(evt_struct,
 			  sync_completion,
 			  VIOSRP_MAD_FORMAT,
-			  init_timeout);
+			  info_timeout);
 
 	host_config = &evt_struct->iu.mad.host_config;
 
@@ -1416,7 +1420,7 @@ static int ibmvscsi_do_host_config(struc
 
 	init_completion(&evt_struct->comp);
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
+	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, info_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 	if (rc == 0)
 		wait_for_completion(&evt_struct->comp);
@@ -1441,7 +1445,7 @@ static int ibmvscsi_slave_configure(stru
 	spin_lock_irqsave(shost->host_lock, lock_flags);
 	if (sdev->type == TYPE_DISK) {
 		sdev->allow_restart = 1;
-		blk_queue_rq_timeout(sdev->request_queue, 60 * HZ);
+		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
 	}
 	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
 	spin_unlock_irqrestore(shost->host_lock, lock_flags);
_
