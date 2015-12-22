From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Tue, 22 Dec 2015 22:13:30 +0000
Message-ID: <1450822398.5616.21.camel@intel.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	 <1449271801.27077.25.camel@HansenPartnership.com>
	 <1449273524.16905.103.camel@intel.com>
	 <87r3if2gij.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-KcJDvNTMkAfK8xxXymt8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28390 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbbLVWNr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 17:13:47 -0500
In-Reply-To: <87r3if2gij.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "neilb@suse.com" <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>

--=-KcJDvNTMkAfK8xxXymt8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2015-12-22 at 16:34 +1100, NeilBrown wrote:
> On Sat, Dec 05 2015, Verma, Vishal L wrote:
>=20
> > On Fri, 2015-12-04 at 15:30 -0800, James Bottomley wrote:
> > [...]
> > > > +ssize_t badblocks_store(struct badblocks *bb, const char *page,
> > > > size_t len,
> > > > +			int unack)
> > > [...]
> > > > +int badblocks_init(struct badblocks *bb, int enable)
> > > > +{
> > > > +	bb->count =3D 0;
> > > > +	if (enable)
> > > > +		bb->shift =3D 0;
> > > > +	else
> > > > +		bb->shift =3D -1;
> > > > +	bb->page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
> > >=20
> > > Why not __get_free_page(GFP_KERNEL)?=C2=A0=C2=A0The problem with kmal=
loc of
> > > an
> > > exactly known page sized quantity is that the slab tracker for
> > > this
> > > requires two contiguous pages for each page because of the
> > > overhead.
> >=20
> > Cool, I didn't know about __get_free_page - I can fix this up too.
> >=20
>=20
> I was reminded of this just recently I thought I should clear up the
> misunderstanding.
>=20
> kmalloc(PAGE_SIZE) does *not* incur significant overhead and certainly
> does not require two contiguous free pages.
> If you "grep kmalloc-4096 /proc/slabinfo" you will note that both
> objperslab and pagesperslab are 1.=C2=A0=C2=A0So one page is used to stor=
e each
> 4096 byte allocation.
>=20
> To quote the email from Linus which reminded me about this
>=20
> > If you
> > want to allocate a page, and get a pointer, just use "kmalloc()".
> > Boom, done!
>=20
> https://lkml.org/lkml/2015/12/21/605
>=20
> There probably is a small CPU overhead from using kmalloc, but no
> memory
> overhead.

Thanks Neil.
I just read the rest of that thread - and I'm wondering if we should
change back to kzalloc here.

The one thing __get_free_page gets us is PAGE_SIZE-aligned memory. Do
you think that would be better for this use? (I can't think of any). If
not, I can send out a new version reverting back to kzalloc.

	-Vishal


--=-KcJDvNTMkAfK8xxXymt8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJWecr+AAoJEHr6Yb6juE3/Ys0P/0L2X4i21k0RSPFfd7JyLkGV
LI0zkfZUmJAyNf2+jCPT0M7a9zzWduy0WS/Rguyc79cAi53D9llMUOQjAgOyxdzv
Xim9Gikr4b3bA2LrgTBYOrG/cHS5lF02sxPhoLFPuMeJjwCpJ3cPrd6S0wdu9jPV
RCfRbRoG+62HhYSYEkSmYGTZsKUV93188f7AJeAkKZt5GwAh52SUrqfe5aIUad5z
QiHttetKh3IMI20hpuQyTFWpuW9vGaKQIhXJ5WXkb5cUJPOmpK5gNqVaYvxrIGYI
IZdjGztPBpquzF01ssnx/93tUuvkLQ797wK983760WlrCoQiU8dpbTiXbZEJQpWn
gS6VykBlpe+fz9uBNEUhJW7p97TTRy3tIt+cDW4UmHdHmWJc0+rc5w7rkJD2mOBm
T1usSXaWQj/UQ16FCu2ePUNFmDzQ7oL/Ijdnfbx7vOkTXEB9FtFvfrdFHOSwOFCA
Kx2NBwWdXfttFN1YoLJxixbpu+k2x+PZ+cLPyMDOfYnSrCfKkeBzRBBB1dxFJI7C
hiaXhqpgTLW4iHdoMV6sBHJtuv2wC7M/m2OTcD1DIM6feuvhkNUxklWwoenDQ7W6
n84xmH+95PGm3xP+gnLA8RXUFawN0xdFueCabt4rpm4CGJy8l+HPUMKRMa00/R0b
3fH2d8NFU+tCEZSWcyQD
=SRvM
-----END PGP SIGNATURE-----

--=-KcJDvNTMkAfK8xxXymt8--
