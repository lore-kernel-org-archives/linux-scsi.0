From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5/8] [SCSI] tgt: Pass pointers to virt_to_page(), not
 integers
Date: Sun, 27 Oct 2013 21:53:13 +0000
Message-ID: <1382910793.2994.49.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-L81O6WD332T/xPHCNaOV"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--=-L81O6WD332T/xPHCNaOV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/scsi_tgt_if.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_tgt_if.c b/drivers/scsi/scsi_tgt_if.c
index 6209110..7199753 100644
--- a/drivers/scsi/scsi_tgt_if.c
+++ b/drivers/scsi/scsi_tgt_if.c
@@ -286,7 +286,7 @@ static int uspace_ring_map(struct vm_area_struct *vma, =
unsigned long addr,
 	int i, err;
=20
 	for (i =3D 0; i < TGT_RING_PAGES; i++) {
-		struct page *page =3D virt_to_page(ring->tr_pages[i]);
+		struct page *page =3D virt_to_page((void *)ring->tr_pages[i]);
 		err =3D vm_insert_page(vma, addr, page);
 		if (err)
 			return err;


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-L81O6WD332T/xPHCNaOV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2LSee/yOyVhhEJAQr/Bg/9GSUjk2OMlTJwZuz0Q/G41sR23SyHJ0sH
5ntFCj7pcAKSfHdqSVyfeDBhypGG4maQOpSWss7gWd0ST2MsXtXINVBC0MnTGS6w
aYmjJQHt1TSZz5mnytm06Jf7ukkt3l0hC0e8FWXWlExRPRLFmXrwI6fTD1Emd9JW
GUS3DM4c6NYgnN5nSUgYKvjhm/JT668b38wIa/rR9NLMdmlRmj9guh20RkA4arN3
DNQ5KdEUgxkdZsmoo0KNr38/GA3vz1yPDFJn6dW8XWjTC8Y37Pz7tIaJfRuHm1aC
6k1dc0KOAGCZ3BytGtdyhzA7YmyvYzpAYV5KrrdKXj9zF3Sl7Hc0k0VjFU4MfAFQ
1ZcEEX+vXOCGE3IaW6pFPVDwNrzHKuk1RoDKormIZnhqcfS83ua6zym+Trplpe3d
d4eiOjYeyRRDUpHuyhNgM7g30sbbt6Uh5zEHbKi0md5tqNPuGnQjzP+tX0rK9o2S
V8A4EFEkq5YVqjMZU6z5lYscC7zsqfO0YKz+s265k0dwABRHvifvvJPWVqTNU4BU
sBkwb7tjLsuTzGt45WsJnJhZfJVJP2n7B08m/xQWsgbNsRgGf14rFkrhozuRXr8H
TxPrQo7gAfym3raReBuq+YAOjqplHO1FGfqTHzdZLBuR0pBx1FAlDOpYpcXsRPfE
RdM3I2cNRFo=
=E4ol
-----END PGP SIGNATURE-----

--=-L81O6WD332T/xPHCNaOV--
