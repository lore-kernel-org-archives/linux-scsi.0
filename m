From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch 4/4] ibmvscsi.c: fix dangling pointer reference
Date: Mon, 29 Nov 2004 14:33:54 -0600
Message-ID: <20041129203354.GD31011@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:16282 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261788AbUK2UeD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 15:34:03 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id C100D5C383
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:33:55 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 21584-01-8 for <linux-scsi@vger.kernel.org>;
 Mon, 29 Nov 2004 14:33:54 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 4A3965C37C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:33:54 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: This code has been problematic for a while
and still contained a leg where free_event_struct was
called....followed by a reference to the event_struct.
Restructure to make the code cleaner and fix the dangling
pointer reference.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 ibmvscsi.c |   49 ++++++++++++++++++++++++-------------------------
 1 files changed, 24 insertions(+), 25 deletions(-)

--- linux-2.6.10-rc1orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:49:28.042047904 -0600
+++ linux-2.6.10-rc1/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:50:00.215083800 -0600
@@ -88,7 +88,7 @@
 static int max_requests = 50;
 static int max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-#define IBMVSCSI_VERSION "1.5.3"
+#define IBMVSCSI_VERSION "1.5.4"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -470,7 +470,7 @@
 static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 				   struct ibmvscsi_host_data *hostdata)
 {
-	struct scsi_cmnd *cmnd = evt_struct->cmnd;
+	struct scsi_cmnd *cmnd;
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
 	int rc;
 
@@ -482,22 +482,15 @@
 	if ((evt_struct->crq.format == VIOSRP_SRP_FORMAT) &&
 	    (atomic_dec_if_positive(&hostdata->request_limit) < 0)) {
 		/* See if the adapter is disabled */
-		if (atomic_read(&hostdata->request_limit) < 0) {
-			if (cmnd)
-				cmnd->result = DID_ERROR << 16;
-			if (evt_struct->cmnd_done)
-				evt_struct->cmnd_done(cmnd);
-			unmap_cmd_data(&evt_struct->iu.srp.cmd,
-				       hostdata->dev);
-			free_event_struct(&hostdata->pool, evt_struct);
-			return 0;
-		} else {
-			printk("ibmvscsi: Warning, request_limit exceeded\n");
-			unmap_cmd_data(&evt_struct->iu.srp.cmd,
-				       hostdata->dev);
-			free_event_struct(&hostdata->pool, evt_struct);
-			return SCSI_MLQUEUE_HOST_BUSY;
-		}
+		if (atomic_read(&hostdata->request_limit) < 0)
+			goto send_error;
+	
+		printk(KERN_WARNING 
+		       "ibmvscsi: Warning, request_limit exceeded\n");
+		unmap_cmd_data(&evt_struct->iu.srp.cmd,
+			       hostdata->dev);
+		free_event_struct(&hostdata->pool, evt_struct);
+		return SCSI_MLQUEUE_HOST_BUSY;
 	}
 
 	/* Copy the IU into the transfer area */
@@ -514,18 +507,24 @@
 	     ibmvscsi_send_crq(hostdata, crq_as_u64[0], crq_as_u64[1])) != 0) {
 		list_del(&evt_struct->list);
 
-		cmnd = evt_struct->cmnd;
 		printk(KERN_ERR "ibmvscsi: failed to send event struct rc %d\n",
 		       rc);
-		unmap_cmd_data(&evt_struct->iu.srp.cmd, hostdata->dev);
-		free_event_struct(&hostdata->pool, evt_struct);
-		if (cmnd)
-			cmnd->result = DID_ERROR << 16;
-		if (evt_struct->cmnd_done)
-			evt_struct->cmnd_done(cmnd);
+		goto send_error;
 	}
 
 	return 0;
+
+ send_error:
+	unmap_cmd_data(&evt_struct->iu.srp.cmd, hostdata->dev);
+
+	if ((cmnd = evt_struct->cmnd) != NULL) {
+		cmnd->result = DID_ERROR << 16;
+		evt_struct->cmnd_done(cmnd);
+	} else if (evt_struct->done)
+		evt_struct->done(evt_struct);
+	
+	free_event_struct(&hostdata->pool, evt_struct);
+	return 0;
 }
 
 /**
-- 
Dave Boutcher
