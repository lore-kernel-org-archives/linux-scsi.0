From: Sumant Patro <sumantp@lsil.com>
Subject: [PATCH 4/6] scsi: megaraid_sas - replace pci_alloc_consitent with
	dma_alloc_coherent in ioctl path
Date: Wed, 14 Feb 2007 12:55:45 -0800
Message-ID: <1171486545.4188.27.camel@dumbo>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48727 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964822AbXBOCFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Feb 2007 21:05:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, akpm@osdl.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, neela.kolli@lsi.com, bo.yang@lsi.com, sumant.patro@lsi.com


Replaced pci_alloc_consistent with dma_alloc_coherent from the ioctl path.
This is to avoid situations where ioctl fails for lack of memory 
(when system under heavy stress).

Signed-off-by: Sumant Patro <sumant.patro@lsi.com>
---

 drivers/scsi/megaraid/megaraid_sas.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -uprN linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.c linux-feb13-new-p4/drivers/scsi/megaraid/megaraid_sas.c
--- linux-feb13-new-p3/drivers/scsi/megaraid/megaraid_sas.c	2007-02-13 11:45:38.000000000 -0800
+++ linux-feb13-new-p4/drivers/scsi/megaraid/megaraid_sas.c	2007-02-14 04:34:31.000000000 -0800
@@ -2738,9 +2738,9 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	 * For each user buffer, create a mirror buffer and copy in
 	 */
 	for (i = 0; i < ioc->sge_count; i++) {
-		kbuff_arr[i] = pci_alloc_consistent(instance->pdev,
+		kbuff_arr[i] = dma_alloc_coherent(&instance->pdev->dev,
 						    ioc->sgl[i].iov_len,
-						    &buf_handle);
+						    &buf_handle, GFP_KERNEL);
 		if (!kbuff_arr[i]) {
 			printk(KERN_DEBUG "megasas: Failed to alloc "
 			       "kernel SGL buffer for IOCTL \n");
@@ -2767,8 +2767,8 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 	}
 
 	if (ioc->sense_len) {
-		sense = pci_alloc_consistent(instance->pdev, ioc->sense_len,
-					     &sense_handle);
+		sense = dma_alloc_coherent(&instance->pdev->dev, ioc->sense_len,
+					     &sense_handle, GFP_KERNEL);
 		if (!sense) {
 			error = -ENOMEM;
 			goto out;
@@ -2827,12 +2827,12 @@ megasas_mgmt_fw_ioctl(struct megasas_ins
 
       out:
 	if (sense) {
-		pci_free_consistent(instance->pdev, ioc->sense_len,
+		dma_free_coherent(&instance->pdev->dev, ioc->sense_len,
 				    sense, sense_handle);
 	}
 
 	for (i = 0; i < ioc->sge_count && kbuff_arr[i]; i++) {
-		pci_free_consistent(instance->pdev,
+		dma_free_coherent(&instance->pdev->dev,
 				    kern_sge32[i].length,
 				    kbuff_arr[i], kern_sge32[i].phys_addr);
 	}



