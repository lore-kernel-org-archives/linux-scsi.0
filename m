From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Tue, 10 Feb 2004 12:04:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040210110417.GB4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:15282 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265816AbUBJLEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Feb 2004 06:04:21 -0500
Content-Disposition: inline
In-Reply-To: <20040204024512.5bf68428.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Badari Pulavarty <pbadari@us.ibm.com>, Matthew Wilcox <willy@debian.org>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, Feb 04, 2004 at 02:45:12AM -0800, Andrew Morton wrote:
> You can't hide from me you know ;)
>=20
> What to do about this?

Apply my patch ;-)

Find attached a patch that combines Badari's and Matthew's ideas.
It corrects the typos in Matthew's code snippets.

It does even address Christoph's criticism. Though I'm sure, he'll find=20
new points ...

> Last time it was discussed we had:
>=20
> Christoph Hellwig <hch@infradead.org> wrote:
> >
> >=20
> >  - I think the bitmap overhead was killing us on big x86 machines, righ=
t?
> >    so that might need some swork.

I limited the number of disks to 32k, which gives us a 4k bitmap.

Loading scsi_debug with 4k disks takes a minute or so, removing a few
minutes.
I doubt that it's caused by the bitmap, though. sg takes equally long.
Eventually, we'll need to ask oprofile.=20
As long as we know there are no holes, we could shortcut the bitmap=20
search ...

The patch would support up to 262144 disks, but I believe we're safe
with just 32k for the next years, even for those hard core multipath
people.

> >  - a config option definitly is the wrong way to go.

There's no config option any more.
EMBEDDED  ->   256
otherwise -> 32768

> >  - I don't think assigning more numbers to the last major is a bad idea,
> >    better assign them to the first one, maybe with a hole for what we're
> >    using the other majors currently for, so when udev gets more mature
> >    we can kill the additional majors.

Matthew stripes them over the majors. The first sixteen go to major0,
the next to major 1 ...; disks 256 -- 271 go to major0 again etc.

> Matthew Wilcox <willy@debian.org> wrote:
> >
> > LWN were kind enough to archive my previous thoughts on this at
> > http://lwn.net/Articles/54840/
> >=20
> > I'd've worked on some code for this if anyone had been interested ...

I've taken most from it.

I also let the support for two more partition bits in, though it=20
can't be really used at the moment. The genhd does not accomodate
non-contigous minors for partitions.

If the need arises, this can be done later, though it will be a bit=20
of a hack. So we can as well look at them as two reserved bits for now.

> badari <pbadari@us.ibm.com> wrote:
> >
> > I am not sorry for not replying for so long. I have been on vacation.
> >=20
> > 1) I am not really concerned about bitmap overhead. Bitmap of one
> > page (4k) - should be enough to support 32K disks. That should be
> > good enough for most of the machines.

Agreed.

> > 2) I used config option for 2 reasons
> >         - to minimize impact on machines this is not needed.
> >         - didn't want to depend on <major, minor> split to decide on
> >            how many disks we can support.

That's why I made it depending on CONFIG_EMBEDDED.

> > 3) The reason, I assigned all the disks to last major is to maintain ba=
ckward
> > compatibility with current major, minor assignments. Hopefully "udev"
> > will cleanup all these.

Matthew's approach does this as well.

> > My question is, what do we do for current 2.6 ? Hoping to address these
> > before distros start making 2.6 distros and adding their own stuff to s=
upport
> > this.
> >=20
> > And also, is there a plan to support more partitions per disk ?

There is, but either we have to hack gendisk or break the old numbering.
For now, I've done neither, but two bits are reserved for supporting 64
partitions per disk.

> And nothing happened.

Well, I even tested the patch.=20

I'm a bit worried that unloading scsi_debug with 4k disks takes so long,
but I doubt it's caused by sd, as it also happened with sg only.
For the rest, it survived well.

Note that sg currently limits the amount of generic devices to 8k.
We should probably also increase it to 32k.

If the sd patch is found acceptable, I'll submit a patch to sg.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKLqwxmLh6hyYd04RAoMZAKCjjy8UYUaDfn9OAJTl5WDImJFHugCfYCk8
mVyP6lDbZv+sSlgQs7Za05Q=
=5ned
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
