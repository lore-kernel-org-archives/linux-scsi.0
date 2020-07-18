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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0387C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 933AF20684
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSW/TUfD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbgGRJfl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgGRJfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:35:41 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D78C0619D2;
        Sat, 18 Jul 2020 02:35:41 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k5so7525636pjg.3;
        Sat, 18 Jul 2020 02:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=2NvG5DvW4nGU/Mk4ldCs8dltAByMdSmrH+ohJqnmURI=;
        b=LSW/TUfDSKF8FNo/3zAnqv5qlR0KZP5tINQtMFl03LJj5QF/h+qIXJeN5W4I1rvpd5
         9wyK6RLMM6Pg4uxSxWqvSzEuKyEOW0C71bJqA0Mer4jUwAsyHMvk2iiu1YNPhOivahzs
         SA4sU4OGEKPqhXahTueHdHpF/kVu4pgGchY/TgHjte760jJhB05MLEnh5mHGf7LKzM4N
         OkMSYeYnTdBkuF+9hxVexelSO8CA4Io6lgpAI2Z3M0LCgHbuNyZJgI2guiFQ6cac8R9a
         H22eMvCAYZ2xwXnRRaRY/gwVhRqWkgiZ5EIShpY/+B2Paufyh2uv1Vx0FTe51HiFpJr6
         RjDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=2NvG5DvW4nGU/Mk4ldCs8dltAByMdSmrH+ohJqnmURI=;
        b=HNURcAU9DptTcCJzltmfpzw04pcz9+pP9mJHJe0pvnDQUpc09ZvXOwSQdCQ6nGKyYk
         W+DPwrrmDrMOgdbPP2mJ5T58tsVqNNzFDeEcKFL6eSt2jcx2TApYzWYZmzlSiFyTNrTi
         0tsNcY/GuinB4jS+ubeubMls3UlY2A+2gyV4T7qUh2GouAqIO9ptn7MSs9BRpggeyiZw
         XG5XxeoVufjhSMHfmIx1JRU8QJfa3NGa19TfomB4/cJJ43k1uRPpnAh+BN1DQKYkVx4v
         2SlGbQ6GgDgplsZt/yobtXCbkJCuOOUKOYLPk9KmmLi/KVxIPtwdtympv5T85jB9z8FP
         zyXg==
X-Gm-Message-State: AOAM530CmgNykpWWqpuEiak8GVYIqYraiTP3HIJRBBq2xgRXKzlQhUQ9
        1r7YKDRBdQJ/FO6n31Wztow=
X-Google-Smtp-Source: ABdhPJzDvqdldI4SMN9xDMucnkUYNi0IJcPuKFADkRx2/bdpsZpF3neRj2cCptvKY26ouMp38WD6Ow==
X-Received: by 2002:a17:902:7441:: with SMTP id e1mr10585693plt.23.1595064940466;
        Sat, 18 Jul 2020 02:35:40 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id g12sm10141155pfb.190.2020.07.18.02.35.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:35:39 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:05:26 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.peterson@oracle.com
Cc:     aacraid@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] scsi: aacraid: Remove pci-dma-compat wrapper APIs.
Message-ID: <20200718093526.GA1628@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--oyUTqETQ0mS9luUI
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
 drivers/scsi/aacraid/aachba.c   |  4 ++--
 drivers/scsi/aacraid/commctrl.c | 15 ++++++---------
 drivers/scsi/aacraid/commsup.c  |  8 ++++----
 drivers/scsi/aacraid/linit.c    |  4 ++--
 4 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 769af4ca9ca9..959b3ae8a99e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -2229,10 +2229,10 @@ int aac_get_adapter_info(struct aac_dev* dev)
 	}
=20
 	if (dev->dac_support) {
-		if (!pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(64))) {
+		if (!dma_set_mask(&dev->pdev->dev, DMA_BIT_MASK(64))) {
 			if (!dev->in_reset)
 				dev_info(&dev->pdev->dev, "64 Bit DAC enabled\n");
-		} else if (!pci_set_dma_mask(dev->pdev, DMA_BIT_MASK(32))) {
+		} else if (!dma_set_mask(&dev->pdev->dev, DMA_BIT_MASK(32))) {
 			dev_info(&dev->pdev->dev, "DMA mask set failed, 64 Bit DAC disabled\n");
 			dev->dac_support =3D 0;
 		} else {
diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctr=
l.c
index 59e82a832042..a374273da12d 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -670,8 +670,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 					goto cleanup;
 				}
 			}
-			addr =3D pci_map_single(dev->pdev, p, sg_count[i],
-						data_dir);
+			addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i], data_dir);
 			hbacmd->sge[i].addr_hi =3D cpu_to_le32((u32)(addr>>32));
 			hbacmd->sge[i].addr_lo =3D cpu_to_le32(
 						(u32)(addr & 0xffffffff));
