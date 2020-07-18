Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21BD7C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:37:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2DB42074B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:37:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VclUBqVS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgGRJhp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgGRJho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:37:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5F2C0619D2;
        Sat, 18 Jul 2020 02:37:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so6490198plx.6;
        Sat, 18 Jul 2020 02:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5Mrg12/HL/hoE1p76y3YAFgAZs+CqAOXZGJhSsgV5K0=;
        b=VclUBqVS8eF0H3eatXjPiM8526M98jWkVSnRjwmQCR7hO9uwqmm5f1f016R9hS3EZg
         miJT+f9drVrqwMa7xmVDpY6oEskTG3MIS9AV+HwjU+kd3nq531GJLM8q4KzVlns2lsC6
         aue1N7/hdvNWUZAFVg0CzyiqoO4oV1atHAvshk822RCHbXb1FF4PTSpjZM4U5xzQmC0f
         p8oMv6IRWdKfVXzWXxf+JdY4NLaWefmal5AZmzEyfuVD/uvDFveX5+PIPpmdRtIrdWxJ
         4xUcBnv66rzKtkYHDYGXcAV7DpY5aeVH3a2SalsQX88TVfP3vFPcJ3EJkTldn4v2BRAA
         6K/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5Mrg12/HL/hoE1p76y3YAFgAZs+CqAOXZGJhSsgV5K0=;
        b=ucsH9ZKey9qf8bwB0jcBvE+cugLqTzyS132aR7dDMrVMmnV85HkGeTfTfme8Lqj3s5
         IK5oxoXwMPCKvLdzeHgkPtRN0akhGj+s2us4ZognVhHVz59nEWhcmmwA+p3K6N9VnjQ0
         /yKt8RcmT1GHJnnj6xeNPgM7lXDSay7ZyX6K/ZgHanRx7w+Wq2wIcZcez9fiwqcEPsdz
         XK2oeobcwk/smpAM6bppSQNmTVKNMq+uA8iMBoDhFj7+71YVLe/RiMwbsuJLQ+vH7lBN
         KlCgMBwrHfNSZtNpWKt3X8taUvZUrOWW5plX3L3l+V+RLBmtbAIsKmadEw6A+PsMUMub
         wS7A==
X-Gm-Message-State: AOAM532+0dhalg982wPSFn0ejR9/rHAAsu/y93SA/kGreErLTTdrq4zS
        QToQxp66HJIA1S+mNCS//N4=
X-Google-Smtp-Source: ABdhPJzIdLn3TVe6xrExcAZ/VE2xHbH8kBHXPdtOsuz7cLJLczqt4+XptS/Co748Wvmme6xStdPpqg==
X-Received: by 2002:a17:902:fe04:: with SMTP id g4mr10730780plj.66.1595065064040;
        Sat, 18 Jul 2020 02:37:44 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id d4sm10086129pgf.9.2020.07.18.02.37.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:37:43 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:07:30 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     hare@suse.com, jejb@linux.ibm.com, martin.peterson@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200718093730.GA1854@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--cWoXeonUoKmBZSoM
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


--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8SwtoACgkQ+gRsbIfe
74571xAAsWKxCds8TztPG6rsT6k4eG9fyhbdAQNUdPqKfXGVi6OtA0ViAgVyUMtg
SyxF6SYuGQIyv6Y37ehfcFjgeMuf5wHEDgPgF5Nl5O7eJtssji2DpRzT2N9yC39A
qZeWjOz5efNApgk8BYpQ/h6LKZVfmpFVGaVt7WOVfbTrwg8dr8BqdU3k5bsudSkW
7R749fKfRZatZsJD9DRo/o9G544hzCXZVR9iSzpgVCUSMBdx+1yKN9jthNkBPav1
2tdRW169wFif02WKybsuKBrxZMm4BlZIY6QbaLD/o2qYNETe4O6uPhN1wJUEWohB
5CW90Y6d1kpIMl/41Cz3SpI1AgJVW8n2oCURu9ijYgNH3OV/+526krjE8w5jipuK
YjAHzpUOtu9ua+PvjdBsKLHo7g17O4U2qvDTUfMzO03/Tn969aT/2kjEW7cgK6Rw
VLazCvQi5zTE3J5zTtDRRhIq9L9fjb2kR9XpX7bbBMN0Tu41B5kJo9mg2g4dBsZa
uxVzUYwb8muKzGVZOz/83xT4C/D6O9mnjc4hQY16ZAXrvErRhq6aHG3usru9avO9
DHniSlZRvlurVOimWpJK3QHOX/i5nH9nCuFkh300qSmO7Ns2KyiI3zZ8TQ2+GUpo
cGy4kv50TAnJlWYt0/Exjq06P1pLHFPMtX82uSMafuCvvuexeqU=
=a7X8
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
