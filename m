From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/5] zfcp: Fix oops during shutdown of offline device
Date: Thu, 24 Sep 2009 10:23:23 +0200
Message-ID: <20090924082603.044502000@de.ibm.com>
References: <20090924082320.374328000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:59813 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZIXI0A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Sep 2009 04:26:00 -0400
Content-Disposition: inline; filename=702-zfcp-fallout.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

With the change that the zfcp_adapter struct is only allocated when
the device is set online, the shutdown handler has to check for a
non-existing zfcp_adapter struct. On the other hand, this check is not
necessary in the offline callback, since an online device has the
zfcp_adapter allocated and we go through the offline callback before
removing the ccw device.

Reviewed-by: Felix Beck <felix.beck@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:18.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2009-09-23 10:13:18.000000000 +0200
@@ -192,13 +192,9 @@ static int zfcp_ccw_set_offline(struct c
 
 	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	if (!adapter)
-		goto out;
-
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
 	mutex_unlock(&zfcp_data.config_mutex);
-out:
 	return 0;
 }
 
@@ -253,9 +249,13 @@ static void zfcp_ccw_shutdown(struct ccw
 
 	mutex_lock(&zfcp_data.config_mutex);
 	adapter = dev_get_drvdata(&cdev->dev);
+	if (!adapter)
+		goto out;
+
 	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
+out:
 	mutex_unlock(&zfcp_data.config_mutex);
 }
 

