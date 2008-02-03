From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Sun, 3 Feb 2008 23:03:48 +0100
Message-ID: <20080203220348.GH2648@uranus.ravnborg.org>
References: <1202074856.3318.111.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:58279 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751460AbYBCWDo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Feb 2008 17:03:44 -0500
Content-Disposition: inline
In-Reply-To: <1202074856.3318.111.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>

Hi James.

Nitpicking only.

	Sam

> The enclosure misc device is really just a library providing sysfs
> support for physical enclosure devices and their components.
> 
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
> 
> See the additional ses patch for SCSI enclosure services users of this.
> 
> ---
>  drivers/misc/Kconfig      |   10 +
>  drivers/misc/Makefile     |    1 +
>  drivers/misc/enclosure.c  |  449 +++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/enclosure.h |  120 ++++++++++++
>  4 files changed, 580 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/enclosure.c
>  create mode 100644 include/linux/enclosure.h
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index b5e67c0..c6e5c09 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -11,6 +11,7 @@ menuconfig MISC_DEVICES
>  
>  	  If you say N, all options in this submenu will be skipped and disabled.
>  
> +
>  if MISC_DEVICES

Unrelated change.

>  
>  config IBM_ASM
> @@ -232,4 +233,13 @@ config ATMEL_SSC
>  
>  	  If unsure, say N.
>  
> +config ENCLOSURE_SERVICES
> +	tristate "Enclosure Services"
> +	default n
Not needed. n is default.

> +	help
> +	  Provides support for intelligent enclosures (bays which
> +	  contain storage devices).  You also need either a host
> +	  driver (SCSI/ATA) which supports enclosures
> +	  or a SCSI enclosure device (SES) to use these services.
> +
>  endif # MISC_DEVICES
> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> index 87f2685..de9f1f5 100644
> --- a/drivers/misc/Makefile
> +++ b/drivers/misc/Makefile
> @@ -17,3 +17,4 @@ obj-$(CONFIG_SONY_LAPTOP)	+= sony-laptop.o
>  obj-$(CONFIG_THINKPAD_ACPI)	+= thinkpad_acpi.o
>  obj-$(CONFIG_FUJITSU_LAPTOP)	+= fujitsu-laptop.o
>  obj-$(CONFIG_EEPROM_93CX6)	+= eeprom_93cx6.o
> +obj-$(CONFIG_ENCLOSURE_SERVICES) += enclosure.o
> \ No newline at end of file
Can we get one..

> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> new file mode 100644
> index 0000000..e4683cd
> --- /dev/null
> +++ b/drivers/misc/enclosure.c
> @@ -0,0 +1,449 @@
> +/*
> + * Enclosure Services
> + *
> + * Copyright (C) 2008 James Bottomley <James.Bottomley@HansenPartnership.com>
> + *
> +**-----------------------------------------------------------------------------
> +**
> +**  This program is free software; you can redistribute it and/or
> +**  modify it under the terms of the GNU General Public License
> +**  version 2 as published by the Free Software Foundation.
> +**
> +**  This program is distributed in the hope that it will be useful,
> +**  but WITHOUT ANY WARRANTY; without even the implied warranty of
> +**  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +**  GNU General Public License for more details.
> +**
> +**  You should have received a copy of the GNU General Public License
> +**  along with this program; if not, write to the Free Software
> +**  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +**
> +**-----------------------------------------------------------------------------
> +*/
> +#include <linux/device.h>
> +#include <linux/enclosure.h>
> +#include <linux/err.h>
> +#include <linux/list.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +static LIST_HEAD(container_list);
> +static DEFINE_MUTEX(container_list_lock);
> +static struct class enclosure_class;
> +static struct class enclosure_component_class;
> +
> +/**
> + * enclosure_find - find an enclosure given a device
> + * @dev:	the device to find for
> + *
> + * Looks through the list of registered enclosures to see
> + * if it can find a match for a device.  Returns NULL if no
> + * enclosure is found.
> + */
> +struct enclosure_device *enclosure_find(struct device *dev)
> +{
> +	struct enclosure_device *edev = NULL;
> +
> +	mutex_lock(&container_list_lock);
> +	list_for_each_entry(edev, &container_list, node) {
> +		if (edev->cdev.dev == dev) {
> +			mutex_unlock(&container_list_lock);
> +			return edev;
> +		}
> +	}
> +	mutex_unlock(&container_list_lock);
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(enclosure_find);

No GPL - but the other of your EXPORT's are GPL.

> +
> +/**
> + * enclosure_for_each_device - calls a function for each enclosure
> + * @fn:		the function to call
> + * @data:	the data to pass to each call
> + *
> + * Loops over all the enclosures calling the function.
> + *
> + * Note, this function uses a mutex which will be held across calls to
> + * @fn, so it must have user context, and @fn should not sleep or
> + * otherwise cause the mutex to be held for indefinite periods
> + */
> +int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
> +			      void *data)
> +{
> +	int error = 0;
> +	struct enclosure_device *edev;
> +
> +	mutex_lock(&container_list_lock);
> +	list_for_each_entry(edev, &container_list, node) {
> +		error = fn(edev, data);
> +		if (error)
> +			break;
> +	}
> +	mutex_unlock(&container_list_lock);
> +
> +	return error;
> +}
> +EXPORT_SYMBOL_GPL(enclosure_for_each_device);
> +
> +/**
> + * enclosure_register - register device as an enclosure
> + *
> + * @dev:	device containing the enclosure
> + * @components:	number of components in the enclosure
> + *
> + * This sets up the device for being an enclosure.  Note that @dev does
> + * not have to be a dedicated enclosure device.  It may be some other type
> + * of device that additionally responds to enclosure services
> + */
> +struct enclosure_device *
> +enclosure_register(struct device *dev, const char *name, int components,
> +		   struct enclosure_component_callbacks *cb)
style purists would request you to put return type and function
name on the same line...


