From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.6.1-rc2 - MPT Fusion driver 3.00.00 update
Date: Wed, 07 Jan 2004 09:55:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073465748.4429.3.camel@laptop.fenrus.com>
References: <3FFB4E0F.704@lsil.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-quSn56SWUjEm/maJU92p"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:34688 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S266146AbUAGIz5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 03:55:57 -0500
In-Reply-To: <3FFB4E0F.704@lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <emoore@lsil.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 'James.Bottomley@steeleye.com'


--=-quSn56SWUjEm/maJU92p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2004-01-07 at 01:08, Eric Moore wrote:
> +/***********************************************************************=
***
> + * Power Management
> + */
> +#ifdef CONFIG_PM
> +#include <acpi/acpi_drivers.h>
> +
> +/*=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D*/
> +/*
> + *    mptbase_suspend - Fusion MPT base driver suspend routine.
> + *
> + *
> + */
> +static int mptbase_suspend(struct pci_dev *pdev, u32 state)
> +{
> +    u32 device_state;
> +    MPT_ADAPTER *ioc =3D pci_get_drvdata(pdev);
> +
> +    switch(state)
> +    {
> +        case ACPI_STATE_S1:

this looks really really wrong. Linux suspend and resume are absolutely
not acpi specific and drivers should not use ACPI specific defines that
also just may mean something different than the linux API means!
> @@ -264,12 +298,14 @@
>  mptscsih_io_direction(Scsi_Cmnd *cmd)


why can't you use the scsi layer IO direction function ???
> =20
> +#ifndef MPTSCSIH_DISABLE_DOMAIN_VALIDATION
> +        mpt_dv_deregister(MPTSCSIH_DRIVER);
> +#endif

I would suggest making mpt_dv_deregister() and co a nop in the DISABLE
case, that way you don't need ifdefs all over the driver but just around
the entire functions....


--=-quSn56SWUjEm/maJU92p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/+8mUxULwo51rQBIRAmTDAJ9aujqK9csNZZrkPpjE6pB/mgs71wCdEy8f
o/LOkGFAmdYTk8oZiFq+8mI=
=MMUO
-----END PGP SIGNATURE-----

--=-quSn56SWUjEm/maJU92p--
