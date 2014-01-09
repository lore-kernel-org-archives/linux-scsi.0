From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 9 Jan 2014 11:14:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401091108490.1493-100000@iolanthe.rowland.org>
References: <52CEC5EF.4030201@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52CEC5EF.4030201@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 9 Jan 2014, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/9/2014 10:40 AM, Alan Stern wrote:
> > We should change the code in the block layer.  blk_pm_peek_request
> >  should allow requests with REQ_PM set to go through, no matter
> > what the rpm_status is.  Then the disk driver could query the disk
> > (to see whether it is spinning) while the disk remains in runtime
> > suspend.
> 
> No, because if the disk is RPM_SUSPENDED, the port may be
> RPM_SUSPENDED, which likely means that you CAN'T send down requests to
> the device.

That's true, but it isn't a problem.  We know that requests with REQ_PM
are sent only at certain, controlled times.  In particular, the only
time such a request would be sent while the disk is RPM_SUSPENDED is
during a system resume.

> We need to put the device into one of the transitioning states to
> block other IO, without allowing the port to suspend.

No, we only need to make sure that the port doesn't go into runtime 
suspend while we carry out the "is the disk spinning" test.

Alan Stern

