From: Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH] virtio_scsi: Always try to read VPD pages
Date: Thu, 13 Apr 2017 14:39:09 +0100
Message-ID: <20170413133909.GC13387@stefanha-x1.localdomain>
References: <20170413021300.25023-1-david@gibson.dropbear.id.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ALfTUftag+2gvp1h"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753231AbdDMNjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Apr 2017 09:39:21 -0400
Content-Disposition: inline
In-Reply-To: <20170413021300.25023-1-david@gibson.dropbear.id.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: pbonzini@redhat.com, famz@redhat.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 13, 2017 at 12:13:00PM +1000, David Gibson wrote:
> @@ -705,6 +706,28 @@ static int virtscsi_device_reset(struct scsi_cmnd *s=
c)
>  	return virtscsi_tmf(vscsi, cmd);
>  }
> =20
> +static int virtscsi_device_alloc(struct scsi_device *sdevice)
> +{
> +	/*
> +	 * Passed through SCSI targets (e.g. with qemu's 'scsi-block')
> +	 * may have transfer limits which come from the host SCSI
> +	 * controller something on the host side other than the target

s/controller something/controller or something/ ?

> +	 * itself.
> +	 *
> +	 * To make this work properly, the hypervisor can adjust the
> +	 * target's VPD information to advertise these limits.  But
> +	 * for that to work, the guest has to look at the VPD pages,
> +	 * which we won't do by default if it is an SPC-2 device, even
> +	 * if it does actually support it.
> +	 *
> +	 * So, set the blist to always try to read the VPD pages.
> +	 */
> +	sdevice->sdev_bflags =3D BLIST_TRY_VPD_PAGES;
> +
> +	return 0;
> +}

Looks good to me.  Not a SCSI expert but I checked
scsi_device_supports_vpd() callers and this seems sane.

--ALfTUftag+2gvp1h
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAEBAgAGBQJY7399AAoJEJykq7OBq3PIB6QIAL6vbfJiGy3ZdOedLd2jv5Fl
NYopdCnkosSKlZbutnqI4TKX9f3zonaiBtahmfNBheh20fDRxFlRGzigarzJjP/j
KiINjFZBMi/uiNEOqOZtsVJUHhXa8M9bv+5fJIrzrevga/RLYWLFyCN9XWcCXukB
pQaMg3otRyT9nOjJWJe1Cbe6HFnvVQvUvlos39PxZ0tehfAI+sgxwPMRyRWXhg+N
/wJXJe6Y+eu0Nnw1k5+nuTU0f71iQuPsW1l4AOh+oZwowRHw4bo2Scav6o7auuxo
cHT6CXXBGx7D1A9bRQ7c5dx6qBygaX5LE1HMZGBEu8uK8FXV5GmPoA0uUAL1Tb0=
=JTpC
-----END PGP SIGNATURE-----

--ALfTUftag+2gvp1h--
