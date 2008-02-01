From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/9] scsi_dh: add skeleton for SCSI Device
	Handlers
Date: Fri, 01 Feb 2008 13:53:39 -0600
Message-ID: <47A378C3.5030207@cs.wisc.edu>
References: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
	<20080124003115.18871.42778.sendpatchset@localhost.localdomain>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080124003115.18871.42778.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: andmike@us.ibm.com, dm-devel@redhat.com, linux-scsi@vger.kernel.org, jens.axboe@oracle.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
>  	 * mainly associated with tapes and returned SUCCESS.
> Index: linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
> ===================================================================
> --- linux-2.6.24-rc8.orig/drivers/scsi/scsi_sysfs.c
> +++ linux-2.6.24-rc8/drivers/scsi/scsi_sysfs.c
> @@ -951,6 +951,49 @@ int scsi_register_interface(struct class
>  }
>  EXPORT_SYMBOL(scsi_register_interface);
>  
> +static int scsi_dh_notifier_add(struct device *dev, void *data)
> +{
> +	struct scsi_device_handler *sdev_dh = data;
> +
> +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_ADD_DEVICE, dev);
> +
> +	return 0;
> +}
> +
> +int scsi_register_device_handler(struct scsi_device_handler *sdev_dh)
> +{
> +	int ret;
> +
> +	ret = bus_register_notifier(&scsi_bus_type, &sdev_dh->nb);
> +
> +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh, scsi_dh_notifier_add);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(scsi_register_device_handler);
> +
> +static int scsi_dh_notifier_remove(struct device *dev, void *data)
> +{
> +	struct scsi_device_handler *sdev_dh = data;
> +
> +	sdev_dh->nb.notifier_call(&sdev_dh->nb, BUS_NOTIFY_DEL_DEVICE, dev);
> +
> +	return 0;
> +}
> +
> +int scsi_unregister_device_handler(struct scsi_device_handler *sdev_dh)
> +{
> +	int ret;
> +
> +	ret = bus_unregister_notifier(&scsi_bus_type, &sdev_dh->nb);
> +
> +	bus_for_each_dev(&scsi_bus_type, NULL, sdev_dh,
> +					scsi_dh_notifier_remove);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(scsi_unregister_device_handler);
> +

Did this end up solving the problem I was hitting where when using the 
other driver model stuff like is used with the SCSI upper layer drivers. 
The problem where the hw handler module had to be loaded before finding 
devices and had to be loaded before sd.c?
