From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: How to write a transparent SCSI bridge?
Date: Wed, 30 Jul 2003 12:13:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030730121310.C30339@one-eyed-alien.net>
References: <Pine.LNX.4.44L0.0307301025050.2868-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="gr/z0/N6AeWAPJVB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:55570 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S273309AbTG3TNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2003 15:13:12 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0307301025050.2868-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Wed, Jul 30, 2003 at 10:38:38AM -0400
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>


--gr/z0/N6AeWAPJVB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2003 at 10:38:38AM -0400, Alan Stern wrote:
> What I have in mind is something that would receive CDBs and data over a=
=20
> USB link and would forward them to a standard SCSI device (or more=20
> accurately, a host adapter driver), and relay the replies back.

CDBs?  Just the command bytes, then?  Why not send more of the struct
scsi_cmd?

> 	1. The SCSI protocol isn't designed for easy bridging.  My driver=20
> would have to figure out the direction of the data flow for each command=
=20
> by examining the CDB and also figure out the amount of data.  Since some=
=20
> commands encode the amount as a number of blocks, and since the blocksize=
=20
> is device-dependent, this isn't a simple task.  Also, it might be=20
> impossible to handle vendor-specific commands.


> 	2. My driver might require some very large I/O buffers.  It
> wouldn't know beforehand how large a data transfer was going to be, and
> the entire buffer must be present and filled before the command can be
> forwarded to the SCSI device.

If you sent more of the struct scsi_cmnd, this wouldn't be an issue.

> 	3. I know very little about how the block layer works.  Somehow my=20
> driver would have to insert its requests into the appropriate queue.

The loopback driver does this -- you might want to see how it does it.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

You were using cheat codes too.  You guys suck.
					-- Greg to General Studebaker
User Friendly, 12/16/1997

--gr/z0/N6AeWAPJVB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE/KBjGIjReC7bSPZARAr0MAJ42wkUTtAZjHLA/uThrXLHSEGAx4ACgnYkv
r2luYKD/f31Z1LdGT7WOk1I=
=q6om
-----END PGP SIGNATURE-----

--gr/z0/N6AeWAPJVB--
