From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Thu, 03 Dec 2015 12:59:06 -0800
Message-ID: <1449176346.2187.19.camel@HansenPartnership.com>
References: <20151201202053.GA4753@glen>
	 <1449097101.2203.67.camel@HansenPartnership.com>
	 <20151203203656.GA9278@glen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-4rPUIPvWmoL8SvmMy93B"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151203203656.GA9278@glen>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrea Gelmini <andrea.gelmini@gelma.net>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


--=-4rPUIPvWmoL8SvmMy93B
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2015-12-03 at 21:36 +0100, Andrea Gelmini wrote:
> On Wed, Dec 02, 2015 at 02:58:21PM -0800, James Bottomley wrote:
> > On Tue, 2015-12-01 at 21:20 +0100, Andrea Gelmini wrote:
> > OK, this looks like some type of problem with a USB enclosure.  It's
> > probably misreporting something in the mode pages.  can you run sg_ses
> > on whatever /dev/sg<n> the enclosure turns up as?
>=20
>=20
> root@glen:/tmp/report# cat sg_ses_usb_hd.txt=20
>   WD        My Passport 0820  1007
>     disk device (not an enclosure)
> Supported diagnostic pages:
>   Supported Diagnostic Pages [sdp] [0x0]
>   Short Enclosure Status (SES) [ses] [0x8]
>   <unknown> [0x80]
>   <unknown> [0x83]
>   <unknown> [0x84]
>   <unknown> [0x85]

Actually, I'm afraid that's the wrong device; it's the disk not the
enclosure (that's why sg_ses says not an enclosure)

If you do

sg_map -i

in your system, you should see something with an inquiry string like
enclosure.  It's the /dev/sg<n> of that you need to run sg_ses on.

Thanks,

James


--=-4rPUIPvWmoL8SvmMy93B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAABCAAGBQJWYK0aAAoJEDeqqVYsXL0MDC0H+wXavxv5OOB6MNK7HSbP9QBk
dkA6M6ar8GYdpQNg08qkujRSWuA1FC5I4WNxlHpnMLoEPGx+jHTxv6idvi8ypDs9
wrn6a32x2L9IOPblsXFCQd/PblccxLbyto6+ZSrQSqOVSFoMHcEvZRuDXYpISqKw
Bt+g7isHEILNvlIi06MewG6urMr3QcVXl+5s27IGMTIOhdvlOiOSAant2ProRi2n
SMB/3Ikg5L0qxaDOg40D1sXyCRN9heiX/g4nCHoEpk+NRNUMwGmqEuSPvcrVVZO3
PbOcBV+mGTKAfv1uUmiztuH1hzEo1cij88QF9FkHAyW992Y9cgwN/2NkTkG1nVk=
=2ytV
-----END PGP SIGNATURE-----

--=-4rPUIPvWmoL8SvmMy93B--
