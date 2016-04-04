From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 05/14] libata-scsi: use scsi_set_sense_information()
Date: Mon,  4 Apr 2016 11:43:58 +0200
Message-ID: <1459763047-125551-6-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754543AbcDDJoW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:22 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use scsi_set_sense_information() instead of hand-crafted function.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 410ce14..de593d8 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1055,7 +1055,6 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	struct scsi_cmnd *cmd = qc->scsicmd;
 	struct ata_taskfile *tf = &qc->result_tf;
 	unsigned char *sb = cmd->sense_buffer;
-	unsigned char *desc = sb + 8;
 	int verbose = qc->ap->ops->error_handler == NULL;
 	u64 block;
 
@@ -1086,18 +1085,7 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 	if (block == (u64)-1)
 		return;
 
-	/* information sense data descriptor */
-	sb[7] = 12;
-	desc[0] = 0x00;
-	desc[1] = 10;
-
-	desc[2] |= 0x80;	/* valid */
-	desc[6] = block >> 40;
-	desc[7] = block >> 32;
-	desc[8] = block >> 24;
-	desc[9] = block >> 16;
-	desc[10] = block >> 8;
-	desc[11] = block;
+	scsi_set_sense_information(sb, SCSI_SENSE_BUFFERSIZE, block);
 }
 
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
-- 
1.8.5.6

