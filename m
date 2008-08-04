From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Mon, 4 Aug 2008 08:21:07 -0700
Message-ID: <20080804152107.GK4322@one-eyed-alien.net>
References: <489656EC.5000602@torque.net> <20080804022152.GJ4322@one-eyed-alien.net> <4896BE7E.3050405@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:35686
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904AbYHDPVS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 11:21:18 -0400
Content-Disposition: inline
In-Reply-To: <4896BE7E.3050405@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Douglas Gilbert <dougg@torque.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2008 at 11:31:58AM +0300, Boaz Harrosh wrote:
> Matthew Dharm wrote:
> > If you've got an app that is sending a command, and you KNOW that comma=
nd
> > should produce >18 bytes of sense data, then there should be a way to
> > specify to the SCSI core (and thus get passed to usb-storage) that sense
> > data of >18 bytes should be requested.
>=20
> What?!! The number 18 comes totally from USB land at:
> drivers/usb/storage/transport.c:601 via call to scsi_eh_prep_cmnd
> Otherwise the entire kernel including scsi-ml and all user applications
> request 96 bytes of sense, always.

Well, yes.  I think the value 96 must be (relatively) new... I think the
value 18 originally came about by copying it from somewhere else, since
it's not passed as a parameter from the scsi-ml and needed to be coded
directly into usb-storage to support auto-sense.

Perhaps you mis-interpreted my use of "should"?  I mean "we should add a
way" (not "a way should already exist").

Supporting auto-sense was a requirement since there are transport/protocol
combinations where it's not really optional.  And, once issued
REQUEST_SENSE will clear the sense data, so it we needed to keep the data
to put into the auto-sense buffer at those times when sense data needed to
be passed to the scsi-ml.

> So there is nothing the SCSI core or application can do about it.=20
> It is USB fix time I'm afraid.

Right now, there is nothing that SCSI core or an app can do about it.  What
I'm suggesting is that there be a parameter (in the scsi_host structure,
perhaps?) that allows the core or an app to control this.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm a pink gumdrop! How can anything be worse?!!
					-- Erwin
User Friendly, 10/4/1998

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIlx5jHL9iwnUZqnkRAhXhAJ9zaHJu++jx8HvhTQJF9MB2GlZjmgCeOf+T
2cpci/yTqjQtrYmrVjcTHIA=
=fexL
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
