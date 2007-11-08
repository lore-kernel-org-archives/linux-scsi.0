From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 1/4] sr/sd: Remove dead code
Date: Thu, 08 Nov 2007 18:56:13 +0200
Message-ID: <47333FAD.2030503@panasas.com>
References: <4730ACAA.2060007@panasas.com> <47333E2A.7020307@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sa15.bezeqint.net ([192.115.104.30]:42338 "EHLO
	sa15.bezeqint.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbXKHQ4T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 11:56:19 -0500
In-Reply-To: <47333E2A.7020307@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>, Andrew Morton <akpm@osdl.org>


  if (rq_data_dir() == WRITE) else if() else chain had an extra
  "else" since the if() is on a value of 1 bit.

  Also with a bidi request, rq_data_dir() == WRITE
  and blk_bidi_rq() == true.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/sd.c |    5 +----
 drivers/scsi/sr.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 18343a6..f1ec2bd 100644
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
index 7702681..a72ae85 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -365,12 +365,9 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
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
1.5.3.1


