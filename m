From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 14/26] acornscsi: move bus reset to host reset
Date: Fri, 25 Aug 2017 13:57:09 +0200
Message-ID: <1503662241-127788-15-git-send-email-hare@suse.de>
References: <1503662241-127788-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49641 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756512AbdHYL6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Aug 2017 07:58:03 -0400
In-Reply-To: <1503662241-127788-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

The bus reset function is really a host reset, so move it to
eh_host_reset_handler.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/arm/acornscsi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 12b8829..690816f 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2725,23 +2725,24 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
  * Params   : SCpnt  - command causing reset
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_bus_reset(struct scsi_cmnd *SCpnt)
+int acornscsi_host_reset(struct Scsi_Host *shpnt)
 {
-	AS_Host *host = (AS_Host *)SCpnt->device->host->hostdata;
+	AS_Host *host = (AS_Host *)shpnt->hostdata;
 	struct scsi_cmnd *SCptr;
     
     host->stats.resets += 1;
 
 #if (DEBUG & DEBUG_RESET)
     {
-	int asr, ssr;
+	int asr, ssr, devidx;
 
 	asr = sbic_arm_read(host, SBIC_ASR);
 	ssr = sbic_arm_read(host, SBIC_SSR);
 
 	printk(KERN_WARNING "acornscsi_reset: ");
 	print_sbic_status(asr, ssr, host->scsi.phase);
-	acornscsi_dumplog(host, SCpnt->device->id);
+	for (devidx = 0; devidx < 9; devidx ++) {
+	    acornscsi_dumplog(host, devidx);
     }
 #endif
 
@@ -2884,7 +2885,7 @@ static int acornscsi_show_info(struct seq_file *m, struct Scsi_Host *instance)
 	.info			= acornscsi_info,
 	.queuecommand		= acornscsi_queuecmd,
 	.eh_abort_handler	= acornscsi_abort,
-	.eh_bus_reset_handler	= acornscsi_bus_reset,
+	.eh_host_reset_handler	= acornscsi_host_reset,
 	.can_queue		= 16,
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
-- 
1.8.5.6
