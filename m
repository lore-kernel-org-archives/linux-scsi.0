From: Namhyung Kim <namhyung@gmail.com>
Subject: [PATCH 2/3] [SCSI] sd: remove dead code
Date: Tue,  2 Aug 2011 12:50:52 +0900
Message-ID: <1312257053-2522-2-git-send-email-namhyung@gmail.com>
References: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52792 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1HBDxC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2011 23:53:02 -0400
In-Reply-To: <1312257053-2522-1-git-send-email-namhyung@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

As rq_data_dir() only checks a single bit (REQ_WRITE), the result
can not be anything but READ or WRITE. Thus last ELSE clause is
not needed at all.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 drivers/scsi/sd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 463a324835f4..fbb522add124 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -760,12 +760,9 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		    sd_dif_prepare(rq, block, sdp->sector_size) == -EIO)
 			goto out;
 
-	} else if (rq_data_dir(rq) == READ) {
+	} else { /* READ */
 		SCpnt->cmnd[0] = READ_6;
 		SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	} else {
-		scmd_printk(KERN_ERR, SCpnt, "Unknown command %x\n", rq->cmd_flags);
-		goto out;
 	}
 
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt,
-- 
1.7.6

