From: domen@coderock.org
Subject: [patch 1/1] scsi/osst: replace schedule_timeout() with msleep()
Date: Sun, 06 Mar 2005 23:27:41 +0100
Message-ID: <20050306222742.294F71EC90@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:62382 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261537AbVCFW16 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: osst@riede.org
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, nacc@us.ibm.com



Use msleep() instead of schedule_timeout() to guarantee the task
delays as expected. Although TASK_INTERRUPTIBLE is used in the current code,
there is no code dealing with an early return / signals_pending().

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/osst.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/osst.c~msleep-drivers_scsi_osst drivers/scsi/osst.c
--- kj/drivers/scsi/osst.c~msleep-drivers_scsi_osst	2005-03-05 16:10:51.000000000 +0100
+++ kj-domen/drivers/scsi/osst.c	2005-03-05 16:10:51.000000000 +0100
@@ -1558,8 +1558,7 @@ static int osst_reposition_and_retry(str
 			osst_set_frame_position(STp, aSRpnt, frame + skip, 1);
 			flag = 0;
 			attempts--;
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule_timeout(HZ / 10);
+			msleep(100);
 		}
 		if (osst_get_frame_position(STp, aSRpnt) < 0) {		/* additional write error */
 #if DEBUG
@@ -1621,7 +1620,7 @@ static int osst_reposition_and_retry(str
 		}
 #endif
 		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(HZ / 10);
+		msleep(100);
 	}
 	printk(KERN_ERR "%s:E: Failed to find valid tape media\n", name);
 #if DEBUG
_
