Return-Path: <SRS0=95cY=AR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10AC4C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED6DD20724
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jul 2020 15:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgGFPOi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:14:38 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55325 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1729297AbgGFPOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2020 11:14:38 -0400
Received: (qmail 703322 invoked by uid 1000); 6 Jul 2020 11:14:36 -0400
Date:   Mon, 6 Jul 2020 11:14:36 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     martin.petersen@oracle.com, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: [PATCH v3] SCSI and block: Simplify resume handling
Message-ID: <20200706151436.GA702867@rowland.harvard.edu>
References: <20200701183718.GA507293@rowland.harvard.edu>
 <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e824700-dfd1-5d71-5e91-833c35ea55eb@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 05d18ae1cc8a ("scsi: pm: Balance pm_only counter of request
queue during system resume") fixed a problem in the block layer's
runtime-PM code: blk_set_runtime_active() failed to call
blk_clear_pm_only().  However, the commit's implementation was
awkward; it forced the SCSI system-resume handler to choose whether to
call blk_post_runtime_resume() or blk_set_runtime_active(), depending
on whether or not the SCSI device had previously been runtime
suspended.

This patch simplifies the situation considerably by adding the missing
function call directly into blk_set_runtime_active() (under the
condition that the queue is not already in the RPM_ACTIVE state).
This allows the SCSI routine to revert back to its original form.
Furthermore, making this change reveals that blk_post_runtime_resume()
(in its success pathway) does exactly the same thing as
blk_set_runtime_active().  The duplicate code is easily removed by
making one routine call the other.

No functional changes are intended.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Can Guo <cang@codeaurora.org>
CC: Bart Van Assche <bvanassche@acm.org>

---

v3:	Arrange the code in blk_pm_post_runtime_resume() and
	blk_set_runtime_active() so that the "if (!q->dev)" tests and
	early returns come first, as in the other nearby functions.

v2:	Don't call blk_clear_pm_only() if the queue's RPM status was
	already set to RPM_ACTIVE.  This happens during a system resume
	if the device was not in runtime suspend beforehand.


[as1939c]


 block/blk-pm.c         |   41 ++++++++++++++++++++++-------------------
 drivers/scsi/scsi_pm.c |   10 ++--------
 2 files changed, 24 insertions(+), 27 deletions(-)

Index: usb-devel/block/blk-pm.c
===================================================================
--- usb-devel.orig/block/blk-pm.c
+++ usb-devel/block/blk-pm.c
@@ -164,9 +164,8 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
  *
  * Description:
  *    Update the queue's runtime status according to the return value of the
- *    device's runtime_resume function. If it is successfully resumed, process
- *    the requests that are queued into the device's queue when it is resuming
- *    and then mark last busy and initiate autosuspend for it.
+ *    device's runtime_resume function. If the resume was successful, call
+ *    blk_set_runtime_active() to do the real work of restarting the queue.
  *
  *    This function should be called near the end of the device's
  *    runtime_resume callback.
@@ -175,19 +174,13 @@ void blk_post_runtime_resume(struct requ
 {
 	if (!q->dev)
 		return;
-
-	spin_lock_irq(&q->queue_lock);
 	if (!err) {
-		q->rpm_status = RPM_ACTIVE;
-		pm_runtime_mark_last_busy(q->dev);
-		pm_request_autosuspend(q->dev);
+		blk_set_runtime_active(q);
 	} else {
+		spin_lock_irq(&q->queue_lock);
 		q->rpm_status = RPM_SUSPENDED;
+		spin_unlock_irq(&q->queue_lock);
 	}
-	spin_unlock_irq(&q->queue_lock);
-
-	if (!err)
-		blk_clear_pm_only(q);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
 
@@ -204,15 +197,25 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
  * This function can be used in driver's resume hook to correct queue
  * runtime PM status and re-enable peeking requests from the queue. It
  * should be called before first request is added to the queue.
+ *
+ * This function is also called by blk_post_runtime_resume() for successful
+ * runtime resumes.  It does everything necessary to restart the queue.
  */
 void blk_set_runtime_active(struct request_queue *q)
 {
-	if (q->dev) {
-		spin_lock_irq(&q->queue_lock);
-		q->rpm_status = RPM_ACTIVE;
-		pm_runtime_mark_last_busy(q->dev);
-		pm_request_autosuspend(q->dev);
-		spin_unlock_irq(&q->queue_lock);
-	}
+	int old_status;
+
+	if (!q->dev)
+		return;
+
+	spin_lock_irq(&q->queue_lock);
+	old_status = q->rpm_status;
+	q->rpm_status = RPM_ACTIVE;
+	pm_runtime_mark_last_busy(q->dev);
+	pm_request_autosuspend(q->dev);
+	spin_unlock_irq(&q->queue_lock);
+
+	if (old_status != RPM_ACTIVE)
+		blk_clear_pm_only(q);
 }
 EXPORT_SYMBOL(blk_set_runtime_active);
Index: usb-devel/drivers/scsi/scsi_pm.c
===================================================================
--- usb-devel.orig/drivers/scsi/scsi_pm.c
+++ usb-devel/drivers/scsi/scsi_pm.c
@@ -80,10 +80,6 @@ static int scsi_dev_type_resume(struct d
 	dev_dbg(dev, "scsi resume: %d\n", err);
 
 	if (err == 0) {
-		bool was_runtime_suspended;
-
-		was_runtime_suspended = pm_runtime_suspended(dev);
-
 		pm_runtime_disable(dev);
 		err = pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
@@ -97,10 +93,8 @@ static int scsi_dev_type_resume(struct d
 		 */
 		if (!err && scsi_is_sdev_device(dev)) {
 			struct scsi_device *sdev = to_scsi_device(dev);
-			if (was_runtime_suspended)
-				blk_post_runtime_resume(sdev->request_queue, 0);
-			else
-				blk_set_runtime_active(sdev->request_queue);
+
+			blk_set_runtime_active(sdev->request_queue);
 		}
 	}
 
