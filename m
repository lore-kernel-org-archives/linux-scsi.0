From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi.c: fix dangling pointer reference
Date: Fri, 31 Dec 2004 13:23:55 -0600
Message-ID: <20041231192355.GC11286@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.36.202]:58579 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S262140AbULaTX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 14:23:57 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id BB5AB5C36A
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 13:23:56 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 05643-01-7 for <linux-scsi@vger.kernel.org>;
 Fri, 31 Dec 2004 13:23:55 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 8578F5C35E
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 13:23:55 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Description: This code has been problematic for a while
and still contained a leg where free_event_struct was
called....followed by a reference to the event_struct.
Restructure to make the code cleaner and fix the dangling
pointer reference.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 09:59:39.346169120 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 09:59:45.793120936 -0600
@@ -87,7 +87,7 @@
 static int init_timeout = 5;
 static int max_requests = 50;
 
-#define IBMVSCSI_VERSION "1.5.3"
+#define IBMVSCSI_VERSION "1.5.4"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -467,7 +467,7 @@
 static int ibmvscsi_send_srp_event(struct srp_event_struct *evt_struct,
 				   struct ibmvscsi_host_data *hostdata)
 {
-	struct scsi_cmnd *cmnd = evt_struct->cmnd;
+	struct scsi_cmnd *cmnd;
 	u64 *crq_as_u64 = (u64 *) &evt_struct->crq;
 	int rc;
 
@@ -479,22 +479,15 @@
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
@@ -511,18 +504,24 @@
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
