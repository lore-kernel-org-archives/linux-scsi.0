From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [SCSI] compat_ioct: fix bsg SG_IO
Date: Wed, 2 Nov 2011 12:24:14 +0300
Message-ID: <20111102092414.GE4751@mwanda>
References: <20111102081642.GD4751@mwanda>
 <1320224338.15504.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FEz7ebHBGB6b2e8X"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:42959 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1KBJYG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 05:24:06 -0400
Content-Disposition: inline
In-Reply-To: <1320224338.15504.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Giridhar Malavali <giridhar.malavali@qlogic.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


--FEz7ebHBGB6b2e8X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2011 at 12:58:58PM +0400, James Bottomley wrote:
> On Wed, 2011-11-02 at 11:16 +0300, Dan Carpenter wrote:
> > 84eb8fb42c120 "[SCSI] compat_ioct: fix bsg SG_IO" introduces an
> > uninitialized variable use.
> >=20
> >    278  static int sg_ioctl_trans(unsigned int fd, unsigned int cmd,
> >    279                          sg_io_hdr32_t __user *sgio32)
> >    280  {
> >    281          sg_io_hdr_t __user *sgio;
> >    282          u16 iovec_count;
> >    283          u32 data;
> >    284          void __user *dxferp;
> >    285          int err;
> >    286          int interface_id;
> >    287 =20
> >    288          if (get_user(interface_id, &sgio32->interface_id))
> >                                             ^^^^^^
> > sgio32 is unitialized here.  Unfortunately Gcc doesn't warn about it.
>=20
> I don't quite understand what makes you think that: it's passed in as an
> argument to the function.  It's a pointer to the userspace 32 bit
> representation of the structure.  The use logic is a slightly convoluted
> way of saying we only understand the 'S' header but we're going to let
> the real ioctl routine say what the error is if it's not type 'S'.

Uh...  This is embarrassing.  I got confused between sgio and sgio32.

Sorry for this.

regards,
dan carpenter

--FEz7ebHBGB6b2e8X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsQw9AAoJEOnZkXI/YHqR/7sP/11/bnQyPqmcMjiY9cyDzRW8
EpjCsgPuc7sJTxJeq8Z9AA/XNuFsrfxGMWjmMLQRIYg7ixIBqY1z8S2mNzyVPA5h
8MdxFOFTfAOsZ8i4wSrorEXUrioJ3cd7ioi53kldH3oIS3szNPbfR1CoQVi2+3S1
d/sJ9cPVCFYZcTZsbaaNcqPDqiPBvL/087rM6DH7yDpXyToTZiOwpj3MHRxWOiGL
RBAS2Wi2uiiyGmFU2DW5USu5Of/N6pSEBrwmCMw8jcGYHegIFzhS1bK/R778JxDe
IlqQV9hzpsnaWE+pKjQCWHF7MaMjx80f5vwXUR5MD15WXbfsANc3Kzat+hXTN1s/
15PeS9zV3/RFsVgDtDCAlDHRfTVpZapTsf/VTQW4xTlzykJvX0/JyxTv0dQSsRio
gAQx6RltfVKzEiJaPCLEqky8vS82X+Sj9S5LsPPsjTZ7B02BR9C4/H6fDLQzygU0
CSeGgcTSoP8Oj810Yl8WQojUOR6G8zI//ZLVaZNDtGh8Cs8e4wL9T5DVhMw0ulmi
0mK7NxE/UdKv7ql3Q2JQIAw1Ng2utkB3rBxovF4npjWYVywn+dgKoRqgP17Oqne1
lcjjtpreymE/+fCEfSBsy8i1qtQfnEtusaS3FaqgJ9wZWjGgEz5aHIc6F+WabxF1
k5zuzjT8FDiLO42CLuvF
=dAwp
-----END PGP SIGNATURE-----

--FEz7ebHBGB6b2e8X--
