From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Thu, 24 Apr 2003 19:12:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030424191238.E10511@one-eyed-alien.net>
References: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="zjcmjzIkjQU2rmur"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:51467 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S262856AbTDYCAj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Apr 2003 22:00:39 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304250043.h3P0hPH01942.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Fri, Apr 25, 2003 at 02:43:25AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: stelian@popies.net, James.Bottomley@steeleye.com, afafc@rnl.ist.utl.pt, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, pwkpete@yahoo.com, stern@rowland.harvard.edu


--zjcmjzIkjQU2rmur
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2003 at 02:43:25AM +0200, Andries.Brouwer@cwi.nl wrote:
> Are there any objections against viewing sr_bufflen
> as the amount of actually available buffer space
> (and thus potentially different from the transferred amount)?

YES!  I MOST DEFINITELY OBJECT!

If you look through the linux-scsi archives, you'll see I've discussed this
before.  Apparently 'real' SCSI busses don't have this problem, but
usb-storage needs to know (in advance) how much data is going to be
transferred by a given command.

We used to have a tremendous amount of code which analyized the command in
an attempt to 'deduce' the correct answer.  It was right most of the time,
and failed completely on any vendor-specific command.

If you think about it, it's not really possible to figure out how much data
is going to be transfered based on the command bytes alone.  You may need
to know information such a the block size of the device, the device type,
etc.

Originally, I proposed adding a field to indicate how much data is actually
supposed to be transferred.  People objected to adding (including, I think,
Linus), and the general consensus was that sr_bufflen should indicate the
amount of data to be transferred.  The originator of the command was
responsible for making certain that there was actually that much buffer
available.

Short answer: usb-storage needs to know what the expected transfer amount
is.  The agreed-upon solution was to make sr_bufflen the expected transfer
amount instead of the available buffer size.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--zjcmjzIkjQU2rmur
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qJmWIjReC7bSPZARAvcZAKDOaQA6FZzLtSFLH7KokFUIWijLkgCgtaWT
GdSxoHNeO229835+CkOeQJM=
=QiZT
-----END PGP SIGNATURE-----

--zjcmjzIkjQU2rmur--
