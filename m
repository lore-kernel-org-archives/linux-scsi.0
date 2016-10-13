From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 16/24] libfc: Do not drop out-of-order frames
Date: Thu, 13 Oct 2016 15:10:52 +0200
Message-ID: <1476364260-12191-17-git-send-email-hare@suse.de>
References: <1476364260-12191-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751317AbcJMNeC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 09:34:02 -0400
In-Reply-To: <1476364260-12191-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When receiving packets from the network we cannot guarantee any
frame ordering, so we should be receiving all valid frames and
let the upper layers deal with it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Acked-by: Johannes Thumshirn <jth@kernel.org>
---
 drivers/scsi/libfc/fc_exch.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 5868824..c62fc27 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1592,9 +1592,6 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
 	if (fc_sof_is_init(sof)) {
 		sp->ssb_stat |= SSB_ST_RESP;
 		sp->id = fh->fh_seq_id;
-	} else if (sp->id != fh->fh_seq_id) {
-		atomic_inc(&mp->stats.seq_not_found);
-		goto rel;
 	}
 
 	f_ctl = ntoh24(fh->fh_f_ctl);
-- 
1.8.5.6

