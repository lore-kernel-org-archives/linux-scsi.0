From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Wed, 11 Feb 2004 23:09:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040211220918.GJ4010@tpkurt.garloff.de>
References: <20040204024512.5bf68428.akpm@osdl.org> <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bXVaen7Op4LYXSUn"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:10646 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265875AbUBKWLi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Feb 2004 17:11:38 -0500
Content-Disposition: inline
In-Reply-To: <20040211132848.49eece0d.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com


--bXVaen7Op4LYXSUn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, Feb 11, 2004 at 01:28:48PM -0800, Andrew Morton wrote:
> Kurt Garloff <garloff@suse.de> wrote:
> > If we really allocate thousands of disks, the overhead of this solution
> > will be higher than the bitmap, I'm afraid.
>=20
> Four (or eight) bytes per disk!  I perceive a lack of perspecitve here ;)

We're fighting about a static 4k array currently ;-)

Well, it's certainly true that the memory we allocate in gendisk per
disk is higher than these wasted 4/8 bytes. It's just that I don't like
wasting anything ... The waste is 32/64times higher than with our
bitfield, except that it's dynamic.

> I'd trade clarity of implementation for that. =20

You seem to have used idr often before. It took me much longer to read
the docu and look at the function decsl than to understand the array
and the meaning of find_first_zero_bit().

> (As well as, possibly, reduced memory use on low-end machines).

This one is true.

If you think this is a relevant issue, tell me. I'll convert to use
idr then. Currently, I'm not sure whether the patch has any chance
to be merged, given the opposition of some people.=20

Actually, I'm not sure we currently have the right discussion here.

We want to have > 256 disk support, and we need to agree on how we=20
want to present it to the user. Changing some implementation behind
this is not really painful to do afterwards. Changing the way we
interpret majors/minors would be painful. Thus the suggestion of
Matthew which I liked and adopted. No need for new majors, no
changes to the well known numbers.

Of course there's the long term perspective of having a "disk" major
and udev taking care of everything. This will happen, but nobody
so far told that this should be done within 2.6. Nor do I see
udev replacing the classical device nodes completely within that
timeframe.

If we want something useful now, we need to keep the old disks=20
major/minor scheme untouched.
I see two possibilities to get somes done:
* Matthew's proposal (whatever we use the two extra "partition"
  bits for in the end)
* Introducing new majors, where we introduce a new numbering scheme.
  One major can accomodate 65536 disks =E0 16 partitions or 8192 disks
  with 64 partitions. We'd allocate one new major and sort disks
  after 256 there. The 64 partitions is actually out of the race,
  as the number of possible partitions would depend on the order=20
  that scsi disks are detected :-/

I think adding some bit shifting in the kernel is preferable to
breaking user interfaces. The effort to fix all the apps is much
higher. We should be aware that some bit shifting in the kernel
is really not the most complex part of this picture.

I would appreciate if those disliking Matthew's maj/min layout would
come up with a proposal and tell what they want. Or maybe admit that
they actually don't care?

I'm definitely not religious about how to solve this. But I would
like to have _a_ solution and I would like this solution not to
change anything for already well-known devices.

Once we have that, we can struggle about implememtation details that
are easy to change anyways.
 =20
Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--bXVaen7Op4LYXSUn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAKqgOxmLh6hyYd04RAipeAKC7f8g9QjYJsRHWP40XVWLPyTz2FgCguKgH
Pc81Yb065lQ1CzkU2uohobo=
=Qhs4
-----END PGP SIGNATURE-----

--bXVaen7Op4LYXSUn--
