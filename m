From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/6] libata: avoid waking disk to check power
Date: Sat,  9 Nov 2013 16:03:24 -0500
Message-ID: <04ad6fca8105259a952c5d7c9ec5c5c0c52e6266.1384030893.git.psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46914 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab3KIVDb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 16:03:31 -0500
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
References: <527EA218.6010604@ubuntu.com> <cover.1384030893.git.psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

When a disk is in SLEEP mode it can not respond to commands,
including the CHECK POWER command.  Instead of waking up the
sleeping disk, fake the reply to the CHECK POWER command to
indicate the disk is in standby mode.  This prevents udisks
from waking up sleeping disks when it polls to see if they
are awake or not before trying to read their smart status.
---
 drivers/ata/libata-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 83b1a9f..686c441 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5084,6 +5084,14 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
+		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER))
+		{
+			/* fake reply to avoid waking drive */
+			qc->flags &= ~ATA_QCFLAG_RESULT_TF;
+			qc->result_tf.nsect = 0;
+			ata_qc_complete(qc);
+			return;
+		}
 		link->eh_info.action |= ATA_EH_RESET;
 		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
 		ata_link_abort(link);
-- 
1.8.3.2

