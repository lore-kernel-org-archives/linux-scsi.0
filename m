From: Christoph Hellwig <hch@infradead.org>
Subject: Re: scsi-mq V2
Date: Tue, 8 Jul 2014 07:48:29 -0700
Message-ID: <20140708144829.GA5539@infradead.org>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403715121-1201-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 25, 2014 at 06:51:47PM +0200, Christoph Hellwig wrote:
> Changes from V1:
>  - rebased on top of the core-for-3.17 branch, most notable the
>    scsi logging changes
>  - fixed handling of cmd_list to prevent crashes for some heavy
>    workloads
>  - fixed incorrect handling of !target->can_queue
>  - avoid scheduling a workqueue on I/O completions when no queues
>    are congested
> 
> In addition to the patches in this thread there also is a git available at:
> 
> 	git://git.infradead.org/users/hch/scsi.git scsi-mq.2


I've pushed out a new scsi-mq.3 branch, which has been rebased on the
latest core-for-3.17 tree + the "RFC: clean up command setup" series
from June 29th.  Robert Elliot found a problem with not fully zeroed
out UNMAP CDBs, which is fixed by the saner discard handling in that
series.

There is a new patch to factor the code from the above series for
blk-mq use, which I've attached below.  Besides that the only changes
are minor merge fixups in the main blk-mq usage patch.

---
>From f925c317c74849666d599926d8ad8f34ef99d5cf Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 8 Jul 2014 13:16:17 +0200
Subject: scsi: add scsi_setup_cmnd helper

Factor out command setup code that will be shared with the blk-mq code path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 116f541..61afae8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1116,6 +1116,27 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
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
@@ -1219,24 +1240,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
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
1.7.10.4
