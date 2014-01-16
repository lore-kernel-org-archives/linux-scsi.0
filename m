From: Todd E Brandt <todd.e.brandt@linux.intel.com>
Subject: Re: Disk spin-up optimization during system resume
Date: Thu, 16 Jan 2014 10:04:16 -0800
Message-ID: <20140116180415.GA14515@linux.intel.com>
References: <52CEC5EF.4030201@ubuntu.com>
 <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Reply-To: todd.e.brandt@linux.intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42506 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaAPSEP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jan 2014 13:04:15 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401161125080.1109-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Phillip Susi <psusi@ubuntu.com>, Aaron Lu <aaron.lu@intel.com>, Tejun Heo <tj@kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Jan 16, 2014 at 11:59:43AM -0500, Alan Stern wrote:
> Folks:
> 
> I would like to tie together separate email threads regarding disk
> spin-up time during system resume.
> 
> Todd has posted some patches to make spin-up occur asynchronously, thus
> not delaying the return of the system to normal operation.  Phillip and
> I have been designing an approach to allow disks to remain spun-down
> until they are needed, by putting them into runtime suspend.  In other
> words, even though some disks may spin up all by themselves when the
> system wakes up, we may be able to avoid immediately spinning up the
> others.
> 
> To implement this approach will require a few small changes to the 
> runtime PM core and the block layer core.  I can take care of them 
> fairly easily; the difficult part lies in getting the sd driver to do 
> the right thing.
> 
> The basic outline of our approach goes like this.  The sd driver will 
> get a new resume_early callback routine, which will:
> 
> 	Check to see if the user has enabled runtime PM for this disk,
> 	if the runtime usage counter is at 0, if the request queue is
> 	empty, and so on.  Basically, anything that should prevent the
> 	disk from going into runtime suspend.
> 
> 	If all the conditions are met, set the disk's runtime PM
> 	status to RPM_SUSPENDED.  Otherwise set it to RPM_ACTIVE.
> 
> Then when the regular sd_resume routine runs, it will do this:
> 
> 	If the runtime PM status is RPM_ACTIVE, issue a START-STOP
> 	command to spin up the disk, the same as sd_resume does now.
> 	(And of course, the command can be skipped if the 
> 	manage_start_stop flag isn't set.)
> 
> 	Otherwise, check to see whether the disk is spinning up all
> 	by itself.  This presumably will involve issuing a TEST UNIT
> 	READY command and checking the sense data.  Maybe something
> 	different will be needed for ATA disks; I don't know.
> 
> 	If the disk is spinning, or if you can't tell, call
> 	pm_runtime_resume() to put the disk back into the
> 	RPM_ACTIVE state (and spin it up in the case where you 
> 	couldn't tell what it was doing).
> 
> Since the START-STOP and TEST UNIT READY (or REQUEST SENSE or whatever)  
> commands are likely to take a long time, they should all be carried out
> asynchronously with respect to the resume procedure.  I don't know what
> the best way is to implement this.  But it is important to guarantee
> that in the RPM_ACTIVE case, the START-STOP command gets sent to the
> disk before any other commands.  (This isn't an issue in the 
> RPM_SUSPENDED case, as the block layer will prevent requests being 
> sent out unless they have the REQ_PM flag set.)
> 
> Does this plan sound reasonable to everyone?  Are there important
> aspects I haven't considered (such as interactions between the SCSI and
> ATA layers)?
> 
> Alan Stern
> 

Both approaches employ non-blocking resume of the scsi disks so why don't
we treat these two patch sets as parts one and two. My patch just spins
everything up but sets everything to non-blocking, so it will take care
of the most common use cases. Your patch will then fine-tune that behavior
to only spin up those disks that are actually needed. I don't think there
are any serious conflicts between the two patch sets.
