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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 332BDC433E1
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FC552070E
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:50:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="royD6rEc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgGRJuM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRJuM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:50:12 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2065C0619D2;
        Sat, 18 Jul 2020 02:50:11 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j19so7869725pgm.11;
        Sat, 18 Jul 2020 02:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=xlxaTRgUcycprIxIC16Wrlbz+yeEI7GCYkU1aIYSSMY=;
        b=royD6rEcCO9MgTWFpNSMs1pIJkRFV0HXHNrp36wc3OySBrhME2KSjzaI0z1Wwl/RxN
         coSN7n5Ua0HckYifxjuNfVFut4Lq1QlOz6P3j5iCV4Cgw290pgZ0vkQ++cuEHyfgG5nA
         hPXSqCjXe1lFm0xP7+IQTAseT3xTelum/F4BZGJnK320+XdVRzXcuZrmJjC4FCpA5f7F
         WXUtLfvZ4eYz6fBG1HAwwIf2wyehfLCiHm0WPP1Pj5QeH+dxQG/lHcLxp5kLBcCf74nC
         QzEN+YmI+Ktfld+dAOar/ow8bVCWzk++fdg2fgoGUJZ15u8h/f4zunrviF99IkoEc99G
         pr1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=xlxaTRgUcycprIxIC16Wrlbz+yeEI7GCYkU1aIYSSMY=;
        b=dy0S7T6U0oaeUiwEAbGLV9KJWLG86ltMY7aEjve/f3HLK+E+pqVZ1zcuDvg/kg1GFC
         zaRswUg108KS1JUH2aUczeV3IfWpdk0fZMufT+zAIywOPhmyOiF5Mv/kBKtR2FwNgajX
         Iy3u5fSKe6OSiMy2C1i0FOLMLSSgAQWr4a8KHcXR7N8Gja1FFbQedzauXDqOcpnqHXoS
         uMY46EEATck3kd2x6bzw+YPCnSUhhQ0V6JhZYrLXWsj220lKRHyBnhhJLeu/MrdGKgre
         2st/ziDoOdHfsIKup8d1K3if0wnGNfyGLkYjeuv386pVVJAMLLKzc33k8Dd/hpTJBYcY
         n10g==
X-Gm-Message-State: AOAM533xLcS1OSsWdDYO+u2NIY0fjPRtVDpezP0fVPuyIhUE/11LkU06
        37szGTmO5Afq6RYKUfAYLtHV38xZFtS3bQ==
X-Google-Smtp-Source: ABdhPJy/+o046/URWTy2yUfFOcLQxN1dKZWNsA9EDQ51I/XG7Qw7RIwovUhWtlrc+8qpWF76E7FUNA==
X-Received: by 2002:a62:e119:: with SMTP id q25mr11649516pfh.300.1595065811197;
        Sat, 18 Jul 2020 02:50:11 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id m3sm10414291pfk.171.2020.07.18.02.50.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:50:10 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:19:55 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200718094955.GA2501@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
APIs directly.

The patch has been generated with the coccinelle script below
and compile-tested.

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
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3=
sas_ctl.c
index 43260306668c..94698ad1cad7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -3384,12 +3384,10 @@ host_trace_buffer_enable_store(struct device *cdev,
 			    &&
 			    (ioc->diag_buffer_status[MPI2_DIAG_BUF_TYPE_TRACE] &
 			    MPT3_DIAG_BUFFER_IS_APP_OWNED)) {
-				pci_free_consistent(ioc->pdev,
-				    ioc->diag_buffer_sz[
-				    MPI2_DIAG_BUF_TYPE_TRACE],
-				    ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE],
-				    ioc->diag_buffer_dma[
-				    MPI2_DIAG_BUF_TYPE_TRACE]);
+				dma_free_coherent(&ioc->pdev->dev,
+						  ioc->diag_buffer_sz[MPI2_DIAG_BUF_TYPE_TRACE],
+						  ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE],
+						  ioc->diag_buffer_dma[MPI2_DIAG_BUF_TYPE_TRACE]);
 				ioc->diag_buffer[MPI2_DIAG_BUF_TYPE_TRACE] =3D
 				    NULL;
 			}
--=20
2.17.1


--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8SxcMACgkQ+gRsbIfe
744EfA/7BwCwC71paqLkuktJey5G3tdgVQMtk+jka4iR2CB2xrjfHiP/ejxvUZC+
f3R8n3Z1N0gu2bp+9gXDUHIp27o/bl0uTqeVcUlszChIbmHsvjIiG05aECXyTLGb
Uwdb5aGX7Qah2XmZsaUAtMnbm9DOdZSepiUsnJ50YDPzc1Zt+ACi+dOicPxTl7H8
FrLxq74ogL7GCXVZjwqVbutEJPpNACmMnwoyudUVruZKbm7kSyPwasGctBdqMj5x
+qXCOmvYgBaFVi8RI0cZDsEISFV8OIF8lXT2CshjzsYfAXK8CD0LTA3IoSWsvihD
CoTI8rF08+/B9Vs/5Bm/7pC5OwUgou9AmaaCjVjOlSePpiQZJneel5ZmRWn3gHhq
JLV4u9zwcJ5qP3kBttsa+Hc7r2+hkoJnSn0CeN7qp56FaMI40iIRFYD9JJVS1stm
7xR9ZyMPmc24bid08G0Izvn1TE6YWmQU3oLhxEEeonJ2JYlDHccHIPAc2dNzQwPY
/7QPpXic2sYcP7RqZ5HFWgRTC7Ru+R/k6czxoNgH4zKk7MS2YdX8RgNFGpEocXIP
ccC5ooHrZ4U/L+cX8DIiHhiQmfGVbdTDul1v30JLneGjA5IZNhBD9w3KiL6/9wwX
WhAVW1poXf1dJohXT8EOozCvXu994Rousf72BG/83ivfyhpCzB0=
=/DxL
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
