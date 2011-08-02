From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 1/3] [SCSI] sd: consolidate sector size alignment check in sd_pref_fn
Date: Tue,  2 Aug 2011 12:50:51 +0900
Message-ID: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52792 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab1HBDxA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 23:53:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Generalize common code to reduce code duplication.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/sd.c |   32 ++++++++------------------------
 1 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 953773cb26d9..463a324835f4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -735,36 +735,20 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * and not force the scsi disk driver to use bounce buffers
 	 * for this.
 	 */
-	if (sdp->sector_size == 1024) {
-		if ((block & 1) || (blk_rq_sectors(rq) & 1)) {
-			scmd_printk(KERN_ERR, SCpnt,
-				    "Bad block number requested\n");
-			goto out;
-		} else {
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
+	if (sdp->sector_size > 512) {
+		int shift = ilog2(sdp->sector_size) - 9;
+
+		if (!IS_ALIGNED(block, 1 << shift) ||
+		    !IS_ALIGNED(blk_rq_sectors(rq), 1 << shift)) {
 			scmd_printk(KERN_ERR, SCpnt,
 				    "Bad block number requested\n");
 			goto out;
 		} else {
-			block = block >> 3;
-			this_count = this_count >> 3;
+			block = block >> shift;
+			this_count = this_count >> shift;
 		}
 	}
+
 	if (rq_data_dir(rq) == WRITE) {
 		if (!sdp->writeable) {
 			goto out;
-- 
1.7.6

