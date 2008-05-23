From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [dm-devel] [PATCH 2/7] scsi_dh: Add 'dh_state' sysfs attribute
Date: Thu, 22 May 2008 19:08:20 -0700
Message-ID: <1211508500.21974.503.camel@chandra-ubuntu>
References: <20080520140530.936DC10B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:55825 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757107AbYEWCGS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2008 22:06:18 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4N26GPb017098
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 22:06:16 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4N26G9l091632
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 20:06:16 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4N26CsY028303
	for <linux-scsi@vger.kernel.org>; Thu, 22 May 2008 20:06:14 -0600
In-Reply-To: <20080520140530.936DC10B5DF@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org


On Tue, 2008-05-20 at 16:05 +0200, Hannes Reinecke wrote:
> Implement a 'dh_state' sdev attribute for dynamic device handler
> manipulation. A read on the attribute will return the name of
> the currently attached device handler or 'detached' if no handler
> is attached.
> The attribute allows the following strings to be written:
> - The name of the device handler to be attached if the state is
>   'detached'.
> - 'activate' to trigger path activation if a device handler
>   is attached.
> - 'detach' to detach the currently attached device handler.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |  107 ++++++++++++++++++++++++++++++++-
>  1 files changed, 105 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 0b5c457..b80fae7 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -79,6 +79,98 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev)
>  }
> 
>  /*
> + * Functions for sysfs attribute 'dh_state'
> + */
> +static ssize_t
> +store_dh_state(struct device *dev, struct device_attribute *attr,
> +	       const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct scsi_device_handler *scsi_dh;
> +	int err = -EINVAL;
> +
> +	if (!sdev->scsi_dh_data) {
> +		/*
> +		 * Attach to a device handler
> +		 */
> +		if (!(scsi_dh = get_device_handler(buf)))
> +			return err;
> +		err = scsi_dh_handler_attach(sdev, scsi_dh);
> +	} else {
> +		if (!strncmp(buf, "detach", 6)) {
> +			/*
> +			 * Detach from a device handler
> +			 */
> +			scsi_dh_handler_detach(sdev);
> +			err = 0;
> +		} else if (!strncmp(buf, "activate", 8)) {
> +			/*
> +			 * Activate a device handler
> +			 */
> +			scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +			if (scsi_dh->activate)
> +				err = scsi_dh->activate(sdev);
> +			else
> +				err = 0;

Sorry for the late comment. Why do we want to give the user to be able
to activate a path ? (I am assuming user as we do not want to be calling
this from multipath tools).

> +		}
> +	}
> +
> +	return err<0?err:count;
> +}
> +
> +static ssize_t
> +show_dh_state(struct device *dev, struct device_attribute *attr, char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +
> +	if (!sdev->scsi_dh_data)
> +		return snprintf(buf, 20, "detached\n");
> +
> +	return snprintf(buf, 20, "%s\n", sdev->scsi_dh_data->scsi_dh->name);
> +}
> +
> +static struct device_attribute scsi_dh_state_attr =
> +	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
> +	       store_dh_state);
> +
> +/*
> + * scsi_dh_sysfs_attr_add - Callback for scsi_init_dh
> + */
> +static int scsi_dh_sysfs_attr_add(struct device *dev, void *data)
> +{
> +	struct scsi_device *sdev;
> +	int err;
> +
> +	if (!scsi_is_sdev_device(dev))
> +		return 0;
> +
> +	sdev = to_scsi_device(dev);
> +
> +	err = device_create_file(&sdev->sdev_gendev,
> +				 &scsi_dh_state_attr);
> +
> +	return 0;
> +}
> +
> +/*
> + * scsi_dh_sysfs_attr_remove - Callback for scsi_exit_dh
> + */
> +static int scsi_dh_sysfs_attr_remove(struct device *dev, void *data)
> +{
> +	struct scsi_device *sdev;
> +
> +	if (!scsi_is_sdev_device(dev))
> +		return 0;
> +
> +	sdev = to_scsi_device(dev);
> +
> +	device_remove_file(&sdev->sdev_gendev,
> +			   &scsi_dh_state_attr);
> +
> +	return 0;
> +}
> +
> +/*
>   * scsi_dh_notifier - notifier chain callback
>   */
>  static int scsi_dh_notifier(struct notifier_block *nb,
> @@ -86,7 +178,7 @@ static int scsi_dh_notifier(struct notifier_block *nb,
>  {
>  	struct device *dev = data;
>  	struct scsi_device *sdev;
> -	int i, err = 0;
> +	int i;
>  	struct scsi_device_handler *tmp, *devinfo = NULL;
> 
>  	if (!scsi_is_sdev_device(dev))
> @@ -114,14 +206,19 @@ static int scsi_dh_notifier(struct notifier_block *nb,
>  		goto out;
> 
>  	if (action == BUS_NOTIFY_ADD_DEVICE) {
> +		int err;
> +
>  		err = scsi_dh_handler_attach(sdev, devinfo);
> +		if (!err)
> +			err = device_create_file(dev, &scsi_dh_state_attr);

we don't want to detach when we fail creating the file ? I am ok with
it, but just wanted to make sure that is what you intended.

>  	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
>  		if (sdev->scsi_dh_data == NULL)
>  			goto out;
> +		device_remove_file(dev, &scsi_dh_state_attr);
>  		scsi_dh_handler_detach(sdev);
>  	}
>  out:
> -	return err;
> +	return 0;

why are we not returning err ?
>  }
> 
>  /*
> @@ -275,11 +372,17 @@ static int __init scsi_dh_init(void)
> 
>  	r = bus_register_notifier(&scsi_bus_type, &scsi_dh_nb);
> 
> +	if (!r)
> +		bus_for_each_dev(&scsi_bus_type, NULL, NULL,
> +				 scsi_dh_sysfs_attr_add);
> +
>  	return r;
>  }
> 
>  static void __exit scsi_dh_exit(void)
>  {
> +	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
> +			 scsi_dh_sysfs_attr_remove);
>  	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
>  }
> 

