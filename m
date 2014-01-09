From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 9 Jan 2014 10:40:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401091032430.1493-100000@iolanthe.rowland.org>
References: <52CDFB97.9080303@intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CDFB97.9080303@intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 9 Jan 2014, Aaron Lu wrote:

> > It's a knotty situation.  The only way to find out whether the disk is
> > spinning is to ask it, which requires doing I/O, which requires
> > spinning up the disk.  Maybe we need to add a mechanism to the block
> > layer's runtime PM implementation for addressing just this situation.
> 
> I think it's knotty because the runtime PM status is a view from the
> kernel/host side, i.e. it is runtime suspended if it is not being used,
> no matter which power state it is in. The trigger for the PM state
> transition are all based on this, if we want to do it the other way
> around(update device's runtime PM status based on device's actual power
> state), we are in a knotty situation.

No, that's not the problem.  The problem is that the block layer does
not permit any requests to go through if the queue's rpm_status is
RPM_SUSPENDED.

We should change the code in the block layer.  blk_pm_peek_request 
should allow requests with REQ_PM set to go through, no matter what the 
rpm_status is.  Then the disk driver could query the disk (to see 
whether it is spinning) while the disk remains in runtime suspend.

Alan Stern

