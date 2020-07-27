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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADCCC433F8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92D6D20719
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpGSOI2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgG0OlJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729434AbgG0OId (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:08:33 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A19FC061794;
        Mon, 27 Jul 2020 07:08:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s189so9568193pgc.13;
        Mon, 27 Jul 2020 07:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=bV4aAnoRBOnxCNr9akirYAXtcfytQ4gDLflpBH6IBtA=;
        b=PpGSOI2S2RwFvk+lh2ETIBnAh+4zugeOh3X1EmPlqHoVMHJcc+Rs3MEqoZK+aRbGAt
         FJNUGLEEegW738Xy1QKWcUe7B5IHdI7HmKHYy81zxRtNaVMq0l4GlYvyMo8/0vAa6vLD
         jy2F0ktWacCUtnc9zkpqiqdT5CUy94BuJ1l272E0P6JtnUvV4Ag19kE6CZZ3NjC8DQ4t
         JqSadk0A0YvW84LTAL5Ao2dk+V7jZXnv29kAJZImaMlyMqVeoYZ+lmTxfSlfU8zlY5Ji
         W5yRAUDvX7iI5QiVsOTlilxBVUJqdftGPmWdoTKBBs+5AvfE1J8YPSqbN4ETRC4+5rIg
         pTyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=bV4aAnoRBOnxCNr9akirYAXtcfytQ4gDLflpBH6IBtA=;
        b=X7kSyBoZCdnfj7D/sdNs+r3hRe+dHtVFMKPyUgxD+kgnJVs8eUKosUxyJlmkxG4A3j
         8YjsmI9NWsBOpAtdpNsgYdQr/MrxNNhj8TYUMUzWQCTcomkocsrhYoW2wgE5wrHbAtN3
         V64QHVf7cYR+A6hiS8y2a414l8cC7WwL2DexSiaVjrWC17WoJ1F2Lm1LzYUC52hcrrUc
         gtdcU0N4qU2cvO1RMYP16ShMrIRP4YnJlq9/rOh6vtfRMEWqFBUqrsmRJsrTTzp6Po/J
         RoJCuixjsnQ7DIy1A7sQ8fZD/foWL9txpknTOqiWOXVERPfDJGDPDozL9P9mZa7/Fp14
         s4Kg==
X-Gm-Message-State: AOAM5317RXCQaGcMWfqCaE+i37THvsv9/xwqCSr4TfcTwAI9sq8nrrby
        vzr1OWmosjduBpvh6JuBbeo=
X-Google-Smtp-Source: ABdhPJwuWeLcGI3h/CXg8HXuAUfcoUDRYENFtFqd1TcHV6ySzPuxMco3bqmaBWulHQwuLwy6QHnlnQ==
X-Received: by 2002:aa7:9ec4:: with SMTP id r4mr8235556pfq.48.1595858913003;
        Mon, 27 Jul 2020 07:08:33 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id e16sm15568622pff.180.2020.07.27.07.08.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:08:32 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:38:26 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 1/2] scsi: megaraid: Remove pci-dma-compat wrapper
 APIs.
Message-ID: <20200727140826.GE14759@blackclown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="wchHw8dVAp53YPj8"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--wchHw8dVAp53YPj8
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


--wchHw8dVAp53YPj8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e39oACgkQ+gRsbIfe
745Z3Q/+M5VTLU/tvNJS6t/DPq35KFblDfBc20P2R9MQQNdQXUd1ygcdJzpoWi8f
KtccK+vdiCUCb54lMI+Vs1rlXgoOFttMWjgao+CWf+7V1RzizcV3UwlkiZ1dXJ1m
eQVIQRr8Hs0tEJrsP2gMSCdDt00laQik5DMDvhNmNjcIx7ez57WnjktnK/rRgZX4
9qElrRV08941bDhY2c30K+kebmMADbdE8vhmvcxsLgOZL0iLWT2b4i3yJNo/HST4
H83zEf4dyhGAhUjfzxfyJf4RymvNVVzmo2pf2kskkeoiye0o8zPf9b7rgNWxtRQR
/4eQjjyBGXeoaYZC4pYPkzYJ7bGLOdxrqn8tTdHVGmAE6YjtMlgFqi+KHunnnQ0E
IUfROWVMYkg5jALinj1rwPukXalAHPFC/OIB8+sRmB+PoSn6gjB+RZjCzbA4B5ac
Hyu/UpljhwQJ0Fs5tt6Ta7S1mujFbtCCpUaa2Nj7c+O8u5YmxoErCi05ltyaza35
kHHDLJLvVtTaST5kfcSQ01hg5xDbSZpb1W6sgJ7gffvfn0kdy9csWTYg6re7ox3J
ZjPmIFFt0y0SXeCVQiRQxe+NrfQffXSuPTIeEqRg6iUMxPgSIfBUnETfDsuAAgZ8
ntRVyUyGYpiV7N8AskbVXJeYYhUchQM1wQ9xv50Q0/6uB1cVuVw=
=Xwt/
-----END PGP SIGNATURE-----

--wchHw8dVAp53YPj8--
