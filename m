From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Mon, 28 Apr 2003 13:19:38 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030428131938.A4255@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <20030426151356.A8697@one-eyed-alien.net> <1051397024.4089.86.camel@mulgrave> <20030426183428.B8697@one-eyed-alien.net> <1051409717.4089.146.camel@mulgrave> <20030427023517.A15212@one-eyed-alien.net> <1051458107.2427.25.camel@fuzzy> <20030427125237.A23693@one-eyed-alien.net> <3EAD7B86.8060300@rogers.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:63250 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S261265AbTD1UH2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2003 16:07:28 -0400
Content-Disposition: inline
In-Reply-To: <3EAD7B86.8060300@rogers.com>; from tluben@rogers.com on Mon, Apr 28, 2003 at 03:05:42PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <tluben@rogers.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 03:05:42PM -0400, Luben Tuikov wrote:
> Now, you've been talking about the Data-Out buffer size.
> This is either ALLOCATION LENGTH (normally bytes), or
> TRANFER LENGTH (READ/WRITE, normally blocks).

Now we're making progess.

> So to repeat what the standards say and what SCSI Core
> does: sr_bufflen, request_buflen, buflen *is* the
> Expected (maxumum) Data Tranfer Length:
> 	- when it means Allocation Length it is the
> maximum available space (e.g. IQUIRY, Request Sense),
> (The transport CANNOT write more data than this!)
> 	- when it means Transfer Length it is the
> Expected Data Transfer Length (READ/WRITE), and I say
> ``expected'' less any End Of Media or similar errors pop up,
> (i.e. number of blocks from CDB * block_size =3D this value).

So, to paraphrase and make certain I understand:  For a certain class of
commands, buflen is the ALLOCATION LENGTH.  Right now, we guarantee that
this matches the 'expected transfer length', but that's only by convention.

For the other class of commands, it's a TRANSFER_LENGTH, which we guarantee
to be the 'expected transfer length'.

You know, it occurs to me that we're talking in circles.  The only reason
this is an issue is because usb-storage re-writes commands into something
which is more acceptable -- if we eliminate this re-writing with a patch
similar to Andries', the problem goes away.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

A:  The most ironic oxymoron wins ...
DP: "Microsoft Works"
A:  Uh, okay, you win.
					-- A.J. & Dust Puppy
User Friendly, 1/18/1998

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rYzaIjReC7bSPZARAj0FAKC8/KGG9iJt/RPNOTR7fJbKc/7JWgCcCQLa
zRYgSwb7K2dLd5XuKXREPVo=
=+EfV
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
