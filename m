From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi.c: limit size of I/O requests, updated
Date: Fri, 31 Dec 2004 11:47:45 -0600
Message-ID: <20041231174745.GA10894@cs.umn.edu>
References: <20041129203107.GB31011@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.32.202]:44458 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S262129AbULaRrr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 12:47:47 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id A7F9A5C373
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 11:47:46 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 28425-01-3 for <linux-scsi@vger.kernel.org>;
 Fri, 31 Dec 2004 11:47:45 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 803E55C36A
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 11:47:45 -0600 (CST)
Content-Disposition: inline
In-Reply-To: <20041129203107.GB31011@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Limit the size of I/O requests sent by the 
ibmvscsi adapter.  With better I/O scheduling (and thus larger
requests) we were breaking some servers.

Updated based on comments from Jens Axboe and James
Bottomley to not specify max I/O sectors as a module
parameter, and subsequently not needlessly store
the value as a static variable.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 10:41:07.430930080 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 10:42:37.518945736 -0600
@@ -87,7 +87,7 @@
 static int init_timeout = 5;
 static int max_requests = 50;
 
-#define IBMVSCSI_VERSION "1.5.1"
+#define IBMVSCSI_VERSION "1.5.2"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -641,11 +641,16 @@
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
+			hostdata->host->max_sectors = 
+				hostdata->madapter_info.port_max_txu[0] >> 9;
 	}
 }
 
@@ -1295,6 +1300,7 @@
 	hostdata->host = host;
 	hostdata->dev = dev;
 	atomic_set(&hostdata->request_limit, -1);
+	hostdata->host->max_sectors = 32 * 8; /* default max I/O 32 pages */
 
 	if (ibmvscsi_init_crq_queue(&hostdata->queue, hostdata,
 				    max_requests) != 0) {
-- 
Dave Boutcher
