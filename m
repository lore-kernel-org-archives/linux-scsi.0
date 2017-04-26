From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] ide-pm: always pass 0 error to ide_complete_rq in ide_do_devset
Date: Wed, 26 Apr 2017 09:34:22 +0200
Message-ID: <20170426073422.14511-4-hch@lst.de>
References: <20170426073422.14511-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170426073422.14511-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The caller only looks at the scsi_request result field anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/ide/ide-devsets.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ide/ide-devsets.c b/drivers/ide/ide-devsets.c
index b1223234037d..9b69c32ee560 100644
--- a/drivers/ide/ide-devsets.c
+++ b/drivers/ide/ide-devsets.c
@@ -187,6 +187,6 @@ ide_startstop_t ide_do_devset(ide_drive_t *drive, struct request *rq)
 	err = setfunc(drive, *(int *)&scsi_req(rq)->cmd[1]);
 	if (err)
 		scsi_req(rq)->result = err;
-	ide_complete_rq(drive, err, blk_rq_bytes(rq));
+	ide_complete_rq(drive, 0, blk_rq_bytes(rq));
 	return ide_stopped;
 }
-- 
2.11.0
