From: Dan Carpenter <error27@gmail.com>
Subject: [patch] mvsas: a couple potential null derefs
Date: Sat, 22 May 2010 22:35:59 +0200
Message-ID: <20100522203559.GS22515@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52277 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757978Ab0EVUgc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2010 16:36:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Andy Yan <ayan@marvell.com>, Ying Chu <jasonchu@marvell.com>, Ke Wei <kewei@marvell.com>, Srinivas <satyasrinivasp@hcl.in>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

Smatch complained because we dereferenced "mvi_dev" before verifying
that it was non-null.  Also there was a missing "goto out" after an error
condition.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index f5e3217..b1f552e 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1379,19 +1379,21 @@ void mvs_dev_gone_notify(struct domain_device *dev)
 {
 	unsigned long flags = 0;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
-
-	spin_lock_irqsave(&mvi->lock, flags);
+	struct mvs_info *mvi;
 
-	if (mvi_dev) {
-		mv_dprintk("found dev[%d:%x] is gone.\n",
-			mvi_dev->device_id, mvi_dev->dev_type);
-		mvs_release_task(mvi, dev);
-		mvs_free_reg_set(mvi, mvi_dev);
-		mvs_free_dev(mvi_dev);
-	} else {
+	if (!mvi_dev) {
 		mv_dprintk("found dev has gone.\n");
+		return;
 	}
+
+	mvi = mvi_dev->mvi_info;
+	spin_lock_irqsave(&mvi->lock, flags);
+
+	mv_dprintk("found dev[%d:%x] is gone.\n",
+		mvi_dev->device_id, mvi_dev->dev_type);
+	mvs_release_task(mvi, dev);
+	mvs_free_reg_set(mvi, mvi_dev);
+	mvs_free_dev(mvi_dev);
 	dev->lldd_dev = NULL;
 
 	spin_unlock_irqrestore(&mvi->lock, flags);
@@ -1640,7 +1642,7 @@ int mvs_abort_task(struct sas_task *task)
 	struct mvs_tmf_task tmf_task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = (struct mvs_device *)dev->lldd_dev;
-	struct mvs_info *mvi = mvi_dev->mvi_info;
+	struct mvs_info *mvi;
 	int rc = TMF_RESP_FUNC_FAILED;
 	unsigned long flags;
 	u32 tag;
@@ -1648,7 +1650,9 @@ int mvs_abort_task(struct sas_task *task)
 	if (!mvi_dev) {
 		mv_printk("%s:%d TMF_RESP_FUNC_FAILED\n", __func__, __LINE__);
 		rc = TMF_RESP_FUNC_FAILED;
+		goto out;
 	}
+	mvi = mvi_dev->mvi_info;
 
 	spin_lock_irqsave(&task->task_state_lock, flags);
 	if (task->task_state_flags & SAS_TASK_STATE_DONE) {
