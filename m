From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH v2] [SCSI] sd: consolidate sector size alignment check in sd_prep_fn
Date: Wed,  3 Aug 2011 10:03:24 +0900
Message-ID: <1312333404-3088-1-git-send-email-namhyung@gmail.com>
References: <1312302550.11352.9.camel@mulgrave>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52589 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab1HCBFa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2011 21:05:30 -0400
In-Reply-To: <1312302550.11352.9.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Generalize common code to reduce code duplication.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/sd.c |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773cb26d9..fb9d997ece9d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -651,6 +651,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	unsigned int this_count = blk_rq_sectors(rq);
 	int ret, host_dif;
 	unsigned char protect;
+	int sector_shift;
 
 	/*
 	 * Discard request come in as REQ_TYPE_FS but we turn them into
@@ -735,36 +736,23 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * and not force the scsi disk driver to use bounce buffers
 	 * for this.
 	 */
-	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
+	sector_shift = 0;
+	switch (sdp->sector_size) {
+	case 4096: sector_shift++;	/* fall through */
+	case 2048: sector_shift++;	/* fall through */
+	case 1024: sector_shift++;
+
+		if (!IS_ALIGNED(block, 1 << sector_shift) ||
+		    !IS_ALIGNED(blk_rq_sectors(rq), 1 << sector_shift)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
 			goto out;
 		} else {
-			block = block >> 1;
-			this_count = this_count >> 1;
-		}
-	}
-	if (sdp->sector_size == 2048) {
-		if ((block & 3) || (blk_rq_sectors(rq) & 3)) {
-			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
-			goto out;
-		} else {
-			block = block >> 2;
-			this_count = this_count >> 2;
-		}
-	}
-	if (sdp->sector_size == 4096) {
-		if ((block & 7) || (blk_rq_sectors(rq) & 7)) {
-			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
-			goto out;
-		} else {
-			block = block >> 3;
-			this_count = this_count >> 3;
+			block = block >> sector_shift;
+			this_count = this_count >> sector_shift;
 		}
 	}
+
 	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
 			goto out;
-- 
1.7.6

