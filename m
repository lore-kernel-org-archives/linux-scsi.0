From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/27] sd: split sd_setup_discard_cmnd
Date: Wed,  5 Apr 2017 19:20:59 +0200
Message-ID: <20170405172125.22600-2-hch@lst.de>
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

Split sd_setup_discard_cmnd into one function per provisioning type.  While
this creates some very slight duplication of boilerplate code it keeps the
code modular for additions of new provisioning types, and for reusing the
write same functions for the upcoming scsi implementation of the Write Zeroes
operation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/sd.c | 153 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 84 insertions(+), 69 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcfeddc79331..b853f91fb3da 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -701,93 +701,97 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
-/**
- * sd_setup_discard_cmnd - unmap blocks on thinly provisioned device
- * @sdp: scsi device to operate on
- * @rq: Request to prepare
- *
- * Will issue either UNMAP or WRITE SAME(16) depending on preference
- * indicated by target device.
- **/
-static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
+static int sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 {
-	struct request *rq = cmd->request;
 	struct scsi_device *sdp = cmd->device;
-	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
-	sector_t sector = blk_rq_pos(rq);
-	unsigned int nr_sectors = blk_rq_sectors(rq);
-	unsigned int len;
-	int ret;
+	struct request *rq = cmd->request;
+	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	unsigned int data_len = 24;
 	char *buf;
-	struct page *page;
 
-	sector >>= ilog2(sdp->sector_size) - 9;
-	nr_sectors >>= ilog2(sdp->sector_size) - 9;
-
-	page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
-	if (!page)
+	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!rq->special_vec.bv_page)
 		return BLKPREP_DEFER;
+	rq->special_vec.bv_offset = 0;
+	rq->special_vec.bv_len = data_len;
+	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	switch (sdkp->provisioning_mode) {
-	case SD_LBP_UNMAP:
-		buf = page_address(page);
-
-		cmd->cmd_len = 10;
-		cmd->cmnd[0] = UNMAP;
-		cmd->cmnd[8] = 24;
-
-		put_unaligned_be16(6 + 16, &buf[0]);
-		put_unaligned_be16(16, &buf[2]);
-		put_unaligned_be64(sector, &buf[8]);
-		put_unaligned_be32(nr_sectors, &buf[16]);
+	cmd->cmd_len = 10;
+	cmd->cmnd[0] = UNMAP;
+	cmd->cmnd[8] = 24;
 
-		len = 24;
-		break;
+	buf = page_address(rq->special_vec.bv_page);
+	put_unaligned_be16(6 + 16, &buf[0]);
+	put_unaligned_be16(16, &buf[2]);
+	put_unaligned_be64(sector, &buf[8]);
+	put_unaligned_be32(nr_sectors, &buf[16]);
 
-	case SD_LBP_WS16:
-		cmd->cmd_len = 16;
-		cmd->cmnd[0] = WRITE_SAME_16;
-		cmd->cmnd[1] = 0x8; /* UNMAP */
-		put_unaligned_be64(sector, &cmd->cmnd[2]);
-		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
+	cmd->allowed = SD_MAX_RETRIES;
+	cmd->transfersize = data_len;
+	rq->timeout = SD_TIMEOUT;
+	scsi_req(rq)->resid_len = data_len;
 
-		len = sdkp->device->sector_size;
-		break;
+	return scsi_init_io(cmd);
+}
 
-	case SD_LBP_WS10:
-	case SD_LBP_ZERO:
-		cmd->cmd_len = 10;
-		cmd->cmnd[0] = WRITE_SAME;
-		if (sdkp->provisioning_mode == SD_LBP_WS10)
-			cmd->cmnd[1] = 0x8; /* UNMAP */
-		put_unaligned_be32(sector, &cmd->cmnd[2]);
-		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
+static int sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd)
+{
+	struct scsi_device *sdp = cmd->device;
+	struct request *rq = cmd->request;
+	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 data_len = sdp->sector_size;
 
-		len = sdkp->device->sector_size;
-		break;
+	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!rq->special_vec.bv_page)
+		return BLKPREP_DEFER;
+	rq->special_vec.bv_offset = 0;
+	rq->special_vec.bv_len = data_len;
+	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
 
-	default:
-		ret = BLKPREP_INVALID;
-		goto out;
-	}
+	cmd->cmd_len = 16;
+	cmd->cmnd[0] = WRITE_SAME_16;
+	cmd->cmnd[1] = 0x8; /* UNMAP */
+	put_unaligned_be64(sector, &cmd->cmnd[2]);
+	put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 
+	cmd->allowed = SD_MAX_RETRIES;
+	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
+	scsi_req(rq)->resid_len = data_len;
 
-	cmd->transfersize = len;
-	cmd->allowed = SD_MAX_RETRIES;
+	return scsi_init_io(cmd);
+}
 
-	rq->special_vec.bv_page = page;
-	rq->special_vec.bv_offset = 0;
-	rq->special_vec.bv_len = len;
+static int sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd, bool unmap)
+{
+	struct scsi_device *sdp = cmd->device;
+	struct request *rq = cmd->request;
+	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
+	u32 data_len = sdp->sector_size;
 
+	rq->special_vec.bv_page = alloc_page(GFP_ATOMIC | __GFP_ZERO);
+	if (!rq->special_vec.bv_page)
+		return BLKPREP_DEFER;
+	rq->special_vec.bv_offset = 0;
+	rq->special_vec.bv_len = data_len;
 	rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
-	scsi_req(rq)->resid_len = len;
 
-	ret = scsi_init_io(cmd);
-out:
-	if (ret != BLKPREP_OK)
-		__free_page(page);
-	return ret;
+	cmd->cmd_len = 10;
+	cmd->cmnd[0] = WRITE_SAME;
+	if (unmap)
+		cmd->cmnd[1] = 0x8; /* UNMAP */
+	put_unaligned_be32(sector, &cmd->cmnd[2]);
+	put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
+
+	cmd->allowed = SD_MAX_RETRIES;
+	cmd->transfersize = data_len;
+	rq->timeout = SD_TIMEOUT;
+	scsi_req(rq)->resid_len = data_len;
+
+	return scsi_init_io(cmd);
 }
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
@@ -1155,7 +1159,18 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 
 	switch (req_op(rq)) {
 	case REQ_OP_DISCARD:
-		return sd_setup_discard_cmnd(cmd);
+		switch (scsi_disk(rq->rq_disk)->provisioning_mode) {
+		case SD_LBP_UNMAP:
+			return sd_setup_unmap_cmnd(cmd);
+		case SD_LBP_WS16:
+			return sd_setup_write_same16_cmnd(cmd);
+		case SD_LBP_WS10:
+			return sd_setup_write_same10_cmnd(cmd, true);
+		case SD_LBP_ZERO:
+			return sd_setup_write_same10_cmnd(cmd, false);
+		default:
+			return BLKPREP_INVALID;
+		}
 	case REQ_OP_WRITE_SAME:
 		return sd_setup_write_same_cmnd(cmd);
 	case REQ_OP_FLUSH:
-- 
2.11.0
