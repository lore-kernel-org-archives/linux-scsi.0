From: =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] scsi: sd: add missing KERN_CONT for disk spin-up
Date: Fri, 24 Nov 2017 18:02:35 +0100
Message-ID: <2a37c111d0ffed64653921fc405c7a17be64a41a.1511542918.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 78-11-180-123.static.ip.netia.com.pl ([78.11.180.123]:58352
        "EHLO rere.qmqm.pl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750731AbdKXRHo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Nov 2017 12:07:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

KERN_CONT is now required for continued printks(). Add it.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 drivers/scsi/sd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d175c5c5ccf8..9743b5f0800d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2142,7 +2142,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 			}
 			/* Wait 1 second for next try */
 			msleep(1000);
-			printk(".");
+			printk(KERN_CONT ".");
 
 		/*
 		 * Wait for USB flash devices with slow firmware.
@@ -2172,9 +2172,9 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 
 	if (spintime) {
 		if (scsi_status_is_good(the_result))
-			printk("ready\n");
+			printk(KERN_CONT "ready\n");
 		else
-			printk("not responding...\n");
+			printk(KERN_CONT "not responding...\n");
 	}
 }
 
-- 
2.11.0
