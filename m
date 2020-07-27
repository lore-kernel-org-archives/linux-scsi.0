Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C3EC43459
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 234A420714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="llKbCc1J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgG0OGy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgG0OGx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:06:53 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48261C0619D2;
        Mon, 27 Jul 2020 07:06:53 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id c6so2812845pje.1;
        Mon, 27 Jul 2020 07:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=/dlgd3xXF2wViyMH4/dVOyKUUCfyX+RzmgXdSrfRYJs=;
        b=llKbCc1Jzqqo+R2xnbeoSk/TDJIw41decVAgoX43zZVyuP/6dBJRdvVkOESBSZdY3L
         A96qMW2LreOn6cizUXAumgXb4phDCe+3Wmp0SCjIhtrMbZc9/XlXNsuZ42Mkxi9onWUN
         e/kI4+z14oylOT5JCyzHeS2a6YKqMRmH64petkoLdwnt4KWGFluP0k0YrufbbbybYjjW
         v5/tH2Z311vFwPIgGNRMCNKM9yR9GKhUEmjyiPAtXXp2VBPT9GelUDEFlRgNgWDpxgrC
         jgiGlAuMF/8reRfi4rxL91Xiz0S4wZvgvqDfkIyyLp3PWYjaVoEGxqU3u7qlC5u448EM
         KVWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=/dlgd3xXF2wViyMH4/dVOyKUUCfyX+RzmgXdSrfRYJs=;
        b=fwcOMntVLKtYfuIQN39cugOgI9Sl8ZrPUU2VxdvMk8f+PzqUkaZHdWnVN8iJOiJ48i
         SWirCozrdo/XcxeTcZ08Sj0HHqW01Xe4IdAIMB1FX6vuBYGoacBIEtYWE4ajB8qZx2j+
         fvClJ/gJCoZu+TFuI3mqU+q0VebrM9fNBGTk7mQGIeIwvg/U93u1ElhuLZJ+hcFxqFd9
         Hoh1nIPwhRvr0RMKiX13rx2WpyqdQJnohVsECFuNXXXuLfR7CHn0QuCrnWjH1mXUmdLB
         7PlKdxX9L6/r9Mn39Xc7Onb/7TlkTRa+MI33wZbWd44yGeCg9Z/SE3HVbPwqK1OCg0Sg
         /oJw==
X-Gm-Message-State: AOAM532gr8j+dFs7miW1gU70ENr0+MMMati3d4R9GlBpoAJTJ2AJWyUo
        thdE0iNNqDDX/6R8BsgMaS0PL/QR+j4=
X-Google-Smtp-Source: ABdhPJyNjZQimFQYsPZZojsGgdduUxnpmtCXQWSqh9MJ9HkwSZ8ELCmS6a/9rrVk9cGhiLpy+DgT6A==
X-Received: by 2002:a17:90a:2d8b:: with SMTP id p11mr13163026pjd.10.1595858812742;
        Mon, 27 Jul 2020 07:06:52 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id y18sm15372647pff.10.2020.07.27.07.06.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:06:51 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:36:40 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.peterson@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: aic7xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200727140640.GA14759@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UugvWAfsgieZRqgk"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--UugvWAfsgieZRqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
APIs directly.

The patch has been generated with the coccinelle script below
and has been hand modified to replace GFP_ with correct flag.

Compile-tested only.

@@@@
- PCI_DMA_BIDIRECTIONAL
+ DMA_BIDIRECTIONAL

@@@@
- PCI_DMA_TODEVICE
+ DMA_TO_DEVICE

@@@@
- PCI_DMA_FROMDEVICE
+ DMA_FROM_DEVICE

@@@@
- PCI_DMA_NONE
+ DMA_NONE

@@ expression E1, E2, E3; @@
- pci_alloc_consistent(E1, E2, E3)
+ dma_alloc_coherent(&E1->dev, E2, E3, GFP_)

@@ expression E1, E2, E3; @@
- pci_zalloc_consistent(E1, E2, E3)
+ dma_alloc_coherent(&E1->dev, E2, E3, GFP_)

