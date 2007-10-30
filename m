From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ibmvscsi: Prevent IO during partner login
Date: Tue, 30 Oct 2007 11:37:07 -0500
Message-ID: <20071030163707.GA29228@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:36247 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbXJ3QhU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Oct 2007 12:37:20 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9UGbHHU008898
	for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2007 12:37:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9UGbHZ2466896
	for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2007 12:37:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9UGbGWw001070
	for <linux-scsi@vger.kernel.org>; Tue, 30 Oct 2007 12:37:16 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: santil@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, linux-scsi@vger.kernel.org

By setting the request_limit in send_srp_login to 1 we allowed login
requests to be sent to the server adapter.  If this was not an initial
login, but was a login after a disconnect with the server, other I/O
requests could attempt to be processed before the login occured.  These
I/O requests would fail, sometimes resulting in filesystems getting
marked read-only.

To address this we can set the request_limit to 0 while doing the login
and add an exception where login requests, along with task management
events, are always passed to the server.

There is a case where the request_limit had already reached 0 would result
in all events being sent rather than returning SCSI_MLQUEUE_HOST_BUSY; this
has also been fixed by this patch.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
Signed-off-by: Brian King <brking@linux.vnet.ibm.com>

---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

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
