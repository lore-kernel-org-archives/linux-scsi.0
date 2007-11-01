From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] [v2] ibmvscsi: Prevent IO during partner login
Date: Thu, 1 Nov 2007 18:40:02 -0500
Message-ID: <20071101234002.GG6120@linux.vnet.ibm.com>
References: <20071030163707.GA29228@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:42399 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbXKAXkY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 19:40:24 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA1NeECp024691
	for <linux-scsi@vger.kernel.org>; Thu, 1 Nov 2007 19:40:14 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA1NeEtR111800
	for <linux-scsi@vger.kernel.org>; Thu, 1 Nov 2007 17:40:14 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA1NeDqq023399
	for <linux-scsi@vger.kernel.org>; Thu, 1 Nov 2007 17:40:13 -0600
Content-Disposition: inline
In-Reply-To: <20071030163707.GA29228@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, santil@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

The prior version of this patch introduced a problem for the error
handler routines.  Calling ibmvscsi_eh_reset_device during a
initialization/login would result in the reset failing without need.
 
To avoid failing the eh_* functions while re-attaching to the server
adapter this will retry for a period of time while
ibmvscsi_send_srp_event
returns SCSI_MLQUEUE_HOST_BUSY.
 
By setting the request_limit in send_srp_login to 1 we allowed login
requests to be sent to the server adapter.  If this was not an initial
login, but was a login after a disconnect with the server, other I/O
requests could attempt to be processed before the login occured.
 
To address this we can set the request_limit to 0 while doing the login
and add an exception where login requests, along with task management
events, are always passed to the server.
 
There is a case where the request_limit had already reached 0 would
result
in all events being sent rather than returning SCSI_MLQUEUE_HOST_BUSY;
this
has also been fixed by this patch.
 
Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
 
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   59 ++++++++++++++++++++++++++++++++-------
 1 file changed, 48 insertions(+), 11 deletions(-)

Index: b/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -556,7 +556,7 @@ static int ibmvscsi_send_srp_event(struc
 				   unsigned long timeout)
 {
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
-	int request_status;
+	int request_status = 0;
 	int rc;
 
 	/* If we have exhausted our request limit, just fail this request,
@@ -574,6 +574,13 @@ static int ibmvscsi_send_srp_event(struc
 		if (request_status < -1)
 			goto send_error;
 		/* Otherwise, we may have run out of requests. */
+		/* If request limit was 0 when we started the adapter is in the
+		 * process of performing a login with the server adapter, or
+		 * we may have run out of requests.
+		 */
+		else if (request_status == -1 &&
+		         evt_struct->iu.srp.login_req.opcode != SRP_LOGIN_REQ)
+			goto send_busy;
 		/* Abort and reset calls should make it through.
 		 * Nothing except abort and reset should use the last two
 		 * slots unless we had two or less to begin with.
@@ -633,7 +640,8 @@ static int ibmvscsi_send_srp_event(struc
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
 	free_event_struct(&hostdata->pool, evt_struct);
-	atomic_inc(&hostdata->request_limit);
+	if (request_status != -1)
+		atomic_inc(&hostdata->request_limit);
 	return SCSI_MLQUEUE_HOST_BUSY;
 
  send_error:
@@ -927,10 +935,11 @@ static int send_srp_login(struct ibmvscs
 	login->req_buf_fmt = SRP_BUF_FORMAT_DIRECT | SRP_BUF_FORMAT_INDIRECT;
 	
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
-	/* Start out with a request limit of 1, since this is negotiated in
-	 * the login request we are just sending
+	/* Start out with a request limit of 0, since this is negotiated in
+	 * the login request we are just sending and login requests always
+	 * get sent by the driver regardless of request_limit.
 	 */
-	atomic_set(&hostdata->request_limit, 1);
+	atomic_set(&hostdata->request_limit, 0);
 
 	rc = ibmvscsi_send_srp_event(evt_struct, hostdata, init_timeout * 2);
 	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
@@ -967,6 +976,7 @@ static int ibmvscsi_eh_abort_handler(str
 	int rsp_rc;
 	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
+	unsigned long wait_switch = 0;
 
 	/* First, find this command in our sent list so we can figure
 	 * out the correct tag
@@ -1010,15 +1020,30 @@ static int ibmvscsi_eh_abort_handler(str
 		    tsk_mgmt->lun, tsk_mgmt->task_tag);
 
 	evt->sync_srp = &srp_rsp;
-	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
+	wait_switch = jiffies + (init_timeout * HZ);
+	do {
+		init_completion(&evt->comp);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+
+		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
+			break;
+
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+		msleep(10);
+		spin_lock_irqsave(hostdata->host->host_lock, flags);
+	} while (time_before(jiffies, wait_switch));
+
 	if (rsp_rc != 0) {
+		free_event_struct(&found_evt->hostdata->pool, found_evt);
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
 		sdev_printk(KERN_ERR, cmd->device,
 			    "failed to send abort() event. rc=%d\n", rsp_rc);
 		return FAILED;
 	}
 
+	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
 	wait_for_completion(&evt->comp);
 
 	/* make sure we got a good response */
@@ -1090,6 +1115,7 @@ static int ibmvscsi_eh_device_reset_hand
 	int rsp_rc;
 	unsigned long flags;
 	u16 lun = lun_from_dev(cmd->device);
+	unsigned long wait_switch = 0;
 
 	spin_lock_irqsave(hostdata->host->host_lock, flags);
 	evt = get_event_struct(&hostdata->pool);
@@ -1116,9 +1142,20 @@ static int ibmvscsi_eh_device_reset_hand
 		    tsk_mgmt->lun);
 
 	evt->sync_srp = &srp_rsp;
-	init_completion(&evt->comp);
-	rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
-	spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
+	wait_switch = jiffies + (init_timeout * HZ);
+	do {
+		init_completion(&evt->comp);
+		rsp_rc = ibmvscsi_send_srp_event(evt, hostdata, init_timeout * 2);
+		spin_unlock_irqrestore(hostdata->host->host_lock, flags);
+
+		if (rsp_rc != SCSI_MLQUEUE_HOST_BUSY)
+			break;
+
+		msleep(10);
+		spin_lock_irqsave(hostdata->host->host_lock, flags);
+	} while (time_before(jiffies, wait_switch));
+
 	if (rsp_rc != 0) {
 		sdev_printk(KERN_ERR, cmd->device,
 			    "failed to send reset event. rc=%d\n", rsp_rc);
