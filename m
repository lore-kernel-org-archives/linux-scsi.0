From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 10/16] aacraid: Terminate kthread on controller fw assert
Date: Tue, 14 Feb 2017 12:44:40 -0800
Message-ID: <20170214204446.14808-11-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0047.outbound.protection.outlook.com ([104.47.38.47]:42880
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751675AbdBODWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:38 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

When the command thread performs a periodic time sync and the firmware is
going through an assert during that time, the command thread waits for the
response that would never arrive. The SCSI Mid layer's error handler would
eventually reset the controller, but the eh_handler just issues a
"thread stop" to the command thread which is stuck on a semaphore and the
eh_thread would in turn goes to sleep waiting for the command_thread to
respond to the stop which never happens.

Fixed by allowing SIGTERM for the command thread, and during the eh_reset
call, sends termination signal to the command thread. As a follow-up, the
eh_reset handler would take care of the controller reset.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 78588e4..0ee91d0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1519,8 +1519,15 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	scsi_block_requests(host);
 	aac_adapter_disable_int(aac);
 	if (aac->thread->pid != current->pid) {
+		struct task_struct *tsk;
+
 		spin_unlock_irq(host->host_lock);
+		tsk = pid_task(find_vpid(aac->thread->pid), PIDTYPE_PID);
+		if (tsk)
+			send_sig(SIGTERM, tsk, 1);
 		kthread_stop(aac->thread);
+
+		dev_info(&aac->pdev->dev, "Command Thread Terminated\n");
 		jafo = 1;
 	}
 
-- 
2.7.4
