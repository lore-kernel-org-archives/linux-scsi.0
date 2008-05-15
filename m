From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 2/7] scsi_dh: Add 'dh_state' sysfs attribute
Date: Wed, 14 May 2008 19:45:55 -0700
Message-ID: <1210819555.21974.253.camel@chandra-ubuntu>
References: <20080514144315.968DE10B5DF@craiglockhart-ipmi.suse.de>
Reply-To: sekharan@us.ibm.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080514144315.968DE10B5DF@craiglockhart-ipmi.suse.de>
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

All the sysfs functions can be grouped together. Helps in readability.

>  drivers/scsi/device_handler/scsi_dh.c |   88 +++++++++++++++++++++++++++++++++
>  1 files changed, 88 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
> index 55e5fd2..2dbf84b 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -54,6 +54,55 @@ static struct scsi_device_handler *get_device_handler(const char *name)
>  	return found;
>  }
> 
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
> +		/*
> +		 * Detach from a device handler
> +		 */
> +		if (!strncmp(buf, "detach", 6)) {
> +			err = scsi_dh_handler_detach(sdev);
> +		} else if (!strncmp(buf, "activate", 8)) {
> +			scsi_dh = sdev->scsi_dh_data->scsi_dh;
> +
> +			err = scsi_dh->activate(sdev);
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
> +	struct scsi_device_handler *scsi_dh;
> +
> +	if (!sdev->scsi_dh_data)
> +		return snprintf(buf, 20, "detached\n");
> +
> +	scsi_dh = sdev->scsi_dh_data->scsi_dh;

we can use it directly instead of this variable ?

> +
> +	return snprintf(buf, 20, "%s\n", scsi_dh->name);
> +}
> +
> +static struct device_attribute scsi_dh_state_attr =
> +	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
> +	       store_dh_state);
> +
>  /*
>   * scsi_dh_handler_attach - Attach a device handler to a device
>   * @sdev - SCSI device the device handler should attach to
> @@ -115,9 +164,11 @@ static int scsi_dh_notifier(struct notifier_block *nb,
> 
>  	if (action == BUS_NOTIFY_ADD_DEVICE) {
>  		scsi_dh_handler_attach(sdev, devinfo->handler);
> +		device_create_file(dev, &scsi_dh_state_attr);

A later patch checks for the return status of scsi_dh_handler_attach(),
should be moved here.

>  	} else if (action == BUS_NOTIFY_DEL_DEVICE) {
>  		if (sdev->scsi_dh_data == NULL)
>  			goto out;
> +		device_remove_file(dev, &scsi_dh_state_attr);
>  		scsi_dh_handler_detach(sdev);
>  	}
>  out:
> @@ -298,17 +349,54 @@ static struct notifier_block scsi_dh_nb = {
>  	.notifier_call = scsi_dh_notifier
>  };
> 
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
>  static int __init scsi_dh_init(void)
>  {
>  	int r;
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
>  static void __exit scsi_dh_exit(void)
>  {
> +	bus_for_each_dev(&scsi_bus_type, NULL, NULL,
> +			 scsi_dh_sysfs_attr_remove);
>  	bus_unregister_notifier(&scsi_bus_type, &scsi_dh_nb);
>  }
> 
