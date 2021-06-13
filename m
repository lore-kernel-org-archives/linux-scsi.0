Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953B8C48BDF
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 21:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F1861354
	for <linux-scsi@archiver.kernel.org>; Sun, 13 Jun 2021 21:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhFMVG0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Jun 2021 17:06:26 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:25647 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbhFMVGY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Jun 2021 17:06:24 -0400
Received: from localhost.localdomain ([86.243.172.93])
        by mwinf5d46 with ME
        id Gl4M2500421Fzsu03l4M8c; Sun, 13 Jun 2021 23:04:21 +0200
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 13 Jun 2021 23:04:21 +0200
X-ME-IP: 86.243.172.93
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/1] scsi: mptctl: switch from 'pci_' to 'dma_' API
Date:   Sun, 13 Jun 2021 23:04:20 +0200
Message-Id: <047a8ad3511a32084a700406998ebc48eb04c7c3.1623617903.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1623617903.git.christophe.jaillet@wanadoo.fr>
References: <cover.1623617903.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'kbuf_alloc_2_sgl()' GFP_KERNEL can be used
because this function already uses the GFP_USER flag for some memory
allocation and not spin_lock is taken in the between.

When memory is allocated in 'mptctl_do_mpt_command()' GFP_KERNEL can be
used because this function already uses 'copy_from_user()' and this
function can sleep.

When memory is allocated in 'mptctl_hp_hostinfo()' GFP_KERNEL can be used
because this function already uses 'mpt_config()' and this function has
an explicit 'might_sleep()'.

When memory is allocated in 'mptctl_hp_targetinfo()' GFP_KERNEL can be used
because this function already uses 'mpt_config()' and this function has
an explicit 'might_sleep()'.


While at it, also remove some useless casts.

@@ @@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@ @@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@ @@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
If needed, see post from Christoph Hellwig on the kernel-janitors ML:
   https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
---
 drivers/message/fusion/mptctl.c | 82 ++++++++++++++++++++-------------
 1 file changed, 49 insertions(+), 33 deletions(-)

diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
index 72025996cd70..7e307b39819a 100644
--- a/drivers/message/fusion/mptctl.c
+++ b/drivers/message/fusion/mptctl.c
@@ -1041,14 +1041,15 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	 * copying the data in this array into the correct place in the
 	 * request and chain buffers.
 	 */
-	sglbuf = pci_alloc_consistent(ioc->pcidev, MAX_SGL_BYTES, sglbuf_dma);
+	sglbuf = dma_alloc_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES,
+				    sglbuf_dma, GFP_KERNEL);
 	if (sglbuf == NULL)
 		goto free_and_fail;
 
 	if (sgdir & 0x04000000)
-		dir = PCI_DMA_TODEVICE;
+		dir = DMA_TO_DEVICE;
 	else
-		dir = PCI_DMA_FROMDEVICE;
+		dir = DMA_FROM_DEVICE;
 
 	/* At start:
 	 *	sgl = sglbuf = point to beginning of sg buffer
@@ -1062,9 +1063,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 	while (bytes_allocd < bytes) {
 		this_alloc = min(alloc_sz, bytes-bytes_allocd);
 		buflist[buflist_ent].len = this_alloc;
-		buflist[buflist_ent].kptr = pci_alloc_consistent(ioc->pcidev,
-								 this_alloc,
-								 &pa);
+		buflist[buflist_ent].kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							       this_alloc,
+							       &pa, GFP_KERNEL);
 		if (buflist[buflist_ent].kptr == NULL) {
 			alloc_sz = alloc_sz / 2;
 			if (alloc_sz == 0) {
@@ -1080,8 +1081,9 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 
 			bytes_allocd += this_alloc;
 			sgl->FlagsLength = (0x10000000|sgdir|this_alloc);
-			dma_addr = pci_map_single(ioc->pcidev,
-				buflist[buflist_ent].kptr, this_alloc, dir);
+			dma_addr = dma_map_single(&ioc->pcidev->dev,
+						  buflist[buflist_ent].kptr,
+						  this_alloc, dir);
 			sgl->Address = dma_addr;
 
 			fragcnt++;
@@ -1140,9 +1142,11 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset, int *frags,
 			kptr = buflist[i].kptr;
 			len = buflist[i].len;
 
-			pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+			dma_free_coherent(&ioc->pcidev->dev, len, kptr,
+					  dma_addr);
 		}
-		pci_free_consistent(ioc->pcidev, MAX_SGL_BYTES, sglbuf, *sglbuf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES, sglbuf,
+				  *sglbuf_dma);
 	}
 	kfree(buflist);
 	return NULL;
@@ -1162,9 +1166,9 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 	int		 n = 0;
 
 	if (sg->FlagsLength & 0x04000000)
-		dir = PCI_DMA_TODEVICE;
+		dir = DMA_TO_DEVICE;
 	else
-		dir = PCI_DMA_FROMDEVICE;
+		dir = DMA_FROM_DEVICE;
 
 	nib = (sg->FlagsLength & 0xF0000000) >> 28;
 	while (! (nib & 0x4)) { /* eob */
