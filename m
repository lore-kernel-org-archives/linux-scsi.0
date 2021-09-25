Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14504C433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 06:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A946127A
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Sep 2021 06:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344624AbhIYGru (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Sep 2021 02:47:50 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:51177 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242130AbhIYGrs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Sep 2021 02:47:48 -0400
Received: from pop-os.home ([90.126.248.220])
        by mwinf5d51 with ME
        id y6mD250034m3Hzu036mDPb; Sat, 25 Sep 2021 08:46:13 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 25 Sep 2021 08:46:13 +0200
X-ME-IP: 90.126.248.220
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 1/1] scsi: mptctl: Remove usage of the deprecated "pci-dma-compat.h" API
Date:   Sat, 25 Sep 2021 08:46:11 +0200
Message-Id: <04aa1ad3511a3208fa700406994ebc48cb048731.1632551759.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1632551759.git.christophe.jaillet@wanadoo.fr>
References: <cover.1632551759.git.christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In [1], Christoph Hellwig has proposed to remove the wrappers in
include/linux/pci-dma-compat.h.

Some reasons why this API should be removed have been given by Julia
Lawall in [2].

Finally, Arnd Bergmann reminded that the documentation was updated 11 years
ago to only describe the modern linux/dma-mapping.h interfaces and mark the
old bus-specific ones as no longer recommended, see commit 216bf58f4092
("Documentation: convert PCI-DMA-mapping.txt to use the generic DMA API").

A coccinelle script has been used to perform the needed transformation.
Only relevant parts are given below.

It has been hand modified to replace GFP_ with a correct flag.

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
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@ @@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
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


[1]: https://lore.kernel.org/kernel-janitors/20200421081257.GA131897@infradead.org/
[2]: https://lore.kernel.org/kernel-janitors/alpine.DEB.2.22.394.2007120902170.2424@hadrien/

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
It has been compile tested.

v2: Change Subject to be more explicit
    Keep only relevant part of the coccinelle script
    Try to improve the commit message to give some reason of why this change is done
    Add the scsi maintainers in the To: field as suggested in [3]

[3]: https://lore.kernel.org/kernel-janitors/CAK8P3a2CBvw_GP372R+p8f4_pa82sMuQ5iHk4Nb2dJCzm_Fivw@mail.gmail.com/
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

