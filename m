From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] block: add support for shared tag maps
Date: Mon, 18 Sep 2006 22:20:28 -0400
Message-ID: <1158632428.17671.109.camel@fc6.xsintricity.com>
References: <NONAMEBh8GyUbvH4KQ700000f3d@nonameb.ptu.promise.com>
	 <20060918184712.GA17670@infradead.org>  <1158607508.3800.4.camel@madmax>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I2Tmn5148aA6JF7VkeTO"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:13767 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1752011AbWISCUy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 22:20:54 -0400
In-Reply-To: <1158607508.3800.4.camel@madmax>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, Ed Lin <ed.lin@promise.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, david.somayajulu@qlogic.com


--=-I2Tmn5148aA6JF7VkeTO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2006-09-18 at 14:25 -0500, Mike Christie wrote:
> On Mon, 2006-09-18 at 19:47 +0100, Christoph Hellwig wrote:
> > On Fri, Sep 01, 2006 at 02:31:51PM +0800, Ed Lin wrote:
> > >  static int
> > > +stex_slave_alloc(struct scsi_device *sdev)
> > > +{
> > > +	/* Cheat: usually extracted from Inquiry data */
> > > +	sdev->tagged_supported =3D 1;
> > > +
> > > +	scsi_activate_tcq(sdev, sdev->host->can_queue);
> >=20
> > these two calls look wrong here. scsi_activate_tcq is supposed to be
> > called from slave_configure.  similarly tagged_supported is probably
> > going to be overwriten as part of the scanning process, but you already
> > set it in slave_configure anyway.
>=20
> If a lld is doing host wide tagging will they always need a tag? For
> those drivers it seems like they are not doing tagging based on this in
> scsi_scan

Well, were I to ever convert the aic7xxx_old driver to mid level tags,
then the answer to this is partially yes.  We don't need to pass the tag
to the device, but since the firmware in the aic7xxx driver looks up the
tag of the used slot via a table for untagged commands, we are in danger
of having that tag passed back down to us for another device at another
time while this one is still active.  Therefore, we need to know which
tag slot the mid layer wants allocated even on untagged commands.  In
addition, the aic7xxx_old driver will, even on tagged devices, send some
commands as untagged when needed (some older devices would choke on both
a tag message and an SDTR message in the same command, so the driver
defaults to sending all WDTR/SDTR flagged commands as untagged).  On
those untagged commands, when the device reconnects, the driver looks
into a table indexed by target/lun to find the tag slot of the untagged
command and then DMAs it into card memory from the SCB array.  On tagged
commands, the tag itself was the index into the command array.  So,
that's a quick rundown of what the aic7xxx_old does.  That means that in
order to have the mid layer assign tags, the aic7xxx driver needs *all*
commands, untagged or tagged, to have a tag value and for that tag to be
reserved.  There would then need to be another something, such as tag
type, to indicate if the passed down tag is to be used solely to index
into the command array or if it should be passed to the device as the
tag value.  One possible way to implement this would be to have a flag
in the host struct registration that indicates that the host has a
shared tag array, the mid layer would allocate a static tag array of
can_queue tags, attach it to the host, then have all subsequent devices
in scsi_scan link to that array, and all commands would be sent with an
array slot allocated even if the command is untagged.  Problem solved.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-I2Tmn5148aA6JF7VkeTO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFD1Psg6WylM+/8ZQRAnX/AJ0ejhoE5uD1rmXmKULdM5w/nC+xRgCdEuZk
LQekM0JE1XFZwDUYSjetvHA=
=HW7q
-----END PGP SIGNATURE-----

--=-I2Tmn5148aA6JF7VkeTO--

