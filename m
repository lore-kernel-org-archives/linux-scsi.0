From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/24] libfc: use configured lport R_A_TOV
Date: Thu, 13 Oct 2016 15:10:39 +0200
Message-ID: <1476364260-12191-4-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932273AbcJMNMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:12:36 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

We should be using the configured R_A_TOV value when sending the
exchange.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index b4bdc90..5e0a57f 100644
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

