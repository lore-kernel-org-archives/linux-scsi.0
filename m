From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] zfcp: Revert to original scanning behaviour
Date: Fri,  8 Apr 2016 08:14:54 +0200
Message-ID: <1460096094-126214-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcDHGO5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Apr 2016 02:14:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

zfcp has its own mechanism for selective scanning, so revert to
the original scanning behaviour to not confuse users.

Fixes: 4e91e876e9b8b6eb4255aa0d690778a89d3f1d28
Suggested-by: Benjamin Block <bblock@linux.vnet.ibm.com>
Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/s390/scsi/zfcp_unit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/scsi/zfcp_unit.c b/drivers/s390/scsi/zfcp_unit.c
index 08bba7c..9310a54 100644
--- a/drivers/s390/scsi/zfcp_unit.c
+++ b/drivers/s390/scsi/zfcp_unit.c
@@ -27,7 +27,7 @@ void zfcp_unit_scsi_scan(struct zfcp_unit *unit)
 
 	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
 		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id, lun,
-				 SCSI_SCAN_RESCAN);
+				 SCSI_SCAN_MANUAL);
 }
 
 static void zfcp_unit_scsi_scan_work(struct work_struct *work)
-- 
1.8.5.6

