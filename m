From: Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH 1/2] drivers: scsi: mpt2sas: Added pci_dma_mapping_error() call
Date: Sun, 18 Jan 2015 12:11:02 +0530
Message-ID: <c92368564a0942d4baddaed49641a595762d35af.1421489699.git.tinajohnson.1234@gmail.com>
References: <cover.1421489699.git.tinajohnson.1234@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41140 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508AbbARGnN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Jan 2015 01:43:13 -0500
In-Reply-To: <cover.1421489699.git.tinajohnson.1234@gmail.com>
In-Reply-To: <cover.1421489699.git.tinajohnson.1234@gmail.com>
References: <cover.1421489699.git.tinajohnson.1234@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, julia.lawall@lip6.fr, abhijit.mahajan@avagotech.com, nagalakshmi.nandigama@avagotech.com, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tina Johnson <tinajohnson.1234@gmail.com>

Replaced null test on dma handle with  pci_dma_mapping_error()
o check for mapping errors. Coccinelle was used to find cases
that do not check for dma mapping errors:

@rule1@
statement S;
identifier x;
@@

*x = pci_map_single(...);
  if (!x) S

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/scsi/mpt2sas/mpt2sas_transport.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index e689bf2..b283140 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1962,7 +1962,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	} else {
 		dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
 		    blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-		if (!dma_addr_out) {
+		if (pci_dma_mapping_error(ioc->pdev, dma_addr_out)) {
 			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr out = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
@@ -1984,7 +1984,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	} else {
 		dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
 		    blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
-		if (!dma_addr_in) {
+		if (pci_dma_mapping_error(ioc->pdev, dma_addr_in)) {
 			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr in = NULL\n",
 			    ioc->name, __func__);
 			rc = -ENOMEM;
-- 
1.7.10.4

