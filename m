From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 27/28] eata: remove 'arg_done' from eata2x_eh_host_reset()
Date: Wed, 28 Jun 2017 10:25:15 +0200
Message-ID: <1498638316-44420-28-git-send-email-hare@suse.de>
References: <1498638316-44420-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53048 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751723AbdF1IbO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:31:14 -0400
In-Reply-To: <1498638316-44420-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Just displaying some different information; drop it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/eata.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index 227dd2c..6501c33 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -1899,7 +1899,6 @@ static int eata2x_eh_abort(struct scsi_cmnd *SCarg)
 static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 {
 	unsigned int i, time, k, c, limit = 0;
-	int arg_done = 0;
 	struct scsi_cmnd *SCpnt;
 	struct Scsi_Host *shost = SCarg->device->host;
 	struct hostdata *ha = (struct hostdata *)shost->hostdata;
@@ -1967,9 +1966,6 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 		if (SCpnt->scsi_done == NULL)
 			panic("%s: reset, mbox %d, SCpnt->scsi_done == NULL.\n",
 			      ha->board_name, i);
-
-		if (SCpnt == SCarg)
-			arg_done = 1;
 	}
 
 	if (do_dma(shost->io_port, 0, RESET_PIO)) {
@@ -2037,10 +2033,7 @@ static int eata2x_eh_host_reset(struct scsi_cmnd *SCarg)
 	ha->in_reset = 0;
 	do_trace = 0;
 
-	if (arg_done)
-		printk("%s: reset, exit, done.\n", ha->board_name);
-	else
-		printk("%s: reset, exit.\n", ha->board_name);
+	printk("%s: reset, exit.\n", ha->board_name);
 
 	spin_unlock_irq(shost->host_lock);
 	return SUCCESS;
-- 
1.8.5.6
