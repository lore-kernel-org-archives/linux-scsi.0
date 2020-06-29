Return-Path: <SRS0=wv9C=AK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDC4C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:34:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 488FD206A1
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Jun 2020 21:34:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgF2VeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Jun 2020 17:34:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34603 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728612AbgF2Sk6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jun 2020 14:40:58 -0400
Received: (qmail 410173 invoked by uid 1000); 29 Jun 2020 13:40:55 -0400
Date:   Mon, 29 Jun 2020 13:40:55 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200629174055.GA408860@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <df54c02f-dbe9-08d5-fec8-835788caf164@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df54c02f-dbe9-08d5-fec8-835788caf164@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 29, 2020 at 09:56:49AM -0700, Bart Van Assche wrote:
> On 2020-06-29 09:15, Alan Stern wrote:
> > Aha.  Looking at this more closely, it's apparent that the code in 
> > blk-core.c contains a logic bug: It assumes that if the BLK_MQ_REQ_PREEMPT 
> > flag is set then the request can be issued regardless of the queue's 
> > runtime status.  That is not correct when the queue is suspended.
> 
> Please clarify why this is not correct.

As I understand it, BLK_MQ_REQ_PREEMPT is supposed to mean (among other 
things) that this request may be issued as part of the procedure for 
putting a device into a low-power state or returning it to a high-power 
state.  Consequently, requests with that flag set must be allowed while 
the queue is in the RPM_SUSPENDING or RPM_RESUMING runtime states -- as 
opposed to ordinary requests, which are allowed only in the RPM_ACTIVE 
state.

In the RPM_SUSPENDED state, however, the queue is entirely inactive.  Even 
if a request were to be issued somehow, it would fail because the system 
would not be able to transmit it to the device.  In other words, when the 
queue is in the RPM_SUSPENDED state, a resume must be requested before 
_any_ request can be issued.

> > Index: usb-devel/block/blk-core.c
> > ===================================================================
> > --- usb-devel.orig/block/blk-core.c
> > +++ usb-devel/block/blk-core.c
> > @@ -423,7 +423,8 @@ int blk_queue_enter(struct request_queue
> >  			 * responsible for ensuring that that counter is
> >  			 * globally visible before the queue is unfrozen.
> >  			 */
> > -			if (pm || !blk_queue_pm_only(q)) {
> > +			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
> > +			    !blk_queue_pm_only(q)) {
> >  				success = true;
> >  			} else {
> >  				percpu_ref_put(&q->q_usage_counter);
> 
> Does the above change make it impossible to bring a suspended device
> back to the RPM_ACTIVE state if the BLK_MQ_REQ_NOWAIT flag is set?

The only case affected by this change is when BLK_MQ_REQ_PREEMPT is set 
and the queue is in the RPM_SUSPENDED state.  If BLK_MQ_REQ_NOWAIT was 
also set, the original code would set "success" to true, allowing the 
request to proceed even though it could not be carried out immediately -- 
a bug.

With the patch, such a request will fail without resuming the device.  I 
don't know whether that is the desired behavior or not, but at least it's 
not obviously a bug.

It does seem odd that blk_queue_enter() tests the queue's pm_only status 
and the request flag in two different spots (here and below).  Why does it 
do this?  It seems like an invitation for bugs.

> > @@ -448,8 +449,7 @@ int blk_queue_enter(struct request_queue
> >  
> >  		wait_event(q->mq_freeze_wq,
> >  			   (!q->mq_freeze_depth &&
> > -			    (pm || (blk_pm_request_resume(q),
> > -				    !blk_queue_pm_only(q)))) ||
> > +			    blk_pm_resume_queue(pm, q)) ||
> >  			   blk_queue_dying(q));
> >  		if (blk_queue_dying(q))
> >  			return -ENODEV;
> > Index: usb-devel/block/blk-pm.h
> > ===================================================================
> > --- usb-devel.orig/block/blk-pm.h
> > +++ usb-devel/block/blk-pm.h
> > @@ -6,11 +6,14 @@
> >  #include <linux/pm_runtime.h>
> >  
> >  #ifdef CONFIG_PM
> > -static inline void blk_pm_request_resume(struct request_queue *q)
> > +static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
> >  {
> > -	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
> > -		       q->rpm_status == RPM_SUSPENDING))
> > -		pm_request_resume(q->dev);
> > +	if (!q->dev || !blk_queue_pm_only(q))
> > +		return 1;	/* Nothing to do */
> > +	if (pm && q->rpm_status != RPM_SUSPENDED)
> > +		return 1;	/* Request allowed */
> > +	pm_request_resume(q->dev);
> > +	return 0;
> >  }
> 
> Does the above change, especially the " && q->rpm_status !=
> RPM_SUSPENDED" part, make it impossible to bring a suspended device back
> to the RPM_ACTIVE state?

Just the opposite -- the change makes it _possible_ for a 
BLK_MQ_REQ_PREEMPT request to bring a suspended device back to the 
RPM_ACTIVE state.

Look at the existing code: If pm is true then blk_pm_request_resume() will 
be skipped, so the device won't be resumed.  With this patch -- in 
particular with the "&& q->rpm_status != RPM_SUSPENDED" part added -- the 
call won't be skipped and so the resume will take place.

The rather complicated syntax of the wait_event() call in the existing 
code contributes to this confusion.  One of the things my patch tries to 
do is make the code more straightforward and easier to grasp.

I admit that there are parts to this thing I don't understand.  The 
wait_event() call in blk_queue_enter(), for example: If we are waiting for 
the device to leave the RPM_SUSPENDED state (or enter the RPM_ACTIVE 
state), where does q->mq_freeze_wq get woken up?  There's no obvious spot 
in blk_{pre|post}_runtime_resume().

Alan Stern
