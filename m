From: janitor@sternwelten.at
Subject: [patch 2/7]  scsi/osst: replace schedule_timeout() 	with msleep()
Date: Wed, 01 Sep 2004 21:54:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2bBw-0005q7-T3@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:23466 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267512AbUIATyu
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 15:54:50 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at







I would appreciate any comments from the janitor@sternweltens list. This is one (of
many) cases where I made a decision about replacing

set_current_state(TASK_INTERRUPTIBLE);
schedule_timeout(some_time);

with

msleep(jiffies_to_msecs(some_time));

msleep() is not exactly the same as the previous code, but I only did
this replacement where I thought long delays were *desired*. If this is
not the case here, then just disregard this patch.

Thanks,
Nish



Description: Replace schedule_timeout() with msleep() to guarantee the task
delays as desired.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Maximilian Attems <janitor@sternwelten.at>



---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/osst.c |   18 ++++++------------
 1 files changed, 6 insertions(+), 12 deletions(-)

diff -puN drivers/scsi/osst.c~msleep-drivers_scsi_osst drivers/scsi/osst.c
--- linux-2.6.9-rc1-bk7/drivers/scsi/osst.c~msleep-drivers_scsi_osst	2004-09-01 19:35:45.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/osst.c	2004-09-01 19:35:45.000000000 +0200
@@ -613,10 +613,8 @@ static int osst_wait_ready(OS_Scsi_Tape 
 	printk(OSST_DEB_MSG "%s:D: Reached onstream wait ready\n", name);
 #endif
 
-	if (initial_delay > 0) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout(initial_delay);
-	}
+	if (initial_delay > 0)
+		msleep(jiffies_to_msecs(initial_delay));
 
 	memset(cmd, 0, MAX_COMMAND_SIZE);
 	cmd[0] = TEST_UNIT_READY;
@@ -637,8 +635,7 @@ static int osst_wait_ready(OS_Scsi_Tape 
 		debugging = 0;
 	    }
 #endif
-	    set_current_state(TASK_INTERRUPTIBLE);
-	    schedule_timeout(HZ / 10);
+	    msleep(100);
 
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
@@ -697,8 +694,7 @@ static int osst_wait_for_medium(OS_Scsi_
 		debugging = 0;
 	    }
 #endif
-	    set_current_state(TASK_INTERRUPTIBLE);
-	    schedule_timeout(HZ / 10);
+	    msleep(100);
 
 	    memset(cmd, 0, MAX_COMMAND_SIZE);
 	    cmd[0] = TEST_UNIT_READY;
@@ -818,8 +814,7 @@ static int osst_wait_frame(OS_Scsi_Tape 
 			notyetprinted--;
 		}
 #endif
-		set_current_state(TASK_INTERRUPTIBLE);
-		schedule_timeout (HZ / OSST_POLL_PER_SEC);
+		msleep(1000 / OSST_POLL_PER_SEC);
 	}
 #if DEBUG
 	printk (OSST_DEB_MSG "%s:D: Fail wait f fr %i (>%i): %i-%i %i: %3li.%li s\n",
@@ -1420,8 +1415,7 @@ static int osst_read_back_buffer_and_rew
 					if (SRpnt->sr_sense_buffer[2] == 2 && SRpnt->sr_sense_buffer[12] == 4 &&
 					    (SRpnt->sr_sense_buffer[13] == 1 || SRpnt->sr_sense_buffer[13] == 8)) {
 						/* in the process of becoming ready */
-						set_current_state(TASK_INTERRUPTIBLE);
-						schedule_timeout(HZ / 10);
+						msleep(100);
 						continue;
 					}
 					if (STp->buffer->syscall_result)

_
