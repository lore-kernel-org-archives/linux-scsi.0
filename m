From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for Nov 27 (scsi/aha1542)
Date: Tue, 27 Nov 2018 21:41:24 -0800
Message-ID: <1543383684.3518.2.camel@HansenPartnership.com>
References: <20181127152539.55426063@canb.auug.org.au>
         <ef9090cf-e86a-7fd0-dfa9-6810eaaf7e65@infradead.org>
         <20181128153847.08ead1c9@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-INqxb6r8LVHJxEOwNF5S"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181128153847.08ead1c9@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>, Randy Dunlap <rdunlap@infradead.org>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org


--=-INqxb6r8LVHJxEOwNF5S
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-11-28 at 15:38 +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> On Tue, 27 Nov 2018 20:14:58 -0800 Randy Dunlap <rdunlap@infradead.or
> g> wrote:
> >=20
> > On 11/26/18 8:25 PM, Stephen Rothwell wrote:
> > > Hi all,
> > >=20
> > > Changes since 20181126:
> > >  =20
> >=20
> > on i386:
> >=20
> > ERROR: "__udivdi3" [drivers/scsi/aha1542.ko] undefined!
> >=20
> > somewhere in aha1542_interrupt() according to objdump.
>=20
> Presumably caused by commit
>=20
>   1794ef2b150d ("scsi: aha1542: convert to DMA mapping API")

Yes, it's because dma_addr_t can be u64 on pae systems but
isa_virt_to_bus only ever returns unsigned long (because an ISA
physical address can only be 24 bits).

I think this is the fix; there doesn't seem to be much point converting
to do_div given all the limitations.

James

---

diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index a9c29757172f..afb693d7b44f 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -325,7 +325,7 @@ static irqreturn_t aha1542_interrupt(int irq, void *dev=
_id)
 			return IRQ_HANDLED;
 		};
=20
-		mbo =3D (scsi2int(mb[mbi].ccbptr) - aha1542->ccb_handle) / sizeof(struct=
 ccb);
+		mbo =3D (scsi2int(mb[mbi].ccbptr) - (unsigned long)aha1542->ccb_handle) =
/ sizeof(struct ccb);
 		mbistatus =3D mb[mbi].status;
 		mb[mbi].status =3D 0;
 		aha1542->aha1542_last_mbi_used =3D mbi;
--=-INqxb6r8LVHJxEOwNF5S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iHUEABMIAB0WIQTnYEDbdso9F2cI+arnQslM7pishQUCW/4qhAAKCRDnQslM7pis
hfOxAQDz5qxC4lFi29t44zMABjdsUIB0s3NkLl3XIr3Okx6nMwD6AhqqSMLVAMOc
ltgP1Qm/FVEspHfkd4yMFj/ygWexeFY=
=X0+P
-----END PGP SIGNATURE-----

--=-INqxb6r8LVHJxEOwNF5S--
