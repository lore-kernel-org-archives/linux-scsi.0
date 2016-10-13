From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 19/24] libfc: Check xid when looking up REC exchanges
Date: Thu, 13 Oct 2016 15:10:55 +0200
Message-ID: <1476364260-12191-20-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752030AbcJMNeF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:34:05 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We currently can only lookup the local xid, so we need
to reject REC with empty rxid.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index c62fc27..4c69a99 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2000,8 +2000,7 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	enum fc_els_rjt_reason reason = ELS_RJT_LOGIC;
 	enum fc_els_rjt_explan explan;
 	u32 sid;
-	u16 rxid;
-	u16 oxid;
+	u16 xid, rxid, oxid;
 
 	lport = fr_dev(rfp);
 	rp = fc_frame_payload_get(rfp, sizeof(*rp));
@@ -2012,9 +2011,18 @@ static void fc_exch_els_rec(struct fc_frame *rfp)
 	rxid = ntohs(rp->rec_rx_id);
 	oxid = ntohs(rp->rec_ox_id);
 
-	ep = fc_exch_lookup(lport,
-			    sid == fc_host_port_id(lport->host) ? oxid : rxid);
 	explan = ELS_EXPL_OXID_RXID;
+	if (sid == fc_host_port_id(lport->host))
+		xid = oxid;
+	else
+		xid = rxid;
+	if (xid == FC_XID_UNKNOWN) {
+		FC_LPORT_DBG(lport,
+			     "REC request from %x: invalid rxid %x oxid %x\n",
+			     sid, rxid, oxid);
+		goto reject;
+	}
+	ep = fc_exch_lookup(lport, xid);
 	if (!ep) {
 		FC_LPORT_DBG(lport,
 			     "REC request from %x: rxid %x oxid %x not found\n",
-- 
1.8.5.6

