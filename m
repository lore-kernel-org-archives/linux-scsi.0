From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/7] scsi_dh: Implement generic device table
	handling
Date: Wed, 14 May 2008 19:45:51 -0700
Message-ID: <1210819551.21974.252.camel@chandra-ubuntu>
References: <20080514144310.1EDBC10B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080514144310.1EDBC10B5DF@craiglockhart-ipmi.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, dm-devel <dm-devel@redhat.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Wed, 2008-05-14 at 16:43 +0200, Hannes Reinecke wrote:
<snip>

> +
> +struct scsi_dh_devinfo_list {
> +	struct list_head node;
> +	char vendor[9];
> +	char model[17];
> +	struct scsi_device_handler *handler;
> +};

I do not see why we should be duplicating the information that is already present in scsi_dh and is available here thru scsi_dh_list. Instead of walking thru the scsi_dh_dev_list we could walk thru scsi_dh_list and get the same result.

On the other hand, if we could create a cache of the list of devices (vendor-product-scsi_dh triplet) that has been attached, and walk thru that list first before others during attach, it would help (as we would guess there to be multiple of the same device).
 
> +
> +int scsi_dh_handler_attach(struct scsi_device *sdev,
> +			   struct scsi_device_handler *scsi_dh);
> +int scsi_dh_handler_detach(struct scsi_device *sdev);

Why is the prototype needed ?

Can this be static ?

> 
>  static struct scsi_device_handler *get_device_handler(const char *name)
>  {
> @@ -33,7 +45,7 @@ static struct scsi_device_handler *get_device_handler(const char *name)
> 

<snip>

> +/*
> + * scsi_dh_handler_attach - Attach a device handler to a device
> + * @sdev - SCSI device the device handler should attach to
> + * @scsi_dh - The device handler to attach
> + */
> +int scsi_dh_handler_attach(struct scsi_device *sdev,
> +			   struct scsi_device_handler *scsi_dh)
> +{
> +	int err = -EBUSY;
> +
> +	if (sdev->scsi_dh_data)
> +		return err;

One of the later patch check for scsi_dh to be same as sdev->scsi_dh_data->scsi_dh. We can check for that here.

One more thing: there are multiple places (in this file and in the hardware handlers) the same check appear. Can we just do it only here and remove all the others ?

> +
> +	err = scsi_dh->attach(sdev);

This assumes attach is available, but there is no assertion in
scsi_register_device_handler().  Same is the case with detach(). Either
assert or check for the function availability here.
> +
> +	return err;
> +}
> +
> +/*
> + * scsi_dh_handler_detach - Detach a device handler to a device
> + * @sdev - SCSI device the device handler should be detached from
> + */
> +int scsi_dh_handler_detach(struct scsi_device *sdev)
> +{
> +	struct scsi_device_handler *scsi_dh;

can avoid the variable and call detach directly ?
> +
> +	if (!sdev->scsi_dh_data)
> +		return -ENODEV;

Can't we just return 0 ?

> +
> +	scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +
> +	scsi_dh->detach(sdev);
> +
> +	return 0;
> +}

<snip>

>  	list_add(&scsi_dh->list, &scsi_dh_list);
>  	spin_unlock(&list_lock);
> +	bus_for_each_dev(&scsi_bus_type, NULL, scsi_dh, scsi_dh_notifier_add);
> +	printk(KERN_INFO "%s: registered\n", scsi_dh->name);

We can be more descriptive. Like "Hardware handler %s registered" or some such.

> +	ret = SCSI_DH_OK;
> 
>  done:
>  	return ret;
<snip>

> +	}
>  	list_del(&scsi_dh->list);
>  	spin_unlock(&list_lock);
> +	printk(KERN_INFO "%s: unregistered\n", scsi_dh->name);

Same here.

> +	ret = SCSI_DH_OK;
> 
>  done:
>  	return ret;

<snip>
