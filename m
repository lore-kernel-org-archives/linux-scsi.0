From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 5 Feb 2008 16:12:18 -0800
Message-ID: <20080205161218.70af0ff9.akpm@linux-foundation.org>
References: <1202074856.3318.111.camel@localhost.localdomain>
	<20080203220348.GH2648@uranus.ravnborg.org>
	<1202084211.3318.129.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54655 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759026AbYBFAN6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Feb 2008 19:13:58 -0500
In-Reply-To: <1202084211.3318.129.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sam@ravnborg.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, kristen.c.accardi@intel.com

On Sun, 03 Feb 2008 18:16:51 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> 
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Sun, 3 Feb 2008 15:40:56 -0600
> Subject: [SCSI] enclosure: add support for enclosure services
> 
> The enclosure misc device is really just a library providing sysfs
> support for physical enclosure devices and their components.
> 

Thanks for sending it out for review.

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
> +EXPORT_SYMBOL_GPL(enclosure_find);

This looks a little odd.  We don't take a ref on the object after looking
it up, so what prevents some other thread of control from freeing or
otherwise altering the returned object while the caller is playing with it?

> +/**
> + * enclosure_for_each_device - calls a function for each enclosure
> + * @fn:		the function to call
> + * @data:	the data to pass to each call
> + *
> + * Loops over all the enclosures calling the function.
> + *
> + * Note, this function uses a mutex which will be held across calls to
> + * @fn, so it must have user context, and @fn should not sleep or

Probably "non atomic context" would be more accurate.

fn() actually _can_ sleep.

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
> +	if (!cb) {
> +		kfree(edev);
> +		return ERR_PTR(-EINVAL);
> +	}

It would be less fuss if this were to test cb before doing the kzalloc().

Can cb==NULL actually and legitimately happen?

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

Is this legal?

> +	mutex_lock(&container_list_lock);
> +	list_del(&edev->node);
> +	mutex_unlock(&container_list_lock);

See, right now, someone who found this enclosure_device via
enclosure_find() could still be playing with it?

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
> +/**
> + * enclosure_component_register - add a particular component to an enclosure
> + * @edev:	the enclosure to add the component
> + * @num:	the device number
> + * @type:	the type of component being added
> + * @name:	an optional name to appear in sysfs (leave NULL if none)
> + *
> + * Registers the component.  The name is optional for enclosures that
> + * give their components a unique name.  If not, leave the field NULL
> + * and a name will be assigned.
> + *
> + * Returns a pointer to the enclosure component or an error.
> + */
> +struct enclosure_component *
> +enclosure_component_register(struct enclosure_device *edev,
> +			     unsigned int number,
> +			     enum enclosure_component_type type,
> +			     const char *name)
> +{
> +	struct enclosure_component *ecomp;
> +	struct class_device *cdev;
> +	int err;
> +
> +	if (!edev || number >= edev->components)
> +		return ERR_PTR(-EINVAL);

Is !edev possible and legitimate?

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

%u :)

> +
> +	err = class_device_register(cdev);
> +	if (err)
> +		ERR_PTR(err);
> +
> +	return ecomp;
> +}
> +EXPORT_SYMBOL_GPL(enclosure_component_register);
> +
> +/**
> + * enclosure_add_device - add a device as being part of an enclosure
> + * @edev:	the enclosure device being added to.
> + * @num:	the number of the component
> + * @dev:	the device being added
> + *
> + * Declares a real device to reside in slot (or identifier) @num of an
> + * enclosure.  This will cause the relevant sysfs links to appear.
> + * This function may also be used to change a device associated with
> + * an enclosure without having to call enclosure_remove_device() in
> + * between.
> + *
> + * Returns zero on success or an error.
> + */
> +int enclosure_add_device(struct enclosure_device *edev, int component,
> +			 struct device *dev)
> +{
> +	struct class_device *cdev;
> +
> +	if (!edev || component >= edev->components)
> +		return -EINVAL;
> +
> +	cdev = &edev->component[component].cdev;
> +
> +	class_device_del(cdev);
> +	if (cdev->dev)
> +		put_device(cdev->dev);
> +	cdev->dev = get_device(dev);
> +	return class_device_add(cdev);
> +}
> +EXPORT_SYMBOL_GPL(enclosure_add_device);
> +
> +/*
> + * sysfs pieces below
> + */
> +
> +static ssize_t enclosure_show_components(struct class_device *cdev, char *buf)
> +{
> +	struct enclosure_device *edev = to_enclosure_device(cdev);
> +
> +	return snprintf(buf, 40, "%d\n", edev->components);
> +}

