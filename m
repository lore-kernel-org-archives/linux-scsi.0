From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC PATCH 1/3] block: add a flag to identify PM request
Date: Tue, 15 May 2012 12:03:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1205151159462.1796-100000@iolanthe.rowland.org>
References: <1337095985.3515.1.camel@chief-river-32>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1337095985.3515.1.camel@chief-river-32>
Sender: linux-kernel-owner@vger.kernel.org
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kernel development list <linux-kernel@vger.kernel.org>, Linux-pm mailing list <linux-pm@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 15 May 2012, Lin Ming wrote:

> On Tue, 2012-05-15 at 10:35 -0400, Alan Stern wrote:
> > On Tue, 15 May 2012, Lin Ming wrote:
> > 
> > > Add a flag REQ_PM to identify the request is PM related.
> > > As an example, modify scsi code to use this flag.
> > 
> > There already is such a flag; you don't need to add one.  In fact, 
> > there already are _two_ such flags, and it would be best to remove one 
> > of them.  In include/linux/blkdev.h:
> > 
> > 	REQ_TYPE_PM_SUSPEND,		/* suspend request */
> > 	REQ_TYPE_PM_RESUME,		/* resume request */
> > 
> > Apparently they had been used by the old ide driver, but they don't
> > seem to be used anywhere now.
> 
> IDE code still uses both types and they are used for system
> suspend/resume. See generic_ide_suspend and generic_ide_resume.

You're right, of course.  I searched for "BLK_TYPE_PM_" instead of 
"REQ_TYPE_PM_".  :-(

> But we need a flag to check whether it is runtime suspend/resume
> request.

It should be possible to fix up the IDE code so that it uses the same
flag for both suspend and resume.  After all, there's no real danger of
confusion -- you never get into a situation where you're not sure
whether the current PM action is a suspend or a resume.

Alan Stern
