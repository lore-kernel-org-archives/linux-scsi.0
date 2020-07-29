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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DBA7C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C4482075F
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UrOswiFu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgG2SJM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726606AbgG2SJM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:09:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3585C061794;
        Wed, 29 Jul 2020 11:09:11 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so6487168pfh.3;
        Wed, 29 Jul 2020 11:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sfPOG6a/47cUtALYSnlvnZ/WCh4i+al44aw0zmYjang=;
        b=UrOswiFuZZhn7uoyGWLSFZsV1RbtprxsD0S5/apScsqI3N3xK3Hxa8rCh0jK2GuiFv
         dtmU9p7g16P2a9Liqnk9mW8m1VPQ+Nlb3Gld6fOLXjetzOiAROMCueh3Dw2vnyQXszDx
         wxWRthkdzuVdIcfzFFFTvdpiZxWTyZIDdq+RXA0i6Ae7NSmF9hPm//Mu2jVBZgB75DrM
         +Oky3bbQPfp5WfiWcYxGQH1kCr2/NE09Px3ykC6Bm1jCnvj2p2lv49d8kQfJthsbs4OU
         XwCpwEq4nVnvE1EyrVO1xj0iO/qzkxIZHCB0i6P5JEzTixSVg1s68X8ZTJtCQEuXkwbW
         bcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sfPOG6a/47cUtALYSnlvnZ/WCh4i+al44aw0zmYjang=;
        b=gG18iD0tl2Mx8nQeXVaQCRMsHZhfZfd/G2p+cg2SdINkVY7ytVIEwhuZRN8zXvCVNW
         DlBawSzyGT/57V7dR46P2HBpOQfSZ7BMI+lWhjCfQm9Tibne5ejJ1PRDFCXXiX4DRxwo
         xOBRT3oB1cWWcF3G1UPSb9g+X5MUa6adTMtXQp2+QwacImL7xDQQycYvR/YIJjwOc1Fi
         ZgtK/RPxWUiy6Ukia8H8boWlSlu+HAahp5H1a8Av7Z31UharKqCTsa9jaHH2esB5qAOU
         g4SIZO2vvLqioWcqmkGPwwUFJ9LgyQupaT9Q7Uy+DAkgNSlPxStBtmL1ucDUouA52LL2
         XRfA==
X-Gm-Message-State: AOAM530iq4iM9au7gV2GdpRBTrFiejHl1uKySdJrPriCBYkYOCBi3Rtj
        LdeMYcPA6A8ZwJZJQoOJWfQ=
X-Google-Smtp-Source: ABdhPJwV3nArYEU4oL7nEaqu3Z7hw2oYoxv+xYvZJDjnXh+nBXIKqwdkdo68TPhpbOujjV47+doUhg==
X-Received: by 2002:aa7:9189:: with SMTP id x9mr29558415pfa.325.1596046151452;
        Wed, 29 Jul 2020 11:09:11 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id g8sm3074779pgr.70.2020.07.29.11.09.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:09:10 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:38:55 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com, oliver@neukum.org,
        aliakc@web.de, lenehan@twibble.org, dc395x@twibble.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 3/7] scsi: dc395x: Remove pci-dma-compat wrapper APIs.
Message-ID: <b8acc51ec774507050a9e9e8edf28e4933322a9e.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering for
include/linux/dma-mapping.h APIs.
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
 drivers/scsi/dc395x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 37c6cc374079..58d4acdb0447 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -902,7 +902,7 @@ static void build_srb(struct scsi_cmnd *cmd, struct Dev=
iceCtlBlk *dcb,
 	nseg =3D scsi_dma_map(cmd);
 	BUG_ON(nseg < 0);
=20
-	if (dir =3D=3D PCI_DMA_NONE || !nseg) {
+	if (dir =3D=3D DMA_NONE || !nseg) {
 		dprintkdbg(DBG_0,
 			"build_srb: [0] len=3D%d buf=3D%p use_sg=3D%d !MAP=3D%08x\n",
 			   cmd->bufflen, scsi_sglist(cmd), scsi_sg_count(cmd),
@@ -3135,7 +3135,7 @@ static void pci_unmap_srb(struct AdapterCtlBlk *acb, =
struct ScsiReqBlk *srb)
 	struct scsi_cmnd *cmd =3D srb->cmd;
 	enum dma_data_direction dir =3D cmd->sc_data_direction;
=20
-	if (scsi_sg_count(cmd) && dir !=3D PCI_DMA_NONE) {
+	if (scsi_sg_count(cmd) && dir !=3D DMA_NONE) {
 		/* unmap DC395x SG list */
 		dprintkdbg(DBG_SG, "pci_unmap_srb: list=3D%08x(%05x)\n",
 			srb->sg_bus_addr, SEGMENTX_LEN);
@@ -3333,7 +3333,7 @@ static void srb_done(struct AdapterCtlBlk *acb, struc=
t DeviceCtlBlk *dcb,
=20
 		if (!ckc_only && (cmd->result & RES_DID) =3D=3D 0
 		    && cmd->cmnd[2] =3D=3D 0 && scsi_bufflen(cmd) >=3D 8
-		    && dir !=3D PCI_DMA_NONE && ptr && (ptr->Vers & 0x07) >=3D 2)
+		    && dir !=3D DMA_NONE && ptr && (ptr->Vers & 0x07) >=3D 2)
 			dcb->inquiry7 =3D ptr->Flags;
=20
 	/*if( srb->cmd->cmnd[0] =3D=3D INQUIRY && */
--=20
2.17.1


--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8huzcACgkQ+gRsbIfe
747TcA/9H6YeOJ2U5ImXBbiuwJG9NV6jOsd4fh1XI3zZnWeQkwM6uV0hHGa/cIpG
M0GypqovQ6VCkA8FDM3I6re5j5f3u+lMMFqDUmMB3+R20TX51MzJpJJMK2C8Zn55
aWXwA0B0Ku75+mNYjfKs/0IIWQFlDgY3xBXbT35JfmZ5xJDMgd1EeUsGMK8HqEm7
N0l0S9Z060H90GtZ3Eh7ug1dEErd0X4bTeijtJ2Y4L01Mrx5ZDft8KJPwbr4/vnE
2rO+LzRkRAavvjUhyaRbOZQz/owoy2KJu5ZbIjfmRmMIe+UT5CM1FppsZkUfMPSD
RPhLBKcE9BbdIz+fGcKRyrHOje20kR11zioos344bF1/B4D5QoN3u3roosjz7599
U3qP9JHgIXbyQ/TNGeqDffeVwnktScpmP+ZJ4uPmxNnxkzns3q1mVl/7/KXPB4Zp
MmGBFcEvViWeaHHYilYYHQumLzHo2i4ON7tE16K1cNRxLQD0rbaGXigxw50RQvWX
uzP/hhThuuVYZ0T+MHkRZQtGY7dLctX/GjSyq+oF2s9cwyh5+Ds4xEIp/1brWZPy
er1vdjcEVBA7eaLKJLtFTdAvDv+NdfNNijzy3LSPFyAqLOQF1jwpab0JbcX+pUQw
E0HZyg7ya+kTvsrVXTxEZA4cGVqC6rPP1H82WMtejQuwa+scvuE=
=7PNN
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
