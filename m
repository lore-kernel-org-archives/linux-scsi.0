From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] scsi sysfs cleanups
Date: Tue, 19 Nov 2002 16:48:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021119164856.A11391@infradead.org>
References: <20021119153008.GA1544@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021119153008.GA1544@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Nov 19, 2002 at 07:30:08AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2002 at 07:30:08AM -0800, Mike Anderson wrote:
> +static inline void scsi_class_data_set(struct device *dev,
> +				       struct Scsi_Host *host)
> +{
> +	dev->class_data = (void *)host;
> +};
> +
> +static inline struct Scsi_Host *scsi_class_data_get(struct device *dev)
> +{
> +	return (struct Scsi_Host *) dev->class_data;
> +};

These casts look rather pointless.

> -module_init(init_scsi);
> +subsys_initcall(init_scsi);
>  module_exit(exit_scsi);


What's the exact reason for this change?

>  /*
> - * driverfs support for determining driver types
> + * sysfs support
>   */
> -EXPORT_SYMBOL(scsi_driverfs_bus_type);
> +EXPORT_SYMBOL(scsi_device_driver_register);
> +EXPORT_SYMBOL(scsi_device_driver_unregister);
> +EXPORT_SYMBOL(scsi_host_class_register);
> +EXPORT_SYMBOL(scsi_host_class_unregister);
> +EXPORT_SYMBOL(shost_devclass);

Why are these exported?

> +/**
> + * scsi_host_class_register - register class scsi host
> + * @dev:	class device to register
> + * @shost:	scsi host associtated with class device
> + *
> + * Return value:
> + **/
> +int scsi_host_class_register(struct device *dev, struct Scsi_Host *shost)
> +{
> +	scsi_class_data_set(dev, shost);
> +	scsi_host_dev_set(shost, dev);
> +
> +	scsi_add_host(shost);
> +
> +	return 0;
> +}
> +
> +/**
> + * scsi_host_class_unregister - unregister class scsi host.
> + * @dev:	class device to unregister
> + **/
> +void scsi_host_class_unregister(struct device *dev)
> +{
> +	struct Scsi_Host *shost;
> +
> +	shost = scsi_class_data_get(dev);
> +
> +	scsi_remove_host(shost);
> +
> +	scsi_class_data_set(dev, NULL);
> +
> +}
> diff -Nru a/drivers/scsi/sd.c b/drivers/scsi/sd.c

What the point of these?  They don't seem to be used at all..

