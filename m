From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/22] zfcp: Remove suspend callback
Date: Tue, 24 Nov 2009 16:54:01 +0100
Message-ID: <20091124160136.668466000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.17.164]:39600 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404AbZKXQCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:02:16 -0500
Content-Disposition: inline; filename=703-zfcp-suspend-callback.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The callback for suspend is not required because it contains exactly
the same functionality as the _set_offline routine does.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:39.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-11-23 09:59:39.000000000 +0100
@@ -37,22 +37,6 @@ void zfcp_ccw_adapter_put(struct zfcp_ad
 	spin_unlock_irqrestore(&zfcp_ccw_adapter_ref_lock, flags);
 }
 
-static int zfcp_ccw_suspend(struct ccw_device *cdev)
-
-{
-	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
-
-	if (!adapter)
-		return 0;
-
-	zfcp_erp_adapter_shutdown(adapter, 0, "ccsusp1", NULL);
-	zfcp_erp_wait(adapter);
-
-	zfcp_ccw_adapter_put(adapter);
-
-	return 0;
-}
-
 static int zfcp_ccw_activate(struct ccw_device *cdev)
 
 {
@@ -291,7 +275,7 @@ struct ccw_driver zfcp_ccw_driver = {
 	.set_offline = zfcp_ccw_set_offline,
 	.notify      = zfcp_ccw_notify,
 	.shutdown    = zfcp_ccw_shutdown,
-	.freeze      = zfcp_ccw_suspend,
+	.freeze      = zfcp_ccw_set_offline,
 	.thaw	     = zfcp_ccw_activate,
 	.restore     = zfcp_ccw_activate,
 };

