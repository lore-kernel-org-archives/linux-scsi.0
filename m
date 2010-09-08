From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/12] zfcp: Remove duplicated code from zfcp_ccw_set_online
Date: Wed, 08 Sep 2010 14:40:00 +0200
Message-ID: <20100908124354.230233573@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:56824 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab0IHMn4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:56 -0400
Content-Disposition: inline; filename=710-zfcp-duplicate-code.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The steps for setting the zfcp_adapter online are the same in
zfcp_ccw_set_online and zfcp_ccw_activate. Remove the code duplication
by calling zfcp_ccw_activate from zfcp_ccw_set_online.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_ccw.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2010-09-08 08:49:31.000000000 +0200
@@ -164,14 +164,7 @@ static int zfcp_ccw_set_online(struct cc
 	BUG_ON(!zfcp_reqlist_isempty(adapter->req_list));
 	adapter->req_no = 0;
 
-	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
-				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-				"ccsonl2", NULL);
-	zfcp_erp_wait(adapter);
-
-	flush_work(&adapter->scan_work);
-
+	zfcp_ccw_activate(cdev);
 	zfcp_ccw_adapter_put(adapter);
 	return 0;
 }

