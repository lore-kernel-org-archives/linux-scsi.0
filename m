From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] [SCSI] scsi/osd: Remove redundant unlikely()
Date: Thu,  9 Dec 2010 15:56:24 +0100
Message-ID: <1291906584-1198-1-git-send-email-tklauser@distanz.ch>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.zhaw.ch ([160.85.104.50]:64188 "EHLO mx1.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219Ab0LIPDV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Dec 2010 10:03:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: osd-dev@open-osd.org, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

IS_ERR() already implies unlikely(), so it can be omitted here.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/scsi/osd/osd_initiator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index b798919..b37c8a3 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -951,7 +951,7 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	/* create a bio for continuation segment */
 	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
 			   GFP_KERNEL);
-	if (unlikely(IS_ERR(bio)))
+	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
 	bio->bi_rw |= REQ_WRITE;
-- 
1.7.0.4

