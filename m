From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] [SCSI] aacraid: Fix invalid bit shifts of DMA address
Date: Fri, 15 Feb 2013 14:50:06 +0000
Message-ID: <1360939806.5374.375.camel@deadeye.wl.decadent.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/ghd26PjgHYaUuKyMVJR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52423 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758244Ab3BOOuT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2013 09:50:19 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Ben Collins <bcollins@ubuntu.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>


--=-/ghd26PjgHYaUuKyMVJR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Commit b5f1758f221e ('[SCSI] aacraid: Fix endian issues in core and
SRC portions of driver') changed the type of the address variable in
aac_src_deliver_message() from u64 to dma_addr_t.  In configurations
with 32-bit dma_addr_t, this results in:

drivers/scsi/aacraid/src.c: In function 'aac_src_deliver_message':
drivers/scsi/aacraid/src.c:410:3: warning: right shift count >=3D width of =
type [enabled by default]
drivers/scsi/aacraid/src.c:434:2: warning: right shift count >=3D width of =
type [enabled by default]

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: stable <stable@vger.kernel.org> # v3.6+
---
This is compile-tested only.

Ben.

 drivers/scsi/aacraid/src.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 3b021ec..129b984 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -407,7 +407,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		fib->hw_fib_va->header.StructType =3D FIB_MAGIC2;
 		fib->hw_fib_va->header.SenderFibAddress =3D (u32)address;
 		fib->hw_fib_va->header.u.TimeStamp =3D 0;
-		BUG_ON((u32)(address >> 32) !=3D 0L);
+		BUG_ON((u64)address >> 32);
 		address |=3D fibsize;
 	} else {
 		/* Calculate the amount to the fibsize bits */
@@ -431,7 +431,7 @@ static int aac_src_deliver_message(struct fib *fib)
 		address |=3D fibsize;
 	}
=20
-	src_writel(dev, MUnit.IQ_H, (address >> 32) & 0xffffffff);
+	src_writel(dev, MUnit.IQ_H, (u64)address >> 32);
 	src_writel(dev, MUnit.IQ_L, address & 0xffffffff);
=20
 	return 0;


--=-/ghd26PjgHYaUuKyMVJR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUR5LHue/yOyVhhEJAQrJOA/+PeA9vnSu4JuMF+2HJJnLWOh2waetxHqo
H6/cHHf4XXwuqVpAji+ts6370KB3ti6DqHMwxtP7Z02E8TImRxRgdCtHfJMOGcEE
QW+fW7//ZN+rLNT8robMP6y+IOb+xje4fShrbYc+TcWCvKSsHuFAI6jo23Mx6sKj
Iez0Yb2CzuttAg5QkmbjEVEU0YhlX/wXoX3KrRIneSJFkLFR8dW92je3o5YAFr1L
582928w+APUZYHdRssCALKQAk53u5G72mYluADzPt2+snkqIT0tYgF5aaaFLDAy0
XnkGWJjeEIdET/C2wHsyIR/dex+SQHKVrJaij4Rzr7jrl5DbRUurzgHODKjK4qzP
5lQLbUf6Ffo4gT3unkhTA6WmdRntDvL4oeXEmVto/LwkkMxIPjz6LibSIc6EzgfE
8NjI+1XoFz81J7wMDxYEMOnloAZVLg1Cs9pKXamyfvHdcKR8qrxkTrwNGJd1amky
xfiG1BTn41yUErVeU7iX3qR8Y8HnzTd+XWbZzikw2btVYFWXakZetJJn5etKdz/t
W1nyIHrqyrief9KRUx9zkq8bHo7bK6XDzNiumaSGKpW18QcLxJFc6zpQodWIgvHH
9+6V1NbXdfcvS+KYRL3UK4H4+pR2r/RoSr4EL2b0Uhh6WgimYtLciQTDkX4uJaod
xOl+1ekFqXg=
=l31z
-----END PGP SIGNATURE-----

--=-/ghd26PjgHYaUuKyMVJR--
