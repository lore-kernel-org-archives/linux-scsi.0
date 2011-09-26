From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH RESEND] [SCSI] sd: consolidate sector size alignment check in sd_prep_fn
Date: Mon, 26 Sep 2011 13:50:11 +0900
Message-ID: <1317012611-4916-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57256 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab1IZEuQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2011 00:50:16 -0400
Received: by gyg10 with SMTP id 10so3861381gyg.19
        for <linux-scsi@vger.kernel.org>; Sun, 25 Sep 2011 21:50:16 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org

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

