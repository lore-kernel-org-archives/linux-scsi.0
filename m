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
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC80C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA43220691
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:43:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MXK/qnd8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGRJno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgGRJno (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:43:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6D3C0619D2;
        Sat, 18 Jul 2020 02:43:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id b9so6496265plx.6;
        Sat, 18 Jul 2020 02:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=n3E6laRCCZyou004IqtLTCIEbaDDAJaS3lw+cd4elkU=;
        b=MXK/qnd8hKlYXVt3KfHNpiisWT0voakIUg2cZ6bSKmB4ZCG9hZxyqKHYfC4wKgUdP5
         jLHA4kSGPAOgenuGvw5B3WVz3s7j+NuVtCUu+IcVw8brL2WZ5w24OugVEMjkf3/zqrp6
         iEH58uWf4MeztnAwTw/CJXJx/vfwpV2CbLL8pCHL20DMHqhm9++hOtPbsreDVkXPtkI+
         nB1qrWrZzoJOihN1yhkYA2H25Q4r49uPCYS62VBKzVVoWitbIZtJUw/A9j0SML5Vs3nj
         eR7ss1yrFvMvT4IJSPFUOk1X0Z4rbCPBYgXCCAi1T8gMTqDWFF9mAsGncz+bLhBNd3JB
         F8HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=n3E6laRCCZyou004IqtLTCIEbaDDAJaS3lw+cd4elkU=;
        b=rv8Pv7AnlC2VAJB2NXheJFNP0DckQigotH7ywmApITsp0R203N8Zw7JWrU0VbWESuW
         1mzTt6lurNVEZy12PXlcmvX6MWmxJER1IHzswPYXyaE2z48IjesEBdfmP3guCGbcb3Mx
         jNoWhbXvIXt6ZyjhldcZ5BQKfuOCLDWab4ZzBDiYFTLw9ENrcXjLRAJv3/84EFdMYJcV
         2DgXjt05gck1cJNPyGzlwOcdT0KoUr8sAz8lti/FHQVS/4AmMc6PpSBFV0hb0eYaHVX4
         yyxguq8sFVzv7Y78rT/F5Sr/567UbNwb1fvvwiy1pah55nJ9y5C0msmcLovCI8qmyufI
         t10w==
X-Gm-Message-State: AOAM530fLbVCtvhKGt963q0Lq3VPg+ECr45phV2FOwVYHcSMrYkd83Ev
        321v8P59pwagDFgdNwZo2gI=
X-Google-Smtp-Source: ABdhPJyIdPd8UsCgsngZoOnr3SkJ8siU0eFROu7sh8kgPeuHs9crYJWvw1tq/We7f5AJQQd6Csatmw==
X-Received: by 2002:a17:902:7e01:: with SMTP id b1mr11092807plm.310.1595065423402;
        Sat, 18 Jul 2020 02:43:43 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id e28sm10019728pfm.177.2020.07.18.02.43.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:43:42 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:13:28 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        jejb@linux.ibm.com, don.brace@microsemi.com
Cc:     dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, esc.storagedev@microsemi.com
Subject: [PATCH] scsi: hpsa and dc395x: Remove pci_dma_compat wrapper APIs.
Message-ID: <20200718094328.GA2102@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fdj2RfSjLxBAspz7"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--fdj2RfSjLxBAspz7
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
 drivers/scsi/dc395x.c |  6 +++---
 drivers/scsi/hpsa.c   | 16 ++++++++--------
 2 files changed, 11 insertions(+), 11 deletions(-)

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
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 81d0414e2117..ef90391a0269 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -9310,10 +9310,10 @@ static int hpsa_enter_performant_mode(struct ctlr_i=
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
@@ -9363,10 +9363,10 @@ static void hpsa_free_ioaccel2_cmd_and_bft(struct c=
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


--fdj2RfSjLxBAspz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8SxEAACgkQ+gRsbIfe
744z8BAAhFnIRbfi6WbnHL5KgP7zhtbr92R+dlb7RWiUu9RCKefHOfmPmAUA1/wk
m6DyBN6Q4FumwaCebYIBNrFxwNJBvcu2q7Me6R+RdMjugKKpsgju8MFzP9QepLFJ
qnucUPGrNMHhvTbLFU5gwOWlV5yAkfssTGYGhy/UYiBCwkWvxBYgLRnxLgBOXKWY
BLmlKwDowRB9W+HC7xUjEIFPeAJmB2+W4l3X/5YGSpX0+xip9vfgMqNBDDGc+z7e
2ZHVPbmk5zFbttCYf4E42nDVUynf9gz8RYEbfGHpv6atMYJwFKPHpn+UiAeN7W2h
nq1UkEj7hgQ1N2IdjUlxQxS8PT9USg9SEWhXiseMs2YjQ5XxUjqv6314qhcOv+2S
VG0i/NVDo0sfWOGTepe92ka7n00orHXayp3MB8xkx5H1RT83GJeJqoU5Z8JLNmRu
OeevS6cguRwyZjuBxEKvNoAMGKzyiDrCrvMhxgLjMt6NO8P3SmopSpATanRXCuCf
cyDYBXGMmt/O6IlfmZ0n4CTtLOLhanIPng0Wl18kwP0XupspBxCmSno6tMyb/eHD
+NOunqL/qTpdmSD5/Wn+fQhlezzGhaH8HRY39QR89gyELjZxWTTZcgqnzvbPYTrF
PqKYTn6VgQQQlnkgEUF2j7/uGIAm2eST5c8oIpE8q7GAJzjbwlo=
=ic8N
-----END PGP SIGNATURE-----

--fdj2RfSjLxBAspz7--
