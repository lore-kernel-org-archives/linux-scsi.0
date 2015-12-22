From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Tue, 22 Dec 2015 16:34:28 +1100
Message-ID: <87r3if2gij.fsf@notabene.neil.brown.name>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com> <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com> <1449271801.27077.25.camel@HansenPartnership.com> <1449273524.16905.103.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40129 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbbLVFek (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2015 00:34:40 -0500
In-Reply-To: <1449273524.16905.103.camel@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 05 2015, Verma, Vishal L wrote:

> On Fri, 2015-12-04 at 15:30 -0800, James Bottomley wrote:
> [...]
>> > +ssize_t badblocks_store(struct badblocks *bb, const char *page,
>> > size_t len,
>> > +			int unack)
>> [...]
>> > +int badblocks_init(struct badblocks *bb, int enable)
>> > +{
>> > +	bb->count =3D 0;
>> > +	if (enable)
>> > +		bb->shift =3D 0;
>> > +	else
>> > +		bb->shift =3D -1;
>> > +	bb->page =3D kmalloc(PAGE_SIZE, GFP_KERNEL);
>>=20
>> Why not __get_free_page(GFP_KERNEL)?=C2=A0=C2=A0The problem with kmalloc=
 of an
>> exactly known page sized quantity is that the slab tracker for this
>> requires two contiguous pages for each page because of the overhead.
>
> Cool, I didn't know about __get_free_page - I can fix this up too.
>

I was reminded of this just recently I thought I should clear up the
misunderstanding.

kmalloc(PAGE_SIZE) does *not* incur significant overhead and certainly
does not require two contiguous free pages.
If you "grep kmalloc-4096 /proc/slabinfo" you will note that both
objperslab and pagesperslab are 1.  So one page is used to store each
4096 byte allocation.

To quote the email from Linus which reminded me about this

> If you
> want to allocate a page, and get a pointer, just use "kmalloc()".
> Boom, done!

https://lkml.org/lkml/2015/12/21/605

There probably is a small CPU overhead from using kmalloc, but no memory
overhead.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeODkAAoJEDnsnt1WYoG5qjgP/1NyOzNsfE/AKwAEF30zSDNO
xhxxYWZv3srRs+nXpmXgX+GBextkuJOf3vSEHTqQtidBV1W85NsCIyM4PmV8aKbx
R5wMcyWWgySfNDYSpqvow/Xit5DgDLi1tp+XmkdV1NQJzwh28N0aV+RO9DyxfPvu
xDQRSjLkajxheH+kxz1LCq8mw6y+Da4wUXplJmYZ7j7E+J9THolDREdJ4ETKRkjn
vlyBhtYZ/BBYK4FZBLvWzCq31JdDNILTPPRtQO6zvMO8he6hCqNjHsRa3pXjA7KW
RpDlUdMee1Qmey5mkK7EbPWf0+jlciUi1kzzyXFwNJLLPURROFLngDc2nEdPHrhT
QNnEO/gcmUOdQPaOVnOto1j/V2lAdV+8p/+EIW+oXIJcjp/teDKgAde18l5rUI8l
E7ovE2x0AmOZkGs+rddq3ZyASCQREzguh9TTUrOlmhcaCneHNbONmbuvah4lg2Ew
4L0VthKKASoV869sPMef7Vr7EwA8J9rNyAp155cm49D2rmuTEL8AI0VJZjUD3qmG
oqgXcHO8PRXi6yfEJ3Jy2NvlnMH7hHTX1Zs81eRIAPkr2YpNo9hKNF7qLaIEJ6Q/
l61j4LHfSF7aE2kN0lJYdXyivJGo/uc1kc9uHPSs5LsE8IlS8VHMbZHx54Qvs4bf
iSYOkxujUvJ/B0o2HPBv
=SDZk
-----END PGP SIGNATURE-----
--=-=-=--
