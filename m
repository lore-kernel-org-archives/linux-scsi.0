From: Hannes Reinecke <hare@suse.de>
Subject: Re: Kernel crash with unsupported DIF protection type
Date: Fri, 21 Sep 2012 08:03:55 +0200
Message-ID: <505C034B.305@suse.de>
References: <50583924.90708@suse.de> <yq14nmslbck.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616Ab2IUGD5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Sep 2012 02:03:57 -0400
In-Reply-To: <yq14nmslbck.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>

On 09/20/2012 09:53 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" =3D=3D Hannes Reinecke <hare@suse.de> writes:
>=20
> Hannes> I recently got my hands on some weird drives, insisting on
> Hannes> having been formatted with protection type 7:
>=20
> Lovely :|
>=20
Hehe. Probably _really_ future drives :-)

>=20
> Hannes> I've attached a tentative patch, which allows the system to
> Hannes> boot.  However, I'm not completely happy with that, as the
> Hannes> capacity is _still_ updated after revalidation:
>=20
> How about this?
>=20
>=20
> sd: Ensure we correctly disable devices with unknown protection type
>=20
> We set the capacity to zero when we discovered a device formatted wit=
h
> an unknown DIF protection type. However, the read_capacity code would
> override the capacity and cause the device to be enabled regardless.
>=20
> Make sd_read_protection_type() return an error if the protection type=
 is
> unknown. Also prevent duplicate printk lines when the device is being
> revalidated.
>=20
> Reported-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
>=20
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 1cf2d5d..1c54564 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1820,34 +1820,42 @@ sd_spinup_disk(struct scsi_disk *sdkp)
>  /*
>   * Determine whether disk supports Data Integrity Field.
>   */
> -static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned=
 char *buffer)
> +static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned =
char *buffer)
>  {
>  	struct scsi_device *sdp =3D sdkp->device;
>  	u8 type;
> +	int ret =3D 0;
> =20
>  	if (scsi_device_protection(sdp) =3D=3D 0 || (buffer[12] & 1) =3D=3D=
 0)
> -		return;
> +		return ret;
> =20
>  	type =3D ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 =3D Type 1 */
> =20
> -	if (type =3D=3D sdkp->protection_type || !sdkp->first_scan)
> -		return;
> +	if (type > SD_DIF_TYPE3_PROTECTION)
> +		ret =3D -ENODEV;
> +	else if (scsi_host_dif_capable(sdp->host, type))
> +		ret =3D 1;
> +
> +	if (sdkp->first_scan || type !=3D sdkp->protection_type)
> +		switch (ret) {
> +		case -ENODEV:
> +			sd_printk(KERN_ERR, sdkp, "formatted with unsupported" \
> +				  " protection type %u. Disabling disk!\n",
> +				  type);
> +			break;
> +		case 1:
> +			sd_printk(KERN_NOTICE, sdkp,
> +				  "Enabling DIF Type %u protection\n", type);
> +			break;
> +		case 0:
> +			sd_printk(KERN_NOTICE, sdkp,
> +				  "Disabling DIF Type %u protection\n", type);
> +			break;
> +		}
> =20
>  	sdkp->protection_type =3D type;
> =20
> -	if (type > SD_DIF_TYPE3_PROTECTION) {
> -		sd_printk(KERN_ERR, sdkp, "formatted with unsupported "	\
> -			  "protection type %u. Disabling disk!\n", type);
> -		sdkp->capacity =3D 0;
> -		return;
> -	}
> -
> -	if (scsi_host_dif_capable(sdp->host, type))
> -		sd_printk(KERN_NOTICE, sdkp,
> -			  "Enabling DIF Type %u protection\n", type);
> -	else
> -		sd_printk(KERN_NOTICE, sdkp,
> -			  "Disabling DIF Type %u protection\n", type);
> +	return ret;
>  }
> =20
>  static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_=
device *sdp,
> @@ -1943,7 +1951,10 @@ static int read_capacity_16(struct scsi_disk *=
sdkp, struct scsi_device *sdp,
>  	sector_size =3D get_unaligned_be32(&buffer[8]);
>  	lba =3D get_unaligned_be64(&buffer[0]);
> =20
> -	sd_read_protection_type(sdkp, buffer);
> +	if (sd_read_protection_type(sdkp, buffer) < 0) {
> +		sdkp->capacity =3D 0;
> +		return -ENODEV;
> +	}
> =20
>  	if ((sizeof(sdkp->capacity) =3D=3D 4) && (lba >=3D 0xffffffffULL)) =
{
>  		sd_printk(KERN_ERR, sdkp, "Too big for this kernel. Use a "
>=20
Yup. That's what I had in mind.

Acked-by: Hannes Reinecke <hare@suse.de>

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
