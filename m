From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/25] sd: implement unmapping Write Zeroes
Date: Fri, 31 Mar 2017 18:33:02 +0200
Message-ID: <20170331163313.31821-15-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Try to use a write same with unmap bit variant if the device supports it
and the caller allows for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d8d9c0bdd93c..001593ed0444 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -803,6 +803,15 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 	u64 sector = blk_rq_pos(rq) >> (ilog2(sdp->sector_size) - 9);
 	u32 nr_sectors = blk_rq_sectors(rq) >> (ilog2(sdp->sector_size) - 9);
 
+	if (!(rq->cmd_flags & REQ_NOUNMAP)) {
+		switch (sdkp->provisioning_mode) {
+		case SD_LBP_WS16:
+			return sd_setup_write_same16_cmnd(cmd, true);
+		case SD_LBP_WS10:
+			return sd_setup_write_same10_cmnd(cmd, true);
+		}
+	}
+
 	if (sdp->no_write_same)
 		return BLKPREP_INVALID;
 	if (sdkp->ws16 || sector > 0xffffffff || nr_sectors > 0xffff)
-- 
2.11.0
