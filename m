From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 20/22] libfc: Do not drop out-of-order frames
Date: Wed,  3 Aug 2016 15:13:20 +0200
Message-ID: <1470230002-37737-21-git-send-email-hare@suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756013AbcHCNNg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Aug 2016 09:13:36 -0400
In-Reply-To: <1470230002-37737-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When receiving packets from the network we cannot guarantee any
frame ordering, so we should be receiving all valid frames and
let the upper layers deal with it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/libfc/fc_exch.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 26a43b3..3e9275f 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1578,9 +1578,6 @@ static void fc_exch_recv_seq_resp(struct fc_exch_mgr *mp, struct fc_frame *fp)
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

