From: NeilBrown <neilb@suse.de>
Subject: Re: raid1d crash at boot
Date: Mon, 21 Nov 2011 19:27:45 +1100
Message-ID: <20111121192745.2c9ac9c0@notabene.brown>
References: <20111119134139.GA30570@rere.qmqm.pl>
	<20111121123729.47c72c3b@notabene.brown>
	<1321859070.3654.7.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/4p.xI2ptl=K..UwKBhAsPQ8"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1321859070.3654.7.camel@dabdike>
Sender: linux-raid-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Sig_/4p.xI2ptl=K..UwKBhAsPQ8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 08:04:30 +0100 James Bottomley
<James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2011-11-21 at 12:37 +1100, NeilBrown wrote:
> > Thank for the report.
> > However as this crash is clearly in the SCSI layer it makes sense to re=
ported
> > it to linux-scsi - so I have cc:ed this reply there.
> >=20
> > NeilBrown
> >=20
> >=20
> > On Sat, 19 Nov 2011 14:41:39 +0100 Micha=C5=82 Miros=C5=82aw <mirq-linu=
x@rere.qmqm.pl>
> > wrote:
> >=20
> > > I get following BUG_ON tripped while booting, before rootfs is mounte=
d by
> > > Debian's initrd. This started to happen for kernels since sometime
> > > during 3.1-rcX.
> > >=20
> > > [    6.246170] ------------[ cut here ]------------
> > > [    6.246246] kernel BUG at /mnt/src-tmp/jaja/git/qmqm/drivers/scsi/=
scsi_lib.c:1153!
>=20
> I can tell you what it is:
>=20
>         /*
>          * Filesystem requests must transfer data.
>          */
>         BUG_ON(!req->nr_phys_segments);
>=20
> But the fault is in the layer above SCSI.  It means something sent a
> request with REQ_TYPE_FS but no actual data attached ... this is
> supposed to be impossible, hence the bug on.
>=20
> James
>=20

Thanks.... that sounds strangely familiar, but I cannot be sure and google
doesn't help.

Micha=C5=82: what are you using on the RAID1 - some filesystem (which one)o=
r swap or something else?

NeilBrown

--Sig_/4p.xI2ptl=K..UwKBhAsPQ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsoLhznsnt1WYoG5AQLvQw//aTZbZAz95nqtj55SKROPV2y3bcL2oaew
NFv+dYcKXbBW59J9Ram3preopfvV2IcRJAXYrZiLp9p5GhXTjxpLCVORnJpl+OrE
oYzlzXDJvQXm/4zpXOx8jN5xTd8nzCpDaix9z0BiSEjjwOmAOgdNliYIXWklfG3q
AEAxFq2RUQXYf+ONTDc0hVU6BB6qdszIR1W/lPKnka7zoP9JOdPfM7sKXAKBbPag
rBdE+/sn5pLzz6dV4eQjBDzt6+JCpm0vpfVZMaaSVxhgluzeYaSwwlFuYwwXm7Yq
L0eozHrxvzqKncA4juCyl60K+FkBueTg37GM9c86tE6BYd58HASX0vpLCszqSwoB
+2sR/4ipgNPZec0mG/Xr1LxhE+oLVpH0LHDmLz1K3lhqQ+qt4QgRYCa3+rzsG9+e
bmaW4+noe8qF+EMeeIOv7bqhjDE3KXa8bl1maG61Ue6gyuLTZqaTSJHtesJaDfG8
vGzccamZst8lymd0bL0mtvzLjkemmLXl8b7dw1Wv4f2pAM5uAz+VCG6EJcTY1l9x
ckQW5O61RIUSkYCNkkNcIbNCMRU9knjX/levmqUoUSPWvitkhizZ6DJLiYlhTbVN
O8F6P/IwpxvH5dBPOAw6tJxBZutW0ur+WECUiF9pO4Mu28Wn2H5upYHv6aXb1gfU
sl24ONbmUsc=
=B5YB
-----END PGP SIGNATURE-----

--Sig_/4p.xI2ptl=K..UwKBhAsPQ8--
