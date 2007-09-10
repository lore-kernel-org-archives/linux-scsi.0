From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [patchset 0/5] Refactoring scsi_error to facilitate in synchronous REQUEST_SENSE
Date: Mon, 10 Sep 2007 10:03:34 -0700
Message-ID: <20070910170334.GA12369@one-eyed-alien.net>
References: <46E5508B.7030108@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:58456
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756716AbXIJRD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 13:03:56 -0400
Content-Disposition: inline
In-Reply-To: <46E5508B.7030108@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@infradead.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 10, 2007 at 05:11:23PM +0300, Boaz Harrosh wrote:
>=20
> In motivation to abstract scsi_cmnd members and insulate
> drivers/transports from scsi_cmnd internals. The last
> place left was the REQUEST_SENSE sequence when done
> synchronous, by drivers.

This probably isn't serious, but I noticed one thing (beyond what Alan's
analysis noted)...

I've always assumed that the scatterlist structs passed to an HCD were,
themselves, allocated from DMA-able memory.  That is, not just the transfer
buffers themselves, but the struct scatterlist also.

In this implementation, the struct scatterlist used for the single-element
transfer of the request sense buffer is part of the
struct scsi_eh_save_cmnd_info, which is allocated on the stack (for at
least usb-storage).  And, stack isn't DMA-able on all arches.

It is not a problem for usb-storage, since the struct scatterlists are
processed in code into a series of URBs, so nobody actually does DMA the
scatterlist structures.  However, I don't know enough about the other HCDs
to be certain about them.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Now payink attention, please.  This is mouse.  Click-click. Easy to=20
use, da? Now you try...
					-- Pitr to Miranda
User Friendly, 10/11/1998

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFG5XjmHL9iwnUZqnkRArtiAJ9fhLHcvnhqTRsVvIkUYlP/K/U0HACgsK+T
1+PmotIQY0gUeBpw0sl1+QU=
=zCQM
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
