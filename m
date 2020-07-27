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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BC8CC433F1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A06220714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uQqOKwTq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733094AbgG0Olz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729307AbgG0OHt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:07:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F95C061794;
        Mon, 27 Jul 2020 07:07:49 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m8so2264074pfh.3;
        Mon, 27 Jul 2020 07:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=uIYJyuYiiW/t79IJASfjSgsvyr6JgQfUGj/U1kW1+kM=;
        b=uQqOKwTqim7etj66QoEBbgwOnFx1TiubnxWdmHhLlW2/NBcuHbHGgFC4UGurNd5Zd7
         sDFMqveMEGq0Tc5m5xFLKqMkBzkuXGxQBdIEFYCqkM9mJ9eOiGNV4q5AqerLbkIp9fXg
         dCaVMlBcNJ0MI9PKsxy0ui/psLd1hq1k3teM6xJfyL2pCAQZEQz46S8rqiEPLLzMPmvK
         SpLzzpdk0j/hgeeJ/WGAilck3JuMQV3+jhkWvS6uJ2Xn4/HVJKdGW+Cq5vfrlp/G1O1v
         3T18HVgB1QNtBj1XIUILJ8CVPx3z4EvYpCx1VnB4pTqa9lKy3bFg0XTu6AMKU0YIWXhV
         N4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=uIYJyuYiiW/t79IJASfjSgsvyr6JgQfUGj/U1kW1+kM=;
        b=Qc3b0lscX7I/QhOlMO2H3OixNVaChor2Y88M/ux/wGe5b/F9zPcVyUvuCpDAn3+yoD
         Sk/OXxaBAhGLof6/1xYhTXJr7f5Hd1t13cMEwKvLVBCJX52g9g0AGl8e4svtYLe+p2zg
         sHrjwFZd0I6JWYmA0L7J4G11cgASrgGTYIpvRMN92I9lidr7AQu7M/+nTthrqjxW19J1
         pc4nQsFZVB2yRxlmnPQPgNgb72rzZOLtEjcAELVW0wF0PMGiuxm9aTH5NidtTNtsx6TG
         974B9fv4X+2FurxikLyhKuyg9cy8EiinuCdBmUe12qV4LFYCX4zfhFLwCl4Rgs2bLVxK
         fJ/w==
X-Gm-Message-State: AOAM530MfenwKNDX7fUd4S8n7LTtUBWWeoS8Kkr5/QTqh6rhWFKafFCm
        cK7BAsJ7oVPp0CcvdnJbgqo=
X-Google-Smtp-Source: ABdhPJxYdZe/awyfdH3IV3SnkfRGrqi3dP6UndHQAjFe3FqxzT8p1Pwotl6hs6Qcb4z8Jil1TIhDYw==
X-Received: by 2002:a62:3204:: with SMTP id y4mr19769998pfy.50.1595858868906;
        Mon, 27 Jul 2020 07:07:48 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id h194sm15164853pfe.201.2020.07.27.07.07.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:07:48 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:37:42 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: mpt3sas: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200727140742.GC14759@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hOcCNbCCxyk/YU74"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--hOcCNbCCxyk/YU74
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


--hOcCNbCCxyk/YU74
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e364ACgkQ+gRsbIfe
7476hRAApZApUEz0Q+bHrUSIr02pBFKMxPO96/elIDLN8mhzeEq0Qs2vinqshnfV
7S2Nh4Dz8BT3wCUp+9QgypHjo3IrTozzThr7ZzPZF+hLlpXt59ccmNCpdiYhcJ3w
kZEOiQREPcR/8b78GjQ+AX35/W3PiW0BSA4Vb5kyfs2858l+QzsSxG+HZ8raI3E2
KWJX81lhG4hlVW+fYUaGKYPiI7mB6GNFln9hIWnN+0ngks7ACoWf0o1+HA3bzjS6
gzrp2uIXqqj+2l76/Yj/2t1laQ9dDbz3PmNolb2KWpJiEMplesksVUYMSrQklrXd
4utN/4K6RWtwbFogTXEBHds2pfun7/Dvv2/EmJEY1quNu/CPfGHXzz8lGW/ul0Md
HedX2B4e3VN6YHIGFQf3UOLbpqadcXLtbii/adpyJbTDjJdO1PjaAVuxKykn/ax0
pT4k4ZxGiOsAYkuDy6P/eSvvDAOzf/6nfIJyhYqNn3VzInyohnn8x/ENZ+1Zt8vN
2HF+Oo5hGXzU0MdTBRQR/7i1k7I55UVfBZQNP9oepOJMGPKqwpQ7VarVOrnD9YDn
VLXGeHgwR5SkmwPg3hj9iSABLbgE/BvqTXidoqkMxjuV58oIfhBzcL7pFlmlXBOK
dzDmp+O8xuMi8QwRKaG2sI1duRgqc+/a0CZlbx0gtmmghruVf10=
=R3fx
-----END PGP SIGNATURE-----

--hOcCNbCCxyk/YU74--
