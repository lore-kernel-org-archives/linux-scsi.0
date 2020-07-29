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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FBF3C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35DAA207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:14:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRQcqUQi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbgG2SOt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgG2SOt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:14:49 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14CA5C061794;
        Wed, 29 Jul 2020 11:14:49 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p3so14708171pgh.3;
        Wed, 29 Jul 2020 11:14:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=m5nolFOvzaVMD7Z8zeWmWx2XitIYYW30zXFEm7+LCos=;
        b=KRQcqUQiwOE9QngKNgB77omHui1yHes0gcP9HfMhXqkhzrEk3KWxEbcLEOK3dCNOoU
         41QU7451ZHD0o9m/5YGyyQTcvs8PbBxNoSMwzsu9YY107afbGJuPiOSO7IaDZ5hircGe
         2WVrXQbMZoAId70LMbWBWo+k3UwRAU+QRKQw8jvsLnKjsbqg0UDPr9ZPRSMOEhqA716f
         J3WnJ26/YFC/m2Q8sDPFx7wpY2IznvFcSkqA3PnjGRi0h3f3W5y+Ne2HkhbNeSIVUzFo
         QiY1rtM7zlDddxZpribXNkOo3CuHA3GdY5/raFgXQopVENFxKy8n0TabTPbrKhOUrxPE
         Ivvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=m5nolFOvzaVMD7Z8zeWmWx2XitIYYW30zXFEm7+LCos=;
        b=PwIpluzlur1GFA0DZsS5QX7VjqIvtQXcjDr7rSPx7NPB8XvX7HhsW5Qhi1Ot76zt2L
         fScfNwgg+aDN+KhbZSjNYyLTiIavVn3R8eWiG7knNdDW7r3IAJPWanePbIeA/SZrRsw/
         hONie2Z/7Fx6K0wde88RZJ5wPwHf7XoFRd0dPvr2bJO2WlKwaufmS6b9223ZkJ8y3Yxo
         OlgEx0uWPVO6mWvq3hXJmLsfL8+8bl0QHremB8OOx3ZnIZPyz24orCyZ9bQA6Z87b+tY
         5oHNpgCOGT/wG0kSyyUjJTLoTlxXUXvigd5oEJubljedGzqDbW6gau96WPMsSQk6bAdc
         8Ung==
X-Gm-Message-State: AOAM533qNBE+Fz/Dyli18JdtO2LJ6jiRK64E84aaqF9Nb3Vo4SkdhznO
        VRQECutx+/7P6FQNhoeuSDA=
X-Google-Smtp-Source: ABdhPJylM1vx/egCQTqxvWHhgbm+9VvvOFJT0PRY4JXdpCT/ZKOBKuawym4cJszD5iedFu80nARcpQ==
X-Received: by 2002:a63:481:: with SMTP id 123mr28443558pge.2.1596046488453;
        Wed, 29 Jul 2020 11:14:48 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id o2sm3128054pfh.160.2020.07.29.11.14.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:14:47 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:44:33 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com,
        megaraidlinux.pdl@broadcom.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@linux-kernel.org
Subject: [PATCH 7/7] scsi: megaraid: Remove pci-dma-compat wrapper APIs
Message-ID: <635cfc08b83a041708ee6afbc430087416f2605c.1596045683.git.usuraj35@gmail.com>
References: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <cover.1596045683.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs.
Instead use dma-mapping.h APIs directly.

The patch has been generated with the coccinelle script below.
And has been hand modified to replace each GFP_ with a correct
flag depending upon the context.
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
 drivers/scsi/megaraid.c | 192 +++++++++++++++++++++-------------------
 1 file changed, 102 insertions(+), 90 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 0484ee52ae80..e24c87a41eeb 100644
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
@@ -253,9 +257,10 @@ mega_query_adapter(adapter_t *adapter)
 		 * get product_info, which is static information and will be
 		 * unchanged
 		 */
-		prod_info_dma_handle =3D pci_map_single(adapter->dev, (void *)
-				&adapter->product_info,
-				sizeof(mega_product_info), PCI_DMA_FROMDEVICE);
+		prod_info_dma_handle =3D dma_map_single(&adapter->dev->dev,
+						      (void *)&adapter->product_info,
+						      sizeof(mega_product_info),
+						      DMA_FROM_DEVICE);
=20
 		mbox->m_out.xferaddr =3D prod_info_dma_handle;
