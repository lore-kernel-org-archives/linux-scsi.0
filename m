From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] libfc: Issue PRLI after a PRLO has been received
Date: Fri,  5 Aug 2016 14:55:00 +0200
Message-ID: <1470401703-87045-2-git-send-email-hare@suse.de>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45360 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667AbcHEMzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 08:55:17 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When receiving a PRLO it just means that the operating parameters
have changed, it does _not_ mean that the port doesn't want to
communicate with us.
So instead of implicitly logging out we should be issueing a PRLI
to figure out the new operating parameters.
We can always recover once PRLI fails.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_rport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_rport.c b/drivers/scsi/libfc/fc_rport.c
index 7fb6685..0ea0d4f 100644
--- a/drivers/scsi/libfc/fc_rport.c
+++ b/drivers/scsi/libfc/fc_rport.c
@@ -2034,7 +2034,7 @@ static void fc_rport_recv_prlo_req(struct fc_rport_priv *rdata,
 	spp->spp_type_ext = rspp->spp_type_ext;
 	spp->spp_flags = FC_SPP_RESP_ACK;
 
-	fc_rport_enter_delete(rdata, RPORT_EV_LOGO);
+	fc_rport_enter_prli(rdata);
 
 	fc_fill_reply_hdr(fp, rx_fp, FC_RCTL_ELS_REP, 0);
 	lport->tt.frame_send(lport, fp);
-- 
1.8.5.6

