From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: return value warnings about scsi_add_host, anything in progre ss?
Date: Mon, 7 Feb 2005 16:10:22 +0000
Message-ID: <20050207161022.GZ20386@parcelfarce.linux.theplanet.co.uk>
References: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:54932 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261171AbVBGQK1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 11:10:27 -0500
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E570366267A@exa-atlanta>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ju, Seokmann" <sju@lsil.com>
Cc: 'Alexander Stohr' <Alexander.Stohr@gmx.de>, linux-scsi@vger.kernel.org

On Mon, Feb 07, 2005 at 08:47:36AM -0500, Ju, Seokmann wrote:
> On Monday, February 07, 2005 4:40 AM, Alex wrote:
> > is anything going to happen with the below listed locations?
> > (Some are part of the USB system, one is in block device, rest is S=
CSI.)
> > Note that a few locations do still lack the "XXX" comment.
> >=20
> > I am asking because i am seeing ther respective warning
> > anytime when i am checking the quality of a new linux kernel.
> > And now i am wondering if there is already some work in progress
> > or already pending in the queue for submitting to bitkeeper.
>=20
> Hi Alex,
>=20
> Can you please elaborate the issue and what you'd expect from it?

include/scsi/scsi_host.h:extern int __must_check scsi_add_host(struct S=
csi_Host *, struct device *);

If you have gcc 3.4 or higher, __must_check is defined as:

include/linux/compiler-gcc3.h:#define __must_check __attribute__((warn_=
unused_result))

`warn_unused_result'
     The `warn_unused_result' attribute causes a warning to be emitted
     if a caller of the function with this attribute does not use its
     return value.  This is useful for functions where not checking the
     result is either a security problem or always a bug, such as
     `realloc'.

ie these drivers need to be fixed to use the return value from scsi_add=
_host().

I'm not sure why returning the result doesn't count as a "use" of the r=
esult
(in the case of megaraid).

> Thanks,
>=20
> Seokmann
> LSI Logic Corporation.
>=20
> > -----Original Message-----
> > From: Alexander Stohr [mailto:Alexander.Stohr@gmx.de]
> > Sent: Monday, February 07, 2005 4:40 AM
> > To: linux-scsi@vger.kernel.org
> > Subject: return value warnings about scsi_add_host, anything in pro=
gress?
> >=20
> > Hello,
> >=20
> > is anything going to happen with the below listed locations?
> > (Some are part of the USB system, one is in block device, rest is S=
CSI.)
> > Note that a few locations do still lack the "XXX" comment.
> >=20
> > I am asking because i am seeing ther respective warning
> > anytime when i am checking the quality of a new linux kernel.
> > And now i am wondering if there is already some work in progress
> > or already pending in the queue for submitting to bitkeeper.
> >=20
> > -Alex.
> >=20
> > PS: i am not subscribed to that list, so please CC me on replys.
> > Hunting answers via the list archives is not always successful.
> >=20
> >=20
> > ./drivers/usb/image/hpusbscsi.c:112:    scsi_add_host(new->host,
> > &intf->dev); /* XXX handle failure */
> >=20
> > ./drivers/usb/image/microtek.c:812:     scsi_add_host(new_desc->hos=
t,
> > NULL);
> > /* XXX handle failure */
> >=20
> > ./drivers/scsi/arm/ecoscsi.c:208:       scsi_add_host(host, NULL); =
/* XXX
> > handle failure */
> >=20
> > ./drivers/scsi/megaraid.c:4890: error =3D scsi_add_host(host, &pdev=
->dev);
> >=20
> > ./drivers/scsi/aic7xxx/aic7xxx_osm.c:1732:      scsi_add_host(host,
> > (ahc->dev_softc ? &ahc->dev_softc->dev : NULL)); /* XXX handle fail=
ure */
> >=20
> > ./drivers/scsi/aic7xxx/aic79xx_osm.c:2068:      scsi_add_host(host,
> > &ahd->dev_softc->dev); /* XXX handle failure */
> >=20
> > ./drivers/scsi/pcmcia/fdomain_stub.c:226:    scsi_add_host(host, NU=
LL); /*
> > XXX handle failure */
> >=20
> > ./drivers/scsi/pcmcia/nsp_cs.c:1908:    scsi_add_host (host, NULL);
> >=20
> > ./drivers/scsi/mac53c94.c:506:  scsi_add_host(host, &mdev->ofdev.de=
v);
> >=20
> > ./drivers/scsi/nsp32.c:2891:    scsi_add_host (host, &PCIDEV->dev);
> >=20
> > ./drivers/scsi/mesh.c:1963:     scsi_add_host(mesh_host, &mdev-
> > >ofdev.dev);
> >=20
> > ./drivers/scsi/aha1740.c:645:   scsi_add_host (shpnt, dev); /* XXX =
handle
> > failure */
> >=20
> > ./drivers/scsi/BusLogic.c:2299:
> scsi_add_host(Host,
> > NULL);
> >=20
> > ./drivers/block/cciss_scsi.c:709:       scsi_add_host(sh,
> > &hba[ctlr]->pdev->dev); /* XXX handle failure *
> >=20
> > --
> > DSL Komplett von GMX +++ Superg=FCnstig und stressfrei einsteigen!
> > AKTION "Kein Einrichtungspreis" nutzen: http://www.gmx.net/de/go/ds=
l
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-scs=
i" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
"Next the statesmen will invent cheap lies, putting the blame upon=20
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refu=
se
to examine any refutations of them; and thus he will by and by convince=
=20
himself that the war is just, and will thank God for the better sleep=20
he enjoys after this process of grotesque self-deception." -- Mark Twai=
n
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
