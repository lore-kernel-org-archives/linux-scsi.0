From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/23] sd: handle REQ_UNMAP
Date: Thu, 23 Mar 2017 10:33:30 -0400
Message-ID: <20170323143341.31549-13-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Try to use a write same with unmap bit variant if the device supports it
and the caller asks for it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b6f70a09a301..ca96bb33471b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -871,6 +871,16 @@ static int sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 			return BLKPREP_INVALID;
 		return sd_setup_ata_trim_cmnd(cmd);
 	}
+
+	if (rq->cmd_flags & REQ_UNMAP) {
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