"40"?

> +static struct class_device_attribute enclosure_attrs[] = {
> +	__ATTR(components, S_IRUGO, enclosure_show_components, NULL),
> +	__ATTR_NULL
> +};
> +
> +static struct class enclosure_class = {
> +	.name			= "enclosure",
> +	.owner			= THIS_MODULE,
> +	.release		= enclosure_release,
> +	.class_dev_attrs	= enclosure_attrs,
> +};
> +
> +static char *enclosure_status [] = {
> +	[ENCLOSURE_STATUS_UNSUPPORTED] = "unsupported",
> +	[ENCLOSURE_STATUS_OK] = "OK",
> +	[ENCLOSURE_STATUS_CRITICAL] = "critical",
> +	[ENCLOSURE_STATUS_NON_CRITICAL] = "non-critical",
> +	[ENCLOSURE_STATUS_UNRECOVERABLE] = "unrecoverable",
> +	[ENCLOSURE_STATUS_NOT_INSTALLED] = "not installed",
> +	[ENCLOSURE_STATUS_UNKNOWN] = "unknown",
> +	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
> +};
> +
> +static char *enclosure_type [] = {
> +	[ENCLOSURE_COMPONENT_DEVICE] = "device",
> +	[ENCLOSURE_COMPONENT_ARRAY_DEVICE] = "array device",
> +};

One could play with const here, if sufficiently keen.

> +static ssize_t set_component_fault(struct class_device *cdev, const char *buf,
> +				   size_t count)
> +{
> +	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
> +	struct enclosure_component *ecomp = to_enclosure_component(cdev);
> +	int val = simple_strtoul(buf, NULL, 0);

hrm, we do this conversion about 1e99 times in the kernel and we have to go
and pass three args where only one was needed. katoi()?

> +	if (edev->cb->set_fault)
> +		edev->cb->set_fault(edev, ecomp, val);
> +	return count;
> +}
> +
> +static ssize_t get_component_status(struct class_device *cdev, char *buf)
> +{
> +	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
> +	struct enclosure_component *ecomp = to_enclosure_component(cdev);
> +
> +	if (edev->cb->get_status)
> +		edev->cb->get_status(edev, ecomp);
> +	return snprintf(buf, 40, "%s\n", enclosure_status[ecomp->status]);
> +}
> +
> +static ssize_t set_component_status(struct class_device *cdev, const char *buf,
> +				   size_t count)
> +{
> +	struct enclosure_device *edev = to_enclosure_device(cdev->parent);
> +	struct enclosure_component *ecomp = to_enclosure_component(cdev);
> +	int i;
> +
> +	for (i = 0; enclosure_status[i]; i++) {
> +		if (strncmp(buf, enclosure_status[i],
> +			    strlen(enclosure_status[i])) == 0 &&
> +		    buf[strlen(enclosure_status[i])] == '\n')
> +			break;
> +	}

So if an application does

	write(fd, "foo", 3)

it won't work?  Thye have to do

	write(fd, "foo\n", 4)

?


> +	if (enclosure_status[i] && edev->cb->set_status) {
> +		edev->cb->set_status(edev, ecomp, i);
> +		return count;
> +	} else
> +		return -EINVAL;
> +}
> +
>
> ...
>
> +#define to_enclosure_device(x) container_of((x), struct enclosure_device, cdev)
> +#define to_enclosure_component(x) container_of((x), struct enclosure_component, cdev)

These could be C functions...

> +struct enclosure_device *
> +enclosure_register(struct device *, const char *, int,
> +		   struct enclosure_component_callbacks *);
> +void enclosure_unregister(struct enclosure_device *);
> +struct enclosure_component *
> +enclosure_component_register(struct enclosure_device *, unsigned int,
> +				 enum enclosure_component_type, const char *);
> +int enclosure_add_device(struct enclosure_device *enclosure, int component,
> +			 struct device *dev);
> +int enclosure_remove_device(struct enclosure_device *enclosure, int component);
> +struct enclosure_device *enclosure_find(struct device *dev);
> +int enclosure_for_each_device(int (*fn)(struct enclosure_device *, void *),
> +			      void *data);
> +
> +#endif /* _LINUX_ENCLOSURE_H_ */

Nice looking driver.
