From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ensure bsg device is available before announcing
 scsi device
Date: Thu, 03 Mar 2011 11:56:59 -0600
Message-ID: <1299175019.9151.16.camel@mulgrave.site>
References: <1299092565.26023.2.camel@satan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48494 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758773Ab1CCUqE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2011 15:46:04 -0500
In-Reply-To: <1299092565.26023.2.camel@satan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Zeuthen <davidz@redhat.com>
Cc: linux-scsi@vger.kernel.org, kay.sievers@vrfy.org

On Wed, 2011-03-02 at 14:02 -0500, David Zeuthen wrote:
> From: David Zeuthen <davidz@redhat.com>
> 
> udev should be able to examine a scsi device (e.g. retrieving VPD like
> the make/model and serial number) before announcing it to the rest of
> user space. Currently this is not possible because the scsi device has
> no device node of its own. Instead, user space will have to use either
> the bsg device or sg device but these are not available at uevent add
> time since both are children of the scsi device

This premise sounds a bit wrong.  SCSI devices go through several
distinct phases: create, add and then configure.  We send the initial
probe before the add phase, but no user should really poke at the device
before the configure phase because that's where we set the
characteristics and other stuff.  The signal to udev that the configure
phase is over is when the ULD binding completes.  That's when the device
is running and it's safe to poke at.  It also means it's been identified
internally and you'll know whether it's a disk, a tape or whatever.

So you should see two distinct events: an ADD for the sdev, meaning we
think there's something there, but at this point there's no real device
for a user to see followed by the add for whatever the ULD major device
binding is ... at that point, we guarantee the device is up, its bsg
queue is registered, there's actually a user block or character device
corresponding to it and we've finished configuring it.

What exactly are you trying to do here?  It's really not that safe to be
running user level poking in parallel with the configuration scanning
we'll be doing as the ULD binds.

James