=20
@@ -267,8 +272,8 @@ mega_query_adapter(adapter_t *adapter)
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
@@ -645,7 +650,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
 			scb->raw_mbox[2] =3D MEGA_RESERVATION_STATUS;
 			scb->raw_mbox[3] =3D ldrv_num;
=20
-			scb->dma_direction =3D PCI_DMA_NONE;
+			scb->dma_direction =3D DMA_NONE;
=20
 			return scb;
 #else
@@ -709,7 +714,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
 				mbox->m_out.cmd =3D MEGA_MBOXCMD_PASSTHRU;
 			}
=20
-			scb->dma_direction =3D PCI_DMA_FROMDEVICE;
+			scb->dma_direction =3D DMA_FROM_DEVICE;
=20
 			pthru->numsgelements =3D mega_build_sglist(adapter, scb,
 				&pthru->dataxferaddr, &pthru->dataxferlen);
@@ -839,10 +844,10 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *=
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
@@ -877,7 +882,7 @@ mega_build_cmd(adapter_t *adapter, struct scsi_cmnd *cm=
d, int *busy)
=20
 			scb->raw_mbox[3] =3D ldrv_num;
=20
-			scb->dma_direction =3D PCI_DMA_NONE;
+			scb->dma_direction =3D DMA_NONE;
=20
 			return scb;
 #endif
@@ -971,7 +976,7 @@ mega_prepare_passthru(adapter_t *adapter, scb_t *scb, s=
truct scsi_cmnd *cmd,
 	memcpy(pthru->cdb, cmd->cmnd, cmd->cmd_len);
=20
 	/* Not sure about the direction */
-	scb->dma_direction =3D PCI_DMA_BIDIRECTIONAL;
+	scb->dma_direction =3D DMA_BIDIRECTIONAL;
=20
 	/* Special Code for Handling READ_CAPA/ INQ using bounce buffers */
 	switch (cmd->cmnd[0]) {
@@ -1035,7 +1040,7 @@ mega_prepare_extpassthru(adapter_t *adapter, scb_t *s=
cb,
 	memcpy(epthru->cdb, cmd->cmnd, cmd->cmd_len);
=20
 	/* Not sure about the direction */
-	scb->dma_direction =3D PCI_DMA_BIDIRECTIONAL;
+	scb->dma_direction =3D DMA_BIDIRECTIONAL;
=20
 	switch(cmd->cmnd[0]) {
 	case INQUIRY:
@@ -1813,25 +1818,25 @@ mega_free_sgl(adapter_t *adapter)
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
@@ -2004,7 +2009,7 @@ make_local_pdev(adapter_t *adapter, struct pci_dev **=
pdev)
=20
 	memcpy(*pdev, adapter->dev, sizeof(struct pci_dev));
=20
-	if( pci_set_dma_mask(*pdev, DMA_BIT_MASK(32)) !=3D 0 ) {
+	if(dma_set_mask(&(*pdev)->dev, DMA_BIT_MASK(32)) !=3D 0 ) {
 		kfree(*pdev);
 		return -1;
 	}
@@ -2028,14 +2033,16 @@ free_local_pdev(struct pci_dev *pdev)
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
@@ -2349,7 +2356,8 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter=
, int channel)
 	}
=20
=20
-	scsi_inq =3D pci_alloc_consistent(pdev, 256, &scsi_inq_dma_handle);
+	scsi_inq =3D dma_alloc_coherent(&pdev->dev, 256, &scsi_inq_dma_handle,
+				      GFP_KERNEL);
 	if( scsi_inq =3D=3D NULL ) {
 		seq_puts(m, "memory not available for scsi inq.\n");
 		goto free_inquiry;
@@ -2422,7 +2430,7 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter=
, int channel)
 	}
=20
 free_pci:
-	pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
+	dma_free_coherent(&pdev->dev, 256, scsi_inq, scsi_inq_dma_handle);
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
 free_pdev:
@@ -2542,8 +2550,8 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter=
, int start, int end )
 			raid_inq.logdrv_info.num_ldrv;
 	}
