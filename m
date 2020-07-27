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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 390DAC433F2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:40:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CC420FC3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 14:40:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="auLYABpk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729975AbgG0Ok6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 10:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729514AbgG0OIy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 10:08:54 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64EB5C061794;
        Mon, 27 Jul 2020 07:08:54 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id k27so9596145pgm.2;
        Mon, 27 Jul 2020 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=KDlWBFaScx8Qud96hby0ZTh0yjULq2EGsmrzoFKN598=;
        b=auLYABpkeVnkUEOQfCSqr8XtYazeAyirBZvZlJ/PDNKeJ9dgIUDg4poI2jemHMDUgR
         /7MxO3VOPnaaFo8ZnFCEHZJ5pDBEpb6vbhvgMPKOga9KzkspuszgRjSWX1Gn3fAItqyv
         UMRjAZfxPaFxJQ+u6JhcKRJ9YMG5hJdaWeK9SnwaAM83eJoKiHMVt2OCocay+H8EbM4g
         QcBGqATyham/jk+XaoWCnZ4LIncJfqRRCiKnCQzXg3Wjcx8uYJur3QYL58wPdl+8V/9c
         XXo9s9st/IcFl5B23H+rT+81YiJPS21cPWY0s3yG69se/vplyrkxYE2J/fRnNopP7Psy
         nkNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KDlWBFaScx8Qud96hby0ZTh0yjULq2EGsmrzoFKN598=;
        b=XfhZ7xxlnmFXs8riAk/+StE13wwgwWkj5eqejUio700nUX4958qy1+8biOJkUN8WEE
         ArkXLLkQR36clRlRTXkvWQV64ujWvHze1z33o8XO3mU9LeaAHOMUk6nvAvFXWF+6IkCG
         Jzock6A5RktCRA83QG0JS4yINX+9igioOwHlnR8GElH7t/DYLZI8d9nFP412rh3ii0Dm
         udnBJ1+6P1mKPeppyTu8vxscX7+Iux3RTR2ndZjRwZs5WjlQ8qVQQNQandlEHfg+3YqK
         Cc+5JHdjgEUHrazcghFFbgkEb6TQfNmp+F/rU3Wys+iMAnzRDniEA5uAKXQ3wwkAUx3/
         1iEQ==
X-Gm-Message-State: AOAM531vZR/pYYgxVHTlCka7SM93stz1NLWmRBcZv+nUGT8MOb55F2mI
        /HbZNGja7Q1lgEE+XwRQQbQ=
X-Google-Smtp-Source: ABdhPJwQGcaBeMXw6/sCyqc5ONLJKT5gr/uA1Zr2WaQmCWr8E679400w9CAo5Qc4idcoCstMoMpJGQ==
X-Received: by 2002:a63:441c:: with SMTP id r28mr20089357pga.372.1595858933923;
        Mon, 27 Jul 2020 07:08:53 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id o8sm14278851pgb.23.2020.07.27.07.08.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jul 2020 07:08:53 -0700 (PDT)
Date:   Mon, 27 Jul 2020 19:38:47 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 2/2] scsi: megaraid: Remove remaining pci-dma-compat
 wrapper APIs.
Message-ID: <20200727140847.GF14759@blackclown>
References: <55829944e20fb558dd3a42f11bfef42b7095e3cd.1595066170.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z0eOaCaDLjvTGF2l"
Content-Disposition: inline
In-Reply-To: <55829944e20fb558dd3a42f11bfef42b7095e3cd.1595066170.git.usuraj35@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--z0eOaCaDLjvTGF2l
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


--z0eOaCaDLjvTGF2l
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8e3+8ACgkQ+gRsbIfe
7450QBAAl5uwVwFS8OtrWB91gwxY27Uk0fNup8Rveb5QJ+Dqql3yRNYFRyztB9s3
+Ds82URQDS/5l+uKS0HhdYbUrcCibmnRAnozPT7VV7ZENjOARyXp0OvfAdK2QR6M
/ZQCX4aSd3eQAg6jabe8pFHv+Dhn0Jyy/PPCGS8IPxsbLlYXqEHNSw0MU/7A+EW9
Zpn4byIq9DicR7ddIg8B6dzHwJ0HTlOobI+yEqFdcBeSsjTFSJg/XhpVVcp6tWCH
CKOODgBQeSvabEANRsFIkqiMpd1W+dubjOzJX7FZ7fKQjGF5w8WZR/gYaWW33Nmt
+nLZRzDSh48MuOXdv9fHk1xprr1eYDVNHfxKgYQEZUFD809S/JBWVs+DGPpm78jT
h3Zawt07iLgFizo2UJ+gS2R/mLkQK45KJBHX+NBSClcQSHhwB5TjYb518Hp+NYOt
jCAkmYVE2k8UPnpLWCJ9vU+1FeH5PBzCBqGbcio+n9fqgoLoDFVpFSLu04dH7A6X
3aybf4vrdUGSzowqlZ8shlDwXl5LWaM0m3dUiGIKQ8YKWmAMxXr/lZwuehXYf2Vu
yqywLGdglVtPUDCFw9srp+hW8MoKIVQqsHpRPyxo1XWvfE7GORTl8/1wsUOpRsQs
wc2rMDvcg5prq3SKhiEJ7ac5IWEynnca2S3ZS3n87NZXna8IZMg=
=//kf
-----END PGP SIGNATURE-----

--z0eOaCaDLjvTGF2l--
