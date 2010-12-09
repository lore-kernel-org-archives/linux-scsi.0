From: Joe Perches <joe@perches.com>
Subject: [PATCH 05/15] osd: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:58 -0800
Message-ID: <786f4b066afe0eb7303f991f936b2643bcfc2d86.1291923889.git.joe@perches.com>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>
Cc: Jiri Kosina <trivial@kernel.org>, "James E.J. Bottomley" <James.Bottomley@suse.de>, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
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
1.7.3.3.464.gf80b6
