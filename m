From: Andy Yan <ayan@marvell.com>
Subject: [PATCH 2/5] mvsas: bug fix of dead lock
Date: Tue, 12 May 2009 01:20:54 +0800
Message-ID: <20090511172054.GB9698@Andy.marvell.com>
Reply-To: ayan@marvell.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:20479 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754374AbZEKIaN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 May 2009 04:30:13 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, jeff@garzik.org

>From fda3efb9dfb8d2b1ff5ef12ee7473ec0c1e8368e Mon Sep 17 00:00:00 2001
From: Andy Yan <ayan@marvell.com>
Date: Mon, 11 May 2009 20:05:26 +0800
Subject: [PATCH 2/5] mvsas: bug fix of dead lock
 
TMF task should be issued with Interrupt Disabled, or Deadlock may take place.
Clean-up unused parameters and conditonal lock.

Signed-off-by: Ying Chu <jasonchu@marvell.com>
Signed-off-by: Andy Yan <ayan@marvell.com>
Signed-off-by: Ke Wei <kewei@marvell.com>
---
 drivers/scsi/mvsas/mv_sas.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f709319..4279b5e 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -868,8 +868,8 @@ static int mvs_task_prep_ssp(struct mvs_info *mvi,
 
 #define	DEV_IS_GONE(mvi_dev)	((!mvi_dev || (mvi_dev->dev_type == NO_DEVICE)))
 static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
-				struct completion *completion, int lock,
-				int is_tmf, struct mvs_tmf_task *tmf)
+				struct completion *completion,int is_tmf,
+				struct mvs_tmf_task *tmf)
 {
 	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi;
@@ -892,8 +892,7 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 
 	mvi = mvs_find_dev_mvi(task->dev);
 
-	if (lock)
-		spin_lock_irqsave(&mvi->lock, flags);
+	spin_lock_irqsave(&mvi->lock, flags);
 	do {
 		dev = t->dev;
 		mvi_dev = (struct mvs_device *)dev->lldd_dev;
@@ -1020,15 +1019,14 @@ out_done:
 		MVS_CHIP_DISP->start_delivery(mvi,
 			(mvi->tx_prod - 1) & (MVS_CHIP_SLOT_SZ - 1));
 	}
-	if (lock)
-		spin_unlock_irqrestore(&mvi->lock, flags);
+	spin_unlock_irqrestore(&mvi->lock, flags);
 	return rc;
 }
 
 int mvs_queue_command(struct sas_task *task, const int num,
 			gfp_t gfp_flags)
 {
-	return mvs_task_exec(task, num, gfp_flags, NULL, 1, 0, NULL);
+	return mvs_task_exec(task, num, gfp_flags, NULL, 0, NULL);
 }
 
 static void mvs_slot_free(struct mvs_info *mvi, u32 rx_desc)
@@ -1448,7 +1446,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 		task->timer.expires = jiffies + MVS_TASK_TIMEOUT*HZ;
 		add_timer(&task->timer);
 
-		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 0, 1, tmf);
+		res = mvs_task_exec(task, 1, GFP_KERNEL, NULL, 1, tmf);
 
 		if (res) {
 			del_timer(&task->timer);
-- 
1.6.2.1

