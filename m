From: domen@coderock.org
Subject: [patch 1/1] scsi/osst: use msleep() instead of schedule_timeout()
Date: Thu, 14 Jul 2005 23:43:04 +0200
Message-ID: <20050714214303.581877000@homer>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from coderock.org ([193.77.147.115]:63136 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S263146AbVGNVn0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 17:43:26 -0400
Content-Disposition: inline; filename=msleep-drivers_scsi_osst
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: linux-scsi@vger.kernel.org, Nishanth Aravamudan <nacc@us.ibm.com>, domen@coderock.org

From: Nishanth Aravamudan <nacc@us.ibm.com>


Replace schedule_timeout() with msleep() to guarantee the
task delays as expected.

Patch is compile-tested.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>

---
 osst.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

Index: quilt/drivers/scsi/osst.c
===================================================================
--- quilt.orig/drivers/scsi/osst.c
+++ quilt/drivers/scsi/osst.c
@@ -863,8 +863,7 @@ static int osst_recover_wait_frame(struc
 				retval = osst_write_error_recovery(STp, aSRpnt, 0);
 				break;
 			}
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout (HZ / OSST_POLL_PER_SEC);
+			msleep(1000 / OSST_POLL_PER_SEC);
 
 			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
 			memset(cmd, 0, MAX_COMMAND_SIZE);
@@ -1559,8 +1558,7 @@ static int osst_reposition_and_retry(str
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			msleep(100);
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1621,8 +1619,7 @@ static int osst_reposition_and_retry(str
 			debugging = 0;
 		}
 #endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);
+		msleep(100);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG

--
