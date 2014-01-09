From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Thu, 9 Jan 2014 12:06:02 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401091204450.1493-100000@iolanthe.rowland.org>
References: <52CECF91.10206@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CECF91.10206@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Thu, 9 Jan 2014, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/9/2014 11:14 AM, Alan Stern wrote:
> > That's true, but it isn't a problem.  We know that requests with
> > REQ_PM are sent only at certain, controlled times.  In particular,
> > the only time such a request would be sent while the disk is
> > RPM_SUSPENDED is during a system resume.
> 
> Yes, but if the disk and port were both already RPM_SUSPENDED when the
> system was suspended, and so the port is still RPM_SUSPENDED when the
> disk's system resume method is called, then it can't communicate with
> the disk.

The port should not be runtime suspended during system resume.  It 
should always go to runtime active.
 
> >> We need to put the device into one of the transitioning states
> >> to block other IO, without allowing the port to suspend.
> > 
> > No, we only need to make sure that the port doesn't go into runtime
> >  suspend while we carry out the "is the disk spinning" test.
> 
> Well how else do you do that other than with the transition states?

pm_runtime_get_noresume(dev->parent).

Alan Stern

