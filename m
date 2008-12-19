From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 02/11] zfcp: register with SCSI layer on ccw registration
Date: Fri, 19 Dec 2008 16:56:53 +0100
Message-ID: <20081219155751.078812000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61125 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYLSP5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:54 -0500
Content-Disposition: inline; filename=707-zfcp-scsi-reg.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Synchronize the registration and de-registration with the SCSI layer
at CCW registration, de-registration. Before we registered with the
SCSI layer on adapter activation. This way the reg and de-reg process
is in balance.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 drivers/s390/scsi/zfcp_ccw.c |    6 ------
 2 files changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-12-19 14:38:26.000000000 +0100
@@ -516,7 +516,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	zfcp_fc_nameserver_init(adapter);
 
-	return 0;
+	if (!zfcp_adapter_scsi_register(adapter))
+		return 0;
 
 sysfs_failed:
 	zfcp_adapter_debug_unregister(adapter);
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-12-19 14:38:13.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-12-19 14:38:26.000000000 +0100
@@ -103,10 +103,6 @@ static int zfcp_ccw_set_online(struct cc
 	if (retval)
 		goto out;
 
-	retval = zfcp_adapter_scsi_register(adapter);
-	if (retval)
-		goto out_scsi_register;
-
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
@@ -120,8 +116,6 @@ static int zfcp_ccw_set_online(struct cc
 	flush_work(&adapter->scan_work);
 	return 0;
 
- out_scsi_register:
-	zfcp_erp_thread_kill(adapter);
  out:
 	up(&zfcp_data.config_sema);
 	return retval;

-- 
