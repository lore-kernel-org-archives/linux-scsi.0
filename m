From: Kurt Garloff <garloff@suse.de>
Subject: Re: lots and lots of disks again
Date: Thu, 12 Feb 2004 17:18:00 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040212161800.GU1780@tpkurt.garloff.de>
References: <20040210133932.A3870@infradead.org> <20040210154751.GH4010@tpkurt.garloff.de> <20040210102603.0c835212.akpm@osdl.org> <20040211145614.GA4010@tpkurt.garloff.de> <20040211132848.49eece0d.akpm@osdl.org> <20040211220918.GJ4010@tpkurt.garloff.de> <20040211142933.484ca978.akpm@osdl.org> <20040211225348.GM21151@parcelfarce.linux.theplanet.co.uk> <20040212150035.GN1780@tpkurt.garloff.de> <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R7Dyui215VKdTDYA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:65208 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S266505AbUBLQSC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Feb 2004 11:18:02 -0500
Content-Disposition: inline
In-Reply-To: <20040212155721.GS21151@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: viro@parcelfarce.linux.theplanet.co.uk
Cc: Andrew Morton <akpm@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, pbadari@us.ibm.com, willy@debian.org, James.Bottomley@steeleye.com


--R7Dyui215VKdTDYA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 12, 2004 at 03:57:21PM +0000, viro@parcelfarce.linux.theplanet.=
co.uk wrote:
> On Thu, Feb 12, 2004 at 04:00:35PM +0100, Kurt Garloff wrote:
> > Let's just use
> >   31     20 19       4 3    0
> >  |--major--|---disk---|-part-|
> >=20
> > Any problems with that?
>=20
> What the hell is "major"? =20

A number out of 8, 64 -- 71, 136 -- 143.
Together with the disk part of the minor number, it determines the=20
disk we talk to. The other way round actually. When detecting disks,
we assign the device numbers according to a scheme=20
0x00800000,0x00800010, ... 0x008000f0, 0x04000000, ...=20
     (0)       (1)            (15)        (16)

0x00800100, ... 0x00800200
   (256)           (512)

The numbers in parens denote the detection order of the SCSI disks.

And we fill the number into the gendisk structure.
But you know this.

> Device numbers space is flat - you don't even
> need any sort of alignment for allocated chunks...

=2E.. and I suggest to use it the way outlined above.

Unless we go for the gendisk aliasing suggestion from James and allocate=20
a new major additionally. I did not yet check whether it's feasible.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--R7Dyui215VKdTDYA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAK6c4xmLh6hyYd04RAt1jAJ9hRUc4+P6IUDCIy3HYgAxnsirxAACgisWb
aulXtuRdtmtKZJ5B6R/InCk=
=6+3o
-----END PGP SIGNATURE-----

--R7Dyui215VKdTDYA--
