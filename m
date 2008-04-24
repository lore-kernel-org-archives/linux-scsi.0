From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/3] zfcp: Wait for free SBAL during exchange config
Date: Thu, 24 Apr 2008 19:35:52 +0200
Message-ID: <20080424174054.921726000@de.ibm.com>
References: <20080424173551.821393000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:2058 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbYDXRk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 13:40:57 -0400
Content-Disposition: inline; filename=zfcp-stat-sbal-wait.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

When sending a exchange config data command, wait for a free SBAL.
This does not matter during adapter initialization, but this is
required for pulling adapter statistics during high I/O load.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fsf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fsf.c	2008-04-24 15:06:33.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-04-24 15:06:34.000000000 +0200
@@ -1927,7 +1927,8 @@ zfcp_fsf_exchange_config_data_sync(struc
 
 	/* setup new FSF request */
 	retval = zfcp_fsf_req_create(adapter, FSF_QTCB_EXCHANGE_CONFIG_DATA,
-				     0, NULL, &lock_flags, &fsf_req);
+				     ZFCP_WAIT_FOR_SBAL, NULL, &lock_flags,
+				     &fsf_req);
 	if (retval) {
 		ZFCP_LOG_INFO("error: Could not create exchange configuration "
 			      "data request for adapter %s.\n",

-- 
