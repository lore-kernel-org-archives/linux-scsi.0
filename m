From: Chaitra P B <chaitra.basappa@broadcom.com>
Subject: [PATCH 05/15] mpt3sas: Optimize I/O memory consumption in driver.
Date: Fri, 30 Mar 2018 15:07:14 +0530
Message-ID: <1522402644-3016-6-git-send-email-chaitra.basappa@broadcom.com>
References: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1522402644-3016-1-git-send-email-chaitra.basappa@broadcom.com>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, stable@vger.kernel.org
Cc: suganath-prabu.subramani@broadcom.com, Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Chaitra P B <chaitra.basappa@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

For every IO, memory of PAGE size is allocated for handling NVMe native
PRPS. And in addition to that for every IO (chains need per IO * chain
buffer size, e.g. 38 * 128byte) amount of memory is allocated for chain
buffers.

However, at any point of time; the IO request can be for NVMe target device
(where PRP's page is used for framing PRP's) or can be for SCSI target
device (where chain buffers are used for framing chain SGE's). This patch
modifies the driver to reuse same pre-allocated PRP page buffers as a chain
buffer for IO's targeted for SCSI target devices. No need to allocate
separate buffers for chain SGE's buffers.

Suppose if the number of chain buffers need for IO doesn't fit in the PRP
Page size then driver maintain's separate buffers for those extra chain
buffers that exceeds the PRP page size. For example consider PRP page size
as 4K and chain buffer size as 128 bytes, then number of chain buffers that
can fit in PRP page is 4096/128 => 32. if the number of chain buffer need
per IO exceeds 32; for example consider number of chains need per IO is 36
then for remaining 4 chain buffer's driver allocates them individual.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 80 +++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1e8e399..701e1e7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4188,7 +4188,8 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	kfree(ioc->internal_lookup);
 	if (ioc->chain_lookup) {
 		for (i = 0; i < ioc->scsiio_depth; i++) {
-			for (j = 0; j < ioc->chains_needed_per_io; j++) {
+			for (j = ioc->chains_per_prp_buffer;
+			    j < ioc->chains_needed_per_io; j++) {
 				ct = &ioc->chain_lookup[i].chains_per_smid[j];
 				if (ct && ct->chain_buffer)
 					dma_pool_free(ioc->chain_dma_pool,
@@ -4506,7 +4507,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	ioc->chain_lookup = kzalloc(sz, GFP_KERNEL);
 	if (!ioc->chain_lookup) {
 		pr_err(MPT3SAS_FMT "chain_lookup: __get_free_pages "
-		"failed\n", ioc->name);
+				"failed\n", ioc->name);
 		goto out;
 	}
 
@@ -4520,33 +4521,6 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 	}
 
-	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
-	    ioc->chain_segment_sz, 16, 0);
-	if (!ioc->chain_dma_pool) {
-		pr_err(MPT3SAS_FMT "chain_dma_pool: dma_pool_create failed\n",
-			ioc->name);
-		goto out;
-	}
-	for (i = 0; i < ioc->scsiio_depth; i++) {
-		for (j = 0; j < ioc->chains_needed_per_io; j++) {
-			ct = &ioc->chain_lookup[i].chains_per_smid[j];
-			ct->chain_buffer = dma_pool_alloc(
-		    ioc->chain_dma_pool , GFP_KERNEL,
-		    &ct->chain_buffer_dma);
-			if (!ct->chain_buffer) {
-				pr_err(MPT3SAS_FMT "chain_lookup: "
-				" pci_pool_alloc failed\n", ioc->name);
-				goto out;
-			}
-		}
-		total_sz += ioc->chain_segment_sz;
-	}
-
-	dinitprintk(ioc, pr_info(MPT3SAS_FMT
-		"chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
-		ioc->name, ioc->chain_depth, ioc->chain_segment_sz,
-		((ioc->chain_depth *  ioc->chain_segment_sz))/1024));
-
 	/* initialize hi-priority queue smid's */
 	ioc->hpr_lookup = kcalloc(ioc->hi_priority_depth,
 	    sizeof(struct request_tracker), GFP_KERNEL);
@@ -4587,6 +4561,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	 * be required for NVMe PRP's, only each set of NVMe blocks will be
 	 * contiguous, so a new set is allocated for each possible I/O.
 	 */
+	ioc->chains_per_prp_buffer = 0;
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_NVME_DEVICES) {
 		nvme_blocks_needed =
 			(ioc->shost->sg_tablesize * NVME_PRP_SIZE) - 1;
@@ -4609,6 +4584,11 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 			    ioc->name);
 			goto out;
 		}
+
+		ioc->chains_per_prp_buffer = sz/ioc->chain_segment_sz;
+		ioc->chains_per_prp_buffer = min(ioc->chains_per_prp_buffer,
+						ioc->chains_needed_per_io);
+
 		for (i = 0; i < ioc->scsiio_depth; i++) {
 			ioc->pcie_sg_lookup[i].pcie_sgl = dma_pool_alloc(
 				ioc->pcie_sgl_dma_pool, GFP_KERNEL,
@@ -4619,13 +4599,55 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 				    ioc->name);
 				goto out;
 			}
+			for (j = 0; j < ioc->chains_per_prp_buffer; j++) {
+				ct = &ioc->chain_lookup[i].chains_per_smid[j];
+				ct->chain_buffer =
+				    ioc->pcie_sg_lookup[i].pcie_sgl +
+				    (j * ioc->chain_segment_sz);
+				ct->chain_buffer_dma =
+				    ioc->pcie_sg_lookup[i].pcie_sgl_dma +
+				    (j * ioc->chain_segment_sz);
+			}
 		}
 
 		dinitprintk(ioc, pr_info(MPT3SAS_FMT "PCIe sgl pool depth(%d), "
 			"element_size(%d), pool_size(%d kB)\n", ioc->name,
 			ioc->scsiio_depth, sz, (sz * ioc->scsiio_depth)/1024));
