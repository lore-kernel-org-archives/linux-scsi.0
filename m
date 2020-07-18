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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D62FDC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACCE121775
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:57:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+qahgw9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgGRJ47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGRJ47 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:56:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A36C0619D2;
        Sat, 18 Jul 2020 02:56:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id j20so6621599pfe.5;
        Sat, 18 Jul 2020 02:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=5Nc15vAXVbMSZCDESpnXXbvL3leXVpnRqbUAuKmF2mI=;
        b=Y+qahgw9kKVEL0xt0wNc+wgeHHf+DZdBTBYjOYUiLJ8EUnxkZxbVm9nqP9fuNsvO9t
         trfThw7s2kaqmUeMKdoOiXErDEzvLtQ/jT1j6jkWUjiScdMQO+ekX5lDhpXHb8dA1hCU
         L36xGLWknx0NZzufrYpubwA+S5s9q1yoVj7804nsJJrCo1LIld8NBnD2nP8xPZSobsmC
         P0sHkR8mVDtsghyKenf6i4RcUN6IFa/GSCs8/iix4DqpAQhgvQngwgSVBvIYgJcmV1Jr
         P8gfrXsMY5H75pmpTbfUX3WYR5AKpWBNUz4ZKWVMX8jmo3QH/1OyNXtkIPrBVIX6FChZ
         oApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=5Nc15vAXVbMSZCDESpnXXbvL3leXVpnRqbUAuKmF2mI=;
        b=FIlqmRSkuspDNr7G3ke7mDg6SpY3e+mm+VVYdng0T+WayLbaGvFSfBhIMuSeiFOqSb
         sO2ZqUpVgsM6+I5o5tROZ6CEwZ9VXsfqSJooHSvU1wBlTXb9rgtUmVhHF7re4oQPz1EO
         utXIkBNCLKkOHs8rkIURWXdJ/D4zXe44WRGedtDA08i6p8MD++V5aMpe/aYb7HzzH6xF
         wnf9sveFjU9KN3jDrymruV2fixrd/RxEgWPS5DB1qtIjs42KTeTzaFbuFQlRXO/SPef1
         UYk2C0Wb2gkVQGEGgRASTo3VrbekteAD7oZlCUcVMgJEREEginIh34uj40+PLW+N2fKd
         Y3WA==
X-Gm-Message-State: AOAM532cpA9SlVV7/FAhdfwtP6RdPu+hIpHj6RyWw2dGoQB3ENPk9/fj
        RFXlfErx1R8b/UXWBg4yqW8=
X-Google-Smtp-Source: ABdhPJypWiVE50rNw07qu4g4Tq4DJq6wqlPfrjkdaAJjhEBYvoC9Fh1tKIipPLiOdG2ADoLgxrVqag==
X-Received: by 2002:a65:60ce:: with SMTP id r14mr12384959pgv.85.1595066218560;
        Sat, 18 Jul 2020 02:56:58 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id q96sm4525877pja.0.2020.07.18.02.56.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:56:57 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:26:44 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] scsi: megaraid: Remove pci-dma-compat wrapper APIs.
Message-ID: <55829944e20fb558dd3a42f11bfef42b7095e3cd.1595066170.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
APIs directly.

