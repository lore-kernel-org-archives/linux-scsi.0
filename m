From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [linux-usb-devel] FW: USB 2.0 external hard drive problem
Date: Fri, 6 Feb 2004 12:59:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040206205929.GB23264@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0402060946350.830-100000@ida.rowland.org> <1076081067.1823.5.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from multivac.one-eyed-alien.net ([64.169.228.101]:24800 "EHLO
	multivac.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S265595AbUBFU7v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2004 15:59:51 -0500
Content-Disposition: inline
In-Reply-To: <1076081067.1823.5.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Joerg Schilling <schilling@fokus.fraunhofer.de>, magliery@csb.yale.edu, appro@fy.chalmers.se, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 06, 2004 at 10:24:25AM -0500, James Bottomley wrote:
> On Fri, 2004-02-06 at 09:59, Alan Stern wrote:
> > Who says it's wrong to retrieve sense information when there is an
> > underrun but not Check Condition?  Can you provide a reference to a
> > published (or draft) document that states this?
>=20
> It's not wrong according to the SCSI standards, a REQUEST SENSE issued
> to a device with no sense data will produce a NO SENSE key.
>=20
> However, because of the way sense is processed in contingent allegiance
> conditions (suspending the I_T_L nexus until sense is cleared) it is
> dangerous to issue arbitrary request sense commands because you may
> receive sense for a different command (and prevent that command from
> erroring correctly).

You'll excuse me if I stare at you blankly after you say this?

If I'm guessing correctly, this is only an issue with multiple pending
commands (i.e. TCQ or somesuch)?

A USB device only ever has one command at a time.

> The SCSI mid-layer definitely does not expect this behaviour.  A driver
> either does not do any sense commands at all or it only issues a REQUEST
> SENSE in response to a Check Condition status in order not to have the
> nexus halted because of a contingent allegiance condition (simulating
> ACA if you will).

'Check Condition' isn't something we can directly observe.  We get 2 status
bits back which encode "good", "bad", or "you're screwed -- you are now
required to perform a reset".

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Stef, you just got beaten by a ball of DIRT.
					-- Greg
User Friendly, 12/7/1997

--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAJAAxIjReC7bSPZARApoqAKCA0jClMpPFQ5L1yfYhlmQpQv2AQgCgvLKd
2sRpAx5kWHn1w0SgObldBjU=
=p9ux
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