> +{
> +	struct enclosure_device *edev =
> +		kzalloc(sizeof(struct enclosure_device) +
> +			sizeof(struct enclosure_component)*components,
> +			GFP_KERNEL);
> +	int err, i;
> +
> +	if (!edev)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (!cb)
> +		return ERR_PTR(-EINVAL);
We leak memory here - we never free edev.

> +
> +	edev->components = components;
> +
> +	edev->cdev.class = &enclosure_class;
> +	edev->cdev.dev = get_device(dev);
> +	edev->cb = cb;
> +	snprintf(edev->cdev.class_id, BUS_ID_SIZE, "%s", name);
> +	err = class_device_register(&edev->cdev);
> +	if (err)
> +		goto err;
> +
> +	for (i = 0; i < components; i++)
> +		edev->component[i].number = -1;
> +
> +	mutex_lock(&container_list_lock);
> +	list_add_tail(&edev->node, &container_list);
> +	mutex_unlock(&container_list_lock);
> +
> +	return edev;
> +
> + err:
> +	put_device(edev->cdev.dev);
> +	kfree(edev);
> +	return ERR_PTR(err);
> +}
> +EXPORT_SYMBOL_GPL(enclosure_register);
> +
> +static struct enclosure_component_callbacks enclosure_null_callbacks;
> +
> +/**
> + * enclosure_unregister - remove an enclosure
> + *
> + * @edev:	the registered enclosure to remove;
> + */
> +void enclosure_unregister(struct enclosure_device *edev)
> +{
> +	int i;
> +
> +	if (!edev)
> +		return;
> +
> +	mutex_lock(&container_list_lock);
> +	list_del(&edev->node);
> +	mutex_unlock(&container_list_lock);
> +
> +	for (i = 0; i < edev->components; i++)
> +		if (edev->component[i].number != -1)
> +			class_device_unregister(&edev->component[i].cdev);
> +
> +	/* prevent any callbacks into service user */
> +	edev->cb = &enclosure_null_callbacks;
> +	class_device_unregister(&edev->cdev);
> +}
> +EXPORT_SYMBOL_GPL(enclosure_unregister);
> +
> +static void enclosure_release(struct class_device *cdev)
> +{
> +	struct enclosure_device *edev = to_enclosure_device(cdev);
> +
> +	put_device(cdev->dev);
> +	kfree(edev);
> +}
> +
> +static void enclosure_component_release(struct class_device *cdev)
> +{
> +	if (cdev->dev)
> +		put_device(cdev->dev);
> +	class_device_put(cdev->parent);
> +}
> +
> +struct enclosure_component *
> +enclosure_component_register(struct enclosure_device *edev,
> +			     unsigned int number,
> +			     enum enclosure_component_type type,
> +			     const char *name)
> +{
Missing kernel-doc for this and the following exports.

> +	struct enclosure_component *ecomp;
> +	struct class_device *cdev;
> +	int err;
> +
> +	if (!edev || number >= edev->components)
> +		return ERR_PTR(-EINVAL);
> +
> +	ecomp = &edev->component[number];
> +
> +	if (ecomp->number != -1)
> +		return ERR_PTR(-EINVAL);
> +
> +	ecomp->type = type;
> +	ecomp->number = number;
> +	cdev = &ecomp->cdev;
> +	cdev->parent = class_device_get(&edev->cdev);
> +	cdev->class = &enclosure_component_class;
> +	if (name)
> +		snprintf(cdev->class_id, BUS_ID_SIZE, "%s", name);
> +	else
> +		snprintf(cdev->class_id, BUS_ID_SIZE, "%d", number);
> +
> +	err = class_device_register(cdev);
> +	if (err)
> +		ERR_PTR(err);
> +
> +	return ecomp;
> +}
> +EXPORT_SYMBOL_GPL(enclosure_component_register);

