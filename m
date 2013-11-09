From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 6/6] libata: fake some more commands when drive is sleeping
Date: Sat,  9 Nov 2013 16:03:28 -0500
Message-ID: <eb83c221015ccb11181d94173ad181b7dc89cd87.1384030893.git.psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
References: <527EA218.6010604@ubuntu.com> <cover.1384030893.git.psusi@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The sd driver issues a flush cache when suspending, and this was causing
a sleeping drive to wake up for no reason.  Another sleep or standby
command when the drive is already sleeping obviously should also not cause
the disk to spin up.
---
 drivers/ata/libata-core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index c53c210..25d141e 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5092,7 +5092,11 @@ void ata_qc_issue(struct ata_queued_cmd *qc)
 
 	/* if device is sleeping, schedule reset and abort the link */
 	if (unlikely(qc->dev->flags & ATA_DFLAG_SLEEPING)) {
-		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER))
+		if (unlikely(qc->tf.command == ATA_CMD_CHK_POWER ||
+			     qc->tf.command == ATA_CMD_SLEEP ||
+			     qc->tf.command == ATA_CMD_FLUSH ||
+			     qc->tf.command == ATA_CMD_FLUSH_EXT ||
+			     qc->tf.command == ATA_CMD_STANDBYNOW1))
 		{
 			/* fake reply to avoid waking drive */
 			qc->flags &= ~ATA_QCFLAG_RESULT_TF;
-- 
1.8.3.2

