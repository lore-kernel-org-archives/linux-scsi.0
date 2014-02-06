From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH][RFC] Add EVPD page 0x83 entries to sysfs
Date: Thu, 06 Feb 2014 14:12:18 +0100
Message-ID: <52F38A32.8050003@suse.de>
References: <1391691878-61265-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41754 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbaBFNMT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Feb 2014 08:12:19 -0500
In-Reply-To: <1391691878-61265-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Kay Sievers <kay@vrfy.org>, Hannes Reinecke <hare@suse.de>, Jeremy Linton <jlinton@tributary.com>, Doug Gilbert <dgilbert@interlog.com>, Kai Makisara <kai.makisara@kolumbus.fi>

On 02/06/2014 02:04 PM, Hannes Reinecke wrote:
> EVPD page 0x83 is used to uniquely identify the device.
> So instead of having each and every program issue a separate
> SG_IO call to retrieve this information it does make far more
> sense to display it in sysfs.
>=20
> Cc: Jeremy Linton <jlinton@tributary.com>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Kai Makisara <kai.makisara@kolumbus.fi>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/scsi_scan.c   |   3 +
>  drivers/scsi/scsi_sysfs.c  | 166 +++++++++++++++++++++++++++++++++++=
+++++++++-
>  include/scsi/scsi_device.h |   3 +
>  3 files changed, 171 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 307a811..073fb84 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -929,6 +929,9 @@ static int scsi_add_lun(struct scsi_device *sdev,=
 unsigned char *inq_result,
>  	if (*bflags & BLIST_SKIP_VPD_PAGES)
>  		sdev->skip_vpd_pages =3D 1;
> =20
> +	if (sdev->scsi_level >=3D SCSI_3)
> +		scsi_attach_vpd_ident(sdev);
> +
>  	transport_configure_device(&sdev->sdev_gendev);
> =20
>  	if (sdev->host->hostt->slave_configure) {
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 9117d0b..ffe7cb5 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -725,8 +725,170 @@ show_queue_type_field(struct device *dev, struc=
t device_attribute *attr,
> =20
>  static DEVICE_ATTR(queue_type, S_IRUGO, show_queue_type_field, NULL)=
;
> =20
> +void scsi_attach_vpd_ident(struct scsi_device *sdev)
> +{
> +	int ret;
> +	int vpd_len =3D 255;
> +	unsigned char *buffer;
> +retry:
> +	buffer =3D kmalloc(vpd_len, GFP_KERNEL);
> +	if (buffer) {
> +		ret =3D scsi_get_vpd_page(sdev, 0x83, buffer, vpd_len);
> +		if (ret =3D=3D 0) {
> +			vpd_len =3D (buffer[2] << 8) + buffer[3];
> +			if (vpd_len > 255) {
> +				kfree(buffer);
> +				goto retry;
> +			}
> +			sdev->vpd_ident_len =3D vpd_len;
> +			sdev->vpd_ident =3D buffer;
> +		}
> +	}
> +}
> +
Bummer. A missing kfree() if scsi_get_vpd_page() returns an error.
But this is just an RFC for now, so I'll be fixing it up once
it looks as if it would be moving forward...

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
