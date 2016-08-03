From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/22] libfc: use configured lport R_A_TOV when sending exchange
Date: Wed,  3 Aug 2016 15:13:09 +0200
Message-ID: <1470230002-37737-10-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40102 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbcHCNNe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:34 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We should be using the configured R_A_TOV value when sending the
exchange.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index dc078d3..51e7fb1 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -2111,7 +2111,7 @@ static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
 	ep->resp = resp;
 	ep->destructor = destructor;
 	ep->arg = arg;
-	ep->r_a_tov = FC_DEF_R_A_TOV;
+	ep->r_a_tov = lport->r_a_tov;
 	ep->lp = lport;
 	sp = &ep->seq;
 
-- 
1.8.5.6

