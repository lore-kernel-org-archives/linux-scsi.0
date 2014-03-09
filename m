From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] bfa: Replace large udelay() with mdelay()
Date: Sun, 09 Mar 2014 04:04:18 +0000
Message-ID: <1394337858.2861.72.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-sjmAM6feAtbFP8k5BMyS"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49493 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752287AbaCIEE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Mar 2014 23:04:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, linux-scsi <linux-scsi@vger.kernel.org>, Vagrant Cascadian <vagrant@debian.org>


--=-sjmAM6feAtbFP8k5BMyS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

udelay() does not work on some architectures for values above
2000, in particular on ARM:

ERROR: "__bad_udelay" [drivers/scsi/bfa/bfa.ko] undefined!

Reported-by: Vagrant Cascadian <vagrant@debian.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/bfa/bfa_ioc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 65180e1..50c75e1 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -7006,7 +7006,7 @@ bfa_flash_sem_get(void __iomem *bar)
 	while (!bfa_raw_sem_get(bar)) {
 		if (--n <=3D 0)
 			return BFA_STATUS_BADFLASH;
-		udelay(10000);
+		mdelay(10);
 	}
 	return BFA_STATUS_OK;
 }

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-sjmAM6feAtbFP8k5BMyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUxvoQue/yOyVhhEJAQovXA/+JkkUqzC7/GjbtuaaO8HtunHcSlE19h5K
Qwv+PMZfAHGFAIm1ZQUqbWJ1X5YQTmuFojCbQEv/xzDaH1H6axnI2irduApqEO4T
80ONqekFy7ODoW8F1b6jjuUVpG8ceF4aga8W1oWZ5Tu5v/vKFM1ON6q65jaRS6qY
MWLhoQcElXwiE19PhwjHH2jVquqn45zFpgjc3EElLLivjIoL67hIZE9gdXymIxa4
wrg+yJA6uDuXOWREBBghFolBrUpEJkluW0IQc9SX1UMz4MpSOCgy+SDFs67aTzGk
B0BLcXUrDqjz0v5f/ayj9QuE8hC1gFaGBdmOvUcYGIPFWXUWq9zmNZlcQUIRiYCq
pAYBwqggYUhH4d/Crg9ZP6YAyjilR/J1ZlRjPvXPBruqjBmnD4RF2MH5kuBPR2uB
jhAf89s+tNQuqQdYExD/W2RAexlrAcy6fl+T7iEc13mNNzqD6f9IdO+AdbCIkk2a
26CRS3AgD1IHL1rAOp31KU3hSa3BAIV7DzFL6g1ooDe9WgfT0uO2All03MwhsyjR
EU1uOvboPX1eYzz34fgGcKzsksBISp4vxF6IoZdscmjCPm21Gs0coOzU2giSxebB
xnkR28+y55VoY7CNJgTQUXteOAuszrUiMoCEkhhuE9i8Su8Nnc/GcvWN13ky1IiD
eFptRI35hrY=
=5XdR
-----END PGP SIGNATURE-----

--=-sjmAM6feAtbFP8k5BMyS--