=20
-	disk_array =3D pci_alloc_consistent(pdev, array_sz,
-			&disk_array_dma_handle);
+	disk_array =3D dma_alloc_coherent(&pdev->dev, array_sz,
+					&disk_array_dma_handle, GFP_KERNEL);
=20
 	if( disk_array =3D=3D NULL ) {
 		seq_puts(m, "memory not available.\n");
@@ -2662,8 +2670,8 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter=
, int start, int end )
 	}
=20
 free_pci:
-	pci_free_consistent(pdev, array_sz, disk_array,
-			disk_array_dma_handle);
+	dma_free_coherent(&pdev->dev, array_sz, disk_array,
+			  disk_array_dma_handle);
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
 free_pdev:
@@ -2881,9 +2889,9 @@ mega_init_scb(adapter_t *adapter)
=20
 		scb->idx =3D i;
=20
-		scb->sgl64 =3D pci_alloc_consistent(adapter->dev,
-				sizeof(mega_sgl64) * adapter->sglen,
-				&scb->sgl_dma_addr);
+		scb->sgl64 =3D dma_alloc_coherent(&adapter->dev->dev,
+						sizeof(mega_sgl64) * adapter->sglen,
+						&scb->sgl_dma_addr, GFP_KERNEL);
=20
 		scb->sgl =3D (mega_sglist *)scb->sgl64;
=20
@@ -2893,9 +2901,9 @@ mega_init_scb(adapter_t *adapter)
 			return -1;
 		}
=20
-		scb->pthru =3D pci_alloc_consistent(adapter->dev,
-				sizeof(mega_passthru),
-				&scb->pthru_dma_addr);
+		scb->pthru =3D dma_alloc_coherent(&adapter->dev->dev,
+						sizeof(mega_passthru),
+						&scb->pthru_dma_addr, GFP_KERNEL);
=20
 		if( !scb->pthru ) {
 			dev_warn(&adapter->dev->dev, "RAID: Can't allocate passthru\n");
@@ -2903,9 +2911,9 @@ mega_init_scb(adapter_t *adapter)
 			return -1;
 		}
