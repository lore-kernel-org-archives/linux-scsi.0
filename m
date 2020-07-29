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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F83FC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:11:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7EB2083B
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:11:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ogl5axki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgG2SLc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726509AbgG2SLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:11:32 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49074C061794;
        Wed, 29 Jul 2020 11:11:32 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id s15so3158805pgc.8;
        Wed, 29 Jul 2020 11:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yAh8owI2oyYhWMiiYjqiiKpF84ZnFMNUd5g3cqXC4rI=;
        b=ogl5axkiIz3HPEN20QlCfE/JGHFxAnZNXwOU9qkakFUBeM/QyrUEusIaXCWY3XzuCm
         wsZHbKEicdMrABMsVEVP2Z9ZXPLTX7dySW1UqQQjwTjrPn0j6LsdZDh7maylM+nbs9vg
         SDjmWEQ6O4eAJdN9rHReKpZ9CUycOzVTIvRgurj4QCbdj70/9MT4kt6i8+t2qql17Cng
         BRyAR7PN3YxCWEzrCkQM5VlYqy/VfE16AeoqMDm0rLVacf0xgddOVQXWNMINGqtslnni
         JwHxbc9+xgOpzOLuKL/yjJ6/E7NBKwiXDWpFEjo9Ss0UpbJgfyIDgPSFDZzWQxNXSEUg
         Phnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yAh8owI2oyYhWMiiYjqiiKpF84ZnFMNUd5g3cqXC4rI=;
        b=CbQd1WYoGcEl7yTFVMgCTuR/1gkVR5Nmipi/ty/Xl1/xgSSG3/0fD6EuwDac/tyz1K
         W6Y7jJnFgPL0IjC3BNExoLYTWLZz6/bbzSZp/UIY7nfTgDOgUBSCKzgOsmUKY9zonXce
         FhwriGg1eIaVLMlmM/hxuTYWa/oL3Uck4fmiAAv0TPtp9I6nH8llz68HYLGU0fsnLfUo
         mgvILPD2sAAf0+smdhLLjBTNGIJUM9SWnDeQi9sqh9y74v27MikI/4Tf0tyGTJO/cr8t
         8cZT7SqjS0JjZyNX96pavGCGPTqES/7sVdzpbq/iem/fOIUPAgYf3Aw035p2YbEnS7xl
         StPg==
X-Gm-Message-State: AOAM530L14Hq4uGSpIA/AmH1TX7oNxBoP531ZRDRYGsu7ybh6Wei7qe1
        HZ8heFF0HbqXfHzRxDf4gVc=
X-Google-Smtp-Source: ABdhPJzvtgmTo0z3FZ3NyMDyA2YjIhB1CeoA4/NV96oGLrmTpE/VmRO4iR3Pp4UIEOLiq3vWT+UqGw==
X-Received: by 2002:a63:5619:: with SMTP id k25mr30129698pgb.139.1596046291556;
        Wed, 29 Jul 2020 11:11:31 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id x9sm3321612pfq.11.2020.07.29.11.11.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:11:30 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:41:18 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, esc.storagedev@microsemi.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 5/7] scsi: hpsa: Remove pci-dma-compat wrapper APIs.
Message-ID: <37154a4efe82a58b9bad143608dd9fd37a2c94e5.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--YiEDa0DAkWCtVeE4
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
 drivers/scsi/hpsa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 90c36d75bf92..6be850de6f62 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9328,10 +9328,10 @@ static int hpsa_enter_performant_mode(struct ctlr_i=
nfo *h, u32 trans_support)
 static void hpsa_free_ioaccel1_cmd_and_bft(struct ctlr_info *h)
 {
 	if (h->ioaccel_cmd_pool) {
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(*h->ioaccel_cmd_pool),
-			h->ioaccel_cmd_pool,
-			h->ioaccel_cmd_pool_dhandle);
+		dma_free_coherent(&h->pdev->dev,
+				  h->nr_cmds * sizeof(*h->ioaccel_cmd_pool),
+				  h->ioaccel_cmd_pool,
+				  h->ioaccel_cmd_pool_dhandle);
 		h->ioaccel_cmd_pool =3D NULL;
 		h->ioaccel_cmd_pool_dhandle =3D 0;
 	}
@@ -9381,10 +9381,10 @@ static void hpsa_free_ioaccel2_cmd_and_bft(struct c=
tlr_info *h)
 	hpsa_free_ioaccel2_sg_chain_blocks(h);
=20
 	if (h->ioaccel2_cmd_pool) {
-		pci_free_consistent(h->pdev,
-			h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
-			h->ioaccel2_cmd_pool,
-			h->ioaccel2_cmd_pool_dhandle);
+		dma_free_coherent(&h->pdev->dev,
+				  h->nr_cmds * sizeof(*h->ioaccel2_cmd_pool),
+				  h->ioaccel2_cmd_pool,
+				  h->ioaccel2_cmd_pool_dhandle);
 		h->ioaccel2_cmd_pool =3D NULL;
 		h->ioaccel2_cmd_pool_dhandle =3D 0;
 	}
--=20
2.17.1


--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hu8UACgkQ+gRsbIfe
747WJQ//WJ543pOY2T9drubHzvRC4T95JyVGnSvtgZVBA7fLNXr/xdz9q9r94msv
zo2zBctKZcnqx7KeI1TC1WkjRzcMADaugp47O+LI4KoteMPxvQm11fJ4MUNNavDy
CNZhwSGCbybKyFWmsv2l42BDXzOTvX08ghN4db3XI0h64dyjXmli0M3CL/1R1fv9
wWoT3lCvrr0PIoNy0cTtdsqMK6WELvN6nc3H7+Kwb3fbqrKd2aruYtOi3ScWF1i0
rH1H/tOtRS/PPRRNvjFaj4i2zyVzaknG5WPIm7DhmlKUmNpNFjSdz0EhDuQOR5M3
WQBxy7z7jvJQ+aktiL+O3mA9Q2LfD/i7nK3FV+x3QjAlpIVM2HZr/nwD9KScLjxS
MWOILO0g8GO/lEr95EBTG18l1JAVRFQir1CJaqx1EDmBTJU8lFvVAfdeiVOjTRum
koTU9JuJoCWgy/ZtwBHvX2cU1nrP+xURpN+H8ri75DSNdzEytRqVeZNf7CJP8T6w
cou2rtx+cFjaRnz86KH/DBK2EfsQ6lqBSyYNESJYAsfuLpNghPq6DCBst07LFrfU
ljMtlbbSub39BGr1a6aIJnStLoi3hAw/0QbJMI8+4ySJ8W7krLwWzLqiTH+Mlfpr
mwdYEDOY20LrX8647FN9VZ1SWmxhBLXt37uXOzMELhGPbgSw4BU=
=g1Ai
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
