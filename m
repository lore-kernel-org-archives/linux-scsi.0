From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7/8] sd: Permit merged discard requests
Date: Tue, 18 Sep 2012 12:19:31 -0400
Message-ID: <1347985172-2495-8-git-send-email-martin.petersen@oracle.com>
References: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:24511 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab2IRQUC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Sep 2012 12:20:02 -0400
In-Reply-To: <1347985172-2495-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: axboe@kernel.dk, shli@kernel.org, snitzer@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

Support requests with more than one bio payload for discards. The total
number of bytes to be discarded is stored in req->__data_len and used in
sd_done() to complete the I/O.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/sd.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4df73e5..e100b5c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -560,29 +560,26 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 }
 
 /**
- * scsi_setup_discard_cmnd - unmap blocks on thinly provisioned device
+ * sd_setup_discard_cmnd - unmap blocks on thinly provisioned device
  * @sdp: scsi device to operate one
  * @rq: Request to prepare
  *
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
  * indicated by target device.
  **/
-static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	struct bio *bio = rq->bio;
-	sector_t sector = bio->bi_sector;
-	unsigned int nr_sectors = bio_sectors(bio);
+	sector_t sector = blk_rq_pos(rq);
+	unsigned int nr_sectors = blk_rq_sectors(rq);
+	unsigned int nr_bytes = blk_rq_bytes(rq);
 	unsigned int len;
 	int ret;
 	char *buf;
 	struct page *page;
 
-	if (sdkp->device->sector_size == 4096) {
-		sector >>= 3;
-		nr_sectors >>= 3;
-	}
-
+	sector >>= ilog2(sdp->sector_size) - 9;
+	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 	rq->timeout = SD_TIMEOUT;
 
 	memset(rq->cmd, 0, rq->cmd_len);
@@ -637,6 +634,7 @@ static int scsi_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	blk_add_request_payload(rq, page, len);
 	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
 	rq->buffer = page_address(page);
+	rq->__data_len = nr_bytes;
 
 out:
 	if (ret != BLKPREP_OK) {
@@ -689,7 +687,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * block PC requests to make life easier.
 	 */
 	if (rq->cmd_flags & REQ_DISCARD) {
-		ret = scsi_setup_discard_cmnd(sdp, rq);
+		ret = sd_setup_discard_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = scsi_setup_flush_cmnd(sdp, rq);
@@ -1460,12 +1458,20 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	unsigned int good_bytes = result ? 0 : scsi_bufflen(SCpnt);
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
+	struct request *req = SCpnt->request;
 	int sense_valid = 0;
 	int sense_deferred = 0;
 	unsigned char op = SCpnt->cmnd[0];
 
-	if ((SCpnt->request->cmd_flags & REQ_DISCARD) && !result)
-		scsi_set_resid(SCpnt, 0);
+	if (req->cmd_flags & REQ_DISCARD) {
+		if (!result) {
+			good_bytes = blk_rq_bytes(req);
+			scsi_set_resid(SCpnt, 0);
+		} else {
+			good_bytes = 0;
+			scsi_set_resid(SCpnt, blk_rq_bytes(req));
+		}
+	}
 
 	if (result) {
 		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
-- 
1.7.7.6