@@ expression E1, E2, E3, E4; @@
- pci_free_consistent(E1, E2, E3, E4)
+ dma_free_coherent(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_map_single(E1, E2, E3, E4)
+ dma_map_single(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_unmap_single(E1, E2, E3, E4)
+ dma_unmap_single(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4, E5; @@
- pci_map_page(E1, E2, E3, E4, E5)
+ dma_map_page(&E1->dev, E2, E3, E4, E5)

@@ expression E1, E2, E3, E4; @@
- pci_unmap_page(E1, E2, E3, E4)
+ dma_unmap_page(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_map_sg(E1, E2, E3, E4)
+ dma_map_sg(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_unmap_sg(E1, E2, E3, E4)
+ dma_unmap_sg(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_dma_sync_single_for_cpu(E1, E2, E3, E4)
+ dma_sync_single_for_cpu(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_dma_sync_single_for_device(E1, E2, E3, E4)
+ dma_sync_single_for_device(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_dma_sync_sg_for_cpu(E1, E2, E3, E4)
+ dma_sync_sg_for_cpu(&E1->dev, E2, E3, E4)

@@ expression E1, E2, E3, E4; @@
- pci_dma_sync_sg_for_device(E1, E2, E3, E4)
+ dma_sync_sg_for_device(&E1->dev, E2, E3, E4)

@@ expression E1, E2; @@
- pci_dma_mapping_error(E1, E2)
+ dma_mapping_error(&E1->dev, E2)

@@ expression E1, E2; @@
- pci_set_consistent_dma_mask(E1, E2)
+ dma_set_coherent_mask(&E1->dev, E2)

@@ expression E1, E2; @@
- pci_set_dma_mask(E1, E2)
+ dma_set_mask(&E1->dev, E2)

Signed-off-by: Suraj Upadhyay <usuraj35@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic7=
9xx_osm.c
index 3782a20d5888..2998d70e1987 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -952,8 +952,8 @@ int
 ahd_dmamem_alloc(struct ahd_softc *ahd, bus_dma_tag_t dmat, void** vaddr,
 		 int flags, bus_dmamap_t *mapp)
 {
-	*vaddr =3D pci_alloc_consistent(ahd->dev_softc,
-				      dmat->maxsize, mapp);
+	*vaddr =3D dma_alloc_coherent(&ahd->dev_softc->dev, dmat->maxsize, mapp,
+				    GFP_ATOMIC);
 	if (*vaddr =3D=3D NULL)
 		return (ENOMEM);
 	return(0);
@@ -963,8 +963,7 @@ void
 ahd_dmamem_free(struct ahd_softc *ahd, bus_dma_tag_t dmat,
 		void* vaddr, bus_dmamap_t map)
 {
-	pci_free_consistent(ahd->dev_softc, dmat->maxsize,
-			    vaddr, map);
+	dma_free_coherent(&ahd->dev_softc->dev, dmat->maxsize, vaddr, map);
 }
=20
 int
--=20
2.17.1


--UugvWAfsgieZRqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e32UACgkQ+gRsbIfe
744KDw/7BpO7VI4xx9d2wmnGAwifaIX6neKoXzHs8RxWHssVDdZHn0PVd07wcNTZ
2GYQ3gr9HVZJKe3GGwLY1naLzK2Ee28bHvfUro/DEdcJHjF5oyVgCwYEJT5vxdrU
0wO2SvP3uUha3INyogAqUecWIdhqo6sGJ4LPnoeu93vp/RIK81CELKebxP9vkY9s
Lq2l+BxeXyMMTxxfUWNMRTurf3FqqOnmRuN9uqM9hH+wMmM6WgY0BYDKam4fVecw
/AwSrHQVyDzRle/zMnGUgJhV50KPwJbkmm2de2aqAUkwwrYYpOan5VgU5A+hRQJO
7ry9jBXRxZn1rBz8T/v9IXD2UZ705/o6tDm51YrUrNY+Kk7JOI1rp2pTHV2ITpIQ
aGp7SBUSEeXELdjrkgD/BSC0iopZ+apeiIh87qZEJ3VqS7xvrB05b8xm0XPKXDNy
i3O3Vc5aOAypnb7GhBWxvKaM962WGhnH2AvRvxrPDbFRycsafwnkVa7QPU4P1Xs4
xZG8HYg8SSJ3uLLpxb00SrtvDL9lyzR1cMWVU42eEDUeB0W9N/fY3rPvpB28iJ37
CeAaJu8purH1u/+2B80S/p0933lWpih07cmnIx12q3R1MiFY2z5PlyJDiUGxeIbq
YGsKrIMLMgPAHmNt5/I9LyAyoA1TaVsgiHwRKOY2jHFOWCHc+n0=
=yJ/4
-----END PGP SIGNATURE-----

--UugvWAfsgieZRqgk--
