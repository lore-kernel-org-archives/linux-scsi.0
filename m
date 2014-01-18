From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Fri, 17 Jan 2014 17:24:21 -0800
Message-ID: <20140118012420.GA11405@linux.intel.com>
References: <20140116220409.GA1183@linux.intel.com>
 <Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752592AbaARB3Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 20:29:16 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401170951270.1162-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Fri, Jan 17, 2014 at 09:57:47AM -0500, Alan Stern wrote:
> On Thu, 16 Jan 2014, Todd E Brandt wrote:
> 
> > On Thu, Jan 16, 2014 at 03:05:40PM -0500, Alan Stern wrote:
> > > On Thu, 16 Jan 2014, Todd E Brandt wrote:
> > > 
> > > > > Does this plan sound reasonable to everyone?  Are there important
> > > > > aspects I haven't considered (such as interactions between the SCSI and
> > > > > ATA layers)?
> > > > > 
> > > > > Alan Stern
> > > > > 
> > > > 
> > > > Both approaches employ non-blocking resume of the scsi disks so why don't
> > > > we treat these two patch sets as parts one and two. My patch just spins
> > > > everything up but sets everything to non-blocking, so it will take care
> > > > of the most common use cases. Your patch will then fine-tune that behavior
> > > > to only spin up those disks that are actually needed. I don't think there
> > > > are any serious conflicts between the two patch sets.
> > > 
> > > Hmmm.  In your 2/2 patch, sd_resume_complete() gets called in atomic
> > > context.  I would need a process context in order to carry out a
> > > runtime resume.  Any suggestions?
> > 
> > The complete call is really just there to printk any errors and free
> > the sense buffer. Why would you want to carry out a runtime resume in
> > it?
> 
> From my earlier message:
> 
>  	Otherwise, check to see whether the disk is spinning up all
>  	by itself.  This presumably will involve issuing a TEST UNIT
>  	READY command and checking the sense data.  Maybe something
>  	different will be needed for ATA disks; I don't know.
>  
>  	If the disk is spinning, or if you can't tell, call
>  	pm_runtime_resume() to put the disk back into the
>  	RPM_ACTIVE state (and spin it up in the case where you 
>  	couldn't tell what it was doing).
> 
> As you can see, the runtime resume is carried out in the completion
> routine for the TEST UNIT READY command.  Since the command is likely
> to take a long time (Phillip said it can take up to 10 seconds for ATA
> disks), we want it to be asynchronous, like the START-STOP command.

10 seconds?! The only possible way that could happen is if the test unit
ready SCSI command actually triggered an ata port wakeup; at which point
you've already done the one thing you were trying not to do.

> 
> > > Also, I don't understand the point of your 1/2 patch.  If the whole
> > > point of that patch was to carry out the ATA port resume asynchronously
> > > ("thus allowing the next device in the pm queue to resume"), doesn't
> > > device_enable_async_suspend() already do that for you?
> > > 
> > > Alan Stern
> > > 
> > 
> > The device_enable_async_suspend call is used to set a pm flag which lets
> > the power manager know that this device can be added to the async suspend
> > queue. Basically that means that it can be suspended/resumed in parallel
> > with all the other async devices, but resume still waits for all those
> > devices to finish before completing system resume.
> 
> Correct.
> 
> > My patch makes ata port and scsi disk resume 'non-blocking' (asynchronous
> > with respect to system resume). Which means once they're called the power
> > manager pays no more attention to them and will complete system resume
> > whenever. Both the power manager and the ata subsystems call these 
> > features 'asynchronous' so it can be confusing.
> 
> I see.  That's not explained very well in the patch description -- it
> talks about going on to resume the next device on the list, but not
> about waiting for the overall system resume to finish.

I'll word it differently if I have to resubmit again, but it does assume
a working knowledge of the pm subsystem.

> 
> Alan Stern
> 
