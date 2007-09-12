From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 11/24] a2091.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:00:55 +0300
Message-ID: <46E72C37.207@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5319 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753660AbXILAEk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:04:40 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


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


