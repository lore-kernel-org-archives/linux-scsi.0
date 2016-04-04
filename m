From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 03/14] libata-scsi: sanitize ata_gen_ata_sense()
Date: Mon,  4 Apr 2016 11:43:56 +0200
Message-ID: <1459763047-125551-4-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59392 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755110AbcDDJoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:24 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

ata_to_sense_error() is called conditionally, so we should be
generating a default sense if the condition is not met.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 6dc2fad..e331077 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1074,6 +1074,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 		ata_to_sense_error(qc->ap->print_id, tf->command, tf->feature,
 				   &sb[1], &sb[2], &sb[3], verbose);
 		sb[1] &= 0x0f;
+	} else {
+		/* Could not decode error */
+		ata_dev_warn(dev, "could not decode error status 0x%x err_mask 0x%x\n",
+			     tf->command, qc->err_mask);
+		ata_scsi_set_sense(cmd, ABORTED_COMMAND, 0, 0);
+		return;
 	}
 
 	block = ata_tf_read_block(&qc->result_tf, dev);
-- 
1.8.5.6

