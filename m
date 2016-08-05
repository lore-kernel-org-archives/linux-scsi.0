From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/4] libfc: reset exchange manager during LOGO handling
Date: Fri,  5 Aug 2016 14:55:02 +0200
Message-ID: <1470401703-87045-4-git-send-email-hare@suse.de>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45364 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759678AbcHEMzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 08:55:17 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

FC-LS mandates that we should invalidate all sequences before
sending a LOGO. And we should set the event to RPORT_EV_STOP
when a LOGO request has been received to signal that all
exchanges are terminated.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index bfad971..05fccd3 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -489,6 +489,9 @@ static void fc_rport_enter_delete(struct fc_rport_priv *rdata,
  */
 static int fc_rport_logoff(struct fc_rport_priv *rdata)
 {
+	struct fc_lport *lport = rdata->local_port;
+	u32 port_id = rdata->ids.port_id;
+
 	mutex_lock(&rdata->rp_mutex);
 
 	FC_RPORT_DBG(rdata, "Remove port\n");
@@ -498,6 +501,15 @@ static int fc_rport_logoff(struct fc_rport_priv *rdata)
 		FC_RPORT_DBG(rdata, "Port in Delete state, not removing\n");
 		goto out;
 	}
+	/*
+	 * FC-LS states:
+	 * To explicitly Logout, the initiating Nx_Port shall terminate
+	 * other open Sequences that it initiated with the destination
+	 * Nx_Port prior to performing Logout.
+	 */
+	lport->tt.exch_mgr_reset(lport, 0, port_id);
+	lport->tt.exch_mgr_reset(lport, port_id, 0);
+
 	fc_rport_enter_logo(rdata);
 
 	/*
@@ -2082,7 +2094,7 @@ static void fc_rport_recv_logo_req(struct fc_lport *lport, struct fc_frame *fp)
 		FC_RPORT_DBG(rdata, "Received LOGO request while in state %s\n",
 			     fc_rport_state(rdata));
 
-		fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+		fc_rport_enter_delete(rdata, RPORT_EV_STOP);
 		mutex_unlock(&rdata->rp_mutex);
 		kref_put(&rdata->kref, rdata->local_port->tt.rport_destroy);
 	} else
-- 
1.8.5.6