The patch has been generated with the coccinelle script below and has
been hand modified to replace GFP_ with correct flags based on the
context.

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
 drivers/scsi/megaraid.c | 66 ++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 0484ee52ae80..16bcdffeab37 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -133,8 +133,10 @@ mega_setup_mailbox(adapter_t *adapter)
 {
 	unsigned long	align;
=20
-	adapter->una_mbox64 =3D pci_alloc_consistent(adapter->dev,
-			sizeof(mbox64_t), &adapter->una_mbox64_dma);
+	adapter->una_mbox64 =3D dma_alloc_coherent(&adapter->dev->dev,
+						 sizeof(mbox64_t),
+						 &adapter->una_mbox64_dma,
+						 GFP_KERNEL);
=20
 	if( !adapter->una_mbox64 ) return -1;
 	=09
@@ -222,8 +224,9 @@ mega_query_adapter(adapter_t *adapter)
 		mraid_inquiry		*inq;
 		dma_addr_t		dma_handle;
=20
-		ext_inq =3D pci_alloc_consistent(adapter->dev,
-				sizeof(mraid_ext_inquiry), &dma_handle);
+		ext_inq =3D dma_alloc_coherent(&adapter->dev->dev,
+					     sizeof(mraid_ext_inquiry),
+					     &dma_handle, GFP_KERNEL);
=20
 		if( ext_inq =3D=3D NULL ) return -1;
=20
@@ -243,8 +246,9 @@ mega_query_adapter(adapter_t *adapter)
 		mega_8_to_40ld(inq, inquiry3,
 				(mega_product_info *)&adapter->product_info);
=20
-		pci_free_consistent(adapter->dev, sizeof(mraid_ext_inquiry),
-				ext_inq, dma_handle);
+		dma_free_coherent(&adapter->dev->dev,
+				  sizeof(mraid_ext_inquiry), ext_inq,
+				  dma_handle);
=20
 	} else {		/*adapter supports 40ld */
 		adapter->flag |=3D BOARD_40LD;
@@ -253,9 +257,9 @@ mega_query_adapter(adapter_t *adapter)
 		 * get product_info, which is static information and will be
 		 * unchanged
 		 */
-		prod_info_dma_handle =3D pci_map_single(adapter->dev, (void *)
-				&adapter->product_info,
-				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
+		prod_info_dma_handle =3D dma_map_single(&adapter->dev->dev,
+						      (void *)&adapter->product_info,
+						      sizeof(mega_product_info), DMA_FROM_DEVICE);
=20
 		mbox->m_out.xferaddr =3D prod_info_dma_handle;
=20
@@ -267,8 +271,8 @@ mega_query_adapter(adapter_t *adapter)
 				"Product_info cmd failed with error: %d\n",
 				retval);
=20
-		pci_unmap_single(adapter->dev, prod_info_dma_handle,
-				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&adapter->dev->dev, prod_info_dma_handle,
+				 sizeof(mega_product_info), DMA_FROM_DEVICE);
 	}
=20
=20
@@ -645,7 +649,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
 			scb->raw_mbox[2] =3D MEGA_RESERVATION_STATUS;
 			scb->raw_mbox[3] =3D ldrv_num;
=20
-			scb->dma_direction =3D PCI_DMA_NONE;
+			scb->dma_direction =3D DMA_NONE;
=20
 			return scb;
 #else
@@ -709,7 +713,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
 				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU;
 			}
=20
-			scb->dma_direction =3D PCI_DMA_FROMDEVICE;
+			scb->dma_direction =3D DMA_FROM_DEVICE;
=20
 			pthru->numsgelements =3D mega_build_sglist(adapter, scb,
 				&pthru->dataxferaddr, &pthru->dataxferlen);
@@ -839,10 +843,10 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
cmd, int *busy)
 			 * If it is a read command
 			 */
 			if( (*cmd->cmnd & 0x0F) =3D=3D 0x08 ) {
-				scb->dma_direction =3D PCI_DMA_FROMDEVICE;
+				scb->dma_direction =3D DMA_FROM_DEVICE;
 			}
 			else {
-				scb->dma_direction =3D PCI_DMA_TODEVICE;
+				scb->dma_direction =3D DMA_TO_DEVICE;
 			}
=20
 			/* Calculate Scatter-Gather info */
@@ -877,7 +881,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
=20
 			scb->raw_mbox[3] =3D ldrv_num;
=20
-			scb->dma_direction =3D PCI_DMA_NONE;
+			scb->dma_direction =3D DMA_NONE;
=20
 			return scb;
 #endif
@@ -971,7 +975,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, s=
truct scsi_cmnd *cmd,
 	memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
=20
 	/* Not sure about the direction */
