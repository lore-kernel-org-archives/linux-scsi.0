From: Arjan van de Ven <arjanv@redhat.com>
Subject: aic7xxx strange code
Date: Wed, 31 Dec 2003 16:46:17 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1072885576.10877.6.camel@laptop.fenrus.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Kvn8VKaslfXBmyw4tC4Q"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:44420 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S265156AbTLaPqV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 31 Dec 2003 10:46:21 -0500
Received: from laptop.fenrus.com (laptop.fenrus.com [127.0.0.1])
	by laptop.fenrus.com (8.12.10/8.12.10) with ESMTP id hBVFkIwa011308
	for <linux-scsi@vger.kernel.org>; Wed, 31 Dec 2003 16:46:18 +0100
Received: (from arjan@localhost)
	by laptop.fenrus.com (8.12.10/8.12.10/Submit) id hBVFkHch011307
	for linux-scsi@vger.kernel.org; Wed, 31 Dec 2003 16:46:17 +0100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


--=-Kvn8VKaslfXBmyw4tC4Q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,


the snippet below (from aic7xxx driver) is rather strange and probably
broken:

        /*
         * Although we can dma data above 4GB, our
         * "consistent" memory is below 4GB for
         * space efficiency reasons (only need a 4byte
         * address).  For this reason, we have to reset
         * our dma mask when doing allocations.
         */
        if (ahc->dev_softc !=3D NULL)
                if (ahc_pci_set_dma_mask(ahc->dev_softc, 0xFFFFFFFF)) {
                        printk(KERN_WARNING "aic7xxx: No suitable DMA
available.\n");
                        return (ENODEV);
                }
        *vaddr =3D pci_alloc_consistent(ahc->dev_softc,
                                      dmat->maxsize, &map->bus_addr);
        if (ahc->dev_softc !=3D NULL)
                if (ahc_pci_set_dma_mask(ahc->dev_softc,
                                     ahc->platform_data->hw_dma_mask)) {
                        printk(KERN_WARNING "aic7xxx: No suitable DMA
available.\n");
                        return (ENODEV);
                }


consistent memory ALWAYS comes from lower 4Gb regardless of the
pci_set_dma_mask() setting; only the pci_set_consistent_dma_mask()
function controls where consistent memory comes from, even in 2.4.0
already (which the ifdef surrounding this code tests for)

Justin: are you willing to just remove the unneeded dma mask sets? They
can race etc etc and are 100% unneeded.

Greetings,
   Arjan van de Ven

--=-Kvn8VKaslfXBmyw4tC4Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/8u9IxULwo51rQBIRAl8PAKCBio0sFFpmhxWg+l7zSy/C6FVegQCghkpK
Iqwzw8xsywvPQ8TMO158kXI=
=uBuf
-----END PGP SIGNATURE-----

--=-Kvn8VKaslfXBmyw4tC4Q--
