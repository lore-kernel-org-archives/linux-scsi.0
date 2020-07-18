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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4E29C433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A4B12074B
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 09:57:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MCRCqn9l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgGRJ5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 05:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgGRJ5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 05:57:36 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F89CC0619D2;
        Sat, 18 Jul 2020 02:57:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id a14so6626945pfi.2;
        Sat, 18 Jul 2020 02:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=f1LOZp5JlzkmUbPeyK+AOPbtRtPHkw4Fri+hBp79l4E=;
        b=MCRCqn9lVjazk2tH5HwpFZ3/BSrnqin99DexBMzdZTFiI/pGNeDl2Dp1Y6N4rgWP1Q
         SVhB1v+fIXrDoo6zuAUCIH4fkCB+b93yMuq8psqSA48nJrjYYDyzfAAg1NZSSeFCcx9w
         h8fq7i0ZrsjvE+T6sGD9ehdMvFkf5oDoBr7ZAZDqZ1RVft1rbv6xW8sTyC0M4vkuN+1y
         5gi+v4kGlcn/QGmTB/Ps6ZWTSpojjEZoABXcCJ4MR/0IuNF/1/nLM6ui/j/AhHDlTl4Y
         ToNFlo4l0t07yckBjbff5tz18LSwiQhSr5B23VIgUr3smZLmGPw9uLnN8SJjPx6HXL00
         stWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=f1LOZp5JlzkmUbPeyK+AOPbtRtPHkw4Fri+hBp79l4E=;
        b=IbcsvkV7t5jBhYr1FbsGj4GsL7zCJZwIE9kKTioombw7MAkTlSFZB6ggKQn4aARqhK
         RUMrylZUNHlJC2R12vzYLDKvGRKtQO+Y/uQi2jo467NW3k3UO6SGpio97BLioIjcyfru
         J6I0SLaD3pocSPxFqEbd/5rhRiyrS916XB+K36f0UVVAmmfLwD38cbRGBfOgesgcsHk4
         B+9fXqJBbXTylq45K/gcTIxl/xieFVZkV4AQIWHU0ldivg7JDdTT+u9S8IDsuc/IPeqC
         lbgNU5aApiRxoo1gEOpvNHkyBJiz0eTf67r782cmFYwgFn5My9TQi7iLVuBBEyXaabj6
         SQUw==
X-Gm-Message-State: AOAM531uzHLhM6LiTYXHtZ3Zn6NQjPKXIRgL9by98nXn+AumJt+l5sWB
        3xPXO4a5rX6rm1FqE2PB+8A=
X-Google-Smtp-Source: ABdhPJyFZ2s76luE3gMN3so6bUPjtIJQCnsr/mzREBif6Finz0nRHydcITkUbIYgtz1678mJQki9Mg==
X-Received: by 2002:a62:7f55:: with SMTP id a82mr11389773pfd.61.1595066255879;
        Sat, 18 Jul 2020 02:57:35 -0700 (PDT)
Received: from blackclown ([103.88.82.25])
        by smtp.gmail.com with ESMTPSA id h18sm10252353pfr.186.2020.07.18.02.57.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 18 Jul 2020 02:57:35 -0700 (PDT)
Date:   Sat, 18 Jul 2020 15:27:21 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: megaraid: Remove remaining pci-dma-compat wrapper
 APIs.
Message-ID: <a4372635a7500dcc23d6a30ada74e0f875814f11.1595066170.git.usuraj35@gmail.com>
References: <55829944e20fb558dd3a42f11bfef42b7095e3cd.1595066170.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <55829944e20fb558dd3a42f11bfef42b7095e3cd.1595066170.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The legacy API wrappers in include/linux/pci-dma-compat.h
should go away as it creates unnecessary midlayering
for include/linux/dma-mapping.h APIs, instead use dma-mapping.h
APIs directly.

The patch has been generated with the coccinelle script below
and has been hand modified to replace GFP_ with correct flags based on
the context.

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
 drivers/scsi/megaraid.c | 125 +++++++++++++++++++++-------------------
 1 file changed, 65 insertions(+), 60 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 16bcdffeab37..ed06aafeeedc 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -2355,7 +2355,8 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter=
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
@@ -2428,7 +2429,7 @@ proc_show_pdrv(struct seq_file *m, adapter_t *adapter=
, int channel)
 	}
