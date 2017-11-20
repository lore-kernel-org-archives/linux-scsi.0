From: Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v15 4/5] scsi: mpt3sas: Replace PCI pool old API
Date: Mon, 20 Nov 2017 20:32:46 +0100
Message-ID: <20171120193247.8187-5-romain.perier@gmail.com>
References: <20171120193247.8187-1-romain.perier@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:42227 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdKTTdL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2017 14:33:11 -0500
In-Reply-To: <20171120193247.8187-1-romain.perier@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>, Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Aviad Krawczyk <aviad.krawczyk@huawei.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Cc: dmaengine@vger.kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Romain Perier <romain.perier@gmail.com>

The PCI pool API is deprecated. This commit replaces the PCI pool old
API by the appropriate function with the DMA pool API.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 8027de465d47..08237b8659ae 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3790,12 +3790,12 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	if (ioc->pcie_sgl_dma_pool) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			if (ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl)
-				pci_pool_free(ioc->pcie_sgl_dma_pool,
+				dma_pool_free(ioc->pcie_sgl_dma_pool,
 				ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl,
 				ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl_dma);
 		}
 		if (ioc->pcie_sgl_dma_pool)
-			pci_pool_destroy(ioc->pcie_sgl_dma_pool);
+			dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
 
 	if (ioc->config_page) {
@@ -4204,21 +4204,21 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 
 		sz = nvme_blocks_needed * ioc->page_size;
 		ioc->pcie_sgl_dma_pool =
-			pci_pool_create("PCIe SGL pool", ioc->pdev, sz, 16, 0);
+			dma_pool_create("PCIe SGL pool", &ioc->pdev->dev, sz, 16, 0);
 		if (!ioc->pcie_sgl_dma_pool) {
 			pr_info(MPT3SAS_FMT
-			    "PCIe SGL pool: pci_pool_create failed\n",
+			    "PCIe SGL pool: dma_pool_create failed\n",
 			    ioc->name);
 			goto out;
 		}
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl =
-					pci_pool_alloc(ioc->pcie_sgl_dma_pool,
+					dma_pool_alloc(ioc->pcie_sgl_dma_pool,
 					GFP_KERNEL,
 				&ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl_dma);
 			if (!ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl) {
 				pr_info(MPT3SAS_FMT
-				    "PCIe SGL pool: pci_pool_alloc failed\n",
+				    "PCIe SGL pool: dma_pool_alloc failed\n",
 				    ioc->name);
 				goto out;
 			}
-- 
2.14.1
