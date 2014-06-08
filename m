From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND] [SCSI] bfa: Fix undefined bit shift on big-endian
 architectures with 32-bit DMA address
Date: Sun, 08 Jun 2014 23:33:25 +0100
Message-ID: <1402266805.23860.40.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hELWPcBhKFkwn6IUPGZ9"
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Gurumurthy <agurumur@brocade.com>, Vijaya Mohan Guvva <vmohan@brocade.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-hELWPcBhKFkwn6IUPGZ9
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
index 2e28392..a38aafa0 100644
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
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-hELWPcBhKFkwn6IUPGZ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5Tku+e/yOyVhhEJAQqSGQ//UMcLmoh3ZhkNT5PnMKj0NZWxlzdGfcyW
CLGyVpgpV0+CYZH/2W+6Y5l1h7G/hc5eUZAOf6dR7c53C5ZmdeIdDLfL8eyltVn3
PGsN6tv91Wwjh5VW0FgNerSTD/IEkCKoIpqX4WF2Z2OkRlJU2WA+sjKdTeJUiwI4
vhnOorojb+PGT3PO6M3e3J1YhdLwqsL+wsbhIwktWFyvA5ZuW0X9IPZoQlTTNOj+
JzhEpXIAw0K1dRRQvLwHvO1tjLuckLoD4f88WuROfBfsq5LTiTZ1y0p4pgAKYSh/
27zmoL+T8wiaVaPtpF71HsH8w/cDlNfUq/OLePA2f8JVFSlnXFE+1UWEpXyT47OX
hb59QF53wsZeBcUyluO0s5tD+UfcpBjxGw4gBc9AqIyfauj9faMrgV4upTJOGhlo
i6II2U008Nr4rEM42DniBi1p2LTfh8W+C3g6jrDVRtabEMMX4TtqIvsyoY1y7ThO
t8B3DNbpr35o4lHFI+OOz0IsoFxSZN0IaBGchyDxL3ww83ya8zxt4rI9FmltgH44
B6Cqqfg8I5Y3LP9XIliOKme07cBxxbDm5WquAfw1DTMgv8FNuOYN2TkARTmKYWES
e4WEBU1q3+pJU7p6LojokK5k5pmCELXZwts+vo6my9lpfSLdCVktlm+NmJIJONkI
BOvWQJ6B6PI=
=Kzhg
-----END PGP SIGNATURE-----

--=-hELWPcBhKFkwn6IUPGZ9--
