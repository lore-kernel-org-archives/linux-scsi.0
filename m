From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: Fix NULL pointer dereference in runtime PM
Date: Tue, 8 Sep 2015 10:25:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1509081018520.1533-100000@iolanthe.rowland.org>
References: <1441677236.5845.6.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42204 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754430AbbIHOZH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2015 10:25:07 -0400
In-Reply-To: <1441677236.5845.6.camel@kxue-X58A-UD3R>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ken Xue <Ken.Xue@amd.com>
Cc: "JBottomley@Odin.com" <JBottomley@Odin.com>, "Huang, Shane" <Shane.Huang@amd.com>, "Yu, Xiangliang" <Xiangliang.Yu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tue, 8 Sep 2015, Ken Xue wrote:

> On Mon, 2015-09-07 at 10:48 -0400, Alan Stern wrote:
> > On Mon, 7 Sep 2015, Xue, Ken wrote:
> > 
> > > Hi Alan and James,
> > > I found a bug about sr device runtime suspend & resume which is introduced by your patch about fixing NULL pointer dereference in runtime PM.
> > > You know that sr device only has runtime suspend routine but doesn't have resume routine.
> > > After your patch, blk_ *_ runtime_suspend  will be called when runtime suspend. But blk_ *_ runtime_resume cannot be called when resume.
> > > So, sr device cannot work correctly after 1st runtime suspend.
> > 
> > Argh.  Things just get more and more complicated...
> > 
> > > I want to make a dummy runtime resume routine in sr.c for fixing this runtime issue of sr device.
> > > If you guys think a dummy runtime routine for resume is acceptable, I can submit patch later.
> > 
> > A dummy routine isn't the greatest solution.  Eventually someone will 
> > see it, wonder why it's there, and remove it.
> > 
> > The real issue we need to address here is whether the driver has asked
> > for request-queue-oriented runtime PM by calling blk_pm_runtime_init().  
> > If it hasn't then we need to skip at least the calls to
> > blk_{pre|post}_runtime_{suspend|resume}.
> > 
> > The patch I wrote uses the existence of runtime-PM callbacks as an 
> > indicator for this, but evidently it isn't adequate.  A more direct 
> > approach would be to test whether sdev->request_queue->dev is non-NULL, 
> > but this would be a layering violation.
> > 
> > Should we add a SCSI-level flag to indicate that blk_pm_runtime_init() 
> > has been called?
>  Can we check whether sdev->request_queue->dev is non-NULL in blk_{pre|
> post}_runtime_{suspend|resume}?
> 
> just use simple codes like:
> int blk_pre_runtime_suspend(struct request_queue *q)
> {
> ...
> 	if(!q->dev)

Missing space between "if" and "(".  :-)

> 	  return -ENODEV;

Return ret (i.e., 0), not -ENODEV.  If, for some reason, a device uses
runtime PM that's not based on the state of the request queue, we don't
want to subvert that other mechanism.

> ..
> }

I agree, this appears to be the best solution.  (That, plus reverting
my earlier patch.)  I originally avoided putting in this test because 
it seemed like unnecessary overhead.  Now we see that the overhead is 
necessary after all.

Alan Stern

