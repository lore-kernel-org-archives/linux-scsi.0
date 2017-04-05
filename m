From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 04/27] sd: implement REQ_OP_WRITE_ZEROES
Date: Wed,  5 Apr 2017 19:21:02 +0200
Message-ID: <20170405172125.22600-5-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c     | 31 ++++++++++++++++++++++++++-----
 drivers/scsi/sd_zbc.c |  1 +
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b853f91fb3da..d8d9c0bdd93c 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -735,7 +735,7 @@ static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	return scsi_init_io(cmd);
 }
 
-static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
+static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd, bool unmap)
 {
 	struct scsi_device *sdp = cmd->device;
 	struct request *rq = cmd->request;
@@ -752,13 +752,14 @@ static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
 
 	cmd->cmd_len = 16;
 	cmd->cmnd[0] = WRITE_SAME_16;
-	cmd->cmnd[1] = 0x8; /* UNMAP */
+	if (unmap)
+		cmd->cmnd[1] = 0x8; /* UNMAP */
 	put_unaligned_be64(sector, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 
 	cmd->allowed = SD_MAX_RETRIES;
 	cmd->transfersize = data_len;
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 	scsi_req(rq)->resid_len = data_len;
 
 	return scsi_init_io(cmd);
@@ -788,12 +789,27 @@ static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
 
 	cmd->allowed = SD_MAX_RETRIES;
 	cmd->transfersize = data_len;
-	rq->timeout = SD_TIMEOUT;
+	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 	scsi_req(rq)->resid_len = data_len;
 
 	return scsi_init_io(cmd);
 }
 
+static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
+{
+	struct request *rq = cmd->request;
+	struct scsi_device *sdp = cmd->device;
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+
+	if (sdp->no_write_same)
+		return BLKPREP_INVALID;
+	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
+		return sd_setup_write_same16_cmnd(cmd, false);
+	return sd_setup_write_same10_cmnd(cmd, false);
+}
+
 static void sd_config_write_same(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
@@ -823,6 +839,8 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 out:
 	blk_queue_max_write_same_sectors(q, sdkp->max_ws_blocks *
 					 (logical_block_size >> 9));
+	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
+					 (logical_block_size >> 9));
 }
 
 /**
@@ -1163,7 +1181,7 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 		case SD_LBP_UNMAP:
 			return sd_setup_unmap_cmnd(cmd);
 		case SD_LBP_WS16:
-			return sd_setup_write_same16_cmnd(cmd);
+			return sd_setup_write_same16_cmnd(cmd, true);
 		case SD_LBP_WS10:
 			return sd_setup_write_same10_cmnd(cmd, true);
 		case SD_LBP_ZERO:
@@ -1171,6 +1189,8 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 		default:
 			return BLKPREP_INVALID;
 		}
+	case REQ_OP_WRITE_ZEROES:
+		return sd_setup_write_zeroes_cmnd(cmd);
 	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
 	case REQ_OP_FLUSH:
@@ -1810,6 +1830,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 
 	switch (req_op(req)) {
 	case REQ_OP_DISCARD:
+	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
 		if (!result) {
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 92620c8ea8ad..1994f7799fce 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -329,6 +329,7 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 
 	switch (req_op(rq)) {
 	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 	case REQ_OP_ZONE_RESET:
 
-- 
2.11.0
