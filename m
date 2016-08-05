From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/4] libfc: do not send ABTS when resetting exchanges
Date: Fri,  5 Aug 2016 14:55:03 +0200
Message-ID: <1470401703-87045-5-git-send-email-hare@suse.de>
References: <1470401703-87045-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759617AbcHEMzR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Aug 2016 08:55:17 -0400
In-Reply-To: <1470401703-87045-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When all exchanges are reset the upper layers have already logged
out of the remote port, so the exchanges can be reset without
sending any ABTS.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 3e9275f..823cc31 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1860,7 +1860,6 @@ static void fc_exch_reset(struct fc_exch *ep)
 	int rc = 1;
 
 	spin_lock_bh(&ep->ex_lock);
-	fc_exch_abort_locked(ep, 0);
 	ep->state |= FC_EX_RST_CLEANUP;
 	fc_exch_timer_cancel(ep);
 	if (ep->esb_stat & ESB_ST_REC_QUAL)
-- 
1.8.5.6