@@ -1179,8 +1183,10 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 			dma_addr = sg->Address;
 			kptr = bl->kptr;
 			len = bl->len;
-			pci_unmap_single(ioc->pcidev, dma_addr, len, dir);
-			pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+			dma_unmap_single(&ioc->pcidev->dev, dma_addr, len,
+					 dir);
+			dma_free_coherent(&ioc->pcidev->dev, len, kptr,
+					  dma_addr);
 			n++;
 		}
 		sg++;
@@ -1197,12 +1203,12 @@ kfree_sgl(MptSge_t *sgl, dma_addr_t sgl_dma, struct buflist *buflist, MPT_ADAPTE
 		dma_addr = sg->Address;
 		kptr = bl->kptr;
 		len = bl->len;
-		pci_unmap_single(ioc->pcidev, dma_addr, len, dir);
-		pci_free_consistent(ioc->pcidev, len, kptr, dma_addr);
+		dma_unmap_single(&ioc->pcidev->dev, dma_addr, len, dir);
+		dma_free_coherent(&ioc->pcidev->dev, len, kptr, dma_addr);
 		n++;
 	}
 
-	pci_free_consistent(ioc->pcidev, MAX_SGL_BYTES, sgl, sgl_dma);
+	dma_free_coherent(&ioc->pcidev->dev, MAX_SGL_BYTES, sgl, sgl_dma);
 	kfree(buflist);
 	dctlprintk(ioc, printk(MYIOC_s_DEBUG_FMT "-SG: Free'd 1 SGL buf + %d kbufs!\n",
 	    ioc->name, n));
@@ -2100,8 +2106,9 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 			}
 			flagsLength |= karg.dataOutSize;
 			bufOut.len = karg.dataOutSize;
-			bufOut.kptr = pci_alloc_consistent(
-					ioc->pcidev, bufOut.len, &dma_addr_out);
+			bufOut.kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							 bufOut.len,
+							 &dma_addr_out, GFP_KERNEL);
 
 			if (bufOut.kptr == NULL) {
 				rc = -ENOMEM;
@@ -2134,8 +2141,9 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 			flagsLength |= karg.dataInSize;
 
 			bufIn.len = karg.dataInSize;
-			bufIn.kptr = pci_alloc_consistent(ioc->pcidev,
-					bufIn.len, &dma_addr_in);
+			bufIn.kptr = dma_alloc_coherent(&ioc->pcidev->dev,
+							bufIn.len,
+							&dma_addr_in, GFP_KERNEL);
 
 			if (bufIn.kptr == NULL) {
 				rc = -ENOMEM;
@@ -2283,13 +2291,13 @@ mptctl_do_mpt_command (MPT_ADAPTER *ioc, struct mpt_ioctl_command karg, void __u
 	/* Free the allocated memory.
 	 */
 	if (bufOut.kptr != NULL) {
-		pci_free_consistent(ioc->pcidev,
-			bufOut.len, (void *) bufOut.kptr, dma_addr_out);
+		dma_free_coherent(&ioc->pcidev->dev, bufOut.len, bufOut.kptr,
+				  dma_addr_out);
 	}
 
 	if (bufIn.kptr != NULL) {
-		pci_free_consistent(ioc->pcidev,
-			bufIn.len, (void *) bufIn.kptr, dma_addr_in);
+		dma_free_coherent(&ioc->pcidev->dev, bufIn.len, bufIn.kptr,
+				  dma_addr_in);
 	}
 
 	/* mf is null if command issued successfully
@@ -2395,7 +2403,9 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 			/* Issue the second config page request */
 			cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
-			pbuf = pci_alloc_consistent(ioc->pcidev, hdr.PageLength * 4, &buf_dma);
+			pbuf = dma_alloc_coherent(&ioc->pcidev->dev,
+						  hdr.PageLength * 4,
+						  &buf_dma, GFP_KERNEL);
 			if (pbuf) {
 				cfg.physAddr = buf_dma;
 				if (mpt_config(ioc, &cfg) == 0) {
@@ -2405,7 +2415,9 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 							pdata->BoardTracerNumber, 24);
 					}
 				}
-				pci_free_consistent(ioc->pcidev, hdr.PageLength * 4, pbuf, buf_dma);
+				dma_free_coherent(&ioc->pcidev->dev,
+						  hdr.PageLength * 4, pbuf,
+						  buf_dma);
 				pbuf = NULL;
 			}
 		}
