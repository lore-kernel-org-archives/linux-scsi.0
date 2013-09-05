From: Hannes Reinecke <hare@suse.de>
Subject: Re: fix swapped arguments in aic7xxx:ahc_find_pci_device
Date: Thu, 05 Sep 2013 15:39:05 +0200
Message-ID: <52288979.5050205@suse.de>
References: <20130905023309.GA10315@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43516 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3IENjG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Sep 2013 09:39:06 -0400
In-Reply-To: <20130905023309.GA10315@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 09/05/2013 04:33 AM, Dave Jones wrote:
> The prototype for ahc_9005_subdevinfo_valid shows that the caller has=
 the
> arguments in the wrong order.
>=20
>  637 ahc_9005_subdevinfo_valid(uint16_t device, uint16_t vendor,
>  638                           uint16_t subdevice, uint16_t subvendor=
)
>=20
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
Acked-by: Hannes Reinecke <hare@suse.de>

>=20
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_pci.c b/drivers/scsi/aic7xx=
x/aic7xxx_pci.c
> index 6917b4f..22d5a94 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_pci.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_pci.c
> @@ -692,7 +692,7 @@ ahc_find_pci_device(ahc_dev_softc_t pci)
>  	 * ID as valid.
>  	 */
>  	if (ahc_get_pci_function(pci) > 0
> -	 && ahc_9005_subdevinfo_valid(vendor, device, subvendor, subdevice)
> +	 && ahc_9005_subdevinfo_valid(device, vendor, subdevice, subvendor)
>  	 && SUBID_9005_MFUNCENB(subdevice) =3D=3D 0)
>  		return (NULL);
> =20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

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
