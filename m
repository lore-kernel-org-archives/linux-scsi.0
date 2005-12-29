From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Thu, 29 Dec 2005 23:02:45 +0100
Message-ID: <200512292302.50743@bilbo.math.uni-mannheim.de>
References: <1135801791.9541.12.camel@gateway.markschaefer.org> <200512290845.17192@bilbo.math.uni-mannheim.de> <62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1988372.NJeC3INGhi";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:37601 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1751054AbVL2WC6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Dec 2005 17:02:58 -0500
In-Reply-To: <62187.24.3.12.198.1135893081.squirrel@www.markschaefer.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark@markschaefer.org
Cc: linux-scsi@vger.kernel.org

--nextPart1988372.NJeC3INGhi
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Mark Schaefer wrote:
>Eike,
>
>I think I've resigned myself to the fact that it won't boot.  I've done a
>bit of digging by directly sending commands to the unit.  I'm not sure why
>I can't force scsi_scan to do a REPORT_LUN on it through the Black List,
>but what I know is that it reports luns as 0x40...00 - 0x40...MAX_LUNS -
>they are reported as flat addressing, according to the SCSI Architecture
>Manual.
>
>Since TYPE_RAID implements a standard (albeit deprecated), it might
>actually be worth trying to create a driver for it.  The real question I
>have is whether I could get at the drives simply by masking the LUN's like
>the cpqfc driver does, or whether something like BLIST_SPARSE_LUNS would
>do the trick, or maybe even a new blasklist entry like
>BLIST_FLAT_LUN_ADDRESSING.
>
>Here's a quote from cpqfcTSworker.c:
>// e.g., the Compaq RA4x00 f/w Rev 2.54 and above may report
>// LUNs 4001, 4004, etc., because other LUNs are masked from
>// this HBA (owned by someone else).  We'll make those appear as
>// LUN 0, 1... to Linux

I've looked around a bit in the LUN code some month ago as I was trying to =
get=20
this to a state where it was sort of working. This code is as horrible as t=
he=20
rest of this driver, so I didn't really got the point what of this strange=
=20
stuff is really needed and what was just caused by code monkeys on drugs.

I now got a card, but a 5121, so I can't test this stuff. And I don't have=
=20
such an array :)

>I'm not sure what the direction of Linux is at this point, but there are a
>lot of RA4x00's out there for cheap and they (at least initially) seemed
>like a good entry-level FC RAID system.

Now the driver is buried and all the people with such hardware come out of=
=20
their holes. Fascinating :)) I was thinking about a list related only to=20
these things and/or writing a FAQ for this. What do the other people around=
=20
think about this? MKP?

>Also, I'm not sure how strange of=20
>a beast the RA4x00 is.  If it's a one-off, maybe I could create a specific
>driver for it that acts as a LUN masker.  If there are more, it may make
>sense to make the changes necessary to deal with flat addressing.
>
>At this point, I'm convinced that it would be a minor change to at least
>the scsi_scan code to deal with TYPE_RAID.  I'm a bit more concerned about
>how widespread a change like flat addressing would be.

I'm not really familiar with the low level SCSI code. James? Christoph?

Eike

--nextPart1988372.NJeC3INGhi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDtF0KXKSJPmm5/E4RAjWZAKCSBKSAF9BPNqD+V6sbWM57ttl5igCfRvq5
uPxBGlVnGgICkYO6nGvwL84=
=pxus
-----END PGP SIGNATURE-----

--nextPart1988372.NJeC3INGhi--
