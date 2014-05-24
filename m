From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] [SCSI] dc395x: remove check for
 CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
Date: Sat, 24 May 2014 13:09:18 +0200
Message-ID: <1400929758.22523.2.camel@x220>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: dc395x@twibble.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This driver has always contained a check for
CONFIG_SCSI_DC395x_TRMS1040_TRADMAP. But a Kconfig symbol
SCSI_DC395x_TRMS1040_TRADMAP was never added to the tree. Besides, the
code that this check hides can't compile, since "geom" is never defined.
Remove it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested.

 drivers/scsi/dc395x.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 83d9bf6fa6ca..cd0b2bf4369e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1164,29 +1164,7 @@ static DEF_SCSI_QCMD(dc395x_queue_command)
 static int dc395x_bios_param(struct scsi_device *sdev,
 		struct block_device *bdev, sector_t capacity, int *info)
 {
-#ifdef CONFIG_SCSI_DC395x_TRMS1040_TRADMAP
-	int heads, sectors, cylinders;
-	struct AdapterCtlBlk *acb;
-	int size = capacity;
-
-	dprintkdbg(DBG_0, "dc395x_bios_param..............\n");
-	acb = (struct AdapterCtlBlk *)sdev->host->hostdata;
-	heads = 64;
-	sectors = 32;
-	cylinders = size / (heads * sectors);
-
-	if ((acb->gmode2 & NAC_GREATER_1G) && (cylinders > 1024)) {
-		heads = 255;
-		sectors = 63;
-		cylinders = size / (heads * sectors);
-	}
-	geom[0] = heads;
-	geom[1] = sectors;
-	geom[2] = cylinders;
-	return 0;
-#else
 	return scsicam_bios_param(bdev, capacity, info);
-#endif
 }
 

-- 
1.9.0
