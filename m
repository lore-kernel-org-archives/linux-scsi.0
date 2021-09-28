Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 368E3C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1957E61130
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 14:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240803AbhI1OHZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 10:07:25 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49693 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S240172AbhI1OHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 10:07:25 -0400
Received: (qmail 393547 invoked by uid 1000); 28 Sep 2021 10:05:44 -0400
Date:   Tue, 28 Sep 2021 10:05:44 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     John Garry <john.garry@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@suse.com>,
        "chenxiang \(M\)" <chenxiang66@hisilicon.com>,
        Xiejianqin <xiejianqin@hisilicon.com>
Subject: Re: SCSI layer RPM deadlock debug suggestion
Message-ID: <20210928140544.GA393436@rowland.harvard.edu>
References: <9e90d035-fac1-432a-1d34-de5805d8f799@huawei.com>
 <20210702203142.GA49307@rowland.harvard.edu>
 <ec4a3038-34b0-084f-a1bd-039827465dd1@acm.org>
 <1081c3ed-0762-58c7-8b99-8b3721c710bd@huawei.com>
 <20210705131712.GB116379@rowland.harvard.edu>
 <a5b9109c-cad6-0057-29c9-8974fda3347c@suse.de>
 <47f35811-33c5-9620-45d5-8201e5ec5db3@huawei.com>
 <20210714161027.GC380727@rowland.harvard.edu>
 <dc75007c-4a07-d1a9-6b86-2f6d2dc59271@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc75007c-4a07-d1a9-6b86-2f6d2dc59271@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 14, 2021 at 05:48:36PM +0100, John Garry wrote:
> > > 
> > > And that looks to solve the deadlock which I was seeing. I'm not sure on
> > > side-effects elsewhere.
> > > 
> > > We'll test it a bit more.
> > 
> > In the absence of any bad reports, here is a proposal for a patch.
> > 
> > Comments?
> > 
> > Alan Stern
> 
> Hi Alan,
> 
> Sorry for not getting back to you sooner. Testing so far with the originally
> proposed change [0] has not raised any issues and has solved the deadlock.
> 
> But we have a list of other problems to deal with in the RPM area related to
> the LLDD/libsas, so were waiting to address all of them (or at least have a
> plan) before progressing this change.
> 
> One such issue is that when we issue the link-reset which causes the device
> to be lost in the test, the disk is not found again. The customer may not be
> happy with this, so we're investigating solutions.
> 
> As for your change itself, I had something similar sitting on our dev
> branch:
> 
> [0] https://github.com/hisilicon/kernel-dev/commit/3696ca85c1e00257c96e40154d28b936742430c4
> 
> For me, I'm happy to hold off on any change, but if you think it's serious
> enough to progress your patch, below, now, then I think that should be ok.
> 
> Thanks,
> John

John:

We seem to have forgotten all about this.  I just now noticed that 
this hadn't gotten in 5.15-rc3... and the reason is that it was never 
submitted!

What would you like to do?

Alan Stern

