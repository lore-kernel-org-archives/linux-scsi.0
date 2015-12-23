From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Wed, 23 Dec 2015 00:38:55 +0000
Message-ID: <1450831135.5616.24.camel@intel.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	 <1449271801.27077.25.camel@HansenPartnership.com>
	 <1449273524.16905.103.camel@intel.com>
	 <87r3if2gij.fsf@notabene.neil.brown.name>
	 <1450822398.5616.21.camel@intel.com>
	 <877fk62idp.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-XyfdK1xyofynMXfkONFy"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fk62idp.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "neilb@suse.com" <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

--=-XyfdK1xyofynMXfkONFy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-12-23 at 10:06 +1100, NeilBrown wrote:
> On Wed, Dec 23 2015, Verma, Vishal L wrote:
>=20
> > On Tue, 2015-12-22 at 16:34 +1100, NeilBrown wrote:
> > > On Sat, Dec 05 2015, Verma, Vishal L wrote:
> > >=20
> > > > On Fri, 2015-12-04 at 15:30 -0800, James Bottomley wrote:
> > > > [...]
> > > > > > +ssize_t badblocks_store(struct badblocks *bb, const char
> > > > > > *page,
> > > > > > size_t len,
> > > > > > +			int unack)
> > > > > [...]
> > > > > > +int badblocks_init(struct badblocks *bb, int enable)
> > > > > > +{
> > > > > > +	bb->count =3D 0;
> > > > > > +	if (enable)
> > > > > > +		bb->shift =3D 0;
> > > > > > +	else
> > > > > > +		bb->shift =3D -1;
> > > > > > +	bb->page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
> > > > >=20
> > > > > Why not __get_free_page(GFP_KERNEL)?=C2=A0=C2=A0The problem with =
kmalloc
> > > > > of
> > > > > an
> > > > > exactly known page sized quantity is that the slab tracker for
> > > > > this
> > > > > requires two contiguous pages for each page because of the
> > > > > overhead.
> > > >=20
> > > > Cool, I didn't know about __get_free_page - I can fix this up
> > > > too.
> > > >=20
> > >=20
> > > I was reminded of this just recently I thought I should clear up
> > > the
> > > misunderstanding.
> > >=20
> > > kmalloc(PAGE_SIZE) does *not* incur significant overhead and
> > > certainly
> > > does not require two contiguous free pages.
> > > If you "grep kmalloc-4096 /proc/slabinfo" you will note that both
> > > objperslab and pagesperslab are 1.=C2=A0=C2=A0So one page is used to =
store
> > > each
> > > 4096 byte allocation.
> > >=20
> > > To quote the email from Linus which reminded me about this
> > >=20
> > > > If you
> > > > want to allocate a page, and get a pointer, just use
> > > > "kmalloc()".
> > > > Boom, done!
> > >=20
> > > https://lkml.org/lkml/2015/12/21/605
> > >=20
> > > There probably is a small CPU overhead from using kmalloc, but no
> > > memory
> > > overhead.
> >=20
> > Thanks Neil.
> > I just read the rest of that thread - and I'm wondering if we should
> > change back to kzalloc here.
> >=20
> > The one thing __get_free_page gets us is PAGE_SIZE-aligned memory.
> > Do
> > you think that would be better for this use? (I can't think of any).
> > If
> > not, I can send out a new version reverting back to kzalloc.
>=20
> kzalloc(PAGE_SIZE) will also always return page-aligned memory.
> kzalloc returns a void*, __get_free_page returns unsigned long.=C2=A0=C2=
=A0For
> that reason alone I would prefer kzalloc.
>=20
> But I'm not necessarily suggesting you change the code.=C2=A0=C2=A0I just=
 wanted
> to clarify a misunderstanding.=C2=A0=C2=A0You should produce the
> code that you are
> most happy with.


I agree, the typecasting with=C2=A0__get_free_page is pretty ugly. I'll
change it back to kzalloc.

Thanks,
	-Vishal
--=-XyfdK1xyofynMXfkONFy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJWee0fAAoJEHr6Yb6juE3/FV8P/0lryHr537Czk95+gxwRV8e5
/f8SP2Fp1+9V/GNxTYk70KmtLbVTqxul0KJO4Mt7cjeeuhFsumY9Njq4PLtJ+C8n
JSJCZEzxWg8XVK6oqXdY6rEGywrFWpfrN7LiRZuHi+i1xFm0YNMf1Z0ndYC67fjb
UzhabQGRFBgQb5ogpcPrGxW0pGpK5Zqkq/ifoZ2ZZ4dvcym9llPode5cuA3fbtS7
lvJ0HeVhnUy8+XkQfPZy0UyTYuZZ8Al0EWGiV4WoXgKTVYa8HqVzDLh9wkFyor+D
TCvTJp0KbHmmcBVs6qDA1S7aDFAVNWtfUfQOkysD06ywbO+MuZ0rtBd0jsXTv5Sc
wlpkQiK5wsL4IGLxdpCqz7+1TnNYab5zwlbCCkuoN/f9N5IUkR3slr0rcez6GWMa
XTCcUdV7XE496SNJbC40SMqtMKWABLRqFC+mQiGySEPWr7odRAjGMLbLpRbf9tJ3
e8bSFEvPW9TKxQdx5f3+PjuYHIhUwPCViKlrGdOncDvIpbKc6RiQFYjxEZUmUWh6
6UaRG6rqf07KEbkcjZs0K4w3S8OdLgGetEuhQnWnKWTHsvkDANTVJvT1PvI+dJXG
scvFo3UtrGfTpt5c7g39HjQJUB401G3nC05Vl0BOp3UF5ZT3hQFo6eDvm4tBrPJg
DpqPBZETiL8gcGBA1Jfo
=HQFD
-----END PGP SIGNATURE-----

--=-XyfdK1xyofynMXfkONFy--
