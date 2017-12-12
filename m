From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: [PATCH] esas2r: Fix a possible sleep-in-atomic bug in esas2r_flash_access
Date: Tue, 12 Dec 2017 16:24:33 +0800
Message-ID: <1513067073-22976-1-git-send-email-baijiaju1990@163.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:38833 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750715AbdLLIW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Dec 2017 03:22:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxdrivers@attotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@163.com>

The driver may sleep in the interrupt handler.
The function call path is:
esas2r_adapter_tasklet (interrupt handler)
  esas2r_do_tasklet_tasks
    esas2r_handle_chip_rst_during_tasklet
      esas2r_init_adapter_hw
        esas2r_nvram_read_direct
          esas2r_read_flash_block
            esas2r_flash_access
              schedule_timeout_interruptible --> may sleep

To fix it, schedule_timeout_uninterruptible is replaced with mdelay.

This bug is found by my static analysis tool(DSAC) and checked by my code review.

Signed-off-by: Jia-Ju Bai <baijiaju1990@163.com>
---
 drivers/scsi/esas2r/esas2r_flash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d..9b3da4c 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -965,7 +965,7 @@ static bool esas2r_flash_access(struct esas2r_adapter *a, u32 function)
 				break;
 		}
 
-		schedule_timeout_interruptible(msecs_to_jiffies(100));
+		mdelay(100);
 
 		if ((jiffies_to_msecs(jiffies) - starttime) > timeout) {
 			/*
-- 
1.7.9.5
