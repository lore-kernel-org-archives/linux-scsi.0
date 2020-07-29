Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 098D9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E06A8207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:07:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UlDkrCz5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgG2SHi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2SHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:07:38 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17224C061794;
        Wed, 29 Jul 2020 11:07:38 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d4so14695856pgk.4;
        Wed, 29 Jul 2020 11:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1Krxl1GvFbA1WWD9zXx5UhETQ4OJ61M+EH3cH8paiuk=;
        b=UlDkrCz5awqZE0HM0RaCzHfiq0jfLK0AXl6ZeG0o0voJ8ynShSEAZwEiChOHJrNHZB
         wICpuZpxZ6AjcNfygmgRHR2EeMGhnWl2Con4e0OUjgb7m/fL10YjgeRaYtL8VDXzwy4I
         U2gzW40r1PcsOvsTWNJ6NdILKgSXEfVehzFYshg3lQKXv4ZgI/g43MCR1drmNpJoj8en
         JMUMXU4aanI3OlyROTeY26gWAUGeh4DIOqsJlYM706LnHnYX0FVKl8wXaAWSjnKBz/qg
         wwbfcWA8lN4P51Ftuoex1E+WtoQoXgmgkiLfSGIUJKUQVnCplTXvv8QfhCn50TzfCgIT
         g2+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1Krxl1GvFbA1WWD9zXx5UhETQ4OJ61M+EH3cH8paiuk=;
        b=dXKOT6qSYIGzia9k7vLElrCPhnvcmFh57NSghFEoH1H1Yip3iwsWNOXSbF0yL4QOcH
         eLGok8p1QHT1k/IORmL8i4r/+XDPT+mo7ndrAHtOvfvYSX3wSFe98V/bMxLx0CH6y8/9
         fvgcOaooULZUa885yceSzrcd/RutDZ6JgSWaBZyZ9haA7uRunAdLifGzFG0qP5pUjaqd
         IHf374/Xvo6jE41X3u8PoOnoQIujZsKKiTN0X1DIiFxJB83GuupKdZX/KXNVwzqy8BDR
         rj2a87NmEHv5vTbv6wyjjGtfy6HPJBVknBpGPjpFrBIt+SSdaQK3n4NonEuBvLqxOkVw
         kNgw==
X-Gm-Message-State: AOAM530c07jI/4a2F39WAh/ifYExGVKBEuy664MNZig/g+cqiUIIaFLM
        lvM2fWlE7hZtqzbhetsGGOE=
X-Google-Smtp-Source: ABdhPJw58v3SyohfcCXwEq6Mo38cSFL91tCfPmYdtFXnR27muEdJYR5/suIWBqhJfAx+LqYXHzIybw==
X-Received: by 2002:a63:6c1:: with SMTP id 184mr31367480pgg.262.1596046057615;
        Wed, 29 Jul 2020 11:07:37 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id s18sm3109246pfd.132.2020.07.29.11.07.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:07:36 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:37:24 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, hare@suse.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 2/7] scsi: aic7xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <790a8751b5c2b5393c3021b8def08e47bb1597c0.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs.
Instead use dma-mapping.h APIs directly.

The patch has been generated with the coccinelle script below.
And has been hand modified to replace each GFP_ with the correct
flag depending upon the context.
Compile-tested.

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
index d019e3f2bb9b..7599eec08bf2 100644
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


--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hutsACgkQ+gRsbIfe
745duBAAkXYF7tWrnY8CRU1qgU5+Q8BEsnJe6jHa4k5Fgj/9MrGGxO66rCaQlWKZ
2ggk7psvFy0ovS+KVbygAN6i6uSRrBx7C5jIeyjRu8RJ72ODNcjXyUA2E8JJKPS/
k3YEHYGCPDSqRxuM/nZCrU3NtxTFe6UVLVf06H/OhO9ocOIWksOGq7Dk9CZpLeOr
ew4GLuYczWWdrCO4lYoAu82Q7xNcREwF7dKxxy/YOobkazyMkXGloeI43kL3d4RU
P88NKCKsafIZc96F8EwafTQRlT95BM8yR6t9Yx8fy+pQzkEJptYwIOCkMvcUZ3/y
uBBeIlnTZulqQ+s5XuoiI+ZNu9Vk2JMLmcnPWuydqKN3h4IJQuFRmNzHyBDL87x4
Iix9qocZtlwjr1Sz8PMLOZ7vuYbOcryANkystbeeqgwIdMi7nrWDt3xTxUcozOEc
nugh942pt0plNBSlX5qXwsZeen+oA4nEMuv+BCBAa25EjksBi8D2COpigWNMtPSc
3xT8RJ5o371Y/5WDGw/7WoNW9tXyPlnkrZkBMk35UJ0mqtd5FV3XV/r1GNPJiVAg
HxG9KxgehdWFiSlDgaWSyDoFFdZxqEXOq+8RTfqEKAAs0niC9pXfGx+kxcdx9JuB
t1g4U2v/+GH6tSGSGEfzEbSyJH5HyeC/jUOoTEo8bTS0dH9ZpaI=
=P43Z
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
