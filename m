From: Tina Johnson <tinajohnson.1234@gmail.com>
Subject: [PATCH] drivers: message: Clean up error handling for calls to pci_map_single
Date: Wed, 14 Jan 2015 00:16:02 +0530
Message-ID: <1421174763-8802-1-git-send-email-tinajohnson.1234@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: nagalakshmi.nandigama@avagotech.com
Cc: praveen.krishnamoorthy@avagotech.com, sreekanth.reddy@avagotech.com, abhijit.mahajan@avagotech.com, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr, Tina Johnson <tinajohnson.1234@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Replaced null tests on the value return by pci_map_single by calls to
pci_dma_mapping_error.

Added initialization of the ret variable, to return an error code on
failure.

Reorganized error handling code to remove the need for tests on
dma_addr_out, dma_addr_in, and mf.

Added new error labels for freeing dma_addr_out (unmap_out) and
dma_addr_in (unmap_in).

Coccinelle was used to find unchecked dma handles, as follows:

@rule1@
expression e1;
identifier x;
@@

*x = pci_map_single(...);
 ... when != pci_dma_mapping_error(e1,x)

Signed-off-by: Tina Johnson <tinajohnson.1234@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/message/fusion/mptsas.c |   30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5bdaae1..bac6bec 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2282,8 +2282,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
 				      blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_out)
+	if (pci_dma_mapping_error(ioc->pcidev, dma_addr_out)) {
+		ret = -ENOMEM;
 		goto put_mf;
+	}
 	ioc->add_sge(psge, flagsLength, dma_addr_out);
 	psge += ioc->SGE_size;
 
@@ -2297,8 +2299,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	flagsLength |= blk_rq_bytes(rsp) + 4;
 	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
 				      blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_in)
-		goto unmap;
+	if (pci_dma_mapping_error(ioc->pcidev, dma_addr_in)) {
+		ret = -ENOMEM;
+		goto unmap_out;
+	}
 	ioc->add_sge(psge, flagsLength, dma_addr_in);
 
 	INITIALIZE_MGMT_STATUS(ioc->sas_mgmt.status)
@@ -2310,10 +2314,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		mpt_free_msg_frame(ioc, mf);
 		mf = NULL;
 		if (ioc->sas_mgmt.status & MPT_MGMT_STATUS_DID_IOCRESET)
-			goto unmap;
+			goto unmap_in;
 		if (!timeleft)
 			mpt_Soft_Hard_ResetHandler(ioc, CAN_SLEEP);
-		goto unmap;
+		goto unmap_in;
 	}
 	mf = NULL;
 
@@ -2331,16 +2335,14 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    ioc->name, __func__);
 		ret = -ENXIO;
 	}
-unmap:
-	if (dma_addr_out)
-		pci_unmap_single(ioc->pcidev, dma_addr_out, blk_rq_bytes(req),
-				 PCI_DMA_BIDIRECTIONAL);
-	if (dma_addr_in)
-		pci_unmap_single(ioc->pcidev, dma_addr_in, blk_rq_bytes(rsp),
-				 PCI_DMA_BIDIRECTIONAL);
+unmap_in:
+	pci_unmap_single(ioc->pcidev, dma_addr_in, blk_rq_bytes(rsp),
+			 PCI_DMA_BIDIRECTIONAL);
+unmap_out:
+	pci_unmap_single(ioc->pcidev, dma_addr_out, blk_rq_bytes(req),
+			 PCI_DMA_BIDIRECTIONAL);
 put_mf:
-	if (mf)
-		mpt_free_msg_frame(ioc, mf);
+	mpt_free_msg_frame(ioc, mf);
 out_unlock:
 	CLEAR_MGMT_STATUS(ioc->sas_mgmt.status)
 	mutex_unlock(&ioc->sas_mgmt.mutex);
-- 
1.7.10.4
