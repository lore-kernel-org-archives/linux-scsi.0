From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/10] sd: don't use scsi_setup_blk_pc_cmnd for write same requests
Date: Sun, 29 Jun 2014 15:34:36 +0200
Message-ID: <1404048881-19526-6-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46572 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaF2Ncd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:33 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Simplify handling of write same requests by setting up the command directly
instead of initializing request fields and then calling
scsi_setup_blk_pc_cmnd to propagate the information into the command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |   44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 620d32f..25f25dd 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -799,14 +799,15 @@ out:
 
 /**
  * sd_setup_write_same_cmnd - write the same data to multiple blocks
- * @sdp: scsi device to operate one
- * @rq: Request to prepare
+ * @cmd: command to prepare
  *
  * Will issue either WRITE SAME(10) or WRITE SAME(16) depending on
  * preference indicated by target device.
  **/
-static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 {
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	struct bio *bio = rq->bio;
 	sector_t sector = blk_rq_pos(rq);
@@ -822,25 +823,36 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
 
-	rq->__data_len = sdp->sector_size;
 	rq->timeout = SD_WRITE_SAME_TIMEOUT;
-	memset(rq->cmd, 0, rq->cmd_len);
 
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
-		rq->cmd_len = 16;
-		rq->cmd[0] = WRITE_SAME_16;
-		put_unaligned_be64(sector, &rq->cmd[2]);
-		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = WRITE_SAME_16;
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 	} else {
-		rq->cmd_len = 10;
-		rq->cmd[0] = WRITE_SAME;
-		put_unaligned_be32(sector, &rq->cmd[2]);
-		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
+		cmd->cmd_len = 10;
+		cmd->cmnd[0] = WRITE_SAME;
+		put_unaligned_be32(sector, &cmd->cmnd[2]);
+		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
 	}
 
-	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
-	rq->__data_len = nr_bytes;
+	cmd->transfersize = sdp->sector_size;
+	cmd->allowed = rq->retries;
 
+	/*
+	 * For WRITE_SAME the data transferred in the DATA IN buffer is
+	 * different from the amount of data actually written to the target.
+	 *
+	 * We set up __data_len to the amount of data transferred from the
+	 * DATA IN buffer so that blk_rq_map_sg set up the proper S/G list
+	 * to transfer a single sector of data first, but then reset it to
+	 * the amount of data to be written right after so that the I/O path
+	 * knows how much to actually write.
+	 */
+	rq->__data_len = sdp->sector_size;
+	ret = scsi_init_io(cmd, GFP_ATOMIC);
+	rq->__data_len = nr_bytes;
 	return ret;
 }
 
@@ -894,7 +906,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 		ret = sd_setup_discard_cmnd(sdp, rq);
 		goto out;
 	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
-		ret = sd_setup_write_same_cmnd(sdp, rq);
+		ret = sd_setup_write_same_cmnd(SCpnt);
 		goto out;
 	} else if (rq->cmd_flags & REQ_FLUSH) {
 		ret = sd_setup_flush_cmnd(SCpnt);
-- 
1.7.10.4

