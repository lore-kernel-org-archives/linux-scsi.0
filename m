From: Johannes Thumshirn <jthumshirn@suse.com>
Subject: Re: [PATCH 01/18] scsi_dh: move 'dh_state' sysfs attribute to
 generic code
Date: Tue, 24 Nov 2015 13:14:05 +0100
Message-ID: <1448367245.2877.10.camel@suse.com>
References: <1447081703-110552-1-git-send-email-hare@suse.de>
	 <1447081703-110552-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46234 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752547AbbKXMOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Nov 2015 07:14:06 -0500
In-Reply-To: <1447081703-110552-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Jamed Bottomley <jbottomley@odin.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On Mon, 2015-11-09 at 16:08 +0100, Hannes Reinecke wrote:
> As scsi_dh.c is now always compiled in we should be moving
> the 'dh_state' attribute to the generic code.
>=20
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
> =C2=A0drivers/scsi/scsi_dh.c=C2=A0=C2=A0=C2=A0=C2=A0| 68 +-----------=
-----------------------
> ------------
> =C2=A0drivers/scsi/scsi_sysfs.c | 58
> ++++++++++++++++++++++++++++++++++++++++
> =C2=A02 files changed, 59 insertions(+), 67 deletions(-)
>=20
> diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
> index 0a2168e..57ad0f3 100644
> --- a/drivers/scsi/scsi_dh.c
> +++ b/drivers/scsi/scsi_dh.c
> @@ -153,76 +153,11 @@ static void scsi_dh_handler_detach(struct
> scsi_device *sdev)
> =C2=A0	module_put(sdev->handler->module);
> =C2=A0}
> =C2=A0
> -/*
> - * Functions for sysfs attribute 'dh_state'
> - */
> -static ssize_t
> -store_dh_state(struct device *dev, struct device_attribute *attr,
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0const char *buf, size_t c=
ount)
> -{
> -	struct scsi_device *sdev =3D to_scsi_device(dev);
> -	struct scsi_device_handler *scsi_dh;
> -	int err =3D -EINVAL;
> -
> -	if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
> -	=C2=A0=C2=A0=C2=A0=C2=A0sdev->sdev_state =3D=3D SDEV_DEL)
> -		return -ENODEV;
> -
> -	if (!sdev->handler) {
> -		/*
> -		=C2=A0* Attach to a device handler
> -		=C2=A0*/
> -		scsi_dh =3D scsi_dh_lookup(buf);
> -		if (!scsi_dh)
> -			return err;
> -		err =3D scsi_dh_handler_attach(sdev, scsi_dh);
> -	} else {
> -		if (!strncmp(buf, "detach", 6)) {
> -			/*
> -			=C2=A0* Detach from a device handler
> -			=C2=A0*/
> -			sdev_printk(KERN_WARNING, sdev,
> -				=C2=A0=C2=A0=C2=A0=C2=A0"can't detach handler %s.\n",
> -				=C2=A0=C2=A0=C2=A0=C2=A0sdev->handler->name);
> -			err =3D -EINVAL;
> -		} else if (!strncmp(buf, "activate", 8)) {
> -			/*
> -			=C2=A0* Activate a device handler
> -			=C2=A0*/
> -			if (sdev->handler->activate)
> -				err =3D sdev->handler->activate(sdev,
> NULL, NULL);
> -			else
> -				err =3D 0;
> -		}
> -	}
> -
> -	return err<0?err:count;
> -}
> -
> -static ssize_t
> -show_dh_state(struct device *dev, struct device_attribute *attr,
> char *buf)
> -{
> -	struct scsi_device *sdev =3D to_scsi_device(dev);
> -
> -	if (!sdev->handler)
> -		return snprintf(buf, 20, "detached\n");
> -
> -	return snprintf(buf, 20, "%s\n", sdev->handler->name);
> -}
> -
> -static struct device_attribute scsi_dh_state_attr =3D
> -	__ATTR(dh_state, S_IRUGO | S_IWUSR, show_dh_state,
> -	=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0store_dh_state);
> -
> =C2=A0int scsi_dh_add_device(struct scsi_device *sdev)
> =C2=A0{
> =C2=A0	struct scsi_device_handler *devinfo =3D NULL;
> =C2=A0	const char *drv;
> -	int err;
> -
> -	err =3D device_create_file(&sdev->sdev_gendev,
> &scsi_dh_state_attr);
> -	if (err)
> -		return err;
> +	int err =3D 0;
> =C2=A0
> =C2=A0	drv =3D scsi_dh_find_driver(sdev);
> =C2=A0	if (drv)
> @@ -236,7 +171,6 @@ void scsi_dh_remove_device(struct scsi_device
> *sdev)
> =C2=A0{
> =C2=A0	if (sdev->handler)
> =C2=A0		scsi_dh_handler_detach(sdev);
> -	device_remove_file(&sdev->sdev_gendev, &scsi_dh_state_attr);
> =C2=A0}
> =C2=A0
> =C2=A0/*
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index f021423..13a5ede 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -17,6 +17,7 @@
> =C2=A0#include <scsi/scsi_device.h>
> =C2=A0#include <scsi/scsi_host.h>
> =C2=A0#include <scsi/scsi_tcq.h>
> +#include <scsi/scsi_dh.h>
> =C2=A0#include <scsi/scsi_transport.h>
> =C2=A0#include <scsi/scsi_driver.h>
> =C2=A0
> @@ -902,6 +903,60 @@ sdev_show_function(queue_depth, "%d\n");
> =C2=A0static DEVICE_ATTR(queue_depth, S_IRUGO | S_IWUSR,
> sdev_show_queue_depth,
> =C2=A0		=C2=A0=C2=A0=C2=A0sdev_store_queue_depth);
> =C2=A0
> +#ifdef CONFIG_SCSI_DH
> +static ssize_t
> +sdev_show_dh_state(struct device *dev, struct device_attribute
> *attr,
> +		=C2=A0=C2=A0=C2=A0char *buf)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +
> +	if (!sdev->handler)
> +		return snprintf(buf, 20, "detached\n");
> +
> +	return snprintf(buf, 20, "%s\n", sdev->handler->name);
> +}
> +
> +static ssize_t
> +sdev_store_dh_state(struct device *dev, struct device_attribute
> *attr,
> +		=C2=A0=C2=A0=C2=A0=C2=A0const char *buf, size_t count)
> +{
> +	struct scsi_device *sdev =3D to_scsi_device(dev);
> +	int err =3D -EINVAL;
> +
> +	if (sdev->sdev_state =3D=3D SDEV_CANCEL ||
> +	=C2=A0=C2=A0=C2=A0=C2=A0sdev->sdev_state =3D=3D SDEV_DEL)
> +		return -ENODEV;
> +
> +	if (!sdev->handler) {
> +		/*
> +		=C2=A0* Attach to a device handler
> +		=C2=A0*/
> +		err =3D scsi_dh_attach(sdev->request_queue, buf);
> +	} else if (!strncmp(buf, "activate", 8)) {
> +		/*
> +		=C2=A0* Activate a device handler
> +		=C2=A0*/
> +		if (sdev->handler->activate)
> +			err =3D sdev->handler->activate(sdev, NULL,
> NULL);
> +		else
> +			err =3D 0;
> +	} else if (!strncmp(buf, "detach", 6)) {
> +		/*
> +		=C2=A0* Detach from a device handler
> +		=C2=A0*/
> +		sdev_printk(KERN_WARNING, sdev,
> +			=C2=A0=C2=A0=C2=A0=C2=A0"can't detach handler %s.\n",
> +			=C2=A0=C2=A0=C2=A0=C2=A0sdev->handler->name);
> +		err =3D -EINVAL;
> +	}
> +
> +	return err < 0 ? err : count;
> +}
> +
> +static DEVICE_ATTR(dh_state, S_IRUGO | S_IWUSR, sdev_show_dh_state,
> +		=C2=A0=C2=A0=C2=A0sdev_store_dh_state);
> +#endif
> +
> =C2=A0static ssize_t
> =C2=A0sdev_show_queue_ramp_up_period(struct device *dev,
> =C2=A0			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct device_attr=
ibute *attr,
> @@ -971,6 +1026,9 @@ static struct attribute *scsi_sdev_attrs[] =3D {
> =C2=A0	&dev_attr_modalias.attr,
> =C2=A0	&dev_attr_queue_depth.attr,
> =C2=A0	&dev_attr_queue_type.attr,
> +#ifdef CONFIG_SCSI_DH
> +	&dev_attr_dh_state.attr,
> +#endif
> =C2=A0	&dev_attr_queue_ramp_up_period.attr,
> =C2=A0	REF_EVT(media_change),
> =C2=A0	REF_EVT(inquiry_change_reported),

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
