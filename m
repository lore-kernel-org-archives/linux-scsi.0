From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Thu, 12 Feb 2004 16:00:35 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212150035.GN1780@tpkurt.garloff.de>
References: <20040210110417.GB4010@tpkurt.garloff.de> <20040210112658.GC4010@tpkurt.garloff.de> <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BjavXC7V3ilNTWHC"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:7808 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266488AbUBLPAh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 10:00:37 -0500
Content-Disposition: inline
In-Reply-To: <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: Andrew Morton <akpm@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com


--BjavXC7V3ilNTWHC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al Viro,

On Wed, Feb 11, 2004 at 10:53:48PM +0000, viro@parcelfarce.linux.theplanet.=
co.uk wrote:
> On Wed, Feb 11, 2004 at 02:29:33PM -0800, Andrew Morton wrote:
> > I was rather hoping that Al would follow up on his comments yesterday
> > actually.
>=20
> OK.  Proposed "sparse" partition numbers are Bad Idea(tm), for the same
> reasons why 255.255.252.240 is not a good netmask for a subnet in class B.
> It might be possible to handle if we do a single ->probe() for entire
> major and put the smarts into it (about the only way to do that, actually=
),
> but we'll have a hell of time hunting down all places assuming that
> device number =3D=3D first device number + partition number.  Note that we
> are talking about late-boot code, fs/partition/*, anything that calls
> bdget_disk(), etc.  _And_ unknown amount of userland code.  And code that
> exports information to userland (e.g. /proc/paritions or sysfs per-disk
> subtrees).

OK, so let's scratch that from the proposal.=20

It means we won't get 64 partitions, but I don't think this an=20
important feature for many users. And it looks like we can't do=20
it in a sane way without breaking the old numbers any way.
And the breakage should be deferred to the /dev/disk change in=20
2.7, IMHO.

Let's just use
  31     20 19       4 3    0
 |--major--|---disk---|-part-|

Any problems with that?

I would have reserved 2 bits (19,18) in case somebody finds a way to
implement it in a sane way, but probably you're right and it's not
doable in a sane way. As long as we don't bump up the limit to more=20
than 256k disks, we do not run into conflicts anyway.=20

Expect a patch later.=20

> Unless somebody has a good idea of the modifications involved and is will=
ing
> to describe them (_not_ on usual aeb level of handwaving, please), I cons=
ider
> that idea as non-feasible.

One could add a hook to gendisk, and do some translation from user-visible
device numbers to kernel device numbers. Thus only causing hacks at one=20
place ...

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--BjavXC7V3ilNTWHC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAK5UTxmLh6hyYd04RAmRxAKDKpVoWzbgiQyC/oxN2mx/QahoQUgCePZDZ
VQCip8hKc4MiSUwYgGYV85A=
=l6yI
-----END PGP SIGNATURE-----

--BjavXC7V3ilNTWHC--