> 
> > 
> > 
> > 
> > John Garry reported a deadlock that occurs when trying to access a
> > runtime-suspended SATA device.  For obscure reasons, the rescan
> > procedure causes the link to be hard-reset, which disconnects the
> > device.
> > 
> > The rescan tries to carry out a runtime resume when accessing the
> > device.  scsi_rescan_device() holds the SCSI device lock and won't
> > release it until it can put commands onto the device's block queue.
> > This can't happen until the queue is successfully runtime-resumed or
> > the device is unregistered.  But the runtime resume fails because the
> > device is disconnected, and __scsi_remove_device() can't do the
> > unregistration because it can't get the device lock.
> > 
> > The best way to resolve this deadlock appears to be to allow the block
> > queue to start running again even after an unsuccessful runtime
> > resume.  The idea is that the driver or the SCSI error handler will
> > need to be able to use the queue to resolve the runtime resume
> > failure.
> > 
> > This patch removes the err argument to blk_post_runtime_resume() and
> > makes the routine act as though the resume was successful always.
> > This fixes the deadlock.
> > 
> > Reported-and-tested-by: John Garry <john.garry@huawei.com>
> > Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> > Fixes: e27829dc92e5 ("scsi: serialize ->rescan against ->remove")
> > CC: Bart Van Assche <bvanassche@acm.org>
> > CC: Hannes Reinecke <hare@suse.de>
> > CC: <stable@vger.kernel.org>
> > 
> > ---
> > 
> >   block/blk-pm.c         |   22 +++++++---------------
> >   drivers/scsi/scsi_pm.c |    2 +-
> >   include/linux/blk-pm.h |    2 +-
> >   3 files changed, 9 insertions(+), 17 deletions(-)
> > 
> > Index: usb-devel/block/blk-pm.c
> > ===================================================================
> > --- usb-devel.orig/block/blk-pm.c
> > +++ usb-devel/block/blk-pm.c
> > @@ -163,27 +163,19 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
> >   /**
> >    * blk_post_runtime_resume - Post runtime resume processing
> >    * @q: the queue of the device
> > - * @err: return value of the device's runtime_resume function
> >    *
> >    * Description:
> > - *    Update the queue's runtime status according to the return value of the
> > - *    device's runtime_resume function. If the resume was successful, call
> > - *    blk_set_runtime_active() to do the real work of restarting the queue.
> > + *    For historical reasons, this routine merely calls blk_set_runtime_active()
> > + *    to do the real work of restarting the queue.  It does this regardless of
> > + *    whether the device's runtime-resume succeeded; even if it failed the
> > + *    driver or error handler will need to communicate with the device.
> >    *
> >    *    This function should be called near the end of the device's
> >    *    runtime_resume callback.
> >    */
> > -void blk_post_runtime_resume(struct request_queue *q, int err)
> > +void blk_post_runtime_resume(struct request_queue *q)
> >   {
> > -	if (!q->dev)
> > -		return;
> > -	if (!err) {
> > -		blk_set_runtime_active(q);
> > -	} else {
> > -		spin_lock_irq(&q->queue_lock);
> > -		q->rpm_status = RPM_SUSPENDED;
> > -		spin_unlock_irq(&q->queue_lock);
> > -	}
> > +	blk_set_runtime_active(q);
> >   }
> >   EXPORT_SYMBOL(blk_post_runtime_resume);
> > @@ -201,7 +193,7 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
> >    * runtime PM status and re-enable peeking requests from the queue. It
> >    * should be called before first request is added to the queue.
> >    *
> > - * This function is also called by blk_post_runtime_resume() for successful
> > + * This function is also called by blk_post_runtime_resume() for
> >    * runtime resumes.  It does everything necessary to restart the queue.
> >    */
> >   void blk_set_runtime_active(struct request_queue *q)
> > Index: usb-devel/drivers/scsi/scsi_pm.c
> > ===================================================================
> > --- usb-devel.orig/drivers/scsi/scsi_pm.c
> > +++ usb-devel/drivers/scsi/scsi_pm.c
> > @@ -262,7 +262,7 @@ static int sdev_runtime_resume(struct de
> >   	blk_pre_runtime_resume(sdev->request_queue);
> >   	if (pm && pm->runtime_resume)
> >   		err = pm->runtime_resume(dev);
> > -	blk_post_runtime_resume(sdev->request_queue, err);
> > +	blk_post_runtime_resume(sdev->request_queue);
> >   	return err;
> >   }
> > Index: usb-devel/include/linux/blk-pm.h
> > ===================================================================
> > --- usb-devel.orig/include/linux/blk-pm.h
> > +++ usb-devel/include/linux/blk-pm.h
> > @@ -14,7 +14,7 @@ extern void blk_pm_runtime_init(struct r
> >   extern int blk_pre_runtime_suspend(struct request_queue *q);
> >   extern void blk_post_runtime_suspend(struct request_queue *q, int err);
> >   extern void blk_pre_runtime_resume(struct request_queue *q);
> > -extern void blk_post_runtime_resume(struct request_queue *q, int err);
> > +extern void blk_post_runtime_resume(struct request_queue *q);
> >   extern void blk_set_runtime_active(struct request_queue *q);
> >   #else
> >   static inline void blk_pm_runtime_init(struct request_queue *q,
> > .
> > 
> 
