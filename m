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
	by smtp.lore.kernel.org (Postfix) with ESMTP id F34CBC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D4D0A207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:06:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eluQfMTa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgG2SGp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgG2SGo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:06:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD618C061794;
        Wed, 29 Jul 2020 11:06:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k13so4352367plk.13;
        Wed, 29 Jul 2020 11:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B2KfWF3L6+xMOlLZwv9VkcvnCAVH1M+CNRiBEZLmWhE=;
        b=eluQfMTaE4khwO2NE25f3rFEC7Wc451hqODZ6I1ZVvV6OnpogsNpY1WhfluhzwbIct
         cpMorHPkLXqhjnjl48pq23lUwlAzpYPcsPQACKjdyhkF035r3ULy/ChFV85ldawt8CmG
         T767w2spITiN9WoR5oB6qCkqv71M1TvZ7wGdMRhz22UYNLbtm2pKokb+Y2gzC4ue9BFr
         87U9644g09oV1Ehg3EEG5uSr7ywLqVI0KlO17yLsqQq1VqbyZQWRmZ8NpTVtQ1Oj9viK
         tiVVoQ6tMvboKaDbPlMXORvTkx/qS4OurrCFyDM8Iz63kcHTt9xS/cKSHTsDbrwNpY1H
         4mYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B2KfWF3L6+xMOlLZwv9VkcvnCAVH1M+CNRiBEZLmWhE=;
        b=RvAg8nSRU+Wb7/CM6V6eCgVqUa23kALs2ycjv+A8GbIHWuaFHDFP3VyEStquw/zsTT
         KjLbESt3ZZ1lAyo2kep9p6SqaKqKGZkC2TzwzVIp8/GTSKBrngvhqgbwdJCQS+eb2cmF
         gzX4v0ucHJTJB44JjzJ8035cVWLynm5RjDiDYNUrjQ5F8m/s4SD7qw/19RR7++VoTlWu
         cwLC1rwoOMvvPCN/JcTeyNMetuSKHs8SypaeZrAEWvFs2G2JP7LalRIED/qDXqVxLrqu
         dKcG3V9peJc1BLfg+Oc2504QPHRriZY0MNll6AjhFNNETQlTZDoibDU9snpFH2zfWUXV
         05wQ==
X-Gm-Message-State: AOAM533SLhK9fNkpiuqvQ7qmjsJz88O8TRUCAtX+eicJeQS6NuUeTUCh
        0ur+TRI31QEUML//kpn5NW1QiJAaRtU=
X-Google-Smtp-Source: ABdhPJwj5VcH2rXvjdnOMTAtEOD94KDLplNPF+08mdR38dQ1bN2sOy+HgBcY4a67R8m+LEQLjPPhRA==
X-Received: by 2002:a17:90b:3685:: with SMTP id mj5mr10896577pjb.123.1596046004287;
        Wed, 29 Jul 2020 11:06:44 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id 17sm2812324pjl.30.2020.07.29.11.06.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:06:43 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:36:27 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        aacraid@microsemi.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 1/7] scsi: aacraid: Remove pci-dma-compat wrapper APIs
Message-ID: <f8d4778440d55ba26c04eef0f7d63fb211a39443.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering for
include/linux/dma-mapping.h APIs.
Instead use dma-mapping.h APIs directly.

The patch has been generated with the coccinelle script below.
Compile-tested.

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
 drivers/scsi/aacraid/commctrl.c | 20 +++++++++++---------
 drivers/scsi/aacraid/commsup.c  |  8 ++++----
 drivers/scsi/aacraid/linit.c    |  4 ++--
 4 files changed, 19 insertions(+), 17 deletions(-)

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
index 59e82a832042..e3e157a74988 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -670,8 +670,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 					goto cleanup;
 				}
 			}
-			addr =3D pci_map_single(dev->pdev, p, sg_count[i],
-						data_dir);
+			addr =3D dma_map_single(&dev->pdev->dev, p, sg_count[i],
+					      data_dir);
 			hbacmd->sge[i].addr_hi =3D cpu_to_le32((u32)(addr>>32));
 			hbacmd->sge[i].addr_lo =3D cpu_to_le32(
 						(u32)(addr & 0xffffffff));
@@ -732,8 +732,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-							sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p,
+						      sg_count[i], data_dir);
=20
 				psg->sg[i].addr[0] =3D cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] =3D cpu_to_le32(addr>>32);
@@ -788,8 +788,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-							sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p,
+						      sg_count[i], data_dir);
=20
 				psg->sg[i].addr[0] =3D cpu_to_le32(addr & 0xffffffff);
 				psg->sg[i].addr[1] =3D cpu_to_le32(addr>>32);
@@ -844,7 +844,9 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p, usg->sg[i].count, data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p,
+						      usg->sg[i].count,
+						      data_dir);
=20
 				psg->sg[i].addr =3D cpu_to_le32(addr & 0xffffffff);
 				byte_count +=3D usg->sg[i].count;
@@ -883,8 +885,8 @@ static int aac_send_raw_srb(struct aac_dev* dev, void _=
_user * arg)
 						goto cleanup;
 					}
 				}
-				addr =3D pci_map_single(dev->pdev, p,
-					sg_count[i], data_dir);
+				addr =3D dma_map_single(&dev->pdev->dev, p,
+						      sg_count[i], data_dir);
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


--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8huqMACgkQ+gRsbIfe
7469+A//YC9Izwf7LXngOOOYVrtTTGe0nV7qhzjk+l/3CfzDXYSA5nUCz3uF0/Ox
zRmKyQPCATgVW1bNjqvw4Pe1cqFNxZEKYCVB+v6X1szRRq/bdNY+syTBMUTSVPGJ
aZ8qtyLoLmNzFCyNpMYst2Rvn1Yap1PbeHi3ShSo/UyyrzcvSMwJPemHAnem6naR
SQi/6CB7X9DFhBRHkiaTFEoyD2RX9iTJd9TxOMQ5zyiMVcAFRhJKHqUTR0ZSXsAP
huPpIG3/xtJX+WVr0juhmoy/dLjlJQb6RONUzKA4fw/CTjgT/I/NbtPmUjtJrrWn
EIZDWDypXi3fNApR1fSLnC1yXWSNAe3ty/WwyscCvF+WsKVICGNCw98EffQTU9T5
SkC/NrzzukjJZqx5UHTJ4tmpShyUpK4r0MP4WppLfYZLtCgv9+AdmfRQOseuxUd+
C/MMSPBwYNGYuZTyuANVLmwBTcNdYVSSMSwDf3Z8BcfFc/ehsblmGpaeF+jKM0HK
ImJMtTXlZuB7rEQabbjclv8MA3GQwYr0KbLlxeRs3GpR6fJrjNsElYsEtXzNE5Z+
QoGdcnfPAlM273FjIuySD63mnV7dQFAXr/Ag7tqQJ/EP4arcXX+QvhhYjBODKdQK
k38ElZ6CneIXGCBd2fDKQn72cHQ65qhkgXbSmw4ZSADmE2J9iR0=
=lDK+
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
