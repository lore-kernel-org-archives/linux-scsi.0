From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] fix more ipr kref problems
Date: 29 Aug 2004 17:51:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093816265.1708.45.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:18374 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268340AbUH2VvR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Aug 2004 17:51:17 -0400
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

This was caused by

KREF: make kref_get() return void as it makes sense to do so.
  
drivers/scsi/ipr.c: In function `ipr_worker_thread':
drivers/scsi/ipr.c:1825: error: wrong type argument to unary exclamation
mark
make[2]: *** [drivers/scsi/ipr.o] Error 1

The fix is fairly simple.

James

===== drivers/scsi/ipr.c 1.25 vs edited =====
--- 1.25/drivers/scsi/ipr.c	2004-08-16 01:40:17 -05:00
+++ edited/drivers/scsi/ipr.c	2004-08-29 16:25:31 -05:00
@@ -1822,10 +1822,11 @@
 
 	if (ioa_cfg->sdt_state == GET_DUMP) {
 		dump = ioa_cfg->dump;
-		if (!dump || !kref_get(&dump->kref)) {
+		if (!dump) {
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 			return;
 		}
+		kref_get(&dump->kref);
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		ipr_get_ioa_dump(ioa_cfg, dump);
 		kref_put(&dump->kref, ipr_release_dump);
@@ -2423,11 +2424,11 @@
 	spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
 	dump = ioa_cfg->dump;
 
-	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump || !kref_get(&dump->kref)) {
+	if (ioa_cfg->sdt_state != DUMP_OBTAINED || !dump) {
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 		return 0;
 	}
-
+	kref_get(&dump->kref);
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
 	if (off > dump->driver_dump.hdr.len) {

