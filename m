From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/27] sd: implement unmapping Write Zeroes
Date: Wed,  5 Apr 2017 19:21:12 +0200
Message-ID: <20170405172125.22600-15-hch@lst.de>
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

Try to use a write same with unmap bit variant if the device supports it
and the caller allows for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
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
