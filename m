From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Advansys regression between 2.6.23.8 and 2.6.24.2
Date: Thu, 14 Feb 2008 16:10:24 +0100
Message-ID: <20080214161024.2a0c0f17@crazy>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GHT6_tD2=a954FIr88dF1P+";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.191.46.45]:3793 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759368AbYBNPl1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 10:41:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: gregkh@suse.de, chrisw@sous-sol.org

--Sig_/GHT6_tD2=a954FIr88dF1P+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

I just upgraded my system from 2.6.23.8 to 2.6.24.2, and when loading
the advansys module, it paniced, with "Kernel BUG at advansys.c:6335".
The issue is that the overrun buffer is not aligned on 8 bytes.

The patch 7d5d408c77cee95d1380511de46b7a4c8dc2211d [1], by FUJITA
Tomonori, which has been committed a few days ago, fixes the issue. The
commit log says that the structure should be 8-byte aligned on 2.6.23
and 2.6.24, but it doesn't seem to be the case in 2.6.24. I have not
identified which commit broke the driver, but I confirm that Tomonori's
patch fixes the problem.

I've added Greg and Chris as Cc:=C2=A0because such a patch should probably
be included in the next -stable of 2.6.24, but of course Tomonori and
Matthew are best placed to say what should be done.

Thanks,

Thomas

[1]
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D7d5d408c77cee95d1380511de46b7a4c8dc2211d
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/GHT6_tD2=a954FIr88dF1P+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtFnj9lPLMJjT96cRAmgpAJ9ZFIrDiubug0TObXc7i27T17DPaQCgm/yR
z8ivrcfL0wTQEOGwQ5IenBk=
=7u9e
-----END PGP SIGNATURE-----

--Sig_/GHT6_tD2=a954FIr88dF1P+--
