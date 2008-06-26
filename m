From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/9] scsi_dh: Add 'dh_state' sysfs attribute
Date: Wed, 25 Jun 2008 17:53:44 -0700
Message-ID: <1214441624.32521.12.camel@chandra-ubuntu>
References: <20080624100442.042C910B5DE@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46787 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbYFZAxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jun 2008 20:53:48 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m5Q0rm6Q011987
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 20:53:48 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5Q0rmBp214014
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 20:53:48 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5Q0rlt0003242
	for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 20:53:47 -0400
In-Reply-To: <20080624100442.042C910B5DE@craiglockhart-ipmi.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>

On Tue, 2008-06-24 at 12:04 +0200, Hannes Reinecke wrote:
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
>  drivers/scsi/device_handler/scsi_dh.c |  103 ++++++++++++++++++++++++++++++++-
>  1 files changed, 102 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 21cd645..7cbd1f6 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -84,7 +84,7 @@ static int scsi_dh_handler_attach(struct scsi_device *sdev,
>   * @scsi_dh - Device handler to be detached
>   *
>   * Detach from a device handler. If a device handler is specified,
> - * only detach if the currently attached handler is equal to it.
> + * only detach if the currently attached handler matches @scsi_dh.
>   */
>  static void scsi_dh_handler_detach(struct scsi_device *sdev,
>  				   struct scsi_device_handler *scsi_dh)
> @@ -100,6 +100,98 @@ static void scsi_dh_handler_detach(struct scsi_device *sdev,
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
> +		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +		if (!strncmp(buf, "detach", 6)) {
> +			/*
> +			 * Detach from a device handler
> +			 */
> +			scsi_dh_handler_detach(sdev, scsi_dh);
> +			err = 0;
> +		} else if (!strncmp(buf, "activate", 8)) {
> +			/*
> +			 * Activate a device handler
> +			 */
> +			if (scsi_dh->activate)
> +				err = scsi_dh->activate(sdev);
> +			else
> +				err = 0;
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
> @@ -129,7 +221,10 @@ static int scsi_dh_notifier(struct notifier_block *nb,
> 
>  	if (action == BUS_NOTIFY_ADD_DEVICE) {
>  		err = scsi_dh_handler_attach(sdev, devinfo);
> +		if (!err)
> +		    err = device_create_file(dev, &scsi_dh_state_attr);
>  	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
> +		device_remove_file(dev, &scsi_dh_state_attr);
>  		scsi_dh_handler_detach(sdev, NULL);
>  	}
>  out:
> @@ -281,11 +376,17 @@ static int __init scsi_dh_init(void)
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

