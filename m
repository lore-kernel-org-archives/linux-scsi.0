From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/11] zfcp: wait until adapter is finished with ERP during auto-port
Date: Wed, 02 Jul 2008 10:56:31 +0200
Message-ID: <20080702085946.770044000@de.ibm.com>
References: <20080702085630.473635000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:50882 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbYGBI7u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 04:59:50 -0400
Content-Disposition: inline; filename=zfcp_auto_port_erp_race.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

In some situations the auto port attachment task is started
before the ERP is finished. To prevent this unwanted situation
we wait until the adapter is up and running before we start our work.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_fc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/s390/scsi/zfcp_fc.c	2008-06-27 18:07:02.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-06-27 18:07:26.000000000 +0200
@@ -520,6 +520,7 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
 
+	zfcp_erp_wait(adapter); /* wait until adapter is finished with ERP */
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
 

-- 
