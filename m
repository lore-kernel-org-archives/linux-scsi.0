From: Phillip Susi <psusi@ubuntu.com>
Subject: [PATCH 1/6] libata: use sleep instead of standby command
Date: Mon, 16 Dec 2013 18:30:52 -0500
Message-ID: <1387236657-4852-2-git-send-email-psusi@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:33888 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3LPXbB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Dec 2013 18:31:01 -0500
In-Reply-To: <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
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
index db6dfcf..f92eb21 100644
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

