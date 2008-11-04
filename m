From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/8] zfcp: Dont clear reference from SCSI device to unit
Date: Tue, 04 Nov 2008 16:35:05 +0100
Message-ID: <20081104153626.151079000@de.ibm.com>
References: <20081104153504.606043000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:58675 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYKDPh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Nov 2008 10:37:29 -0500
Content-Disposition: inline; filename=fix-abort-after-port-off-on.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Swen Schillig <swen@vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

It is possible that a remote port has a problem, the SCSI device gets
deleted after the rport timeout and then the timeout for pending SCSI
commands trigger an abort. For this case, don't delete the reference
from the SCSI device to the zfcp unit, so that we can still have the
reference to issue an abort request.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-11-04 14:44:04.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-11-04 14:44:11.000000000 +0100
@@ -24,14 +24,10 @@ char *zfcp_get_fcp_sns_info_ptr(struct f
 static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
-	WARN_ON(!unit);
-	if (unit) {
-		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
-		sdpnt->hostdata = NULL;
-		unit->device = NULL;
-		zfcp_erp_unit_failed(unit, 12, NULL);
-		zfcp_unit_put(unit);
-	}
+	atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
+	unit->device = NULL;
+	zfcp_erp_unit_failed(unit, 12, NULL);
+	zfcp_unit_put(unit);
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)

-- 
