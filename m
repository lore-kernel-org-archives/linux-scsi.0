From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: REQ_PM vs REQ_TYPE_PM_RESUME
Date: Tue, 7 Jan 2014 13:05:17 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401071251330.1296-100000@iolanthe.rowland.org>
References: <52CC2D5F.6030905@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <52CC2D5F.6030905@ubuntu.com>
Sender: linux-pm-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: Aaron Lu <aaron.lu@intel.com>, Sujit Reddy Thumma <sthumma@codeaurora.org>, todd.e.brandt@linux.intel.com, tj@kernel.org, JBottomley@parallels.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Linux-pm mailing list <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 7 Jan 2014, Phillip Susi wrote:

> On 1/7/2014 11:08 AM, Alan Stern wrote:
> > Okay, that's a different matter.  There's a much simpler way to 
> > accomplish this.  The patch below will avoid spinning up drives
> > that were already in runtime suspend when the system sleep started.
> >  (If a drive wasn't in runtime suspend then presumably it was used
> >  recently; therefore it's likely to be used again in the near
> > future and so it _should_ be spun up.)
> 
> This is a poor assumption.  You may not be using autosuspend at all,
> or with a rather long timeout, so it is fairly normal to not be
> runtime suspended at suspend time, and yet not likely to access the
> disk for some time after resume.

I disagree with your argument.  If you aren't using autosuspend at all 
then you don't mind having your disks spin all the time.  Therefore you 
don't mind if the disks spin up during system resume.

If you're using a long timeout and you don't like the way the timer 
gets reset by a system sleep, then you have set the timeout too long.

Now, a more reasonable argument might be that for some disks, the
kernel doesn't need to do an explicit spin-up or spin-down (for runtime
suspend) at all; instead we can rely on the drive's internal power
management.  In fact there already is a "manage_start_stop" attribute
to control this.  (Well, almost -- if the attribute is set to 0 then
the kernel won't issue a spin-down command even for system suspend.)

>  It also still suffers from the issue
> of claiming the device is runtime suspended while the disk has in
> fact, spun up of its own accord.

I don't understand.  Under what circumstances would this happen?  Are 
you saying this would happen during system resume?  Why would the disk 
spin up of its own accord at that time?

And if it does spin up of its own accord, what makes you think the 
kernel can do anything to prevent it from spinning up?

Alan Stern

