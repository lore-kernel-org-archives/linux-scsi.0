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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC96C433F1
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A10B20714
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:41:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FZOYSXYh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731215AbgG0Ol0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:41:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729354AbgG0OIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:08:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFE8C061794;
        Mon, 27 Jul 2020 07:08:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w2so9566228pgg.10;
        Mon, 27 Jul 2020 07:08:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=eZ0u2C3g5CgBy7wbvgHSs5dQhBRrwMmUSKIQuQjB0Us=;
        b=FZOYSXYhKycBE0e4vYg1MTp5p+IleOJwcfblWh3DEYYmgZO7/jqrz7ApbapLEtc71X
         CepzGfwu69TGcL4Y20C2TgUVnKvz2yqQK6pfZUeUIaLm9mxlRA831MjDA1f34uY6WCo4
         HRBXUunheyfTETk+FoQtt6xWhca3MOrVvCKlGVNTG22Q8n0nDvE6JfLBii9JVM5OnEpx
         OrnyH1Y0hGNR6GGqrcZut1JvEWoZovM5WpsxkjsXXf5fF3aXGV2PmFLzo2C+5+nXUGdM
         1QLsiXLze5uY4KWH+cGm+qejn6tHR/VmAg1wm7ZgcZ24L+jyz0I4OFfTc9iVVH0IekAZ
         GNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=eZ0u2C3g5CgBy7wbvgHSs5dQhBRrwMmUSKIQuQjB0Us=;
        b=cco/rVT6Ay3qzdNlChgPOI/aLobv4+Ga1ecouNWQJmtfV2c69Fc7qmiG1nFTk3c86U
         TE41w/kucn/RlfQvU6uBnFN+m/qnzifuC7Jfj7AYtxi39nHR9EvPvaXGhg/A2jhJI+xH
         +kvzbTovniJOGVHOjHK56js1+AboSqyp93h9lhuePgLQVgl/CaJ8iyiWuB65QPvc04qv
         7FzFnNoHmBS4VraAqafBhBOHvrvYIcIRX+6d+cO51+F94fZCOhQe+/u9O6Xhct+izIbv
         3Mz1XAhwGtfU9LTgfuYzymdmlMF8RNjDTHwP1ZbQ9TH6+0luKMYauqfMexCBn4SHJEzG
         CTmg==
X-Gm-Message-State: AOAM533Zm3rh1bJu3QKrdwQiYEJsP2/uJtoNPoRsKjPDm/VfWQd7y5/w
        orQJKbEIp1ueM1quH2OLuDHytyzc+rs=
X-Google-Smtp-Source: ABdhPJx40a0o1ldA7mVVfFO+dNJxFMHCcf8jnnA+MUrCRgbhB62rBis6fBNXWh4J/47uJwowwng7ng==
X-Received: by 2002:a65:64c5:: with SMTP id t5mr20001115pgv.28.1595858887260;
        Mon, 27 Jul 2020 07:08:07 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id d5sm14209780pju.15.2020.07.27.07.08.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:08:06 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:38:01 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     njavali@marvell.com, jejb@linux.ibm.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: qla2xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200727140801.GD14759@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="BRE3mIcgqKzpedwo"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--BRE3mIcgqKzpedwo
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
 drivers/scsi/qla2xxx/qla_os.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 9b59f032a569..8b4e3da1de5a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1885,7 +1885,7 @@ qla2x00_config_dma_addressing(struct qla_hw_data *ha)
 	if (!dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 		/* Any upper-dword bits set? */
 		if (MSD(dma_get_required_mask(&ha->pdev->dev)) &&
-		    !pci_set_consistent_dma_mask(ha->pdev, DMA_BIT_MASK(64))) {
+		    !dma_set_coherent_mask(&ha->pdev->dev, DMA_BIT_MASK(64))) {
 			/* Ok, a 64bit DMA mask is applicable. */
 			ha->flags.enable_64bit_addressing =3D 1;
 			ha->isp_ops->calc_req_entries =3D qla2x00_calc_iocbs_64;
@@ -1895,7 +1895,7 @@ qla2x00_config_dma_addressing(struct qla_hw_data *ha)
 	}
=20
 	dma_set_mask(&ha->pdev->dev, DMA_BIT_MASK(32));
-	pci_set_consistent_dma_mask(ha->pdev, DMA_BIT_MASK(32));
+	dma_set_coherent_mask(&ha->pdev->dev, DMA_BIT_MASK(32));
 }
=20
 static void
--=20
2.17.1


--BRE3mIcgqKzpedwo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e38EACgkQ+gRsbIfe
74560w/+PjFAdYduER+Duyjb+f3oCkF8wQzpx1KuqHNM5+LJR294sZ3j1cJvX0G7
CY0grqbLttHUoRqaY0yvZze7Tn53crozHQ/fj2rRBG2ob7fz8B4Lzr4Nz8ahZY+M
KoE+Kd0+s0GjzU0gK+0zCDaUymGvL59HZ2EN9gRhK0HoBzA5V77xBsBd26ov5cUU
sTdC0j4srVwAIUJZirKEcO/GeC/PDe5yAKpcyGUaNeYB3PrGb3uQnwCugmefeirh
7FXYnMWvJr7N3VNWuzdejuQbDUyox5PVKOVkugI/8+VL+noRQUF/XXBYgS/sZapr
azkxBbH8uTm0YUWcJvmn675JHcPx9SCod5KQqIkh8B8wruqYfNyjOX6H3wmhPqZV
9t0bf+hchUv1A/TQ/YTFgkT3PkwE+iWBfhmKDFeRjnq2w06jKzr3G5sBs8NgekOF
n2P3tuKiNm1lIKaDg/n5IzjEqzDMzU2ocghqxFxudI04ZzXXxrWKrTU48tAEEdE9
tnH8ke5xXpZ1syv8STL6QAlOHYnvVLdUj4o01AOuI+ZLcnvkRPBgT5LTZmrpjE4l
UrJYbp5u9/UKngI4B2GD5Ane9hBxF8yB9AkyIHnGlwOxj79xMD0WtMphvhVYEP3e
oXKNvnnbHt6tB9oPLHIuKN9eCF0lBYNuYXakmWEBVEnvEwSPzx0=
=RwLc
-----END PGP SIGNATURE-----

--BRE3mIcgqKzpedwo--
