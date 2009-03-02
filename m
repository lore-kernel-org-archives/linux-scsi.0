From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 16/18] [PATCH] zfcp: erp failed status bit will not be set
Date: Mon, 02 Mar 2009 13:09:09 +0100
Message-ID: <20090302121004.183095000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:49676 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbZCBMKI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:08 -0500
Content-Disposition: inline; filename=717-zfcp-erp-status-bit.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

It will not be necessary to set the erp failed status bit
in case a SCSI device is removed by the SCSI mid layer.
In the case a SCSI device is unavailable for a short time
(15 to 20 seconds) a FCP unit will not get on-line again.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    1 -
 1 file changed, 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2009-03-01 16:41:36.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2009-03-01 16:41:36.000000000 +0100
@@ -28,7 +28,6 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 	unit->device = NULL;
-	zfcp_erp_unit_failed(unit, "scslvd1", NULL);
 	zfcp_unit_put(unit);
 }
 

