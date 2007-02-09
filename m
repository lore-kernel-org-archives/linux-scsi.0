From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ibmvscsi: allow for dynamic adjustment of server request_limit
Date: Fri, 09 Feb 2007 11:49:55 -0600
Message-ID: <20070209174955.5080.80326.sendpatchset@toy>
References: <20070209174949.5080.69663.sendpatchset@toy>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:48605 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992463AbXBIRuK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Feb 2007 12:50:10 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.11.20060308/8.13.8) with ESMTP id l19HnfdI006901
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 12:49:41 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.2) with ESMTP id l19Ho4Yi478624
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:50:04 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l19HntLE002515
	for <linux-scsi@vger.kernel.org>; Fri, 9 Feb 2007 10:49:55 -0700
In-Reply-To: <20070209174949.5080.69663.sendpatchset@toy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Robert Jennings <rcj@linux.vnet.ibm.com>

The request limit calculations used previously on the client failed to
mirror the state of the server.  Additionally, when a value < 3 was provided
there could be problems setting can_queue and handling abort and reset 
commands.

Signed-off-by: "Robert Jennings" <rcj@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c |   58 +++++++++++++++++++++++++--------------
 drivers/scsi/ibmvscsi/ibmvscsi.h |    2 +
 2 files changed, 40 insertions(+), 20 deletions(-)

Index: ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- ibmvscsi-23509.orig/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -85,7 +85,7 @@
 static int max_id = 64;
 static int max_channel = 3;
 static int init_timeout = 5;
-static int max_requests = 50;
+static int max_requests = IBMVSCSI_MAX_REQUESTS_DEFAULT;
 
 #define IBMVSCSI_VERSION "1.5.8"
 
@@ -538,7 +538,8 @@
 	int request_status;
 	int rc;
 
-	/* If we have exhausted our request limit, just fail this request.
+	/* If we have exhausted our request limit, just fail this request,
+	 * unless it is for a reset or abort.
 	 * Note that there are rare cases involving driver generated requests 
 	 * (such as task management requests) that the mid layer may think we
 	 * can handle more requests (can_queue) when we actually can't
@@ -551,9 +552,30 @@
 		 */
 		if (request_status < -1)
 			goto send_error;
-		/* Otherwise, if we have run out of requests */
-		else if (request_status < 0)
-			goto send_busy;
+		/* Otherwise, we may have run out of requests. */
+		/* Abort and reset calls should make it through.
+		 * Nothing except abort and reset should use the last two
+		 * slots unless we had two or less to begin with.
+		 */
+		else if (request_status < 2 &&
+		         evt_struct->iu.srp.cmd.opcode != SRP_TSK_MGMT) {
+			/* In the case that we have less than two requests
+			 * available, check the server limit as a combination
+			 * of the request limit and the number of requests
+			 * in-flight (the size of the send list).  If the
+			 * server limit is greater than 2, return busy so
+			 * that the last two are reserved for reset and abort.
+			 */
+			int server_limit = request_status;
+			struct srp_event_struct *tmp_evt;
+
+			list_for_each_entry(tmp_evt, &hostdata->sent, list) {
+				server_limit++;
+			}
+
+			if (server_limit > 2)
+				goto send_busy;
+		}
 	}
 
 	/* Copy the IU into the transfer area */
@@ -572,6 +594,7 @@
 
 		printk(KERN_ERR "ibmvscsi: send error %d\n",
 		       rc);
+		atomic_inc(&hostdata->request_limit);
 		goto send_error;
 	}
 
@@ -581,7 +604,8 @@
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
 
 	free_event_struct(&hostdata->pool, evt_struct);
- 	return SCSI_MLQUEUE_HOST_BUSY;
+	atomic_inc(&hostdata->request_limit);
+	return SCSI_MLQUEUE_HOST_BUSY;
 
  send_error:
 	unmap_cmd_data(&evt_struct->iu.srp.cmd, evt_struct, hostdata->dev);
@@ -831,23 +855,16 @@
 
 	printk(KERN_INFO "ibmvscsi: SRP_LOGIN succeeded\n");
 
-	if (evt_struct->xfer_iu->srp.login_rsp.req_lim_delta >
-	    (max_requests - 2))
-		evt_struct->xfer_iu->srp.login_rsp.req_lim_delta =
-		    max_requests - 2;
+	if (evt_struct->xfer_iu->srp.login_rsp.req_lim_delta < 0)
+		printk(KERN_ERR "ibmvscsi: Invalid request_limit.\n");
 
-	/* Now we know what the real request-limit is */
+	/* Now we know what the real request-limit is.
+	 * This value is set rather than added to request_limit because
+	 * request_limit could have been set to -1 by this client.
+	 */
 	atomic_set(&hostdata->request_limit,
 		   evt_struct->xfer_iu->srp.login_rsp.req_lim_delta);
 
-	hostdata->host->can_queue =
-	    evt_struct->xfer_iu->srp.login_rsp.req_lim_delta - 2;
-
-	if (hostdata->host->can_queue < 1) {
-		printk(KERN_ERR "ibmvscsi: Invalid request_limit_delta\n");
-		return;
-	}
-
 	/* If we had any pending I/Os, kick them */
 	scsi_unblock_requests(hostdata->host);
 
@@ -1483,7 +1500,7 @@
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
 	.cmd_per_lun = 16,
-	.can_queue = 1,		/* Updated after SRP_LOGIN */
+	.can_queue = IBMVSCSI_MAX_REQUESTS_DEFAULT,
 	.this_id = -1,
 	.sg_tablesize = SG_ALL,
 	.use_clustering = ENABLE_CLUSTERING,
@@ -1503,6 +1520,7 @@
 
 	vdev->dev.driver_data = NULL;
 
+	driver_template.can_queue = max_requests;
 	host = scsi_host_alloc(&driver_template, sizeof(*hostdata));
 	if (!host) {
 		printk(KERN_ERR "ibmvscsi: couldn't allocate host data\n");
Index: ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.h
===================================================================
--- ibmvscsi-23509.orig/drivers/scsi/ibmvscsi/ibmvscsi.h
+++ ibmvscsi-23509/drivers/scsi/ibmvscsi/ibmvscsi.h
@@ -44,6 +44,8 @@
  */
 #define MAX_INDIRECT_BUFS 10
 
+#define IBMVSCSI_MAX_REQUESTS_DEFAULT 100
+
 /* ------------------------------------------------------------
  * Data Structures
  */
