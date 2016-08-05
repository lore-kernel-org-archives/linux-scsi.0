From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] libfc: send LOGO for PLOGI failure
Date: Fri,  5 Aug 2016 14:55:01 +0200
Message-ID: <1470401703-87045-3-git-send-email-hare@suse.de>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759668AbcHEMzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 08:55:17 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When running in point-to-multipoint mode PLOGI is done after
FLOGI completed. So when the PLOGI fails we should be sending
a LOGO to the remote port.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 0ea0d4f..bfad971 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -593,15 +593,23 @@ static void fc_rport_timeout(struct work_struct *work)
  */
 static void fc_rport_error(struct fc_rport_priv *rdata, int err)
 {
+	struct fc_lport *lport = rdata->local_port;
+
 	FC_RPORT_DBG(rdata, "Error %d in state %s, retries %d\n",
 		     -err, fc_rport_state(rdata), rdata->retries);
 
 	switch (rdata->rp_state) {
 	case RPORT_ST_FLOGI:
-	case RPORT_ST_PLOGI:
 		rdata->flags &= ~FC_RP_STARTED;
 		fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
 		break;
+	case RPORT_ST_PLOGI:
+		if (lport->point_to_multipoint) {
+			rdata->flags &= ~FC_RP_STARTED;
+			fc_rport_enter_delete(rdata, RPORT_EV_FAILED);
+		} else
+			fc_rport_enter_logo(rdata);
+		break;
 	case RPORT_ST_RTV:
 		fc_rport_enter_ready(rdata);
 		break;
-- 
1.8.5.6

