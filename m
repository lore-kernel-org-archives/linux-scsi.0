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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C7EC433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:10:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A94132075D
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:10:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3aw98rP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgG2SKi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727866AbgG2SKg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:10:36 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C3AC061794;
        Wed, 29 Jul 2020 11:10:36 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w126so13174165pfw.8;
        Wed, 29 Jul 2020 11:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FjVLtakLnkTChcyRfYnpNb/VSLaNgBesDn6ACtOCpfA=;
        b=Z3aw98rPf2c2EdoB8RwBsFO0TgAEQ1qheF+QYl7XJ77U5H4WeC2uHZ5lXbEngQr3vq
         1SnRyQkmviqW7mJjaXZ0UHdaqgNjyX+7CIN5DIwQT+vH1l5X9vQIGlFufr7cnAtQdtge
         LkJkAueCZpW3eMIM8GVg9NmPuX9yc6uZYsNzcQzfyWyoNrfNUYsU9UnHM5YZDTCv+7u8
         SG7iGE8qokUOsKVC94Df2l4z4kFg7n4WDDuCHutISnMJPC5OGT9wCoLFgGCBB7BUN+qN
         MY1rC20niX8qO1FhgfbxNcO7ky3VTVS715gsv8qD2X+2S+6IHPlelwxI9qOK6zmEaFQN
         J0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=FjVLtakLnkTChcyRfYnpNb/VSLaNgBesDn6ACtOCpfA=;
        b=h21v3dKb/5ehC056kFWSg7E4jmjMWvOBu3eOKK7dZo2TjZtzLCcK7SSYhuJLzwyfmV
         yzUFeQ7ylguJ/n/kamy9Pq75UtVlNPhINWLGFlNh0WUyQwuTH9OqVFgRUxq86TO6Y0/C
         We2LYN0AarMpZ+eQQ+Y3Lu3KWDf7Iz7npiadqBJYPEQkMuut9oDMGD3uMhfeErurf6M3
         JfIXoZqaaK0qPabPH9f0hd+KgpKXXA2nVda8vrCcJsUNdggYVMBijGzvTXYJ/to0a7++
         g8HB++1K8de0hdN0ccFczCESedh5rnmpfmNvFHcgjxSlozX3K3PGBcLo5/AGfl1aRA0h
         BAjw==
X-Gm-Message-State: AOAM531aaTgfxr4A+YzUOF3dLCM4wWcWIVzGaa1oBOWn8gwGtHHZSz6Q
        Q/9KtJN2YflP9reorPbiG4Y=
X-Google-Smtp-Source: ABdhPJzRQqOo8JlwItJuw9aDoVwtbmxErFCN6sNMOPtjtpha/JtV8hDF5HHWGqNc7F1KBc6q5P6GUw==
X-Received: by 2002:a62:1dc3:: with SMTP id d186mr15379797pfd.93.1596046235902;
        Wed, 29 Jul 2020 11:10:35 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id f131sm3146938pgc.14.2020.07.29.11.10.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:10:35 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:40:21 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 4/7] scsi: mpt3sas: Remove pci-dma-compat wrapper APIs.
Message-ID: <e825ac7108092cc8fa8d462dc702098ef10fc6a2.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--sdtB3X0nJg68CQEu
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


--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hu4wACgkQ+gRsbIfe
744pnQ/+L1/0iu3tEgfAUIuv1dK2wl3gSobE6p6zDAYTZKmFqCGuedXizHG1HCc4
LEnwZ8bBm8WGSC9AEzJEgpvxCKCLQDIrSGa11E4QShNJdx1tl689CdTMAwob2YVJ
F4SJJFDeRf7BbGROlUVV+Vdpg3e0G+HXIYtlPM31pCsV1tboAjNRPz6IgVXwWJwW
ylgmj1GZbJAXa8OnJZ1BVc+lebwxgJnPrCUjR5oFd0Z230ymZY6XM4iCRVKeIDaZ
uPhfjjR7b4ECIS2ZeYtvXLNb54t0wSXByMc2aeLhdTxCS2XruTL+PTsyDmnTSgF2
Jxl9KjF4JxoOU5JCi3Df++PpHFH2lbezOhVauGz1EBex6jtBuhVRxADjfp8+oRAM
ULpcGJ3ipGCh6OoeWPt4Ge3bpfUQmibnHxaDsxxEibtWZ4tbhxPE+yvfBWbrYu+U
3L9nUFDUhjHHSFdfEI2AfBgo0wzGOoNt1t2SWNE8xJPwAActVxk6rNFjlj3WgzEd
N4ibYk1K3TdC9cx4z8MpQaP1W1C0cJk4qJ7QVO8OzLC20LTN8CpSRoIKylwJbDNe
NM08fSaum+XzVTHTcBIRQhVwgKFRKnxTtt7xs4Y2AXGyKp/HvGptTG/PbJqJhwC7
jsGh7y1Uue0+bxEYAngEDUIieVd9BVdRRJYAMrnDwwrcv+AX1qU=
=b4xk
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
