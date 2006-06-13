From: boutcher@cs.umn.edu (Dave C Boutcher)
Subject: [PATCH] ibmvscsi: treat busy and error conditions separately
Date: Mon, 12 Jun 2006 21:22:51 -0500
Message-ID: <17550.8571.551666.798240@hound.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.34.202]:7933 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S932769AbWFMCXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Jun 2006 22:23:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id C1E8F5C46B
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jun 2006 21:23:21 -0500 (CDT)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (mail.cs.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
 with LMTP id 28535-02-6 for <linux-scsi@vger.kernel.org>;
 Mon, 12 Jun 2006 21:23:18 -0500 (CDT)
Received: from oxygen.cs.umn.edu (oxygen.cs.umn.edu [128.101.35.179])
	by mail.cs.umn.edu (Postfix) with ESMTP id 3CD4C5C430
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jun 2006 21:23:18 -0500 (CDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch fixes a condition where ibmvscsi treats a transport error as a
"busy" condition, so no errors were returned to the scsi mid-layer.
In a RAID environment this means that I/O hung rather than failing
over.
---

 drivers/scsi/ibmvscsi/ibmvscsi.c  |   64 ++++++++++++++++++++++++++++---------
 drivers/scsi/ibmvscsi/rpa_vscsi.c |    5 ++-
 2 files changed, 52 insertions(+), 17 deletions(-)

7458d4009b48ea25253b1881625f418c5173135a
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 944fc12..54e996a 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -535,6 +535,7 @@ static int ibmvscsi_send_srp_event(struc
 				   struct ibmvscsi_host_data *hostdata)
 {
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
+	int request_status;
 	int rc;
 
 	/* If we have exhausted our request limit, just fail this request.
@@ -542,9 +543,18 @@ static int ibmvscsi_send_srp_event(struc
 	 * (such as task management requests) that the mid layer may think we
 	 * can handle more requests (can_queue) when we actually can't
 	 */
-	if ((evt_struct->crq.format == VIOSRP_SRP_FORMAT) &&
-	    (atomic_dec_if_positive(&hostdata->request_limit) < 0))
-		goto send_error;
+	if (evt_struct->crq.format == VIOSRP_SRP_FORMAT) {
+		request_status =
+			atomic_dec_if_positive(&hostdata->request_limit);
+		/* If request limit was -1 when we started, it is now even
+		 * less than that
+		 */
+		if (request_status < -1)
+			goto send_error;
+		/* Otherwise, if we have run out of requests */
+		else if (request_status < 0)
+			goto send_busy;
+	}
 
 	/* Copy the IU into the transfer area */
 	*evt_struct->xfer_iu = evt_struct->iu;
@@ -567,11 +577,23 @@ static int ibmvscsi_send_srp_event(struc
 
 	return 0;
 
- send_error:
+ send_busy:
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
 	free_event_struct(&hostdata->pool, evt_struct);
  	return SCSI_MLQUEUE_HOST_BUSY;
+
+ send_error:
+	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
+
+	if (evt_struct->cmnd != NULL) {
+		evt_struct->cmnd->result = DID_ERROR << 16;
+		evt_struct->cmnd_done(evt_struct->cmnd);
+	} else if (evt_struct->done)
+		evt_struct->done(evt_struct);
+	
+	free_event_struct(&hostdata->pool, evt_struct);
+	return 0;
 }
 
 /**
@@ -1184,27 +1206,37 @@ void ibmvscsi_handle_crq(struct viosrp_c
 		return;
 	case 0xFF:	/* Hypervisor telling us the connection is closed */
 		scsi_block_requests(hostdata->host);
+		atomic_set(&hostdata->request_limit, 0);
 		if (crq->format == 0x06) {
 			/* We need to re-setup the interpartition connection */
 			printk(KERN_INFO
 			       "ibmvscsi: Re-enabling adapter!\n");
-			atomic_set(&hostdata->request_limit, -1);
 			purge_requests(hostdata, DID_REQUEUE);
-			if (ibmvscsi_reenable_crq_queue(&hostdata->queue,
-							hostdata) == 0)
-				if (ibmvscsi_send_crq(hostdata,
-						      0xC001000000000000LL, 0))
+			if ((ibmvscsi_reenable_crq_queue(&hostdata->queue,
+							hostdata) == 0) ||
+			    (ibmvscsi_send_crq(hostdata,
+					       0xC001000000000000LL, 0))) {
+					atomic_set(&hostdata->request_limit, 
+						   -1);
 					printk(KERN_ERR
-					       "ibmvscsi: transmit error after"
+					       "ibmvscsi: error after"
 					       " enable\n");
+			}
 		} else {
 			printk(KERN_INFO
 			       "ibmvscsi: Virtual adapter failed rc %d!\n",
 			       crq->format);
 
-			atomic_set(&hostdata->request_limit, -1);
 			purge_requests(hostdata, DID_ERROR);
-			ibmvscsi_reset_crq_queue(&hostdata->queue, hostdata);
+			if ((ibmvscsi_reset_crq_queue(&hostdata->queue,
+							hostdata)) ||
+			    (ibmvscsi_send_crq(hostdata,
+					       0xC001000000000000LL, 0))) {
+					atomic_set(&hostdata->request_limit,
+						   -1);
+					printk(KERN_ERR
+					       "ibmvscsi: error after reset\n");
+			}
 		}
 		scsi_unblock_requests(hostdata->host);
 		return;
@@ -1467,6 +1499,7 @@ static int ibmvscsi_probe(struct vio_dev
 	struct Scsi_Host *host;
 	struct device *dev = &vdev->dev;
 	unsigned long wait_switch = 0;
+	int rc;
 
 	vdev->dev.driver_data = NULL;
 
@@ -1484,8 +1517,8 @@ static int ibmvscsi_probe(struct vio_dev
 	atomic_set(&hostdata->request_limit, -1);
 	hostdata->host->max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-	if (ibmvscsi_init_crq_queue(&hostdata->queue, hostdata,
-				    max_requests) != 0) {
+	rc = ibmvscsi_init_crq_queue(&hostdata->queue, hostdata, max_requests);
+	if (rc != 0 && rc != H_RESOURCE) {
 		printk(KERN_ERR "ibmvscsi: couldn't initialize crq\n");
 		goto init_crq_failed;
 	}
@@ -1505,7 +1538,8 @@ static int ibmvscsi_probe(struct vio_dev
 	 * to fail if the other end is not acive.  In that case we don't
 	 * want to scan
 	 */
-	if (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0) == 0) {
+	if (ibmvscsi_send_crq(hostdata, 0xC001000000000000LL, 0) == 0 
+	    || rc == H_RESOURCE) {
 		/*
 		 * Wait around max init_timeout secs for the adapter to finish
 		 * initializing. When we are done initializing, we will have a
diff --git a/drivers/scsi/ibmvscsi/rpa_vscsi.c b/drivers/scsi/ibmvscsi/rpa_vscsi.c
index 1a9992b..242b887 100644
--- a/drivers/scsi/ibmvscsi/rpa_vscsi.c
+++ b/drivers/scsi/ibmvscsi/rpa_vscsi.c
@@ -208,6 +208,7 @@ int ibmvscsi_init_crq_queue(struct crq_q
 			    int max_requests)
 {
 	int rc;
+	int retrc;
 	struct vio_dev *vdev = to_vio_dev(hostdata->dev);
 
 	queue->msgs = (struct viosrp_crq *)get_zeroed_page(GFP_KERNEL);
@@ -226,7 +227,7 @@ int ibmvscsi_init_crq_queue(struct crq_q
 	gather_partition_info();
 	set_adapter_info(hostdata);
 
-	rc = plpar_hcall_norets(H_REG_CRQ,
+	retrc = rc = plpar_hcall_norets(H_REG_CRQ,
 				vdev->unit_address,
 				queue->msg_token, PAGE_SIZE);
 	if (rc == H_RESOURCE)
@@ -263,7 +264,7 @@ int ibmvscsi_init_crq_queue(struct crq_q
 	tasklet_init(&hostdata->srp_task, (void *)ibmvscsi_task,
 		     (unsigned long)hostdata);
 
-	return 0;
+	return retrc;
 
       req_irq_failed:
 	do {
-- 
1.2.4.gc98264