> This patch ensures that the bsg device is created before user space is
> notified of add event for the scsi device. With devtmpfs, this thus
> enables udev to use the /dev/bsg/$kernel device node to examine the
> scsi device.
> 
> Related udev commits:
> 
>  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=2938220037862b7698df091a1e5cd45f44132d73
>  http://git.kernel.org/?p=linux/hotplug/udev.git;a=commitdiff;h=310f99d33595afdc1962611a913c429785f9ad40
> 
> Signed-off-by: David Zeuthen <davidz@redhat.com>
> Acked-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  block/bsg.c                       |   53 +++++++++++++++++++++++++++++++++++-
>  drivers/scsi/scsi_sysfs.c         |   27 +++++++++++++-----
>  drivers/scsi/scsi_transport_fc.c  |    4 +-
>  drivers/scsi/scsi_transport_sas.c |    2 +-
>  include/linux/bsg.h               |    6 +++-
>  5 files changed, 77 insertions(+), 15 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index 0c8b64a..7148b4c 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -993,8 +993,48 @@ void bsg_unregister_queue(struct request_queue *q)
>  }
>  EXPORT_SYMBOL_GPL(bsg_unregister_queue);
>  
> +static void bsg_release_class_device(struct device *dev)
> +{
> +	pr_debug("device: '%s': %s\n", dev_name(dev), __func__);
> +	kfree(dev);
> +}
> +
> +static struct device *bsg_create_class_device(struct class *class,
> +					      struct device *parent,
> +					      dev_t devt,
> +					      const char *name)
> +{
> +	struct device *dev = NULL;
> +	int retval = -ENODEV;
> +
> +	if (class == NULL || IS_ERR(class))
> +		goto error;
> +
> +	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
> +	if (!dev) {
> +		retval = -ENOMEM;
> +		goto error;
> +	}
> +
> +	dev->devt = devt;
> +	dev->class = class;
> +	dev->parent = parent;
> +	dev->release = bsg_release_class_device;
> +
> +	retval = kobject_set_name(&dev->kobj, name);
> +	if (retval)
> +		goto error;
> +
> +	return dev;
> +
> +error:
> +	put_device(dev);
> +	return ERR_PTR(retval);
> +}
> +
>  int bsg_register_queue(struct request_queue *q, struct device *parent,
> -		       const char *name, void (*release)(struct device *))
> +		       const char *name, void (*release)(struct device *),
> +		       bool suppress_add_uevent)
>  {
>  	struct bsg_class_device *bcd;
>  	dev_t dev;
> @@ -1040,11 +1080,20 @@ int bsg_register_queue(struct request_queue *q, struct device *parent,
>  	bcd->release = release;
>  	kref_init(&bcd->ref);
>  	dev = MKDEV(bsg_major, bcd->minor);
> -	class_dev = device_create(bsg_class, parent, dev, NULL, "%s", devname);
> +	class_dev = bsg_create_class_device(bsg_class, parent, dev, devname);
>  	if (IS_ERR(class_dev)) {
>  		ret = PTR_ERR(class_dev);
>  		goto put_dev;
>  	}
> +	if (suppress_add_uevent) {
> +		dev_set_uevent_suppress(class_dev, true);
> +		ret = device_register(class_dev);
> +		dev_set_uevent_suppress(class_dev, false);
> +	} else {
> +		ret = device_register(class_dev);
> +	}
> +	if (ret)
> +		goto put_dev;
>  	bcd->class_dev = class_dev;
>  
>  	if (q->kobj.sd) {
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 490ce21..fd8c43f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -862,12 +862,31 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	 */
>  	scsi_autopm_get_device(sdev);
>  
> +	/* Delay add uevent for device until bsg device has been
> +	 * created - this way user space can use the bsg device node
> +	 * when handling the uevent
> +	 */
> +	dev_set_uevent_suppress(&sdev->sdev_gendev, true);
>  	error = device_add(&sdev->sdev_gendev);
> +	dev_set_uevent_suppress(&sdev->sdev_gendev, false);
>  	if (error) {
>  		sdev_printk(KERN_INFO, sdev,
>  				"failed to add device: %d\n", error);
>  		return error;
>  	}
> +
> +	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL, true);
> +	if (error) {
> +		/* we're treating error on bsg register as non-fatal,
> +		 * so pretend nothing went wrong */
> +		sdev_printk(KERN_INFO, sdev,
> +			    "Failed to register bsg queue, errno=%d\n", error);
> +		kobject_uevent(&sdev->sdev_gendev.kobj, KOBJ_ADD);
> +	} else {
> +		kobject_uevent(&sdev->sdev_gendev.kobj, KOBJ_ADD);
> +		kobject_uevent(&rq->bsg_dev.class_dev->kobj, KOBJ_ADD);
> +	}
> +
>  	device_enable_async_suspend(&sdev->sdev_dev);
>  	error = device_add(&sdev->sdev_dev);
>  	if (error) {
> @@ -898,14 +917,6 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
>  	if (error)
>  		return error;
>  
> -	error = bsg_register_queue(rq, &sdev->sdev_gendev, NULL, NULL);
> -
> -	if (error)
> -		/* we're treating error on bsg register as non-fatal,
> -		 * so pretend nothing went wrong */
> -		sdev_printk(KERN_INFO, sdev,
> -			    "Failed to register bsg queue, errno=%d\n", error);
> -
>  	/* add additional host specific attributes */
>  	if (sdev->host->hostt->sdev_attrs) {
>  		for (i = 0; sdev->host->hostt->sdev_attrs[i]; i++) {
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 998c01b..6066b9a7 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -4037,7 +4037,7 @@ fc_bsg_hostadd(struct Scsi_Host *shost, struct fc_host_attrs *fc_host)
>  	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
>  	blk_queue_rq_timeout(q, FC_DEFAULT_BSG_TIMEOUT);
>  
> -	err = bsg_register_queue(q, dev, bsg_name, NULL);
> +	err = bsg_register_queue(q, dev, bsg_name, NULL, false);
>  	if (err) {
>  		printk(KERN_ERR "fc_host%d: bsg interface failed to "
>  				"initialize - register queue\n",
> @@ -4083,7 +4083,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost, struct fc_rport *rport)
>  	blk_queue_rq_timed_out(q, fc_bsg_job_timeout);
>  	blk_queue_rq_timeout(q, BLK_DEFAULT_SG_TIMEOUT);
>  
> -	err = bsg_register_queue(q, dev, NULL, NULL);
> +	err = bsg_register_queue(q, dev, NULL, NULL, false);
>  	if (err) {
>  		printk(KERN_ERR "%s: bsg interface failed to "
>  				"initialize - register queue\n",
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 927e99c..0da85fe 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -241,7 +241,7 @@ static int sas_bsg_initialize(struct Scsi_Host *shost, struct sas_rphy *rphy)
>  	if (!q)
>  		return -ENOMEM;
>  
> -	error = bsg_register_queue(q, dev, name, release);
> +	error = bsg_register_queue(q, dev, name, release, false);
>  	if (error) {
>  		blk_cleanup_queue(q);
>  		return -ENOMEM;
> diff --git a/include/linux/bsg.h b/include/linux/bsg.h
> index ecb4730..999f3e9 100644
> --- a/include/linux/bsg.h
> +++ b/include/linux/bsg.h
> @@ -75,12 +75,14 @@ struct bsg_class_device {
>  
>  extern int bsg_register_queue(struct request_queue *q,
>  			      struct device *parent, const char *name,
> -			      void (*release)(struct device *));
> +			      void (*release)(struct device *),
> +			      bool suppress_add_uevent);
>  extern void bsg_unregister_queue(struct request_queue *);
>  #else
>  static inline int bsg_register_queue(struct request_queue *q,
>  				     struct device *parent, const char *name,
> -				     void (*release)(struct device *))
> +				     void (*release)(struct device *),
> +				     bool suppress_add_uevent)
>  {
>  	return 0;
>  }


