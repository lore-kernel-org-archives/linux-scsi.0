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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B8CC433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:53:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C33212074B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:53:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7rq+6Gh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgGRJw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGRJw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:52:58 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A36C0619D2;
        Sat, 18 Jul 2020 02:52:58 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id p1so6506334pls.4;
        Sat, 18 Jul 2020 02:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=CeJIA92KmMTwWfodZ9XhqpWFLxlsGjbZM2lrufVB5FI=;
        b=B7rq+6GhNypvcUEXW1PovdZtSfYPmdRq/YMUlHvlgRBPrTgd+PC9BUFyofUH1kZQGr
         LtOj4+VnUEJGAgdQ61VLdqgEntmXAuf50y4P9lTlCISaWFfG/1ILAU6KGwbhNGb78391
         vpa0QMs9tu3Z5Tx2ryAe9x63D8IZ6VXmKsylwZPgeeUh33nLMxRM3fHpZgdKNuu5frko
         yowhywsQCd8xLQZzN/x13nh5P67O7amsyAfT+jYbPi/vJb6DpS6CcsOsm1f6Sz8N2sVi
         umQt44OnFUBwfNSQOfMCGbEMITyE4kbOrWk4UsKPGE2nzf4USPUeiGpHJ/9qBRqF96CG
         h9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=CeJIA92KmMTwWfodZ9XhqpWFLxlsGjbZM2lrufVB5FI=;
        b=nry27/s3D6h59QJnLhxTuhWHx2XMliE5ZJ7nDZv82OAWaQ4crWZ2a9lB8EicvL266X
         NMiNk2yJywo2INs1rYxCBe5NXM3NtCsY8VUFerM5d8PcD22B6GRF45u9x2yMP1NbzFVs
         QlLiSt0kmGi+dRmj/3mzsWBSbxbH0mBHo39olchYB483Fz8Wmlnx/JOHy3zZv+EbJzCC
         w+jKMtLIdpCLeMVU4RKpqNQs895TFQN7e5sS6VD4ozVrek8IheGfu18t8yDjX9JYLsLQ
         +c+hIVjNE40Ih6SD2FY82hGNW7ZN/IQgPGLDvOFgGRZOdy0DBDOY1llZ9UWO9NOJKv35
         rwqQ==
X-Gm-Message-State: AOAM532Q+yA1omj7OWDbYCBw9LqlQPc4aPKDJHs8aH6szu/ixiD0n/dC
        btODnhSisDI9A5s5VlHDngg=
X-Google-Smtp-Source: ABdhPJyAF3Xg1maP6qr2LuCduNHDx+1pO+uzktdFGDxd1uGLDYZluw9cLCH5nvccxWlhZ5KGXEyhow==
X-Received: by 2002:a17:90a:b891:: with SMTP id o17mr13421942pjr.202.1595065977650;
        Sat, 18 Jul 2020 02:52:57 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id w2sm5001629pjt.19.2020.07.18.02.52.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:52:56 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:22:44 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     njavali@marvell.com, jejb@linux.ibm.com
Cc:     GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200718095244.GA2761@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--u3/rZRmxL6MmkK24
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


--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8SxmwACgkQ+gRsbIfe
744Xmg//WMRvwkLZhwcZ/v+9TnuHsmZOqE55mqrXwiqZ3OQChoHlwjSUxIcDMEx0
NcP7ls3sEq4Qzo5sfszM9xtf0gSd4PLlfnm/y8wxp7V/+GsSPXEzPJGWWhTr8KDv
xt/8Blnrbxs+NiTqS/CVFJhN5j8ojqukSTCv2PWZ/cPBBiHB/LfzmCYkMVBJPJdy
nqx0AwiCg01X9dkLwgINqVlfQZhvQgCC/58A7dW1Ni/zOeLyCpdNVC+K4BCaiFsu
pI99kAI9DRQf9WsPlRUnLXB2Db9sF5qrHm1gt0LZPP4zalbTW9cpOF7LqUX6X+ns
7PhFe7WXdSEs+IO3lh3/Qzkt0tCZwyxBQzLSFoYzAZqOl4GSc8v3IXrWgSe3TcfN
qTS8fiqh6CbkeVAS3vqvplLG9tsbQTPCVzYNVhyBu3bpvhltSDyAmHQBJTfTb8fI
xOuUK35DPzP/nlYzm5nxGxBKzO6xVzNcrd0nQG1ITWjZ4vp53ljF1Pe4qnXmnajh
Vp0pBQgyHtIJNNvlUWLaKtJsB2REfsS79knrKdAM0+pPbjJbH39rGLexNeNogfJc
QHOCGLqA+wD+sv5Fe/NVwvcaicLxQJYJXhNuB9zkk9UFUsR/N5skK5cokfyb5XEg
I2gpXiKmxFQV7tlStZmPO95V9PpI3s9hSH41yD/b7uRKV53ilM4=
=3Y/v
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
