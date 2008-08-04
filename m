From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] USB storage devices and SAT
Date: Sun, 3 Aug 2008 19:21:52 -0700
Message-ID: <20080804022152.GJ4322@one-eyed-alien.net>
References: <489656EC.5000602@torque.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZoaI/ZTpAVc4A5k6"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:60113
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861AbYHDCVy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Aug 2008 22:21:54 -0400
Content-Disposition: inline
In-Reply-To: <489656EC.5000602@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>


--ZoaI/ZTpAVc4A5k6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2008 at 03:10:04AM +0200, Douglas Gilbert wrote:
> Alan Stern has already noted to another smartmontools developer
> that such a change is likely to break some USB storage devices.
> Perhaps the maximum sense buffer size could be optionally
> specified per usb storage device. Alternatively the usb mass
> storage logic could make some dynamic decisions itself.

To clarify: A great many devices choke (fatally) if asked for sense data
other than 18 bytes.  Since the first TEST_UNIT_READY will likely require
sense data, almost every device sees REQUEST_SENSE.

Personally, I hate having to make dynamic decisions in usb-storage.  The
more we try to do there, the more likely we are to get it wrong.

If you've got an app that is sending a command, and you KNOW that command
should produce >18 bytes of sense data, then there should be a way to
specify to the SCSI core (and thus get passed to usb-storage) that sense
data of >18 bytes should be requested.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm seen in many forms.  Now open your mouth.  It's caffeine time.
					-- Cola Man to Greg
User Friendly, 10/28/1998

--ZoaI/ZTpAVc4A5k6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIlmfAHL9iwnUZqnkRAtA9AKCq5agbSJnYqmWLz9Up2Tdtzz1f6gCfYScO
BS94pSLt06679ew0GFbdJII=
=Uooh
-----END PGP SIGNATURE-----

--ZoaI/ZTpAVc4A5k6--
