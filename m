From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH 5/6] sd: don't start disks on system resume
Date: Tue, 17 Dec 2013 10:01:36 -0500
Message-ID: <52B06750.7080903@ubuntu.com>
References: <cover.1384030893.git.psusi@ubuntu.com>	 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>	 <1387236657-4852-6-git-send-email-psusi@ubuntu.com> <1387262618.13936.38.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1387262618.13936.38.camel@dabdike.int.hansenpartnership.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 12/17/2013 1:43 AM, James Bottomley wrote:

>> -static int sd_resume(struct device *dev) +static int
>> sd_resume_runtime(struct device *dev) { struct scsi_disk *sdkp =
>> scsi_disk_get_from_dev(dev); int ret = 0;
>> 
>> -	if (!sdkp->device->manage_start_stop) -		goto done; -
> 
> This would make every disk start on resume ... even those which
> were spun down before suspend.

What?  Those are lines I removed.

>> sd_printk(KERN_NOTICE, sdkp, "Starting disk\n"); +	dump_stack();
> 
> I assume this is a debug left over that should be removed?

Yes.

>> ret = sd_start_stop_device(sdkp, 1);
>> 
>> -done: scsi_disk_put(sdkp); return ret; }
>> 
>> +#ifdef CONFIG_PM_RUNTIME
> 
> I really don't like the ifdefs.  The behaviour changes look pretty 
> radical for something that's supposed to be an add on to system
> suspend.

How is it radical?  Either we wake the disk as we did before, or we
use runtime pm to (try to) keep it suspended until accessed.  The
#ifdefs are required because it depends on runtime pm.

>> +static void sd_resume_work(struct work_struct *work) +{ +	struct
>> scsi_disk *sdkp = container_of(work, struct scsi_disk,
>> resume_work.work); +	struct scsi_device *sdp = sdkp->device; +
>> struct device *dev = &sdkp->dev; +	int res; +	unsigned char
>> cmd[10] = { 0 }; +	struct scsi_sense_hdr sshdr; +	const int
>> timeout = sdp->request_queue->rq_timeout; + +	cmd[0] =
>> REQUEST_SENSE;
> 
> You can't just send a random request sense because the reply will
> also be pretty random (either no sense or the sense of the last
> check condition depending on how the disk is feeling).  To see if a
> disk is spun down, you need to send a test unit ready (TUR).

- From what I can see in the standards, this is not true.  TEST UNIT
READY will give an error response if the drive requires START STOP
UNIT, but if it does not, either because it is actually an ata disk,
or because it auto starts ( the standard indicates scsi disks can be
configured to do this, but does not say how ), and is simply in
standby, then it will return success.

In other words, ata drives always return ready and scsi disks do as
well, if they are in standby mode rather than stopped mode.

On the other hand, there are several references in the standards to
using REQUEST SENSE to poll the drive status rather than to read sense
data for the last command, and I believe there was a passage somewhere
that mentioned the last command status is cleared once it has been
read once, presumably so that a subsequent REQUEST SENSE will instead
get the current status of the drive.  SAT-3 specifies that REQUEST
SENSE is to be translated to an ata CHECK POWER CONDITION specifically
so that it can be used to poll the drive to see if it is currently in
standby.

You can use sdparm --command=sense to issue a REQUEST SENSE command to
a drive and see for yourself.  If you configure the drive to auto
suspend using the timer, then poll it, you should see the response
indicating it is in standby.

See SPC-4 section 5.6 and SAT-3 section 8.10.

> When you send the TUR, you only test the sense if check condition
> was returned.   Plus, I think you only want to start the disk if it
> sends back an ASC/ASCQ saying initialising command is required,
> don't you?

REQUEST SENSE gives GOOD rather than CHECK CONDITION.  You want to NOT
start the disk if you get back that status.  The whole point is to let
the disk stay asleep.  The idea is to force the disk into runtime
suspend so it can sleep, and be started when accessed, but if it is
already up and running ( as most ata disks will be ), then don't
pretend it is suspended since it really isn't.

> OK, I think I'm lost here ... why are we finalising suspend in the 
> resume thread?

Because we want to let runtime pm start the disk at a later time, once
it is accessed, rather than when the system resumes.

>> +	execute_in_process_context(sd_resume_work, +
>> &sdkp->resume_work);
> 
> Why is this necessary ... I thought resume was run on a thread (so
> it can sleep)?

Because we don't want to block the resume path for many seconds and
delay user space unfreezing.  I actually need to fix that to
unconditionally queues the work item since right now it is in process
context, so it just directly calls the other function.

>> +err: +	scsi_disk_put(sdkp); +	return ret; +#else +	if
>> (sdkp->device->manage_start_stop) +		return
>> sd_resume_runtime(dev); +	return 0; +#endif
> 
> This doesn't really look right: if we have runtime resume enabled,
> the system resume will always spin up; if we don't, it will
> conditionally spin up?

Other way around; if we *don't* have runtime pm configured, then
system resume always spins up, and if we do, then we try to delay
spinning up until the disk is accessed, but check to see if the drive
has spun up on its own.


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJSsGdQAAoJEI5FoCIzSKrwWRgH+wTIMDt7lyXbZVX/JNS7qkOI
eRLZnWurNSXpgkXQ2B+OQIgM+l18URbN9cf0j66o6tGH6M+CbKzT2iiQMR5lqbVY
ejkUVlZ3rruYSAc8sHGHJi1CYoHRh4wgQ65mGiRVBI6TPS5Gmqmy53QVOGaGRJwo
IZDV3oOaWelAQB4VF6T1jJHHHbraEuaXsGMwP+900mbN0uboYgkQ5pkwdNSd9dpO
CBDG0Dgn31U4P1dZUQpKtytUwm64keGzMQ8kgckiR77Y9fJ82hJ4QnFX0CmQuFgM
EeiEhTikYZ5Q1jHg8QFXkqnbigWj4o1fAJungs2iqwNrrhkwTaZW5OyUA8FV5xk=
=ZaZs
-----END PGP SIGNATURE-----
