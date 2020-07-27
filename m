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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139AEC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD57720719
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="peHWGC30"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbgG0OmW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729232AbgG0OHZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:07:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B98C061794;
        Mon, 27 Jul 2020 07:07:25 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l2so2788348pff.0;
        Mon, 27 Jul 2020 07:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=rRa+fNv/h1FLu+e0oE4gptqf0fEaL6gJEA3JJuU10DI=;
        b=peHWGC30Cc4mA3aNsP0q1simXnVE+JXDG/VGM4rr2LjgWNKoOR7WolOdacYFzdz6bU
         Iue6nCpY7k7ThnLX3f2gtK1eVj27P5VSL4dXkrDAvRQBgl8SgaNxxv/D4Eds4TXdqYmg
         jbrRzyRDLN8JUq4CD9qD9ja7U8+wZWQwybqxr+yYtV4ZcXdr8xrPnGBitLIoeGGB/X+v
         9nqpEItJUw5nWDi4Z3mCh35jqpRjjlPFatlFkicfeHbjbqiVObU1UyYfG6YAHf4GUj9t
         vojKLcNOOV+Whq2u7UWhAzh9+8iyAB/daxYBQH6hJTgCSnBCZnAdlfbZriKVkn1pzoKr
         oqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rRa+fNv/h1FLu+e0oE4gptqf0fEaL6gJEA3JJuU10DI=;
        b=I7IoomyFVkzi7fwzg2rCnKM6srqnetTQuNsaSowOXBopEeFLDdgmPJC8HoAX4GqRWu
         3rBXxmU+tDuoZktNL1uy18w3VfupdJVga68utFv8O9NLXq6k5LYGzCZOa3k/SHVKTa42
         hdB+c/BhqRZPUV9qoWQxnG/V8X6u7bFiHCTS1vxprTaX/FMe8prKuMFRyhqVdla0LYqp
         LlUukqOLDeIu3INxghEPTU/9KXalgimjIti4ty9/usglZbT0B+JJ5IIYJoW/sHRJdUnF
         FH+w3z+2wZsx3JiOXrKdMEMAun3mN5vspZLrd/gYMa0NolyUn4jeI0qrQa0D88upj2qm
         ZIzQ==
X-Gm-Message-State: AOAM530o/rTFUAFbO2DrICdBlylIZlZlccyQ4lVzL5rkHyBFG28XX00F
        gb4hraNtJ5HSxT+BSox8Gk7xaT3+8oQ=
X-Google-Smtp-Source: ABdhPJwyQG7PnT2nCaXWxsHbL2qpIG3kNtO1WyEmRdXQAB+5YOW+5gNsYZR0JpVmHGErRsOzZv3g7w==
X-Received: by 2002:a62:164a:: with SMTP id 71mr20981392pfw.266.1595858844659;
        Mon, 27 Jul 2020 07:07:24 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id n137sm15266576pfd.194.2020.07.27.07.07.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:07:23 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:37:18 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        jejb@linux.ibm.com, don.brace@microsemi.com
Cc:     dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, esc.storagedev@microsemi.com
Subject: [PATCH RESEND] scsi: hpsa and dc395x: Remove pci_dma_compat wrapper
 APIs.
Message-ID: <20200727140718.GB14759@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--pvezYHf7grwyp3Bc
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


--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e35YACgkQ+gRsbIfe
745LERAArCx2Ge07lVIKLK0+ZHYsHsU+GUJH4CMIJ6cWPDmY3kPrWA68T9/RwPhv
T39sW+NRyr4qrQL15WFOST8/x1xXIZKh76wGu8LMsan+UFwzxN57cAq2dzCQJ7Cp
o55GkPNParldjorb4EcE3lKHIG2Yx1O05kUJ4WV/Zfllq0L2cT7BFYf0ggqFmnLo
0pqh6TPH+yP8DdeADX0fe99/wLHr9jZSy/DnwNkfS4fU5VyAIUcDjdlDTX8gQ72r
m8etjUazpEhWQK5rDP1vX0QOY2RM7g1gunAKR3J0x+/5shEmWFnkkfJrrCcAz37R
JZMG4mXA1Tgb2bFtYtRo2bZgJlyPtDGr+LegnW5TiWLUGhTOXx+z282mids0P65E
tsdel8P3gHgRuYrp7rC4a+QVqhJLEDLYB8Tfj3T3j46tykf3CA5nLZoJ12uJGxRK
CgPyYNtt0r0YHEGvgEBnRrO06jc8e5Of+mGCFGQYtc+FNXOHmE8C/A0u8b2hqPeE
03IAkIhCLTqefsGn+fFkIraZtTiA7Et81znkBh0bY5W5loYWUTl3agGgJ+rv/VpM
v1nwVCu3jwvOoPOHVzfELC8pu/rpgkrO/36XEbjMbQ8eIMDh/4036yGiBjx+Cw+/
EXpiQQQ7wo8+OvvWg9x050ql4JxGq0h36KrBLLnxhGqGWxwRCxQ=
=myJW
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
