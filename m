From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 11/32] a2091.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 19:47:25 +0200
Message-ID: <47164AAD.5020905@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:1232 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754898AbXJQRtS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:49:18 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/a2091.c |   36 +++++-------------------------------
 1 files changed, 5 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index b7c5385..23f27c9 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -73,18 +73,9 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 	}
 
 	if (!dir_in) {
-	    /* copy to bounce buffer for a write */
-	    if (cmd->use_sg)
-#if 0
-		panic ("scsi%ddma: incomplete s/g support",
-		       instance->host_no);
-#else
+		/* copy to bounce buffer for a write */
 		memcpy (HDATA(instance)->dma_bounce_buffer,
 			cmd->SCp.ptr, cmd->SCp.this_residual);
-#endif
-	    else
-		memcpy (HDATA(instance)->dma_bounce_buffer,
-			cmd->request_buffer, cmd->request_bufflen);
 	}
     }
 
@@ -144,30 +135,13 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 
     /* copy from a bounce buffer, if necessary */
     if (status && HDATA(instance)->dma_bounce_buffer) {
-	if (SCpnt && SCpnt->use_sg) {
-#if 0
-	    panic ("scsi%d: incomplete s/g support",
-		   instance->host_no);
-#else
-	    if( HDATA(instance)->dma_dir )
+	if( HDATA(instance)->dma_dir )
 		memcpy (SCpnt->SCp.ptr, 
 			HDATA(instance)->dma_bounce_buffer,
 			SCpnt->SCp.this_residual);
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
-	    
-#endif
-	} else {
-	    if (HDATA(instance)->dma_dir && SCpnt)
-		memcpy (SCpnt->request_buffer,
-			HDATA(instance)->dma_bounce_buffer,
-			SCpnt->request_bufflen);
-
-	    kfree (HDATA(instance)->dma_bounce_buffer);
-	    HDATA(instance)->dma_bounce_buffer = NULL;
-	    HDATA(instance)->dma_bounce_len = 0;
-	}
+	kfree (HDATA(instance)->dma_bounce_buffer);
+	HDATA(instance)->dma_bounce_buffer = NULL;
+	HDATA(instance)->dma_bounce_len = 0;
     }
 }
 
-- 
1.5.3.1


