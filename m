From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch 3/4] ibmvscsi.c: fix premature loop exit
Date: Mon, 29 Nov 2004 14:32:23 -0600
Message-ID: <20041129203223.GC31011@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.33.102]:55960 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261785AbUK2UcZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 15:32:25 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id 2149B5C37C
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:32:25 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 20154-01-3 for <linux-scsi@vger.kernel.org>;
 Mon, 29 Nov 2004 14:32:23 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id EEC4C5C380
	for <linux-scsi@vger.kernel.org>; Mon, 29 Nov 2004 14:32:23 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Fix a bug where we could fall out of our delay
loop and then forget to scan for drives.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 ibmvscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.10-rc1orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 11:11:07.285070336 -0600
+++ linux-2.6.10-rc1/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-01 11:10:00.846052920 -0600
@@ -88,7 +88,7 @@
 static int max_requests = 50;
 static int max_sectors = 32 * 8; /* default max I/O 32 pages */
 
-#define IBMVSCSI_VERSION "1.5.2"
+#define IBMVSCSI_VERSION "1.5.3"
 
 MODULE_DESCRIPTION("IBM Virtual SCSI");
 MODULE_AUTHOR("Dave Boutcher");
@@ -1335,7 +1335,7 @@
 		 */
 		for (wait_switch = jiffies + (init_timeout * HZ);
 		     time_before(jiffies, wait_switch) &&
-		     atomic_read(&hostdata->request_limit) < 0;) {
+		     atomic_read(&hostdata->request_limit) < 2;) {
 
 			msleep(10);
 		}
-- 
Dave Boutcher
