From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH] sr/sd: Remove simple dead code
Date: Thu, 13 Dec 2007 13:34:05 +0200
Message-ID: <476118AD.80407@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:11591 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751692AbXLMLeK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Dec 2007 06:34:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>


  if (rq_data_dir() == WRITE) else if() else chain had an extra
  "else" since the if() is on a value of 1 bit.

  Also with a bidi request rq_data_dir() == WRITE
  and blk_bidi_rq() == true.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/sd.c |    5 +----
 drivers/scsi/sr.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 212f6bc..e6d85b0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -445,12 +445,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		}
 		SCpnt->cmnd[0] = WRITE_6;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
-	} else if (rq_data_dir(rq) == READ) {
+	} else {
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 896be4a..7128d15 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -372,12 +372,9 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[0] = WRITE_10;
 		SCpnt->sc_data_direction = DMA_TO_DEVICE;
  	 	cd->cdi.media_written = 1;
-	} else if (rq_data_dir(rq) == READ) {
+	} else {
 		SCpnt->cmnd[0] = READ_10;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		blk_dump_rq_flags(rq, "Unknown sr command");
-		goto out;
 	}
 
 	{
-- 
1.5.3.3

