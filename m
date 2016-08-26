From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/30] libfc: use configured lport R_A_TOV when sending
Date: Fri, 26 Aug 2016 14:01:28 +0200
Message-ID: <1472212913-39810-6-git-send-email-hare@suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751884AbcHZMCG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 08:02:06 -0400
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We should be using the configured R_A_TOV value when sending the
exchange.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index f178084..7d0e7ca 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2135,7 +2135,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	ep->resp = resp;
 	ep->destructor = destructor;
 	ep->arg = arg;
-	ep->r_a_tov = FC_DEF_R_A_TOV;
+	ep->r_a_tov = lport->r_a_tov;
 	ep->lp = lport;
 	sp = &ep->seq;
 
-- 
1.8.5.6

