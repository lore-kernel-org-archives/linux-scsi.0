From: Ying Chu <jasonchu@marvell.com>
Subject: [PATCH 2/4] mvsas: Deadlocks meet when TMF tasks issue
Date: Fri, 8 May 2009 14:16:05 +0800
Message-ID: <20090508061605.GA1884@jason.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:50426 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751481AbZEHGQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 02:16:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jeff@garzik.org, james.bottomley@hansenpartnership.com

>From 58f754f51fced4a39adcf708319e3de946a0d61a Mon Sep 17 00:00:00 2001
From: Andy <ayan@marvell.com>
Date: Mon, 4 May 2009 23:31:43 +0800
Subject: [PATCH 2/4] bug fix: deal lock 

TMF task need be issued with Interrupt Disabled, or Deadlock may take place.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 318ec01..cb002ef 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1446,7 +1446,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 		task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
 		add_timer(&task->timer);
 
-		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 0, 1, tmf);
+		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 1, 1, tmf);
 
 		if (res) {
 			del_timer(&task->timer);
-- 
1.6.0.3

-- 
Regards,
Ying Chu
