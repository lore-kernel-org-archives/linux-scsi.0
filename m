From: janitor@sternwelten.at
Subject: [patch 6/7]  scsi/sd: replace schedule_timeout() with 	msleep()
Date: Wed, 01 Sep 2004 21:55:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bCI-0005sz-S6@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:24556 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267523AbUIATzL
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:55:11 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. 



Description: Use msleep() instead of schedule_timeout() to 
guarantee the task delays for the desired time.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/sd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/sd.c~msleep-drivers_scsi_sd drivers/scsi/sd.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/sd.c~msleep-drivers_scsi_sd	2004-09-01 19:35:48.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/sd.c	2004-09-01 19:35:48.000000000 +0200
@@ -48,6 +48,7 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/kref.h>
+#include <linux/delay.h>
 #include <asm/uaccess.h>
 
 #include <scsi/scsi.h>
@@ -943,7 +944,6 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 		 * Issue command to spin up drive when not ready
 		 */
 		} else if (SRpnt->sr_sense_buffer[2] == NOT_READY) {
-			unsigned long time1;
 			if (!spintime) {
 				printk(KERN_NOTICE "%s: Spinning up disk...",
 				       diskname);
@@ -962,12 +962,8 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
 				spintime_value = jiffies;
 			}
 			spintime = 1;
-			time1 = HZ;
 			/* Wait 1 second for next try */
-			do {
-				current->state = TASK_UNINTERRUPTIBLE;
-				time1 = schedule_timeout(time1);
-			} while(time1);
+			msleep(1000);
 			printk(".");
 		} else {
 			/* we don't understand the sense code, so it's

_
