From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 08/14] libata-scsi: Generate sense code for disabled devices
Date: Mon, 25 Apr 2016 12:45:50 +0200
Message-ID: <1461581156-92581-9-git-send-email-hare@suse.de>
References: <1461581156-92581-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59284 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932083AbcDYKs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2016 06:48:28 -0400
In-Reply-To: <1461581156-92581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

If a device is disabled after error recovery it doesn't make
any sense to generate an ATA sense, but we should rather
return a generic sense code indicating the device is gone.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-scsi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 8b61d63..6d78b4b 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1126,6 +1126,12 @@ static void ata_gen_ata_sense(struct ata_queued_cmd *qc)
 
 	cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
 
+	if (ata_dev_disabled(dev)) {
+		/* Device disabled after error recovery */
+		/* LOGICAL UNIT NOT READY, HARD RESET REQUIRED */
+		ata_scsi_set_sense(dev, cmd, NOT_READY, 0x04, 0x21);
+		return;
+	}
 	/* Use ata_to_sense_error() to map status register bits
 	 * onto sense key, asc & ascq.
 	 */
-- 
1.8.5.6

