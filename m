From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 26/36] SCSI: st: convert class code to use dev_groups
Date: Tue, 30 Jul 2013 18:27:06 +0000
Message-ID: <1375208826.2065.12.camel@dabdike.int.hansenpartnership.com>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
	 <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:33150 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613Ab3G3S1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 14:27:08 -0400
In-Reply-To: <1374703539-9705-27-git-send-email-gregkh@linuxfoundation.org>
Content-Language: en-US
Content-ID: <729B32817221F54798078068CC3F9F2D@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?iso-8859-15?Q?Kai_M=E4kisara?= <Kai.Makisara@kolumbus.fi>, linux-scsi <linux-scsi@vger.kernel.org>

Adding linux-scsi to cc.

James

On Wed, 2013-07-24 at 15:05 -0700, Greg Kroah-Hartman wrote:
> The dev_attrs field of struct class is going away soon, dev_groups
> should be used instead.  This converts the scsi tape class code to us=
e
> the correct field.
>=20
> Cc: Kai M=E4kisara <Kai.Makisara@kolumbus.fi>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>=20
> James, feel free to take this through your tree, or ACK it and I can
> take it through mine.
>=20
>  drivers/scsi/st.c | 27 ++++++++++++++++-----------
>  1 file changed, 16 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 2a32036a..ff44b3c2 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -82,7 +82,7 @@ static int try_rdio =3D 1;
>  static int try_wdio =3D 1;
> =20
>  static struct class st_sysfs_class;
> -static struct device_attribute st_dev_attrs[];
> +static const struct attribute_group *st_dev_groups[];
> =20
>  MODULE_AUTHOR("Kai Makisara");
>  MODULE_DESCRIPTION("SCSI tape (st) driver");
> @@ -4274,7 +4274,7 @@ static void scsi_tape_release(struct kref *kref=
)
> =20
>  static struct class st_sysfs_class =3D {
>  	.name =3D "scsi_tape",
> -	.dev_attrs =3D st_dev_attrs,
> +	.dev_groups =3D st_dev_groups,
>  };
> =20
>  static int __init init_st(void)
> @@ -4408,6 +4408,7 @@ defined_show(struct device *dev, struct device_=
attribute *attr, char *buf)
>  	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->defined);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(defined);
> =20
>  static ssize_t
>  default_blksize_show(struct device *dev, struct device_attribute *at=
tr,
> @@ -4419,7 +4420,7 @@ default_blksize_show(struct device *dev, struct=
 device_attribute *attr,
>  	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->default_blksize);
>  	return l;
>  }
> -
> +static DEVICE_ATTR_RO(default_blksize);
> =20
>  static ssize_t
>  default_density_show(struct device *dev, struct device_attribute *at=
tr,
> @@ -4433,6 +4434,7 @@ default_density_show(struct device *dev, struct=
 device_attribute *attr,
>  	l =3D snprintf(buf, PAGE_SIZE, fmt, STm->default_density);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(default_density);
> =20
>  static ssize_t
>  default_compression_show(struct device *dev, struct device_attribute=
 *attr,
> @@ -4444,6 +4446,7 @@ default_compression_show(struct device *dev, st=
ruct device_attribute *attr,
>  	l =3D snprintf(buf, PAGE_SIZE, "%d\n", STm->default_compression - 1=
);
>  	return l;
>  }
> +static DEVICE_ATTR_RO(default_compression);
> =20
>  static ssize_t
>  options_show(struct device *dev, struct device_attribute *attr, char=
 *buf)
> @@ -4472,15 +4475,17 @@ options_show(struct device *dev, struct devic=
e_attribute *attr, char *buf)
>  	l =3D snprintf(buf, PAGE_SIZE, "0x%08x\n", options);
>  	return l;
>  }
> -
> -static struct device_attribute st_dev_attrs[] =3D {
> -	__ATTR_RO(defined),
> -	__ATTR_RO(default_blksize),
> -	__ATTR_RO(default_density),
> -	__ATTR_RO(default_compression),
> -	__ATTR_RO(options),
> -	__ATTR_NULL,
> +static DEVICE_ATTR_RO(options);
> +
> +static struct attribute *st_dev_attrs[] =3D {
> +	&dev_attr_defined.attr,
> +	&dev_attr_default_blksize.attr,
> +	&dev_attr_default_density.attr,
> +	&dev_attr_default_compression.attr,
> +	&dev_attr_options.attr,
> +	NULL,
>  };
> +ATTRIBUTE_GROUPS(st_dev);
> =20
>  /* The following functions may be useful for a larger audience. */
>  static int sgl_map_user_pages(struct st_buffer *STbp,


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
