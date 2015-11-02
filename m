From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/8] pm80xx: add support for ATTO devices during SAS
 address initiailization
Date: Mon, 2 Nov 2015 08:53:37 +0100
Message-ID: <56371681.4020102@suse.de>
References: <1446216811-2248-1-git-send-email-brood@attotech.com>
 <1446216811-2248-5-git-send-email-brood@attotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54762 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbKBHxk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Nov 2015 02:53:40 -0500
In-Reply-To: <1446216811-2248-5-git-send-email-brood@attotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Rood <benjaminjrood@gmail.com>, linux-scsi@vger.kernel.org, xjtuwjp@gmail.com, James.Bottomley@HansenPartnership.com
Cc: Benjamin Rood <brood@attotech.com>

On 10/30/2015 03:53 PM, Benjamin Rood wrote:
> ATTO SAS controllers retrieve the SAS address from the NVRAM in a loc=
ation
> different from non-ATTO PMC Sierra SAS controllers.  This patch makes=
 the
> necessary adjustments in order to retrieve the SAS address on these t=
ypes
> of adapters.
>=20
> Signed-off-by: Benjamin Rood <brood@attotech.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/=
pm8001_init.c
> index feaf504..fdbfab6 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -636,6 +636,11 @@ static void pm8001_init_sas_add(struct pm8001_hb=
a_info *pm8001_ha)
>  			payload.minor_function =3D 0;
>  			payload.length =3D 128;
>  		}
> +	} else if ((pm8001_ha->chip_id =3D=3D chip_8070 ||
> +			pm8001_ha->chip_id =3D=3D chip_8072) &&
> +		pm8001_ha->pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_ATTO) {
> +		payload.minor_function =3D 4;
> +		payload.length =3D 4096;
>  	} else {
>  		payload.minor_function =3D 1;
>  		payload.length =3D 4096;
> @@ -662,6 +667,11 @@ static void pm8001_init_sas_add(struct pm8001_hb=
a_info *pm8001_ha)
>  			else if (deviceid =3D=3D 0x0042)
>  				pm8001_ha->sas_addr[j] =3D
>  					payload.func_specific[0x010 + i];
> +		} else if ((pm8001_ha->chip_id =3D=3D chip_8070 ||
> +				pm8001_ha->chip_id =3D=3D chip_8072) &&
> +		pm8001_ha->pdev->subsystem_vendor =3D=3D PCI_VENDOR_ID_ATTO) {
> +			pm8001_ha->sas_addr[j] =3D
> +					payload.func_specific[0x010 + i];
>  		} else
>  			pm8001_ha->sas_addr[j] =3D
>  					payload.func_specific[0x804 + i];
>=20
The indentation is a bit skewed here.
Other than that:

Reviewed-by: Hannes Reinecke <hare@suse.de>

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
