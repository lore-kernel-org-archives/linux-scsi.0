From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch 2/4] ibmvscsi.c: limit size of I/O requests
Date: Mon, 29 Nov 2004 14:31:07 -0600
Message-ID: <20041129203107.GB31011@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:15767 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261773AbUK2UbQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 15:31:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 954265C383
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:31:08 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 18114-01-10 for <linux-scsi@vger.kernel.org>;
 Mon, 29 Nov 2004 14:31:07 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 5BA495C353
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:31:07 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Limit the size of I/O requests sent by the 
ibmvscsi adapter.  With better I/O scheduling (and thus larger
requests) we were breaking some servers.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 ibmvscsi.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

--- linux-2.6.10-rc1orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:46:58.413032856 -0600
+++ linux-2.6.10-rc1/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 10:46:34.616058720 -0600
@@ -86,8 +86,9 @@
 static int max_channel = 3;
 static int init_timeout = 5;
 static int max_requests = 50;
+static int max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-#define IBMVSCSI_VERSION "1.5.1"
+#define IBMVSCSI_VERSION "1.5.2"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -102,6 +103,8 @@
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
+module_param_named(max_sectors, max_sectors, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(max_sectors, "Maximum sectors per request for this adapter");
 
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs
@@ -641,11 +644,16 @@
 		       evt_struct->xfer_iu->mad.adapter_info.common.status);
 	} else {
 		printk("ibmvscsi: host srp version: %s, "
-		       "host partition %s (%d), OS %d\n",
+		       "host partition %s (%d), OS %d, max io %u\n",
 		       hostdata->madapter_info.srp_version,
 		       hostdata->madapter_info.partition_name,
 		       hostdata->madapter_info.partition_number,
-		       hostdata->madapter_info.os_type);
+		       hostdata->madapter_info.os_type,
+		       hostdata->madapter_info.port_max_txu[0]);
+
+		if (hostdata->madapter_info.port_max_txu[0]) 
+		    hostdata->host->max_sectors = 
+			hostdata->madapter_info.port_max_txu[0] >> 9;
 	}
 }
 
@@ -1295,6 +1303,7 @@
 	hostdata->host = host;
 	hostdata->dev = dev;
 	atomic_set(&hostdata->request_limit, -1);
+	hostdata->host->max_sectors = max_sectors; 
 
 	if (ibmvscsi_init_crq_queue(&hostdata->queue, hostdata,
 				    max_requests) != 0) {
-- 
Dave Boutcher
