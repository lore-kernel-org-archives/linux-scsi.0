From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/3] ses: fix discovery of SATA devices in SAS
 enclosures
Date: Tue, 15 Dec 2015 11:17:46 +0100
Message-ID: <566FE8CA.2090800@suse.de>
References: <1449688206.2226.30.camel@HansenPartnership.com>
 <1449688495.2226.36.camel@HansenPartnership.com>
 <1449694567.2226.45.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58116 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964798AbbLOKRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 05:17:48 -0500
In-Reply-To: <1449694567.2226.45.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 12/09/2015 09:56 PM, James Bottomley wrote:
> The current discovery routines use the VPD 0x83 inquiry page to find
> the device SAS address and match it to the end point in the enclosure=
=2E
> This doesn't work for SATA devices because expanders (or hosts) simpl=
y
> make up an endpoint address for STP and thus the address returned by
> the VPD page never matches.  Instead of doing this, for SAS attached
> devices, match by the direct endpoint address instead.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com=
>
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 5f692ae..2a1d20e 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -194,6 +194,7 @@ config CHR_DEV_SCH
>   config SCSI_ENCLOSURE
>   	tristate "SCSI Enclosure Support"
>   	depends on SCSI && ENCLOSURE_SERVICES
> +	depends on m || SCSI_SAS_ATTRS !=3D m
>   	help
>   	  Enclosures are devices sitting on or in SCSI backplanes that
>   	  manage devices.  If you have a disk cage, the chances are that
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index 7d9cec5..1736935 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -34,6 +34,8 @@
>   #include <scsi/scsi_driver.h>
>   #include <scsi/scsi_host.h>
>
> +#include <scsi/scsi_transport_sas.h>
> +
>   struct ses_device {
>   	unsigned char *page1;
>   	unsigned char *page1_types;
> @@ -571,31 +573,15 @@ static void ses_enclosure_data_process(struct e=
nclosure_device *edev,
>   static void ses_match_to_enclosure(struct enclosure_device *edev,
>   				   struct scsi_device *sdev)
>   {
> -	unsigned char *desc;
>   	struct efd efd =3D {
>   		.addr =3D 0,
>   	};
>
>   	ses_enclosure_data_process(edev, to_scsi_device(edev->edev.parent)=
, 0);
>
> -	if (!sdev->vpd_pg83_len)
> -		return;
> -
> -	desc =3D sdev->vpd_pg83 + 4;
> -	while (desc < sdev->vpd_pg83 + sdev->vpd_pg83_len) {
> -		enum scsi_protocol proto =3D desc[0] >> 4;
> -		u8 code_set =3D desc[0] & 0x0f;
> -		u8 piv =3D desc[1] & 0x80;
> -		u8 assoc =3D (desc[1] & 0x30) >> 4;
> -		u8 type =3D desc[1] & 0x0f;
> -		u8 len =3D desc[3];
> -
> -		if (piv && code_set =3D=3D 1 && assoc =3D=3D 1
> -		    && proto =3D=3D SCSI_PROTOCOL_SAS && type =3D=3D 3 && len =3D=3D=
 8)
> -			efd.addr =3D get_unaligned_be64(&desc[4]);
> +	if (is_sas_attached(sdev))
> +		efd.addr =3D sas_get_address(sdev);
>
> -		desc +=3D len + 4;
> -	}
>   	if (efd.addr) {
>   		efd.dev =3D &sdev->sdev_gendev;
>
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
