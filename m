From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 1/6] libata: use sleep instead of standby command
Date: Sat,  9 Nov 2013 16:03:23 -0500
Message-ID: <b13217d14f5d1519a045d02382e3009e2d194547.1384030893.git.psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46914 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319Ab3KIVDa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Nov 2013 16:03:30 -0500
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
In-Reply-To: <cover.1384030893.git.psusi@ubuntu.com>
References: <527EA218.6010604@ubuntu.com> <cover.1384030893.git.psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: todd.e.brandt@linux.intel.com
Cc: tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

The ATA SLEEP mode saves some more power than SUSPEND, and
has basically the same recovery time, so use it instead.
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

