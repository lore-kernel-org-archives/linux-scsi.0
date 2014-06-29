From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/10] scsi: set sc_data_direction in common code
Date: Sun, 29 Jun 2014 15:34:34 +0200
Message-ID: <1404048881-19526-4-git-send-email-hch@lst.de>
References: <1404048881-19526-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:46564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051AbaF2Ncb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Jun 2014 09:32:31 -0400
In-Reply-To: <1404048881-19526-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   14 +++++++-------
 drivers/scsi/sd.c       |    2 --
 drivers/scsi/sr.c       |    2 --
 3 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index bc84811..ea23860 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1101,13 +1101,6 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
 	}
 
 	cmd->cmd_len = req->cmd_len;
-	if (!blk_rq_bytes(req))
-		cmd->sc_data_direction = DMA_NONE;
-	else if (rq_data_dir(req) == WRITE)
-		cmd->sc_data_direction = DMA_TO_DEVICE;
-	else
-		cmd->sc_data_direction = DMA_FROM_DEVICE;
-	
 	cmd->transfersize = blk_rq_bytes(req);
 	cmd->allowed = req->retries;
 	return BLKPREP_OK;
@@ -1236,6 +1229,13 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 		goto out;
 	}
 
+	if (!blk_rq_bytes(req))
+		cmd->sc_data_direction = DMA_NONE;
+	else if (rq_data_dir(req) == WRITE)
+		cmd->sc_data_direction = DMA_TO_DEVICE;
+	else
+		cmd->sc_data_direction = DMA_FROM_DEVICE;
+
 	switch (req->cmd_type) {
 	case REQ_TYPE_FS:
 		ret = scsi_setup_fs_cmnd(sdev, req);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 001b3e8..d88bdc8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -994,14 +994,12 @@ static int sd_init_command(struct scsi_cmnd *SCpnt)
 			goto out;
 		}
 		SCpnt->cmnd[0] = WRITE_6;
-		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 
 		if (blk_integrity_rq(rq))
 			sd_dif_prepare(rq, block, sdp->sector_size);
 
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_6;
-		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		scmd_printk(KERN_ERR, SCpnt, "Unknown command %llx\n", (unsigned long long) rq->cmd_flags);
 		goto out;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 9feeb37..cce4771 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -438,11 +438,9 @@ static int sr_init_command(struct scsi_cmnd *SCpnt)
 		if (!cd->device->writeable)
 			goto out;
 		SCpnt->cmnd[0] = WRITE_10;
-		SCpnt->sc_data_direction = DMA_TO_DEVICE;
 		cd->cdi.media_written = 1;
 	} else if (rq_data_dir(rq) == READ) {
 		SCpnt->cmnd[0] = READ_10;
-		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
 	} else {
 		blk_dump_rq_flags(rq, "Unknown sr command");
 		goto out;
-- 
1.7.10.4

