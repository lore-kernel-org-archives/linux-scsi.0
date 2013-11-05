From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 2/2] libata: avoid waking disk to check power
Date: Mon,  4 Nov 2013 19:53:00 -0500
Message-ID: <1383612780-6591-2-git-send-email-psusi@ubuntu.com>
References: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When a disk is in SLEEP mode it can not respond to commands,
including the CHECK POWER command.  Instead of waking up the
sleeping disk, fake the reply to the CHECK POWER command to
indicate the disk is in standby mode.  This prevents udisks
from waking up sleeping disks when it polls to see if they
are awake or not before trying to read their smart status.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 drivers/ata/libata-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 83b1a9f..573d151 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5084,6 +5084,13 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
+		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER))
+		{
+			/* fake reply to avoid waking drive */
+			qc->result_tf.nsect = 0;
+			ata_qc_complete(qc);
+			return;
+		}
 		link->eh_info.action |= ATA_EH_RESET;
 		ata_ehi_push_desc(&link->eh_info, "waking up from sleep");
 		ata_link_abort(link);
-- 
1.8.3.2
