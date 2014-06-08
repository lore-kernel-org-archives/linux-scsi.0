From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH RESEND] [SCSI] bfa: Fix undefined bit shift on big-endian
 architectures with 32-bit DMA address
Date: Mon, 09 Jun 2014 00:48:04 +0100
Message-ID: <1402271284.23860.51.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9cLTyv6jzp6zbSBLt8kP"
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, "M:Anil Gurumurthy" <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-9cLTyv6jzp6zbSBLt8kP
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
Resending yet again, this time with current maintainer addresses.

Ben.

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
One of the nice things about standards is that there are so many of them.

--=-9cLTyv6jzp6zbSBLt8kP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5T2Oee/yOyVhhEJAQogTA/+LrzOqbflKNyFoUZAmSLn21hzk2EBRXus
QRMYTr1CaScvi9QJBtShU7QQprMsJ0LoSps4Y0MVTYMbQcyr4MddDSy2cJ/v4I64
tIqkVRxd5C1zMRdgag49NSuVtACxOrNXGP6ND3kiDDXlg4LPD1kI5Z4ZzJ+7UYKf
qPQpzgX2HbWIdBzt0JbDQ53EUJ4CNg6fAQJ3r7EX7Tb64NynahHFeC8E+dBID5rL
cNjZGEoAteShao9msblwy5V8mzk2CJHpMoKhEOAxm/Z6YjX161zOUFf5XavxclJq
jlPREm9nn5BcV717zq/E85py9Il9lNE8DnYGdsfbrEFh+fxnoXyc/5r16YZ0BXR9
1RBdyPnVC8IQs5M/+jkJxSSBbnx47bXMStIe743S8z59i5EzD/m3fXaNyjw3pA7t
ZYNJtp7tFM5mnhboKX8MjqqrJLzczdXoPpyLXqEKBisNe/DLQGskn7xAGFY3+4xv
GJa054iqDRFRKuYnjNdlmWfm8SbBJMzAteSWDXVDcvR2eKTNn77nr0CD3TxIYYvZ
Dc8y95/3VCcvEd3BliAU6rsLvFJaylLdEvg7fIEeFswjCcWyWcvvgnd1XxEsD6++
Yt/XO1cxgEWvi1IpSihMChJ8lW+4RFVHlnBB5wGWJpub0FRq9t+0um7Fg+svBJKn
hVvAUwl/k3Q=
=jjXl
-----END PGP SIGNATURE-----

--=-9cLTyv6jzp6zbSBLt8kP--
