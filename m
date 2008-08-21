From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 3/6] zfcp: Simplify ccw notify handler
Date: Thu, 21 Aug 2008 13:43:34 +0200
Message-ID: <20080821114557.331301000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:47146 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117AbYHULrI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:47:08 -0400
Content-Disposition: inline; filename=703-zfcp-notify.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Christof Schmitt <christof.schmitt@de.ibm.com>, Martin Petermann <martin@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The notify handler does not change the list of adapters, it only
triggers erp actions to open or shutdown the adapter. We don't
need to hold the config semaphore and wait for the erp to complete.

This is a prerequisite for a fix in the s390 common i/o code.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2008-08-20 14:41:08.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2008-08-20 14:41:34.000000000 +0200
@@ -152,10 +152,8 @@ static int zfcp_ccw_set_offline(struct c
  */
 static int zfcp_ccw_notify(struct ccw_device *ccw_device, int event)
 {
-	struct zfcp_adapter *adapter;
+	struct zfcp_adapter *adapter = dev_get_drvdata(&ccw_device->dev);
 
-	down(&zfcp_data.config_sema);
-	adapter = dev_get_drvdata(&ccw_device->dev);
 	switch (event) {
 	case CIO_GONE:
 		dev_warn(&adapter->ccw_device->dev, "device gone\n");
@@ -174,8 +172,6 @@ static int zfcp_ccw_notify(struct ccw_de
 					89, NULL);
 		break;
 	}
-	zfcp_erp_wait(adapter);
-	up(&zfcp_data.config_sema);
 	return 1;
 }
 

-- 
