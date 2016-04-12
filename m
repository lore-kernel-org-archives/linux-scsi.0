From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 01/14] libata: do not attempt to retrieve sense code twice
Date: Tue, 12 Apr 2016 08:47:45 +0200
Message-ID: <1460443678-57934-2-git-send-email-hare@suse.de>
References: <1460443678-57934-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbcDLGsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Apr 2016 02:48:18 -0400
In-Reply-To: <1460443678-57934-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Do not call ata_request_sense() if the sense code is already
present.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/ata/libata-eh.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 5b340ce..e816619 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1660,7 +1660,7 @@ static void ata_eh_request_sense(struct ata_queued_cmd *qc,
 		return;
 	}
 
-	if (!cmd)
+	if (!cmd || qc->flags & ATA_QCFLAG_SENSE_VALID)
 		return;
 
 	if (!ata_id_sense_reporting_enabled(dev->id)) {
@@ -1849,7 +1849,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	memcpy(&qc->result_tf, &tf, sizeof(tf));
 	qc->result_tf.flags = ATA_TFLAG_ISADDR | ATA_TFLAG_LBA | ATA_TFLAG_LBA48;
 	qc->err_mask |= AC_ERR_DEV | AC_ERR_NCQ;
-	if (qc->result_tf.auxiliary) {
+	if ((qc->result_tf.command & ATA_SENSE) || qc->result_tf.auxiliary) {
 		char sense_key, asc, ascq;
 
 		sense_key = (qc->result_tf.auxiliary >> 16) & 0xff;
-- 
1.8.5.6

