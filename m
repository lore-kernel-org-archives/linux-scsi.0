Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871E5C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 16:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67AD1608FE
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 16:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhGNQNU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 12:13:20 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54217 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S230427AbhGNQNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 12:13:20 -0400
Received: (qmail 384915 invoked by uid 1000); 14 Jul 2021 12:10:27 -0400
Date:   Wed, 14 Jul 2021 12:10:27 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
Subject: Re: SCSI layer RPM deadlock debug suggestion
Message-ID: <20210714161027.GC380727@rowland.harvard.edu>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
 <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
 <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 07, 2021 at 04:08:34PM +0100, John Garry wrote:
> > > > > > > Any suggestion on how to fix this deadlock?
> > > > > > This is indeed a tricky question.  It seems like we should allow a
> > > > > > runtime resume to succeed if the only reason it failed was that the
> > > > > > device has been removed.
> > > > > > 
> > > > > > More generally, perhaps we should always consider that a runtime
> > > > > > resume succeeds.  Any remaining problems will be dealt with by the
> > > > > > device's driver and subsystem once the device is marked as
> > > > > > runtime-active again.
> > > > > > 
> > > > > > Suppose you try changing blk_post_runtime_resume() so that it always
> > > > > > calls blk_set_runtime_active() regardless of the value of err.  Does
> > > > > > that fix the problem?
> > > > > > 
> 
> Hi Alan,
> 
> I tried that suggestion with the following change:
> 
> 
> --- a/block/blk-pm.c
> +++ b/block/blk-pm.c
> @@ -185,9 +185,8 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
>   */
> void blk_post_runtime_resume(struct request_queue *q, int err)
> {
> -
> +       err = 0;
>         if (!q->dev)
>                 return;
>         if (!err) {
> 
> 
> And that looks to solve the deadlock which I was seeing. I'm not sure on
> side-effects elsewhere.
> 
> We'll test it a bit more.

In the absence of any bad reports, here is a proposal for a patch.

Comments?

Alan Stern



John Garry reported a deadlock that occurs when trying to access a
runtime-suspended SATA device.  For obscure reasons, the rescan
procedure causes the link to be hard-reset, which disconnects the
device.

The rescan tries to carry out a runtime resume when accessing the
device.  scsi_rescan_device() holds the SCSI device lock and won't
release it until it can put commands onto the device's block queue.
This can't happen until the queue is successfully runtime-resumed or
the device is unregistered.  But the runtime resume fails because the
device is disconnected, and __scsi_remove_device() can't do the
unregistration because it can't get the device lock.

The best way to resolve this deadlock appears to be to allow the block
queue to start running again even after an unsuccessful runtime
resume.  The idea is that the driver or the SCSI error handler will
need to be able to use the queue to resolve the runtime resume
failure.

This patch removes the err argument to blk_post_runtime_resume() and
makes the routine act as though the resume was successful always.
This fixes the deadlock.

Reported-and-tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Fixes: e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
CC: Bart Van Assche <bvanassche@acm.org>
CC: Hannes Reinecke <hare@suse.de>
CC: <stable@vger.kernel.org>

---

 block/blk-pm.c         |   22 +++++++---------------
 drivers/scsi/scsi_pm.c |    2 +-
 include/linux/blk-pm.h |    2 +-
 3 files changed, 9 insertions(+), 17 deletions(-)

Index: usb-devel/block/blk-pm.c
===================================================================
--- usb-devel.orig/block/blk-pm.c
+++ usb-devel/block/blk-pm.c
@@ -163,27 +163,19 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
 /**
  * blk_post_runtime_resume - Post runtime resume processing
  * @q: the queue of the device
- * @err: return value of the device's runtime_resume function
  *
  * Description:
- *    Update the queue's runtime status according to the return value of the
- *    device's runtime_resume function. If the resume was successful, call
- *    blk_set_runtime_active() to do the real work of restarting the queue.
+ *    For historical reasons, this routine merely calls blk_set_runtime_active()
+ *    to do the real work of restarting the queue.  It does this regardless of
+ *    whether the device's runtime-resume succeeded; even if it failed the
+ *    driver or error handler will need to communicate with the device.
  *
  *    This function should be called near the end of the device's
  *    runtime_resume callback.
  */
-void blk_post_runtime_resume(struct request_queue *q, int err)
+void blk_post_runtime_resume(struct request_queue *q)
 {
-	if (!q->dev)
-		return;
-	if (!err) {
-		blk_set_runtime_active(q);
-	} else {
-		spin_lock_irq(&q->queue_lock);
-		q->rpm_status = RPM_SUSPENDED;
-		spin_unlock_irq(&q->queue_lock);
-	}
+	blk_set_runtime_active(q);
 }
 EXPORT_SYMBOL(blk_post_runtime_resume);
 
@@ -201,7 +193,7 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
  * runtime PM status and re-enable peeking requests from the queue. It
  * should be called before first request is added to the queue.
  *
- * This function is also called by blk_post_runtime_resume() for successful
+ * This function is also called by blk_post_runtime_resume() for
  * runtime resumes.  It does everything necessary to restart the queue.
  */
 void blk_set_runtime_active(struct request_queue *q)
Index: usb-devel/drivers/scsi/scsi_pm.c
===================================================================
--- usb-devel.orig/drivers/scsi/scsi_pm.c
+++ usb-devel/drivers/scsi/scsi_pm.c
@@ -262,7 +262,7 @@ static int sdev_runtime_resume(struct de
 	blk_pre_runtime_resume(sdev->request_queue);
 	if (pm && pm->runtime_resume)
 		err = pm->runtime_resume(dev);
-	blk_post_runtime_resume(sdev->request_queue, err);
+	blk_post_runtime_resume(sdev->request_queue);
 
 	return err;
 }
Index: usb-devel/include/linux/blk-pm.h
===================================================================
--- usb-devel.orig/include/linux/blk-pm.h
+++ usb-devel/include/linux/blk-pm.h
@@ -14,7 +14,7 @@ extern void blk_pm_runtime_init(struct r
 extern int blk_pre_runtime_suspend(struct request_queue *q);
 extern void blk_post_runtime_suspend(struct request_queue *q, int err);
 extern void blk_pre_runtime_resume(struct request_queue *q);
-extern void blk_post_runtime_resume(struct request_queue *q, int err);
+extern void blk_post_runtime_resume(struct request_queue *q);
 extern void blk_set_runtime_active(struct request_queue *q);
 #else
 static inline void blk_pm_runtime_init(struct request_queue *q,