@@ -2470,7 +2482,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	else
 		IstwiRWRequest->DeviceAddr = 0xB0;
 
-	pbuf = pci_alloc_consistent(ioc->pcidev, 4, &buf_dma);
+	pbuf = dma_alloc_coherent(&ioc->pcidev->dev, 4, &buf_dma, GFP_KERNEL);
 	if (!pbuf)
 		goto out;
 	ioc->add_sge((char *)&IstwiRWRequest->SGL,
@@ -2519,7 +2531,7 @@ mptctl_hp_hostinfo(MPT_ADAPTER *ioc, unsigned long arg, unsigned int data_size)
 	SET_MGMT_MSG_CONTEXT(ioc->ioctl_cmds.msg_context, 0);
 
 	if (pbuf)
-		pci_free_consistent(ioc->pcidev, 4, pbuf, buf_dma);
+		dma_free_coherent(&ioc->pcidev->dev, 4, pbuf, buf_dma);
 
 	/* Copy the data from kernel memory to user memory
 	 */
@@ -2585,7 +2597,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
        /* Get the data transfer speeds
         */
 	data_sz = ioc->spi_data.sdp0length * 4;
-	pg0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+	pg0_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz, &page_dma,
+				       GFP_KERNEL);
 	if (pg0_alloc) {
 		hdr.PageVersion = ioc->spi_data.sdp0version;
 		hdr.PageLength = data_sz;
@@ -2623,7 +2636,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 				karg.negotiated_speed = HP_DEV_SPEED_ASYNC;
 		}
 
-		pci_free_consistent(ioc->pcidev, data_sz, (u8 *) pg0_alloc, page_dma);
+		dma_free_coherent(&ioc->pcidev->dev, data_sz, pg0_alloc,
+				  page_dma);
 	}
 
 	/* Set defaults
@@ -2649,7 +2663,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 		/* Issue the second config page request */
 		cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 		data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
-		pg3_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page_dma);
+		pg3_alloc = dma_alloc_coherent(&ioc->pcidev->dev, data_sz,
+					       &page_dma, GFP_KERNEL);
 		if (pg3_alloc) {
 			cfg.physAddr = page_dma;
 			cfg.pageAddr = (karg.hdr.channel << 8) | karg.hdr.id;
@@ -2658,7 +2673,8 @@ mptctl_hp_targetinfo(MPT_ADAPTER *ioc, unsigned long arg)
 				karg.phase_errors = (u32) le16_to_cpu(pg3_alloc->PhaseErrorCount);
 				karg.parity_errors = (u32) le16_to_cpu(pg3_alloc->ParityErrorCount);
 			}
-			pci_free_consistent(ioc->pcidev, data_sz, (u8 *) pg3_alloc, page_dma);
+			dma_free_coherent(&ioc->pcidev->dev, data_sz, pg3_alloc,
+					  page_dma);
 		}
 	}
 	hd = shost_priv(ioc->sh);
-- 
2.30.2

