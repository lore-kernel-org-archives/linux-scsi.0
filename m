From: Michael Guntsche <mike@it-loops.com>
Subject: Re: PROBLEM: 2.6.3 hangs when writing to scsi-dvd
Date: Sat, 21 Feb 2004 11:25:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040221112550.6aec57eb.mike@it-loops.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="pgp-sha1";
 boundary="Signature=_Sat__21_Feb_2004_11_25_50_+0100_3I3=viS0kFjWE995"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [62.116.46.196] ([62.116.46.196]:32275 "EHLO it-loops.com")
	by vger.kernel.org with ESMTP id S261542AbUBUK0f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Feb 2004 05:26:35 -0500
Received: from [192.168.0.150] (helo=roadrunner.comsick.at)
	by localhost with asmtp (Exim 3.36 #1 (Debian))
	id 1AuUKY-0002Ve-00
	for <linux-scsi@vger.kernel.org>; Sat, 21 Feb 2004 11:25:54 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--Signature=_Sat__21_Feb_2004_11_25_50_+0100_3I3=viS0kFjWE995
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

Hi,

> More info:
> on the cdwrite list, somebody reported a similar problem
> (http://lists.debian.org/cdwrite/2004/cdwrite-200402/msg00081.html)

That was me.
Since this now really looks like a kernel related problem I post to this
list.

Looking through the code of growisofs (part of dvd+rw-tools) I noticed
that it only hangs if it calls an SG_IO ioctl with a datalen of 8 or
multiple value (16,24).

There it freezes and I see the following error

Feb 21 10:44:14 roadrunner kernel: Current sr0: sense = 70  4
Feb 21 10:44:14 roadrunner kernel: ASC=1b ASCQ= 0
Feb 21 10:44:14 roadrunner kernel: Raw sense data:0x70 0x00 0x04 0x00
0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x1b 0x00 0x00 0x00 0x00 0x00
Feb 21 10:44:23 roadrunner kernel: SCSI error : <0 0 0 0> return code =
0x8000002
 
If I increase the buflen by 1 if it is (8,16,24) the ioctl returns and
everything works.
Since my knowledge about the SCSI internals is pretty limited Im pretty
sure that this isn't the right fix.

As stated in my mail to the cdwrite-ml removing the dma alignment to 8 byte works too.

This happens with an external DVD-Writer connected via firewire.
Could someone take a look at it and help me please?

Thanks in advance,
Michael

--Signature=_Sat__21_Feb_2004_11_25_50_+0100_3I3=viS0kFjWE995
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANzIx9lrUeNl8Hv8RAkcCAJ4lWZXbD/yc2fdFH3E1+4umB/67SACfeA1b
CeKT62BXuNCCnyiDl7bgHHw=
=m14S
-----END PGP SIGNATURE-----

--Signature=_Sat__21_Feb_2004_11_25_50_+0100_3I3=viS0kFjWE995--
