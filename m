From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] scsi: sd: make disk spin-up quieter
Date: Wed, 30 Aug 2017 00:00:15 +0200
Message-ID: <29ebd092338f51b297e94510d88892492ee3b690.1504043937.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 78-11-180-123.static.ip.netia.com.pl ([78.11.180.123]:55376
        "EHLO rere.qmqm.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751492AbdH2WAR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2017 18:00:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Currently disk spin-up is generating one line per second. Make it
less verbose by setting DEBUG level for progress indicators.
Add device id prefixes while at it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/sd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b6bb4e0ce0e3..7544b60e5a6d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2117,7 +2117,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(".");
+			sd_printk(KERN_DEBUG, sdkp, ".");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -2147,9 +2147,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk("ready\n");
+			sd_printk(KERN_NOTICE, sdkp, "disk is ready\n");
 		else
-			printk("not responding...\n");
+			sd_printk(KERN_NOTICE, sdkp, "disk not responding...\n");
 	}
 }
 
-- 
2.11.0
