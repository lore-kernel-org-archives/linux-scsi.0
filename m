From: Daniel Axtens <dja@axtens.net>
Subject: Re: [PATCH 2/6] cxlflash: Fix to avoid virtual LUN failover failure
Date: Mon, 14 Dec 2015 16:00:25 +1100
Message-ID: <87h9jl7hg6.fsf@gamma.ozlabs.ibm.com>
References: <1449787867-23015-1-git-send-email-ukrishn@linux.vnet.ibm.com> <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:32981 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbLNFAk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2015 00:00:40 -0500
Received: by pfnn128 with SMTP id n128so99310128pfn.0
        for <linux-scsi@vger.kernel.org>; Sun, 13 Dec 2015 21:00:40 -0800 (PST)
In-Reply-To: <1449788029-23093-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Uma Krishnan <ukrishn@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Virtual LUNs may be accessed through one or both ports of the adapter.

Is it possible that there might ever be adapters with a number of ports
other than 2? In particular, is it possible for 3 or 4 port adapters to
exist?

If so, do you need something with a bit more fidelity?

If not, this is a good approach.

Regards,
Daniel

> This access is encoded in the translation entries that comprise the
> virtual LUN and used by the AFU for load-balancing I/O and handling
> failover scenarios. In a link loss scenario, even though the AFU is
> able to maintain connectivity to the LUN, it is up to the application
> to retry the failed I/O. When applications are unaware of the virtual
> LUN's underlying topology, they are unable to make a sound decision of
> when to retry an I/O and therefore are forced to make their reaction to
> a failed I/O absolute. The result is either a failure to retry I/O or
> increased latency for scenarios where a retry is pointless.
>
> To remedy this scenario, provide feedback back to the application on
> virtual LUN creation as to which ports the LUN may be accessed. LUN's
> spanning both ports are candidates for a retry in a presence of an I/O
> failure.
>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>  drivers/scsi/cxlflash/vlun.c       |  2 ++
>  include/uapi/scsi/cxlflash_ioctl.h | 10 ++++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/drivers/scsi/cxlflash/vlun.c b/drivers/scsi/cxlflash/vlun.c
> index a53f583..50f8e93 100644
> --- a/drivers/scsi/cxlflash/vlun.c
> +++ b/drivers/scsi/cxlflash/vlun.c
> @@ -1008,6 +1008,8 @@ int cxlflash_disk_virtual_open(struct scsi_device *=
sdev, void *arg)
>  	virt->last_lba =3D last_lba;
>  	virt->rsrc_handle =3D rsrc_handle;
>=20=20
> +	if (lli->port_sel =3D=3D BOTH_PORTS)
> +		virt->hdr.return_flags |=3D DK_CXLFLASH_ALL_PORTS_ACTIVE;
>  out:
>  	if (likely(ctxi))
>  		put_context(ctxi);
> diff --git a/include/uapi/scsi/cxlflash_ioctl.h b/include/uapi/scsi/cxlfl=
ash_ioctl.h
> index 831351b..2302f3c 100644
> --- a/include/uapi/scsi/cxlflash_ioctl.h
> +++ b/include/uapi/scsi/cxlflash_ioctl.h
> @@ -31,6 +31,16 @@ struct dk_cxlflash_hdr {
>  };
>=20=20
>  /*
> + * Return flag definitions available to all ioctls
> + *
> + * Similar to the input flags, these are grown from the bottom-up with t=
he
> + * intention that ioctl-specific return flag definitions would grow from=
 the
> + * top-down, allowing the two sets to co-exist. While not required/enfor=
ced
> + * at this time, this provides future flexibility.
> + */
> +#define DK_CXLFLASH_ALL_PORTS_ACTIVE	0x0000000000000001ULL
> +
> +/*
>   * Notes:
>   * -----
>   * The 'context_id' field of all ioctl structures contains the context
> --=20
> 2.1.0
>
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWbkzqAAoJEPC3R3P2I92FFWYQAKTRjNuDkCGuxUGEN7jhxTrK
syYnjbFhR3IQd1d+EQos/B3/pbxVUOH6yG+ksHECxDNMaH7hp0KfWhifIlYHSxlX
OK2N/4CQTpfRmEKGLGMS6VkGuJDK6w1RJeQgsKwpGuqYXazj7RcXdSAaLTC4/LOX
G1mO4QIBAhnKs5uBkEnX9pE5mJFrmceZeCtOWtHYtuoBHKeVESf/DMYZpUFST5wQ
gOiEkBL0DQV1GBhVRKdgCFVN4HVsR/oEQG0rMjMDih1wc5oXUyu4fEjMg4vqjYOa
Q68LIH1E4lUO4ARj7hQeJE+2eTr64mxYnZIw1Q2cpUiUVvVoDaCpjk5zZv8JwBNu
N1pRXjd/E5yrlyX+FDU3wVw7HWKzOH5QzE/UzCPq1p67KVVISY8sO0yWpEtj3gmw
S8MjSsieOwGh9EDW5ihw1bUpArJDU6XNlGarDcbrbM0j7SyRINWKs6S6FFuAYc2t
0Li5IW4FuoYyvZrd2O3aPq3g3Gso+hJFBrkIFtuFjQ8p5BPl3NeGvpxGGUuGRoEP
Gadhvd58vlv0wioItUZzW0HSmrP9pjWBHkluyCk99NZ8UukdxmjdLyujYd9tDSRT
rxz2x7+mc6OW2ag739X5Cw46ALg6iIYgWMVRK9Sm8/ajqm+0fyjrQrMeQNl89FhQ
5eTbElazyYepFIFuyYrO
=y1+S
-----END PGP SIGNATURE-----
--=-=-=--
