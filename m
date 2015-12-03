From: Andrea Gelmini <andrea.gelmini@gelma.net>
Subject: Re: BUG: KASAN: slab-out-of-bounds in
 ses_enclosure_data_process+0x900/0xe50
Date: Thu, 3 Dec 2015 23:20:04 +0100
Message-ID: <20151203222004.GA22311@glen>
References: <20151201202053.GA4753@glen>
 <1449097101.2203.67.camel@HansenPartnership.com>
 <20151203203656.GA9278@glen>
 <1449176346.2187.19.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449176346.2187.19.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dgilbert@interlog.com
List-Id: linux-scsi@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 03, 2015 at 12:59:06PM -0800, James Bottomley wrote:
> sg_map -i
>=20
> in your system, you should see something with an inquiry string like
> enclosure.  It's the /dev/sg<n> of that you need to run sg_ses on.

root@glen:/home/gelma# sg_map -i
/dev/sg0  /dev/sda  ATA       Samsung SSD 850   1B6Q
/dev/sg1  /dev/sr0  HL-DT-ST  DVDRAM GU40N      QX23
/dev/sg2  /dev/sdb  WD        My Passport 0820  1007
/dev/sg3  WD        SES Device        1007

And following Douglas' instructions:

root@glen:/home/gelma# lsscsi -gs
[0:0:0:0]    disk    ATA      Samsung SSD 850  1B6Q  /dev/sda   /dev/sg0   =
1.02TB
[1:0:0:0]    cd/dvd  HL-DT-ST DVDRAM GU40N     QX23  /dev/sr0   /dev/sg1   =
     -
[8:0:0:0]    disk    WD       My Passport 0820 1007  /dev/sdb   /dev/sg2   =
2.00TB
[8:0:0:1]    enclosu WD       SES Device       1007  -          /dev/sg3   =
   =20

root@glen:/home/gelma# sg_ses /dev/sg3
  WD        SES Device        1007
Supported diagnostic pages:
  Supported Diagnostic Pages [sdp] [0x0]
  Short Enclosure Status (SES) [ses] [0x8]
  <unknown> [0x80]
  <unknown> [0x83]
  <unknown> [0x84]
  <unknown> [0x85]


Well, if it's better for you, I can give you root access to a machine with =
this device
connected to.

Thanks a lot for your time,
Andrea

--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQJ8BAEBCgBmBQJWYMAUXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25zLm9w
ZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXRFQTQyRTkzNjBCNzVERDZFODMyNTQ3RjdB
NDMwOTA3NUYwNTk2MEY2AAoJEKQwkHXwWWD2+KQP/jMHBp2xdcYSr+CbHlLPERLC
7IOkYIFi8/S8SLAD2nwHQ1Mc/MWnZLLSLlDfEEQofND99OcdYHuUgdEl/1EpPAqO
jU9jw6pMHQAvqcS2mtJuWWNyr2fIRgnyArKTkH6rXP78ui016ZInzTVCx2lc4s1L
ttUjaTuN/i4d2OrnQozLIlGHLGpXrSRrfAFXIjOLIwK1yQHfnA42uay30WoGajdo
qHIyW5lxJL2AI8BIfEC9Z0YJckCaqWyn7rAuDWqh3ElAR5cbX3YVoF9r46hPU5QX
GIUReJlnoBcI+Mxui6zj0yT0PfLfuL4XVtNcnx/gfmuYyER2dNp2u30vpgdCd1qM
CY8mVW/GgguTq0bOK0LC/IPESdqvu8hIjaoGgMO/0zOIna2SEEMwbVU6jtntKApJ
Tb7R8KcoBQzDp+WoCOXGV5Su9Ew9530RHBgLtLweASYJFq7u+iNv73rjPQzHX0ah
2SAsNjiVQ8AQNGj04/DVoaEsHPkglAESJCUUQaDDmhDa2o/LVjkLgaOIDifvHK7J
qeP1oxSxFPfkx5cCJ1mNNBnSxGIMPgyWSsOd9Hc6MbbloolGJblcwN5ZT0RCj98H
Dh3Hx6ml6kDvYZDglSRfI1BXFsJpSbKVnwlzz9oDdgErQQB1WWtLgsNgxL1Vpp3h
22Iq0/q5D36IjXGxp5Lq
=efcr
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
