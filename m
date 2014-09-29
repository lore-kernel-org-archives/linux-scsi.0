From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 08/38] 53c700: remove scsi_print_sense() usage
Date: Mon, 29 Sep 2014 13:58:37 +0200
Message-ID: <1411991947-130166-9-git-send-email-hare@suse.de>
References: <1411991947-130166-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59304 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbaI2L7L (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2014 07:59:11 -0400
In-Reply-To: <1411991947-130166-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Robert Elliott <elliott@hp.com>, Hannes Reinecke <hare@suse.de>

The 53c700 driver would be using scsi_print_sense() in a debug
statement, which was never compiled in. Plus the same information
can get retrieved with logging. So remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/53c700.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index 68bf423..179a24e 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -592,19 +592,14 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 	hostdata->cmd = NULL;
 
 	if(SCp != NULL) {
-		struct NCR_700_command_slot *slot = 
+		struct NCR_700_command_slot *slot =
 			(struct NCR_700_command_slot *)SCp->host_scribble;
-		
+
 		dma_unmap_single(hostdata->dev, slot->pCmd,
 				 MAX_COMMAND_SIZE, DMA_TO_DEVICE);
 		if (slot->flags == NCR_700_FLAG_AUTOSENSE) {
 			char *cmnd = NCR_700_get_sense_cmnd(SCp->device);
-#ifdef NCR_700_DEBUG
-			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
-			       SCp, SCp->cmnd[7], result);
-			scsi_print_sense(SCp);
 
-#endif
 			dma_unmap_single(hostdata->dev, slot->dma_handle,
 					 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 			/* restore the old result if the request sense was
-- 
1.8.5.2

