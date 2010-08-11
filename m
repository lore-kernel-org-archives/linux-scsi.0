From: Dan Carpenter <error27@gmail.com>
Subject: [patch 2/2] mvsas: dereferencing before checking
Date: Wed, 11 Aug 2010 09:41:57 +0200
Message-ID: <20100811074157.GB30429@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Jiri Slaby <jslaby@suse.cz>, Srinivas <satyasrinivasp@hcl.in>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

If "mvi_dev" is NULL then we have to test it at the start of the function
and return if it is null.  In the original code, we dereferenced "mvi_dev"
before the check to assign "mvi" and then we dereferenced "mvi" to take
the spin lock.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 406246c..a5c5aa5 100644
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
