From: janitor@sternwelten.at
Subject: [patch 04/10]  scsi/osst: replace 	schedule_timeout() with msleep_interruptible()
Date: Thu, 21 Oct 2004 10:47:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1CKYb9-0004E0-Rw@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:64232 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S270706AbUJUIrH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Oct 2004 04:47:07 -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, janitor@sternwelten.at, nacc@us.ibm.com




Any comments would be appreciated.

Description: Use msleep_interruptible() instead of
schedule_timeout() to guarantee the task delays as expected.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>
---

 linux-2.6.9-max/drivers/scsi/osst.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/osst.c~msleep-drivers_scsi_osst drivers/scsi/osst.c
--- linux-2.6.9/drivers/scsi/osst.c~msleep-drivers_scsi_osst	2004-10-21 02:41:29.000000000 +0200
+++ linux-2.6.9-max/drivers/scsi/osst.c	2004-10-21 02:41:29.000000000 +0200
@@ -1488,8 +1488,7 @@ static int osst_reposition_and_retry(OS_
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			msleep_interruptible(100);
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1550,7 +1549,7 @@ static int osst_reposition_and_retry(OS_
 			debugging = 0;
 		}
 #endif
-		schedule_timeout(HZ / 10);
+		msleep_interruptible(100);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG
_
