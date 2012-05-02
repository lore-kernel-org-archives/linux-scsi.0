From: Stefan Bader <stefan.bader@canonical.com>
Subject: Kernel oops in sym_int_sir
Date: Wed, 02 May 2012 16:25:00 +0200
Message-ID: <4FA143BC.2010702@canonical.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig8EC0A656348579D86C92CEE4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50811 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2EBOZF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 May 2012 10:25:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Stefan Bader <stefan.bader@canonical.com>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8EC0A656348579D86C92CEE4
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

While looking at a bug report [1] I found that the immediate cause of the=
 crash
was in that specific case the reference cp->cmd for a printk:

/*
  * The device didn't switch to MSG IN phase after
  * having reselected the initiator.
  */
 case SIR_RESEL_NO_MSG_IN:
         scmd_printk(KERN_WARNING, cp->cmd,
                         "No MSG IN phase after reselection\n");
         goto out_stuck;

Unfortunately cp (that is returned by sym_ccb_from_dsa()) is NULL. This p=
robably
is as old as 2.6.24 when this patch added the scmd_printk:

commit 3fb364e089e05c35ead55a08d56d3004193681f6
Author: Matthew Wilcox <matthew@wil.cx>
Date: Fri Oct 5 15:55:10 2007 -0400

    [SCSI] sym53c8xx: Use scmd_printk where appropriate

A quick research looks like it might be other cases where this happened[2=
].
Maybe more often (or solely?) when running in a VM (KVM). I even found so=
me post
that looks like it tries to fix just this problem[3].

However without more knowledge about that driver it could also be a probl=
em in
the hardware emulation so that normally cp =3D=3D NULL should never happe=
n. Or it
might be that the emulation is just running sufficiently "different" to c=
ause
races to happen which never would be observed on real hardware.

Would [3] still make sense?

Thanks,
Stefan


[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/992328
[2] http://www.mail-archive.com/kvm@vger.kernel.org/msg08927.html
[3] https://lkml.org/lkml/2010/11/18/495


--------------enig8EC0A656348579D86C92CEE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJPoUO9AAoJEOhnXe7L7s6jFtAQAM3ffrcFuZkV18vOKXUGFXir
8vCSDz6CI+i7cqskXp3DcD50OxvU8snChHRF8f7vqkekia0m5OBMvdEN8sS9g6la
UYZg9ABoYhoMtmrcaa5UlJEbA8clHmQX4iIEfNrlDpEKFFpj2TqXoWmtzZwvWh+v
vfj1pAoRT195W4GqqhNCcF68OdO7j7F6u9hgqkiNXA2YSrIv0Y0LmC1b/nOUsrDf
dPDr3mQQZ6oMyImUJYK09ENP1X516Rfo5SI+BBfeb3oXOPHiJU0rkcXyF9Qg4hcU
McKBjNlypIbjz+Fqdyl7BbA0BPgNiMvHDJVqBs16Z2InTX0f1zHxiTo/GeY3MTC+
DdjZYo304KW/3xN6v0eYGu7JWK/zAWEEx9Ko4QoAogspW/O9ZhgKk+rkD0M8/x0T
k6K+FFSetKDWXwYC/o8kUA7RpTCpVaJNl5uWtKrOD/gE4IP2GmSvomLbAHEZ3Bah
uAezJGhNBrInDa28XnsZHDm1ijtrKkyb35TeLRi+YZnzGsHRgcA1GfIuQeki/kuZ
u9q+LV4o63mo8/lvn/MWN8eQVqVMiWnCABjHotu3tJfM8SVTMyzbQ2f9iHZqCyvp
kKlPia0oixeC9rTNd6oPFIVrtrmz134qm9bRDRcPpM5DlQW1eN1V71pfbdDoBkuM
iicmAhrTe4HPMRvnBb8C
=M68O
-----END PGP SIGNATURE-----

--------------enig8EC0A656348579D86C92CEE4--
