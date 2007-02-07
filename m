From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/5] scsi: megaraid_sas - preallocate memory for ioctl
 processing
Date: Wed, 7 Feb 2007 13:30:20 -0800
Message-ID: <20070207133020.4c58e271.akpm@linux-foundation.org>
References: <1170800394.10482.41.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38157 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422794AbXBGVa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 16:30:28 -0500
In-Reply-To: <1170800394.10482.41.camel@dumbo>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumant Patro <sumantp@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com

On Tue, 06 Feb 2007 14:19:54 -0800
Sumant Patro <sumantp@lsil.com> wrote:

> Preallocate memory for ioctl processing. This is to avoid situations 
> where ioctl fails for lack of memory (when system under heavy stress).
> The memory pool will have 8*4K, 4*8K and 1*64K memory chunks

mutter.

I suspect all this horror is due to stupidity in the DMA API.

pci_alloc_consistent() just goes and assumes GFP_ATOMIC, whereas
the caller (megasas_mgmt_fw_ioctl) would have been perfectly happy
to use GFP_KERNEL.

I bet this fixes it:



diff -puN include/asm-generic/pci-dma-compat.h~a include/asm-generic/pci-dma-compat.h
--- a/include/asm-generic/pci-dma-compat.h~a
+++ a/include/asm-generic/pci-dma-compat.h
@@ -4,6 +4,7 @@
 #ifndef _ASM_GENERIC_PCI_DMA_COMPAT_H
 #define _ASM_GENERIC_PCI_DMA_COMPAT_H
 
+#include <linux/types.h>
 #include <linux/dma-mapping.h>
 
 /* note pci_set_dma_mask isn't here, since it's a public function
@@ -22,6 +23,13 @@ pci_alloc_consistent(struct pci_dev *hwd
 	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, GFP_ATOMIC);
 }
 
+static inline void *
+pci_alloc_consistent_not_stupid(struct pci_dev *hwdev, size_t size,
+		     dma_addr_t *dma_handle, gfp_t flags)
+{
+	return dma_alloc_coherent(hwdev == NULL ? NULL : &hwdev->dev, size, dma_handle, flags);
+}
+
 static inline void
 pci_free_consistent(struct pci_dev *hwdev, size_t size,
 		    void *vaddr, dma_addr_t dma_handle)
diff -puN drivers/scsi/megaraid/megaraid_sas.c~a drivers/scsi/megaraid/megaraid_sas.c
--- a/drivers/scsi/megaraid/megaraid_sas.c~a
+++ a/drivers/scsi/megaraid/megaraid_sas.c
@@ -2655,9 +2655,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		kbuff_arr[i] = pci_alloc_consistent_not_stupid(instance->pdev,
 						    ioc->sgl[i].iov_len,
-						    &buf_handle);
+						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
 			printk(KERN_DEBUG "megasas: Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
@@ -2684,8 +2684,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	if (ioc->sense_len) {
-		sense = pci_alloc_consistent(instance->pdev, ioc->sense_len,
-					     &sense_handle);
+		sense = pci_alloc_consistent_nopt_stupid(instance->pdev,
+					ioc->sense_len, &sense_handle,
+					GFP_KERNEL);
 		if (!sense) {
 			error = -ENOMEM;
 			goto out;
_

