From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 7/7] sd: Use sd_ prefix for flush and discard functions
Date: Fri, 16 Mar 2012 14:43:19 -0400
Message-ID: <1331923399-30987-8-git-send-email-martin.petersen@oracle.com>
References: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:46251 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab2CPSnm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Mar 2012 14:43:42 -0400
In-Reply-To: <1331923399-30987-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jaxboe@fusionio.com, jbottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

From: "Martin K. Petersen" <martin.petersen@oracle.com>

The commands to set up flush and discard operations used a scsi_ prefix
despite being local to the sd driver. Use an sd_ prefix instead.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/sd.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 26c33db..0c5c4b2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -575,14 +575,14 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
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
 	struct bio *bio = rq->bio;
@@ -733,7 +733,7 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	return scsi_setup_blk_pc_cmnd(sdp, rq);
 }
 
-static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
 	rq->timeout = SD_FLUSH_TIMEOUT;
 	rq->retries = SD_MAX_RETRIES;
@@ -776,13 +776,13 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * block PC requests to make life easier.
 	 */
 	if (rq->cmd_flags & REQ_DISCARD) {
-		ret = scsi_setup_discard_cmnd(sdp, rq);
+		ret = sd_setup_discard_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
 		ret = sd_setup_write_same_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
-		ret = scsi_setup_flush_cmnd(sdp, rq);
+		ret = sd_setup_flush_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_type == REQ_TYPE_BLOCK_PC) {
 		ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-- 
1.7.7.6

