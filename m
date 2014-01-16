From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 15:05:40 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401161441030.1109-100000@iolanthe.rowland.org>
References: <20140116180415.GA14515@linux.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:35303 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750994AbaAPUFm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2014 15:05:42 -0500
In-Reply-To: <20140116180415.GA14515@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Todd E Brandt <todd.e.brandt@linux.intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 16 Jan 2014, Todd E Brandt wrote:

> > Does this plan sound reasonable to everyone?  Are there important
> > aspects I haven't considered (such as interactions between the SCSI and
> > ATA layers)?
> > 
> > Alan Stern
> > 
> 
> Both approaches employ non-blocking resume of the scsi disks so why don't
> we treat these two patch sets as parts one and two. My patch just spins
> everything up but sets everything to non-blocking, so it will take care
> of the most common use cases. Your patch will then fine-tune that behavior
> to only spin up those disks that are actually needed. I don't think there
> are any serious conflicts between the two patch sets.

Hmmm.  In your 2/2 patch, sd_resume_complete() gets called in atomic
context.  I would need a process context in order to carry out a
runtime resume.  Any suggestions?

Also, I don't understand the point of your 1/2 patch.  If the whole
point of that patch was to carry out the ATA port resume asynchronously
("thus allowing the next device in the pm queue to resume"), doesn't
device_enable_async_suspend() already do that for you?

Alan Stern

