From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi.c: fix loop exit condition
Date: Fri, 31 Dec 2004 13:22:32 -0600
Message-ID: <20041231192232.GB11286@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:52690 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S262139AbULaTWe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Dec 2004 14:22:34 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 0ABA75C373
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 13:22:34 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 05503-01-10 for <linux-scsi@vger.kernel.org>;
 Fri, 31 Dec 2004 13:22:33 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id F18FA5C35E
	for <linux-scsi@vger.kernel.org>; Fri, 31 Dec 2004 13:22:32 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Description: Fix a bug where we could fall out of our delay
loop and then forget to scan for drives.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 09:59:23.762143064 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-31 09:59:39.346169120 -0600
@@ -87,7 +87,7 @@
 static int init_timeout = 5;
 static int max_requests = 50;
 
-#define IBMVSCSI_VERSION "1.5.2"
+#define IBMVSCSI_VERSION "1.5.3"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -1333,7 +1333,7 @@
 		 */
 		for (wait_switch = jiffies + (init_timeout * HZ);
 		     time_before(jiffies, wait_switch) &&
-		     atomic_read(&hostdata->request_limit) < 0;) {
+		     atomic_read(&hostdata->request_limit) < 2;) {
 
 			msleep(10);
 		}

-- 
Dave Boutcher
