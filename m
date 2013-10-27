From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] bfa: Fix undefined bit shift on big-endian
 architectures with 32-bit DMA address
Date: Sun, 27 Oct 2013 20:51:42 +0000
Message-ID: <1382907102.2994.34.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-vrD4u+7RnK2J/GTAvr4p"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59215 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542Ab3J0Uv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Oct 2013 16:51:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org


--=-vrD4u+7RnK2J/GTAvr4p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

bfa_swap_words() shifts its argument (assumed to be 64-bit) by 32 bits
each way.  In two places the argument type is dma_addr_t, which may be
32-bit, in which case the effect of the bit shift is undefined:

drivers/scsi/bfa/bfa_fcpim.c: In function 'bfa_ioim_send_ioreq':
drivers/scsi/bfa/bfa_fcpim.c:2497:4: warning: left shift count >=3D width o=
f type [enabled by default]
    addr =3D bfa_sgaddr_le(sg_dma_address(sg));
    ^
drivers/scsi/bfa/bfa_fcpim.c:2497:4: warning: right shift count >=3D width =
of type [enabled by default]
drivers/scsi/bfa/bfa_fcpim.c:2509:4: warning: left shift count >=3D width o=
f type [enabled by default]
    addr =3D bfa_sgaddr_le(sg_dma_address(sg));
    ^
drivers/scsi/bfa/bfa_fcpim.c:2509:4: warning: right shift count >=3D width =
of type [enabled by default]

Avoid this by adding casts to u64 in bfa_swap_words().

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org
Fixes: f16a17507b09 ('[SCSI] bfa: remove all OS wrappers')
---
 drivers/scsi/bfa/bfa_ioc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 90814fe..d5b3f66 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -72,7 +72,7 @@ struct bfa_sge_s {
 } while (0)
=20
 #define bfa_swap_words(_x)  (	\
-	((_x) << 32) | ((_x) >> 32))
+	((u64)(_x) << 32) | ((u64)(_x) >> 32))
=20
 #ifdef __BIG_ENDIAN
 #define bfa_sge_to_be(_x)

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-vrD4u+7RnK2J/GTAvr4p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm183ue/yOyVhhEJAQrNDQ/+NgGVcv/9s+xhpN+XbszepAfJebNbt4Jx
Q/WG3Xf3FfqAgydZj1/3bN4KqKXdG2kaWBgJMbODxHujXouRLzR0BVGdSmCyTKGt
7fsoc5+vE3YzpImPW1YxZCUISxSIOg4WVqj0MIaKkxtAHN14bg55Ap+5OCeaEFrM
7zP23TR0ONzeWcE4YvjcB1XG7pMKy+TPqdBdZqtUx9wboBqnBMEtOAAOhGOOY54r
3iR+DuxbRqBAQ6h6fYWiorIcF7VAoULxu2HMxJoHdNirKtEy7DbAlVputrHb54Im
F0lVDs80eufzfGkvK+hSrBB/e1AuaAtkObFs4f+HNCLwAAcZwexpV6ZYTSEdwgiN
FwjgdJkyboJrJirIOwWunGX1OP52i7jterxqpzUDrw9ZNxzrhuzD4PvsfqBDYagx
Xa5TB+y/ug1VyGRG85F5yimVYnGZI2UgM9nwQCiWN9ai6HEPxlMDyOqv6JhT0X46
0rscRlpxYC6gi7rGQxR+ZN0m2ko2cHOYevo77e2NOGVXsbKh3OZdxsgts2hwCSEu
HX8hNk3fMqw83R8I3O7GVmHNKmE3actyS92agqJQqRgDgR/xBTYtuKjdrY97065R
lyF7fjJ666JlLXIHB5BwUWIYsGUYj0Gwr5SzBO2MCEANY8TIoSNjS+OrTqjXxQbG
2WAvaDOFMmM=
=vl0u
-----END PGP SIGNATURE-----

--=-vrD4u+7RnK2J/GTAvr4p--
