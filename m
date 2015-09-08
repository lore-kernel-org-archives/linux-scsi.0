From: Ken Xue <Ken.Xue@amd.com>
Subject: Re: [PATCH] SCSI: Fix NULL pointer dereference in runtime PM
Date: Tue, 8 Sep 2015 09:53:56 +0800
Message-ID: <1441677236.5845.6.camel@kxue-X58A-UD3R>
References: <Pine.LNX.4.44L0.1509071039430.32284-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0082.outbound.protection.outlook.com ([207.46.100.82]:50176
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751952AbbIHCMg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Sep 2015 22:12:36 -0400
In-Reply-To: <Pine.LNX.4.44L0.1509071039430.32284-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "JBottomley@Odin.com" <JBottomley@Odin.com>, "Huang, Shane" <Shane.Huang@amd.com>, "Yu, Xiangliang" <Xiangliang.Yu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2015-09-07 at 10:48 -0400, Alan Stern wrote:
> On Mon, 7 Sep 2015, Xue, Ken wrote:
> 
> > Hi Alan and James,
> > I found a bug about sr device runtime suspend & resume which is introduced by your patch about fixing NULL pointer dereference in runtime PM.
> > You know that sr device only has runtime suspend routine but doesn't have resume routine.
> > After your patch, blk_ *_ runtime_suspend  will be called when runtime suspend. But blk_ *_ runtime_resume cannot be called when resume.
> > So, sr device cannot work correctly after 1st runtime suspend.
> 
> Argh.  Things just get more and more complicated...
> 
> > I want to make a dummy runtime resume routine in sr.c for fixing this runtime issue of sr device.
> > If you guys think a dummy runtime routine for resume is acceptable, I can submit patch later.
> 
> A dummy routine isn't the greatest solution.  Eventually someone will 
> see it, wonder why it's there, and remove it.
> 
> The real issue we need to address here is whether the driver has asked
> for request-queue-oriented runtime PM by calling blk_pm_runtime_init().  
> If it hasn't then we need to skip at least the calls to
> blk_{pre|post}_runtime_{suspend|resume}.
> 
> The patch I wrote uses the existence of runtime-PM callbacks as an 
> indicator for this, but evidently it isn't adequate.  A more direct 
> approach would be to test whether sdev->request_queue->dev is non-NULL, 
> but this would be a layering violation.
> 
> Should we add a SCSI-level flag to indicate that blk_pm_runtime_init() 
> has been called?
 Can we check whether sdev->request_queue->dev is non-NULL in blk_{pre|
post}_runtime_{suspend|resume}?

just use simple codes like:
int blk_pre_runtime_suspend(struct request_queue *q)
{
...
	if(!q->dev)
	  return -ENODEV;
..
}

> 
> Alan Stern
> 


