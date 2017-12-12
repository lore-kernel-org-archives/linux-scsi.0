From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] esas2r: Fix a possible sleep-in-atomic bug in esas2r_wait_request
Date: Tue, 12 Dec 2017 16:27:57 +0800
Message-ID: <1513067277-23126-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>
List-Id: linux-scsi@vger.kernel.org

The driver may sleep in the interrupt handler.
The function call path is:
esas2r_adapter_tasklet (interrupt handler)
  esas2r_do_tasklet_tasks
    esas2r_handle_chip_rst_during_tasklet
      esas2r_init_adapter_hw
        esas2r_init_msgs
          esas2r_wait_request
            schedule_timeout_interruptible --> may sleep

To fix it, schedule_timeout_uninterruptible is replaced with mdelay.

This bug is found by my static analysis tool(DSAC) and checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/esas2r/esas2r_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 4eb1430..4cd8f79 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -1307,7 +1307,7 @@ void esas2r_wait_request(struct esas2r_adapter *a, struct esas2r_request *rq)
 		if (rq->req_stat != RS_STARTED)
 			break;
 
-		schedule_timeout_interruptible(msecs_to_jiffies(100));
+		mdelay(100);
 
 		if ((jiffies_to_msecs(jiffies) - starttime) > timeout) {
 			esas2r_hdebug("request TMO");
-- 
1.7.9.5
