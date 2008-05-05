From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/2] gdth: fix Error: Driver 'gdth' is already registered, aborting...
Date: Mon, 5 May 2008 11:24:06 +0200
Message-ID: <200805051124.11940.eike-kernel@sf-tec.de>
References: <1209958558.16283.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart43217228.GKoQBO04gc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:34787 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYEEJYb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 May 2008 05:24:31 -0400
In-Reply-To: <1209958558.16283.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--nextPart43217228.GKoQBO04gc
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

James Bottomley wrote:
> This message appears on modprobe/rmmod/modprobe of the driver.  It's
> caused because if the driver has no instances, it returns an error
> from gdth_init, which causes the module to fail to load.
> Unfortunately, the module's pci driver is still registered at this
> point.
>
> Fix this by making gdth behave like a modern driver and insert even if
> it doesn't find any instances (in case of hot plug or software driven
> binding).
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>  drivers/scsi/gdth.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 16785a2..46771d4 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -550,7 +550,6 @@ static int __init gdth_search_isa(ulong32 bios_adr)
>  #endif /* CONFIG_ISA */
>
>  #ifdef CONFIG_PCI
> -static bool gdth_pci_registered;
>
>  static bool gdth_search_vortex(ushort device)
>  {
> @@ -5157,8 +5156,13 @@ static int __init gdth_init(void)
>
>  #ifdef CONFIG_PCI
>  	/* scanning for PCI controllers */
> -	if (pci_register_driver(&gdth_pci_driver) =3D=3D 0)
> -		gdth_pci_registered =3D true;
> +	if (pci_register_driver(&gdth_pci_driver)) {
> +		gdth_ha_str *ha;
> +
> +		list_for_each_entry(ha, &gdth_instances, list)
> +			gdth_remove_one(ha);
> +		return -ENODEV;
> +	}
>  #endif /* CONFIG_PCI */
>
>  	TRACE2(("gdth_detect() %d controller detected\n", gdth_ctr_count));

Wouldn't it be better to return the error code that pci_register_driver() s=
ent=20
back?

Eike

--nextPart43217228.GKoQBO04gc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBIHtI7XKSJPmm5/E4RAkjgAJ4rbCX9PZRZ42hQXy8z33vLTDFRpgCbBbL0
HMKoT97LsuXYEmCSg8x70jU=
=8qGH
-----END PGP SIGNATURE-----

--nextPart43217228.GKoQBO04gc--