=20
-		scb->epthru =3D pci_alloc_consistent(adapter->dev,
-				sizeof(mega_ext_passthru),
-				&scb->epthru_dma_addr);
+		scb->epthru =3D dma_alloc_coherent(&adapter->dev->dev,
+						 sizeof(mega_ext_passthru),
+						 &scb->epthru_dma_addr, GFP_KERNEL);
=20
 		if( !scb->epthru ) {
 			dev_warn(&adapter->dev->dev,
@@ -3145,9 +3153,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
 		if( uioc.uioc_rmbox[0] =3D=3D MEGA_MBOXCMD_PASSTHRU ) {
 			/* Passthru commands */
=20
-			pthru =3D pci_alloc_consistent(pdev,
-					sizeof(mega_passthru),
-					&pthru_dma_hndl);
+			pthru =3D dma_alloc_coherent(&pdev->dev,
+						   sizeof(mega_passthru),
+						   &pthru_dma_hndl, GFP_KERNEL);
=20
 			if( pthru =3D=3D NULL ) {
 				free_local_pdev(pdev);
@@ -3165,9 +3173,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
 			if( copy_from_user(pthru, upthru,
 						sizeof(mega_passthru)) ) {
=20
-				pci_free_consistent(pdev,
-						sizeof(mega_passthru), pthru,
-						pthru_dma_hndl);
+				dma_free_coherent(&pdev->dev,
+						  sizeof(mega_passthru),
+						  pthru, pthru_dma_hndl);
=20
 				free_local_pdev(pdev);
=20
@@ -3178,15 +3186,16 @@ megadev_ioctl(struct file *filep, unsigned int cmd,=
 unsigned long arg)
 			 * Is there a data transfer
 			 */
 			if( pthru->dataxferlen ) {
-				data =3D pci_alloc_consistent(pdev,
-						pthru->dataxferlen,
-						&data_dma_hndl);
+				data =3D dma_alloc_coherent(&pdev->dev,
+							  pthru->dataxferlen,
+							  &data_dma_hndl,
+							  GFP_KERNEL);
=20
 				if( data =3D=3D NULL ) {
-					pci_free_consistent(pdev,
-							sizeof(mega_passthru),
-							pthru,
-							pthru_dma_hndl);
+					dma_free_coherent(&pdev->dev,
+							  sizeof(mega_passthru),
+							  pthru,
+							  pthru_dma_hndl);
=20
 					free_local_pdev(pdev);
=20
@@ -3251,13 +3260,13 @@ megadev_ioctl(struct file *filep, unsigned int cmd,=
 unsigned long arg)
=20
 freemem_and_return:
 			if( pthru->dataxferlen ) {
-				pci_free_consistent(pdev,
-						pthru->dataxferlen, data,
-						data_dma_hndl);
+				dma_free_coherent(&pdev->dev,
+						  pthru->dataxferlen, data,
+						  data_dma_hndl);
 			}
=20
-			pci_free_consistent(pdev, sizeof(mega_passthru),
-					pthru, pthru_dma_hndl);
+			dma_free_coherent(&pdev->dev, sizeof(mega_passthru),
+					  pthru, pthru_dma_hndl);
=20
 			free_local_pdev(pdev);
=20
@@ -3270,8 +3279,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, =
unsigned long arg)
 			 * Is there a data transfer
 			 */
 			if( uioc.xferlen ) {
-				data =3D pci_alloc_consistent(pdev,
-						uioc.xferlen, &data_dma_hndl);
+				data =3D dma_alloc_coherent(&pdev->dev,
+							  uioc.xferlen,
+							  &data_dma_hndl,
+							  GFP_KERNEL);
=20
 				if( data =3D=3D NULL ) {
 					free_local_pdev(pdev);
@@ -3291,9 +3302,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
 				if( copy_from_user(data, (char __user *)(unsigned long) uxferaddr,
 							uioc.xferlen) ) {
=20
-					pci_free_consistent(pdev,
-							uioc.xferlen,
-							data, data_dma_hndl);
+					dma_free_coherent(&pdev->dev,
+							  uioc.xferlen, data,
+							  data_dma_hndl);
=20
 					free_local_pdev(pdev);
=20
@@ -3314,9 +3325,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
=20
 			if( rval ) {
 				if( uioc.xferlen ) {
-					pci_free_consistent(pdev,
-							uioc.xferlen, data,
-							data_dma_hndl);
+					dma_free_coherent(&pdev->dev,
+							  uioc.xferlen, data,
+							  data_dma_hndl);
 				}
=20
 				free_local_pdev(pdev);
@@ -3336,9 +3347,8 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
nsigned long arg)
 			}
=20
 			if( uioc.xferlen ) {
-				pci_free_consistent(pdev,
-						uioc.xferlen, data,
-						data_dma_hndl);
+				dma_free_coherent(&pdev->dev, uioc.xferlen,
+						  data, data_dma_hndl);
 			}
=20
 			free_local_pdev(pdev);
@@ -4004,8 +4014,8 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, =
u8 tgt,
 	 */
 	if( make_local_pdev(adapter, &pdev) !=3D 0 ) return -1;
=20
-	pthru =3D pci_alloc_consistent(pdev, sizeof(mega_passthru),
-			&pthru_dma_handle);
+	pthru =3D dma_alloc_coherent(&pdev->dev, sizeof(mega_passthru),
+				   &pthru_dma_handle, GFP_KERNEL);
=20
 	if( pthru =3D=3D NULL ) {
 		free_local_pdev(pdev);
@@ -4041,8 +4051,8 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, =
u8 tgt,
=20
 	rval =3D mega_internal_command(adapter, &mc, pthru);
=20
-	pci_free_consistent(pdev, sizeof(mega_passthru), pthru,
-			pthru_dma_handle);
+	dma_free_coherent(&pdev->dev, sizeof(mega_passthru), pthru,
+			  pthru_dma_handle);
=20
 	free_local_pdev(pdev);
=20
@@ -4267,8 +4277,10 @@ megaraid_probe_one(struct pci_dev *pdev, const struc=
t pci_device_id *id)
 	/*
 	 * Allocate buffer to issue internal commands.
 	 */
-	adapter->mega_buffer =3D pci_alloc_consistent(adapter->dev,
-		MEGA_BUFFER_SIZE, &adapter->buf_dma_handle);
+	adapter->mega_buffer =3D dma_alloc_coherent(&adapter->dev->dev,
+						  MEGA_BUFFER_SIZE,
+						  &adapter->buf_dma_handle,
+						  GFP_KERNEL);
 	if (!adapter->mega_buffer) {
 		dev_warn(&pdev->dev, "out of RAM\n");
 		goto out_host_put;
@@ -4427,10 +4439,10 @@ megaraid_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
=20
 	/* Set the Mode of addressing to 64 bit if we can */
 	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) =3D=3D 8)) {
-		pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
+		dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
 		adapter->has_64bit_addr =3D 1;
 	} else  {
-		pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 		adapter->has_64bit_addr =3D 0;
 	}
 	=09
@@ -4469,15 +4481,15 @@ megaraid_probe_one(struct pci_dev *pdev, const stru=
ct pci_device_id *id)
 	return 0;
=20
  out_free_mbox:
-	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
-			adapter->una_mbox64, adapter->una_mbox64_dma);
+	dma_free_coherent(&adapter->dev->dev, sizeof(mbox64_t),
+			  adapter->una_mbox64, adapter->una_mbox64_dma);
  out_free_irq:
 	free_irq(adapter->host->irq, adapter);
  out_free_scb_list:
 	kfree(adapter->scb_list);
  out_free_cmd_buffer:
-	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
-			adapter->mega_buffer, adapter->buf_dma_handle);
+	dma_free_coherent(&adapter->dev->dev, MEGA_BUFFER_SIZE,
+			  adapter->mega_buffer, adapter->buf_dma_handle);
  out_host_put:
 	scsi_host_put(host);
  out_iounmap:
@@ -4551,11 +4563,11 @@ megaraid_remove_one(struct pci_dev *pdev)
 	sprintf(buf, "hba%d", adapter->host->host_no);
 	remove_proc_subtree(buf, mega_proc_dir_entry);
=20
-	pci_free_consistent(adapter->dev, MEGA_BUFFER_SIZE,
-			adapter->mega_buffer, adapter->buf_dma_handle);
+	dma_free_coherent(&adapter->dev->dev, MEGA_BUFFER_SIZE,
+			  adapter->mega_buffer, adapter->buf_dma_handle);
 	kfree(adapter->scb_list);
-	pci_free_consistent(adapter->dev, sizeof(mbox64_t),
-			adapter->una_mbox64, adapter->una_mbox64_dma);
+	dma_free_coherent(&adapter->dev->dev, sizeof(mbox64_t),
+			  adapter->una_mbox64, adapter->una_mbox64_dma);
=20
 	scsi_host_put(host);
 	pci_disable_device(pdev);
--=20
2.17.1


--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hvIkACgkQ+gRsbIfe
746tvw//c86epRhE72mAZNhGss05jURBm7oi/tugrIh194ox3+zWQhFQxdyWW7s/
6rf2LUbJfK9aiQMCPqJMbVlrbVXYcP1rZA57XwOTOQ0eQBuVmOST7lbOixyrBlCe
rP2inV6ylo/o4SBib9zukVi+cO2gfHZ7uPXFivcAbOAyhu3wLp3rrnVHoDdMpuaA
MkTqhnkNgA52pwJ5lWoLHHi35JgWNXvqCfncomBOUyzU31iuEB1CkbvEcjM2snEn
o3kzPb41OzErXELzB9yiQ89mBXEdBBLvTqlnviona/00s/dLGXSyLbGgYMHzUoJi
lcCZPYwM3/ibuA9MoLYHx1mkKa6Qag5xmPVsrXocnPbkWhGufWb526OfiTBMJHy+
KbJ5RQRi0OYqRXE4BfIgb+sFZMkx1MusdI28P13vGA/bSnCIax5fMsB6yH2LzZz/
zWRq1hxDmakjnCVX+qPvfcUbWfEPwRFeZkYt/1nqYNq5j3thhH8gr8ro/2FXfOYl
7TahwzR6GoGgfZYhFghalIQ9qVu0VVUQxnVoPirk9agFCxRHm29RyCIvcPTavmh3
WRYLPk2PrFT0cWjSlZr9BkkUYmUVMNl+ra89yaDCc/cRJAeJO3dE3bVyX696Iu4k
bAeyThhc9CzgAs1J8G0dIYM4+u94rAkzwHJDi1/LjLVdJgQeyEo=
=Zwwx
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
