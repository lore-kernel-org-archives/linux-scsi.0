From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/6] zfcp: channel cannot be detached due to refcount imbalance
Date: Thu, 21 Aug 2008 13:43:36 +0200
Message-ID: <20080821114558.971074000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:55951 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757765AbYHULqC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:46:02 -0400
Content-Disposition: inline; filename=705-zfcp-imbalance.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Due to an imbalance of the nameserver refcounting, channel devices
couldn't be take offline anymore after the channel was activated.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    1 -
 1 file changed, 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:36.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:36.000000000 +0200
@@ -352,7 +352,6 @@ static int zfcp_scan_get_nameserver(stru
 		if (ret)
 			return ret;
 		zfcp_erp_wait(adapter);
-		zfcp_port_put(adapter->nameserver_port);
 	}
 	return !atomic_test_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				  &adapter->nameserver_port->status);

-- 
