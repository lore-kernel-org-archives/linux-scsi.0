From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [example PATCH - not for applying] exclude certain commands
Date: Sat, 26 Apr 2003 18:39:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030426183957.C8697@one-eyed-alien.net>
References: <UTC200304262144.h3QLiAt04450.aeb@smtp.cwi.nl> <1051396197.1768.81.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:34568 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263199AbTD0B1s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Apr 2003 21:27:48 -0400
Content-Disposition: inline
In-Reply-To: <1051396197.1768.81.camel@mulgrave>; from James.Bottomley@SteelEye.com on Sat, Apr 26, 2003 at 05:29:55PM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Andries.Brouwer@cwi.nl, greg@kroah.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 26, 2003 at 05:29:55PM -0500, James Bottomley wrote:
> This looks fine to me.  Originally, sr_bufflen was exactly that (because
> all SCSI LLDs have to be prepared to transfer fewer than the specified
> number of bytes anyway, since that's required by the spec).  I believe
> only USB needs this to be set to the actual command length (and further
> require that we ensure that the device *will* transfer exactly
> this...that's to some extent the origin of the INQUIRY problems), so the
> change should be small.

This is a common misconception.  usb-storage does not need to know, in
advance, exactly how many bytes will transfer.  It does, however, need to
know exactly how many bytes are being requested for transfer.

There's a subtle difference there.  usb-storage can handle the case of
underrun or overrun properly.  But there are USB<->[SCSI|ATA|whatever]
bridges which can't handle a discrepancy between expected transfer length
and actual transfer length when no error was detected.

I can give examples, but it's confusing and not really relevant unless
someone wants to know.

There are also broken devices which are specifically broken with respect to
the INQUIRY command for length !=3D 36, but that's a separate issue to a
certain degree.  These are really two separate problems.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

YOU SEE!!?? It's like being born with only one nipple!
					-- Erwin
User Friendly, 10/19/1998

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+qzTtIjReC7bSPZARAiAIAJ47kzenBDh+peqeLVZmfmccsNaVqgCfdLMv
tVQJoZVEdyrrdmqrgRUKfto=
=+1ak
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
