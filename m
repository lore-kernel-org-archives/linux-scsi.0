From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/14] scsi: add scsi_setup_cmnd helper
Date: Fri, 18 Jul 2014 12:13:00 +0200
Message-ID: <1405678393-11497-2-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Factor out command setup code that will be shared with the blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c | 40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 85cf0ef..04c3684 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1092,6 +1092,27 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 	return scsi_cmd_to_driver(cmd)->init_command(cmd);
 }
 
+static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	if (!blk_rq_bytes(req))
+		cmd->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(req) == WRITE)
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	else
+		cmd->sc_data_direction = DMA_FROM_DEVICE;
+
+	switch (req->cmd_type) {
+	case REQ_TYPE_FS:
+		return scsi_setup_fs_cmnd(sdev, req);
+	case REQ_TYPE_BLOCK_PC:
+		return scsi_setup_blk_pc_cmnd(sdev, req);
+	default:
+		return BLKPREP_KILL;
+	}
+}
+
 static int
 scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 {
@@ -1195,24 +1216,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 		goto out;
 	}
 
-	if (!blk_rq_bytes(req))
-		cmd->sc_data_direction = DMA_NONE;
-	else if (rq_data_dir(req) == WRITE)
-		cmd->sc_data_direction = DMA_TO_DEVICE;
-	else
-		cmd->sc_data_direction = DMA_FROM_DEVICE;
-
-	switch (req->cmd_type) {
-	case REQ_TYPE_FS:
-		ret = scsi_setup_fs_cmnd(sdev, req);
-		break;
-	case REQ_TYPE_BLOCK_PC:
-		ret = scsi_setup_blk_pc_cmnd(sdev, req);
-		break;
-	default:
-		ret = BLKPREP_KILL;
-	}
-
+	ret = scsi_setup_cmnd(sdev, req);
 out:
 	return scsi_prep_return(q, req, ret);
 }
-- 
1.9.1
