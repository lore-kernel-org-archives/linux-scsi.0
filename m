From: Andre Noll <maan@systemlinux.org>
Subject: Re: [PATCH 2/6] Adjust block device size after an online resize of a disk.
Date: Fri, 5 Sep 2008 19:55:36 +0200
Message-ID: <20080905175536.GD3795@skl-net.de>
References: <20080904202714.10456.88061.stgit@bob.kio> <20080904202725.10456.62289.stgit@bob.kio> <20080905131244.GC3795@skl-net.de> <1220628997.7790.30.camel@grinch>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:45680 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbYIESE5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Sep 2008 14:04:57 -0400
Content-Disposition: inline
In-Reply-To: <1220628997.7790.30.camel@grinch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk, andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com, jmoyer@redhat.com


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:36, Andrew Patterson wrote:
> On Fri, 2008-09-05 at 15:12 +0200, Andre Noll wrote:
> > On 14:27, Andrew Patterson wrote:
> > >  int revalidate_disk(struct gendisk *disk)
> > >  {
> > > +	struct block_device *bdev;
> > >  	int ret =3D 0;
> > > =20
> > >  	if (disk->fops->revalidate_disk)
> > >  		ret =3D disk->fops->revalidate_disk(disk);
> >=20
> > Maybe we should return early at this point if revalidate_disk()
> > failed or fops->revalidate_disk is NULL.
>=20
> We won't run check_disk_size_change() if we return early here. So the
> question is would anyone ever make this call if they didn't have a
> revalidate_disk routine?

I'd say no. In case someone ever does, it seems natural to do nothing
and return early.

> > > +	bdev =3D bdget_disk(disk, 0);
> > > +	if (!bdev)
> > > +		return ret;
> >=20
> > We might return success here even if bdev is NULL. OTOH, as the callers
> > of revalidate_disk() do not check the return value anyway (although at
> > least tapeblock_revalidate_disk() might return a negative value) it's
> > probably also an option to change the return type of revalidate_disk()
> > to void.
> >=20
>=20
> The revalidate_disk() wrapper tries to maintain compatibility with the
> current interface. It might make sense to change it given no one
> actually really seems to use the return value. I guess I am very wary
> about effectively changing the interface of the lower-level
> revalidate_disk() routines, at least in this particular patchset.

Agreed, that should be done later in a different patchset. It just
looked a bit odd to introduce a new function returning int with none
of its callers actually caring about the return value.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIwXKYWto1QDEAkw8RAhK9AJ9szRI9FyG3l85lDgoIWldb0vrQHACfVx/R
9wO06YWWGnseGc2cKxg/yu4=
=g2kD
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
