From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] libsas: Fixup transport protocol definition in sas_get_ata_info()
Date: Tue, 07 Apr 2015 10:47:50 +0200
Message-ID: <552399B6.6000302@suse.de>
References: <1428396307-87607-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150AbbDGIrw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Apr 2015 04:47:52 -0400
In-Reply-To: <1428396307-87607-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 04/07/2015 10:45 AM, Hannes Reinecke wrote:
> 'tproto' specifies the transport protocol, not the device type.
> So use the correct definitions here.
>=20
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/libsas/sas_ata.c | 2 +-
>  drivers/scsi/sd.c             | 7 +++++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index 9c706d8..83b182a 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -279,7 +279,7 @@ int sas_get_ata_info(struct domain_device *dev, s=
truct ex_phy *phy)
>  	if (phy->attached_tproto & SAS_PROTOCOL_STP)
>  		dev->tproto =3D phy->attached_tproto;
>  	if (phy->attached_sata_dev)
> -		dev->tproto |=3D SAS_SATA_DEV;
> +		dev->tproto |=3D SAS_PROTOCOL_SATA;
> =20
>  	if (phy->attached_dev_type =3D=3D SAS_SATA_PENDING)
>  		dev->dev_type =3D SAS_SATA_PENDING;
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ec512b8..19e6154 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2127,6 +2127,13 @@ static int read_capacity_16(struct scsi_disk *=
sdkp, struct scsi_device *sdp,
>  				 * give it one more chance */
>  				if (--reset_retries > 0)
>  					continue;
> +			if (sense_valid &&
> +			    sshdr.sense_key =3D=3D UNIT_ATTENTION &&
> +			    sshdr.asc =3D=3D 0x29 && sshdr.ascq =3D=3D 0x00)
> +				/* Device reset might occur several times,
> +				 * give it one more chance */
> +				if (--reset_retries > 0)
> +					continue;
>  		}
>  		retries--;
> =20
>=20
Bah. That doesn't belong here.

Will be resending.

Sorry.

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