+		dinitprintk(ioc, pr_info(MPT3SAS_FMT "Number of chains can "
+		    "fit in a PRP page(%d)\n", ioc->name,
+		    ioc->chains_per_prp_buffer));
 		total_sz += sz * ioc->scsiio_depth;
 	}
+
+	ioc->chain_dma_pool = dma_pool_create("chain pool", &ioc->pdev->dev,
+	    ioc->chain_segment_sz, 16, 0);
+	if (!ioc->chain_dma_pool) {
+		pr_err(MPT3SAS_FMT "chain_dma_pool: dma_pool_create failed\n",
+			ioc->name);
+		goto out;
+	}
+	for (i = 0; i < ioc->scsiio_depth; i++) {
+		for (j = ioc->chains_per_prp_buffer;
+				j < ioc->chains_needed_per_io; j++) {
+			ct = &ioc->chain_lookup[i].chains_per_smid[j];
+			ct->chain_buffer = dma_pool_alloc(
+					ioc->chain_dma_pool, GFP_KERNEL,
+					&ct->chain_buffer_dma);
+			if (!ct->chain_buffer) {
+				pr_err(MPT3SAS_FMT "chain_lookup: "
+				" pci_pool_alloc failed\n", ioc->name);
+				_base_release_memory_pools(ioc);
+				goto out;
+			}
+		}
+		total_sz += ioc->chain_segment_sz;
+	}
+
+	dinitprintk(ioc, pr_info(MPT3SAS_FMT
+		"chain pool depth(%d), frame_size(%d), pool_size(%d kB)\n",
+		ioc->name, ioc->chain_depth, ioc->chain_segment_sz,
+		((ioc->chain_depth *  ioc->chain_segment_sz))/1024));
+
 	/* sense buffers, 4 byte align */
 	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
 	ioc->sense_dma_pool = dma_pool_create("sense pool", &ioc->pdev->dev, sz,
-- 
1.8.3.1
