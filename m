From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/32] a3000.c: convert to accessors and !use_sg cleanup
Date: Wed, 17 Oct 2007 19:50:43 +0200
Message-ID: <47164B73.4050705@panasas.com>
References: <47164306.6090702@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:5391 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbXJQRva (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Oct 2007 13:51:30 -0400
In-Reply-To: <47164306.6090702@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Wilcox <matthew@wil.cx>, Matthew Dharm <mdharm-scsi@one-e>
Cc: Benny Halevy <bhalevy@panasas.com>, Pete Wyckoff <pw@osc.edu>


 - convert to accessors and !use_sg cleanup

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/a3000.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 796f1c4..d7255c8 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -70,12 +70,8 @@ static int dma_setup(struct scsi_cmnd *cmd, int dir_in)
 
 	if (!dir_in) {
 	    /* copy to bounce buffer for a write */
-	    if (cmd->use_sg) {
-		memcpy (HDATA(a3000_host)->dma_bounce_buffer,
-			cmd->SCp.ptr, cmd->SCp.this_residual);
-	    } else
-		memcpy (HDATA(a3000_host)->dma_bounce_buffer,
-			cmd->request_buffer, cmd->request_bufflen);
+	    memcpy (HDATA(a3000_host)->dma_bounce_buffer,
+		cmd->SCp.ptr, cmd->SCp.this_residual);
 	}
 
 	addr = virt_to_bus(HDATA(a3000_host)->dma_bounce_buffer);
@@ -146,7 +142,7 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 
     /* copy from a bounce buffer, if necessary */
     if (status && HDATA(instance)->dma_bounce_buffer) {
-	if (SCpnt && SCpnt->use_sg) {
+	if (SCpnt) {
 	    if (HDATA(instance)->dma_dir && SCpnt)
 		memcpy (SCpnt->SCp.ptr,
 			HDATA(instance)->dma_bounce_buffer,
@@ -155,11 +151,6 @@ static void dma_stop(struct Scsi_Host *instance, struct scsi_cmnd *SCpnt,
 	    HDATA(instance)->dma_bounce_buffer = NULL;
 	    HDATA(instance)->dma_bounce_len = 0;
 	} else {
-	    if (HDATA(instance)->dma_dir && SCpnt)
-		memcpy (SCpnt->request_buffer,
-			HDATA(instance)->dma_bounce_buffer,
-			SCpnt->request_bufflen);
-
 	    kfree (HDATA(instance)->dma_bounce_buffer);
 	    HDATA(instance)->dma_bounce_buffer = NULL;
 	    HDATA(instance)->dma_bounce_len = 0;
-- 
1.5.3.1


