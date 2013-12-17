From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/6] sd: don't start disks on system resume
Date: Tue, 17 Dec 2013 09:48:56 -0800
Message-ID: <1387302536.2213.43.camel@dabdike.int.hansenpartnership.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
		 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
		 <1387236657-4852-6-git-send-email-psusi@ubuntu.com>
	 <1387262618.13936.38.camel@dabdike.int.hansenpartnership.com>
	 <52B06750.7080903@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <52B06750.7080903@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2013-12-17 at 10:01 -0500, Phillip Susi wrote:
> On 12/17/2013 1:43 AM, James Bottomley wrote:
> 
> >> -static int sd_resume(struct device *dev) +static int
> >> sd_resume_runtime(struct device *dev) { struct scsi_disk *sdkp =
> >> scsi_disk_get_from_dev(dev); int ret = 0;
> >> 
> >> -	if (!sdkp->device->manage_start_stop) -		goto done; -
> > 
> > This would make every disk start on resume ... even those which
> > were spun down before suspend.
> 
> What?  Those are lines I removed.

Yes, they say that in sd_resume, if we're managing the disk start stop,
spin it up.  Removing them spins everything up unconditionally.

> >> sd_printk(KERN_NOTICE, sdkp, "Starting disk\n"); +	dump_stack();
> > 
> > I assume this is a debug left over that should be removed?
> 
> Yes.
> 
> >> ret = sd_start_stop_device(sdkp, 1);
> >> 
> >> -done: scsi_disk_put(sdkp); return ret; }
> >> 
> >> +#ifdef CONFIG_PM_RUNTIME
> > 
> > I really don't like the ifdefs.  The behaviour changes look pretty 
> > radical for something that's supposed to be an add on to system
> > suspend.
> 
> How is it radical?  Either we wake the disk as we did before, or we
> use runtime pm to (try to) keep it suspended until accessed.  The
> #ifdefs are required because it depends on runtime pm.

Good systems engineering practise does not have different behaviours for
code with and without ifdefs.  You want to be adding incremental
behaviour not modifying existing.  The reason is testing; now you have
to build two different kernels to test the two behaviours and mostly one
path gets selected by every distro and the other bitrots.

> >> +static void sd_resume_work(struct work_struct *work) +{ +	struct
> >> scsi_disk *sdkp = container_of(work, struct scsi_disk,
> >> resume_work.work); +	struct scsi_device *sdp = sdkp->device; +
> >> struct device *dev = &sdkp->dev; +	int res; +	unsigned char
> >> cmd[10] = { 0 }; +	struct scsi_sense_hdr sshdr; +	const int
> >> timeout = sdp->request_queue->rq_timeout; + +	cmd[0] =
> >> REQUEST_SENSE;
> > 
> > You can't just send a random request sense because the reply will
> > also be pretty random (either no sense or the sense of the last
> > check condition depending on how the disk is feeling).  To see if a
> > disk is spun down, you need to send a test unit ready (TUR).
> 
> From what I can see in the standards, this is not true.  TEST UNIT
> READY will give an error response if the drive requires START STOP
> UNIT, but if it does not, either because it is actually an ata disk,
> or because it auto starts ( the standard indicates scsi disks can be
> configured to do this, but does not say how ), and is simply in
> standby, then it will return success.

Are you confused about the power states?  in SCSI, stand by and idle are
different from spun down (or stopped).  Right at the moment, start stop
manages spin down/spin up not the granular power states for almost every
device.  The only subsystem that actually uses power state management is
firewire.  Even if you enable power state management for ATA, we have to
cope with non-ATA devices.

The standards actually say that SCSI devices automatically come out of
standby power conditions unless the transport protocol says something
different.

> In other words, ata drives always return ready and scsi disks do as
> well, if they are in standby mode rather than stopped mode.

Yes, but they aren't going to be in standby mode apart from firewire
devices; they're going to be stopped.

> On the other hand, there are several references in the standards to
> using REQUEST SENSE to poll the drive status rather than to read sense
> data for the last command, and I believe there was a passage somewhere
> that mentioned the last command status is cleared once it has been
> read once, presumably so that a subsequent REQUEST SENSE will instead
> get the current status of the drive.  SAT-3 specifies that REQUEST
> SENSE is to be translated to an ata CHECK POWER CONDITION specifically
> so that it can be used to poll the drive to see if it is currently in
> standby.
> 
> You can use sdparm --command=sense to issue a REQUEST SENSE command to
> a drive and see for yourself.  If you configure the drive to auto
> suspend using the timer, then poll it, you should see the response
> indicating it is in standby.
> 
> See SPC-4 section 5.6

That's "self test operations".  I assume you mean 6.29 "REQUEST SENSE"?

>  and SAT-3 section 8.10.

What SAT says is irrelevant.  That's about how to translate ATA to SCSI,
not how SCSI devices should behave.

> > When you send the TUR, you only test the sense if check condition
> > was returned.   Plus, I think you only want to start the disk if it
> > sends back an ASC/ASCQ saying initialising command is required,
> > don't you?
> 
> REQUEST SENSE gives GOOD rather than CHECK CONDITION.  You want to NOT
> start the disk if you get back that status.  The whole point is to let
> the disk stay asleep.  The idea is to force the disk into runtime
> suspend so it can sleep, and be started when accessed, but if it is
> already up and running ( as most ata disks will be ), then don't
> pretend it is suspended since it really isn't.
> 
> > OK, I think I'm lost here ... why are we finalising suspend in the 
> > resume thread?
> 
> Because we want to let runtime pm start the disk at a later time, once
> it is accessed, rather than when the system resumes.

I still don't get why a resume function call is doing suspend
operations.

> >> +	execute_in_process_context(sd_resume_work, +
> >> &sdkp->resume_work);
> > 
> > Why is this necessary ... I thought resume was run on a thread (so
> > it can sleep)?
> 
> Because we don't want to block the resume path for many seconds and
> delay user space unfreezing.  I actually need to fix that to
> unconditionally queues the work item since right now it is in process
> context, so it just directly calls the other function.

Um, then you need to read the code.  execute_in_process_context() is a
direct function call if we have process context, so it's not going to
use a work queue.

> >> +err: +	scsi_disk_put(sdkp); +	return ret; +#else +	if
> >> (sdkp->device->manage_start_stop) +		return
> >> sd_resume_runtime(dev); +	return 0; +#endif
> > 
> > This doesn't really look right: if we have runtime resume enabled,
> > the system resume will always spin up; if we don't, it will
> > conditionally spin up?
> 
> Other way around; if we *don't* have runtime pm configured, then
> system resume always spins up, and if we do, then we try to delay
> spinning up until the disk is accessed, but check to see if the drive
> has spun up on its own.

Please don't do this.  Significant behaviour changes depending on what
options are selected are not a good idea from the systems point of view.
Options should control incremental changes (function present or not
present).

James


