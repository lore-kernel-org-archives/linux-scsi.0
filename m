From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 1/2] libata: use sleep instead of standby command
Date: Mon,  4 Nov 2013 19:52:59 -0500
Message-ID: <1383612780-6591-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The ATA SLEEP mode saves some more power than SUSPEND, and
has basically the same recovery time, so use it instead.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 drivers/ata/libata-scsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 97a0cef..79b75fd 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1362,8 +1362,8 @@ static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
 		     system_entering_hibernation())
 			goto skip;
 
-		/* Issue ATA STANDBY IMMEDIATE command */
-		tf->command = ATA_CMD_STANDBYNOW1;
+		/* Issue ATA SLEEP command */
+		tf->command = ATA_CMD_SLEEP;
 	}
 
 	/*
-- 
1.8.3.2
