From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5/6] sd: don't start disks on system resume
Date: Mon, 16 Dec 2013 22:43:38 -0800
Message-ID: <1387262618.13936.38.camel@dabdike.int.hansenpartnership.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
	 <1387236657-4852-1-git-send-email-psusi@ubuntu.com>
	 <1387236657-4852-6-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1387236657-4852-6-git-send-email-psusi@ubuntu.com>
Sender: linux-ide-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2013-12-16 at 18:30 -0500, Phillip Susi wrote:
> Instead of forcing a disk to start up with the START STOP UNIT
> command when the system resumes, let it stay asleep if runtime
> pm is enabled, and it will start the drive when it is accessed.
> Query the drive to see if it starts up on its own ( like most
> ATA disks do ) and update the runtime pm status if so.
> ---
>  drivers/scsi/sd.c | 94 +++++++++++++++++++++++++++++++++++++++++++++++++------
>  drivers/scsi/sd.h |  1 +
>  2 files changed, 86 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e6c4bff..98c082a 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -107,7 +107,8 @@ static int  sd_remove(struct device *);
>  static void sd_shutdown(struct device *);
>  static int sd_suspend_system(struct device *);
>  static int sd_suspend_runtime(struct device *);
> -static int sd_resume(struct device *);
> +static int sd_resume_system(struct device *);
> +static int sd_resume_runtime(struct device *dev);
>  static void sd_rescan(struct device *);
>  static int sd_done(struct scsi_cmnd *);
>  static int sd_eh_action(struct scsi_cmnd *, unsigned char *, int, int);
> @@ -486,11 +487,11 @@ static struct class sd_disk_class = {
>  
>  static const struct dev_pm_ops sd_pm_ops = {
>  	.suspend		= sd_suspend_system,
> -	.resume			= sd_resume,
> +	.resume			= sd_resume_system,
>  	.poweroff		= sd_suspend_system,
> -	.restore		= sd_resume,
> +	.restore		= sd_resume_system,
>  	.runtime_suspend	= sd_suspend_runtime,
> -	.runtime_resume		= sd_resume,
> +	.runtime_resume		= sd_resume_runtime,
>  };
>  
>  static struct scsi_driver sd_template = {
> @@ -3166,22 +3167,97 @@ static int sd_suspend_runtime(struct device *dev)
>  	return sd_suspend_common(dev, false);
>  }
>  
> -static int sd_resume(struct device *dev)
> +static int sd_resume_runtime(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
>  	int ret = 0;
>  
> -	if (!sdkp->device->manage_start_stop)
> -		goto done;
> -

This would make every disk start on resume ... even those which were
spun down before suspend.

>  	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
> +	dump_stack();

I assume this is a debug left over that should be removed?

>  	ret = sd_start_stop_device(sdkp, 1);
>  
> -done:
>  	scsi_disk_put(sdkp);
>  	return ret;
>  }
>  
> +#ifdef CONFIG_PM_RUNTIME

I really don't like the ifdefs.  The behaviour changes look pretty
radical for something that's supposed to be an add on to system suspend.

> +static void sd_resume_work(struct work_struct *work)
> +{
> +	struct scsi_disk *sdkp = container_of(work, struct scsi_disk, resume_work.work);
> +	struct scsi_device *sdp = sdkp->device;
> +	struct device *dev = &sdkp->dev;
> +	int res;
> +	unsigned char cmd[10] = { 0 };
> +	struct scsi_sense_hdr sshdr;
> +	const int timeout = sdp->request_queue->rq_timeout;
> +
> +	cmd[0] = REQUEST_SENSE;

You can't just send a random request sense because the reply will also
be pretty random (either no sense or the sense of the last check
condition depending on how the disk is feeling).  To see if a disk is
spun down, you need to send a test unit ready (TUR).

> +	printk(KERN_NOTICE "Requesting sense\n");
> +	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
> +				     &sshdr, timeout, SD_MAX_RETRIES,
> +				     NULL, REQ_PM);
> +	if (res) {
> +		sd_print_result(sdkp, res);
> +		goto wakeup;
> +	}
> +	if (driver_byte(res) & DRIVER_SENSE)
> +		sd_print_sense_hdr(sdkp, &sshdr);
> +	/* we need to evaluate the error return  */
> +	if (scsi_sense_valid(&sshdr) &&
> +	    sshdr.sense_key == 0 &&
> +	    sshdr.asc == 0 &&
> +	    sshdr.ascq == 0)

When you send the TUR, you only test the sense if check condition was
returned.   Plus, I think you only want to start the disk if it sends
back an ASC/ASCQ saying initialising command is required, don't you?

> +		goto wakeup;
> +
> +	/* finalize suspend */
> +	printk(KERN_NOTICE "Finalizing suspend\n");

OK, I think I'm lost here ... why are we finalising suspend in the
resume thread?

> +	pm_runtime_disable(dev);
> +	pm_runtime_set_suspended(dev);
> +	pm_runtime_enable(dev);
> +	blk_post_runtime_suspend(sdp->request_queue, 0);
> +	scsi_disk_put(sdkp);
> +	return;
> +
> +wakeup:
> +	/* abort suspend */
> +	sd_printk(KERN_NOTICE, sdkp, "Activating disk %s\n", kobject_name(&dev->kobj));
> +	blk_post_runtime_suspend(sdp->request_queue, -EBUSY);
> +	scsi_disk_put(sdkp);
> +}
> +#endif
> +
> +
> +static int sd_resume_system(struct device *dev)
> +{
> +	struct scsi_disk *sdkp;
> +#ifdef CONFIG_PM_RUNTIME
> +	struct scsi_device *sdp;
> +	int ret = 0;
> +
> +	sdkp = scsi_disk_get_from_dev(dev);
> +	sdp = sdkp->device;
> +	if (!scsi_device_online(sdp))
> +	{
> +		ret = -ENODEV;
> +		goto err;
> +	}
> +	sd_printk(KERN_NOTICE, sdkp, "Suspending disk\n");
> +	/* force runtime pm status to suspending */
> +	blk_pre_runtime_suspend(sdp->request_queue);
> +	execute_in_process_context(sd_resume_work,
> +				   &sdkp->resume_work);

Why is this necessary ... I thought resume was run on a thread (so it
can sleep)?

> +err:
> +	scsi_disk_put(sdkp);
> +	return ret;
> +#else
> +	if (sdkp->device->manage_start_stop)
> +		return sd_resume_runtime(dev);
> +	return 0;
> +#endif

This doesn't really look right: if we have runtime resume enabled, the
system resume will always spin up; if we don't, it will conditionally
spin up?

James

> +
> +
>  /**
>   *	init_sd - entry point for this driver (both when built in or when
>   *	a module).
> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
> index 26895ff..0b8afb3 100644
> --- a/drivers/scsi/sd.h
> +++ b/drivers/scsi/sd.h
> @@ -90,6 +90,7 @@ struct scsi_disk {
>  	unsigned	lbpvpd : 1;
>  	unsigned	ws10 : 1;
>  	unsigned	ws16 : 1;
> +	struct execute_work resume_work;
>  };
>  #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
>  



