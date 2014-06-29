From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/10] sd: don't use scsi_setup_blk_pc_cmnd for flush requests
Date: Sun, 29 Jun 2014 15:34:35 +0200
Message-ID: <1404048881-19526-5-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46569 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbaF2Ncc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:32 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Simplify handling of flush requests by setting up the command directly
instead of initializing request fields and then calling
scsi_setup_blk_pc_cmnd to propagate the information into the command.

Also rename scsi_setup_flush_cmnd to sd_setup_flush_cmnd for consistency.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d88bdc8..620d32f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -844,14 +844,20 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	return ret;
 }
 
-static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 {
-	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
-	rq->retries = SD_MAX_RETRIES;
-	rq->cmd[0] = SYNCHRONIZE_CACHE;
-	rq->cmd_len = 10;
+	struct request *rq = cmd->request;
+
+	/* flush requests don't perform I/O, zero the S/G table */
+	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
 
-	return scsi_setup_blk_pc_cmnd(sdp, rq);
+	cmd->cmnd[0] = SYNCHRONIZE_CACHE;
+	cmd->cmd_len = 10;
+	cmd->transfersize = 0;
+	cmd->allowed = SD_MAX_RETRIES;
+
+	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
+	return BLKPREP_OK;
 }
 
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
@@ -891,7 +897,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 		ret = sd_setup_write_same_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
-		ret = scsi_setup_flush_cmnd(sdp, rq);
+		ret = sd_setup_flush_cmnd(SCpnt);
 		goto out;
 	}
 	ret = scsi_init_io(SCpnt, GFP_ATOMIC);
-- 
1.7.10.4

