From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/6] libata: avoid waking disk for several commands
Date: Mon, 16 Dec 2013 18:30:53 -0500
Message-ID: <1387236657-4852-3-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46507 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab3LPXbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 18:31:01 -0500
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

When a disk is in SLEEP mode it can not respond to any
commands.  Instead of waking up the sleeping disk, fake the
commands.  The commands include:

CHECK POWER
FLUSH CACHE
SLEEP
STANDBY IMMEDIATE
IDENTIFY

If we konw the disk is sleeping, we don't need to wake it up
to to find out if it is in standby, so just pretend it is in
standby.  While alseep, there's no dirty pages in the cache,
so there's no need to flush it.  There's no point in waking
a disk from sleep just to put it back to sleep.  We also have
a cache of the IDENTIFY information so just return that
instead of waking the disk.
---
 drivers/ata/libata-core.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 81a94a3..8f856bb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5085,6 +5085,22 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
+		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER ||
+			     qc->tf.command == ATA_CMD_SLEEP ||
+			     qc->tf.command == ATA_CMD_FLUSH ||
+			     qc->tf.command == ATA_CMD_FLUSH_EXT ||
+			     qc->tf.command == ATA_CMD_STANDBYNOW1 ||
+			     (qc->tf.command == ATA_CMD_ID_ATA &&
+			      !ata_tag_internal(qc->tag))))
+		{
+			/* fake reply to avoid waking drive */
+			qc->flags &= ~ATA_QCFLAG_RESULT_TF;
+			qc->result_tf.nsect = 0;
+			if (qc->tf.command == ATA_CMD_ID_ATA)
+				sg_copy_from_buffer(qc->sg, 1, qc->dev->id, 2 * ATA_ID_WORDS);
+			ata_qc_complete(qc);
+			return;
+		}
 		link->eh_info.action |= ATA_EH_RESET;
 		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
 		ata_link_abort(link);
-- 
1.8.3.2

