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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 909F8C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72AD7207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maKKlbaG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgG2SMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:12:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgG2SMy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:12:54 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EE28C061794;
        Wed, 29 Jul 2020 11:12:54 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id t1so3010337plq.0;
        Wed, 29 Jul 2020 11:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bxde798Da17MibNZCXMF9ILk7ca0H7ApvtwlWCaWKSQ=;
        b=maKKlbaG5VFgu7Rg5G3DhsRQc+y0Unw1JLBNKKgdxAVsGPgbYMQXSxJanb7Jgw24+D
         br4TQGyvgVIm6EjQEs/wUPNcxMY6hQTMcxIX4kisrgkhT/dfvIoBFo3+pPT6vNaSH9et
         rG+tCyv52E886dbeDLWhhIz6mDaYuN1pboi8sP4aRWB/aIDUWQvAYMrxlbQT29hvpsWy
         vrdDmeGzY2+HXlsBNaccayLqo11GtaW+hrWXRFZolMneMwyS/9eEd/P3iWOtz5CJrXgw
         0eWRhq4ELVhOHkicKoCEPpgRWwxifiiD7sNJ12yRyTaFsp9OsXQM1li26uM6hMV2CJ/w
         8rBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bxde798Da17MibNZCXMF9ILk7ca0H7ApvtwlWCaWKSQ=;
        b=N+9J92ghUKiHCLsLxZdn1vbA5L43hd/3fuyTB28zOwryXYwGNCV1JXsJatboSxuLQH
         TGvmRu5TeqKYZwUhCDUHfYJ216canv92N0G78e6gKXKBHnFxQKXvSkcqEMgEgTp+9O/c
         SzU7cvBIAfiekLwF/NXjYh2oYRXon/qvQV439i394YB1pvbBHb924KA6n0MRP1mte9a0
         /TdrhgM5CeOIujZ5ou41nSc29+nIZhcfwsyJlFlBGi6TuvGRiPpQ14frSZhYDhHSA8kc
         ditbi4yBSW4ba56zezPB4lsTo1KfmH1I8dwGRhVhRBRH9vtBA0vsnO6CtsefHmQ+4Cko
         mmww==
X-Gm-Message-State: AOAM531oPV8GSFaCKRFlfLodqpoodIgNHbMZi4aUGDmeaHjgWEXSYuUw
        qdPkC88bwFs7ZNJnNX45pcE=
X-Google-Smtp-Source: ABdhPJwgv0sCQXA3N945OqAaEE7bT3TACCbGLa9TwPpyR9KfigEa+syfRsyCFP74S1bdvXE1oiGCMg==
X-Received: by 2002:a17:902:9009:: with SMTP id a9mr26826174plp.252.1596046373656;
        Wed, 29 Jul 2020 11:12:53 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id f3sm3009696pju.54.2020.07.29.11.12.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:12:52 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:42:40 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 6/7] scsi: qla2xxx: Remove pci-dma-compat wrapper APIs.
Message-ID: <24627a86cf1e67fd229bc323316523d1ba0811f9.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs.
Instead use dma-mapping.h APIs directly.

The patch has been generated with the coccinelle script below.
Compile tested.

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


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hvBcACgkQ+gRsbIfe
746ogQ/+JqVb6wHACgUNPcI6r3aTAyFkghwuP08zFo4FNRJx9HFrEgg0YEhZWqpv
CM+ccp58pCJhTdLdarLYnL1+uVWAjiMtPZu4/MkGKJ0XAXm9pFUm+xdc8fmC7IJN
Tq/lBZhFyJ/8pZR4qBrpoUDlnyt+Bod8C+YG7sl687utX2OMHao8mK8inJaGm6di
4E0raYJJwiWU55wTzXXy0Y5fr7LVDM6TCETp7BEK5Aln5FCCtluIhNlA5Tomkdya
TBpN/ZlDN0CwLvVjAn6J/+t/gOgh8iqVqKrHLHcrAZ1jqFz4Yqb3wmfNBv+ghCSa
dDXndEZzJ+OE1nNTu4cjW11XNacCc94he0nho7CAwO/cCBLTg0TBaR/1x8aXLZ7/
NuFCsY2OcINAol6/QjNahNCuo6PVOfbh3q6PLWLnTx/HCrFDsKaVh+lp1lciR1FW
i1xRGRWvLh8ClfB7TSGnrQ0ZaoqmBNjWJZrQjQ742ZWkvH+/nbonl15aGIgVuJ16
T9OtviEcV8BK5HUy00rk8kgOWJaJULP+fYRqQWv/ro0cTuBCFehO7cfwQWTZIvOm
3konfJtxJpKv5JZlrTlbIKTmyJl7A+/RddyBrgtewJS4rck/fJrCR0jdo+SA4jVL
I5iDhr46srEdq6IKXvpVUAKeDcFFU63zkyXKOlVpx42V47dDgf0=
=of8U
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
