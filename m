From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] esas2r: Fix possible sleep-in-atomic bugs in esas2r_check_adapter
Date: Tue, 12 Dec 2017 16:09:14 +0800
Message-ID: <1513066154-22571-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:40101 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdLLIHN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:07:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep in the interrupt handler.
The function call path is:
esas2r_adapter_tasklet (interrupt handler)
  esas2r_do_tasklet_tasks
    esas2r_handle_chip_rst_during_tasklet
      esas2r_check_adapter
        schedule_timeout_interruptible

To fix it, schedule_timeout_uninterruptible is replaced with mdelay.

This bug is found by my static analysis tool(DSAC) and checked by my code review.


Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/esas2r/esas2r_init.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 5b14dd2..0b9f547 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -1068,7 +1068,7 @@ bool esas2r_check_adapter(struct esas2r_adapter *a)
 			break;
 		}
 
-		schedule_timeout_interruptible(msecs_to_jiffies(100));
+		mdelay(100);
 
 		if ((jiffies_to_msecs(jiffies) - starttime) > 180000) {
 			esas2r_hdebug("FW ready TMO");
@@ -1091,7 +1091,7 @@ bool esas2r_check_adapter(struct esas2r_adapter *a)
 			break;
 		}
 
-		schedule_timeout_interruptible(msecs_to_jiffies(50));
+		mdelay(50);
 
 		if ((jiffies_to_msecs(jiffies) - starttime) > 3000) {
 			esas2r_hdebug("timeout waiting for interface down");
@@ -1180,7 +1180,7 @@ bool esas2r_check_adapter(struct esas2r_adapter *a)
 			break;
 		}
 
-		schedule_timeout_interruptible(msecs_to_jiffies(100));
+		mdelay(100);
 
 		if ((jiffies_to_msecs(jiffies) - starttime) > 3000) {
 			esas2r_hdebug(
-- 
1.7.9.5
