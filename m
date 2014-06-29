From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 06/10] sd: don't use scsi_setup_blk_pc_cmnd for discard requests
Date: Sun, 29 Jun 2014 15:34:37 +0200
Message-ID: <1404048881-19526-7-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46576 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbaF2Nce (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:34 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Simplify handling of discard requests by setting up the command directly
instead of initializing request fields and then calling
scsi_setup_blk_pc_cmnd to propagate the information into the command.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 25f25dd..9737e78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -691,8 +691,10 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
  * Will issue either UNMAP or WRITE SAME(16) depending on preference
  * indicated by target device.
  **/
-static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
+static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 {
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 	sector_t sector = blk_rq_pos(rq);
 	unsigned int nr_sectors = blk_rq_sectors(rq);
@@ -704,9 +706,6 @@ static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 
 	sector >>= ilog2(sdp->sector_size) - 9;
 	nr_sectors >>= ilog2(sdp->sector_size) - 9;
-	rq->timeout = SD_TIMEOUT;
-
-	memset(rq->cmd, 0, rq->cmd_len);
 
 	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
 	if (!page)
@@ -716,9 +715,9 @@ static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	case SD_LBP_UNMAP:
 		buf = page_address(page);
 
-		rq->cmd_len = 10;
-		rq->cmd[0] = UNMAP;
-		rq->cmd[8] = 24;
+		cmd->cmd_len = 10;
+		cmd->cmnd[0] = UNMAP;
+		cmd->cmnd[8] = 24;
 
 		put_unaligned_be16(6 + 16, &buf[0]);
 		put_unaligned_be16(16, &buf[2]);
@@ -729,23 +728,23 @@ static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 		break;
 
 	case SD_LBP_WS16:
-		rq->cmd_len = 16;
-		rq->cmd[0] = WRITE_SAME_16;
-		rq->cmd[1] = 0x8; /* UNMAP */
-		put_unaligned_be64(sector, &rq->cmd[2]);
-		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
+		cmd->cmd_len = 16;
+		cmd->cmnd[0] = WRITE_SAME_16;
+		cmd->cmnd[1] = 0x8; /* UNMAP */
+		put_unaligned_be64(sector, &cmd->cmnd[2]);
+		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 
 		len = sdkp->device->sector_size;
 		break;
 
 	case SD_LBP_WS10:
 	case SD_LBP_ZERO:
-		rq->cmd_len = 10;
-		rq->cmd[0] = WRITE_SAME;
+		cmd->cmd_len = 10;
+		cmd->cmnd[0] = WRITE_SAME;
 		if (sdkp->provisioning_mode == SD_LBP_WS10)
-			rq->cmd[1] = 0x8; /* UNMAP */
-		put_unaligned_be32(sector, &rq->cmd[2]);
-		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
+			cmd->cmnd[1] = 0x8; /* UNMAP */
+		put_unaligned_be32(sector, &cmd->cmnd[2]);
+		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
 
 		len = sdkp->device->sector_size;
 		break;
@@ -756,8 +755,14 @@ static int sd_setup_discard_cmnd(struct scsi_device *sdp, struct request *rq)
 	}
 
 	rq->completion_data = page;
+	rq->timeout = SD_TIMEOUT;
+
 	blk_add_request_payload(rq, page, len);
-	ret = scsi_setup_blk_pc_cmnd(sdp, rq);
+
+	cmd->transfersize = len;
+	cmd->allowed = rq->retries;
+
+	ret = scsi_init_io(cmd, GFP_ATOMIC);
 	rq->__data_len = nr_bytes;
 
 out:
@@ -903,7 +908,7 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 	 * block PC requests to make life easier.
 	 */
 	if (rq->cmd_flags & REQ_DISCARD) {
-		ret = sd_setup_discard_cmnd(sdp, rq);
+		ret = sd_setup_discard_cmnd(SCpnt);
 		goto out;
 	} else if (rq->cmd_flags & REQ_WRITE_SAME) {
 		ret = sd_setup_write_same_cmnd(SCpnt);
-- 
1.7.10.4

