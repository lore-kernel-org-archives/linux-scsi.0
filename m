From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 14:04:11 -0800
Message-ID: <20140116220409.GA1183@linux.intel.com>
References: <20140116180415.GA14515@linux.intel.com>
 <Pine.LNX.4.44L0.1401161441030.1109-100000@iolanthe.rowland.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:30007 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbaAPWEJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 17:04:09 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401161441030.1109-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 16, 2014 at 03:05:40PM -0500, Alan Stern wrote:
> On Thu, 16 Jan 2014, Todd E Brandt wrote:
> 
> > > Does this plan sound reasonable to everyone?  Are there important
> > > aspects I haven't considered (such as interactions between the SCSI and
> > > ATA layers)?
> > > 
> > > Alan Stern
> > > 
> > 
> > Both approaches employ non-blocking resume of the scsi disks so why don't
> > we treat these two patch sets as parts one and two. My patch just spins
> > everything up but sets everything to non-blocking, so it will take care
> > of the most common use cases. Your patch will then fine-tune that behavior
> > to only spin up those disks that are actually needed. I don't think there
> > are any serious conflicts between the two patch sets.
> 
> Hmmm.  In your 2/2 patch, sd_resume_complete() gets called in atomic
> context.  I would need a process context in order to carry out a
> runtime resume.  Any suggestions?

The complete call is really just there to printk any errors and free
the sense buffer. Why would you want to carry out a runtime resume in
it?

> 
> Also, I don't understand the point of your 1/2 patch.  If the whole
> point of that patch was to carry out the ATA port resume asynchronously
> ("thus allowing the next device in the pm queue to resume"), doesn't
> device_enable_async_suspend() already do that for you?
> 
> Alan Stern
> 

The device_enable_async_suspend call is used to set a pm flag which lets
the power manager know that this device can be added to the async suspend
queue. Basically that means that it can be suspended/resumed in parallel
with all the other async devices, but resume still waits for all those
devices to finish before completing system resume.

My patch makes ata port and scsi disk resume 'non-blocking' (asynchronous
with respect to system resume). Which means once they're called the power
manager pays no more attention to them and will complete system resume
whenever. Both the power manager and the ata subsystems call these 
features 'asynchronous' so it can be confusing.
