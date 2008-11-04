From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/8] zfcp: Wait for port scan to complete when setting adapter online
Date: Tue, 04 Nov 2008 16:35:10 +0100
Message-ID: <20081104153629.586426000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:54668 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbYKDPgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:36:32 -0500
Content-Disposition: inline; filename=scan-wait-online.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Attaching a unit immediately after setting the adapter online should
be possible. The problem right now is that the port_scan runs from a
workqueue and has not finished when the set_online call returns and
the sysfs structures for the ports are not available yet. Fix that by
waiting for the port scan to complete.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_ccw.c	2008-11-04 14:44:04.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-11-04 14:44:27.000000000 +0100
@@ -116,7 +116,9 @@ static int zfcp_ccw_set_online(struct cc
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85,
 				NULL);
 	zfcp_erp_wait(adapter);
-	goto out;
+	up(&zfcp_data.config_sema);
+	flush_work(&adapter->scan_work);
+	return 0;
 
  out_scsi_register:
 	zfcp_erp_thread_kill(adapter);

-- 