=20
 free_pci:
-	pci_free_consistent(pdev, 256, scsi_inq, scsi_inq_dma_handle);
+	dma_free_coherent(&pdev->dev, 256, scsi_inq, scsi_inq_dma_handle);
 free_inquiry:
 	mega_free_inquiry(inquiry, dma_handle, pdev);
 free_pdev:
@@ -2548,8 +2549,8 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter=
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
@@ -2668,8 +2669,8 @@ proc_show_rdrv(struct seq_file *m, adapter_t *adapter=
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
@@ -2887,9 +2888,9 @@ mega_init_scb(adapter_t *adapter)
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
@@ -2899,9 +2900,9 @@ mega_init_scb(adapter_t *adapter)
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
@@ -2909,9 +2910,9 @@ mega_init_scb(adapter_t *adapter)
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
@@ -3151,9 +3152,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
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
@@ -3171,9 +3172,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
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
@@ -3184,15 +3185,16 @@ megadev_ioctl(struct file *filep, unsigned int cmd,=
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
@@ -3257,13 +3259,13 @@ megadev_ioctl(struct file *filep, unsigned int cmd,=
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
@@ -3276,8 +3278,10 @@ megadev_ioctl(struct file *filep, unsigned int cmd, =
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
@@ -3297,9 +3301,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
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
@@ -3320,9 +3324,9 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
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
@@ -3342,9 +3346,8 @@ megadev_ioctl(struct file *filep, unsigned int cmd, u=
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
@@ -4010,8 +4013,8 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, =
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
@@ -4047,8 +4050,8 @@ mega_internal_dev_inquiry(adapter_t *adapter, u8 ch, =
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
@@ -4273,8 +4276,10 @@ megaraid_probe_one(struct pci_dev *pdev, const struc=
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
@@ -4433,10 +4438,10 @@ megaraid_probe_one(struct pci_dev *pdev, const stru=
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
@@ -4475,15 +4480,15 @@ megaraid_probe_one(struct pci_dev *pdev, const stru=
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
@@ -4557,11 +4562,11 @@ megaraid_remove_one(struct pci_dev *pdev)
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


--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8Sx4AACgkQ+gRsbIfe
747BJxAApNzcHFpUfSPpJKu+/Rgn4CS7hLkYj9ucuAfkSZMrhQ460rSaO9gPHRv9
wOlyYFxI6jDn/g0s3Vee5IxOEIT+6U7NeRQz+U4Tj351Sg7Pwz7o7OymLEoBKpo0
OsCr6vAFMjzuSQEW0DgyV0xUGgYk0c5kcfhyyf/6OM+J5VLGglqlInThd38PvPWx
S6Ms7NcoOLCOX9nyniSxbOwCLFD1ctVYoKcHk8nyZX4+alV9EgeA+ViJuXdlVLP1
Kh6zF4dVZaRMN1myw0Sfs1/GpKBCT28nDttAEoRnbBfy0WZwrnrFhKO0Jhqxf7Sl
LKA7EjFxqNFPVvbC45f1PzN4/2rU9OYBbvpaMlB5RQ4V8HxSKPD6f3vtr2PBMigX
Lx2FoEtgMTjX5f2vY6wxeJdTmFen8AxJjBEHAscU0Js8AO6P1k5J4mdLcfAvNvP7
1hH28oRd26v5b3aBTtymScoYgktdzkr8DDL2x7ZJ/79qfTA52qkdaX/qWg09eIKF
ln0oqPiMBxdbrUP8mv8MfGSaoMo++Pzs+2GjCTRq7+YF3QlbGogEgEILCm1dX1A7
RsHe1rhVer2eGu8TLxprPivMs+VxAqu6bArnrkyRsmTweYsRs7YUHI9d5JiPHlMV
Km8vEdmW8H3Oh4b2/DCYlZzRTs4aFzDkSxOAr4NOLj0xyeAJQ3E=
=2cms
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
