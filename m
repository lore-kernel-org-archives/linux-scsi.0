From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Wed, 23 Dec 2015 10:06:26 +1100
Message-ID: <877fk62idp.fsf@notabene.neil.brown.name>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com> <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com> <1449271801.27077.25.camel@HansenPartnership.com> <1449273524.16905.103.camel@intel.com> <87r3if2gij.fsf@notabene.neil.brown.name> <1450822398.5616.21.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48080 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932072AbbLVXGh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 18:06:37 -0500
In-Reply-To: <1450822398.5616.21.camel@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 23 2015, Verma, Vishal L wrote:

> On Tue, 2015-12-22 at 16:34 +1100, NeilBrown wrote:
>> On Sat, Dec 05 2015, Verma, Vishal L wrote:
>>=20
>> > On Fri, 2015-12-04 at 15:30 -0800, James Bottomley wrote:
>> > [...]
>> > > > +ssize_t badblocks_store(struct badblocks *bb, const char *page,
>> > > > size_t len,
>> > > > +			int unack)
>> > > [...]
>> > > > +int badblocks_init(struct badblocks *bb, int enable)
>> > > > +{
>> > > > +	bb->count =3D 0;
>> > > > +	if (enable)
>> > > > +		bb->shift =3D 0;
>> > > > +	else
>> > > > +		bb->shift =3D -1;
>> > > > +	bb->page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>> > >=20
>> > > Why not __get_free_page(GFP_KERNEL)?=C2=A0=C2=A0The problem with kma=
lloc of
>> > > an
>> > > exactly known page sized quantity is that the slab tracker for
>> > > this
>> > > requires two contiguous pages for each page because of the
>> > > overhead.
>> >=20
>> > Cool, I didn't know about __get_free_page - I can fix this up too.
>> >=20
>>=20
>> I was reminded of this just recently I thought I should clear up the
>> misunderstanding.
>>=20
>> kmalloc(PAGE_SIZE) does *not* incur significant overhead and certainly
>> does not require two contiguous free pages.
>> If you "grep kmalloc-4096 /proc/slabinfo" you will note that both
>> objperslab and pagesperslab are 1.=C2=A0=C2=A0So one page is used to sto=
re each
>> 4096 byte allocation.
>>=20
>> To quote the email from Linus which reminded me about this
>>=20
>> > If you
>> > want to allocate a page, and get a pointer, just use "kmalloc()".
>> > Boom, done!
>>=20
>> https://lkml.org/lkml/2015/12/21/605
>>=20
>> There probably is a small CPU overhead from using kmalloc, but no
>> memory
>> overhead.
>
> Thanks Neil.
> I just read the rest of that thread - and I'm wondering if we should
> change back to kzalloc here.
>
> The one thing __get_free_page gets us is PAGE_SIZE-aligned memory. Do
> you think that would be better for this use? (I can't think of any). If
> not, I can send out a new version reverting back to kzalloc.

kzalloc(PAGE_SIZE) will also always return page-aligned memory.
kzalloc returns a void*, __get_free_page returns unsigned long.  For
that reason alone I would prefer kzalloc.

But I'm not necessarily suggesting you change the code.  I just wanted
to clarify a misunderstanding.  You should produce the code that you are
most happy with.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeddyAAoJEDnsnt1WYoG5IBwQAKSRzFgKw3UletLf3gN+jlHH
0IK5rwV3gZWY3oHVhEUNJvdo+HGE9soat4dW3HpyuBDvBTu682pGgq9/f94Cgbug
xDXrYPhes9xL1qbI9USLKA6FJ+6fgpW5vWmUJvkds424Gm7sBIDomcMfAcu+DKUg
agSwYdhSQ5oxXCAnXY3VtSpJZqzQ1e0zkB18Nr2RpBz4OJOy9PCucfzbWYme/BH3
6ILOEekIFA7WNvf0flX6+nEO50SkVHxat6TeRBYqrWqF1fqACB8R1IfkKMfHT7Q0
XWxrCgqei2Jzs+kq81LAvbheMjGPn2Q5ot8vzIXpz/fJcsLA/xY0QQJRoWEIPcDX
e05jI2XuxoBADqSLgS16CCxZ/yH4quoU2xpLg0h98UdZ8H5e/NxKMt3ktfZqmQXQ
zvwMaBcEAsNsYbcfB5UO+w5x05jRG60b0HcejvAxAeKUDbV8a/0rBNUVpZzFhvLk
knILHt7d5KNS+aaEL7Qm3dHe+qZYWbMkIBNYpEG6FH2oMundEWGtrzUpeS2xwdR3
4HhxpkIjlvArlOUzjq20zKco0NVzX0rJo5Sf9nBN8MVNKl1quwHzwLCZvqcDdd0p
Vme/2WdyMlKQuoRNJe7GMYcNucO08AOFA+3IcEnXuhshORiW7xru/TFIRNsbORtD
3YRYtS1jY0dZLfOQOICN
=Bq96
-----END PGP SIGNATURE-----
--=-=-=--
