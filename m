From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: scsi_forget_host() and scsi_remove_device()
Date: Fri, 4 Jul 2003 12:54:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030704125444.B17588@one-eyed-alien.net>
References: <20030703221940.GA5983@beaverton.ibm.com> <Pine.LNX.4.44L0.0307041505110.22716-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="xgyAXRrhYN0wYx8y"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:3335 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S266149AbTGDTkT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Jul 2003 15:40:19 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307041505110.22716-100000@netrider.rowland.org>; from stern@rowland.harvard.edu on Fri, Jul 04, 2003 at 03:36:55PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI development list <linux-scsi@vger.kernel.org>


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 04, 2003 at 03:36:55PM -0400, Alan Stern wrote:
> Finally a segmentation violation occurs when __scsi_get_command() tries to
> access dev->host->cmd_pool->gfp_mask.  Not surprising since the host
> structure is gone.

This could still be our (usb-storage) problem.

We're not supposed to release the host structures until after ->release is
called.  I think we're violating that right now.

Add a little bit of debugging (a stub ->release() function that printk's)
and see if the mid-layer really thinks that everything should have been
freed already.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--xgyAXRrhYN0wYx8y
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/BduEIjReC7bSPZARAhmZAJ44By4Wgai4BiVQGmJaCa2K/8WSOwCfRK9q
mASvGAv8oa3tCmhuXqlbJWg=
=2bFE
-----END PGP SIGNATURE-----

--xgyAXRrhYN0wYx8y--
