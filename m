From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RFC 1/2] drivers/base: add bus_device_iter_init,
 bus_device_iter_next, bus_device_iter_exit
Date: Fri, 18 Dec 2015 10:22:46 +0100
Message-ID: <5673D066.2020603@suse.de>
References: <1449583704-32400-1-git-send-email-emilne@redhat.com>
 <1449583704-32400-2-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42226 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932445AbbLRJWs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Dec 2015 04:22:48 -0500
In-Reply-To: <1449583704-32400-2-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 12/08/2015 03:08 PM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> These functions are needed to expose an iterator for SCSI usage.
>
>  From a patch originally developed by David Jeffery <djeffery@redhat.=
com>
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/base/bus.c     | 59 +++++++++++++++++++++++++++++++++++++++=
+++++++++++
>   include/linux/device.h |  5 +++++
>   2 files changed, 64 insertions(+)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 5005924..a472e46 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -318,6 +318,65 @@ int bus_for_each_dev(struct bus_type *bus, struc=
t device *start,
>   EXPORT_SYMBOL_GPL(bus_for_each_dev);
>
>   /**
> + * bus_device_iter_init - Initialize an iterator for walking a bus's=
 devices.
> + * @iter: iterator structure to initialize
> + * @bus: bus type
> + *
> + * Initializes an iterator for safely walking a bus's list of device=
s.  The
> + * iterator can be used by bus_device_iter_next() to safely walk the=
 list, even
> + * if a device is removed from the list while being examined.  Needs=
 to be
> + * matched with a call to bus_device_iter_exit() to clean up the ite=
rator when
> + * finished.
> + *
> + * Return 0 on success, non-zero on failure.  Iterator cannot be use=
d
> + * for a non-zero result
> + */
> +int bus_device_iter_init(struct klist_iter *iter,
> +			 struct bus_type *bus)
> +{
> +	if (!bus || !bus->p)
> +		return -EINVAL;
> +
> +	klist_iter_init_node(&bus->p->klist_devices, iter, NULL);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(bus_device_iter_init);
> +
> +/**
> + * bus_device_iter_next - Get a bus's next device from the iterator.
> + * @iter: iterator structure from bus_device_iter_init()
> + *
> + * Finds the next valid device entry on a bus's device list.  Allows=
 the list
> + * to be safely traversed by the caller even when other tasks remove=
 devices
> + * from the list.
> + *
> + * Returns a reference to the next device, or NULL if no more device=
s.
> + */
> +struct device *bus_device_iter_next(struct klist_iter *iter)
> +{
> +	struct device *dev;
> +
> +	while ((dev =3D next_device(iter)))
> +		if (get_device(dev))
> +			break;
> +
> +	return dev;
> +}
> +EXPORT_SYMBOL_GPL(bus_device_iter_next);
> +
> +/**
> + * bus_device_iter_exit - Clean up an iterator from walking a bus's =
device list.
> + * @iter: iterator structure from bus_device_iter_init() to clean up
> + *
> + * Clean up any remaining state after finishing walking a bus's devi=
ce list.
> + */
> +void bus_device_iter_exit(struct klist_iter *iter)
> +{
> +	klist_iter_exit(iter);
> +}
> +EXPORT_SYMBOL_GPL(bus_device_iter_exit);
> +
> +/**
>    * bus_find_device - device iterator for locating a particular devi=
ce.
>    * @bus: bus type
>    * @start: Device to begin with
> diff --git a/include/linux/device.h b/include/linux/device.h
> index b8f411b..a44d912 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -151,6 +151,11 @@ void subsys_dev_iter_exit(struct subsys_dev_iter=
 *iter);
>
>   int bus_for_each_dev(struct bus_type *bus, struct device *start, vo=
id *data,
>   		     int (*fn)(struct device *dev, void *data));
> +
> +int bus_device_iter_init(struct klist_iter *iter, struct bus_type *b=
us);
> +struct device *bus_device_iter_next(struct klist_iter *iter);
> +void bus_device_iter_exit(struct klist_iter *iter);
> +
>   struct device *bus_find_device(struct bus_type *bus, struct device =
*start,
>   			       void *data,
>   			       int (*match)(struct device *dev, void *data));
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
