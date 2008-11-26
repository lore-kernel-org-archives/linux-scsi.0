From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/6] zfcp: verify for correct rport state before scanning for SCSI devs
Date: Wed, 26 Nov 2008 18:07:38 +0100
Message-ID: <20081126171020.354678000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:44899 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYKZRKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:23 -0500
Content-Disposition: inline; filename=702-zfcp-rport.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Prevent a SCSI target scan for a rport which have turned invalid
in the meantime.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-11-26 16:17:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-11-26 16:42:53.000000000 +0100
@@ -1186,7 +1186,9 @@ static void zfcp_erp_scsi_scan(struct wo
 		container_of(work, struct zfcp_erp_add_work, work);
 	struct zfcp_unit *unit = p->unit;
 	struct fc_rport *rport = unit->port->rport;
-	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+
+	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
+		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
 			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
 	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
 	zfcp_unit_put(unit);

-- 