-	scb->dma_direction =3D PCI_DMA_BIDIRECTIONAL;
+	scb->dma_direction =3D DMA_BIDIRECTIONAL;
=20
 	/* Special Code for Handling READ_CAPA/ INQ using bounce buffers */
 	switch (cmd->cmnd[0]) {
@@ -1035,7 +1039,7 @@ mega_prepare_extpassthru(adapter_t *adapter, scb_t *s=
cb,
 	memcpy(epthru->cdb, cmd->cmnd, cmd->cmd_len);
=20
 	/* Not sure about the direction */
-	scb->dma_direction =3D PCI_DMA_BIDIRECTIONAL;
+	scb->dma_direction =3D DMA_BIDIRECTIONAL;
=20
 	switch(cmd->cmnd[0]) {
 	case INQUIRY:
@@ -1813,25 +1817,25 @@ mega_free_sgl(adapter_t *adapter)
 		scb =3D &adapter->scb_list[i];
=20
 		if( scb->sgl64 ) {
-			pci_free_consistent(adapter->dev,
-				sizeof(mega_sgl64) * adapter->sglen,
-				scb->sgl64,
-				scb->sgl_dma_addr);
+			dma_free_coherent(&adapter->dev->dev,
+					  sizeof(mega_sgl64) * adapter->sglen,
+					  scb->sgl64, scb->sgl_dma_addr);
=20
 			scb->sgl64 =3D NULL;
 		}
=20
 		if( scb->pthru ) {
-			pci_free_consistent(adapter->dev, sizeof(mega_passthru),
-				scb->pthru, scb->pthru_dma_addr);
+			dma_free_coherent(&adapter->dev->dev,
+					  sizeof(mega_passthru), scb->pthru,
+					  scb->pthru_dma_addr);
=20
 			scb->pthru =3D NULL;
 		}
=20
 		if( scb->epthru ) {
-			pci_free_consistent(adapter->dev,
-				sizeof(mega_ext_passthru),
-				scb->epthru, scb->epthru_dma_addr);
+			dma_free_coherent(&adapter->dev->dev,
+					  sizeof(mega_ext_passthru),
+					  scb->epthru, scb->epthru_dma_addr);
=20
 			scb->epthru =3D NULL;
 		}
@@ -2004,7 +2008,7 @@ make_local_pdev(adapter_t *adapter, struct pci_dev **=
pdev)
=20
 	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
=20
-	if( pci_set_dma_mask(*pdev, DMA_BIT_MASK(32)) !=3D 0 ) {
+	if(dma_set_mask(&(*pdev)->dev, DMA_BIT_MASK(32)) !=3D 0 ) {
 		kfree(*pdev);
 		return -1;
 	}
@@ -2028,14 +2032,16 @@ free_local_pdev(struct pci_dev *pdev)
 static inline void *
 mega_allocate_inquiry(dma_addr_t *dma_handle, struct pci_dev *pdev)
 {
-	return pci_alloc_consistent(pdev, sizeof(mega_inquiry3), dma_handle);
+	return dma_alloc_coherent(&pdev->dev, sizeof(mega_inquiry3),
+				  dma_handle, GFP_KERNEL);
 }
=20
=20
 static inline void
 mega_free_inquiry(void *inquiry, dma_addr_t dma_handle, struct pci_dev *pd=
ev)
 {
-	pci_free_consistent(pdev, sizeof(mega_inquiry3), inquiry, dma_handle);
+	dma_free_coherent(&pdev->dev, sizeof(mega_inquiry3), inquiry,
+			  dma_handle);
 }
=20
=20
--=20
2.17.1


--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8Sx1wACgkQ+gRsbIfe
744fJRAAs4MQ3a1gzOQg93JJWwvNZa6FE6GTM+pfhHtaSjYuHHnpnqVjAtCUabLM
GQvIt7kDpnJufnqBXrESdIslhV1KDtG+VK8T4kh0jZZ6DfXdZNKay8fIsAEQt+Lg
ukMhp44IF3FrWHFh8LA8OsTyYtbAr41Lp91ENNygJ0fcyOuk5meCSzxmakxX2mZs
iKn2iP/dy6PWfiRO6yh+MA4DYxZHd1robsu5p534hdxh4m1Y5ExT33c6OnoUGm4i
ksobhvp4exhYcn5VIGzfhRc0b+vGjDNj2HHqGOHrTN0ZlHyFFvAurERkJq5T7pNf
tv46XJkIz3r0+sfRwCDtq5Tf9+o0JKhdz4aJZZBmHGTDOhGLouJHrYPy2EkljSFb
kK4HYmsxnI710EShMBzCjBajRvOLKHg40+iutEYzSgaiTLkBQ5hjDnlMF+M6bW1p
FTWeY/zQfm6ObOlM1glJrSFSsbJoMN5eEizoOsA7LKbT6xfguw56ECUBLWMov+VL
zS4NBNdON1WCwLquG68/t283hGpf47Ubxh714AxTxp+AUOyK5f5SYwp2frVilOvn
4LhjmVXtdYrVqlCGFjrFN/TdcQpreqlgfYfdRZZwsXPluj2vMF2EF+r2ZaKt4RYJ
gn4zZBKHaJq1apVdhuVvpDY5o/DlFdljRL51BhSNbg+8AXg8YqE=
=OCOK
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
