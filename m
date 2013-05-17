From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2 1/2] ATA/SCSI subsystem resume path made fully
 asynchronous
Date: Fri, 17 May 2013 15:38:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1305171519580.1012-100000@iolanthe.rowland.org>
References: <11E08D716F0541429B7042699DD5C1A16B97BD7C@FMSMSX103.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:46515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751004Ab3EQTiO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 May 2013 15:38:14 -0400
In-Reply-To: <11E08D716F0541429B7042699DD5C1A16B97BD7C@FMSMSX103.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Brandt, Todd E" <todd.e.brandt@intel.com>
Cc: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, Arjan van de Ven <arjan@linux.intel.com>

On Fri, 17 May 2013, Brandt, Todd E wrote:

> This patch goes through and sets the power.async_suspend flag for every device
> in the ATA/SCSI resume path. This includes the ata port, link, and dev
> devices, the scsi host and target devices, all their associated transport
> devices, the block devices, and block partitions. This allows the entire

This sounds like overkill.  For instance, do you really need to mark
the block devices and partitions?  I would be surprised if they make 
any difference.

The SCSI host and target devices are already marked for async suspend.  
This patch doesn't change that.

Have you tried taking everything out of this patch except for the 
change to drivers/scsi/sd.c?  That's probably the only important one.

> ATA resume path to be added to the async device queue in
> drivers/base/power/main.c. Without this, the ATA resume path ends up in
> both queues (sync and async), which causes interdependencies and backs up
> the two queues.

I suspect the interdependencies aren't as bad as you think.  Basically, 
the way to avoid them is simply to make sure that everything requiring 
a long time to resume uses the async queue.  In your case, the 
time-consuming portion is the disk spin-up, which means that the 
scsi_disk devices should be async.

> diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
> index c04d393..493f5ce 100644
> --- a/drivers/ata/libata-transport.c
> +++ b/drivers/ata/libata-transport.c
> @@ -285,13 +285,13 @@ int ata_tport_add(struct device *parent,
>  	dev->parent = get_device(parent);
>  	dev->release = ata_tport_release;
>  	dev_set_name(dev, "ata%d", ap->print_id);
> +	device_enable_async_suspend(dev);
>  	transport_setup_device(dev);
>  	error = device_add(dev);
>  	if (error) {
>  		goto tport_err;
>  	}
>  
> -	device_enable_async_suspend(dev);

What's the reason for moving this line of code?  Will it have any 
significant effect?

> diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
> index d78b204..7209b6e 100644
> --- a/drivers/base/attribute_container.c
> +++ b/drivers/base/attribute_container.c
> @@ -349,6 +349,7 @@ attribute_container_add_attrs(struct device *classdev)
>  int
>  attribute_container_add_class_device(struct device *classdev)
>  {
> +	classdev->power.async_suspend = true;

Is this needed?  And why aren't you using the proper helper function?

> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index a235085..07fb818 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1020,7 +1020,8 @@ int device_add(struct device *dev)
>  		goto name_error;
>  	}
>  
> -	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
> +	pr_debug("device: '%s': %s, %s suspend\n", dev_name(dev), __func__,
> +		(dev->power.async_suspend) ? "async" : "sync");
>  
>  	parent = get_device(dev->parent);
>  	kobj = get_device_parent(dev, parent);
> @@ -1558,6 +1559,11 @@ struct device *device_create_vargs(struct class *class, struct device *parent,
>  		goto error;
>  	}
>  
> +	if (parent)
> +		dev->power.async_suspend = parent->power.async_suspend;
> +	else
> +		dev->power.async_suspend = true;

This really seems like going overboard.  It will cause _every_ device
to marked for async suspend unless userspace deliberately turns the
flag off.

> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 931a7d9..22b5a5a 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -838,6 +838,7 @@ static int scsi_target_add(struct scsi_target *starget)
>  	if (starget->state != STARGET_CREATED)
>  		return 0;
>  
> +	device_enable_async_suspend(&starget->dev);
>  	error = device_add(&starget->dev);
>  	if (error) {
>  		dev_err(&starget->dev, "target device_add failed, error %d\n", error);
> @@ -848,7 +849,6 @@ static int scsi_target_add(struct scsi_target *starget)
>  
>  	pm_runtime_set_active(&starget->dev);
>  	pm_runtime_enable(&starget->dev);
> -	device_enable_async_suspend(&starget->dev);

Again, what's the point of moving a line of code like this?

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 7992635..3a412ea 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2924,6 +2924,9 @@ static int sd_probe(struct device *dev)
>  	sdkp->dev.class = &sd_disk_class;
>  	dev_set_name(&sdkp->dev, dev_name(dev));
>  
> +	if (dev)
> +		sdkp->dev.power.async_suspend = dev->power.async_suspend;
> +
>  	if (device_add(&sdkp->dev))
>  		goto out_free_index;

Why not call device_enable_async_suspend() always?

Alan Stern

