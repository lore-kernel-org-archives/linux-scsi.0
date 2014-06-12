From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] sd: don't use rq->cmd_len before setting it up
Date: Thu, 12 Jun 2014 15:48:53 +0200
Message-ID: <1402580946-11470-2-git-send-email-hch@lst.de>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1402580946-11470-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Unlike the old request code blk-mq doesn't initialize cmd_len with a
default value, so don't rely on it being set in sd_setup_write_same_cmnd.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e9689d5..dbd0c51 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -810,15 +810,16 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 
 	rq->__data_len = sdp->sector_size;
 	rq->timeout = SD_WRITE_SAME_TIMEOUT;
-	memset(rq->cmd, 0, rq->cmd_len);
 
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff) {
 		rq->cmd_len = 16;
+		memset(rq->cmd, 0, rq->cmd_len);
 		rq->cmd[0] = WRITE_SAME_16;
 		put_unaligned_be64(sector, &rq->cmd[2]);
 		put_unaligned_be32(nr_sectors, &rq->cmd[10]);
 	} else {
 		rq->cmd_len = 10;
+		memset(rq->cmd, 0, rq->cmd_len);
 		rq->cmd[0] = WRITE_SAME;
 		put_unaligned_be32(sector, &rq->cmd[2]);
 		put_unaligned_be16(nr_sectors, &rq->cmd[7]);
-- 
1.7.10.4
