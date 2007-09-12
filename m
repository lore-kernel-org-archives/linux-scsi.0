From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/24] a3000.c: convert to accessors and !use_sg cleanup
Date: Wed, 12 Sep 2007 03:01:50 +0300
Message-ID: <46E72C6E.3020307@panasas.com>
References: <46E6F92D.2090409@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:4148 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760918AbXILAFc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Sep 2007 20:05:32 -0400
In-Reply-To: <46E6F92D.2090409@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Greg Kroah-Hartman <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Matthew


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