@@ -732,8 +731,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-							sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i], data_dir);
=20
 				psg->sg[i].addr[0] =3D cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] =3D cpu_to_le32(addr>>32);
@@ -788,8 +786,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-							sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i], data_dir);
=20
 				psg->sg[i].addr[0] =3D cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] =3D cpu_to_le32(addr>>32);
@@ -844,7 +841,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p,
+						      usg->sg[i].count, data_dir);
=20
 				psg->sg[i].addr =3D cpu_to_le32(addr & 0xffffffff);
 				byte_count +=3D usg->sg[i].count;
@@ -883,8 +881,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-					sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i], data_dir);
=20
 				psg->sg[i].addr =3D cpu_to_le32(addr);
 				byte_count +=3D sg_count[i];
diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index adbdc3b7c7a7..7c0710417d37 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1561,15 +1561,15 @@ static int _aac_reset_adapter(struct aac_dev *aac, =
int forced, u8 reset_type)
 	dmamask =3D DMA_BIT_MASK(32);
 	quirks =3D aac_get_driver_ident(index)->quirks;
 	if (quirks & AAC_QUIRK_31BIT)
-		retval =3D pci_set_dma_mask(aac->pdev, dmamask);
+		retval =3D dma_set_mask(&aac->pdev->dev, dmamask);
 	else if (!(quirks & AAC_QUIRK_SRC))
-		retval =3D pci_set_dma_mask(aac->pdev, dmamask);
+		retval =3D dma_set_mask(&aac->pdev->dev, dmamask);
 	else
-		retval =3D pci_set_consistent_dma_mask(aac->pdev, dmamask);
+		retval =3D dma_set_coherent_mask(&aac->pdev->dev, dmamask);
=20
 	if (quirks & AAC_QUIRK_31BIT && !retval) {
 		dmamask =3D DMA_BIT_MASK(31);
-		retval =3D pci_set_consistent_dma_mask(aac->pdev, dmamask);
+		retval =3D dma_set_coherent_mask(&aac->pdev->dev, dmamask);
 	}
=20
 	if (retval)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 8588da0a0655..7d99f7155a13 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1659,7 +1659,7 @@ static int aac_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
 		goto out;
=20
 	if (!(aac_drivers[index].quirks & AAC_QUIRK_SRC)) {
-		error =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		error =3D dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		if (error) {
 			dev_err(&pdev->dev, "PCI 32 BIT dma mask set failed");
 			goto out_disable_pdev;
@@ -1678,7 +1678,7 @@ static int aac_probe_one(struct pci_dev *pdev, const =
struct pci_device_id *id)
 		mask_bits =3D 32;
 	}
=20
-	error =3D pci_set_consistent_dma_mask(pdev, dmamask);
+	error =3D dma_set_coherent_mask(&pdev->dev, dmamask);
 	if (error) {
 		dev_err(&pdev->dev, "PCI %d B consistent dma mask set failed\n"
 				, mask_bits);
--=20
2.17.1


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8Swl4ACgkQ+gRsbIfe
744DTw/9EyFyGAd8FmA4qRvIIvrPGOowxXn+QLBK6weURjOu2ctBWl0eEd4hj3P8
6XRUVFKNzUl64hJl6JCWTJUpWK36vDDMSLaLCin7yz5YSyQoDocs8DaOvtcAEmu/
NmfdVEYYVCCKOiNRWNAgYo89Xn1xD6xBIh0/2mAycjUk8eS0JfuxanBWIC4MNnwC
u4c6Ck/Ephi2yHUeuChqvxWVZncYLC2y9SFR0TUpSxkd3WolSsosq8PPBc3CHeVP
QqXv4q0C3svL2civkWkQeq3MoY8BNBgoAaBMNexOzpDoE/K7cfwrMBFEzXR62QZr
MR4hpEtgeFXAk9ISma0lSXolhJywCMo+TB+52x8ccSjilP4rHxgl7Jf1POH1KQOT
K/wk4bCiPzXG7DUJCnR0cOCB7pj9wD0FQw8otLHnmqwLU1yWo5MzogWtK5RJ5ySX
8Biq+s7ytrVihvKVjInuoQICK674wHyTBAh/y4U1tLaG1gGdEeyJ4fY4MpYSBW1M
gB29ctjHn9paBu1dsQJxqddX3VllNCnN2PCI93VFSV3Y3c6s/G84m3YFR7Ovo+58
Sq9kW+jB1MEoYXRog93snAfpwa9y9MvghSTbUDAmuFiLW1inp64Dq/2cj3AJS0zs
RrAE1TZzMpAGjFkZowXwR2C5Zv/I/g/pkIEFKSQg/99C0Olq2do=
=E6V6
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
