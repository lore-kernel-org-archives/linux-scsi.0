From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [patch] convert the scsi layer to use struct device
Date: Sat, 15 Mar 2008 19:26:44 +0100
Message-ID: <1205605604.3109.148.camel@lov.site>
References: <20080313210655.GA13468@kroah.com>
	 <1205514958.2904.27.camel@localhost.localdomain>
	 <1205529619.2904.87.camel@localhost.localdomain>
	 <1205531922.3522.57.camel@lov.site>
	 <1205590788.6767.12.camel@localhost.localdomain>
	 <1205594256.3109.53.camel@lov.site>
	 <1205597776.6767.40.camel@localhost.localdomain>
	 <1205604100.6767.43.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.177]:64016 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYCOSZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Mar 2008 14:25:54 -0400
In-Reply-To: <1205604100.6767.43.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tony Jones <tonyj@suse.de>

On Sat, 2008-03-15 at 13:01 -0500, James Bottomley wrote:
> On Sat, 2008-03-15 at 11:16 -0500, James Bottomley wrote:
> > On Sat, 2008-03-15 at 16:17 +0100, Kay Sievers wrote:
> > > We just need to create something like a "contains" link from the
> > > component to the scsi device, and a "enclosure" link at the scsi =
device
> > > back to the component, right?
> >=20
> > Assuming you're moving to the single tree model, then I can easily =
do
> > this:
> >=20
> > <real enclosure device>/<enclosure>/<enclosure component>/device ->=
 link
> > to component device
> >=20
> > with a back link in the component device pointing to the enclosure
> > component.
> >=20
> > The way components work, probably blowing away enclosure_component_=
class
> > makes the most sense anyway.
>=20
> OK, so this is the patch doing the above; is this what you had in min=
d?
> We're now managing all the links.

Yeah, that looks fine.

While I in general don't really like the <classname>:<devname> symlinks=
=2E
One needs to readdir() the whole device directory to find them, which i=
s
not nice for a 1:1 relationship link between two devices. I would prefe=
r
to be able to find an enclosure component for a LUN by simply looking
at:
  /sys/bus/scsi/devices/0:0:0:0/enclosure/
instead of searching for that composed link, because one can't predict
its name. Can there ever be more than one link from a device to an
enclosure?

Also the "device" link, it will work to use that name, I guess, but it
has usually a different meaning, as all "device" links are just
meaninglessly pointing to the next parent device with !SYSFS_DEPRECATED=
=2E
=EF=BB=BFWith !SYSFS_DEPRECATED <classname>:<devname> links are no long=
er
created for any device, the class device directories just live in a
subdirectory with the class name.

Do you prefer the <classname>:<devname>, "device" names?

Thanks,
Kay

> diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
> index fafb57f..0736cff 100644
> --- a/drivers/misc/enclosure.c
> +++ b/drivers/misc/enclosure.c
> @@ -31,7 +31,6 @@
>  static LIST_HEAD(container_list);
>  static DEFINE_MUTEX(container_list_lock);
>  static struct class enclosure_class;
> -static struct class enclosure_component_class;
> =20
>  /**
>   * enclosure_find - find an enclosure given a device
> @@ -166,6 +165,40 @@ void enclosure_unregister(struct enclosure_devic=
e *edev)
>  }
>  EXPORT_SYMBOL_GPL(enclosure_unregister);
> =20
> +#define ENCLOSURE_NAME_SIZE	64
> +
> +static void enclosure_link_name(struct enclosure_component *cdev, ch=
ar *name)
> +{
> +	strcpy(name, "enclosure_device:");
> +	strcat(name, cdev->cdev.bus_id);
> +}
> +
> +static void enclosure_remove_links(struct enclosure_component *cdev)
> +{
> +	char name[ENCLOSURE_NAME_SIZE];
> +
> +	enclosure_link_name(cdev, name);
> +	sysfs_remove_link(&cdev->dev->kobj, name);
> +	sysfs_remove_link(&cdev->cdev.kobj, "device");
> +}
> +
> +static int enclosure_add_links(struct enclosure_component *cdev)
> +{
> +	int error;
> +	char name[ENCLOSURE_NAME_SIZE];
> +
> +	error =3D sysfs_create_link(&cdev->cdev.kobj, &cdev->dev->kobj, "de=
vice");
> +	if (error)
> +		return error;
> +
> +	enclosure_link_name(cdev, name);
> +	error =3D sysfs_create_link(&cdev->dev->kobj, &cdev->cdev.kobj, nam=
e);
> +	if (error)
> +		sysfs_remove_link(&cdev->cdev.kobj, "device");
> +
> +	return error;
> +}
> +
>  static void enclosure_release(struct device *cdev)
>  {
>  	struct enclosure_device *edev =3D to_enclosure_device(cdev);
> @@ -178,10 +211,15 @@ static void enclosure_component_release(struct =
device *dev)
>  {
>  	struct enclosure_component *cdev =3D to_enclosure_component(dev);
> =20
> -	put_device(cdev->dev);
> +	if (cdev->dev) {
> +		enclosure_remove_links(cdev);
> +		put_device(cdev->dev);
> +	}
>  	put_device(dev->parent);
>  }
> =20
> +static struct attribute_group *enclosure_groups[];
> +
>  /**
>   * enclosure_component_register - add a particular component to an e=
nclosure
>   * @edev:	the enclosure to add the component
> @@ -217,12 +255,14 @@ enclosure_component_register(struct enclosure_d=
evice *edev,
>  	ecomp->number =3D number;
>  	cdev =3D &ecomp->cdev;
>  	cdev->parent =3D get_device(&edev->edev);
> -	cdev->class =3D &enclosure_component_class;
>  	if (name)
>  		snprintf(cdev->bus_id, BUS_ID_SIZE, "%s", name);
>  	else
>  		snprintf(cdev->bus_id, BUS_ID_SIZE, "%u", number);
> =20
> +	cdev->release =3D enclosure_component_release;
> +	cdev->groups =3D enclosure_groups;
> +
>  	err =3D device_register(cdev);
>  	if (err)
>  		ERR_PTR(err);
> @@ -255,10 +295,12 @@ int enclosure_add_device(struct enclosure_devic=
e *edev, int component,
> =20
>  	cdev =3D &edev->component[component];
> =20
> -	device_del(&cdev->cdev);
> +	if (cdev->dev)
> +		enclosure_remove_links(cdev);
> +
>  	put_device(cdev->dev);
>  	cdev->dev =3D get_device(dev);
> -	return device_add(&cdev->cdev);
> +	return enclosure_add_links(cdev);
>  }
>  EXPORT_SYMBOL_GPL(enclosure_add_device);
> =20
> @@ -442,24 +484,32 @@ static ssize_t get_component_type(struct device=
 *cdev,
>  }
> =20
>=20
> -static struct device_attribute enclosure_component_attrs[] =3D {
> -	__ATTR(fault, S_IRUGO | S_IWUSR, get_component_fault,
> -	       set_component_fault),
> -	__ATTR(status, S_IRUGO | S_IWUSR, get_component_status,
> -	       set_component_status),
> -	__ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
> -	       set_component_active),
> -	__ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
> -	       set_component_locate),
> -	__ATTR(type, S_IRUGO, get_component_type, NULL),
> -	__ATTR_NULL
> +static DEVICE_ATTR(fault, S_IRUGO | S_IWUSR, get_component_fault,
> +		    set_component_fault);
> +static DEVICE_ATTR(status, S_IRUGO | S_IWUSR, get_component_status,
> +		   set_component_status);
> +static DEVICE_ATTR(active, S_IRUGO | S_IWUSR, get_component_active,
> +		   set_component_active);
> +static DEVICE_ATTR(locate, S_IRUGO | S_IWUSR, get_component_locate,
> +		   set_component_locate);
> +static DEVICE_ATTR(type, S_IRUGO, get_component_type, NULL);
> +
> +static struct attribute *enclosure_component_attrs[] =3D {
> +	&dev_attr_fault.attr,
> +	&dev_attr_status.attr,
> +	&dev_attr_active.attr,
> +	&dev_attr_locate.attr,
> +	&dev_attr_type.attr,
> +	NULL
>  };
> =20
> -static struct class enclosure_component_class =3D  {
> -	.name			=3D "enclosure_component",
> -	.owner			=3D THIS_MODULE,
> -	.dev_attrs	=3D enclosure_component_attrs,
> -	.dev_release		=3D enclosure_component_release,
> +static struct attribute_group enclosure_group =3D {
> +	.attrs =3D enclosure_component_attrs,
> +};
> +
> +static struct attribute_group *enclosure_groups[] =3D {
> +	&enclosure_group,
> +	NULL
>  };
> =20
>  static int __init enclosure_init(void)
> @@ -469,20 +519,12 @@ static int __init enclosure_init(void)
>  	err =3D class_register(&enclosure_class);
>  	if (err)
>  		return err;
> -	err =3D class_register(&enclosure_component_class);
> -	if (err)
> -		goto err_out;
> =20
>  	return 0;
> - err_out:
> -	class_unregister(&enclosure_class);
> -
> -	return err;
>  }
> =20
>  static void __exit enclosure_exit(void)
>  {
> -	class_unregister(&enclosure_component_class);
>  	class_unregister(&enclosure_class);
>  }
> =20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
